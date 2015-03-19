
local _,L = ...
local rematch = Rematch
local settings
local saved

function rematch:InitSaveAs()
	settings = RematchSettings
	saved = RematchSaved
	RegisterAddonMessagePrefix("Rematch")
	rematch:RegisterEvent("CHAT_MSG_ADDON")
end

-- this displays a dialog to save a team (must be a table)
-- if team isn't given, then it will use the team last loaded into team.pets
-- if fromCurrent is true, then team being is saved from current pets
function rematch:ShowSaveDialog(team,fromCurrent)

	local dialog = rematch.dialog

	rematch:ShowDialog("SaveTeam",152,L["Save As..."],L["Save this team?"],rematch.SaveDialogAcceptOnClick)

	dialog.team:SetPoint("TOP",0,-48)
	dialog.team:Show()

	if team then
		rematch:FillPetFramesFromTeam(dialog.team.pets,team)
	end

	local pets = dialog.team.pets

	dialog.editBox:SetPoint("TOP",0,-20)
	dialog.editBox:SetText(pets.teamName)
	dialog.editBox:SetScript("OnTextChanged",rematch.SaveEditBoxOnTextChanged)
	dialog.editBox:Show()

	-- tabPicker button appears if user has custom tabs defined--to choose where to save team
	if #settings.TeamGroups>1 then
		dialog.tabPicker:Show()
	end

	dialog.savingFromCurrent = fromCurrent

	-- if any leveling pets, setup levelingPanel
	if pets[1].petID==0 or pets[2].petID==0 or pets[3].petID==0 then
		dialog.hasLeveling = true
		local panel = dialog.levelingPanel
--		panel:SetPoint("TOP",0,-120)
		panel:Show()
		-- set initial values to controls
		panel.minHP:SetText(pets[7] or "")
		panel.allowMM:SetChecked(pets[8] and true)
		panel.maxXP:SetText(pets[9] or "")
		if pets[7] or pets[9] then
			dialog.showLeveling = true -- if any preferences defined, show panel from start
		end
		rematch:PreferencesExpectedUpdate()
		-- make tab on reused editBox jump to minHP (this is cleared when dialogs are repurposed)
		dialog.editBox:SetScript("OnTabPressed",function(self)
			if dialog.levelingPanel:IsVisible() then
				dialog.levelingPanel.minHP:SetFocus(true)
			end
		end)
		-- display toggle button in lower left of dialog
		dialog.panelToggle:SetPoint("BOTTOMLEFT",3,2)
		dialog.panelToggle.icon:SetTexture(rematch.levelingIcon)
		dialog.panelToggle:Show()
		-- if saving from current pets, show the option 'Save leveling pets as themselves'
		if not dialog.asThemselves then
			dialog.asThemselves = CreateFrame("CheckButton",nil,dialog,"RematchCheckButtonTemplate")
			rematch:RegisterDialogWidget("asThemselves")
			dialog.asThemselves.text:SetText(L["Save leveling pets as themselves"])
			dialog.asThemselves.tooltipTitle = L["Save As Themselves"]
			dialog.asThemselves.tooltipBody = L["Save pets without turning them into leveling pets.\n\nSo loading this team in the future will load these specific pets and not from the queue."]
			dialog.asThemselves:SetScript("OnClick",rematch.LevelingPanelSaveAsThemselvesOnClick)
		end
		dialog.asThemselves:SetChecked(false) -- always default it to off
		dialog.asThemselves:SetPoint("BOTTOMLEFT",24,40)
	else
		dialog.hasLeveling = nil
	end

	-- if saving with an npcID attached, add a checkbox to allow clearing the npcID
	if pets[4] then
		if not dialog.checkBox then
			dialog.checkBox = CreateFrame("CheckButton",nil,dialog,"RematchCheckButtonTemplate")
			rematch:RegisterDialogWidget("checkBox")
		end
		dialog.checkBox.text:SetText(format(L["Save NPC ID with team"],pets[4]))
		dialog.checkBox:SetChecked(true)
		dialog.checkBox.tooltipTitle = format(L["Save NPC ID (%d)"],pets[4])
		dialog.checkBox.tooltipBody = format(L["Save a unique identifier for \124cffffffff%s\124r so Rematch will react only to this version of the NPC.\n\nIf an ID is not saved, Rematch will react to any targets that share this team's name.\n\nTeams with an NPC ID are listed in \124cffffffffWhite\124r.\nTeams without an NPC ID are listed in \124cffffd200Gold\124r."],team.teamName)
		dialog.checkBox:SetPoint("TOPLEFT",dialog.team,"BOTTOMLEFT",35,-6)
		dialog.keepNpcID = true
		dialog.checkBox:SetScript("OnClick",function(self) dialog.keepNpcID = self:GetChecked() end)
		dialog.checkBox:Show()
	end

	RematchTeamCard:Hide()
