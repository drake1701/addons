
--[[ Rematch menu functions ]]

-- These are the functions called when menus are shown and refreshed in the menu system

local _,L = ...
local rematch = Rematch
rematch.rmf = {}
local rmf = rematch.rmf
local menu = rematch.menu
local roster = rematch.roster
local settings, saved

function rematch:InitRMF()
	settings = RematchSettings
	saved = RematchSaved
end

-- helper function for populating slot with a petID, much like FillPetFramesFrometc does for teams
function rmf:FillDialogSlot(petID)
	local slot = Rematch.dialog.slot
	local icon,_,level = rematch:GetPetIDIcon(petID)
	slot.icon:SetTexture(icon)
	slot.petID = petID
	if level then
		slot.level:SetText(level)
		slot.level:Show()
		slot.levelBG:Show()
		if not settings.HideRarityBorders and type(petID)=="string" then
			local _,_,_,_,rarity = C_PetJournal.GetPetStats(petID)
	    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
			slot.border:SetVertexColor(r,g,b,1)
			slot.border:Show()
		end
	end
end

function rmf:PetName()
	local petID = menu.subject
	if not petID or petID==rematch.emptyPetID then
		return L["Empty Slot"]
	elseif type(petID)=="string" then
		local _,customName,_,_,_,_,_,realName = C_PetJournal.GetPetInfoByPetID(petID)
		return customName or realName
	else
		return (C_PetJournal.GetPetInfoBySpeciesID(petID))
	end
end

function rmf:MissingPet()
	return not menu.subject or menu.subject==rematch.emptyPetID or type(menu.subject)~="string"
end

function rmf:SummonOrDismissText()
	local petID = C_PetJournal.GetSummonedPetGUID()
	if menu.subject==petID then
		return PET_ACTION_DISMISS
	else
		return SUMMON
	end
end
function rmf:Summon()
	C_PetJournal.SummonPetByGUID(menu.subject)
end


--[[ Leveling ]]

function rmf:HideStartLeveling()
	return not rematch:PetCanLevel(menu.subject) or menu.subject==rematch:GetCurrentLevelingPet() or settings.QueueFullSort
end
function rmf:StartLeveling()
	rematch:StartLevelingPet(menu.subject)
end

function rmf:HideAddToQueue()
	return not rematch:PetCanLevel(menu.subject) or rematch:IsPetLeveling(menu.subject)
end
function rmf:AddToQueue()
	rematch:AddLevelingPet(menu.subject)
end

function rmf:HideStopLeveling()
	return not rematch:IsPetLeveling(menu.subject)
end
function rmf:StopLeveling()
	rematch:StopLevelingPet(menu.subject)
end

--[[ Queue ]]

function rmf:HideQueueMove()
	return settings.QueueSortOrder and true
end
function rmf:HideQueueMoveToTop()
	return (settings.QueueSortOrder and settings.QueueFullSort) and true
end
function rmf:AtTopOfQueue()
	return rematch:GetUnsortedQueuePosition(menu.subject)==1
end
function rmf:AtEndOfQueue()
	return rematch:GetUnsortedQueuePosition(menu.subject)==rematch:GetNumLevelingPets()
end
function rmf:ShinePet(index)
	local buttons = rematch.drawer.queue.list.scrollFrame.buttons
	for i=1,#buttons do
		if buttons[i].index==index then
			rematch:ShineOnYouCrazy(buttons[i],"CENTER",-14,0)
			return
		end
	end
end
function rmf:MoveToTop()
	rematch:StartLevelingPet(menu.subject)
end
function rmf:MoveToEnd()
	rematch:RemoveFromQueue(menu.subject)
	rematch:AddLevelingPet(menu.subject)
end
function rmf:MoveUp()
	local index = rematch:GetUnsortedQueuePosition(menu.subject)
	rematch:SwapQueuePositions(index,index-1)
	rematch:ListScrollToIndex(rematch.drawer.queue.list.scrollFrame,index-1)
	rmf:ShinePet(index-1)
end
function rmf:MoveDown()
	local index = rematch:GetUnsortedQueuePosition(menu.subject)
	rematch:SwapQueuePositions(index,index+1)
	rematch:ListScrollToIndex(rematch.drawer.queue.list.scrollFrame,index+1)
	rmf:ShinePet(index+1)
end

--[[ Current ]]

function rmf:HidePutLevelingPetHere()
	local slot = menu.arg1
	if type(slot)=="number" and slot>0 and slot<4 then
		local petID = C_PetJournal.GetPetLoadOutInfo(slot)
		return rematch:IsPetLeveling(petID)
	end
	return true
