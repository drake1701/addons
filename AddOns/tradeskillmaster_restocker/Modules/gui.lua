-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0")

-- loads the localization table --
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Restocker") 
local private = {data={}, ignore={}}

--- Define the Frames and Setup Events
function GUI:OnEnable()
	private.frame = private:CreateRestockFrame()
	TSMAPI:CreateEventBucket("BAG_UPDATE", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("UPDATE_TRADESKILL_RECAST", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("UNIT_SPELLCAST_SUCCEEDED", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("UPDATE_PENDING_MAIL", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("AUCTION_OWNED_LIST_UPDATE", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("NEW_AUCTION_UPDATE", function() private:UpdateST() end, 10)
	TSMAPI:CreateEventBucket("AUCTION_HOUSE_SHOW", function() GUI:AutoShowFrame() end, 1)
	TSMAPI:CreateEventBucket("AUCTION_HOUSE_CLOSED", function() GUI:OnCloseClick() end, 1)
	TSMAPI:CreateTimeDelay("RestockSTUpdate", 1, function() private:UpdateST() end)
end


private.hidden = true -- Start with the frame hidden, this bit will track that
private.ManualClosed = false -- The users didn't close it. This tracks that to not reopen once manually closed
function GUI:ShowFrame()
	private.hidden = nil
	private:UpdateST(true)
end

-- If the users does /tsm restock, we need to reset the ManualClosed bit as the GUI should now
-- follow the openWithAH rules.
function GUI:SlashShow()
	private.ManualClosed = false
	GUI:ShowFrame()
end


private.AHFrame_Showing = false -- track if the AH is showing.
function GUI:AutoShowFrame() -- Triggered when the AH opens.
	local playerName, playerRealm = UnitName('player')
	local StayHidden = false
	--Check to see if the current character has been added to the list of
	-- characters Restocker should not open automatically for.
	for name, keep_hidden in pairs(TSM.db.global.ignoreCharacters) do 
		if playerName == name then
			StayHidden = keep_hidden
		end
	end

	private.AHFrame_Showing = true 
	if StayHidden == false then private.hidden = nil end
	if private.ManualClosed == true then private.hidden=true end
	private:UpdateST(true)
end

-- Simple rounding function.
local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num*mult+0.5)/mult
end

-- Triggered when the AH closes.
function GUI:OnCloseClick()
	local StayHidden = false
	private.AHFrame_Showing = false
	for name, keep_hidden in pairs(TSM.db.global.ignoreCharacters) do 
		if playername == name then
			StayHidden = keep_hidden
		end
	end
	if StayHidden == false then private.hidden = true end	private.frame:Hide()
end

--Enable Item tooltips
local function ItemOnEnter(_, data, col)
	local link = select(2, TSMAPI:GetSafeItemInfo(data.itemString))
	if link then
		GameTooltip:SetOwner(col, "ANCHOR_LEFT")
		TSMAPI:SafeTooltipLink(link)
		GameTooltip:Show()
	end
end
local function ItemOnLeave(_, data)
	GameTooltip:Hide()
end

--------------------------
-- Quickly check to see if the entry ELEMENT is present in an input table. Returns true of false.
--------------------------
local function grouplistContains(table, element)
	for _, value in pairs(table) do 
		if value == element then 
			return true
		end
	end
	return false
end


function private:CreateRestockFrame()

	---------------------------------------	
	-- Setup the main Frame
	--------------------------------------
	local function OnFrameShow(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", UIParent, unpack(TSM.db.global.framePosition))
	end
	
	local frame = CreateFrame("Frame")
	frame:Hide()
	frame:SetFrameStrata("HIGH")
	frame:SetHeight(220)
	frame:SetWidth(500)
	frame:SetScale(UIParent:GetScale())
	frame:SetPoint("CENTER", UIParent, 0, 200)
	frame:EnableMouse(true)
	frame:SetMovable(true)

	frame:SetScript("OnMouseDown", frame.StartMoving)
	frame:SetScript("OnMouseUp", function(...) frame.StopMovingOrSizing(...) TSM.db.global.framePosition = {frame:GetLeft(), frame:GetBottom()} end)
	TSMAPI.Design:SetFrameBackdropColor(frame)
	frame:SetScript("OnShow", OnFrameShow)
	frame:Hide()
	
	---------------------------------------	
	-- Do some setup for the group frame
	--------------------------------------
	local groupFrame = CreateFrame("Frame") -- for group list window
	groupFrame:Hide()
	groupFrame:SetFrameStrata("HIGH")
	groupFrame:SetHeight(400)
	groupFrame:SetWidth(300)
	groupFrame:SetScale(UIParent:GetScale())
	groupFrame:SetPoint("CENTER", UIParent, 0, 200)
	groupFrame:EnableMouse(true)
	groupFrame:SetMovable(true)
	groupFrame:SetScript("OnMouseDown", groupFrame.StartMoving)
	groupFrame:SetScript("OnMouseUp", function(...) groupFrame.StopMovingOrSizing(...) end)
	TSMAPI.Design:SetFrameBackdropColor(groupFrame)
	groupFrame:Hide()
	

	------------------------------------------------------------------
	-- Create a button that will create an extra frame that stores a group tree
	-- for users to quickly configure what items they want
	------------------------------------------------------------------
	local groupBtn = TSMAPI.GUI:CreateButton(frame, 18)
	groupBtn:SetPoint("TOPRIGHT", -35, -3)
	groupBtn:SetWidth(120)
	groupBtn:SetHeight(19)
	groupBtn:SetText(L["Toggle groups"])
	groupBtn:SetScript("OnClick", function()
		groupFrame:Show()
	end)

	
	-----------------------------
	-- Setup the GroupFrame
	-----------------------------

	local groupTitle = TSMAPI.GUI:CreateLabel(groupFrame)
	groupTitle:SetText(L["Select Groups to Show"])
	groupTitle:SetPoint("TOPLEFT")
	groupTitle:SetHeight(20)
	
	local groupCloseBtn = TSMAPI.GUI:CreateButton(groupFrame, 18)
	groupCloseBtn:SetPoint("TOPRIGHT", -3, -3)
	groupCloseBtn:SetWidth(19)
	groupCloseBtn:SetHeight(19)
	groupCloseBtn:SetText("X")
	groupCloseBtn:SetScript("OnClick", function()
		groupFrame:Hide()
	end)
	TSMAPI.GUI:CreateHorizontalLine(groupFrame, -23)

	local groupline = TSMAPI.GUI:CreateVerticalLine(groupFrame, 0)
	groupline:ClearAllPoints()
	groupline:SetPoint("TOPRIGHT", -25, -1)
	groupline:SetWidth(2)
	groupline:SetHeight(22)
	
	
	local stContainer = CreateFrame("Frame", nil, groupFrame)
	stContainer:SetPoint("TOPLEFT", 3, -30)
	stContainer:SetPoint("BOTTOMRIGHT")
	TSMAPI.Design:SetFrameColor(stContainer)
	frame.groupTree = TSMAPI:CreateGroupTree(stContainer, "Restocker", "Restocker_GroupList")
	
	
	
	----------------------------------------------------------
	-- Now back to the main Restocker Frame
	----------------------------------------------------------
	local title = TSMAPI.GUI:CreateLabel(frame)
	title:SetText("TSM_Restocker")
	title:SetPoint("TOPLEFT")
	title:SetHeight(20)
	
	
	local line = TSMAPI.GUI:CreateVerticalLine(frame, 0)
	line:ClearAllPoints()
	line:SetPoint("TOPRIGHT", -25, -1)
	line:SetWidth(2)
	line:SetHeight(22)
	
	local closeBtn = TSMAPI.GUI:CreateButton(frame, 18)
	closeBtn:SetPoint("TOPRIGHT", -3, -3)
	closeBtn:SetWidth(19)
	closeBtn:SetHeight(19)
	closeBtn:SetText("X")
	closeBtn:SetScript("OnClick", function()
		private.hidden = true
		private.ManualClosed = true
		TSM:Printf(L["You have manually closed the TSM Restocker window. It will remain closed for the rest of this session or until you open it manually with /tsm rest."])
		frame:Hide()
		groupFrame:Hide()
	end)

	
	TSMAPI.GUI:CreateHorizontalLine(frame, -23)
	
	local stContainer = CreateFrame("Frame", nil, frame)
	stContainer:SetPoint("TOPLEFT", 0, -25)
	stContainer:SetPoint("BOTTOMRIGHT", 0, 30)
	TSMAPI.Design:SetFrameColor(stContainer)
		

	local stCols = {
		{
			name = L["Item"],
			width = 0.3,
		},
		{
			name = L["Stock"],
			width = 0.15,
			align = "CENTER",
		},
		{
			name = L["Deficit"], 
			width = 0.1, 
			align = "CENTER"
		},
		{
			name = L["Avgbuy"], 
			width = 0.15, 
			align = "CENTER"
		},
		{	name = L["Price"], 
			width = 0.15, 
			align = "CENTER"
		},
		{
			name="%",
			width=0.15,
			align="CENTER"
		}
		
	}
	local handlers = {
		OnEnter = ItemOnEnter, OnLeave = ItemOnLeave,
		OnClick = function(_,data, self)
			if private.AHFrame_Showing == true then 
				if TSMAPI:AHTabIsVisible("Shopping") then
					TSMAPI:ModuleAPI("Shopping", "runSearch", TSMAPI:GetSafeItemInfo(data.itemString) .. "/exact", ShoppingCallback)
				else 
					TSM:Printf(L["Please switch to the Shopping Tab to perform the search."])
				end
			else
				TSM:Printf(L["The Auction House doesn't appear to be open. Please (re-)open it to search."])
			end
		end,

		
	}
	local st = TSMAPI:CreateScrollingTable(stContainer, stCols, handlers, 12)
	st:SetData({})
	st:DisableSelection(true)
	st:EnableSorting(true, -3)
	frame.st = st
	
	local updateBtn = TSMAPI.GUI:CreateButton(frame, 14, "TSMRestockUpdate", true)
	updateBtn:SetPoint("BOTTOMLEFT", 3,3)
	updateBtn:SetPoint("BOTTOMRIGHT", -3, 3)
	updateBtn:SetHeight(20)
	updateBtn:SetText(L["Update Restock"])
	updateBtn:SetScript("OnClick", function()
		private:UpdateST()
	end)
	frame.updateBtn = updateBtn
	return frame
end

--Given an itemID, find the max restock quantity from the Restocker operation
local function FindItemQuantity(itemId)
	local ops = TSMAPI:GetItemOperation(TSMAPI:GetItemString(itemId), "Restocker")
	local maxquantity = -1
	if (ops) then
		for _, operationName in pairs(ops) do
			TSMAPI:UpdateOperation("Restocker", operationName)
			maxquantity = TSM.operations[operationName].maxquantity
			break
		end
	end
	return maxquantity
end

-- Check to see if a given Restocker operation has a user-defined
-- price string. If not, use the global default
local function FindItemPriceSource(itemId)
	local ops = TSMAPI:GetItemOperation(TSMAPI:GetItemString(itemId), "Restocker")
	local PriceSource = TSM.db.global.globalPriceSource
	if (ops) then
		for _, operationName in pairs(ops) do
			TSMAPI:UpdateOperation("Restocker", operationName)
			if TSM.operations[operationName].PriceSource then
				PriceSource = TSM.operations[operationName].PriceSource
			end
			break
		end
	end
	return PriceSource
end


local isDelayed
function private:UpdateST(forceShow)
	if private.hidden then return end
	if (not private.frame or not private.frame:IsVisible()) and not forceShow and not isDelayed then
		TSMAPI:CreateTimeDelay("RestockUpdateDelay2", 1, function() isDelayed = true private:UpdateST() isDelayed = nil end)
		return
	end
	if InCombatLockdown() then return end
	local stData = {}
	-- Fill in the stData
	
	-- Find the Restocking Operations
	local itemList = TSMAPI:GetModuleItems("Restocker")

	-- Find the currently selected groups
	groupList = {}
	for groups, _ in pairs(private.frame.groupTree:GetSelectedGroupInfo()) do 
		groupList[#groupList+1] =  TSMAPI:FormatGroupPath(groups, false)
	end


	
	for itemString in pairs(itemList) do 

		local grouppath = TSMAPI:FormatGroupPath(TSMAPI:GetGroupPath(itemString), false)
		if grouplistContains(groupList, grouppath) then
			local itemId = TSMAPI:GetItemID(itemString)
			if itemId then 
				local maxquantity = FindItemQuantity(itemId)
				local itemName, itemLink = GetItemInfo(itemId)
				local avgbuy = TSMAPI:GetItemValue(itemString, "avgBuy")
				local avgbuySort = avgbuy
				if not avgbuy then 
					avgbuySort = 0 
					avgbuy = '--'
				else
					avgbuy = TSMAPI:FormatTextMoney(avgbuy)
				end
			
				PriceSource = FindItemPriceSource(itemString)
				local func = TSMAPI:ParseCustomPrice(PriceSource)
				local minbuyout = func(itemString)
			
				local minbuyoutSort = minbuyout
				if not minbuyout then 
					minbuyoutSort = 0 
					minbuyout = '--'
				else 
					minbuyout = TSMAPI:FormatTextMoney(minbuyout)
				end
		
				local playerTotal, altTotal = TSMAPI:ModuleAPI("ItemTracker", "playertotal", itemString)
				local guildTotal = TSMAPI:ModuleAPI("ItemTracker", "guildtotal", itemString)
				local auctionTotal = TSMAPI:ModuleAPI("ItemTracker", "auctionstotal", itemString) or 0
				local currentstock = playerTotal + altTotal+guildTotal
				local stockstring = currentstock
				if auctionTotal > 0 then stockstring = currentstock .. " (" .. auctionTotal ..")" end
				local totalstock = currentstock + auctionTotal
				local deficit = max(maxquantity-totalstock, 0)
				local percentage = round(100.0*totalstock/max(maxquantity, 1), 1)
			
	
				-- Get the Color
				color = TSMAPI:GetAuctionPercentColor(150-percentage)
		
				if itemName then
					local row= {
						cols = {
							{
								value = itemLink,
								sortArg = itemName,
							},		
							{	
								value = color .. stockstring .."|r",
								sortArg = totalstock,
							},
							{
								value = color .. deficit .. "|r",
								sortArg = deficit,
							},
							{
								value = avgbuy,
								sortArg = avgbuySort,
							},
							{
								value =  minbuyout,
								sortArg = minbuyoutSort,
							},
							{ 
								value = color .. percentage .. "|r",
								sortArg = percentage,
							},
						},
						itemString = itemString,
						currentstock = totalstock,
						deficit = deficit,
						avgbuy = avgbuy,
						minbuyout = minbuyout,
					}	
				tinsert(stData, row)
				end
			end
		end
	end
		
	if (TSM.db.global.autoShow or forceShow) then
		private.frame:Show()
	end
	private.data = CopyTable(stData)
	private.frame.st:SetData(stData)
	
end