end

function rematch:UpdateSaveDialog()
	local dialog = rematch.dialog
	local warnOffset = dialog.warning:IsVisible() and 18 or 0
	local pets = dialog.team.pets
	local npcOffset = pets[4] and 26 or 0
	local showLeveling = dialog.showLeveling and dialog.hasLeveling
	dialog.levelingPanel:SetShown(showLeveling and true)
	if dialog.asThemselves then
		dialog.asThemselves:SetShown(dialog.savingFromCurrent and showLeveling)
	end
	dialog:SetHeight(152 + npcOffset + warnOffset + (showLeveling and (dialog.levelingPanel:GetHeight()+(dialog.savingFromCurrent and 24 or 0)) or 0))
	dialog.team:SetPoint("TOP",0,-48-warnOffset)
	dialog.levelingPanel:SetPoint("TOP",0,-120-warnOffset-npcOffset)
end

function rematch:SaveEditBoxOnTextChanged()
	local teamName = self:GetText()
	rematch:SetAcceptEnabled(teamName:len()>0)
	local dialog = rematch.dialog
	dialog.team.pets.teamName = teamName
	-- loadedTeamName is the loaded team; we need to account for new targeted npcIDs staying
	if saved[teamName] and teamName~=dialog.team.pets.originalTeamName then -- if name is same as an existing team
		dialog.warning.text:SetText(L["A team already has this name."])
		dialog.warning:SetPoint("TOP",0,-42)
		dialog.warning:Show()
	else
		dialog.warning:Hide()
	end
	rematch:UpdateSaveDialog()
end

-- does the final save of a team
function rematch:SaveTeamFromPetFrames(pets)
	saved[pets.teamName] = saved[pets.teamName] or {}
	local team = saved[pets.teamName]
	local hasLeveling
	for i=1,3 do
		local petID = pets[i].petID
		-- petID goes in [1]
		team[i] = {petID}
		-- note if any leveling pets in this team
		if petID==0 then
			hasLeveling = true
		end
		-- abilities go in [2] through [4]
		for j=1,3 do
			team[i][j+1] = pets[i].abilities[j].abilityID or 0
		end
		-- speciesID goes in [5]
		if type(petID)=="string" and petID~=rematch.emptyPetID then
			local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
			if speciesID then
				team[i][5] = speciesID
			end
		elseif type(petID)=="number" and petID~=0 then
			team[i][5] = petID
		end
	end
	-- the existing npcID should take precedent over the old one
	if not team[4] then
		team[4] = pets[4]
	end
	-- if 'Save NPC with team' unchecked, remove npcID
	if not rematch.dialog.keepNpcID then
		team[4] = nil
	end
	for i=7,10 do -- minHP, allowMM, maxXP, expected (MAX_TEAM_FIELDS is 10)
		if hasLeveling then
			team[i] = pets[i]
		else
			team[i] = nil
		end
	end
	rematch:AssignTeamToTab(pets.teamName,settings.SelectedTab)
	-- if the name was changed by the user, then remove its npcID
	if pets.originalTeamName ~= pets.teamName then
		team[4] = nil
	end
	wipe(settings.ManuallySlotted)
	if not rematch.dialog.teamNotLoaded then
		settings.loadedTeamName = pets.teamName
		settings.loadedNpcID = team[4]
		rematch:ProcessQueue() -- leveling pet preferences may have changed
	end
end

