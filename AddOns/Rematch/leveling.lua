
local _,L = ...
local rematch = Rematch
local settings
local queue = rematch.drawer.queue

-- the unsorted leveling queue is settings.LevelingQueue
rematch.levelingPetsByID = {} -- for faster lookups, this is all pets in the queue indexed by petID
-- which is copied to sortedQueue and sorted if need be
rematch.sortedQueue = {}
rematch.levelingIcon = "Interface\\AddOns\\Rematch\\textures\\leveling.tga"

function rematch:InitLeveling()
	settings = RematchSettings

	queue.levelingSlot.icon:SetTexture(rematch.levelingIcon)
	queue.levelingSlot.leveling:Show()
	queue.levelingSlot.menu = "levelingSlot"
	queue.resultsBar.label:SetText(L["Queued:"])
	queue.filter.icon:SetTexture("Interface\\Icons\\INV_Misc_EngGizmos_30")
	queue.title.label:SetText(L["Leveling:"])
	queue.title.sortLabel:SetText(L["Sort:"])

	-- setup queue list scrollFrame
	local scrollFrame = queue.list.scrollFrame
	scrollFrame.update = rematch.UpdateQueueList
	HybridScrollFrame_CreateButtons(scrollFrame, "RematchQueueListButtonTemplate")
	scrollFrame.emptyCapture:RegisterForClicks("AnyUp")

	rematch:RegisterEvent("UPDATE_SUMMONPETS_ACTION")

end

function rematch:UpdateLeveling()
--	rematch:debugstack("UpdateLeveling")
	rematch:UpdateLevelingSlot()
	rematch:UpdateQueueList()
	rematch:UpdateQueueTitle()
	rematch:UpdateLevelingMarkers()
end

function rematch.events.UPDATE_SUMMONPETS_ACTION()
	local oldPetID = rematch:GetCurrentLevelingPet()
	rematch:ProcessQueue()
--	rematch:UpdateWindow() -- UpdateCurrentPets()
	local newPetID = rematch:GetCurrentLevelingPet()
	if oldPetID and newPetID and oldPetID~=newPetID then -- if leveling pet changes, toast new leveling pet
		rematch:ToastNextLevelingPet(newPetID)
	end
end

function rematch:LevelingQueueFilterButtonOnClick()
	if rematch:IsMenuOpen("levelingQueueFilter") then
		rematch:HideDialogs()
	else
		rematch:ShowMenu("levelingQueueFilter","TOPLEFT",self,"TOPRIGHT",-6,8)
	end
end

--[[ Leveling Pet System ]]

-- returns true if the petID is in the queue
function rematch:IsPetLeveling(petID)
	return petID and rematch.levelingPetsByID[petID]
end

-- returns true if the petID is the *current* leveling pet
function rematch:IsCurrentLevelingPet(petID)
	return petID and settings.CurrentLevelingPet==petID
end

-- returns the petID of the current leveling pet
function rematch:GetCurrentLevelingPet()
	return settings.CurrentLevelingPet
end

-- returns true if petID is below 25 and can battle
-- also returns pet's level (including partial level)
function rematch:PetCanLevel(petID)
	if petID and type(petID)=="string" and petID:match("^Battle") then
		local _,_,level,xp,maxXp,_,_,_,_,_,_,_,_,_,canBattle = C_PetJournal.GetPetInfoByPetID(petID)
		if level and level<25 and canBattle then
			return true,level+(xp/maxXp)
		end
	end
end

-- returns either the icon of the pet, or "interface\\addons\\rematch\\leveling.tga" if no leveling pet
function rematch:GetLevelingPetIcon()
	local petID = settings.CurrentLevelingPet
	local icon = petID and (select(9,C_PetJournal.GetPetInfoByPetID(petID))) or rematch.levelingIcon
	return icon
end

function rematch:GetNumLevelingPets()
	return #rematch.sortedQueue
end

-- returns the index in sortedQueue for the current leveling pet
function rematch:GetCurrentQueuePosition()
	local sorted = rematch.sortedQueue
	local petID = settings.CurrentLevelingPet
	for i=1,#sorted do
		if sorted[i]==petID then
			return i
		end
	end
end

