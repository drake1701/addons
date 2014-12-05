
local _,L = ...
local rematch = Rematch
local settings
local saved

-- these don't need declared, but they're important enough to merit early mention
rematch.targetName = nil -- name/npc ID of current target
rematch.targetNpcID = nil
--settings.loadedTeamName = nil -- name/npc ID of last team loaded
--settings.loadedNpcID = nil

local COLLAPSED_HEIGHT = 134
local EXPANDED_HEIGHT = 450

rematch.inBottomHalf = nil -- whether center of main frame is in lower half of screen
rematch.inLeftHalf = nil -- whether center of main frame is in left half of screen

function rematch:InitMain()

	settings = RematchSettings
	saved = RematchSaved

	-- setup buttons along bottom of main window
	for index,info in pairs({
		-- { icon, tooltip (string or func), OnClick func, noHide }
		{"Interface\\AddOns\\Rematch\\textures\\save",SAVE,rematch.ToolbarSaveOnClick,true}, -- Icons\\INV_Misc_Bag_09",SAVE},
		{"Interface\\Icons\\ability_monk_roll",L["Reload"],rematch.ReloadTeam},
		{"Interface\\Icons\\Trade_Engineering",L["Options"],rematch.ToggleOptions},
		{"Interface\\Icons\\PetBattle_Attack",FIND_BATTLE,rematch.ToolbarFindBattleOnClick},
		{"Interface\\Icons\\inv_misc_bandage_05"},
		{"Interface\\Icons\\spell_misc_petheal"},
	}) do
		rematch.toolbar.buttons[index].icon:SetTexture(info[1])
		rematch.toolbar.buttons[index].tooltipTitle = info[2]
		if info[3] then
			rematch.toolbar.buttons[index]:SetScript("OnClick",info[3])
		end
		if info[4] then -- disable PreClick so these buttons can act as a toggle
			rematch.toolbar.buttons[index]:SetScript("PreClick",nil)
		end
	end

	rematch.toolbar.petsTab:SetText(PETS)
	rematch.toolbar.teamsTab:SetText(L["Teams"])

	rematch:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
	rematch.events:PET_BATTLE_QUEUE_STATUS()

	rematch:SetUserPlaced(0)
	rematch:SetWidth(296)

	rematch.notesButton:SetFrameLevel(rematch.header:GetFrameLevel()+3)
	rematch.notesButton:RegisterForClicks("AnyUp")

	settings = RematchSettings
	if not settings.X then
		rematch:SaveFramePosition()
	end
	rematch:SetFramePosition()

end

function rematch:Toggle()
	if InCombatLockdown() then
		print(L["\124cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"])
	else
		rematch:SetShown(not rematch:IsVisible())
		return true
	end
end

-- called from BINDING_NAME_REMATCH_AUTOLOAD
function rematch:ToggleAutoLoad()
	rematch:HideDialogs()
	settings.AutoLoad = not settings.AutoLoad and 1 or nil
	print(L["\124cffffff00Rematch Auto Load is now"],settings.AutoLoad and L["\124cff00ff00Enabled"] or L["\124cffff0000Disabled"])
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
	if rematch.targetName then -- if something targeted, use targeted name/npcID
		rematch:ShowSaveDialog(rematch.targetName,nil,rematch.targetNpcID)
	else -- otherwise, use loaded name/npcID if they exist
		rematch:ShowSaveDialog(settings.loadedTeamName,nil,settings.loadedNpcID)
	end
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

function rematch.events.PET_BATTLE_QUEUE_STATUS()
	local button = rematch.toolbar.buttons[4]
	local oldIcon = button.icon:GetTexture()
	local queued = C_PetBattles.GetPVPMatchmakingInfo()
	button.tooltipTitle = queued and LEAVE_QUEUE or FIND_BATTLE
	button.icon:SetTexture(queued and "Interface\\Icons\\PetBattle_Attack-Down" or "Interface\\Icons\\PetBattle_Attack")
	if oldIcon~=button.icon:GetTexture() then
		rematch:ShineOnYouCrazy(button,"CENTER")
	end
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
	rematch:StartTimer("UpdateHealbuttons",0.1,rematch.UpdateBandageButton)
end

function rematch:UpdatePetHealButton()
	rematch.toolbar.buttons[6].cooldownContainer.cooldown:SetCooldown(GetSpellCooldown(125439))
end

function rematch:UpdateBandageButton()
	local count = GetItemCount(86143)
	local vertex = count==0 and .5 or 1
	rematch.toolbar.buttons[5].vertex = vertex
	rematch.toolbar.buttons[5].icon:SetVertexColor(vertex,vertex,vertex)
	rematch.toolbar.buttons[5].count:SetText(GetItemCount(86143))
end

function rematch:HealButtonOnEnter()
	GameTooltip:SetOwner(self,"ANCHOR_NONE")
	if self:GetAttribute("type")=="spell" then
		GameTooltip:SetSpellByID(125439) -- self:GetAttribute("spell")) -- 125439)
	else