function rematch:SaveDialogAcceptOnClick()
	local dialog = rematch.dialog
	local teamName = dialog.team.pets.teamName
	local npcID = dialog.npcID

	rematch.lastOffered = nil -- "reset" autoload ignoring last target

	-- if team already exists and any pets are different...
	local askReplace
	if saved[teamName] then
		for i=1,3 do
			if saved[teamName][i][1]~=dialog.team.pets[i].petID then
				askReplace = true
			end
		end
	end

	if askReplace then -- then ask if they want this replaced
		rematch:ShowReplaceDialog(teamName)
	else -- otherwise save
		rematch:SaveTeamFromPetFrames(dialog.team.pets)
		rematch:UpdateWindow()
		rematch:ScrollToTeam(teamName)
	end
end

function rematch:ShowReplaceDialog(teamName)

	local dialog = rematch.dialog

	if not saved[teamName] then
		return -- this can only be called from a dialog displaying a team that already exists
	end

	-- now show the dialog (which wipes the contents of the team frames!)
	rematch:ShowDialog("ReplaceTeam",220,teamName,L["Overwrite this team?"],rematch.ReplaceApproved)

	if not dialog.replace then
		dialog.replace = CreateFrame("Frame",nil,dialog,"RematchTeamTemplate")
		rematch:RegisterDialogWidget("replace")
		dialog.replace.arrow = dialog.replace:CreateTexture(nil,"ARTWORK")
		dialog.replace.arrow:SetSize(32,32)
		dialog.replace.arrow:SetPoint("TOP",dialog.replace,"BOTTOM",0,0)
		dialog.replace.arrow:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
	end
	dialog.replace:SetPoint("TOP",0,-24)
	dialog.replace:Show()

	dialog.team:SetPoint("TOP",dialog.replace,"BOTTOM",0,-32)
	dialog.team:Show()

	-- old team is saved[teamName] and filled into dialog.replace
	-- new team is the one from dialog.team from previous dialog
	rematch:FillPetFramesFromTeam(dialog.replace.pets,saved[teamName])

	dialog.runOnHide = rematch.RestoreSaveInOneFrame -- when hitting cancel, show save dialog

end

-- this is the runOnHide for the replace dialog
-- one frame after window hides, run RestoreSaveDialog if runOnHide still defined
function rematch:RestoreSaveInOneFrame()
	C_Timer.After(0,rematch.RestoreSaveDialog)
end

-- unless the accept button is clicked (that nils the runOnHide), restore
-- the save dialog that spawned the replace dialog that hid last frame
function rematch:RestoreSaveDialog()
	if rematch.dialog.runOnHide then -- accept button wasn't hit (esc or cancel)
		rematch:ShowSaveDialog()
	end
end

-- accept was clicked, nil runOnHide and save the team for real real
function rematch:ReplaceApproved()
	local dialog = rematch.dialog
	dialog.runOnHide = nil
	if not dialog.teamNotLoaded then
		settings.loadedTeamName = dialog.teamName
		settings.loadedNpcID = dialog.npcID
	end
	rematch:SaveTeamFromPetFrames(dialog.team.pets)
	rematch:UpdateWindow()
	rematch:ScrollToTeam(dialog.teamName)
end

-- when an editbox in levelingPanel text changes, update its value in the
function rematch:LevelingPanelOnTextChanged()
	rematch:HideTooltip()
	local value = self:GetText()
	local number = tonumber(value)
	if value:len()==0 or number then
		rematch.dialog.team.pets[self:GetID()] = number
	else
		self:SetText(rematch.dialog.team.pets[self:GetID()] or "")
	end
	self.clear:SetShown(value:len()>0)
end

function rematch:LevelingPanelCheckButtonOnClick()
	rematch.dialog.team.pets[self:GetID()] = self:GetChecked()
end

--[[ Import/Export ]]

function rematch:ShowExportDialog(teamName)

	local dialog = rematch:ShowDialog("ExportTeam",244,teamName,"",true)

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,teamName)

	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Press CTRL+C to copy this team to the clipboard."])
	dialog.text:Show()

	dialog.multiLine:SetPoint("TOP",dialog.text,"BOTTOM",0,-8)
	dialog.multiLine:Show()

	dialog.multiLine.editBox:SetText(rematch:ConvertTeamToString(teamName))
	dialog.multiLine.editBox:HighlightText(0)

	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.ExportOnTextChanged)

