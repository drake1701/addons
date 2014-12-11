--------------------------------------------
--         Author: Simca@Malfurion        --
-- Special Thanks: durandal42 and yinzara --
--------------------------------------------

-- Additional thanks to Ro for inspiration for the overall structure of this options panel (and the title/version/description code)

-- Set addon name and namespace
local addonname, ASH = ...

local Options = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
Options:Hide()
Options.name = "Auto Safari Hat"

-- Variable for easy positioning
local lastcheckbox

-- Ro's CreateFont function for easy FontString creation
local function CreateFont(fontName, r, g, b, anchorPoint, relativeTo, relativePoint, cx, cy, xoff, yoff, text)
	local font = Options:CreateFontString(nil, "BACKGROUND", fontName)
	font:SetJustifyH("LEFT")
	font:SetJustifyV("TOP")
	if type(r) == "string" then -- r is text, no positioning
		text = r
	else
		if r then
			font:SetTextColor(r, g, b, 1)
		end
		font:SetSize(cx, cy)
		font:SetPoint(anchorPoint, relativeTo, relativePoint, xoff, yoff)
	end
	font:SetText(text)
	return font
end

-- My CreateCheckbox function for easy Checkbox creation
local function CreateCheckbox(text, height, width, anchorPoint, relativeTo, relativePoint, xoff, yoff, font)
	local checkbox = CreateFrame("CheckButton", nil, Options, "UICheckButtonTemplate")
	checkbox:SetPoint(anchorPoint, relativeTo, relativePoint, xoff, yoff)
	checkbox:SetSize(height, width)
	local realfont = font or "GameFontNormal"
	checkbox.text:SetFontObject(realfont)
	checkbox.text:SetText(" " .. text)
	lastcheckbox = checkbox
	return checkbox
end

local panelWidth = InterfaceOptionsFramePanelContainer:GetWidth() -- ~623
local wideWidth = panelWidth - 40

local title = CreateFont("GameFontNormalLarge", "Auto Safari Hat")
title:SetPoint("TOPLEFT",16,-12)
local ver = CreateFont("GameFontNormalSmall", "version " .. GetAddOnMetadata(addonname, "Version"))
ver:SetPoint("BOTTOMLEFT", title, "BOTTOMRIGHT", 4, 0)
local auth = CreateFont("GameFontNormalSmall", "created by "..GetAddOnMetadata(addonname, "Author"))
auth:SetPoint("BOTTOMLEFT", ver, "BOTTOMRIGHT", 3, 0)
local desc = CreateFont("GameFontHighlight", nil, nil, nil, "TOPLEFT", title, "BOTTOMLEFT" ,wideWidth, 40, 0, -4, "An addon that automatically equips your Safari Hat when fighting wild pets or battling Pet Tamers. Additionally, it automatically accepts quests, starts battles, and completes quests when you right-click on a Pet Tamer.")

-- Create temp format variable
local tempitem = 1

-- Create dropdownmenu
if not ASH_OptionsItemMenu then
	CreateFrame("Button", "ASH_OptionsItemMenu", Options, "UIDropDownMenuTemplate")
end

-- Set dropdownmenu location
ASH_OptionsItemMenu:ClearAllPoints()
ASH_OptionsItemMenu:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 16, -24)
ASH_OptionsItemMenu:Show()

-- Create array for dropdownmenu
local items = {
	"Cast Safari Hat",
	"Equip Guild Rep Tabard",
	"Cast Hat and Equip Tabard",
	"Equip nothing",
}

-- OnClick function for dropdownmenu
local function ASH_OptionsItemMenu_OnClick(self, arg1, arg2, checked)
	-- Update temp variable
	tempitem = arg1
	
	-- Update dropdownmenu text
	UIDropDownMenu_SetText(ASH_OptionsItemMenu, items[tempitem])
end

-- Initialization function for dropdownmenu
local function ASH_OptionsItemMenu_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo()
	info = UIDropDownMenu_CreateInfo()
	info.func = ASH_OptionsItemMenu_OnClick
	info.arg1, info.text = 1, items[1]
	UIDropDownMenu_AddButton(info)
	info.arg1, info.text = 2, items[2]
	UIDropDownMenu_AddButton(info)
	info.arg1, info.text = 3, items[3]
	UIDropDownMenu_AddButton(info)
	info.arg1, info.text = 4, items[4]
	UIDropDownMenu_AddButton(info)
end

-- Final setup for dropdownmenu
UIDropDownMenu_Initialize(ASH_OptionsItemMenu, ASH_OptionsItemMenu_Initialize)
UIDropDownMenu_SetWidth(ASH_OptionsItemMenu, 148);
UIDropDownMenu_SetButtonWidth(ASH_OptionsItemMenu, 124)
UIDropDownMenu_SetText(ASH_OptionsItemMenu, items[tempitem])
UIDropDownMenu_JustifyText(ASH_OptionsItemMenu, "LEFT")

