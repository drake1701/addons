local frame2 = CreateFrame("Frame","LivestockWeightsPreferencesFrame",UIParent,"LivestockBlueFrameTemplate")
frame2:SetHeight(450)
frame2:SetHeight(380)
frame2:SetBackdropColor(0.2, 0.2, 0.6, 1)
frame2.name = LivestockLocalizations.LIVESTOCK_INTERFACE_PREFSPANEL4
frame2.parent = LivestockLocalizations.LIVESTOCK_INTERFACE_MAINPANEL
InterfaceOptions_AddCategory(LivestockWeightsPreferencesFrame)

local frame = CreateFrame("Frame", "LivestockWeightsInterfacePanel", UIParent, "LivestockBlueFrameTemplate")

local weightsCheck = CreateFrame("CheckButton", nil, frame2, "UICheckButtonTemplate")
weightsCheck:SetHeight(30)
weightsCheck:SetWidth(30)
weightsCheck:SetPoint("TOPLEFT", 20, -30)
local wcText = weightsCheck:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
wcText:SetPoint("LEFT", weightsCheck, "RIGHT", 20, 0)
wcText:SetText(LivestockLocalizations.LIVESTOCK_INTERFACE_USEWEIGHTS)

local launchButton = CreateFrame("Button", nil, frame2, "GameMenuButtonTemplate")
launchButton:SetPoint("TOP", 0, -150)
launchButton:SetHeight(25)
launchButton:SetWidth(350)
launchButton:SetText(LivestockLocalizations.LIVESTOCK_INTERFACE_LAUNCHWEIGHTS)
launchButton:SetScript("OnClick", function() Recompense.TransitionFromInterfaceOptionsToFrame(LivestockWeightsInterfacePanel) end)

frame:SetHeight(500)
frame:SetWidth(600)
frame:SetPoint("CENTER", 100, 0)

local fs1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
fs1:SetPoint("TOP", 0, -30)
fs1:SetText(LivestockLocalizations.LIVESTOCK_INTERFACE_PREFSPANEL4)

