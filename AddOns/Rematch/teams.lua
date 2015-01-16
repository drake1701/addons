--[[ teams are saved in RematchSaved (saved local) in this format:

	["team name"] = {
		[1] = {petID,abilityID,abilityID,abilityID,speciesID}, -- petID can be a speciesID (number) if missing
		[2] = {petID,abilityID,abilityID,abilityID,speciesID},
		[3] = {petID,abilityID,abilityID,abilityID,speciesID},
		[4] = npcID, -- nil or number
		[5] = tab, -- nil or tab number (1-16)
		[6] = notes, -- nil or string max 255 characters
		[7] = minHP, - nil or minimum health preference
		[8] = allowMM, nil or true to allow low-health magic and mechanical
		[9] = maxXP, - nil or maximum level preference
	}

	petID of 0 notes a leveling pet.
]]

local _,L = ...
local rematch = Rematch
local settings
local teams = rematch.drawer.teams
local saved
local card = RematchTeamCard

teams.maxTabs = 16 -- max number of team tabs (make sure to update in rmf if this is updated)
teams.tabHeight = 44 -- height of each tab (specifically the y-offset between them)

teams.teamList = {} -- numerically indexed list of team names to list
teams.searchTabsFound = {} -- indexed by tab number, where search results are found

function rematch:InitTeams()
	settings = RematchSettings
	if not settings.TeamGroups or #settings.TeamGroups==0 then
		settings.TeamGroups = {{GENERAL,"Interface\\Icons\\PetJournalPortrait"}}
	end
	saved = RematchSaved
	saved["~temp~"] = nil
	settings.SelectedTab = settings.SelectedTab or 1
	local scrollChild = teams.tabScrollFrame.scrollChild
	for i=1,teams.maxTabs do
		if not scrollChild.tabs[i] then
			tinsert(scrollChild.tabs,(CreateFrame("CheckButton",nil,scrollChild,"RematchTeamTabButtonTemplate")))
			scrollChild.tabs[i]:SetID(i)
			scrollChild.tabs[i]:SetPoint("TOPLEFT",2,-10-(i-1)*teams.tabHeight)
		end
		scrollChild.tabs[i]:RegisterForClicks("AnyUp")
	end
	rematch:UpdateTeamTabs()

	-- setup teams list scrollFrame
	local scrollFrame = teams.list.scrollFrame
	scrollFrame.update = rematch.UpdateTeamList
	HybridScrollFrame_CreateButtons(scrollFrame, "RematchTeamListButtonTemplate")

	card:SetFrameLevel(4)
	card.lockFrame:SetFrameLevel(1)

	teams.import.icon:SetTexture("Interface\\Icons\\INV_Inscription_RunescrollOfFortitude_Blue")
	teams.import.tooltipTitle = L["Import"]

end

function rematch:UpdateTeams()
	rematch:PopulateTeamList()
	rematch:UpdateTeamTabs()
	rematch:UpdateTeamList()
end

function rematch:UpdateTeamTabs()
	local groups = settings.TeamGroups
	if not groups[settings.SelectedTab] then
		settings.SelectedTab = 1
	end
	local searching = teams.searchText and true
	local numGroups = #groups
	for i=1,teams.maxTabs do
		local tab = teams.tabScrollFrame.scrollChild.tabs[i]
		tab:SetShown(i<=(numGroups+1))
		tab:SetChecked(i==settings.SelectedTab and not searching)
		if i==(numGroups+1) then
			tab.icon:SetTexture("Interface\\AddOns\\Rematch\\textures\\newteam")
			tab.name = nil
		elseif i<=numGroups then
			tab.icon:SetTexture(groups[i][2])
			tab.name = groups[i][1]
			if searching then -- dim tabs that are not part of search results
				local tabFound = teams.searchTabsFound[i]
				tab.icon:SetDesaturated(not tabFound)
				tab.icon:SetVertexColor(tabFound and 1 or .5, tabFound and 1 or .5, tabFound and 1 or .5)
			else -- or light them all up if not searching
				tab.icon:SetDesaturated(false)
				tab.icon:SetVertexColor(1,1,1)
			end
		end
	end
	rematch:TeamTabScrollUpdate()