end
function rmf:PutLevelingPetHere()
	local slot = menu.arg1
	local petID = rematch:GetCurrentLevelingPet()
	if type(slot)=="number" and slot>0 and slot<4 and petID then
		-- go through the top 3 leveling picks
		for i=1,3 do
			local petID = rematch:GetLevelingPick(i)
			if petID then
				local found
				for j=1,3 do
					if C_PetJournal.GetPetLoadOutInfo(j)==petID then
						found = true
					end
				end
				-- if leveling pick not already loaded in a slot, load it and leave
				if not found then
					rematch:LoadPetSlot(slot,petID)
					return
				end
			end
		end
	end
end
function rmf:DisablePutLevelingPetHere()
	return not rematch:GetCurrentLevelingPet()
end

--[[ Browser pets ]]

function rmf:RenamePet()
	local petName = rmf:PetName()
	local dialog = rematch:ShowDialog("RenamePet",108,petName,L["Choose a name."],function(self) C_PetJournal.SetCustomName(menu.subject,rematch.dialog.editBox:GetText()) end)
	dialog:SetPoint("CENTER")

	local _,customName,_,_,_,_,_,realName = C_PetJournal.GetPetInfoByPetID(menu.subject)
	if customName then
		if not dialog.restore then
			dialog.restore = CreateFrame("Button",nil,dialog,"RematchToolbarButtonTemplate")
			rematch:RegisterDialogWidget("restore")
			dialog.restore.icon:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Undo")
			dialog.restore.tooltipTitle=L["Restore original name"]
			dialog.restore:SetScript("OnClick",function() C_PetJournal.SetCustomName(menu.subject,"") end)
		end
		dialog.restore.tooltipBody = realName
		dialog.restore:SetPoint("BOTTOMRIGHT",-54,2)
		dialog.restore:Show()
	end

	dialog.slot:SetPoint("TOPLEFT",16,-20)
	rmf:FillDialogSlot(menu.subject)
	dialog.slot:Show()

	dialog.editBox:SetPoint("LEFT",dialog.slot,"RIGHT",10,0)
	dialog.editBox:SetText(petName)
	dialog.editBox:SetScript("OnTextChanged",rematch.DialogEditBoxOnTextChanged)
	dialog.editBox:Show()
end

function rmf:FavoriteText()
	return C_PetJournal.PetIsFavorite(menu.subject) and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE
end
function rmf:FavoritePet()
	C_PetJournal.SetFavorite(menu.subject,C_PetJournal.PetIsFavorite(menu.subject) and 0 or 1)
end

function rmf:HideRelease()
	return rmf:MissingPet() or not C_PetJournal.PetCanBeReleased(menu.subject)
end
function rmf:ReleasePet()
	local dialog = rematch:ShowDialog("ReleasePet",130,rmf:PetName(),L["Release this pet?"],function() C_PetJournal.ReleasePetByID(menu.subject) end)
	dialog.slot:SetPoint("TOP",dialog,"TOP",0,-24)
	rmf:FillDialogSlot(menu.subject)
	dialog.slot:Show()
	dialog.warning.text:SetText(L["Once released, this pet is gone forever!"])
	dialog.warning:SetPoint("TOP",0,-66)
	dialog.warning:Show()
	dialog:SetPoint("CENTER")
end

function rmf:CageableText()
	return C_PetJournal.PetIsSlotted(menu.subject) and BATTLE_PET_PUT_IN_CAGE_SLOTTED or C_PetJournal.PetIsHurt(menu.subject) and BATTLE_PET_PUT_IN_CAGE_HEALTH or BATTLE_PET_PUT_IN_CAGE
end
function rmf:HideCageable()
	return rmf:MissingPet() or not C_PetJournal.PetIsTradable(menu.subject)
end
function rmf:DisableCageable()
	return C_PetJournal.PetIsSlotted(menu.subject) or C_PetJournal.PetIsHurt(menu.subject)
end
function rmf:CagePet()
	local dialog = rematch:ShowDialog("CagePet",108,rmf:PetName(),L["Cage this pet?"],function() C_PetJournal.CagePetByID(menu.subject) end)
	dialog.slot:SetPoint("TOP",dialog,"TOP",0,-24)
	rmf:FillDialogSlot(menu.subject)
	dialog.slot:Show()
	dialog:SetPoint("CENTER")
end

--[[ Browser filter ]]

