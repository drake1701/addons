
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

function rematch:ShowSaveDialog(teamName,teamTable,npcID)

	local dialog = rematch.dialog

	if dialog.name == "SaveTeam" then
		rematch:HideDialogs()
		return
	end

	rematch:ShowDialog("SaveTeam",152,L["Save As..."],L["Save this team?"],rematch.SaveDialogAcceptOnClick)

	dialog.editBox:SetPoint("TOP",0,-20)
	dialog.editBox:SetText(teamName or L["New Team"])
	dialog.editBox:SetScript("OnTextChanged",rematch.SaveEditBoxOnTextChanged)
	dialog.editBox:Show()

	dialog.team:SetPoint("TOP",0,-48)
	dialog.team:Show()
	dialog.teamName = teamName
	dialog.npcID = npcID
	dialog.originalTeamName = teamName
	dialog.originalNpcID = npcID

	if teamTable then -- imports and received teams happen from a table
		rematch:FillPetFramesFromTeam(dialog.team.pets,teamTable)
	else -- the save button saves by team names
		rematch:FillPetFramesFromCurrent(dialog.team.pets)
		local loadedTeam = saved[settings.loadedTeamName]
	end

	-- tabPicker button appears if user has custom tabs defined--to choose where to save team
	if #settings.TeamGroups>1 then
		dialog.tabPicker:Show()
	end

	RematchTeamCard:Hide()

end

function rematch:UpdateSaveDialog()
	local dialog = rematch.dialog
	local warnOffset = dialog.warning:IsVisible() and 18 or 0
	dialog:SetHeight(152 + warnOffset)
	dialog.team:SetPoint("TOP",0,-48-warnOffset)
end

function rematch:SaveEditBoxOnTextChanged()
	local teamName = self:GetText()
	rematch:SetAcceptEnabled(teamName:len()>0)
	local dialog = self:GetParent()
	if teamName ~= dialog.originalTeamName then
		dialog.npcID = nil -- if name is changed, nil the npcID
	else
		dialog.npcID = dialog.originalNpcID
	end
	-- loadedTeamName is the loaded team; we need to account for new targeted npcIDs staying
	dialog.teamName = teamName
	if saved[teamName] and GetTime()~=dialog.timeShown then -- if name is same as an existing team
		dialog.warning.text:SetText(L["A team already has this name."])
		dialog.warning:SetPoint("TOP",0,-42)
		dialog.warning:Show()
	else
		dialog.warning:Hide()
	end
	rematch:UpdateSaveDialog()
end

-- fills pets frame from current loadout (save dialogs)
function rematch:FillPetFramesFromCurrent(pets)
	rematch:WipePetFrames(pets)
	local info = rematch.info
	for i=1,3 do
		info[1],info[2],info[3],info[4] = C_PetJournal.GetPetLoadOutInfo(i)
		if info[1] then
			if rematch:IsCurrentLevelingPet(info[1]) then
				pets[i].petID = 0
				pets[i].icon:SetTexture(rematch.levelingIcon)
				pets[i].leveling:Show()
			else
				pets[i].petID = info[1]
				local _,_,level,_,_,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(info[1])
				pets[i].icon:SetTexture(icon)
				if level and level<25 then
					pets[i].levelBG:Show()
					pets[i].level:SetText(level)
					pets[i].level:Show()
				end
				if not settings.HideRarityBorders and type(info[1])=="string" then
					local _,_,_,_,rarity = C_PetJournal.GetPetStats(info[1])
			    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
					pets[i].border:SetVertexColor(r,g,b,1)
					pets[i].border:Show()
				end
				for j=1,3 do
					if info[j+1] and info[j+1]>0 then
						pets[i].abilities[j].abilityID = info[j+1]
						pets[i].abilities[j].icon:SetTexture((select(3,C_PetBattles.GetAbilityInfoByID(info[j+1]))))
						pets[i].abilities[j].icon:Show()
					end
				end
			end
			pets[i].icon:Show()
		else
			pets[i].petID = rematch.emptyPetID
		end
	end
end