end

function rematch:TeamTabButtonOnClick(button)
	rematch:HideDialogs()
	self:SetChecked(false)
	rematch:ClearSearchBox(teams.searchBox)
	local index = self:GetID()
	if not self.name then
		if button~="RightButton" then
			rematch:ShowTeamTabEditDialog(index,L["New Tab"],"Interface\\Icons\\INV_Misc_QuestionMark")
		end
	else
		if index~=1 or button~="RightButton" then
			rematch:SelectTeamTab(index)
		end
		if button=="RightButton" then
			if index~=1 then
				rematch:SetMenuSubject(index)
				rematch:ShowMenu("teamTab","cursor")
			else
				rematch:UpdateTeamTabs()
			end
		end
	end
end

function rematch:TeamTabButtonOnMouseDown(button)
	local index = self:GetID()
	if button~="RightButton" or (index>1 and index<=#settings.TeamGroups) then
		self.icon:SetSize(28,28)
	end
end

function rematch:TeamTabButtonOnEnter()
	local index = self:GetID()
	if settings.TeamGroups[index] then
		rematch:ShowTooltip(settings.TeamGroups[index][1])
	else
		rematch:ShowTooltip(L["New Tab"],L["Create a new tab."])
	end
end

function rematch:SelectTeamTab(index)
	local scrollToTop = settings.SelectedTab ~= index
	settings.SelectedTab = index
	rematch:UpdateTeams()
	if scrollToTop then
		rematch:ListScrollToTop(teams.list.scrollFrame)
	end
end

--[[ Dialogs for tabs ]]

-- hybridscrollframe update for icon list in tab edit dialog
function rematch:UpdateTeamTabEditIconList()
	local data
	if rematch.dialog.iconPicker.search.text then
		data = teams.iconSearches -- if anything in search table, use this table for icons
	else
		data = teams.iconChoices
	end
	local numData = ceil(#data/6)
	local scrollFrame = rematch.dialog.iconPicker.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	for i=1,min(#buttons,scrollFrame:GetHeight()/scrollFrame.buttonHeight+2) do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			for j=1,6 do
				local subbutton = button.icons[j]
				local iconFilename = data[(index-1)*6+j]
				if iconFilename then
					if type(iconFilename)=="number" then
						subbutton.icon:SetToFileData(iconFilename)
					else
						subbutton.icon:SetTexture("INTERFACE\\ICONS\\"..iconFilename)
					end
					subbutton.selected:SetShown(subbutton.icon:GetTexture()==rematch.dialog.selectedIcon)
					subbutton:Show()
				else
					subbutton:Hide()
				end
			end
			button:Show()
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame,32*numData,32)
end

-- shows tab edit dialog
function rematch:ShowTeamTabEditDialog(index,name,icon)

	if rematch:IsDialogOpen("EditTab") and rematch.dialog.index==index then
		rematch:HideDialogs()
		return
	end

	local dialog = rematch:ShowDialog("EditTab",294,name,L["Choose a name and icon."],rematch.TeamTabEditDialogAccept)
	dialog.index = index

	dialog.slot:SetPoint("TOPLEFT",16,-20)
	dialog.slot.icon:SetTexture(icon)
	dialog.slot:Show()
	dialog.selectedIcon = icon

	dialog.editBox:SetPoint("LEFT",dialog.slot,"RIGHT",10,0)
	dialog.editBox:SetText(name)
	dialog.editBox:SetScript("OnTextChanged",rematch.DialogEditBoxOnTextChanged)
	dialog.editBox:Show()

	if not dialog.iconPicker then
		dialog.iconPicker = CreateFrame("Frame","RematchTeamTabIconList",dialog,"RematchListTemplate")
		rematch:RegisterDialogWidget("iconPicker")
		dialog.iconPicker:SetSize(226,168)
		local scrollFrame = dialog.iconPicker.scrollFrame
		scrollFrame:SetHeight(168) -- 5 buttons*32 buttonHeight
		scrollFrame.update = rematch.UpdateTeamTabEditIconList
		HybridScrollFrame_CreateButtons(scrollFrame, "RematchTabIconPickerTemplate")
		dialog.iconPicker.search = CreateFrame("EditBox","RematchTeamTabIconSearch",dialog.iconPicker,"RematchSearchBoxTemplate")
		local search = dialog.iconPicker.search
		search:SetSize(150,20)
		search:SetPoint("TOP",dialog.iconPicker,"BOTTOM",0,-4)
		search:SetScript("OnTextChanged",rematch.TeamTabEditIconSearchChanged)
		search.testIcon = search:CreateTexture(nil,"BACKGROUND")
		search.testIcon:SetSize(64,64)
		teams.iconChoices = {}
		teams.iconSearches = {}
		dialog.iconPicker:SetScript("OnHide",function() wipe(teams.iconChoices) wipe(teams.iconSearches) end)
	end

	dialog.iconPicker:SetPoint("TOP",0,-64)
	dialog.iconPicker.search:SetText("")
	dialog.iconPicker:Show()
	wipe(teams.iconChoices)
	GetLooseMacroIcons(teams.iconChoices)
	GetMacroIcons(teams.iconChoices)
	GetMacroItemIcons(teams.iconChoices)

	rematch:UpdateTeamTabEditIconList()
end

function rematch:TeamTabEditIconSearchChanged()
	if self:GetText():trim():len()>0 then
		rematch:StartTimer("TeamTabIconSearch",0.5,rematch.TeamTabEditDelayedIconSearch)
	else
		rematch:TeamTabEditDelayedIconSearch()
	end
end

function rematch:TeamTabEditDelayedIconSearch()
	local search = rematch.dialog.iconPicker.search
	local text = search:GetText():trim()
	wipe(teams.iconSearches)
	if text:len()>0 then
		search.text = rematch:DesensitizedText(text)
		for i=1,#teams.iconChoices do
			local candidate = teams.iconChoices[i]
			if type(candidate)=="number" then
				search.testIcon:SetToFileData(candidate)
				candidate = (search.testIcon:GetTexture() or ""):gsub("[iI][nN][tT][eE][rR][fF][aA][cC][eE]\\[iI][cC][oO][nN][sS]\\","")
			end
			if candidate:match(search.text) then
				tinsert(teams.iconSearches,candidate)
			end
		end
	else
		search.text = nil
	end
	rematch:UpdateTeamTabEditIconList()
end

function rematch:TeamTabEditIconOnEnter()
	local icon = (self.icon:GetTexture() or ""):gsub("[iI][nN][tT][eE][rR][fF][aA][cC][eE]\\[iI][cC][oO][nN][sS]\\","")
	rematch.ShowTooltip(self,icon)
	RematchTooltip:ClearAllPoints()
	local left = rematch.inLeftHalf
	RematchTooltip:SetPoint(left and "LEFT" or "RIGHT",self:GetParent(),left and "RIGHT" or "LEFT")
end

-- when user clicks accept button
function rematch:TeamTabEditDialogAccept()
	local index = rematch.dialog.index
	settings.TeamGroups[index] = {rematch.dialog.editBox:GetText(),rematch.dialog.selectedIcon}
	rematch:SelectTeamTab(index)
	rematch:HideDialogs()
end

-- when an icon in iconpicker clicked
function rematch:TeamTabIconPickerOnClick()
	local texture = self.icon:GetTexture()
	rematch.dialog.slot.icon:SetTexture(texture)
	rematch.dialog.selectedIcon = texture
	rematch:UpdateTeamTabEditIconList()
end

function rematch:ShowTeamTabDeleteDialog(index,name,icon)
	local dialog = rematch:ShowDialog("DeleteTab",120,name,L["Delete this tab?"],rematch.DeleteTeamTab)
	dialog.slot:SetPoint("TOPLEFT",12,-24)
	dialog.slot.icon:SetTexture(icon)
	dialog.slot:Show()
	dialog.text:SetSize(180,70)
	dialog.text:SetPoint("LEFT",dialog.slot,"RIGHT",4,0)
	dialog.text:SetText(L["Teams in this tab will be moved to the General tab."])
	dialog.text:Show()
	dialog.index = index
end

function rematch:DeleteTeamTab(index)
	if type(index)~="number" then
		index = rematch.dialog.index
	end
	if not index or index<2 or index>#settings.TeamGroups then
		return
	end
	tremove(settings.TeamGroups,index) -- remove tab from TeamGroups
	-- now go through teams and adjust group/tab where necessary
	for teamName,teamData in pairs(saved) do
		local teamTab = teamData[5]
		if teamTab==index then -- team is in tab being deleted
			teamData[5] = nil -- remove group from team, so it lists in general
		elseif teamTab and teamTab>index then -- team is in a tab after the one being delete
			teamData[5] = teamData[5]-1 -- decrement group number
		end
	end
	rematch:SelectTeamTab(1)
end

function rematch:SwapTeamTabs(index1,index2)
	for teamName,teamData in pairs(saved) do
		local teamTab = teamData[5]
		if teamTab==index1 then
			teamData[5] = index2
		elseif teamTab==index2 then
			teamData[5] = index1
		end
	end
	local groups = settings.TeamGroups
	local name,icon = groups[index1][1], groups[index1][2]
	groups[index1][1] = groups[index2][1]
	groups[index1][2] = groups[index2][2]
	groups[index2][1] = name
	groups[index2][2] = icon
end

--[[ Team List ]]

-- populates teams.teamList with teamNames in the selected tab
function rematch:PopulateTeamList()
	local list = teams.teamList
	wipe(list)
	if teams.searchText then -- if anything in searchbox, populate from search results
		rematch:PopulateTeamSearchResults()
	else -- otherwise populate with matching tabs
		local selectedTab = settings.SelectedTab
		local numTabs = #settings.TeamGroups
		for teamName,teamData in pairs(saved) do
			local teamTab = teamData[5]
			if teamTab and teamTab>numTabs then
				saved[teamName][5] = nil
				teamTab = nil
			end
			if teamTab and teamTab==selectedTab then
				tinsert(list,teamName)
			elseif not teamTab and selectedTab==1 then
				tinsert(list,teamName)
			end
		end
	end
	table.sort(list,function(e1,e2) return e1:lower()<e2:lower() end)
end

function rematch:UpdateTeamList()
	local data = teams.teamList
	local numData = #data
	local scrollFrame = teams.list.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	scrollFrame.stepSize = floor(scrollFrame:GetHeight()*.65)

	for i=1, #buttons do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			local teamName = data[index]
			local teamData = saved[teamName]
			button.name:SetText(teamName)
			button.teamName = teamName
			button.index = index
			if teamName==settings.loadedTeamName then
				button.back:SetGradientAlpha("VERTICAL",.35,.65,1,1, .35,.65,1,0)
			else
				button.back:SetGradientAlpha("VERTICAL",.35,.35,.35,1,.35,.35,.35,0)
			end
			for j=1,3 do
				local petID = teamData[j][1]
				local speciesID = teamData[j][5]
				if petID==0 then
					icon = rematch.levelingIcon
				elseif speciesID or type(petID)=="number" then
					icon = select(2,C_PetJournal.GetPetInfoBySpeciesID(type(petID)=="number" and petID or speciesID))
				else
					icon = "Interface\\Buttons\\UI-PageButton-Background"
				end
				button.pets[j]:SetTexture(icon)
			end
			if teamData[4] then
				button.name:SetTextColor(1,1,1)
			else
				button.name:SetTextColor(1,.82,0)
			end
			local xoff = -10 -- xoffset for BOTTOMRIGHT anchor for name
			local hasNotes = teamData[6] and true
			local hasPreferences = (teamData[7] or teamData[9]) and true
			xoff = xoff - (hasNotes and 16 or 0) - (hasPreferences and 16 or 0)
			button.name:SetPoint("BOTTOMRIGHT",xoff,1)
			button.notes:SetShown(hasNotes)
			if hasNotes and hasPreferences then
				button.preferences:SetPoint("RIGHT",-18,0)
			elseif hasPreferences then
				button.preferences:SetPoint("RIGHT",1,0)
			end
			button.preferences:SetShown(hasPreferences)
			button:Show()
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame,28*numData,28)
	rematch:TeamTabScrollUpdate()
end

function rematch:TeamListOnClick(button)
	if button=="RightButton" then
		rematch:SetMenuSubject(self.teamName)
		rematch:ShowMenu("teamList","cursor")
	elseif settings.OneClickLoad then
		rematch:LoadTeam(self.teamName)
	else
		rematch:LockTeamCard()
		if self.teamName ~= card.teamName then
			rematch.TeamListOnEnter(self,true)
			rematch:LockTeamCard()
		end
	end
end

function rematch:TeamListOnDoubleClick()
	rematch:LoadTeam(self.teamName)
	card:Hide()
end

function rematch:TeamListOnEnter(force)
	if not card.locked or force then
		rematch:SmartAnchor(card,self)
		rematch:FillPetFramesFromTeam(card.pets,self.teamName)
		card.name:SetText(self.teamName)
		SetPortraitToTexture(card.icon,settings.TeamGroups[saved[self.teamName][5] or 1][2])
		card.teamName = self.teamName
		card:Show()
	end
end

function rematch:TeamListOnLeave()
	if not card.locked then
		card:Hide()
	end
end

function rematch:LockTeamCard()
	card.locked = not card.locked
	card.lockFrame:SetShown(card.locked)
end

function rematch:TeamCardOnHide()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	self.locked = nil
	self.lockFrame:Hide()
	rematch:HideFloatingPetCard(true)
end

-- goes through a team and confirms pets are valid petIDs
-- if not, it will convert them to a speciesID and look for an owned pet that's not already on the team
function rematch:ValidateTeam(team)
	if type(team)=="string" then
		team = saved[team]
	end
	if not team then
		return false
	end
	-- first see if there are any duplicate petIDs
	for i=2,3 do
		for j=1,i-1 do
			local petID = team[i][1]
			if petID==team[j][1] and type(petID)=="string" and petID~=rematch.emptyPetID then
				team[i][1] = team[i][5] -- duplicate petID, change to speciesID
			end
		end
	end
	-- now change any invalid petIDs to speciesIDs
	for i=1,3 do
		local petID = team[i][1]
		if type(petID)=="string" and petID~=rematch.emptyPetID then -- if a "real" petID
			if not petID:match("^BattlePet") then
				team[i][1] = team[i][5]
			elseif C_PetJournal.PetIsRevoked(petID) then
				team[i][1] = team[i][5]
			elseif not C_PetJournal.GetPetInfoByPetID(petID) then
				team[i][1] = team[i][5] -- invalid petID, change to speciesID
			end
		end
	end
	-- now look for any speciesIDs and find the best pet for them
	for i=1,3 do
		local petID = team[i][1]
		if type(petID)=="number" and petID~=0 then -- if petID is a speciesID
			local newPetID = rematch:FindBestPetForTeam(petID,i,team)
			if newPetID then
				team[i][1] = newPetID -- we found a petID! :D
			end
		end
	end
end

-- for team searches and InATeam/NotInATeam filter, we'll be looking through teams
-- that have maybe not been interacted; once a session, go through and validate them all
function rematch:ValidateAllTeams()
	if not rematch.allTeamsValidated then
		for teamName in pairs(saved) do
			rematch:ValidateTeam(teamName)
		end
		rematch.allTeamsValidated = true
	end
end

function rematch:ShowLoadDialog(teamName,extra)
	if not teamName or not saved[teamName] then
		return
	end
	rematch:HideDialogs()

	local dialog = rematch:ShowDialog("LoadTeam",128,teamName,L["Load this team?"])

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()

	dialog.accept:SetScript("OnClick",function() rematch:LoadTeam(teamName) end)

	if extra then
		dialog.text:SetSize(220,40)
		dialog.text:SetFontObject("GameFontHighlightSmall")
		dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-4)
		dialog.text:SetText(extra)
		dialog.text:Show()
		dialog:SetHeight(170)
	end

	rematch:FillPetFramesFromTeam(dialog.team.pets,teamName)
