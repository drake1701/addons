local class = select(2, UnitClass("player"))
local race = select(2, UnitRace("player"))

local smartprefs = CreateFrame("Frame","LivestockSmartPreferencesFrame",UIParent,"LivestockBlueFrameTemplate")
smartprefs:SetHeight(450)
smartprefs:SetHeight(380)
smartprefs:SetBackdropColor(0.2, 0.2, 0.6, 1)
LivestockSmartPreferencesFrame.name = LivestockLocalizations.LIVESTOCK_INTERFACE_PREFSPANEL2
LivestockSmartPreferencesFrame.parent = LivestockLocalizations.LIVESTOCK_INTERFACE_MAINPANEL
InterfaceOptions_AddCategory(LivestockSmartPreferencesFrame)

local sb1 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleDruidLogic", smartprefs, 5, -10, "LivestockSmartPreferencesFrameDruidToggleText")
sb1:SetScript("OnClick", function()
	LivestockSettings.druidlogic = 1 - LivestockSettings.druidlogic
	LivestockComboButton:SetAttribute("druidlogic",LivestockSettings.druidlogic)
end)

local sb13 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameMoonkin", smartprefs, 5, -28, "LivestockSmartPreferencesFrameMoonkinText")
sb13:SetScript("OnClick", function()
	LivestockSettings.moonkin = 1 - LivestockSettings.moonkin
	LivestockComboButton:SetAttribute("moonkin",LivestockSettings.moonkin)
end)
if class ~= "DRUID" then sb13:Disable() end

local sb12 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleWorgenLogic", smartprefs, 5, -46, "LivestockSmartPreferencesFrameWorgenToggleText")
sb12:SetScript("OnClick", function()
	LivestockSettings.worgenlogic = 1 - LivestockSettings.worgenlogic
	LivestockComboButton:SetAttribute("worgenlogic",LivestockSettings.worgenlogic)
end)
if race ~= "Worgen" then sb12:Disable() end

local sb2 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleSafeFlying", smartprefs, 5, -64, "LivestockSmartPreferencesFrameSafeFlightText")
sb2:SetScript("OnClick", function()
	LivestockSettings.safeflying = 1 - LivestockSettings.safeflying
	LivestockComboButton:SetAttribute("safeflying", LivestockSettings.safeflying)
end)

local sb3 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleMountInStealth", smartprefs, 5, -82, "LivestockSmartPreferencesFrameMountInStealthText")
sb3:SetScript("OnClick", function()
	LivestockSettings.mountinstealth = 1 - LivestockSettings.mountinstealth
	LivestockComboButton:SetAttribute("mountinstealth", LivestockSettings.mountinstealth)
end)

local sb4 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleCombatForms", smartprefs, 5, -100, "LivestockSmartPreferencesFrameToggleCombatFormsText")
sb4:SetScript("OnClick", function()
	LivestockSettings.combatforms = 1 - LivestockSettings.combatforms
	LivestockComboButton:SetAttribute("combatformstoggle",LivestockSettings.combatforms)
end)

local sb5 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleMovingForms", smartprefs, 5, -118, "LivestockSmartPreferencesFrameToggleMovingFormsText")
sb5:SetScript("OnClick", function() 
	LivestockSettings.movingform = 1 - LivestockSettings.movingform
	LivestockComboButton:SetAttribute("movingform",LivestockSettings.movingform)
end)
if class ~= "DRUID" and class ~= "SHAMAN" then sb5:Disable() sb4:Disable() end

local sb6 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleSmartCatForm", smartprefs, 5, -136, "LivestockSmartPreferencesFrameSmartCatFormText")
sb6:SetScript("OnClick", function()
	LivestockSettings.smartcatform = 1 - LivestockSettings.smartcatform
	LivestockComboButton:SetAttribute("catform",LivestockSettings.smartcatform)
end)
if class ~= "DRUID" then sb6:Disable() sb1:Disable() end

local sb7 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameToggleWaterWalking", smartprefs, 5, -154, "LivestockSmartPreferencesFrameToggleWaterWalkingText")
sb7:SetScript("OnClick", function()
	LivestockSettings.waterwalking = 1 - LivestockSettings.waterwalking
end)
if class ~= "SHAMAN" and class ~= "DEATHKNIGHT" and class ~= "PRIEST" then sb7:Disable() end

local sb9 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameIndoorHunterAspects", smartprefs, 5, -172, "LivestockSmartPreferencesFrameIndoorHunterAspectsText")
sb9:SetScript("OnClick", function()
	LivestockSettings.indooraspects = 1 - LivestockSettings.indooraspects
	LivestockComboButton:SetAttribute("indooraspects",LivestockSettings.indooraspects)
end)

local sb10 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameMovingHunterAspects", smartprefs, 5, -190, "LivestockSmartPreferencesFrameMovingHunterAspectsText")
sb10:SetScript("OnClick", function()
	LivestockSettings.movingaspects = 1 - LivestockSettings.movingaspects
	LivestockComboButton:SetAttribute("movingaspects",LivestockSettings.movingaspects)
end)

local sb14 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameGroupHunterAspects", smartprefs, 5, -208, "LivestockSmartPreferencesFrameGroupHunterAspectsText")
sb14:SetScript("OnClick", function()
	LivestockSettings.groupaspects = 1 - LivestockSettings.groupaspects
	LivestockComboButton:SetAttribute("groupaspects",LivestockSettings.groupaspects)
end)
if class ~= "HUNTER" then sb9:Disable() sb10:Disable() sb14:Disable() end

local sb11 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameSlowFallWhileFalling", smartprefs, 5, -226, "LivestockSmartPreferencesFrameSlowFallWhileFallingText")
sb11:SetScript("OnClick", function()
	LivestockSettings.slowfall = 1 - LivestockSettings.slowfall
end)
if class ~= "MAGE" and class ~= "PRIEST" then sb11:Disable() end

local sb15 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameWaterStrider", smartprefs, 5, -244, "LivestockSmartPreferencesFrameWaterStriderText")
sb15:SetScript("OnClick", function()
	LivestockSettings.waterstrider = 1 - LivestockSettings.waterstrider
end)

local sb16 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameWaterStrider2", smartprefs, 5, -262, "LivestockSmartPreferencesFrameWaterStrider2Text")
sb16:SetScript("OnClick", function()
	LivestockSettings.waterstrider2 = 1 - LivestockSettings.waterstrider2
end)

local sb17 = Recompense.CreateButtonAndText("LivestockSmartPreferencesFrameZenFlight", smartprefs, 5, -280, "LivestockSmartPreferencesFrameZenFlightText")
sb17:SetScript("OnClick", function()
	LivestockSettings.zenflight = 1 - LivestockSettings.zenflight
end)
if class ~= "MONK" then sb17:Disable() end

local sbb = CreateFrame("Button", "LivestockSmartPreferencesFrameOpenLivestockMenuButton", smartprefs, "GameMenuButtonTemplate")
sbb:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_LIVESTOCKMENU)
sbb:SetWidth(145)
sbb:SetHeight(25)
sbb:SetPoint("BOTTOM", 0, 15)
sbb:SetScript("OnClick", function() Recompense.TransitionFromInterfaceOptionsToFrame(LivestockMenuFrame) end)
