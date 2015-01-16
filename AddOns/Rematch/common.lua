
--[[ functions used by more than one module ]]

local _,L = ...
local rematch = Rematch
local settings

rematch.info = {} -- reusable table to reduce garbage creation
rematch.abilityList = {} -- reusable table for C_PetJournal.GetPetAbilityList
rematch.levelList = {} -- reusable table for C_PetJournal.GetPetAbilityList
rematch.emptyPetID = "0x0000000000000000" -- petID to load for an empty slot

BINDING_HEADER_REMATCH = "Rematch"
BINDING_NAME_REMATCH_WINDOW = L["Toggle Window"]
BINDING_NAME_REMATCH_AUTOLOAD = L["Toggle Auto Load"]
BINDING_NAME_REMATCH_PETS = L["Toggle Pets"]
BINDING_NAME_REMATCH_TEAMS = L["Toggle Teams"]

function rematch:InitCommon()
	RematchSettings = RematchSettings or {}
	settings = RematchSettings
	settings.LevelingQueue = settings.LevelingQueue or {}
	RematchSaved = RematchSaved or {}

	rematch.breedSource = rematch:FindBreedSource() -- go find a source for breed info

	hooksecurefunc(C_PetJournal,"PickupPet",rematch.events.CURSOR_UPDATE)
	rematch:RegisterEvent("PET_JOURNAL_LIST_UPDATE")

	rematch:RegisterEvent("PLAYER_TARGET_CHANGED")
	rematch:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	rematch:RegisterEvent("PLAYER_REGEN_ENABLED")
	rematch:RegisterEvent("PLAYER_REGEN_DISABLED")
	rematch:RegisterEvent("PET_BATTLE_OPENING_START")
	rematch:RegisterEvent("PET_BATTLE_CLOSE")
	rematch:RegisterEvent("PLAYER_LOGOUT")

	rematch:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
	rematch.events:PET_BATTLE_QUEUE_STATUS()

	-- 3.0.11 preparation for WoD
	if not settings.WoDReady then
		-- this function converts a MoP (or early WoD beta) petID to the new petID format
		for teamName,team in pairs(RematchSaved) do
			for i=1,3 do
				team[i][1] = rematch:ConvertPetID(team[i][1])
			end
		end
		for i=1,#settings.LevelingQueue do
			settings.LevelingQueue[i] = rematch:ConvertPetID(settings.LevelingQueue[i])
		end
		settings.WoDReady = true
	end

	-- 3.0.0 giving binds proper binding globals
	local bindsMoved
	for oldBind,newBind in pairs({["Toggle Rematch Window"]="WINDOW", ["Toggle Auto Load"]="AUTOLOAD", ["Toggle Pet Browser"]="PETS"}) do
		local key = GetBindingKey(oldBind)
		if key then
			SetBinding(key,"REMATCH_"..newBind)
			bindsMoved = true
		end
	end
	if bindsMoved then
		SaveBindings(GetCurrentBindingSet())
	end

	-- 3.2.0 settings.CurrentLevelingPet depreciated; move its petID to top of LevelingQueue
	if settings.CurrentLevelingPet then
		local petID = settings.CurrentLevelingPet
		local queue = settings.LevelingQueue
		for i=#queue,1,-1 do
			if queue[i]==petID then
				tremove(queue,i) -- remove from its position in the queue
			end
		end
		tinsert(queue,1,petID)
		settings.CurrentLevelingPet = nil
	end

end

function rematch:ConvertPetID(petID)
	if not petID or type(petID)~="string" or petID==rematch.emptyPetID then
		return petID
	end
	if petID:match("^0x") then -- if MoP petID (0x00etc)
		petID = format("BattlePet-0-%s",petID:match("0x0000(%x+)")) -- convert to BattlePet-0-00etc
	end
	petID = petID:gsub(":","%-") -- for earlier beta builds to 18888 (BattlePet:0:00etc to BattlePet-0-00etc)
	return petID
