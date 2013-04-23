local class = select(2, UnitClass("player"))
local race = select(2, UnitRace("player"))

local petprefs = CreateFrame("Frame","LivestockPetPreferencesFrame",UIParent,"LivestockBlueFrameTemplate")
petprefs:SetHeight(450)
petprefs:SetHeight(380)
petprefs:SetBackdropColor(0.2, 0.2, 0.6, 1)
LivestockPetPreferencesFrame.name = LivestockLocalizations.LIVESTOCK_INTERFACE_PREFSPANEL1
LivestockPetPreferencesFrame.parent = LivestockLocalizations.LIVESTOCK_INTERFACE_MAINPANEL
InterfaceOptions_AddCategory(LivestockPetPreferencesFrame)

local pb1 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameToggleAutosummon", petprefs, 5, -10, "LivestockPetPreferencesFrameAutoSummonOnMoveText")
pb1:SetScript("OnClick", Livestock.ClickedAutoSummon)

local pb2 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameToggleAutosummonFavorite", petprefs, 5, -28, "LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText")
pb2:SetScript("OnClick", function() LivestockSettings.summonfaveonmove = 1 - LivestockSettings.summonfaveonmove end)

local pb3 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameRestrictAutoSummonOnPVP", petprefs, 5, -46, "LivestockPetPreferencesFrameRestrictAutoSummonOnPVPText")
pb3:SetScript("OnClick", function()
	LivestockSettings.restrictautosummon = 1 - LivestockSettings.restrictautosummon
	if LivestockSettings.restrictautosummon == 0 then
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstances:Disable()
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstancesText:SetTextColor(0.4, 0.4, 0.4)
	else
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstances:Enable()
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstancesText:SetTextColor(1, 1, 1)
	end
end)

local pb4 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameIgnorePVPRestrictionInInstances", petprefs, 15, -64, "LivestockPetPreferencesFrameIgnorePVPRestrictionInInstancesText")
pb4:SetScript("OnClick", function() LivestockSettings.ignorepvprestrictionininstances = 1 - LivestockSettings.ignorepvprestrictionininstances end)

local pb5 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameRestrictAutoSummonOnRaid", petprefs, 5, -82, "LivestockPetPreferencesFrameRestrictAutoSummonOnRaidText")
pb5:SetScript("OnClick", function() LivestockSettings.donotsummoninraid = 1 - LivestockSettings.donotsummoninraid end)

local pb6 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameDismissPetOnMount", petprefs, 5, -100, "LivestockPetPreferencesFrameDismissPetOnMountText")
pb6:SetScript("OnClick", function() LivestockSettings.dismisspetonmount = 1 - LivestockSettings.dismisspetonmount end)

local pb7 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameToggleDismissOnStealth", petprefs, 5, -118, "LivestockPetPreferencesFrameAutoDismissOnStealthText")
pb7:SetScript("OnClick", function()
	LivestockSettings.dismissonstealth = 1 - LivestockSettings.dismissonstealth
	if LivestockSettings.dismissonstealth == 1 then
		LivestockPetPreferencesFrameToggleDismissOnStealthPVPOnly:Enable()
		LivestockPetPreferencesFramePVPDismissText:SetTextColor(1, 1, 1)
	else
		LivestockPetPreferencesFrameToggleDismissOnStealthPVPOnly:Disable()
		LivestockPetPreferencesFramePVPDismissText:SetTextColor(0.4, 0.4, 0.4)
	end
end)

local pb8 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameToggleDismissOnStealthPVPOnly", petprefs, 10, -136, "LivestockPetPreferencesFramePVPDismissText")
pb8:SetScript("OnClick", function() LivestockSettings.PVPdismiss = 1 - LivestockSettings.PVPdismiss end)

local pb9 = Recompense.CreateButtonAndText("LivestockPetPreferencesFrameNewPet", petprefs, 5, -154, "LivestockPetPreferencesFrameNewPetText")
pb9:SetScript("OnClick", function() LivestockSettings.newpet = 1 - LivestockSettings.newpet end)

local pbb = CreateFrame("Button", "LivestockPetPreferencesFrameOpenLivestockMenuButton", petprefs, "GameMenuButtonTemplate")
pbb:SetText(LivestockLocalizations.LIVESTOCK_FONTSTRING_LIVESTOCKMENU)
pbb:SetWidth(145)
pbb:SetHeight(25)
pbb:SetPoint("BOTTOM", 0, 15)
pbb:SetScript("OnClick", function() Recompense.TransitionFromInterfaceOptionsToFrame(LivestockMenuFrame) end)
