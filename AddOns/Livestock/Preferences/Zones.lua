local frame = CreateFrame("Frame","LivestockZonePreferencesFrame",UIParent,"LivestockBlueFrameTemplate")
frame:SetHeight(450)
frame:SetHeight(380)
frame:SetBackdropColor(0.2, 0.2, 0.6, 1)
frame.name = LivestockLocalizations.LIVESTOCK_INTERFACE_PREFSPANEL3
frame.parent = LivestockLocalizations.LIVESTOCK_INTERFACE_MAINPANEL
InterfaceOptions_AddCategory(LivestockZonePreferencesFrame)
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

function Livestock.UpdateZoneTexts(fromDrag)
	LivestockCurrentZoneText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTZONE, GetRealZoneText()))
	if not fromDrag then
		LivestockZonePreferencesFrameZoneBox.texture:SetTexture(nil)
		LivestockZonePreferencesFrameSubZoneBox.texture:SetTexture(nil)
	end
	if GetSubZoneText ~= "" then
		LivestockCurrentSubZoneText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONE, GetSubZoneText()))
	else
		LivestockCurrentSubZoneText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONE, GetRealZoneText()))
	end

	if LivestockSettings.Zones[GetRealZoneText()] and LivestockSettings.Zones[GetRealZoneText()].critter then
		LivestockCurrentZonePetText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTZONEPET, LivestockSettings.Zones[GetRealZoneText()].critter))
	else
		LivestockCurrentZonePetText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTZONEPET, LivestockLocalizations.LIVESTOCK_INTERFACE_NOPETSELECTED))
	end
	
	if LivestockSettings.Zones[GetRealZoneText()] and LivestockSettings.Zones[GetRealZoneText()].mount then
		LivestockCurrentZoneMountText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTZONEMOUNT, LivestockSettings.Zones[GetRealZoneText()].mount))
	else
		LivestockCurrentZoneMountText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTZONEMOUNT, LivestockLocalizations.LIVESTOCK_INTERFACE_NOMOUNTSELECTED))
	end
	
	if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()].critter then
		LivestockCurrentSubZonePetText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONEPET, LivestockSettings.Zones[GetSubZoneText()].critter))
	else
		LivestockCurrentSubZonePetText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONEPET, LivestockLocalizations.LIVESTOCK_INTERFACE_NOPETSELECTED))
	end
	
	if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()].mount then
		LivestockCurrentSubZoneMountText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONEPET, LivestockSettings.Zones[GetSubZoneText()].mount))
	else
		LivestockCurrentSubZoneMountText:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_CURRENTSUBZONEMOUNT, LivestockLocalizations.LIVESTOCK_INTERFACE_NOMOUNTSELECTED))
	end	
end

frame:SetScript("OnShow", Livestock.UpdateZoneTexts)
frame:SetScript("OnEvent", Livestock.UpdateZoneTexts)

local fs1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
fs1:SetPoint("TOP", 0, -20)
fs1:SetText(LivestockLocalizations.LIVESTOCK_INTERFACE_ZONEFRAMEHEADER)

local zs1 = frame:CreateFontString("LivestockCurrentZoneText", "OVERLAY", "ChatFontNormal")
zs1:SetPoint("TOPLEFT", 25, -75)

local zs2 = frame:CreateFontString("LivestockCurrentZoneMountText", "OVERLAY", "ChatFontNormal")
zs2:SetPoint("TOPLEFT", 25, -95)

local zs3 = frame:CreateFontString("LivestockCurrentZonePetText", "OVERLAY", "ChatFontNormal")
zs3:SetPoint("TOPLEFT", 25, -115)

local zs4 = frame:CreateFontString("LivestockCurrentSubZoneText", "OVERLAY", "ChatFontNormal")
zs4:SetPoint("TOPLEFT", 25, -250)

local zs5 = frame:CreateFontString("LivestockCurrentSubZoneMountText", "OVERLAY", "ChatFontNormal")
zs5:SetPoint("TOPLEFT", 25, -270)

local zs6 = frame:CreateFontString("LivestockCurrentSubZonePetText", "OVERLAY", "ChatFontNormal")
zs6:SetPoint("TOPLEFT", 25, -290)

local zb = CreateFrame("Button", "LivestockZonePreferencesFrameZoneBox", frame, "LivestockBlueFrameTemplate")
local szb = CreateFrame("Button", "LivestockZonePreferencesFrameSubZoneBox", frame, "LivestockBlueFrameTemplate")

local zbs = frame:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
zbs:SetPoint("TOPLEFT", zb, "TOPRIGHT", 10, 0)
zbs:SetJustifyH("LEFT")
zbs:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_DRAGBOXEXPL, "zone"))

local szbs = frame:CreateFontString(nil, "OVERLAY", "ChatFontSmall")
szbs:SetPoint("TOPLEFT", szb, "TOPRIGHT", 10, 0)
szbs:SetJustifyH("LEFT")
szbs:SetText(format(LivestockLocalizations.LIVESTOCK_INTERFACE_DRAGBOXEXPL, "subzone"))

for i, button in pairs{zb, szb} do
	button:SetHeight(36)
	button:SetWidth(36)
	button:SetPoint("TOP", -150, i == 1 and -170 or -330)
	button:Show()
	button:RegisterForClicks("RightButtonUp", "LeftButtonUp")
	local t = button:CreateTexture(nil, "ARTWORK")
	button.texture = t
	t:SetAllPoints()
	button:SetScript("OnReceiveDrag", function(self)
		local kind, index, which = GetCursorInfo()
		if kind ~= "mount" and kind ~= "battlepet" then
			print(LivestockLocalizations.LIVESTOCK_INTERFACE_DRAGERROR)
		else
			ClearCursor()
			local name, texture, _
			if kind == "mount" then
--				name = C_MountJournal.GetMountInfo(index)
				print(LivestockLocalizations.LIVESTOCK_INTERFACE_MOUNTERROR)
			else
				_, _, _, _, _, _, _, name, texture = C_PetJournal.GetPetInfoByPetID(index)
			end
			t:SetTexture(texture)
--			which = which:lower()
			if name then
				Livestock.AddToZone(i == 1 and "zone" or "subzone", name, true)
			end
		end
	end)
	button:SetScript("OnClick", function(self, button)
		Livestock.AddToZone(i == 1 and "zone" or "subzone", "no"..(button:match("Right") and "pet" or "mount"))
		t:SetTexture(nil)
	end)
end