end

--[[ Events ]]

rematch.events = {}
function rematch:OnEvent(event,...)
	if rematch.events[event] then
		rematch.events[event](...)
	end
end

function rematch.events.PLAYER_LOGIN()
	rematch:InitCommon()
	rematch:InitMain()
	rematch:InitCurrent()
	rematch:InitOptions()
	rematch:InitBrowser()
	rematch:InitLeveling()
	rematch:InitMenu()
	rematch:InitRMF()
	rematch:InitDialog()
	rematch:InitTeams()
	rematch:InitSaveAs()
	rematch:InitPetLoading()
	rematch:InitNotes()
	if settings.ResetFilters or not pcall(rematch.roster.LoadFilters,rematch,settings.loginFilters) then
		rematch.roster:ClearAllFilters()
	end
end

function rematch.events.PLAYER_LOGOUT()
	settings.loginFilters = {} -- save filters to loginFilters for next login
	rematch.roster:SaveFilters(settings.loginFilters)
	rematch:SanctuarySave() -- save petIDs (and stats) of owned pets in teams and queue
end

function rematch.events.PET_JOURNAL_LIST_UPDATE()
	local _,owned = C_PetJournal.GetNumPets()
	if owned and owned>0 and owned~=rematch.lastOwned then -- if number of owned pets changed
		rematch:UpdateOwnedPets()
		if not rematch.lastOwned then -- this is first time pets are valid on login
			rematch:CheckForChangedPetIDs()
		end
		rematch:ProcessQueue() -- process the queue
		rematch.lastOwned = owned
	end
	rematch:StartTimer("UpdateWindow",0,rematch.UpdateWindow)
end

function rematch.events.PLAYER_REGEN_DISABLED()
	if rematch:IsVisible() then
		rematch.resummonWindow = true
		rematch:Toggle()
	end
	rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
	rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function rematch.events.PLAYER_REGEN_ENABLED()
	if rematch.resummonWindow  then
		rematch:Show()
		rematch.resummonWindow = nil
	end
	if C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo() then
		return -- in pet battle or pvp, come back when those are done
	end
	-- at this point the player is neither in combat, battle or pvp
	if rematch.queueNeedsProcessed then
		rematch:ProcessQueue()
		rematch.queueNeedsProcessed = nil
	end
	if rematch.teamNeedsLoaded then
		rematch:LoadTeam(rematch.teamNeedsLoaded)
		rematch.teamNeedsLoaded = nil
	end
	rematch:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	rematch:RegisterEvent("PLAYER_TARGET_CHANGED")
	rematch.events.PLAYER_TARGET_CHANGED()
	rematch.events.UPDATE_MOUSEOVER_UNIT()
end

function rematch.events.PET_BATTLE_OPENING_START()
	if settings.ShowNotesInBattle and settings.loadedTeamName and RematchSaved[settings.loadedTeamName] and RematchSaved[settings.loadedTeamName][6] then
		rematch:ShowNotesCard(settings.loadedTeamName,true)
	end
	if not settings.StayForBattle then
		rematch.resummonWindow = rematch:IsVisible()
		rematch:Hide()
	end
	rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
	rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	rematch.queueNeedsProcessed = true
end

-- PET_BATTLE_CLOSE fires twice after a pet battle ends
-- the first time C_PetBattles.IsInBattle() is true, the second time false
-- however if a pet needs to be swapped the server sends a message that a battle is in progress
-- so post-battle processing is delayed 0.5 seconds after the second PET_BATTLE_CLOSE
function rematch.events.PET_BATTLE_CLOSE()
	if not C_PetBattles.IsInBattle() then
		C_Timer.After(0.5,rematch.PostBattleProcessing)
	end
end