-- does the final save of a team
function rematch:SaveTeamFromPetFrames(teamName,npcID,pets)
	local notes
	if saved[teamName] then
		notes = saved[teamName][6] -- save notes if we're about to overwrite team
	end
	saved[teamName] = {}
	saved[teamName][6] = notes
	for i=1,3 do
		local petID = pets[i].petID or rematch.emptyPetID
		-- petID goes in [1]
		saved[teamName][i] = {petID}
		-- abilities goes in [2] through [4]
		for j=1,3 do
			saved[teamName][i][j+1] = pets[i].abilities[j].abilityID or 0
		end
		-- speciesID goes in [5]
		if type(petID)=="string" and petID~=rematch.emptyPetID then
			local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
			if speciesID then
				saved[teamName][i][5] = speciesID
			end
		elseif type(petID)=="number" and petID~=0 then
			saved[teamName][i][5] = petID
		end
	end
	if npcID then
		saved[teamName][4] = npcID
	end
	if settings.SelectedTab and settings.SelectedTab>1 then
		saved[teamName][5] = settings.SelectedTab
	end
end

function rematch:SaveDialogAcceptOnClick()
	local dialog = rematch.dialog
	local teamName = dialog.teamName
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
		if not dialog.teamNotLoaded then
			settings.loadedTeamName = teamName
			settings.loadedNpcID = npcID
		end
		rematch:SaveTeamFromPetFrames(teamName,npcID,dialog.team.pets)
		rematch:UpdateWindow()
		rematch:ScrollToTeam(teamName)
	end
end

function rematch:ShowReplaceDialog(teamName)

	local dialog = rematch.dialog

	if not saved[teamName] then
		return -- this can only be called from a dialog displaying a team that already exists
	end

	-- first copy the team in the prior dialog to dialog.backupTeam
	local backup = dialog.backupTeam
	for i=1,3 do
		wipe(backup[i])
		local petID = dialog.team.pets[i].petID
		backup[i][1] = petID
		for j=1,3 do
			backup[i][j+1] = dialog.team.pets[i].abilities[j].abilityID or 0
		end
	end

	-- now show the dialog (which wipes the contents of the team frames!)
	rematch:ShowDialog("ReplaceTeam",220,teamName,L["Overwrite this team?"],rematch.ReplaceApproved)

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()

	if not dialog.replace then
		dialog.replace = CreateFrame("Frame",nil,dialog,"RematchTeamTemplate")
		rematch:RegisterDialogWidget("replace")
		dialog.replace.arrow = dialog.replace:CreateTexture(nil,"ARTWORK")
		dialog.replace.arrow:SetSize(32,32)
		dialog.replace.arrow:SetPoint("BOTTOM",dialog.replace,"TOP",0,0)
		dialog.replace.arrow:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
	end
	dialog.replace:SetPoint("TOP",dialog.team,"BOTTOM",0,-32)
	dialog.replace:Show()

	-- old team is saved[teamName]
	rematch:FillPetFramesFromTeam(dialog.team.pets,saved[teamName])
	-- new team is backup saved at start of this function
	rematch:FillPetFramesFromTeam(dialog.replace.pets,backup)

	dialog.runOnHide = rematch.RestoreSaveInOneFrame
--rematch:ShowSaveDialog(teamName,teamTable,npcID)
-- when hitting cancel, show save dialog with dialog.teamName,backup,dialog.npcID

end

-- this is the runOnHide for the replace dialog
-- one frame after window hides, run RestoreSaveDialog if runOnHide still defined
function rematch:RestoreSaveInOneFrame()
	rematch:StartTimer("RestoreSaveDialog",0,rematch.RestoreSaveDialog)
end

-- unless the accept button is clicked (that nils the runOnHide), restore
-- the save dialog that spawned the replace dialog that hid last frame
function rematch:RestoreSaveDialog()
	local dialog = rematch.dialog
	if dialog.runOnHide then -- accept button wasn't hit (esc or cancel)
		rematch:ShowSaveDialog(dialog.teamName,dialog.backupTeam,dialog.npcID)
	end
end