end

-- finds the best pet that doesn't occupy one of the other pet slots
function rematch:FindBestPetForTeam(speciesID,index,teamTable)
	if index==1 then
		return rematch:FindBestPetID(speciesID,teamTable[2][1],teamTable[3][1])
	elseif index==2 then
		return rematch:FindBestPetID(speciesID,teamTable[1][1],teamTable[3][1])
	else
		return rematch:FindBestPetID(speciesID,teamTable[1][1],teamTable[2][1])
	end
end

function rematch:FillPetFramesFromTeam(pets,team,teamName)
	if type(team)=="string" then
		teamName = team
		team = saved[team]
	elseif type(team)=="table" and not teamName then
		teamName = team.teamName
	end
	if not team then
		return
	end
	rematch:ValidateTeam(team)
	rematch:WipePetFrames(pets)

	for i=1,3 do
		local petID = team[i][1]
		local icon,missing,level = rematch:GetPetIDIcon(petID)
		if icon then
			pets[i].petID = petID
			pets[i].icon:SetTexture(icon)
			pets[i].icon:Show()
			pets[i].icon:SetDesaturated(missing)
			pets[i].leveling:SetShown(petID==0)
			if level and level<25 then
				pets[i].levelBG:Show()
				pets[i].level:SetText(level)
				pets[i].level:Show()
			end
			if not settings.HideRarityBorders and type(petID)=="string" then
				local _,_,_,_,rarity = C_PetJournal.GetPetStats(petID)
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
				pets[i].border:SetVertexColor(r,g,b,1)
				pets[i].border:Show()
			end
			for j=1,3 do
				local abilityID = team[i][j+1] or 0
				local _,_,icon = C_PetBattles.GetAbilityInfoByID(abilityID)
				if icon then
					pets[i].abilities[j].abilityID = abilityID
					pets[i].abilities[j].icon:SetTexture(icon)
					pets[i].abilities[j].icon:Show()
					pets[i].abilities[j].icon:SetDesaturated(missing)
				end
			end
		end
	end

	-- copy other info (npcID, notes, etc) to frames' parent table
	for i=4,9 do
		pets[i] = team[i]
	end
	pets.teamName = teamName
	pets.originalTeamName = teamName
