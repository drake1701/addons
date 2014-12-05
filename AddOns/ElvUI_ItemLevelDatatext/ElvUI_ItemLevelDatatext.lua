-------------------------------------------------------------------------------
-- ElvUI Item Level Datatext By Lockslap
-------------------------------------------------------------------------------
local E, _, V, P, G, _ = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local L = LibStub("AceLocale-3.0"):GetLocale("ElvUI_ItemLevelDatatext", false)
local EP = LibStub("LibElvUIPlugin-1.0")
local AceTimer = LibStub("AceTimer-3.0")

local join = string.join
local floor = math.floor

local displayString = ""
local lastPanel
local slots = {
	[1] = L["Head"],
	[2] = L["Neck"],
	[3] = L["Shoulders"],
	[5] = L["Chest"],
	[6] = L["Waist"],
	[7] = L["Legs"],
	[8] = L["Feet"],
	[9] = L["Wrist"],
	[10] = L["Hands"],
	[11] = L["Ring 1"],
	[12] = L["Ring 2"],
	[13] = L["Trinket 1"],
	[14] = L["Trinket 2"],
	[15] = L["Back"],
	[16] = L["Main Hand"],
	[17] = L["Off Hand"],
	--[18] = L["Ranged"],
}

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		LibStub("AceTimer-3.0"):ScheduleTimer(function()
			local total, equipped = GetAverageItemLevel()
			self.text:SetFormattedText(displayString, L["Item Level"], E.db.ilvldt.ilvl == "equip" and floor(equipped) or floor(total))
		end, 5)
	else
		local total, equipped = GetAverageItemLevel()
		self.text:SetFormattedText(displayString, L["Item Level"], E.db.ilvldt.ilvl == "equip" and floor(equipped) or floor(total))
	end
end

local function OnEnter(self)
	local total, equipped = GetAverageItemLevel()
	DT:SetupTooltip(self)
	DT.tooltip:AddDoubleLine(L["Total"], floor(total), 1, 1, 1, 1, 1, 0)
	DT.tooltip:AddDoubleLine(L["Equipped"], floor(equipped), 1, 1, 1, 1, 1, 0)
	DT.tooltip:AddLine(" ")
	for i = 1, 17 do
		if slots[i] then
			local item = GetInventoryItemID("player", i)
			if item then
				local _, _, quality, iLevel, _, _, _, _, _, _, _ = GetItemInfo(item)
				local red, green, blue, _ = GetItemQualityColor(quality)
				DT.tooltip:AddDoubleLine(slots[i], iLevel, 1, 1, 1, red, green, blue)
			end
		end
	end
	DT.tooltip:Show()
end

local function OnClick(self, button)
	if button == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	else
		OnEvent(self)
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "|cffffffff%s:|r", " ", hex, "%d|r")
	if lastPanel ~= nil then OnEvent(lastPanel) end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

P["ilvldt"] = {
	["ilvl"] = "equip",
}

local function InjectOptions()
	if not E.Options.args.lockslap then
		E.Options.args.lockslap = {
			type = "group",
			order = -2,
			name = L["Plugins by |cff9382c9Lockslap|r"],
			args = {
				thanks = {
					type = "description",
					order = 1,
					name = L["Thanks for using and supporting my work!  -- |cff9382c9Lockslap|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."],
				},
			},
		}
	elseif not E.Options.args.lockslap.args.thanks then
		E.Options.args.lockslap.args.thanks = {
			type = "description",
			order = 1,
			name = L["Thanks for using and supporting my work!  -- |cff9382c9Lockslap|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."],
		}
	end
	
	E.Options.args.lockslap.args.ilvldt = {
		type = "group",
		name = L["Item Level Datatext"],
		get = function(info) return E.db.ilvldt[info[#info]] end,
		set = function(info, value) E.db.ilvldt[info[#info]] = value; DT:LoadDataTexts() end,
		args = {
			ilvl = {
				type = "select",
				order = 4,
				name = L["iLvl Display"],
				desc = L["Select which item level you want to display in the datatext, total or equipped."],
				values = {
					["equip"] = L["Equipped"],
					["total"] = L["Total"],
				},
			}
		},
	}
end

EP:RegisterPlugin(..., InjectOptions)
DT:RegisterDatatext(L["Item Level"], {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED", "UNIT_INVENTORY_CHANGED"}, OnEvent, nil, OnClick, OnEnter)