function rematch:PostBattleProcessing()
	if settings.ShowNotesInBattle then
		RematchNotesCard:Hide()
	end
	rematch.events.PLAYER_REGEN_ENABLED() -- rest of end-of-fight handling identical to leaving combat
end

function rematch.events.PET_BATTLE_QUEUE_STATUS()
	if rematch:UpdatePVPStatus() then
		rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
		rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		C_Timer.After(0.5,rematch.events.PLAYER_REGEN_ENABLED)
	end
end

function rematch:UpdatePVPStatus()
	local button = rematch.toolbar.buttons[4]
	local oldIcon = button.icon:GetTexture()
	local queued = C_PetBattles.GetPVPMatchmakingInfo()
	button.tooltipTitle = queued and LEAVE_QUEUE or FIND_BATTLE
	button.icon:SetTexture(queued and "Interface\\Icons\\PetBattle_Attack-Down" or "Interface\\Icons\\PetBattle_Attack")
	if oldIcon~="Interface\\Icons\\INV_Misc_QuestionMark" and oldIcon~=button.icon:GetTexture() then
		rematch:ShineOnYouCrazy(button,"CENTER")
	end
	return queued
end

--[[ Pet template script handlers ]]

function rematch:PetOnEnter()
	rematch:ShowFloatingPetCard(self.petID,self,self.menu=="browserPet")
end

function rematch:PetOnLeave()
	rematch:HideFloatingPetCard()
end

function rematch:PetOnClick(button)
	local cursorPetID = rematch:GetCursorPetID()
	if cursorPetID then -- if pet on the cursor
		if button=="RightButton" then
			RematchTooltip:Hide()
			ClearCursor()
			return
		end
		local receive = self:GetScript("OnReceiveDrag")
		if receive then -- any slot that expects to receive pets, run its function and leave
			return receive(self)
		end
	end
	local petID = self.petID
	-- send to chat if Shift+Clicked (or whatever CHATLINK modifier they use)
	if IsModifiedClick("CHATLINK") and type(petID)=="string" then
		return ChatEdit_InsertLink(C_PetJournal.GetBattlePetLink(petID))
	end
	if button=="RightButton" then
		if self.menu then
			rematch:SetMenuSubject(petID,self:GetID())
			rematch:ShowMenu(self.menu,"cursor")
		end
	elseif petID then
		local cardID = RematchFloatingPetCard.petID
		rematch:LockFloatingPetCard()
		if petID ~= cardID then
			rematch:ShowFloatingPetCard(petID,self)
			rematch:LockFloatingPetCard() -- lock it again
		end
	end
end

function rematch:PetOnDoubleClick()
	local petID = self.petID
	if type(petID)=="string" then
		C_PetJournal.SummonPetByGUID(petID)
	end
	rematch:HideFloatingPetCard(true)
end

function rematch:PetOnDragStart()
	if type(self.petID)=="string" then
		C_PetJournal.PickupPet(self.petID)
	end
end

function rematch:AbilityOnEnter()
	local petID = self:GetParent().petID
	if petID and self.abilityID then
		rematch.ShowAbilityCard(self,petID,self.abilityID)
	end
end

function rematch:AbilityOnClick()
	if IsModifiedClick("CHATLINK") and self.abilityID and self:GetParent().petID then
		rematch:ChatLinkAbility(self:GetParent().petID,self.abilityID)
	end
end

--[[ ListTemplate script handlers ]]

function rematch:ListScrollToTop(frame)
	(frame or self:GetParent()).scrollBar:SetValue(0)
	PlaySound("UChatScrollButton")
end

function rematch:ListScrollToBottom(frame)
	local scrollFrame = frame or self:GetParent()
	scrollFrame.scrollBar:SetValue(scrollFrame.range)
	PlaySound("UChatScrollButton")
end