end

function rematch:ExportOnTextChanged()
	self:SetText(rematch:ConvertTeamToString(rematch.dialog.team.pets.teamName))
	self:HighlightText(0)
end

-- Name of team:npcID:S1:A1:A2:A3:S2:A1:A2:A3:S3:A1:A2:A3:
function rematch:ConvertTeamToString(teamName)
	local team = saved[teamName]
	local teamString = format("%s:%s:",teamName,team[4] or 0)
	for i=1,3 do
		local petID = team[i][1]
		if not petID or petID==rematch.emptyPetID then
			petID = 1 -- empty slot is "speciesID" 1
		elseif type(petID)=="number" then
			petID = petID -- already a speciesID, or 0 for leveling slot
		elseif team[i][5] then
			petID = team[i][5] -- a genuine petID should have speciesID in [5]
		else
			petID = 1
		end
		teamString = teamString..format("%d:%d:%d:%d:",petID,team[i][2],team[i][3],team[i][4])
	end
	return teamString
end

function rematch:ShowImportDialog()

	local dialog = rematch.dialog

	if dialog.name == "ImportTeam" then
		rematch:HideDialogs()
		return
	end

	rematch:ShowDialog("ImportTeam",244,L["Import Team"],"",rematch.ImportOrReceiveAccept)

	dialog.team:SetPoint("TOP",0,-24)
	rematch:WipePetFrames(dialog.team.pets)
	dialog.team:Show()

	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Press CTRL+V to paste a team from the clipboard."])
	dialog.text:Show()

	dialog.multiLine:SetPoint("TOP",dialog.text,"BOTTOM",0,-8)
	dialog.multiLine:Show()
	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.ImportOnTextChanged)

	if #settings.TeamGroups>1 then
		dialog.tabPicker:Show()
	end

	rematch:SetAcceptEnabled(false) -- initially accept button disabled
end

function rematch:ImportOrReceiveAccept()
	local dialog = rematch.dialog
	local teamName = dialog.team.pets.teamName
	if saved[teamName] then -- team already exists with this name, show save dialog to replace name
		dialog.teamNotLoaded = true
		rematch:ShowSaveDialog()
	else
		rematch:SaveTeamFromPetFrames(dialog.team.pets)
		rematch:UpdateWindow()
		rematch:ScrollToTeam(teamName)
	end
end

function rematch:ImportOnTextChanged()
	local text = self:GetText()
	local dialog = rematch.dialog

	local team = rematch:ConvertStringToTeam(text)
	rematch:SetAcceptEnabled(team and true)

	dialog.header.text:SetTextColor(1,.82,0)
	dialog.warning:Hide()
	dialog:SetHeight(244)

	if team then
		rematch:FillPetFramesFromTeam(dialog.team.pets,team)
		if team[4] then
			dialog.header.text:SetTextColor(1,1,1)
		end
		dialog.header.text:SetText(teamName)
		dialog.prompt:SetText(L["Save this team?"])

		if saved[team.teamName] then
			dialog.warning:SetPoint("TOP",dialog.multiLine,"BOTTOM",0,-8)
			dialog.warning.text:SetText(L["A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."])
			dialog.warning:Show()
			dialog:SetHeight(268)
		end
	else
		dialog.header.text:SetText(L["Import As..."])
		rematch:WipePetFrames(dialog.team.pets)
		dialog.prompt:SetText("")
	end
end

-- fills teamTable with the team defined in teamString, returning the team as a table if it was valid
function rematch:ConvertStringToTeam(teamString)
	local t={{},{},{}}
	local teamName
	for i=1,3 do
		t[i]=t[i] or {}
		wipe(t[i])
	end
	teamName,t[4],t[1][1],t[1][2],t[1][3],t[1][4],t[2][1],t[2][2],t[2][3],t[2][4],t[3][1],t[3][2],t[3][3],t[3][4] = teamString:match("(.+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):")
	if teamName then
		for i=1,3 do
			-- convert all string matches to numbers
			for j=1,4 do
				t[i][j]=tonumber(t[i][j])
			end
			-- copy speciesID of actual species to [5]
			if t[i][1]>1 then
				t[i][5] = t[i][1]
			end
			-- convert petID's of 1 to 0x0000etc (emptyPetID)
			if t[i][1]==1 then
				t[i][1] = rematch.emptyPetID
			end
		end
		t[4]=t[4]~="0" and tonumber(t[4]) or nil
		rematch:ValidateTeam(t) -- fill out species IDs with petIDs
		t.teamName = teamName
		return t
	end