function rmf:GetCollected()
	return not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED)
end
function rmf:SetCollected(value)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED,value)
end

function rmf:DisableOnlyFavorites()
	return C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED)
end

function rmf:GetNotCollected()
	return not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED)
end
function rmf:SetNotCollected(value)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED,value)
end

function rmf:GetUseTypeBar()
	return settings.UseTypeBar
end

function rmf:GetTypeFiltered()
	return not roster:IsTypeFilterClear(self.typeMode)
end
function rmf:GetTypes()
	return not roster:IsTypeFilterClear(self.typeMode) and roster:GetTypeFilter(self.typeMode,self.index)
end
function rmf:SetTypes(value)
	rematch.drawer.browser.typeMode = self.typeMode
	if not IsShiftKeyDown() then
		roster:SetTypeFilter(self.typeMode,self.index,value)
	else
		roster:ClearTypeFilter(self.typeMode)
		for i=1,10 do
			roster:SetTypeFilter(self.typeMode,i,i~=self.index)
		end
	end
end
function rmf:ResetTypes()
	if roster:IsTypeFilterClear(self.typeMode) then
		rematch:ClearAllTypeFilters()
	else
		roster:ClearTypeFilter(self.typeMode)
	end
	rematch.drawer.browser.typeMode = self.typeMode
end


function rmf:GetSource()
	return not roster:IsSourcesFilterClear() and roster:GetSourcesFilter(self.index)
end
function rmf:SetSource(value)
	if not IsShiftKeyDown() then
		roster:SetSourcesFilter(self.index,not value)
	else
		for i=1,10 do
			C_PetJournal.SetPetSourceFilter(i,i~=self.index)
		end
	end
end

function rmf:GetRarity()
	return roster:GetRarityFilter(self.index)
end
function rmf:SetRarity(value)
	if not IsShiftKeyDown() then
		roster:SetRarityFilter(self.index,value)
	else
		roster:ClearRarityFilter()
		for i=1,4 do
			roster:SetRarityFilter(i,i~=self.index)
		end
	end
end

function rmf:GetSort()
	return C_PetJournal.GetPetSortParameter()==self.index
end
function rmf:SetSort()
	C_PetJournal.SetPetSortParameter(self.index)
	rematch:UpdateBrowser()
end

function rmf:HighlightMenu()
	if type(self.arg)=="number" then
		return not roster:IsTypeFilterClear(self.arg)
	elseif type(self.arg)=="function" then
		return not self.arg()
	end
end

function rmf:GetMiscFilter()
	return roster:GetMiscFilter(self.var)
end
function rmf:SetMiscFilter(value)
	roster:SetMiscFilter(self.var,value)
end
function rmf:HideCanBattle()
	return settings.OnlyBattlePets
end

function rmf:HideLoadFilters()
	return not settings.savedFilters and true
end
function rmf:LoadFilters()
	roster:LoadFilters(settings.savedFilters)
	rematch:ShineOnYouCrazy(rematch.drawer.browser.filter)
end
function rmf:SaveFilters()
	if not settings.savedFilters then
		settings.savedFilters = {}
		roster:SaveFilters(settings.savedFilters)
		rematch:HideMenu()
--		rematch:ShowMenu("browserFilter","TOPLEFT",rematch.drawer.browser.filter,"TOPRIGHT",-6,8)
		rematch:ShineOnYouCrazy(rematch.drawer.browser.filter)
	else -- filters already saved, show a popup dialog
		rematch:HideMenu()
		local dialog = rematch:ShowDialog("SaveFilters",108,L["Save Filters"],"",function() settings.savedFilters=nil rmf:SaveFilters() end)
		dialog.slot.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_03")
		dialog.slot:SetPoint("TOPLEFT",12,-24)
		dialog.slot:Show()
		dialog.text:SetSize(180,80)
		dialog.text:SetPoint("LEFT",dialog.slot,"RIGHT",4,0)
		dialog.text:SetText(L["Do you want to overwrite the existing saved filters?"])
		dialog.text:Show()
		dialog.runOnHide = function() rematch:ShowMenu("browserFilter","TOPLEFT",rematch.drawer.browser.filter,"TOPRIGHT",-6,8) end
	end
end

--[[ The final menus ]]