end

function rematch:ScrollToTeam(teamName)
	for i=1,#teams.teamList do
		if teams.teamList[i]==teamName then
			rematch:ListScrollToIndex(teams.list.scrollFrame,i)
			return
		end
	end
end

--[[ Rename ]]

function rematch:ShowRenameDialog(teamName)
	local dialog = rematch:ShowDialog("RenameTeam",154,teamName,L["Rename this team?"],rematch.RenameAccept)
	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,teamName)

	dialog.editBox:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.editBox:SetText(teamName)
	dialog.editBox:SetScript("OnTextChanged",rematch.RenameOnTextChanged)
	dialog.editBox:Show()
end

function rematch:RenameOnTextChanged()
	local teamName = self:GetText()
	local dialog = rematch.dialog
	local nameTaken = saved[teamName] and teamName~=dialog.team.pets.teamName
	rematch:SetAcceptEnabled(teamName:len()>0 and not nameTaken)
	if nameTaken then
		dialog.warning:SetPoint("TOP",dialog.editBox,"BOTTOM",0,-4)
		dialog.warning.text:SetText(L["A team already has this name."])
		dialog.warning:Show()
		dialog:SetHeight(178)
	else
		dialog.warning:Hide()
		dialog:SetHeight(154)
	end
end

function rematch:RenameAccept()
	local dialog = rematch.dialog
	local oldTeamName = dialog.team.pets.teamName
	local newTeamName = dialog.editBox:GetText()
	if newTeamName and saved[oldTeamName] and oldTeamName~=newTeamName then
		saved[newTeamName] = {}
		for i=1,9 do
			if i<=3 then
				saved[newTeamName][i] = {}
				for j=1,5 do
					saved[newTeamName][i][j] = saved[oldTeamName][i][j]
				end
			else
				saved[newTeamName][i] = saved[oldTeamName][i]
			end
		end
		saved[oldTeamName] = nil
		if settings.loadedTeamName==oldTeamName then
			settings.loadedTeamName = newTeamName
		end
		rematch:UpdateWindow()
		rematch:ScrollToTeam(newTeamName)
	end
