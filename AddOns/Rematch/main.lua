
local _,L = ...
local rematch = Rematch
local settings
local saved

-- these don't need declared, but they're important enough to merit early mention
-- rematch.targetName = nil -- name/npc ID of current target
-- rematch.targetNpcID = nil
-- settings.loadedTeamName = nil -- name/npc ID of last team loaded
-- settings.loadedNpcID = nil
-- rematch.inBottomHalf = nil -- whether center of main frame is in lower half of screen
-- rematch.inLeftHalf = nil -- whether center of main frame is in left half of screen

local COLLAPSED_HEIGHT = 142 -- when changing current area height change this too
local EXPANDED_HEIGHT = 450
local DEFAULT_WIDTH = 296

function rematch:InitMain()
	settings = RematchSettings
	saved = RematchSaved

	rematch.toolbar.petsTab:SetText(PETS)
	rematch.toolbar.teamsTab:SetText(L["Teams"])
	rematch:SetUserPlaced(false)
	rematch.notesButton:SetFrameLevel(rematch.header:GetFrameLevel()+3)
	rematch.notesButton:RegisterForClicks("AnyUp")

	rematch.sidebar.lessertreat:RegisterForClicks("AnyUp")
	rematch.sidebar.treat:RegisterForClicks("AnyUp")

	if not settings.X then
		rematch:SaveFramePosition()
	end
	rematch:SetFramePosition()
end

function rematch:Toggle()
	if InCombatLockdown() then
		rematch:print(L["You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"])
	else
		rematch:SetShown(not rematch:IsVisible())
		return true
	end
end

-- called from BINDING_NAME_REMATCH_AUTOLOAD
function rematch:ToggleAutoLoad()
	rematch:HideDialogs()
	settings.AutoLoad = not settings.AutoLoad and 1 or nil
	rematch:print(L["Auto Load is now"],settings.AutoLoad and L["\124cff00ff00Enabled"] or L["\124cffff0000Disabled"])
end

-- called from BINDING_NAME_REMATCH_PETS ("PETS") and BINDING_NAME_REMATCH_TEAMS ("TEAMS")
function rematch:ToggleTab(mode)
	local oldMode = settings.DrawerMode
	settings.DrawerMode = mode
	if not rematch:IsVisible() then
		if not rematch:Toggle() then
			return
		end
	elseif oldMode==settings.DrawerMode then
		rematch:Toggle()
	end
	rematch:UpdateWindow()
end

function rematch:OnShow()
	-- if options was open, close it
	if settings.DrawerMode=="OPTIONS" then
		settings.DrawerMode = settings.oldDrawerMode
		settings.oldDrawerMode = nil
	end

	rematch:UpdateWindow()

	if rematch:TeamNeedsLoading(rematch.targetName,rematch.targetNpcID) then
		rematch:ShowLoadDialog(rematch.targetName)
	end

	rematch:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")
	rematch:RegisterEvent("BAG_UPDATE")
	PlaySound("SPELLBOOKOPEN")
end

function rematch:OnHide()
	rematch:UnregisterEvent("BAG_UPDATE")
	rematch:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	rematch:HideDialogs()
	PlaySound("SPELLBOOKCLOSE")
end

function rematch:ToolbarSaveOnClick()

	if rematch.dialog.name=="SaveTeam" then
		rematch:HideDialogs() -- if we're looking at save dialog already, hide it
		return -- and leave
	end

	local team
	if rematch.targetName then -- if something targeted, use targeted name/npcID
		team = rematch:CreateTeamFromCurrent(rematch.targetName,rematch.targetNpcID)
	else -- otherwise, use loaded name/npcID if they exist
		team = rematch:CreateTeamFromCurrent()
	end

	rematch:ShowSaveDialog(team,true)
end

function rematch:ToolbarFindBattleOnClick()
	local queueState = C_PetBattles.GetPVPMatchmakingInfo()
	if queueState=="proposal" then
		C_PetBattles.DeclineQueuedPVPMatch()
	elseif queueState then
		C_PetBattles.StopPVPMatchmaking()
	else
		C_PetBattles.StartPVPMatchmaking()
	end
	RematchTooltip:Hide()