end

--[[ Send/Receive ]]

function rematch:ShowSendDialog(teamName,warning)
	local dialog = rematch:ShowDialog("SendTeamStart",200,teamName,L["Send this team?"],rematch.SendTeam)

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()

	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Who would you like to send this team to?"])
	dialog.text:Show()

	dialog.editBox:SetPoint("TOP",dialog.text,"BOTTOM",0,-4)
	dialog.editBox:Show()

	rematch:FillPetFramesFromTeam(dialog.team.pets,teamName)

	rematch:SetAcceptEnabled(false)
	dialog.editBox:SetScript("OnTextChanged",rematch.SendOnTextChanged)

	if warning then
		dialog:SetHeight(220)
		dialog.warning:SetPoint("TOP",dialog.editBox,"BOTTOM",0,-4)
		dialog.warning.text:SetText(warning)
		dialog.warning:Show()
		dialog.editBox:SetText(dialog.teamRecipient)
	end

	dialog.teamRecipient = nil
	dialog.teamName = teamName
end

function rematch:SendOnTextChanged()
	local recipient = self:GetText()
	rematch.dialog.teamRecipient = recipient
	rematch:SetAcceptEnabled(recipient:len()>0)
end

function rematch:ShowSendPendingDialog(success)

	local dialog = rematch.dialog

	rematch:ShowDialog("SendTeamPending",128,dialog.teamName,success and L["Team received!"] or L["Sending..."],success and true)

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,dialog.teamName)

	if not success then
		dialog.accept:Hide()
	end

	return dialog
end

-- sends message to receiver, via bnet if possible, regular SendAddonMessage otherwise
function rematch:SendMessage(message,receiver)

	local dialog = rematch.dialog
	receiver = receiver:lower()

	if settings.UseBNet then
		for i=1,BNGetNumFriends() do
			local presenceID, _, battleTag, isBattleTagPresence, _, _, _, isOnline = BNGetFriendInfo(i)
			if isOnline and isBattleTagPresence then
				local name=battleTag:match("(.+)#%d+")
				if name:lower()==receiver then
					BNSendGameData(presenceID,"Rematch",message)
					return
				end
			end
		end
	end

	SendAddonMessage("Rematch",message,"WHISPER",receiver)
end

function rematch:SendTeam()
	local dialog = rematch:ShowSendPendingDialog()

	dialog.runOnHide = rematch.StopSend

	local teamString = rematch:ConvertTeamToString(dialog.teamName)
	if teamString then
		rematch:StartTimer("SendTimeout",5,rematch.SendTimeout)
		rematch:RegisterEvent("CHAT_MSG_SYSTEM")
		-- otherwise send by normal SendAddonMessage
		rematch:SendMessage(teamString,dialog.teamRecipient)
	end

end

function rematch:StopSend()
	rematch:UnregisterEvent("CHAT_MSG_SYSTEM")
	rematch:StopTimer("SendTimeout")
end

function rematch:SendTimeout()
	rematch:StopSend()
	rematch:SendFailed(L["No response. Lag or no Rematch?"])
end

function rematch:SendFailed(reason)
	rematch:StopSend()
	rematch:ShowSendDialog(rematch.dialog.teamName,reason)
end

function rematch.events.CHAT_MSG_SYSTEM(message)
	if message==format(ERR_CHAT_PLAYER_NOT_FOUND_S,rematch.dialog.teamRecipient) then
		rematch:SendFailed(L["They do not appear to be online."])
	end
end