function rematch:ListScrollToIndex(frame,index)
	if index then
		local scrollFrame = frame or self:GetParent()
		if scrollFrame.scrollBar:IsEnabled() then
			local buttons = scrollFrame.buttons
			local height = math.max(0,floor(scrollFrame.buttonHeight*(index-((scrollFrame:GetHeight()/scrollFrame.buttonHeight))/2)))
			HybridScrollFrame_SetOffset(scrollFrame,height)
			scrollFrame.scrollBar:SetValue(height)
		else
			rematch:ListScrollToTop(frame)
		end
	end
end

-- used in scrollBar's OnValueChanged hooked in during the OnLoad
-- when scrolling with the mousewheel, force an OnEnter of whatever is under mouse
function rematch:ReOnEnter()
	local focus = GetMouseFocus()
	local scrollFrame = self:GetParent()
	for i=1,#scrollFrame.buttons do
		if scrollFrame.buttons[i]==focus then
			local script = focus:GetScript("OnEnter")
			if script then
				script(focus) -- if there's an OnEnter script, use it for focus
			end
			return
		end
	end
end

function rematch:ListOnLoad()
	-- tweak scrollBar appearance
	local scrollBar = self.scrollFrame.scrollBar
	scrollBar.doNotHide = true
	scrollBar.trackBG:SetPoint("TOPLEFT",-2,25)
	scrollBar.trackBG:SetPoint("BOTTOMRIGHT",2,-25)
	scrollBar.trackBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	scrollBar.trackBG:SetGradientAlpha("HORIZONTAL",.125,.125,.125,1,.05,.05,.05,1)
	scrollBar:HookScript("OnValueChanged",rematch.ReOnEnter)
end

function rematch:ListOnSizeChanged()
	-- stepSize moved to the update functions
	rematch:StartTimer(self.scrollFrame:GetName(),0.1,self.scrollFrame.update)
end


--[[ Other template script handlers ]]

-- when a button is resized or released from being pushed, reset its icon to normal
function rematch:ResizeSlotIcon()
	local inset = ceil(self:GetWidth()/12)
	self.icon:SetPoint("TOPLEFT",inset,-inset)
	self.icon:SetPoint("BOTTOMRIGHT",-inset-1,inset+1)
	self.icon:SetVertexColor(1,1,1)
end

function rematch:PushToolbarButton()
	if self:IsEnabled() then
		self.icon:SetSize(18,18)
		local vertex = self.vertex and self.vertex*0.65 or 0.65
		self.icon:SetVertexColor(vertex,vertex,vertex)
	end
end

function rematch:ReleaseToolbarButton()
	self.icon:SetSize(20,20)
	local vertex = self.vertex or 1
	self.icon:SetVertexColor(vertex,vertex,vertex)
end

function rematch:ToolbarButtonOnEnter()
	if self.tooltipTitle then
		rematch:ShowTooltip(self.tooltipTitle,self.tooltipBody)
		RematchTooltip:ClearAllPoints()
		RematchTooltip:SetPoint("BOTTOM",self,"TOP",0,-2)
	end
end

function rematch:SetToolbarButtonEnabled(button,enable)
	button:SetEnabled(enable)
	button.icon:SetDesaturated(not enable)
end

function rematch:ScrollFrameToTop(scrollFrame)
	scrollFrame.scrollBar:SetValue(0)
end

function rematch:ScrollFrameToBottom(scrollFrame)
	scrollFrame.scrollBar:SetValue(scrollFrame.range)
end

--[[ Pet frames ]]

function rematch:WipePetFrames(pets)
	for i=1,3 do
		pets[i].petID = nil
		pets[i].icon:Hide()
		pets[i].dead:Hide()
		pets[i].leveling:Hide()
		pets[i].leveling:SetDesaturated(false)
		pets[i].leveling:SetVertexColor(1,1,1)
		pets[i].level:Hide()
		pets[i].levelBG:Hide()
		pets[i].border:Hide()
		for j=1,3 do
			pets[i].abilities[j].abilityID = nil
			pets[i].abilities[j].icon:Hide()
			if pets[i].abilities[j].level then
				pets[i].abilities[j].level:Hide()
			end
		end
	end
	for i=4,9 do
		pets[i] = nil
	end
	pets.teamName = nil