-- main browser filter menu
menu.menus["browserFilter"] = {
	{ title=FILTER },
	{ text=COLLECTED, check=true, value=rmf.GetCollected, func=rmf.SetCollected },
	{ text=FAVORITES_FILTER, check=true, indent=8, disable=rmf.DisableOnlyFavorites, var="Favorite", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=NOT_COLLECTED, check=true, value=rmf.GetNotCollected, func=rmf.SetNotCollected },
	{ text=L["Current Zone"], check=true, var="CurrentZone", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=PET_FAMILIES, subMenu="browserPetTypes", arg=1, highlight=rmf.HighlightMenu },
	{ text=L["Strong Vs"], subMenu="browserStrongVs", arg=2, highlight=rmf.HighlightMenu },
	{ text=L["Tough Vs"], subMenu="browserToughVs", arg=3, highlight=rmf.HighlightMenu },
	{ text=SOURCES, subMenu="browserSources", arg=roster.IsSourcesFilterClear, highlight=rmf.HighlightMenu },
	{ text=RARITY, subMenu="browserRarity", arg=roster.IsRarityFilterClear, highlight=rmf.HighlightMenu },
	{ text=MISCELLANEOUS, subMenu="browserMisc", arg=roster.IsMiscFilterClear, highlight=rmf.HighlightMenu },
	{ text=RAID_FRAME_SORT_LABEL, subMenu="browserSort" },
	{ text=L["Load Filters"], hide=rmf.HideLoadFilters, func=rmf.LoadFilters },
	{ text=L["Save Filters"], func=rmf.SaveFilters  },
	{ text=L["Reset All"], stay=true, func=rematch.ResetAllBrowserFilters },
	{ text=OKAY },
}