end

--[[ Search Box ]]

function rematch:TeamSearchBoxOnTextChanged()
	local text = self:GetText()
	if text:len()>0 and text~=SEARCH then
		teams.searchText = rematch:DesensitizedText(text)
	else
		teams.searchText = nil
	end
	rematch:UpdateTeams()
end

-- fills teams.teamList with teams that meet the search criterea
function rematch:PopulateTeamSearchResults()
	local list = teams.teamList
	local search = teams.searchText
	wipe(teams.searchTabsFound)
	rematch:ValidateAllTeams()
	for teamName,teamData in pairs(saved) do
		local teamTab = teamData[5]
		local found
		if teamName:match(search) then -- search is part of team name
			found = true
		elseif teamData[6] and teamData[6]:match(search) then -- search is in the notes
			found = true
		else
			local info = rematch.info
			for i=1,3 do -- look for search as part of a pet or ability in the team
				local petID = teamData[i][1]
				if type(petID)=="string" and petID~=rematch.emptyPetID then
					local _,customName,_,_,_,_,_,realName = C_PetJournal.GetPetInfoByPetID(petID)
					if (customName and customName:match(search)) or (realName and realName:match(search)) then
						found = true
						break
					end
				end
			end
		end
		if found then
			tinsert(list,teamName)
			teams.searchTabsFound[teamTab or 1] = true
		end
	end
end

function rematch:ReloadTeam()
	local teamName = settings.loadedTeamName
	if teamName and saved[teamName] then
		rematch:LoadTeam(teamName)
	end
end

--[[ Tab Scrolling ]]

function rematch:TeamTabScroll(delta)
	local offset = teams.tabScrollFrame:GetVerticalScroll() - teams.tabHeight*delta
	rematch:TeamTabScrollUpdate(offset - offset%teams.tabHeight)
end

function rematch:TeamTabScrollUpdate(offset)
	local scrollFrame = teams.tabScrollFrame
	local offset = offset or scrollFrame:GetVerticalScroll() -- use passed offset or current offset if none passed
	local maxOffset = min(#settings.TeamGroups+1,teams.maxTabs)*teams.tabHeight - scrollFrame:GetHeight()

	if offset>maxOffset then
		offset = max(0,maxOffset)
	elseif offset<0 then
		offset = 0
	end
	scrollFrame:SetVerticalScroll(offset)

	teams.tabScrollUp:SetShown(offset>0)
	teams.tabScrollDown:SetShown(offset<maxOffset)
end