function rematch.events.BN_CHAT_MSG_ADDON(prefix,message,_,senderPresenceID)
	if prefix=="Rematch" then
		local _,_,battleTag = BNGetFriendInfoByID(senderPresenceID)
		rematch:HandleReceivedMessage(message,(battleTag or ""):match("(.+)#%d+"))
	end
end

function rematch.events.CHAT_MSG_ADDON(prefix,message,_,sender)
	if prefix=="Rematch" then
		rematch:HandleReceivedMessage(message,sender)
	end
end

function rematch:HandleReceivedMessage(message,sender)

	if message=="ok" then
		rematch:StopSend()
		rematch:ShowSendPendingDialog(true)
	elseif message=="busy" then
		rematch:SendFailed(L["They're busy. Try again later."])
	elseif message=="combat" then
		rematch:SendFailed(L["They're in combat. Try again later."])
	elseif message=="block" then
		rematch:SendFailed(L["They have team sharing disabled."])
	else

		local dialog = rematch.dialog

		-- likely this is a team received, first check if user ready to receive a team
		if settings.DisableShare then
			rematch:SendMessage("block",sender)
		elseif InCombatLockdown() then
			rematch:SendMessage("combat",sender)
		elseif dialog:IsVisible() then
			rematch:SendMessage("busy",sender)
		else
			-- user appears ready to receive; now check if it's an actual team
			local team = rematch:ConvertStringToTeam(message)
			if team then
				-- it's an actual team, send back an ok
				rematch:SendMessage("ok",sender)

				if not rematch:IsVisible() then
					rematch:Toggle() -- show rematch if it's not already on screen
				end

				-- and show receive dialog
				rematch:ShowDialog("ReceiveTeam",170,L["Incoming Rematch Team"],L["Save this team?"],rematch.ImportOrReceiveAccept)

				dialog.text:SetSize(220,42)
				dialog.text:SetPoint("TOP",0,-18)
				dialog.text:SetText(format(L["\124cffffd200%s\124r has sent you a team named \124cffffd200\"%s\"\124r"],sender,team.teamName))
				dialog.text:Show()

				dialog.team:SetPoint("TOP",dialog.text,"BOTTOM",0,-4)
				dialog.team:Show()
				rematch:FillPetFramesFromTeam(dialog.team.pets,team)

				if #settings.TeamGroups>1 then
					dialog.tabPicker:Show()
				end

				if saved[team.teamName] then
					dialog.warning:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
					dialog.warning.text:SetText(L["A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."])
					dialog.warning:Show()
					dialog:SetHeight(196)
				end

			end

		end
	end
end

-- used in main.lua for returning a team table to pass to save dialog
-- if noLeveling is passed, then leveling pets are defined as themselves
function rematch:CreateTeamFromCurrent(targetName,targetNpcID,noLeveling)
	local team = {teamName=L["New Team"]}
	for i=1,3 do
		team[i] = {C_PetJournal.GetPetLoadOutInfo(i)}
		if rematch:IsPetLeveling(team[i][1]) and not noLeveling then -- if loadout pet is leveling
			for j=1,4 do
				team[i][j] = 0 -- then fill its fields with 0's
			end
		end
	end
	local teamName = targetName or settings.loadedTeamName
	if teamName then
		team.teamName = teamName
		team[4] = targetNpcID
	end
	if saved[teamName] then -- if team already exists,
		team[4] = team[4] or saved[teamName][4] -- passed targetNpcID takes priority
		for i=7,10 do -- copy minHP,allowMM,maxXP and expected of saved team (skipping tab and notes) MAX_TEAM_FIELDS is 10
			team[i] = saved[teamName][i]
		end
	end
	return team
end

-- checkbox to save pets as themselves
function rematch:LevelingPanelSaveAsThemselvesOnClick()
	local dialog = rematch.dialog
	local teamName = dialog.team.pets.teamName
	local npcID = dialog.team.pets[4]
	local team = rematch:CreateTeamFromCurrent(teamName,npcID,self:GetChecked())
	dialog.levelingPanel.minHP:SetText("")
	dialog.levelingPanel.allowMM:SetChecked(false)
	dialog.levelingPanel.maxXP:SetText("")
	rematch:FillPetFramesFromTeam(dialog.team.pets,team)
end
