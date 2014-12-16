
-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Options = TSM:NewModule("Options", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

-- loads the localization table --
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Restocker")

----------------------------------------------------------
local function getHelpString1()
	return
	L["Restocker will show you a list of group items with assigned operations, your current stock, and your desired quantity. This can be a helpful tool to know if you should buy more (or even at a slightly higher price than normal."]
end

local function getHelpString2()
	return
	L["1) Select Operations on the left menu and type a name in the textbox labeled \"Operation Name\", hit okay."] .. "\n" ..
			L["2) You can delete an operation by selecting the operation and then under Operation Management click the button labelled \"Delete Operation\". "]
end

local function getHelpString3()
	return
	L["You can toggle the Restock UI by typing the command "] .. "/tsm restock "
end

function Options:Load(parent, operation, group)
	Options.treeGroup = AceGUI:Create("TSMTreeGroup")
	Options.treeGroup:SetLayout("Fill")
	Options.treeGroup:SetCallback("OnGroupSelected", function(...) Options:SelectTree(...) end)
	Options.treeGroup:SetStatusTable(TSM.db.global.TreeStatusOptions)
	parent:AddChild(Options.treeGroup)
	Options:UpdateTree()

	if operation then
		if operation == "" then
			Options.currentGroup = group
			Options.treeGroup:SelectByPath(3)
			Options.currentGroup = nil
		else
			Options.treeGroup:SelectByPath(3, operation)
		end
	else
		Options.treeGroup:SelectByPath(1)
	end
end

function Options:UpdateTree()
	local operationTreeChildren = {}
	
	for name in pairs(TSM.operations) do
		tinsert(operationTreeChildren, {value=name, text=name})
	end
	
	sort(operationTreeChildren, function(a, b) return a.value < b.value end)
	local treeGroups = {
		{value = 1, text=L["Help"]}, 
		{value = 2, text=L["Options"]},
		{value = 3, text=L["Operations"], children=operationTreeChildren},
	}
	
	Options.treeGroup:SetTree(treeGroups)
end

function Options:SelectTree(treeFrame, _, selection)
	treeFrame:ReleaseChildren()
	
	local major, minor = ("\001"):split(selection)
	major = tonumber(major)
	
	if major == 1 then
		Options:DrawHelpPage(treeFrame)
	elseif major ==2 then
		Options:LoadGeneralSettings(treeFrame)
	elseif minor then
		Options:ShowOperationsPage(treeFrame, minor)
	else
		Options:DrawNewOperation(treeFrame)
		
	end
end

function Options:DrawHelpPage(parent)

	local page = {
		{
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = "TSM_Restocking",
					children = {
						{
							type = "Label",
							text = getHelpString1(),
							relativeWidth = 1,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["To create a Restocking Operation"],
					children = {
						{
							type = "Label",
							text = getHelpString2(),
							relativeWidth = 1,
						},
					},
				},
				{
					type = "Spacer",
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Open the Restock UI"],
					children = {
						{
							type = "Label",
							text = getHelpString3(),
							relativeWidth = 1,
						},
					},
				},
			}
		}
	}
	TSMAPI:BuildPage(parent, page)
end

function Options:LoadGeneralSettings(container)
	local altCharacters ={}
	if select(4, GetAddOnInfo("TradeSkillMaster_ItemTracker")) == 1 then
		for _, name in ipairs(TSMAPI:ModuleAPI("ItemTracker", "playerlist") or {}) do
			altCharacters[name] = name
		end
	end
	local playerList = {}
	local CharacterList = TSMAPI:GetCharacters()
	for playerName in pairs(CharacterList) do
        playerList[playerName] = playerName
    end


	
	local page = {
		{
			-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Settings"],
					children = {
						{
							type = "EditBox",
							label = L["Default Price Method"],
							settingInfo = {TSM.db.global, "globalPriceSource"},
							relativeWidth = 1,
							acceptCustom = true,
							tooltip = L["This is the default method Restocking will use for determining the Price column."],
						},
							
					},
				},
				{
					type = "Spacer"
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["Inventory Settings"],
					children = {
						{
							type = "Dropdown",
							label = L["Restock will not automatically open and close for Selected Characters:"],
							value = TSM.db.global.ignoreCharacters,
							list = playerList,
							relativeWidth = 0.49,
							multiselect = true,
							disabled = select(4, GetAddOnInfo("TradeSkillMaster_ItemTracker")) ~= 1,
							callback = function(self, _, key, value)
								TSM.db.global.ignoreCharacters[key] = value
							end,
						},
					},
				},
			},
		},
	}

	TSMAPI:BuildPage(container, page)