-- accept was clicked, nil runOnHide and save the team for reals
function rematch:ReplaceApproved()
	local dialog = rematch.dialog
	dialog.runOnHide = nil
	if not dialog.teamNotLoaded then
		settings.loadedTeamName = dialog.teamName
		settings.loadedNpcID = dialog.npcID
	end
	rematch:SaveTeamFromPetFrames(dialog.teamName,dialog.npcID,dialog.replace.pets)
	rematch:UpdateWindow()
	rematch:ScrollToTeam(dialog.teamName)
end

--[[ Import/Export ]]

function rematch:ShowExportDialog(teamName)

	local dialog = rematch:ShowDialog("ExportTeam",244,teamName,"",true)

	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,saved[teamName])

	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Press CTRL+C to copy this team to the clipboard."])
	dialog.text:Show()

	dialog.multiLine:SetPoint("TOP",dialog.text,"BOTTOM",0,-8)
	dialog.multiLine:Show()

	dialog.multiLine.editBox:SetText(rematch:ConvertTeamToString(teamName))
	dialog.multiLine.editBox:HighlightText(0)

	dialog.teamName = teamName

	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.ExportOnTextChanged)

end

function rematch:ExportOnTextChanged()
	self:SetText(rematch:ConvertTeamToString(rematch.dialog.teamName))
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
	if saved[dialog.teamName] then
		dialog.teamNotLoaded = true
		rematch:ShowSaveDialog(dialog.teamName,dialog.backupTeam,dialog.npcID)
	else
		rematch:SaveTeamFromPetFrames(dialog.teamName,dialog.npcID,dialog.team.pets)
		rematch:UpdateWindow()
		rematch:ScrollToTeam(teamName)
	end
end

function rematch:ImportOnTextChanged()
	local text = self:GetText()
	local dialog = rematch.dialog

	local teamName = rematch:ConvertStringToTeam(text,dialog.backupTeam)
	rematch:SetAcceptEnabled(teamName and true)
	dialog.header.text:SetTextColor(1,.82,0)
	dialog.warning:Hide()
	dialog:SetHeight(244)

	if teamName then
		rematch:FillPetFramesFromTeam(dialog.team.pets,dialog.backupTeam)
		dialog.teamName = teamName
		dialog.npcID = dialog.backupTeam[4]
		if dialog.npcID then
			dialog.header.text:SetTextColor(1,1,1)
		end
		dialog.header.text:SetText(teamName)
		dialog.prompt:SetText(L["Save this team?"])

		if saved[teamName] then
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

-- fills teamTable with the team defined in teamString, returning the teamName if it was valid
function rematch:ConvertStringToTeam(teamString,teamTable)
	local t=teamTable
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
		return teamName
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
			local teamName = rematch:ConvertStringToTeam(message,dialog.backupTeam)
			if teamName then
				-- it's an actual team, send back an ok
				rematch:SendMessage("ok",sender)

				if not rematch:IsVisible() then
					rematch:Toggle() -- show rematch if it's not already on screen
				end

				-- and show receive dialog
				rematch:ShowDialog("ReceiveTeam",170,L["Incoming Rematch Team"],L["Save this team?"],rematch.ImportOrReceiveAccept)

				dialog.text:SetSize(220,42)
				dialog.text:SetPoint("TOP",0,-18)
				dialog.text:SetText(format(L["\124cffffd200%s\124r has sent you a team named \124cffffd200\"%s\"\124r"],sender,teamName))
				dialog.text:Show()

				dialog.team:SetPoint("TOP",dialog.text,"BOTTOM",0,-4)
				dialog.team:Show()
				dialog.teamName = teamName
				dialog.npcID = dialog.backupTeam[4]
				rematch:FillPetFramesFromTeam(dialog.team.pets,dialog.backupTeam)

				if #settings.TeamGroups>1 then
					dialog.tabPicker:Show()
				end

				if saved[teamName] then
					dialog.warning:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
					dialog.warning.text:SetText(L["A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."])
					dialog.warning:Show()
					dialog:SetHeight(196)
				end

			end

		end
	end
end