end

--[[ Timer Management ]]

rematch.timerFuncs = {} -- indexed by arbitrary name, the func to run when timer runs out
rematch.timerTimes = {} -- indexed by arbitrary name, the duration to run the timer
rematch.timerFrame = CreateFrame("Frame") -- timer independent of main frame visibility
rematch.timerFrame:Hide()
rematch.timersRunning = {} -- indexed numerically, timers that are running

function rematch:StartTimer(name,duration,func)
	local timers = rematch.timersRunning
	rematch.timerFuncs[name] = func
	rematch.timerTimes[name] = duration
	if not tContains(timers,name) then
		tinsert(timers,name)
	end
	rematch.timerFrame:Show()
end

function rematch:StopTimer(name)
	local timers = rematch.timersRunning
	for i=#timers,1,-1 do
		if timers[i]==name then
			tremove(timers,i)
			return
		end
	end
end

rematch.timerFrame:SetScript("OnUpdate",function(self,elapsed)
	local tick
	local times = rematch.timerTimes
	local timers = rematch.timersRunning

	for i=#timers,1,-1 do
		local name = timers[i]
		times[name] = times[name] - elapsed
		if times[name] < 0 then
			tremove(timers,i)
			if rematch.timerFuncs[name] then
				rematch.timerFuncs[name]()
			else
				rematch:print(name,"doesn't have a function")
			end
		end
		tick = true
	end

	if not tick then
		self:Hide()
	end
end)

--[[ Tooltips ]]

-- anchors frame to relativeTo depending on where relativeTo is on the screen, based on
-- the center of the reference frame (rematch frame itself if no reference given)
-- specifically, frame will be anchored to the corner furthest from the edge of the screen
function rematch:SmartAnchor(frame,relativeTo,reference)
	reference = reference or rematch
	local referenceScale = reference:GetEffectiveScale()
	local UIParentScale = UIParent:GetEffectiveScale()
	local isLeft = (reference:GetRight()*referenceScale+reference:GetLeft()*referenceScale)/2 < (UIParent:GetWidth()*UIParentScale)/2
	local isBottom = (reference:GetTop()*referenceScale+reference:GetBottom()*referenceScale)/2 < (UIParent:GetHeight()*UIParentScale)/2
	if isLeft then
		anchorPoint = isBottom and "BOTTOMLEFT" or "TOPLEFT"
		relativePoint = isBottom and "TOPRIGHT" or "BOTTOMRIGHT"
	else
		anchorPoint = isBottom and "BOTTOMRIGHT" or "TOPRIGHT"
		relativePoint = isBottom and "TOPLEFT" or "BOTTOMLEFT"
	end
	frame:ClearAllPoints()
	frame:SetPoint(anchorPoint,relativeTo,relativePoint)
end