end
	
	
	
	
function Options:ShowOperationsPage(container, operationName)
	if operationName ~= nil then
		local tg = AceGUI:Create("TSMTabGroup")
		tg:SetLayout("Fill")
		tg:SetFullHeight(true)
		tg:SetFullWidth(true)
		tg:SetTabs({{value=1, text=L["General"]}, {value=2, text=L["Relationships"]}, {value=3, text="Management"}})
		tg:SetCallback("OnGroupSelected", function(self,_,value)
				tg:ReleaseChildren()
				TSMAPI:UpdateOperation("Restocker", operationName)
				if value == 1 then
					Options:DrawOperationGeneral(self, operationName)
				elseif value == 2 then
					Options:DrawOperationRelationships(self, operationName)
				elseif value ==3 then 
					TSMAPI:DrawOperationManagement(TSM,self, operationName)
				end
			end)
		container:AddChild(tg)
		tg:SelectTab(1)
		return
	end
end

function Options:DrawNewOperation(container)
	local currentGroup = Options.currentGroup
	local page = {
		{ -- scroll frame
			type = "ScrollFrame", 
			layout = "List", 
			children = {
				{
					type="InlineGroup", 
					layout="flow", 
					title=L["New Operation"],
					children = {
						{
							type="Label", 
							text=L["Restocking operations contain the desired amount you would like to keep stockpiled for items in your groups"],
							relativeWidth = 1,
						}, 
						{ 
							type="EditBox", 
							label=L["Operation Name"], 
							relativeWidth=0.8, 
							callback = function(self, _, name)
								name = (name or ""):trim()
								if name == "" then return end
								if TSM.operations[name] then
									self:SetText("")
									return TSM:Printf(L["Error creating operation. Operation with name '%s' already exists."], name)
								end
								TSM.operations[name] = CopyTable(TSM.operationDefaults)
								Options:UpdateTree()
								Options.treeGroup:SelectByPath(3, name)
								TSMAPI:NewOperationCallback("Restocker", currentGroup, name)
							end,
							tooltip = L["Give the new operation a name. A descriptive name will help you find this operation later."],
						},
					},
				},
			},
		},
	}
	TSMAPI:BuildPage(container, page)
end

function Options:DrawOperationGeneral(container, operationName)
	local operation = TSM.operations[operationName]
	local page = {
		{
			type="ScrollFrame",
			layout = "list",
			children = {
				{
					type="InlineGroup",
					layout = "flow",
					title = L["General Operation Options"],
					children = {
						{
							type="EditBox",
							label = L["Desired Quantity"],
							settingInfo = {operation, "maxquantity"},
							relativeWidth = 0.49,
							acceptCustom = false,
							disabled = operation.relationships.maxquantity,
							tooltip = L["The number of the item you would like to keep restocked. By default, restocker will not show items above this quantity"],
						},
						{
							type = "CheckBox",
							value = operation.PriceSource,
							label = L["Override the default Price Method"],
							relativeWidth = 1,
							disabled = operation.relationships.PriceSource,
							callback = function(_, _, value)
								if value then
									operation.PriceSource = TSM.db.global.globalPriceSource
								else
									operation.PriceSource = nil
								end
								container:ReloadTab()
							end,
						},
						{
							type="EditBox",
							label=L["Restocker Price Source"],
							settingInfo = {operation, 'PriceSource'},
							relativeWidth=0.49,
							acceptCustom = true,
							disabled = not operation.PriceSource or
								operation.relationships.PriceSource,
							tooltip = L["Set the price method you would like used in the 'Price' Column on Restocker for this operation.  The default is dbmarket."],
						},
					},
				},
				{
					type = "Spacer", 
				},
			},			
		},
	}
	TSMAPI:BuildPage(container, page)
end

function Options:DrawOperationRelationships(container, operationName)
	local settingInfo = {
		{
			label = L["General Settings"], 
			{key="maxquantity", label=L["Restock Desired Quantity"]},
			{key="PriceSource", label=L["Restock Default Price Source"]},
		},
	}
	TSMAPI:ShowOperationRelationshipTab(TSM, container, TSM.operations[operationName], settingInfo)
end


							
	