-- thee three type submenus
for mode,menuName in ipairs({"browserPetTypes","browserStrongVs","browserToughVs"}) do
	menu.menus[menuName] = {{}}
	for i=1,10 do
		tinsert(menu.menus[menuName],{ text=_G["BATTLE_PET_NAME_"..i], check=true, index=i, typeMode=mode, value=rmf.GetTypes, func=rmf.SetTypes, icon="Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[i] })
	end
	tinsert(menu.menus[menuName],{ text=L["Use Type Bar"], check=true, value=rmf.GetUseTypeBar, func=rematch.EnableTypeBar })
	tinsert(menu.menus[menuName],{ text=RESET, stay=true, typeMode=mode, func=rmf.ResetTypes })
end
menu.menus.browserPetTypes[1].title=PET_FAMILIES
menu.menus.browserStrongVs[1].title=L["Strong Vs"]
menu.menus.browserToughVs[1].title=L["Tough Vs"]

menu.menus["browserSources"] = {}
for i=1,10 do
	tinsert(menu.menus["browserSources"],{text=_G["BATTLE_PET_SOURCE_"..i], check=true, index=i, value=rmf.GetSource, func=rmf.SetSource})
end
tinsert(menu.menus["browserSources"],{text=RESET, stay=true, func=C_PetJournal.AddAllPetSourcesFilter})

menu.menus["browserRarity"] = {}
for i=1,4 do
	tinsert(menu.menus["browserRarity"],{text="\124c"..select(4,GetItemQualityColor(i-1)).._G["BATTLE_PET_BREED_QUALITY"..i], check=true, index=i, value=rmf.GetRarity, func=rmf.SetRarity})
end
tinsert(menu.menus["browserRarity"],{text=RESET, stay=true, func=roster.ClearRarityFilter})

menu.menus["browserSort"] = {
	{ text=NAME, radio=true, index=LE_SORT_BY_NAME, value=rmf.GetSort, func=rmf.SetSort },
	{ text=LEVEL, radio=true, index=LE_SORT_BY_LEVEL, value=rmf.GetSort, func=rmf.SetSort },
	{ text=RARITY, radio=true, index=LE_SORT_BY_RARITY, value=rmf.GetSort, func=rmf.SetSort },
	{ text=TYPE, radio=true, index=LE_SORT_BY_PETTYPE, value=rmf.GetSort, func=rmf.SetSort },
}

menu.menus["browserMisc"] = {
	{ text=L["Leveling"], radio=true, var="Leveling", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["Not Leveling"], radio=true, var="NotLeveling", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true },
	{ text=L["Tradable"], radio=true, var="Tradable", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["Not Tradable"], radio=true, var="NotTradable", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true, hidden=rmf.HideCanBattle },
	{ text=L["Can Battle"], radio=true, var="CanBattle", hide=rmf.HideCanBattle, value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["Can't Battle"], radio=true, var="CantBattle", hide=rmf.HideCanBattle, value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true },
	{ text=L["Only Level 25s"], radio=true, var="Level25", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["Without Any 25s"], radio=true, var="None25", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true },
	{ text=L["1 Pet"], radio=true, var="Qty1", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["2+ Pets"], radio=true, var="Qty2", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["3+ Pets"], radio=true, var="Qty3", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true },
	{ text=L["In a Team"], radio=true, var="InATeam", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ text=L["Not In a Team"], radio=true, var="NotInATeam", value=rmf.GetMiscFilter, func=rmf.SetMiscFilter },
	{ spacer=true },
	{ text=RESET, stay=true, func=roster.ClearMiscFilter },
}

menu.menus["current"] = {
	{ title=rmf.PetName },
	{ text=L["Start Leveling"], hide=rmf.HideStartLeveling, func=rmf.StartLeveling },
	{ text=L["Add to Leveling Queue"], hide=rmf.HideAddToQueue, func=rmf.AddToQueue },
	{ text=L["Stop Leveling"], hide=rmf.HideStopLeveling, func=rmf.StopLeveling },
	{ text=L["Put Leveling Pet Here"], hide=rmf.HidePutLevelingPetHere, disable=rmf.DisablePutLevelingPetHere, func=rmf.PutLevelingPetHere },
	{ text=rmf.SummonOrDismissText, hide=rmf.MissingPet, func=rmf.Summon },
	{ text=rmf.FavoriteText, hide=rmf.MissingPet, func=rmf.FavoritePet },
	{ text=CANCEL }
}

menu.menus["levelingSlot"] = {
	{ title=rmf.PetName },
	{ text=L["Stop Leveling"], hide=rmf.HideStopLeveling, func=rmf.StopLeveling },
	{ text=rmf.SummonOrDismissText, hide=rmf.MissingPet, func=rmf.Summon },
	{ text=rmf.FavoriteText, hide=rmf.MissingPet, func=rmf.FavoritePet },
	{ text=CANCEL }
}

menu.menus["levelingQueueList"] = {
	{ title=rmf.PetName },
	{ text=L["Stop Leveling"], hide=rmf.HideStopLeveling, func=rmf.StopLeveling },
	{ text=rmf.SummonOrDismissText, func=rmf.Summon },
	{ text=rmf.FavoriteText, hide=rmf.MissingPet, func=rmf.FavoritePet },
	{ text=L["Move to Top"], hide=rmf.HideQueueMoveToTop, disable=rmf.AtTopOfQueue, icon="Interface\\Buttons\\UI-MicroStream-Green", iconCoords={0.075,0.925,0.925,0.075}, func=rmf.MoveToTop },
	{ text=L["Move Up"], hide=rmf.HideQueueMove, disable=rmf.AtTopOfQueue, icon="Interface\\Buttons\\UI-MicroStream-Yellow", iconCoords={0.075,0.925,0.925,0.075}, stay=true, func=rmf.MoveUp },
	{ text=L["Move Down"], hide=rmf.HideQueueMove, disable=rmf.AtEndOfQueue, icon="Interface\\Buttons\\UI-MicroStream-Yellow", stay=true, func=rmf.MoveDown },
	{ text=L["Move to End"], hide=rmf.HideQueueMove, disable=rmf.AtEndOfQueue, icon="Interface\\Buttons\\UI-MicroStream-Green", func=rmf.MoveToEnd },
	{ text=OKAY },
}

menu.menus["browserPet"] = {
	{ title=rmf.PetName },
	{ text=L["Start Leveling"], hide=rmf.HideStartLeveling, func=rmf.StartLeveling },
	{ text=L["Add to Leveling Queue"], hide=rmf.HideAddToQueue, func=rmf.AddToQueue },
	{ text=L["Stop Leveling"], hide=rmf.HideStopLeveling, func=rmf.StopLeveling },
	{ text=rmf.SummonOrDismissText, hide=rmf.MissingPet, func=rmf.Summon },
	{ text=BATTLE_PET_RENAME, hide=rmf.MissingPet, func=rmf.RenamePet },
	{ text=rmf.FavoriteText, hide=rmf.MissingPet, func=rmf.FavoritePet },
	{ text=BATTLE_PET_RELEASE, hide=rmf.HideRelease, func=rmf.ReleasePet },
	{ text=rmf.CageableText, hide=rmf.HideCageable, disable=rmf.DisableCageable, func=rmf.CagePet },
	{ text=CANCEL },
}

function rmf:GetQueueSort()
	return settings.QueueSortOrder==self.index
end
function rmf:SetQueueSort(value)
	settings.QueueSortOrder = value and self.index
	rematch:SortOrderChanged()
end
function rmf:GetFullSort()
	return settings.QueueFullSort
end
function rmf:SetFullSort(value)
	settings.QueueFullSort = value
	rematch:SortOrderChanged()
end
function rmf:DisableFullSort()
	return not settings.QueueSortOrder
end
function rmf:GetQueueSkipDead()
	return settings.QueueSkipDead
end
function rmf:SetQueueSkipDead(value)
	settings.QueueSkipDead = value
	rematch:ProcessQueue()
end
function rmf:GetQueueNoPreferences()
	return settings.QueueNoPreferences
end
function rmf:SetQueueNoPreferences(value)
	settings.QueueNoPreferences = value
	rematch:ProcessQueue()
end

function rmf:FillQueue(more)
	local count = rematch:FillQueue(true,more)
	local padding = count>100 and 128 or count==0 and 80 or 0
	local dialog = rematch:ShowDialog("FillQueue",128+padding,L["Fill Queue"],"",function() rematch:FillQueue(nil,more) end)
	dialog.text:SetSize(200,64+padding)
	dialog.text:SetPoint("TOP",0,-20)
	dialog.text:SetText(format(L["This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"],count,count>100 and L["\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"] or count==0 and L["\nAll species with a pet that can level already have a pet in the queue.\n"] or ""))
	dialog.text:Show()
	dialog:SetPoint("CENTER")
end

function rmf:FillQueueMore()
	rmf:FillQueue(true)
end

function rmf:EmptyQueue()
	local dialog = rematch:ShowDialog("EmptyQueue",128,L["Empty Queue"],"",rematch.EmptyQueue)
	dialog.text:SetSize(180,64)
	dialog.text:SetPoint("TOP",0,-20)
	dialog.text:SetText(L["Are you sure you want to remove all pets from the leveling queue?"])
	dialog.text:Show()
	dialog:SetPoint("CENTER")
end

-- note: 1=ascending, 2=descending, 3=median, 4=type; 2 and 3 are switched for aesthetic reasons
menu.menus["levelingQueueFilter"] = {
	{ title = L["Queue"] },
	{ text=L["Sort Order:"], highlight=true, disable=true },
	{ text=L["Ascending"], icon="Interface\\Minimap\\Minimap-QuestArrow", radio=true, index=1, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Ascending"], tooltipBody=L["Sort all but the top-most pet from level 1 to level 25."] },
	{ text=L["Median"], icon="Interface\\Minimap\\ObjectIcons", iconCoords={0,0.125,0.125,0.25}, radio=true, index=3, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Median"], tooltipBody=L["Sort all but the top-most pet for levels closest to 10.5."] },
	{ text=L["Descending"], icon="Interface\\Minimap\\Minimap-QuestArrow", iconCoords={0.075,0.925,0.925,0.075}, radio=true, index=2, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Descending"], tooltipBody=L["Sort all but the top-most pet from level 25 to level 1."] },
	{ text=TYPE, icon="Interface\\Minimap\\ObjectIcons", iconCoords={0.5,0.625,0.5,0.625}, radio=true, index=4, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Type"], tooltipBody=L["Sort all but the top-most pet by their types."] },
	{ spacer=true },
	{ text=L["Full Sort"], disable=rmf.DisableFullSort, icon="Interface\\Minimap\\ObjectIcons", iconCoords={0.375,0.5,0.25,0.375}, check=true, value=rmf.GetFullSort, func=rmf.SetFullSort, tooltipTitle=L["Full Sort"], tooltipBody=L["Include even the top-most pet in the sort. This can cause the top-most pet to change as it gains xp or pets get added to the queue."] },
	{ spacer=true },
	{ text=L["Prefer Live Pets"], check=true, disable=rmf.GetQueueNoPreferences, value=rmf.GetQueueSkipDead, func=rmf.SetQueueSkipDead, tooltipTitle=L["Prefer Live Pets"], tooltipBody=L["When loading pets from the queue, skip dead pets and load living ones first."] },
	{ text=L["No Preferences"], check=true, value=rmf.GetQueueNoPreferences, func=rmf.SetQueueNoPreferences, tooltipTitle=L["No Preferences"], tooltipBody=L["Suspend all preferred loading of pets from the queue, except for pets that can't load."] },
	{ spacer=true },
	{ text=L["Fill Queue"], func=rmf.FillQueue, tooltipTitle=L["Fill Queue"], tooltipBody=L["Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."] },
	{ text=L["Fill Queue More"], func=rmf.FillQueueMore, tooltipTitle=L["Fill Queue More"], tooltipBody=L["Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."] },
	{ text=L["Empty Queue"], func=rmf.EmptyQueue, tooltipTitle=L["Empty Queue"], tooltipBody=L["Remove all leveling pets from the queue."] },
	{ spacer=true },
	{ text=RESET, stay=true, func=rematch.ClearQueueSort },
	{ text=OKAY },
}

menu.menus["dialogQueueMenu"] = {
	{ title = L["Queue"] },
	{ text=L["Sort Order:"], highlight=true, disable=true },
	{ text=L["Ascending"], icon="Interface\\Minimap\\Minimap-QuestArrow", radio=true, stay=false, index=1, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Ascending"], tooltipBody=L["Sort all but the top-most pet from level 1 to level 25."] },
	{ text=L["Median"], icon="Interface\\Minimap\\ObjectIcons", iconCoords={0,0.125,0.125,0.25}, radio=true, stay=false, index=3, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Median"], tooltipBody=L["Sort all but the top-most pet for levels closest to 10.5."] },
	{ text=L["Descending"], icon="Interface\\Minimap\\Minimap-QuestArrow", iconCoords={0.075,0.925,0.925,0.075}, radio=true, stay=false, index=2, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Descending"], tooltipBody=L["Sort all but the top-most pet from level 25 to level 1."] },
	{ text=TYPE, icon="Interface\\Minimap\\ObjectIcons", iconCoords={0.5,0.625,0.5,0.625}, radio=true, stay=false, index=4, value=rmf.GetQueueSort, func=rmf.SetQueueSort, tooltipTitle=L["Sort:\124cffffd200Type"], tooltipBody=L["Sort all but the top-most pet by their types."] },
	{ spacer=true },
	{ text=L["Full Sort"], disable=rmf.DisableFullSort, icon="Interface\\Minimap\\ObjectIcons", iconCoords={0.375,0.5,0.25,0.375}, check=true, stay=false, value=rmf.GetFullSort, func=rmf.SetFullSort, tooltipTitle=L["Full Sort"], tooltipBody=L["Include even the top-most pet in the sort. This can cause the top-most pet to change as it gains xp or pets get added to the queue."] },
	{ spacer=true },
	{ text=RESET, func=rematch.ClearQueueSort },
}

function rmf:GetTabName()
	return settings.TeamGroups[menu.subject][1]
end

function rmf:EditTab()
	local index = menu.subject
	if index and index>1 then
		rematch:SelectTeamTab(index)
		local group = settings.TeamGroups[index]
		rematch:ShowTeamTabEditDialog(index,group[1],group[2])
	end
end

function rmf:DeleteTab()
	local index = menu.subject
	if index and index>1 then
		rematch:SelectTeamTab(index)
		local group = settings.TeamGroups[index]
		rematch:ShowTeamTabDeleteDialog(index,group[1],group[2])
	end
end

function rmf:HideTabByIndexUpDown()
	return #settings.TeamGroups<3
end
function rmf:TabAtTop()
	return menu.subject<=2
end
function rmf:TabAtBottom()
	return menu.subject==#settings.TeamGroups
end
function rmf:MoveTabUp()
	rematch:SwapTeamTabs(menu.subject,menu.subject-1)
	rematch:SelectTeamTab(menu.subject-1)
	menu.subject = menu.subject-1
end
function rmf:MoveTabDown()
	rematch:SwapTeamTabs(menu.subject,menu.subject+1)
	rematch:SelectTeamTab(menu.subject+1)
	menu.subject = menu.subject+1
end

menu.menus["teamTab"] = {
	{ title=rmf.GetTabName },
	{ text=L["Edit"], func=rmf.EditTab },
	{ text=DELETE, func=rmf.DeleteTab },
	{ text=L["Move Up"], hide=rmf.HideTabByIndexUpDown, disable=rmf.TabAtTop, icon="Interface\\Buttons\\UI-MicroStream-Yellow", iconCoords={0.075,0.925,0.925,0.075}, stay=true, func=rmf.MoveTabUp },
	{ text=L["Move Down"], hide=rmf.HideTabByIndexUpDown, disable=rmf.TabAtBottom, icon="Interface\\Buttons\\UI-MicroStream-Yellow", stay=true, func=rmf.MoveTabDown },
	{ text=OKAY }
}

function rmf:GetTeamName()
	return menu.subject
end
function rmf:HideMoveMenu()
	if #settings.TeamGroups<2 then
		return true
	end
end

function rmf:DeleteTeam()
	local dialog = rematch:ShowDialog("DeleteTeam",128,rmf:GetTeamName(),L["Delete this team?"],rmf.DeleteAccept)
	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,menu.subject)
end
function rmf:DeleteAccept()
	if settings.loadedTeamName==menu.subject then
		settings.loadedTeamName = nil
		settings.loadedNpcID = nil
	end
	saved[menu.subject] = nil
	rematch:UpdateWindow()
end
function rmf:ExportTeam()
	rematch:ShowExportDialog(menu.subject)
end
function rmf:SendTeam()
	rematch:ShowSendDialog(menu.subject)
end
function rmf:RenameTeam()
	rematch:ShowRenameDialog(menu.subject)
end
function rmf:LoadTeam()
	rematch:LoadTeam(menu.subject)
end
function rmf:DisableSendTeam()
	return settings.DisableShare
end
function rmf:SetNotes()
	rematch:SetNotes(menu.subject)
end
function rmf:DeleteNotes()
	if saved[menu.subject] then
		if RematchNotesCard.teamName==menu.subject then
			RematchNotesCard:Hide()
		end
		saved[menu.subject][6] = nil
		if settings.loadedTeamName==menu.subject then
			rematch:UpdateWindow() -- main header+teamlist needs to remove notes icon
		elseif rematch.drawer.teams:IsVisible() then
			rematch:UpdateTeamList() -- just teamlist needs to remove notes icon
		end
	end
end
function rmf:HidePreferences()
	local team = saved[menu.subject]
	return not team or (team[1][1]~=0 and team[2][1]~=0 and team[3][1]~=0)
end
function rmf:SetPreferences()
	rematch:EditPreferences(menu.subject)
end

menu.menus["teamList"] = {
	{ title=rmf.GetTeamName, maxWidth=90 },
	{ text=L["Load"], tooltipTitle=L["Load Team"], tooltipBody=L["You can also double-click a team to load it."], func=rmf.LoadTeam },
	{ text=L["Rename"], func=rmf.RenameTeam },
	{ text=L["Set Notes"], func=rmf.SetNotes },
	{ text=L["Leveling Preferences"], hide=rmf.HidePreferences, func=rmf.SetPreferences },
	{ text=L["Move To"], subMenu="teamMove", hide=rmf.HideMoveMenu },
	{ text=L["Send"], func=rmf.SendTeam, disable=rmf.DisableSendTeam },
	{ text=L["Export"], func=rmf.ExportTeam },
	{ text=DELETE, func=rmf.DeleteTeam },
	{ text=CANCEL },
}

function rmf:DisableTabMove()
	local index = saved[menu.subject][5] or 1
	return settings.SelectedTab==self.index
end
function rmf:GetTabNameByIndex()
	return settings.TeamGroups[self.index][1]
end
function rmf:GetTabIconByIndex()
	return settings.TeamGroups[self.index][2]
end
function rmf:HideTabByIndex()
	return not settings.TeamGroups[self.index]
end
function rmf:MoveTeamToTab()
	saved[menu.subject][5] = self.index>1 and self.index or nil
	rematch:UpdateTeams()
end
function rmf:SelectTabIndex()
	rematch:SelectTeamTab(self.index)
	if rematch.dialog.tabPicker then
		rematch.dialog.tabPicker.icon:SetTexture(settings.TeamGroups[self.index][2])
	end
end
function rmf:HighlightPickerTab()
	local index = settings.SelectedTab or 1
	return index==self.index
end

-- sub-menu to move a team to another tab
menu.menus["teamMove"] = {}
for i=1,16 do
	tinsert(menu.menus["teamMove"],{ index=i, text=rmf.GetTabNameByIndex, icon=rmf.GetTabIconByIndex, hide=rmf.HideTabByIndex, disable=rmf.DisableTabMove, func=rmf.MoveTeamToTab })
end

-- menu to pick which tab to select
menu.menus["tabPicker"] = { { title=L["Save To"] } }
for i=1,16 do
	tinsert(menu.menus["tabPicker"], { index=i, text=rmf.GetTabNameByIndex, icon=rmf.GetTabIconByIndex, hide=rmf.HideTabByIndex, highlight=rmf.HighlightPickerTab, func=rmf.SelectTabIndex })
end

-- right-click menu for the notes buttons on team list and main header
menu.menus["manageNotes"] = {
	{ text=L["Set Notes"], func=rmf.SetNotes },
	{ text=L["Delete Notes"], func=rmf.DeleteNotes },
}
