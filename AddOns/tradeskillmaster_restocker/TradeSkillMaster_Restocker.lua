-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_Restocker", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Restocker") -- loads the localization table

local savedDBDefaults = {
	["global"] = {
		["TreeStatusOptions"] = {},
		["framePosition"]={100, 300}, -- save the restocker position between sessions
		["frameScale"] = {1},
		["openwithAH"] = {1},
		["closewithAH"]= {1},
		["ignoreCharacters"] ={},
		["globalPriceSource"] ="dbmarket",
	}
}
TSM.operationDefaults = {
	maxquantity = 0,
	relationships = {},
	ignorePlayer = {},
	ignoreFactionrealm = {},
	PriceSource = nil,
}
-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- create shortcuts to all the modules
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end
	
	-- load the savedDB into .db
	if not TradeskillMaster_RestockerDB then
		TradeskillMaster_RestockerDB = { global = {build=TSM.DBVersion}}
	end
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_RestockerDB", savedDBDefaults, true)

	-- register this module with TSM
	TSM:RegisterModule()
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.slashCommands = {
		{key="restock", label=L["Opens the restocking panel."], callback="GUI:SlashShow"},
	}
	TSM.operations = { maxOperations = 1, callbackOptions = "Options:Load", callbackInfo = "GetOperationInfo" }
	TSMAPI:NewModule(TSM)
end

function TSM:GetOperationInfo(name)
	TSMAPI:UpdateOperation("Restocker", name)
	local settings = TSM.operations[name]
	if not settings then return end

	return "Restocker!"
end