-- shows tooltip with title[,body] and resizes around text
-- if priority is set, show through normal HideTooltip option and float by cursor with an OnUpdate
-- if option is set, make the tooltip wider and anchor it to the parent of the mouseover
-- if no title is given, it will fetch self's .tooltipTitle and .tooltipBody
function rematch:ShowTooltip(title,body,priority,option)
	if not title then
		title = self.tooltipTitle
		body = self.tooltipBody
		priority = self.tooltipPriority
	end
	if title and not settings.HideTooltips or (priority and not settings.HideWarnings) or (option and not settings.HideOptionTooltips) then
		local tooltip = RematchTooltip
		tooltip.title:SetText(title)
		tooltip.body:SetText(body)
		local titleWidth=tooltip.title:GetStringWidth()
		local tooltipWidth

		if option then
			width = 200
		elseif not body then
			width = titleWidth -- for tooltips with just a title, make width the title width
		else
			width = max(titleWidth,164) -- otherwise make width the max of title or 164
			-- but if 164 is greater than both title and body width, shrink to max of title and body
			local bodyWidth=tooltip.body:GetStringWidth()
			if width>titleWidth and width>bodyWidth then
				width = max(titleWidth,bodyWidth)
			end
		end

		tooltip.title:SetSize(width,0)
		tooltip.body:SetSize(width,0)

		local titleHeight=tooltip.title:GetStringHeight()
		local bodyHeight=tooltip.body:GetStringHeight()
		tooltip:SetWidth( width+16 )
		tooltip:SetHeight( titleHeight+bodyHeight+16 + (body and 4 or 0) ) -- + ((body and body:len()>0 and 4) or 0) )
		tooltip:Show()
		tooltip:SetScript("OnUpdate",nil)
		if option then -- option tooltips get anchored to parent of mouseover
			rematch:SmartAnchor(tooltip,GetMouseFocus():GetParent())
		elseif priority then -- priority tooltips get an OnUpdated anchor by the cursor
			tooltip:SetScript("OnUpdate",rematch.TooltipOnUpdate)
		else -- regular tooltips are SmartAnchored
			rematch:SmartAnchor(tooltip,GetMouseFocus())
		end
	end
end

function rematch:TooltipOnUpdate(elapsed)
	local x,y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	x = x/scale
	y = y/scale
	self:ClearAllPoints()
	if x>UIParent:GetWidth()/2 then -- right half of screen
		self:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMLEFT",x-2,y+2)
	else -- left half of screen
		self:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",x+2,y+2)
	end
end

--[[ Keep Summoned ]]

-- primarilyy for KeepSummoned, call this before pets are about to change
function rematch:SummonedPetMayChange()
	if settings.KeepSummoned then
		rematch.preLoadCompanion = rematch.preLoadCompanion or C_PetJournal.GetSummonedPetGUID()
		rematch:RegisterEvent("UNIT_PET")
		rematch:StartTimer("RestoreTimeout",1,rematch.RestoreTimeout)
	end
end

function rematch.events.UNIT_PET()
	rematch:StopTimer("RestoreTimeout")
	rematch:UnregisterEvent("UNIT_PET")
	rematch:StartTimer("RestoreCompanion",1.6,rematch.RestoreCompanion) -- wait a GCD before restoring
end

function rematch:RestoreCompanion()
	if not InCombatLockdown() then -- can't SummonPetByGUID in combat :(
		local nowSummoned = C_PetJournal.GetSummonedPetGUID()
		if not rematch.preLoadCompanion and nowSummoned then
			C_PetJournal.SummonPetByGUID(nowSummoned) -- something summoned, had nothing before
		elseif nowSummoned ~= rematch.preLoadCompanion then
			C_PetJournal.SummonPetByGUID(rematch.preLoadCompanion) -- something summoned different than before
		end
		rematch.preLoadCompanion = nil
	end
end

-- if no UNIT_PET fired, unregister it. apparently no pet was loaded
function rematch:RestoreTimeout()
	rematch.preLoadCompanion = nil
	rematch:UnregisterEvent("UNIT_PET")
end

--[[ Miscellaneous ]]

function rematch:GetCursorPetID()
	local cursorType,petID = GetCursorInfo()
	if cursorType=="battlepet" then
		return petID
	end
end

-- use this instead of a direct C_PetJournal.SetPetLoadOutInfo
function rematch:LoadPetSlot(slot,petID)
	if slot>0 and slot<4 and type(petID)=="string" then -- hilarious crash bug if we attempt to load slots other than 1-3
		rematch:SummonedPetMayChange()
		C_PetJournal.SetPetLoadOutInfo(slot,petID)
		if PetJournal then
			PetJournal_UpdatePetLoadOut() -- update petjournal if it's open
		end
	end
end