end

function rematch:ToolbarTabOnClick()
	rematch:HideDialogs()
	local mode = self:GetID()==1 and "PETS" or "TEAMS"
	settings.DrawerMode = settings.DrawerMode~=mode and mode or nil
	rematch:UpdateWindow()
end

--[[ targeting ]]

-- returns name of the given unit and npcID if it's an npc, or nil if unit doesn't exist
function rematch:GetUnitNameandID(unit)
	if UnitExists(unit) then
		local name = UnitName(unit)
		local npcID
		local guid = UnitGUID(unit) or ""
		npcID = tonumber(guid:match(".-%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
		if npcID and npcID~=0 then
			return name,npcID -- this is an npc, return its name and npcID
		else
			return name -- this is a player, return its name
		end
	end
end

function rematch:MovedSinceLastAutoLoad()
	local newX,newY = UnitPosition("player")
	local distance
	if rematch.playerXPos then
		local xdiff = newX - rematch.playerXPos
		local ydiff = newY - rematch.playerYPos
		distance = xdiff*xdiff + ydiff*ydiff
	end
	rematch.playerXPos = newX
	rematch.playerYPos = newY
	return not distance or distance>25 -- sqrt(25)=5 yards
end

function rematch.events.PLAYER_TARGET_CHANGED(...)
	local saved = RematchSaved
	local teamName,npcID = rematch:GetUnitNameandID("target")
	rematch.targetName = teamName
	rematch.targetNpcID = npcID

	if rematch:IsVisible() then
		rematch:HideDialogs()
	end

	if rematch:TeamNeedsLoading(teamName,npcID) then
		if rematch:IsVisible() and (not settings.AutoLoad or rematch.lastTeamAutoLoaded==teamName) then
			rematch:ShowLoadDialog(teamName)
		elseif settings.AutoLoad and rematch.lastTeamAutoLoaded~=teamName then
			if rematch:MovedSinceLastAutoLoad() then
				rematch.lastTeamAutoLoaded = teamName
				rematch:LoadTeam(teamName)
			else
				rematch:PromptForLoad(teamName,npcID,true)
			end
		elseif not rematch:IsVisible() and settings.AutoShow then
			rematch:PromptForLoad(teamName,npcID)
		end
	end

end

-- if teamName exists, if it hasn't been offered already, if the team exists, if it's
-- not the last loaded them, and if npcID matches (or npcID not involved) then return true
function rematch:TeamNeedsLoading(teamName,npcID)
	if teamName and saved[teamName] and teamName~=settings.loadedTeamName then
		local savedNpcID = saved[teamName][4]
		if not savedNpcID or npcID==savedNpcID then
			return true
		end
	end
end

function rematch.events.UPDATE_MOUSEOVER_UNIT()
	if settings.AutoLoad and not settings.AutoLoadTargetOnly then
		local teamName,npcID = rematch:GetUnitNameandID("mouseover")
		if settings.loadedTeamName==UnitName("target") then
			return -- ignore mouseover if we've loaded a team for target
		end
		if rematch:TeamNeedsLoading(teamName,npcID) then
			if rematch.lastTeamAutoLoaded~=teamName then
				if rematch:MovedSinceLastAutoLoad() then
					rematch.lastTeamAutoLoaded = teamName
					rematch:LoadTeam(teamName)
				else
					rematch:PromptForLoad(teamName,npcID,true)
				end
			else
				rematch:PromptForLoad(teamName,npcID)
			end
		end
	end
end

-- both AutoShow and AutoLoad use this to prompt for a load
function rematch:PromptForLoad(teamName,npcID,didntMove)
	if not rematch:IsVisible() and not rematch:IsVisible() then
		rematch:Show()
		rematch.automaticallyShownForTeamName = teamName
	end
	rematch:ShowLoadDialog(teamName,didntMove and settings.AutoLoad and L["This team did not automatically load because you've already auto-loaded a team from where you're standing."])
end

--[[ Heal buttons ]]

-- track when Revive Battle Pets & Battle Pet Bandage is used (only registered when window visible)
function rematch.events:UNIT_SPELLCAST_SUCCEEDED(_,_,_,spellID)
	if spellID==125439 then -- revive battle pet
		rematch:StartTimer("UpdateHealButtons",0.1,rematch.UpdatePetHealButton)
	end
end

-- can't just track when bandages used, also need to track when bandages received
-- this is only registered while the rematch window is visible
function rematch.events:BAG_UPDATE()
	rematch:StartTimer("UpdateHealButtons",0.1,rematch.UpdateBandageButton)
end

function rematch:UpdatePetHealButton()
	rematch.toolbar.heal.cooldownContainer.cooldown:SetCooldown(GetSpellCooldown(125439))
end

function rematch:UpdateBandageButton()
	local count = GetItemCount(86143)
	local vertex = count==0 and .5 or 1
	rematch.toolbar.bandage.vertex = vertex
	rematch.toolbar.bandage.icon:SetVertexColor(vertex,vertex,vertex)
	rematch.toolbar.bandage.count:SetText(count)

	rematch:UpdateSideBarButtons() -- piggybacking onto this event from BAG_UPDATE
end

-- this is for any button that contains a spell or item that should show a real tooltip:
-- heal, bandage, treat, lessertreat, safari
function rematch:HealButtonOnEnter()
	GameTooltip:SetOwner(self,"ANCHOR_NONE")
	if self:GetAttribute("type")=="spell" then
		GameTooltip:SetSpellByID(self:GetAttribute("spell"))
	else
		local itemID = tonumber((self:GetAttribute("item") or ""):match("item:(%d+)"))
		if itemID then
			GameTooltip:SetItemByID(itemID)
		end
		if (itemID==98112 or itemID==98114) then -- if one of the treats and we have some to cast
			local petID = C_PetJournal.GetSummonedPetGUID()
			if GetItemCount(itemID)>0 then
				local spell = GetItemSpell(itemID)
				local index, buff, found = 1
				repeat
					buff = UnitBuff("player",index)
					if buff==spell then
						GameTooltip:SetUnitBuff("player",index)
						found = true
					end
					index = index + 1
				until not buff or found
				if not found then -- treat buff isn't found
					if not petID then -- if pet is not out, left click will summon a pet
						GameTooltip:AddLine(format("\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283\124t \124cff88bbff%s",rematch:GetLevelingPick(1) and L["Summon a leveling pet."] or L["Summon a favorite pet."]))
					elseif SpellIsTargeting() then -- if pet is out and spell targeting
						GameTooltip:AddLine(format("\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:89:144:228:283\124t \124cff88bbff%s",L["Target treat onto the pet."]))
					else -- if pet is out and spell targeting not happening
						GameTooltip:AddLine(format("\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283\124t \124cff88bbff%s",L["Cast this treat."]))
					end
				end
			end
			if petID then
				GameTooltip:AddLine(format("\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:330:385\124t \124cff88bbff%s",L["Dismiss the summoned pet."]))
			end
		end
	end
	GameTooltip:SetBackdropBorderColor(0.5,0.41,0)
	GameTooltip:Show()
	rematch:SmartAnchor(GameTooltip,self)

	-- this timer calls this onenter again in half a second; the onleave stops the timer
	-- this causes a bit of garbage creation but is forgivable for the effects (cooldown timers
	-- count down in the tooltip and left/right click instructions update)
	self.tooltipTimer = C_Timer.NewTimer(0.5,function() rematch.HealButtonOnEnter(self) end)
end

function rematch:HealButtonOnLeave()
	if self.tooltipTimer then
		self.tooltipTimer:Cancel() -- stop tooltip updating itself
	end
	GameTooltip:Hide()
	RematchTooltip:Hide()
end

function rematch:UpdateSafariHat()
	local hasHat = GetItemCount(92738)>0
	local spell = GetItemSpell(92738)
	local wearing = UnitBuff("player",spell)
	local safari = rematch.sidebar.safari
	safari.icon:SetTexture(wearing and "Interface\\AddOns\\Rematch\\textures\\nosafari" or "Interface\\Icons\\INV_Helm_Cloth_PetSafari_A_01")
	local vertex = hasHat and 1 or 0.35
	safari.vertex = vertex
	safari.icon:SetVertexColor(vertex,vertex,vertex)
	if wearing then
		safari:SetAttribute("type","cancelaura")
		safari:SetAttribute("unit","player")
		safari:SetAttribute("spell",spell)
	else
		safari:SetAttribute("type","item")
	end
end

function rematch:UpdateTreatButton(button)
	local treat = button:GetAttribute("item")
	local count = GetItemCount(treat)
	local vertex = count==0 and 0.5 or 1
	button.vertex = vertex
	button.icon:SetVertexColor(vertex,vertex,vertex)
	button.count:SetText(count)

	local spell = GetItemSpell(treat)
	if spell then
		local _,_,_,_,_,duration,expiration = UnitBuff("player",spell)
		if duration then
			button.cooldownContainer.cooldown:SetCooldown(expiration-duration,duration)
			return
		end
	end
	button.cooldownContainer.cooldown:Hide()
end

-- updates the sidebar buttons (safari hat, treats) if sidebar is up
function rematch:ActuallyUpdateSideBarButtons()
	if rematch.sidebar:IsVisible() then
		rematch:UpdateSafariHat()
		rematch:UpdateTreatButton(rematch.sidebar.lessertreat)
		rematch:UpdateTreatButton(rematch.sidebar.treat)
	end
end

function rematch.events.UNIT_AURA()
	rematch:StartTimer("UpdateSideBarButtons",0.1,rematch.ActuallyUpdateSideBarButtons)
end
rematch.UpdateSideBarButtons = rematch.events.UNIT_AURA

--[[ Frame movement ]]

-- from the OnMouseDown
function rematch:FrameStartMoving()
	if not settings.LockPosition or IsShiftKeyDown() then
		rematch:HideMenu()
		rematch.isMoving = true
		rematch:StartMoving()
	end
end

-- from the OnMouseUp
function rematch:FrameStopMoving()
	if rematch.isMoving then
		rematch.isMoving = nil
		rematch:StopMovingOrSizing()
		rematch:SaveFramePosition()
		rematch:SetFramePosition()
	end
end

function rematch:FrameStartSizing()
	local grip = self:GetID() -- 1=height 2=width 3=both

	local width = rematch:GetWidth()
	local height = rematch:GetHeight()

	if grip==1 then
		rematch:SetMinResize(width,332)
		rematch:SetMaxResize(width,700)
	elseif grip==2 then
		rematch:SetMinResize(296,height)
		rematch:SetMaxResize(500,height)
	else
		rematch:SetMinResize(296,332)
		rematch:SetMaxResize(500,700)
	end

	rematch:HideFloatingPetCard(true)
	rematch:HideDialogs()
	rematch.isSizing = true
	rematch:StartSizing()
	rematch.ResizeGripHighlight(self)
end

function rematch:FrameStopSizing()
	if rematch.isSizing then
		rematch.isSizing = nil
		rematch:StopMovingOrSizing()
		rematch:SaveFramePosition()
		rematch:SetFramePosition()
		rematch.ResizeGripUnhighlight(self)
	end
end

function rematch:ResizeGripHighlight()
	self.grip:SetAlpha(1)
end

function rematch:ResizeGripUnhighlight()
	self.grip:SetAlpha(0.5)
end

function rematch:SaveFramePosition()
	local mainScale = rematch:GetEffectiveScale()
	local uiScale = UIParent:GetEffectiveScale()
	local mx = rematch:GetCenter()
	local my = settings.GrowDownward and rematch:GetTop() or rematch:GetBottom()
	local ux,uy = UIParent:GetCenter()
	rematch.inLeftHalf = (mx*mainScale)<(ux*uiScale)
	rematch.inBottomHalf = (my*mainScale)<(uy*uiScale)
	settings.X = rematch:GetLeft()
	settings.Y = my -- settings.GrowDownward and rematch:GetTop() or rematch:GetBottom()
	if rematch.drawer:IsVisible() then
		settings.Height = rematch:GetHeight()
	end
	settings.Height = settings.Height or EXPANDED_HEIGHT
	settings.Width = rematch:GetWidth() or DEFAULT_WIDTH
end

function rematch:SetFramePosition()
	rematch:ClearAllPoints()
	rematch:SetPoint(settings.GrowDownward and "TOPLEFT" or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",settings.X,settings.Y)
	rematch:SetScale(settings.LargeWindow and 1.25 or 1)
end

--[[ Drawer ]]

function rematch:GetDrawerMode()
	local mode = settings.DrawerMode
	if mode=="PETS" or mode=="TEAMS" or mode=="OPTIONS" then
		return mode
	else
		return nil
	end
end

function rematch:DrawerOnHide()
	if not settings.LockDrawer then
		settings.DrawerMode = nil
		rematch:UpdateWindow()
	end
end

-- shapes tab into into a tab if state true, into a button otherwise
function rematch:SetToolbarTabState(tab,state)
	-- set tab textures depending on if in a tab or button state
	local backdrop = state and "Interface\\AddOns\\Rematch\\textures\\tab-backdrop" or "Interface\\AddOns\\Rematch\\textures\\button-backdrop"
	local border = state and "Interface\\AddOns\\Rematch\\textures\\tab-border" or "Interface\\AddOns\\Rematch\\textures\\button-border"
	for i=1,3 do
--		tab.backdrop[i]:SetTexture(backdrop)
		tab.border[i]:SetTexture(border)
		tab.highlight[i]:SetTexture(border)
	end
	-- flip tab textures depending on growth direction
	local grow = settings.GrowDownward and 1 or 0
	for _,texture in pairs({"backdrop","border","highlight"}) do
		tab[texture][1]:SetTexCoord(0,.5,grow,1-grow)
		tab[texture][2]:SetTexCoord(.5,1,grow,1-grow)
		tab[texture][3]:SetTexCoord(.25,.65,grow,1-grow)
	end
	tab.selected:SetPoint("CENTER",0,4-grow*8)
end

--[[ this is the main function to update the window ]]
function rematch:UpdateWindow()
--	rematch:debugstack("UpdateWindow")

	if not rematch:IsVisible() or InCombatLockdown() then
		return
	end

	local hasNotes = (saved[settings.loadedTeamName] and saved[settings.loadedTeamName][6]) and true

	rematch.notesButton:SetShown(hasNotes)
	if settings.loadedTeamName then
		rematch.header.text:SetText(format("%s%s",hasNotes and "     " or "",settings.loadedTeamName))
	else
		rematch.header.text:SetText(L["Current Battle Pets"])
	end
	if settings.loadedNpcID then
		rematch.header.text:SetTextColor(1,1,1)
	else
		rematch.header.text:SetTextColor(1,.82,0)
	end

	rematch:HideFloatingPetCard(true)

	rematch:UpdateCurrentPets()
	rematch:UpdatePVPStatus()

	local drawerMode = rematch:GetDrawerMode()
	local drawerOpen = drawerMode and true

	local toolbar = rematch.toolbar

	rematch:SetToolbarTabState(toolbar.petsTab,drawerMode=="PETS")
	rematch:SetToolbarTabState(toolbar.teamsTab,drawerMode=="TEAMS")
	toolbar.petsTab.selected:SetShown(drawerMode=="PETS")
	toolbar.teamsTab.selected:SetShown(drawerMode=="TEAMS")
	toolbar.petsTab:SetNormalFontObject(drawerMode=="PETS" and "GameFontHighlightSmall" or "GameFontNormalSmall")
	toolbar.teamsTab:SetNormalFontObject(drawerMode=="TEAMS" and "GameFontHighlightSmall" or "GameFontNormalSmall")

	rematch.toolbar:ClearAllPoints()
	rematch:SetWidth(settings.Width or DEFAULT_WIDTH)
	if drawerOpen then -- if drawer is open, move toolbar as needed
		rematch:SetHeight(settings.Height or EXPANDED_HEIGHT)
		rematch.drawer.separator:ClearAllPoints()
		local currentHeight = rematch.current:GetHeight()
		toolbar:ClearAllPoints()
		if settings.GrowDownward then -- toolbar is at top just below current pets
			toolbar:SetPoint("TOPLEFT",rematch,"TOPLEFT",3,-currentHeight-3)
			toolbar:SetPoint("TOPRIGHT",rematch,"TOPRIGHT",-3,-currentHeight-3)
			rematch.drawer:SetPoint("TOPLEFT",toolbar,"BOTTOMLEFT")
			rematch.drawer:SetPoint("BOTTOMRIGHT",rematch,"BOTTOMRIGHT",-3,3)
			rematch.drawer.separator:SetPoint("BOTTOMLEFT",toolbar,0,-2)
			rematch.drawer.separator:SetPoint("BOTTOMRIGHT",toolbar,0,-2)
		else -- toolbar is along bottom
			toolbar:SetPoint("BOTTOMLEFT",3,2)
			toolbar:SetPoint("BOTTOMRIGHT",-3,2)
			rematch.drawer:SetPoint("TOPLEFT",rematch,"TOPLEFT",3,-currentHeight-4)
			rematch.drawer:SetPoint("BOTTOMRIGHT",toolbar,"TOPRIGHT")
			rematch.drawer.separator:SetPoint("BOTTOMLEFT",rematch.drawer,0,-3)
			rematch.drawer.separator:SetPoint("BOTTOMRIGHT",rematch.drawer,0,-3)
		end
		rematch.drawer:Show()
	else -- if drawer isn't open
		rematch:SetHeight(COLLAPSED_HEIGHT)
		toolbar:SetPoint("BOTTOMLEFT",3,2)
		toolbar:SetPoint("BOTTOMRIGHT",-3,2)
		rematch.drawer:Hide()
	end

	if drawerMode=="PETS" then
		rematch.drawer.teams:Hide()
		rematch.drawer.browser:Show()
		rematch.drawer.queue:Show()
		rematch.drawer.options:Hide()
		rematch:UpdateBrowser()
		rematch:UpdateLeveling()
	elseif drawerMode=="TEAMS" then
		rematch.drawer.browser:Hide()
		rematch.drawer.queue:Hide()
		rematch.drawer.teams:Show()
		rematch.drawer.options:Hide()
		rematch:UpdateTeams()
	elseif drawerMode=="OPTIONS" then
		rematch.drawer.browser:Hide()
		rematch.drawer.queue:Hide()
		rematch.drawer.teams:Hide()
		rematch.drawer.options:Show()
		rematch:UpdateOptionsList()
	end

	rematch.drawer.resizeHeightGrip:SetShown(not settings.LockHeight)
	rematch.drawer.resizeWidthGrip:SetShown(not settings.LockHeight)
	rematch.drawer.resizeAllGrip:SetShown(not settings.LockHeight)
	rematch.resizeCollapsedGrip:SetShown(not drawerOpen and not settings.LockHeight)

	rematch:SetToolbarButtonEnabled(toolbar.reload,(settings.loadedTeamName and saved[settings.loadedTeamName]) and true)

	rematch:UpdatePetHealButton()
	rematch:UpdateBandageButton()
	rematch:UpdateSideBarButtons()

	rematch:SaveFramePosition()
	rematch:SetFramePosition()

	local showSideBar = settings.ShowSideBar and true
	rematch.sidebar:SetShown(showSideBar)
	rematch.current:SetPoint("TOPLEFT",rematch.sidebar,showSideBar and "TOPRIGHT" or "TOPLEFT")
--	rematch.toolbar.toggle.icon:SetTexCoord(showSideBar and 0.925 or 0.075,showSideBar and 0.075 or 0.925,0.075,0.925)

	rematch:OnSizeChanged() -- adjust width of stretchyButtons
end

--[[ ESCable system ]]

rematch.specialFrames = { "Rematch", "RematchDrawer", "RematchDialog", "RematchMenu", "RematchTeamCard", "RematchFloatingPetCard" }
rematch.ESCHandler = CreateFrame("Frame",nil,rematch)
rematch.ESCHandler:SetScript("OnKeyDown",function(self,key) -- this only runs while frame is visible
	local somethingClosed
	if key==GetBindingKey("TOGGLEGAMEMENU") then
		if rematch.drawer.browser.searchBox:HasFocus() or rematch.drawer.teams.searchBox:HasFocus() then
			self:SetPropagateKeyboardInput(true)
			return
		end
		if rematch:GetDrawerMode()=="OPTIONS" then
			rematch:ToggleOptions()
			self:SetPropagateKeyboardInput(false)
			return
		end
		if RematchNotesCard:IsVisible() and not settings.NotesNoESC then
			RematchNotesCard:Hide()
			if not settings.CloseAllOnESC then
				self:SetPropagateKeyboardInput(false)
				return
			else
				somethingClosed = true
			end
		end
		local special = rematch.specialFrames
		for i=#special,1,-1 do
			local frame = _G[special[i]]
			if frame and frame:IsVisible() then
				if i<2 and UnitExists("target") then
					-- if we're on main or drawer, and a target exists, send esc through
					self:SetPropagateKeyboardInput(true)
					return
				elseif frame==Rematch and settings.LockWindow then
					-- do nothing if on main frame and window locked (no next frame, will leave loop naturally)
				elseif frame==RematchDrawer and settings.LockDrawer then
					-- do nothing if on drawer and drawer locked, go to next frame
				elseif frame==RematchFloatingPetCard and not RematchFloatingPetCard.lockFrame:IsVisible() then
					-- if pet card is up and not locked, hide the card and continue to next frame
					frame:Hide()
				elseif frame==RematchTeamCard and not RematchTeamCard.lockFrame:IsVisible() then
					-- if team card is up and not locked, hide the card and continue to next frame
					frame:Hide()
				else
					-- if any other situation, hide the frame, consume the ESC and leave
					-- TODO: set propagate to false if i==1 and CloseAllWindows actually closes stuff
					frame:Hide()
					if not settings.CloseAllOnESC then
						self:SetPropagateKeyboardInput(false)
						return
					else
						somethingClosed = true
					end
				end
			end
		end
	elseif settings.JumpToTeam and not IsModifierKeyDown() then
		local focus = GetMouseFocus()

		if focus and key:len()==1 then
			local parent = focus:GetParent()
			local keySearch = format("^[%s%s]",key,key:lower())
			if parent==rematch.drawer.teams.list.scrollFrame.scrollChild then
				rematch:JumpToNextKey(keySearch,"TEAMS",rematch.drawer.teams.teamList,rematch.drawer.teams.list.scrollFrame)
				self:SetPropagateKeyboardInput(false)
				return
			elseif parent==rematch.drawer.browser.list.scrollFrame.scrollChild then
				rematch:JumpToNextKey(keySearch,"PETS",rematch.roster.pets,rematch.drawer.browser.list.scrollFrame)
				self:SetPropagateKeyboardInput(false)
				return
			end

		end
	end
	self:SetPropagateKeyboardInput(not somethingClosed)
end)

-- jumps to the next pet or team that begins with keySearch; used in above ESCHandler OnKeyDown
function rematch:JumpToNextKey(keySearch,tab,list,scrollFrame)

	if rematch.jumpTab~=tab or (rematch.jumpTime and GetTime()>(rematch.jumpTime+3)) then
		rematch.jumpIndex = nil
	end

	rematch.jumpTab = tab
	rematch.jumpTime = GetTime()

	rematch.jumpIndex = rematch.jumpIndex or 0
	for i=1,#list do
		rematch.jumpIndex = rematch.jumpIndex%#list + 1
		local name = list[rematch.jumpIndex]
		if tab=="PETS" then
			local petID = list[rematch.jumpIndex]
			if type(petID)=="string" then
				local _,customName,_,_,_,_,_,realName = C_PetJournal.GetPetInfoByPetID(petID)
				name = customName or realName
			else
				name = C_PetJournal.GetPetInfoBySpeciesID(petID)
			end
		end
		if name and name:match(keySearch) then
			rematch:ListScrollToIndex(scrollFrame,rematch.jumpIndex)
			for i=1,#scrollFrame.buttons do
				if scrollFrame.buttons[i].index==rematch.jumpIndex then
					rematch:ShineOnYouCrazy(scrollFrame.buttons[i].name,"LEFT",4,0)
					return
				end
			end
			return
		end
	end

	PlaySoundKitID(39369) -- play tick sound when key fails to find anything

end


SlashCmdList["REMATCH"] = function(msg)
	if msg:lower()=="reset" then
		-- /rematch reset wipes all settings (including position and other "hidden" settings)
		-- it does *not* wipe the leveling queue or saved teams
		for key in pairs(RematchSettings) do
			if key~="LevelingQueue" and key~="TeamGroups" then -- don't wipe leveling queue
				RematchSettings[key] = nil -- just everything else (saved teams are RematchSaved)
			end
		end
		ReloadUI()
	elseif msg:lower()=="import" then
		if IsAddOnLoaded("PetBattleTeams") then
			rematch:Show()
			rematch.optionsFunc.ImportPBTButton()
		else
			rematch:print(L["\124cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."])
		end
	else
		rematch:Toggle()
	end
end
SLASH_REMATCH1 = "/rematch"

-- when main window sizes, go through all stretchy buttons and adjust width based on window width
function rematch:OnSizeChanged()
	-- at 296 width, each of six button widths is 32: 296-(32*6)=104, or rW-(bW*6)=104
	local width = abs((104-self:GetWidth())/6) -- solve bW above when rW changes
	for _,button in pairs(rematch.stretchyButtons) do
		button:SetWidth(width)
	end

	-- adjust sidebar to width of button
	rematch.sidebar:SetWidth(width)
end

function rematch:ToggleSideBar()
	settings.ShowSideBar = not settings.ShowSideBar
	rematch:UpdateWindow()
end

-- for both lesser pet treat and pet treat
-- if a pet isn't out and buff needed, it will summon the topmost pet from the queue and not cast
-- if a pet is out and button is right-clicked, it will dismiss the pet and not cast
-- otherwise it will make the button cast the treat
function rematch:SideBarTreatPreClick(button)

	rematch.HideDialogs() -- since this preclick is an override of the template

	local petID = C_PetJournal.GetSummonedPetGUID()
	local treat = self:GetAttribute("item")

	self:SetAttribute("type","stop") -- this button will stopcasting unless told otherwise

	-- on right-click of treat, dismiss pet
	if button=="RightButton" then
		if petID then
			C_PetJournal.SummonPetByGUID(petID)
		end
		return
	end

	if GetItemCount(treat)==0 or UnitBuff("player",GetItemSpell(treat)) then
		return -- buff is already up, do nothing when clicked
	end

	if not petID then -- pet isn't out and we have treats
		petID = rematch:GetLevelingPick(1) -- grab top pet from queue
		if petID then -- if there's a pet in the queue, summon top-most one
			C_PetJournal.SummonPetByGUID(petID)
		else -- otherwise summon a random favorite
			C_PetJournal.SummonRandomPet(false)
		end
		return
	end
	-- if we get this far, allow this click to cast the treat
	self:SetAttribute("type","item")
end
