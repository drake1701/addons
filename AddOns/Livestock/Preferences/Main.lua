-- Main preferences panel

local mainprefs = CreateFrame("Frame","LivestockMainPreferencesFrame",UIParent,"LivestockBlueFrameTemplate")
mainprefs:SetHeight(450)
mainprefs:SetHeight(380)
mainprefs:SetBackdropColor(0.2, 0.2, 0.6, 1)
LivestockMainPreferencesFrame.name = LivestockLocalizations.LIVESTOCK_INTERFACE_MAINPANEL
InterfaceOptions_AddCategory(LivestockMainPreferencesFrame)

local mb1 = CreateFrame("CheckButton", "LivestockMainPreferencesFrameShowLandMounts", mainprefs, "UICheckButtonTemplate")
mb1:SetHeight(26)
mb1:SetWidth(26)
mb1:SetPoint("TOPLEFT", 85, -90)
mb1:SetScript("OnClick", function()
	LivestockSettings.showland = 1 - LivestockSettings.showland
	if LivestockSettings.showland == 0 then
		LivestockLandMountsButton:Hide()
	else
		LivestockLandMountsButton:Show()
	end
end)

local mb2 = CreateFrame("CheckButton", "LivestockMainPreferencesFrameShowCritters", mainprefs, "UICheckButtonTemplate")
mb2:SetHeight(26)
mb2:SetWidth(26)
mb2:SetPoint("TOPLEFT", 85, -55)
mb2:SetScript("OnClick", function()
	LivestockSettings.showcritter = 1 - LivestockSettings.showcritter
	if LivestockSettings.showcritter == 0 then
		LivestockCrittersButton:Hide()
	else
		LivestockCrittersButton:Show()
	end
end)

local mb3 = CreateFrame("CheckButton", "LivestockMainPreferencesFrameShowFlyingMounts", mainprefs, "UICheckButtonTemplate")
mb3:SetHeight(26)
mb3:SetWidth(26)
mb3:SetPoint("TOPLEFT", 240, -55)
mb3:SetScript("OnClick", function()
	LivestockSettings.showflying = 1 - LivestockSettings.showflying
	if LivestockSettings.showflying == 0 then
		LivestockFlyingMountsButton:Hide()
	else
		LivestockFlyingMountsButton:Show()
	end
end)

local mb4 = CreateFrame("CheckButton", "LivestockMainPreferencesFrameShowSmartMounts", mainprefs, "UICheckButtonTemplate")
mb4:SetHeight(26)
mb4:SetWidth(26)
mb4:SetPoint("TOPLEFT", 240, -90)
mb4:SetScript("OnClick", function()
	LivestockSettings.showsmart = 1 - LivestockSettings.showsmart
	if LivestockSettings.showsmart == 0 then
		LivestockSmartButton:Hide()
	else
		LivestockSmartButton:Show()
	end
end)

local mb7 = CreateFrame("Button", "LivestockCritterMacroButton", mainprefs, "GameMenuButtonTemplate")
mb7:SetHeight(25)
mb7:SetWidth(115)
mb7:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL)
mb7:SetPoint("TOP", -133, -180)
mb7:SetScript("OnClick", function()
	CreateMacro("Critters",1,"/run if GetMouseButtonClicked() == 'RightButton' then Livestock.DismissCritter() else Livestock.PickCritter() end",1)
	DEFAULT_CHAT_FRAME:AddMessage(LivestockLocalizations.LIVESTOCK_INTERFACE_CRITTERMACROCREATED)
end)

local mb8 = CreateFrame("Button", "LivestockLandMountMacroButton", mainprefs, "GameMenuButtonTemplate")
mb8:SetHeight(25)
mb8:SetWidth(115)
mb8:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_SHOWLANDLABEL)
mb8:SetPoint("TOP", 0, -180)
mb8:SetScript("OnClick", function()
	CreateMacro("LandMounts",1,"/click LivestockLandMountsButton",1)
	DEFAULT_CHAT_FRAME:AddMessage(LivestockLocalizations.LIVESTOCK_INTERFACE_LANDMACROCREATED)
end)

local mb9 = CreateFrame("Button", "LivestockFlyingMountMacroButton", mainprefs, "GameMenuButtonTemplate")
mb9:SetHeight(25)
mb9:SetWidth(115)
mb9:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL)
mb9:SetPoint("TOP", 133, -180)
mb9:SetScript("OnClick", function()
	CreateMacro("FlyingMounts",1,"/click LivestockFlyingMountsButton",1)
	DEFAULT_CHAT_FRAME:AddMessage(LivestockLocalizations.LIVESTOCK_INTERFACE_FLYINGMACROCREATED)
end)

local mb10 = CreateFrame("Button", "LivestockComboMacroButton", mainprefs, "GameMenuButtonTemplate")
mb10:SetHeight(25)
mb10:SetWidth(115)
mb10:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL)
mb10:SetPoint("TOP", 0, -210)
mb10:SetScript("OnClick", function()
	CreateMacro("ComboMounts",1,"/click LivestockComboButton",1)
	DEFAULT_CHAT_FRAME:AddMessage(LivestockLocalizations.LIVESTOCK_INTERFACE_SMARTMACROCREATED)
end)

local mb11 = CreateFrame("Button", "LivestockMainPreferencesFrameOpenLivestockMenuButton", mainprefs, "GameMenuButtonTemplate")
mb11:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_LIVESTOCKMENU)
mb11:SetWidth(145)
mb11:SetHeight(25)
mb11:SetPoint("BOTTOM", 0, 15)
mb11:SetScript("OnClick", function() Recompense.TransitionFromInterfaceOptionsToFrame(LivestockMenuFrame) end)

local function PlaceFS(title, template, anchor, xOffset, yOffset)
	local t = mainprefs:CreateFontString(title, "OVERLAY", template)
	t:SetPoint(anchor, xOffset, yOffset)
	t:SetJustifyH("LEFT")
end

PlaceFS("LivestockMainPreferencesFrameButtonsToggleTitle", "GameFontNormalLarge", "TOP", 0, -25)
PlaceFS("LivestockMainPreferencesFrameMacroTitle", "GameFontNormalLarge", "TOP", 0, -120)
--PlaceFS("LivestockMainPreferencesFrameOtherTitle", "GameFontNormalLarge", "TOP", 0, -250)
PlaceFS("LivestockMainPreferencesFrameMacroText", "ChatFontNormal", "TOP", 0, -150)
PlaceFS("LivestockMainPreferencesFrameShowSmartMountsLabel", "ChatFontNormal", "TOPLEFT", 275, -95)
PlaceFS("LivestockMainPreferencesFrameShowLandMountsLabel", "ChatFontNormal", "TOPLEFT", 115, -95)
PlaceFS("LivestockMainPreferencesFrameShowFlyingMountsLabel", "ChatFontNormal", "TOPLEFT", 275, -60)
PlaceFS("LivestockMainPreferencesFrameShowCrittersLabel", "ChatFontNormal", "TOPLEFT", 115, -60)

local vfs = mainprefs:CreateFontString("LivestockVersionNumber", "OVERLAY", "ChatFontSmall")
vfs:SetText(format("Version: %s", LIVESTOCK_VERSION))
vfs:SetPoint("BOTTOMRIGHT", -10, 10)
