-- AllPlayed-ptBR.lua
-- $Id: AllPlayed-deDE.lua 257 2012-03-12 22:02:47Z LaoTseu $
if not AllPlayed_revision then AllPlayed_revision = {} end
AllPlayed_revision.ptBR	= ("$Revision: 257 $"):match("(%d+)")

local L = LibStub("AceLocale-3.0"):NewLocale("AllPlayed", "ptBR")
if not L then return end



-- Generated from http://www.wowace.com/addons/all-played-laotseu/localization/
-- Translators: onideusx

-- L["000.TOC Notes"] = ""
-- L["100%"] = ""
-- L["150%"] = ""
-- L["%.1f K XP"] = ""
-- L["%.1f M XP"] = ""
-- L["%.2f iLvl"] = ""
-- L["AB Marks"] = ""
L["About"] = "Sobre" -- Needs review
L["All Factions"] = "Todas Facções" -- Needs review
-- L["All factions will be displayed"] = ""
-- L["/allplayed"] = ""
-- L["All Played Breakdown"] = ""
-- L["AllPlayed Configuration"] = ""
-- L["All Realms"] = ""
-- L["All realms will de displayed"] = ""
-- L["/ap"] = ""
-- L["Arena Points"] = ""
-- L["AV Marks"] = ""
-- L["Badges of Justice"] = ""
-- L["BC Installed?"] = ""
-- L["By experience"] = ""
-- L["By item level"] = ""
-- L["By level"] = ""
-- L["By money"] = ""
-- L["By name"] = ""
-- L["By % rested"] = ""
-- L["By rested XP"] = ""
-- L["By time played"] = ""
L["Close"] = "Fechar" -- Needs review
-- L["Close the tooltip"] = ""
-- L["Colorize Class"] = ""
-- L["Colorize the character name based on class"] = ""
L["Configuration"] = "Configuração" -- Needs review
-- L["Conquest Points"] = ""
-- L["Conquest Pts"] = ""
-- L["Delete Characters"] = ""
-- L["DELETE_WARNING"] = ""
-- L["Display"] = ""
-- L["Display Delay"] = ""
-- L["Display the gold each character pocess"] = ""
-- L["Display the played time and the total time played"] = ""
-- L["Display the %s each character pocess"] = ""
-- L["Display the seconds in the time strings"] = ""
-- L["Display XP progress as a decimal value appended to the level"] = ""
-- L["Do not show Percent Rest"] = ""
L["Don't show location"] = "Não mostrar localização" -- Needs review
-- L["%d rested XP"] = ""
-- L["%d XP"] = ""
-- L["EotS Marks"] = ""
-- L["Erase character data permanantely"] = ""
-- L["Erase data for %s of %s"] = ""
-- L["Erasing data for %s of %s"] = ""
L["Experience Points"] = "Pontos de Experiencia" -- Needs review
-- L["Factions and Realms"] = ""
-- L["Filter"] = ""
-- L["Hide characters from display"] = ""
-- L["Hide %s of %s from display"] = ""
-- L["Honor Kills"] = ""
-- L["Honor Points"] = ""
-- L["How long should the tooltip be displayed after the mouse is moved out."] = ""
-- L["Ignore Characters"] = ""
-- L["Is the Burning Crusade expansion installed?"] = ""
-- L["Justice Points"] = ""
-- L["Keep displaying the tooltip when the mouse is over it. If uncheck, the tooltip is displayed only when mousing over the icon."] = ""
-- L["Lvl: %d"] = ""
-- L["Main Settings"] = ""
-- L["Minimap Icon"] = ""
-- L["None"] = ""
-- L["Opacity"] = ""
-- L["% opacity of the tooltip background"] = ""
-- L["Open configuration dialog"] = ""
-- L["Percent Rest"] = ""
L["PVP"] = "JxJ" -- Needs review
-- L["rested"] = ""
-- L["Rested XP"] = ""
-- L["Rested XP Countdown"] = ""
-- L["Rested XP Total"] = ""
-- L["%s AP"] = ""
-- L["Scale"] = ""
-- L["Scale the tooltip (70% to 150%)"] = ""
-- L["%s characters "] = ""
-- L["%s CP"] = ""
-- L["Select the sort type"] = ""
-- L["Set the base for % display of rested XP"] = ""
-- L["Set the display options"] = ""
-- L["Set the PVP options"] = ""
-- L["Set the rested XP options"] = ""
-- L["Set the sort options"] = ""
-- L["Set UI options"] = ""
-- L["%s HK"] = ""
L["Show Class Name"] = "Mostrar Nome da Classe" -- Needs review
-- L["Show Gold"] = ""
L["Show Item Level"] = "Mostrar Nível do Item" -- Needs review
-- L["Show level total"] = ""
L["Show Location"] = "Mostrar Localização" -- Needs review
-- L["Show Minimap Icon"] = ""
-- L["Show Played Time"] = ""
-- L["Show PVP Totals"] = ""
-- L["Show %s"] = ""
L["Show Seconds"] = "Mostrar Segundos" -- Needs review
-- L["Show %s total"] = ""
-- L["Show subzone"] = ""
-- L["Show the Alterac Valley Marks"] = ""
-- L["Show the Arathi Basin Marks"] = ""
-- L["Show the character arena points"] = ""
-- L["Show the character badges of Justice"] = ""
-- L["Show the character class beside the level"] = ""
-- L["Show the character honor kills"] = ""
-- L["Show the character honor points"] = ""
-- L["Show the character item level (iLevel)"] = ""
-- L["Show the character location"] = ""
-- L["Show the character rested XP"] = ""
-- L["Show the Eye of the Storm Marks"] = ""
-- L["Show the honor related stats for all characters"] = ""
-- L["Show the time remaining before the character is 100% rested"] = ""
-- L["Show the total levels for all characters"] = ""
-- L["Show the total %s for all characters"] = ""
-- L["Show the total XP for all characters"] = ""
-- L["Show the Warsong Gulch Marks"] = ""
-- L["Show XP Progress"] = ""
-- L["Show XP total"] = ""
-- L["Show zone"] = ""
-- L["Show zone/subzone"] = ""
-- L["%s HP"] = ""
-- L["%s JP"] = ""
-- L["Sort"] = ""
-- L["Sort in reverse order"] = ""
-- L["Sort Order"] = ""
-- L["Sort Type"] = ""
-- L["Specify what to display"] = ""
-- L["%s : %s"] = ""
-- L["%s (%s)"] = ""
-- L["%s %s characters "] = ""
-- L["%s (%s or %s)"] = ""
-- L["Sticky Tooltip"] = ""
-- L["%s VP"] = ""
-- L["Time Played"] = ""
-- L["Total Cash Value: "] = ""
-- L["Total Character Levels: "] = ""
-- L["Total Justice Points: "] = ""
-- L["Total PvP: "] = ""
-- L["Total %s Cash Value: "] = ""
-- L["Total %s Time Played: "] = ""
-- L["Total Time Played: "] = ""
-- L["Total Valor Points: "] = ""
-- L["Total XP: "] = ""
-- L["UI"] = ""
-- L["Unknown"] = ""
-- L["Use graphics for coin and PvP currencies"] = ""
-- L["Use Icons"] = ""
-- L["Use Old Shaman Colour"] = ""
-- L["Use the curent sort type in reverse order"] = ""
-- L["Use the pre-210 patch colour for the Shaman class"] = ""
-- L["Valor Points"] = ""
-- L["Version %s (r%s)"] = ""
-- L["v%s - %s (Type /ap for help)"] = ""
-- L["WG Marks"] = ""