--		local itemID = tonumber(self:GetAttribute("item"):match("item:(%d+)"))
		GameTooltip:SetItemByID(86143) -- itemID) -- 86143)
	end
	GameTooltip:Show()
	rematch:SmartAnchor(GameTooltip,self)
end

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
	rematch:HideFloatingPetCard(true)
	rematch:HideDialogs()
	rematch.isSizing = true
	rematch:StartSizing()
	rematch:ResizeGripHighlight()
end

function rematch:FrameStopSizing()
	if rematch.isSizing then
		rematch.isSizing = nil
		rematch:StopMovingOrSizing()
		rematch:SaveFramePosition()
		rematch:SetFramePosition()
		rematch:ResizeGripUnhighlight()
	end
end

function rematch:ResizeGripHighlight()
	rematch.drawer.resizeGrip.gripLine1:SetVertexColor(1,1,1)
	rematch.drawer.resizeGrip.gripLine2:SetVertexColor(1,1,1)
end

function rematch:ResizeGripUnhighlight()
	rematch.drawer.resizeGrip.gripLine1:SetVertexColor(0.75,0.75,0.75)
	rematch.drawer.resizeGrip.gripLine2:SetVertexColor(0.75,0.75,0.75)
end

function rematch:SaveFramePosition()
	local mainScale = rematch:GetEffectiveScale()
	local uiScale = UIParent:GetEffectiveScale()
	local mx,my = rematch.toolbar.buttons[5]:GetCenter()
	local ux,uy = UIParent:GetCenter()
	rematch.inLeftHalf = (mx*mainScale)<(ux*uiScale)
	rematch.inBottomHalf = (my*mainScale)<(uy*uiScale)
	settings.X = rematch:GetLeft()
	settings.Y = settings.GrowDownward and rematch:GetTop() or rematch:GetBottom()
	if rematch.drawer:IsVisible() then
		settings.Height = rematch:GetHeight()
	elseif not settings.Height then
		settings.Height = EXPANDED_HEIGHT
	end
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
		tab.backdrop[i]:SetTexture(backdrop)
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
--	rematch.header.text:SetText(settings.loadedTeamName or L["Current Battle Pets"])
	if settings.loadedNpcID then
		rematch.header.text:SetTextColor(1,1,1)
	else
		rematch.header.text:SetTextColor(1,.82,0)
	end

	rematch:HideFloatingPetCard(true)

	rematch:UpdateCurrentPets()

	local drawerMode = rematch:GetDrawerMode()
	local drawerOpen = drawerMode and true

	rematch:SetToolbarTabState(rematch.toolbar.petsTab,drawerMode=="PETS")
	rematch:SetToolbarTabState(rematch.toolbar.teamsTab,drawerMode=="TEAMS")
	rematch.toolbar.petsTab.selected:SetShown(drawerMode=="PETS")
	rematch.toolbar.teamsTab.selected:SetShown(drawerMode=="TEAMS")
	rematch.toolbar.petsTab:SetNormalFontObject(drawerMode=="PETS" and "GameFontHighlightSmall" or "GameFontNormalSmall")
	rematch.toolbar.teamsTab:SetNormalFontObject(drawerMode=="TEAMS" and "GameFontHighlightSmall" or "GameFontNormalSmall")

	rematch.toolbar:ClearAllPoints()
	if drawerOpen then -- if drawer is open, move toolbar as needed
		rematch:SetHeight(settings.Height or EXPANDED_HEIGHT)
		rematch.drawer.separator:ClearAllPoints()
		if settings.GrowDownward then -- toolbar is at top just below current pets
			rematch.toolbar:SetPoint("TOP",rematch.current,"BOTTOM")
			rematch.drawer:SetPoint("TOPLEFT",rematch.toolbar,"BOTTOMLEFT")
			rematch.drawer:SetPoint("BOTTOMRIGHT",rematch,"BOTTOMRIGHT",-3,3)
			rematch.drawer.separator:SetPoint("BOTTOM",rematch.toolbar,"BOTTOM",0,-2)
		else -- toolbar is along bottom
			rematch.toolbar:SetPoint("BOTTOM",0,2)
			rematch.drawer:SetPoint("TOPLEFT",rematch.current,"BOTTOMLEFT")
			rematch.drawer:SetPoint("BOTTOMRIGHT",rematch.toolbar,"TOPRIGHT")
			rematch.drawer.separator:SetPoint("BOTTOM",rematch.drawer,"BOTTOM",0,-3)
		end
		rematch.drawer:Show()
	else -- if drawer isn't open
		rematch:SetHeight(COLLAPSED_HEIGHT)
		rematch.toolbar:SetPoint("BOTTOM",0,2)
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

	rematch.drawer.resizeGrip:SetShown(not settings.LockHeight)

	rematch:SetToolbarButtonEnabled(rematch.toolbar.buttons[2],(settings.loadedTeamName and saved[settings.loadedTeamName]) and true)

	rematch:UpdatePetHealButton()
	rematch:UpdateBandageButton()

	rematch:SaveFramePosition()
	rematch:SetFramePosition()
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
			print(L["\124cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."])
		end
	else
		rematch:Toggle()
	end
end
SLASH_REMATCH1 = "/rematch"