-- this makes the current pets glow when a pet is picked up onto the cursor
function rematch.events.CURSOR_UPDATE()
  local hasPet,petID = GetCursorInfo()
	hasPet = hasPet=="battlepet"
	for i=1,3 do
		rematch.current.pets[i].glow:SetShown(hasPet)
	end
	rematch.drawer.queue.levelingSlot.glow:SetShown(hasPet and rematch:PetCanLevel(petID))
	if hasPet then
		rematch:HideDialogs()
		rematch:RegisterEvent("CURSOR_UPDATE") -- this is the only place this event is registered
	else
		rematch:UnregisterEvent("CURSOR_UPDATE") -- cursor clear, stop watching cursor changes
	end
	if rematch.drawer.queue:IsVisible() then
		rematch:UpdateQueueList()
	end
end

-- for general purpose use, creates a shine cooldown effect on corner of frame
function rematch:ShineOnYouCrazy(frame,corner,xoff,yoff)
	if not rematch.shine then
		rematch.shine = CreateFrame("Frame")
		rematch.shine:SetSize(32,32)
		rematch.shine.cooldown = CreateFrame("Cooldown",nil,rematch.shine,"CooldownFrameTemplate")
		rematch.shine.cooldown:SetDrawEdge(false)
		rematch.shine.cooldown:SetDrawSwipe(false)
	end
	local shine = rematch.shine
	shine:SetParent(frame:GetObjectType()=="Frame" and frame or frame:GetParent())
	shine:SetPoint("CENTER",frame,corner,xoff,yoff)
	shine.cooldown:SetCooldownDuration(0.01)
end

-- toggle tooltip
function rematch:ToggleTooltip()
	GameTooltip:SetOwner(self, self==RematchJournalButton and "ANCHOR_RIGHT" or "ANCHOR_LEFT")
	GameTooltip:SetText("Rematch",1,1,1)
	GameTooltip:AddLine(L["Toggles the Rematch window to manage battle pets and teams."],nil,nil,nil,true)
	GameTooltip:Show()
end
function rematch:ToggleTooltipHide()
	GameTooltip:Hide()
end

function rematch:GetPetIDIcon(petID)
	local speciesID,level,icon
	if petID==0 then
		return rematch.levelingIcon
	elseif not petID or petID==rematch.emptyPetID then
		return nil
	elseif type(petID)=="string" then
		local speciesID,_,level,_,_,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(petID)
		return icon,false,level
	else
		return (select(2,C_PetJournal.GetPetInfoBySpeciesID(petID))),true
	end
end

function rematch:ChatLinkAbility(petID,abilityID)
	local maxHealth,power,speed,_ = 100,0,0
	if type(petID)=="string" and petID~=rematch.emptyPetID then
		_,maxHealth,power,speed = C_PetJournal.GetPetStats(petID)
	end
	ChatEdit_InsertLink(GetBattlePetAbilityHyperlink(abilityID,maxHealth,power,speed))
end

--[[ Search Box ]]

function rematch:SearchBoxOnEditFocusGained()
	self.searchIcon:SetVertexColor(1,1,1)
	self.clearButton:Show()
	self.Instructions:Hide()
end

function rematch:SearchBoxOnEditFocusLost()
	self.Instructions:SetShown(self:GetText() == "")
	if ( self:GetText() == "" ) then
		self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
		self.clearButton:Hide();
	end
end

function rematch:ClearSearchBox(searchBox)
	searchBox.clearButton:Click()
end

function rematch:SearchBoxOnLoad()
	self.clearButton:SetScript("OnClick",function(self)
		PlaySound("igMainMenuOptionCheckBoxOn")
		local editBox = self:GetParent()
		editBox:SetText("")
		editBox:ClearFocus()
		editBox:GetScript("OnEditFocusLost")(editBox)
	end)
end

local function literal(c)
	return "%"..c
end