-- returns position in unsorted queue of leveling pet (unsorted only!)
function rematch:GetUnsortedQueuePosition(petID)
	local rawQueue = settings.LevelingQueue
	for i=1,#rawQueue do
		if petID==rawQueue[i] then
			return i
		end
	end
end

--[[ Leveling Slot ]]

function rematch:UpdateLevelingSlot()
	local currentPetID = rematch:GetCurrentLevelingPet()
	local slot = rematch.drawer.queue.levelingSlot
	slot.petID = currentPetID
	slot.icon:SetTexture(rematch:GetLevelingPetIcon())
	if currentPetID then
		slot.level:SetText((select(3,C_PetJournal.GetPetInfoByPetID(currentPetID))))
	end
	local showLevel = currentPetID and true
	slot.levelBG:SetShown(showLevel)
	slot.level:SetShown(showLevel)
end

function rematch:LevelingSlotOnEnter()
	local cursorType,petID = GetCursorInfo()
	local canLevel = cursorType=="battlepet" and rematch:PetCanLevel(petID)
	if not rematch:GetCurrentLevelingPet() then
		if canLevel then
			return -- don't show helpplate (or floatingpetcard) if a pet that can level is over empty slot
		end
		HelpPlate_TooltipHide()
		HelpPlateTooltip.ArrowLEFT:Show()
		HelpPlateTooltip.ArrowGlowLEFT:Show()
		HelpPlateTooltip:SetPoint("RIGHT", self, "LEFT", -10, 0)
		HelpPlateTooltip.Text:SetText(L["This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the current leveling pet.\n\nWhen a team is saved with the current leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."])
		HelpPlateTooltip:Show()
	else
		if not canLevel and cursorType=="battlepet" then
			rematch:ShowTooltip(L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"],nil,true)
		end
		rematch:ShowFloatingPetCard(self.petID,self)
	end
end

function rematch:LevelingSlotOnLeave()
	HelpPlate_TooltipHide()
	rematch:HideFloatingPetCard()
	RematchTooltip:Hide()
end

function rematch:LevelingSlotOnReceiveDrag()
	local petID = rematch:GetCursorPetID()
	if rematch:PetCanLevel(petID) then
		rematch:StartLevelingPet(petID)
		ClearCursor()
	end
end


--[[ Queue ]]

function rematch:UpdateQueueList()
	local sortedQueue = rematch.sortedQueue
	local numData = #sortedQueue
	local scrollFrame = queue.list.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local lastButton
	local cursorType,petOnCursor = GetCursorInfo()
	petOnCursor = cursorType=="battlepet" and petOnCursor

	scrollFrame.stepSize = floor(scrollFrame:GetHeight()*.65)

	for i=1,min(#buttons,scrollFrame:GetHeight()/scrollFrame.buttonHeight+2) do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			button.petID = sortedQueue[index]
			button.index = index
			local petID = button.petID
			local onCursor = petOnCursor==petID
			local _,_,level,xp,maxXp,_,_,_,icon,petType = C_PetJournal.GetPetInfoByPetID(petID)
			if icon then
				local isSelected = button.petID==rematch:GetCurrentLevelingPet()
				button.icon:SetTexture(icon)
				button.level:SetText(level)
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
				if onCursor then
					button.rarity:SetGradientAlpha("VERTICAL",.4,.4,.4,.25,.4,.4,.4,.6)
				elseif isSelected then
					button.rarity:SetGradientAlpha("VERTICAL",1,.82,0,.75,r,g,b,.6)
				else
			    button.rarity:SetGradientAlpha("VERTICAL",r,g,b,.25,r,g,b,.6)
				end
				button.type:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
				button.icon:SetDesaturated(onCursor)
				button.type:SetDesaturated(onCursor)
			end
			button.selected:SetShown(button.petID and button.petID==rematch:GetCurrentLevelingPet())
			lastButton = button
			button:Show()
		else
			button.petID = nil
			button.index = nil
			button:Hide()
		end
	end

	queue.resultsBar.count:SetText(numData)

	HybridScrollFrame_Update(scrollFrame,28*numData,28)

	rematch:UpdateEmptyCapture()
end

-- used in resize and regular update
function rematch:UpdateEmptyCapture()
	local lastButton
	local scrollFrame = queue.list.scrollFrame
	for i=1,#scrollFrame.buttons do
		if scrollFrame.buttons[i]:IsVisible() then
			lastButton = scrollFrame.buttons[i]
		end
	end
	-- a scrollframe can't receive clicks/drags; this invisible button will capture clicks/drags to empty area of scrollframe
	local emptyCapture = scrollFrame.emptyCapture
	if not scrollFrame.scrollBar:IsEnabled() then
		if lastButton then
			emptyCapture:SetPoint("TOPLEFT",lastButton,"BOTTOMLEFT",0,0)
		else
			emptyCapture:SetPoint("TOPLEFT",scrollFrame,"TOPLEFT")
		end
		emptyCapture:Show()
	else
		emptyCapture:Hide()
	end
end


-- when pet dragged over QueueListButton (or capture area)
function rematch:QueueListOnEnter()
	if self and self.petID then
		rematch:ShowFloatingPetCard(self.petID,self)
	end
	local cursorType,petID = GetCursorInfo()
	if cursorType=="battlepet" then
		if settings.QueueSortOrder and rematch:IsPetLeveling(petID) then
			rematch:ShowTooltip(L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t The queue is sorted"],L["This pet is already in the queue. Pets can't move while the queue is sorted"],true)
			return -- can't reorder leveling pets while queue has a sort order
		elseif rematch:PetCanLevel(petID) then
			if settings.QueueSortOrder then
				rematch:ShowTooltip(L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t The queue is sorted"],L["This pet will be added to the end of the unsorted queue."],true)
			end
			queue.list.scrollFrame.insertLine.timer = 1 -- start immediately
			queue.list.scrollFrame.insertLine.parent = self
			queue.list.scrollFrame.insertLine:Show()
		else
			rematch:ShowTooltip(L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"],nil,true)
		end
	end
end

function rematch:QueueListOnLeave()
	rematch:HideFloatingPetCard()
	queue.list.scrollFrame.insertLine:Hide()
	RematchTooltip:Hide()
end

function rematch:QueueListOnDoubleClick(button)
	if rematch:IsCurrentLevelingPet(self.petID) then
		C_PetJournal.SummonPetByGUID(self.petID)
	else
		rematch:SetCurrentLevelingPet(self.petID)
		rematch:UpdateQueueList()
	end
	rematch:HideFloatingPetCard(true)
end

-- when pets in the queue receive a click/drag with a battlepet on the cursor
function rematch:QueueListOnReceiveDrag()
	local petID = rematch:GetCursorPetID()
	if petID then
		if GetMouseButtonClicked()=="RightButton" then
			ClearCursor()
			queue.list.scrollFrame.insertLine:Hide()
			RematchTooltip:Hide()
			return
		elseif rematch:PetCanLevel(petID) then
			if settings.QueueSortOrder and rematch:IsPetLeveling(petID) then
				return -- can't reorder queue when there's a sort order
			elseif self==queue.list.scrollFrame.emptyCapture or settings.QueueSortOrder then
				ClearCursor()
				rematch:AddLevelingPet(petID) -- emptyCapture click/drags always add to end of queue
				queue.list.scrollFrame.insertLine:Hide()
				RematchTooltip:Hide()
			else
				local index = queue.list.scrollFrame.insertLine.index
				if index then
					ClearCursor()
					rematch:InsertLevelingPet(petID,index) -- insert into the index derived by insertLine
					queue.list.scrollFrame.insertLine:Hide()
				end
			end
			rematch:UpdateLevelingMarkers()
		end
	end
end

function rematch:EmptyCaptureOnClick()
	local cursorPetID = rematch:GetCursorPetID()
	if cursorPetID then -- if pet on the cursor
		if button=="RightButton" then
			RematchTooltip:Hide()
			ClearCursor()
			return
		end
		rematch.QueueListOnReceiveDrag(self)
	end
end

-- insertLine's OnUpdate that moves the line to where a battlepet on cursor will insert into queue
-- queue.list.scrollFrame.insertLine.index will be the index in the queue to insert the pet
-- an index of -1 means to add it to the end
function rematch:QueueListInsertLineOnUpdate(elapsed)
	self.timer = self.timer + elapsed
	if self.timer>0.1 then
		self.timer = 0
		local parent = self.parent
		if parent==queue.list.scrollFrame.emptyCapture then
			self:SetPoint("CENTER",queue.list.scrollFrame.emptyCapture,"TOP")
			self.index = -1 -- add to end of queue
		elseif parent then
			local _,y = GetCursorPosition()
			local top,bottom = parent:GetTop(),parent:GetBottom()
			local center = (top+bottom)*parent:GetEffectiveScale()/2
			if y>center then -- battlepet on cursor goes to slot previous to mouseover
				if top<=queue.list.scrollFrame:GetTop() then
					self:SetPoint("CENTER",parent,"TOP")
				else -- if above top of scrollFrame, get it off screen (but still "visible" so OnUpdate runs)
					self:ClearAllPoints()
				end
				self.index = parent.index
			else -- battlepet on cursor goes to slot after the mouseover
				if bottom>queue.list.scrollFrame:GetBottom()-6 then
					self:SetPoint("CENTER",parent,"BOTTOM")
				else -- move off screen if below bottom of scrollFrame
					self:ClearAllPoints()
				end
				self.index = parent.index+1
			end
		else
			self:Hide()
		end
	end
end

--[[ Queue manipulation ]]

-- sets CurrentLevelingPet, swaps loadout if needed, updates slot
-- note: petID must already be in queue or it will do nothing!
-- use StartLevelingPet(petID) instead
function rematch:SetCurrentLevelingPet(petID)
	local oldLevelingPet = settings.CurrentLevelingPet
	if petID~=oldLevelingPet and rematch:IsPetLeveling(petID) then
		settings.CurrentLevelingPet = petID
		if petID then -- oldLevelingPet and
			local loadoutSlot
			for i=1,3 do
				local loadoutPetID = C_PetJournal.GetPetLoadOutInfo(i)
				if loadoutPetID==oldLevelingPet or rematch:IsPetLeveling(loadoutPetID) then
					loadoutSlot = i
					if loadoutPetID==oldLevelingPet then
						break -- this slot is old current leveling pet, ignore rest
					end
				end
			end
			if loadoutSlot then
				if not C_PetBattles.IsInBattle() and not InCombatLockdown() then
					rematch:LoadPetSlot(loadoutSlot,petID)
				else
					-- "Pet battle already in progress."
					local info = ChatTypeInfo["SYSTEM"] -- use user's system chat color
					print(format("\124cff%02x%02x%02x%s",info.r*255,info.g*255,info.b*255,ERR_PETBATTLE_IN_BATTLE))
					print(L["\124cffff8800The current leveling pet is in battle and can't be swapped."])
					settings.CurrentLevelingPet = oldLevelingPet
					return
				end
			end
		end
	elseif not petID then
		settings.CurrentLevelingPet = nil
	end
	rematch:UpdateLevelingSlot()
	rematch:NoteLastLevelingPet()
end

-- if petID not in queue, adds to top of queue; if in queue, selects
function rematch:StartLevelingPet(petID)
	if not rematch:IsPetLeveling(petID) and rematch:PetCanLevel(petID) then
		table.insert(settings.LevelingQueue,1,petID)
		rematch:ProcessQueue(true) -- light processing to prevent redundantly finding a current leveling pet
		rematch:UpdateLevelingMarkers()
	end
	rematch:SetCurrentLevelingPet(petID)
	if queue:IsVisible() then
		rematch:UpdateQueueList()
		rematch:ScrollToQueuePetID(petID)
	end
end

-- adds or moves petID to the end of the queue
function rematch:AddLevelingPet(petID)
	local rawQueue = settings.LevelingQueue
	if petID and rematch:PetCanLevel(petID) then
		if rematch:IsPetLeveling(petID) then
			for i=#rawQueue,1,-1 do
				if queue[i]==petID then
					table.remove(rawQueue,i)
				end
			end
		end
		table.insert(rawQueue,petID)
		rematch:ProcessQueue()
		rematch:UpdateLevelingMarkers()
		if queue:IsVisible() then
			rematch:ListScrollToBottom(queue.list.scrollFrame)
		end
	end
end

-- removes petID from the leveling queue
function rematch:StopLevelingPet(petID)
	if rematch:IsPetLeveling(petID) then
		local rawQueue = settings.LevelingQueue
		for i=#rawQueue,1,-1 do
			if rawQueue[i]==petID then
				table.remove(rawQueue,i)
			end
		end
		rematch:ProcessQueue()
		rematch:UpdateLevelingMarkers()
	end
end

-- inserts petID into the index slot in the leveling queue
function rematch:InsertLevelingPet(petID,index)
	if petID and rematch:PetCanLevel(petID) then
		local rawQueue = settings.LevelingQueue
		if rawQueue[index]==petID then
			return -- pet already there!
		end
		if index>#rawQueue then
			rematch:AddLevelingPet(petID) -- add to end of queue
			if petID==rematch:GetCurrentLevelingPet() then
				rematch:SetCurrentLevelingPet(rawQueue[1])
				rematch:ProcessQueue()
			end
			return
		end
		local queueSlot
		if rematch:IsPetLeveling(petID) then
			-- pet is in queue, we need to remove it from queue, but first find where it is in queue
			for i=1,#rawQueue do
				if rawQueue[i]==petID then
					queueSlot = i
					break
				end
			end
			if queueSlot<index then
				index = index - 1 -- and decrement index if it was in a slot we're about to remove
			end
			table.remove(rawQueue,queueSlot) -- remove from queue
		end
		table.insert(rawQueue,index,petID) -- insert into queue at index
		if index==1 then -- pets dragged to start also get set as current leveling pet
			rematch:SetCurrentLevelingPet(petID)
		end
		if queueSlot==1 and petID==rematch:GetCurrentLevelingPet() then
			rematch:SetCurrentLevelingPet(rawQueue[1])
		end
		rematch:ProcessQueue()
		rematch:UpdateLevelingMarkers()
	end
end

-- this should be called whenever pets can possibly change
-- validates queue, sorts if needed and chooses new leveling pet if none after validation
function rematch:ProcessQueue(lightProcessing)
	if InCombatLockdown() then
		rematch.queueNeedsProcessed = true -- in case a pet levels to 25 when we're in combat
		return
	end
	if select(2,C_PetJournal.GetNumPets())==0 then -- if pets not loaded, come back in half a second to try again
		rematch:StartTimer("PetsRanAwayFromQueue",0.5,rematch.ProcessQueue)
		return
	end

	local rawQueue = settings.LevelingQueue
	local hash = rematch.levelingPetsByID
	local sorted = rematch.sortedQueue

	-- rebuild levelingPetsByID and sortedQueue
	wipe(hash)
	wipe(sorted)
	for i=#rawQueue,1,-1 do
		local petID = rawQueue[i]
		local canLevel,level = rematch:PetCanLevel(petID)
		if canLevel and not hash[petID] then
			table.insert(sorted,1,petID)
			hash[petID] = i*100+level -- xxxyy.yy where xxx is raw queue index, yy.yy is pet level
		else
			table.remove(rawQueue,i)
		end
	end

	-- sort the queue. order 1=ascending, 2=descending, 3=median
	if settings.QueueSortOrder then
		table.sort(sorted,function(e1,e2)
			local order = settings.QueueSortOrder
			local hash = rematch.levelingPetsByID
			local level1 = hash[e1]%100
			local level2 = hash[e2]%100
			if order==3 then -- for median sort, levels are distance from 10.5
				level1 = abs(level1-10.5)
				level2 = abs(level2-10.5)
			end
			if level1==level2 then -- if levels are the same, return sort by their original queue index
				return floor(hash[e1]/100)<floor(hash[e2]/100)
			else
				if order==2 then -- if descending, higher levels first
					return level1>level2
				else -- if ascending or median, lower levels (or distance from 10.5) first
					return level1<level2
				end
			end
		end)
	end

	-- post-processing stuff goes here; lightProcessing for calling functions that will do a proper process later
	if not lightProcessing then

		-- if Auto Rotate enabled, look for a new leveling pet if current leveling pet has gained xp
		if settings.QueueAutoRotate then
			local currentPetID = settings.CurrentLevelingPet
			if rematch.lastLevelingPetID==currentPetID and hash[currentPetID] then -- if leveling pet is unchanged and still leveling
				local newLevelingPetLevel = hash[currentPetID]%100
				if newLevelingPetLevel > rematch.lastLevelingPetLevel then -- and it's gained xp since last visit
					local order = settings.QueueSortOrder
					if order==1 or order==3 then -- ascending or median: get top-most pet
						if sorted[1] then
							rematch:SetCurrentLevelingPet(sorted[1])
						end
					elseif order==2 or not order then -- descending or unsorted: get next pet
						local nextPetID	= sorted[(rematch:GetCurrentQueuePosition() or 0)%#sorted+1]
						if nextPetID then
							rematch:SetCurrentLevelingPet(nextPetID)
						end
					end
				end
			end
		end

		-- if current leveling pet is no longer leveling, set a new one
		if not rematch:IsPetLeveling(settings.CurrentLevelingPet) then
			rematch:SetCurrentLevelingPet(rawQueue[1])
		end

		-- update displayed list
		if queue:IsVisible() then
			rematch:UpdateQueueList()
		end

		rematch:NoteLastLevelingPet()

		rematch:UpdateCurrentLevelingBorders()

	end
end

-- called in both SetCurrentLevelingPet and ProcessQueue
-- notes the current leveling pet and its level for auto rotate purposes
function rematch:NoteLastLevelingPet()
	local petID = settings.CurrentLevelingPet
	if petID and rematch.levelingPetsByID[petID] then
		rematch.lastLevelingPetID = petID
		rematch.lastLevelingPetLevel = rematch.levelingPetsByID[petID]%100 or nil
	end
end

-- changes current leveling pet to the next or previous pet in the queue
function rematch:TraverseQueue(backward)
	rematch:DisableNavigatorButtons()
	if self.tooltipTitle then
		rematch.ShowTooltip(self) -- show tooltip again when buttons disabled
	end
	local dirOffset = backward and -2 or 0
	local index = ((rematch:GetCurrentQueuePosition() or 0)+dirOffset)%#rematch.sortedQueue+1
	local petID = rematch.sortedQueue[index]
	if petID then
		rematch:StartLevelingPet(petID)
	end
	if queue:IsVisible() then
		rematch:ListScrollToIndex(queue.list.scrollFrame,index)
	end
end

function rematch:SetNavigatorButtonState(button,state)
	button.icon:SetDesaturated(not state)
	local vertex = state and 1 or .5
	button.icon:SetVertexColor(vertex,vertex,vertex)
	button:SetEnabled(state)
end

-- these are the two prev/next buttons beneath the leveling pet in the current pets area
-- to prevent swapping too fast, the buttons are disabled for 0.3 seconds after being hit
function rematch:DisableNavigatorButtons()
	local nav = rematch.current.levelingNavigator
	rematch:SetNavigatorButtonState(nav.prev,false)
	rematch:SetNavigatorButtonState(nav.next,false)
	rematch:StartTimer("NavigateLeveling",0.3,rematch.EnableNavigatorButtons)
end

function rematch:EnableNavigatorButtons()
	local nav = rematch.current.levelingNavigator
	rematch:SetNavigatorButtonState(nav.prev,true)
	rematch:SetNavigatorButtonState(nav.next,true)
end

function rematch:ScrollToQueuePetID(petID)
	if queue:IsVisible() then
		local sortedQueue = rematch.sortedQueue
		for i=1,#sortedQueue do
			if sortedQueue[i]==petID then
				rematch:ListScrollToIndex(queue.list.scrollFrame,i)
				return
			end
		end
	end
end

function rematch:UpdateLevelingMarkers()
--	rematch:debugstack("UpdateLevelingMarkers")
	if rematch.drawer.browser:IsVisible() then
		if rematch.roster:GetMiscFilter("Leveling") then
			rematch:UpdateBrowser()
		else
			rematch:UpdateBrowserList()
		end
	end
	if PetJournal and PetJournal:IsVisible() then
		if PetJournalEnhanced then
			rematch.UpdateLevelingMarkersHook(PetJournalEnhancedListScrollFrame)
		else
			rematch.UpdateLevelingMarkersHook(PetJournalListScrollFrame)
		end
	end
end

function rematch:SortOrderChanged()
	rematch:ProcessQueue()
	if not settings.KeepCurrentOnSort then
		rematch:SetCurrentLevelingPet(rematch.sortedQueue[1])
	end
	rematch:UpdateQueueList()
	rematch:ListScrollToTop(queue.list.scrollFrame)
	rematch:UpdateQueueTitle()
end

function rematch:UpdateQueueTitle()
	local title = queue.title
	if not settings.QueueSortOrder and not settings.QueueAutoRotate then
		title.label:Show()
		title.sortLabel:Hide()
		title.sorted:Hide()
		title.rotate:Hide()
		title.clear:Hide()
	else
		title.label:Hide()
		title.sortLabel:Show()
		title.clear:Show()
		title.rotate:SetShown(settings.QueueAutoRotate)
		if settings.QueueSortOrder==1 then
			title.sorted:SetTexCoord(0.57812500,0.82812500,0.41406250,0.28906250)
		elseif settings.QueueSortOrder==2 then
			title.sorted:SetTexCoord(0.57812500,0.82812500,0.28906250,0.41406250)
		else
			title.sorted:SetTexCoord(0.29687500,0.54687500,0.28906250,0.41406250)
		end
		title.sorted:SetShown(settings.QueueSortOrder)
		if settings.QueueSortOrder and settings.QueueAutoRotate then
			title.rotate:SetPoint("LEFT",title.sorted,"RIGHT",-1,0)
		else
			title.rotate:SetPoint("LEFT",title.sortLabel,"RIGHT",-1,0)
		end
	end
end

function rematch:ClearQueueSortAndRotate()
	settings.QueueSortOrder = nil
	settings.QueueAutoRotate = nil
	rematch:SortOrderChanged()
end

-- adds one of each species listed in the browser (confirm dialog is in rmf)
function rematch:FillQueue(countOnly,fillMore)
	local roster = rematch.roster
	local rawQueue = settings.LevelingQueue
	local scratch = rematch.info
	rematch:ProcessQueue()
	roster:Update()
	wipe(scratch)
	-- count how many species to add
	local count = 0
	for i=1,roster:GetNumPets() do
		local petID = roster:GetPetByIndex(i)
		local speciesID,level,canBattle,_
		if type(petID)=="string" then -- owned pet
			speciesID, _, level, _, _, _, _, _, _, _, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petID)
			if rematch:IsPetLeveling(petID) then
				scratch[speciesID]=1
			elseif rematch:PetCanLevel(petID) and not scratch[speciesID] and (fillMore or not rematch.ownedSpeciesAt25[speciesID]) then
				if not countOnly then
					table.insert(rawQueue,petID)
				end
				count = count + 1
				scratch[speciesID]=1
			end
		end
	end

	if countOnly then
		return count
	end

	rematch:ProcessQueue()
	rematch:UpdateQueueList()
	rematch:UpdateLevelingMarkers()

	rematch:ShineOnYouCrazy(queue.resultsBar.count,"CENTER")
end

function rematch:EmptyQueue()
	wipe(settings.LevelingQueue)
	if not settings.KeepQueueSort then
		settings.QueueSortOrder = nil
		settings.QueueAutoRotate = nil
	end
	rematch:ProcessQueue()
	rematch:UpdateLeveling()
	rematch:ShineOnYouCrazy(queue.resultsBar.count,"CENTER")
end

-- does a "criterea" toast to alert that the leveling pet has changed
function rematch:ToastNextLevelingPet(petID)
	if settings.HidePetToast then
		return -- aww :(
	end
	local _,customName,_,_,_,_,_,realName,icon = C_PetJournal.GetPetInfoByPetID(petID)
	if icon then
    local frame = CriteriaAlertFrame_GetAlertFrame()
		if frame then
			local frameName = frame:GetName()
			_G[frameName.."Name"]:SetText(customName or realName)
			_G[frameName.."Unlocked"]:SetText(L["Next leveling pet:"])
	    _G[frameName.."IconTexture"]:SetTexture(icon)
	    frame.id = nil
	    AlertFrame_AnimateIn(frame)
      AlertFrame_FixAnchors()
			if not frame.rematchHide then
				-- add an OnHide secure hook to change "Unlocked" back to "Achievement Progress"
				frame.rematchHide = true
				frame:HookScript("OnHide",function(self) _G[self:GetName().."Unlocked"]:SetText(ACHIEVEMENT_PROGRESSED) end)
			end
		end
	end
end