-- All five checkboxes
local OptWildPetHat = CreateCheckbox("Automatically equip/notify about the above item(s) for Wild Pet Battles", 32, 32, "TOPLEFT", ASH_OptionsItemMenu, "BOTTOMLEFT", 0, -12)
local OptTamerPetHat = CreateCheckbox("Automatically battle tamers if you have their quest AND cast/equip the above item(s)", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)
local OptAutoPetBattleTeams = CreateCheckbox("Automatically equips a Pet Battle Team with opponent's name (Needs PetBattleTeams)", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)
local OptAutoQuestAccept = CreateCheckbox("Automatically pick up quests from tamers", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)
local OptAutoQuestComplete = CreateCheckbox("Automatically turn in quests to tamers", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)
local OptAttemptCombatFix = CreateCheckbox("Attempt to return your equipment to the correct state when you exit combat", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)
local OptDisableText = CreateCheckbox("Disable all text notifications, like those that occur if a Pet Battle Team is unavailable", 32, 32, "TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -12)

-- To disable child checkbox (OptAutoPetBattleTeams) when both parents are unchecked
local function ASH_OptWildPetHat_OnClick(self, button, down)
	
	if OptWildPetHat:GetChecked() and ASH.LibStub then -- Ensures LibStub exists before enable
		-- Enable child checkbox
		OptAutoPetBattleTeams:Enable()
		
	elseif not OptWildPetHat:GetChecked() and not OptTamerPetHat:GetChecked() then
		-- Disable and uncheck child checkbox
		OptAutoPetBattleTeams:Disable()
		OptAutoPetBattleTeams:SetChecked(nil)
	end
end

-- To disable child checkbox (OptAutoPetBattleTeams) when both parents are unchecked
local function ASH_OptTamerPetHat_OnClick(self, button, down)
	
	if OptTamerPetHat:GetChecked() and ASH.LibStub then -- Ensures LibStub exists before enable
		-- Enable child checkbox
		OptAutoPetBattleTeams:Enable()
		
	elseif not OptWildPetHat:GetChecked() and not OptTamerPetHat:GetChecked() then
		-- Disable and uncheck child checkbox
		OptAutoPetBattleTeams:SetChecked(nil)
		OptAutoPetBattleTeams:Disable()
	end
end

-- When the frame refreshes
function Options.refresh()
	tempitem = AutoSafariHatOptions.Items
	UIDropDownMenu_SetText(ASH_OptionsItemMenu, items[tempitem])
	
	OptWildPetHat:SetChecked(AutoSafariHatOptions.WildPetHat)
	OptTamerPetHat:SetChecked(AutoSafariHatOptions.TamerPetHat)
    
    -- If we don't find LibStub, this option doesn't matter. We need to disable it and 'uncheck' it display-wise.
    -- We can keep the real value hidden without altering that, though.
    if ASH.PBT then
        OptAutoPetBattleTeams:SetChecked(nil)
        OptAutoPetBattleTeams:Disable()
    else
        OptAutoPetBattleTeams:Enable()
        OptAutoPetBattleTeams:SetChecked(AutoSafariHatOptions.AutoPetBattleTeams)
    end
    
	OptAutoQuestAccept:SetChecked(AutoSafariHatOptions.AutoQuestAccept)
	OptAutoQuestComplete:SetChecked(AutoSafariHatOptions.AutoQuestComplete)
	OptAttemptCombatFix:SetChecked(AutoSafariHatOptions.AttemptCombatFix)
	OptDisableText:SetChecked(AutoSafariHatOptions.DisableText)
end

-- When you hit okay
function Options.okay()
	AutoSafariHatOptions.Items = tempitem
	
	AutoSafariHatOptions.WildPetHat = OptWildPetHat:GetChecked()
	AutoSafariHatOptions.TamerPetHat = OptTamerPetHat:GetChecked()
	AutoSafariHatOptions.AutoPetBattleTeams = OptAutoPetBattleTeams:GetChecked()
	AutoSafariHatOptions.AutoQuestAccept = OptAutoQuestAccept:GetChecked()
	AutoSafariHatOptions.AutoQuestComplete = OptAutoQuestComplete:GetChecked()
	AutoSafariHatOptions.AttemptCombatFix = OptAttemptCombatFix:GetChecked()
	AutoSafariHatOptions.DisableText = OptDisableText:GetChecked()
	
	AutoSafariHatOptions.ManualChange = GetAddOnMetadata(addonname, "Version")
end

-- When you hit default
function Options.default()
	tempitem = 1
	UIDropDownMenu_SetText(ASH_OptionsItemMenu, items[tempitem])
	
	OptWildPetHat:SetChecked(true)
	OptTamerPetHat:SetChecked(true)
	OptAutoPetBattleTeams:SetChecked(nil)
	OptAutoQuestAccept:SetChecked(true)
	OptAutoQuestComplete:SetChecked(true)
	OptAttemptCombatFix:SetChecked(true)
    OptDisableText:SetChecked(nil)
end

-- Set script for needed checkbox
OptWildPetHat:SetScript("OnClick", ASH_OptWildPetHat_OnClick)
OptTamerPetHat:SetScript("OnClick", ASH_OptTamerPetHat_OnClick)
OptAutoPetBattleTeams:SetScript("OnClick", ASH_OptAutoPetBattleTeams_OnClick)

-- Add the options panel to the Blizzard list
InterfaceOptions_AddCategory(Options)