local function caseinsensitive(c)
	return format("[%s%s]",c:lower(),c:upper())
end

-- returns text in a literal (magic characters escaped) and case-insensitive format
function rematch:DesensitizedText(text)
	if type(text)=="string" then
		return text:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]",literal):gsub("%a",caseinsensitive)
	end
end

-- prints the file:line that called the function
function rematch:debugstack(name)
	rematch:print(name,debugstack():match(".-%.lua:%d+.-%.lua:%d+.-\\.-\\.-\\(.-%.lua:%d+)"),GetTime())
end

function rematch:print(...)
	print("\124cffffd200Rematch:\124r",...)
end

-- returns the breed of the petID
function rematch:GetBreed(petID)
	local source = rematch.breedSource
	if source=="BattlePetBreedID" then
		return GetBreedID_Journal(petID) or ""
	elseif source=="PetTracker_Breeds" then
		return PetTracker:GetBreedIcon((PetTracker.Journal:GetBreed(petID)),.85)
	elseif source=="LibPetBreedInfo-1.0" then
		return rematch.breedLib:GetBreedName(rematch.breedLib:GetBreedByPetID(petID)) or ""
	end
	return ""
end

-- returns the addon that will provide breed data
function rematch:FindBreedSource()
	local addon
	for _,name in pairs({"BattlePetBreedID","PetTracker_Breeds","LibPetBreedInfo-1.0"}) do
		if not addon and IsAddOnLoaded(name) then
			addon = name
		end
	end
	if not addon then -- one of the sources is not loaded, try loading LibPetBreedInfo separately
		LoadAddOn("LibPetBreedInfo-1.0")
		if LibStub then
			for lib in LibStub:IterateLibraries() do
				if lib=="LibPetBreedInfo-1.0" then
					rematch.breedLib = LibStub("LibPetBreedInfo-1.0")
					addon = lib
					break
				end
			end
		end
	end
	return addon
end

-- this should be called when pets are dragged to a loadout slot
-- if the incoming pet is in the queue (but not the topmost pet in queue)
-- then turn off full sort and set it as the topmost leveling pet
function rematch:HandleReceivingLevelingPet(petID)
	if not petID then
		local slot = self:GetParent():GetID() -- grab petID from journal slot receiving pet
		if slot and slot>0 and slot<4 then
			petID = C_PetJournal.GetPetLoadOutInfo(self:GetParent():GetID())
		end
	end
	if rematch:IsPetLeveling(petID) and petID~=rematch:GetCurrentLevelingPet() then
		if settings.QueueFullSort then
			if rematch:IsVisible() then
				local dialog = rematch:ShowDialog("NoFullSort",152,L["Full Sort Was Enabled"],"",true)
				dialog.text:SetSize(196,96)
				dialog.text:SetPoint("TOP",0,-20)
				dialog.text:SetText(L["The Full Sort queue option has been turned off to allow this new pet to be the active leveling pet. You can turn Full Sort back on in the queue menu."])
				dialog.text:Show()
			end
			settings.QueueFullSort = nil
		end
		rematch:StartLevelingPet(petID)
	end
end

-- CheckForChangedPetIDs() runs on login after pets are loaded.
-- Occasionally, the server will reassign whole new petIDs to a user.
-- This uses the sanctuary system in finder.lua to get any changed petIDs.
function rematch:CheckForChangedPetIDs()
	-- validate pets in the queue
	for index,petID in ipairs(settings.LevelingQueue) do
		local newPetID = rematch:SanctuaryFind(petID)
		if newPetID then
			settings.LevelingQueue[index] = newPetID
		end
	end
	-- validate pets within teams
	for teamName,team in pairs(RematchSaved) do
		for i=1,3 do
			local newPetID = rematch:SanctuaryFind(team[i][1])
			if newPetID then
				team[i][1] = newPetID
			end
		end
	end
	rematch:SanctuaryDone()
end
