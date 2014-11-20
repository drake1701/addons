-- AllPlayed-koKR.lua
-- $Id: AllPlayed-koKR.lua 231 2010-10-18 02:07:01Z LaoTseu $
if not AllPlayed_revision then AllPlayed_revision = {} end
AllPlayed_revision.koKR	= ("$Revision: 231 $"):match("(%d+)")

local L = LibStub("AceLocale-3.0"):NewLocale("AllPlayed", "koKR")
if not L then return end

-- Generated from http://www.wowace.com/addons/all-played-laotseu/localization/
-- Translators: chkid, next96 and maknae

L["000.TOC Notes"] = "\235\170\168\235\147\160 \236\186\144\235\166\173\237\132\176\236\157\152 \237\148\140\235\160\136\236\157\180 \236\139\156\234\176\132, \237\156\180\236\139\157\234\178\189\237\151\152\236\185\152, \234\184\136\236\160\132\237\152\132\237\153\169 \234\184\176\235\161\157"
L["100%"] = true
L["150%"] = true
L["%.1f K XP"] = "%.1f \236\178\156 \234\178\189\237\151\152\236\185\152"
L["%.1f M XP"] = "%.1f \235\176\177\235\167\140 \234\178\189\237\151\152\236\185\152"
L["%.2f iLvl"] = "\236\149\132\236\157\180\237\133\156 \235\160\136\235\178\168 :  %.2f" -- Needs review
L["AB Marks"] = "\235\182\132\236\167\128 \236\160\144\236\136\152"
L["About"] = "...\235\140\128\237\149\152\236\151\172"
L["All Factions"] = "\235\170\168\235\147\160 \236\167\132\236\152\129"
L["All factions will be displayed"] = "\235\170\168\235\147\160 \236\167\132\236\152\129\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["/allplayed"] = true
L["All Played Breakdown"] = "\235\170\168\235\147\160 \237\148\140\235\160\136\236\157\180\237\149\156 \235\130\180\236\151\173"
L["AllPlayed Configuration"] = "AllPlayed \236\132\164\236\160\149"
L["All Realms"] = "\235\170\168\235\147\160 \234\179\132\236\160\149"
L["All realms will de displayed"] = "\235\170\168\235\147\160 \234\179\132\236\160\149\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["/ap"] = true
L["Arena Points"] = "\237\136\172\234\184\176\236\158\165 \236\160\144\236\136\152"
L["AV Marks"] = "\236\149\140\235\176\169 \236\160\144\236\136\152"
L["Badges of Justice"] = "\236\160\149\236\157\152\236\157\152 \235\172\184\236\158\165"
L["BC Installed?"] = "\235\182\136\236\132\177 \236\132\164\236\185\152\235\144\168?"
L["By experience"] = "\234\178\189\237\151\152\236\185\152"
L["By item level"] = "\236\149\132\236\157\180\237\133\156 \235\160\136\235\178\168" -- Needs review
L["By level"] = "\235\160\136\235\178\168"
L["By money"] = "\236\134\140\236\167\128\234\184\136"
L["By name"] = "\236\157\180\235\166\132"
L["By % rested"] = "% \237\156\180\236\139\157"
L["By rested XP"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152"
L["By time played"] = "\237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132"
L["Close"] = "\235\139\171\234\184\176"
L["Close the tooltip"] = "\237\136\180\237\140\129 \235\139\171\234\184\176"
L["Colorize Class"] = "\236\167\129\236\151\133\235\179\132 \236\131\137\236\131\129\237\153\148"
L["Colorize the character name based on class"] = "\236\167\129\236\151\133\236\157\132 \234\184\176\236\164\128\236\156\188\235\161\156 \236\186\144\235\166\173\237\132\176 \236\157\180\235\166\132\236\157\132 \236\131\137\236\131\129\237\153\148\237\149\169\235\139\136\235\139\164."
L["Configuration"] = "\236\132\164\236\160\149"
L["Conquest Points"] = "\236\160\149\235\179\181 \236\160\144\236\136\152"
L["Conquest Pts"] = "\236\160\149\235\179\181 \236\160\144\236\136\152\236\157\152 \236\152\181\236\133\152 \235\140\128\237\153\148 \236\131\129\236\158\144\236\151\144 \235\140\128\237\149\156 \236\149\189\236\185\173. \235\172\184\236\158\144\236\157\152 \234\184\184\236\157\180\235\138\148 12~14\236\158\144 \235\175\184\235\167\140\236\157\180\236\150\180\236\149\188 \237\149\169\235\139\136\235\139\164."
L["Delete Characters"] = "\236\186\144\235\166\173\237\132\176 \236\130\173\236\160\156" -- Needs review
-- L["DELETE_WARNING"] = ""
L["Display"] = "\237\153\148\235\169\180"
L["Display Delay"] = "\237\136\180\237\140\129 \236\167\128\236\151\176\236\139\156\234\176\132 \237\145\156\236\139\156" -- Needs review
L["Display the gold each character pocess"] = "\236\186\144\235\166\173\237\132\176 \235\179\132 \236\134\140\236\167\128\234\184\136\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Display the played time and the total time played"] = "\237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132\234\179\188 \237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132\236\157\152 \236\180\157\234\179\132\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Display the %s each character pocess"] = "%s\236\157\152 \234\176\129 \235\172\184\236\158\144 \236\178\152\235\166\172\235\176\169\236\139\157 \237\145\156\236\139\156"
L["Display the seconds in the time strings"] = "\236\139\156\234\176\132 \235\172\184\236\158\144\236\151\180\236\151\144 \236\180\136\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Display XP progress as a decimal value appended to the level"] = "\235\160\136\235\178\168\236\151\144 \236\134\140\236\136\152\236\160\144\236\157\132 \236\182\148\234\176\128\237\149\180 \234\178\189\237\151\152\236\185\152 \236\131\129\237\131\156\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Do not show Percent Rest"] = "% \237\156\180\236\139\157\234\178\189\237\151\152\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164."
L["Don't show location"] = "\236\156\132\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\152\236\167\128 \236\149\138\236\157\140"
L["%d rested XP"] = "%d \237\156\180\236\139\157\234\178\189\237\151\152\236\185\152"
L["%d XP"] = "%d \234\178\189\237\151\152\236\185\152"
L["EotS Marks"] = "\237\143\173\235\136\136 \236\160\144\236\136\152"
L["Erase character data permanantely"] = "\236\186\144\235\166\173\237\132\176 \235\141\176\236\157\180\237\132\176\235\165\188 \236\153\132\236\160\132\237\158\136 \236\130\173\236\160\156\237\149\169\235\139\136\235\139\164." -- Needs review
-- L["Erase data for %s of %s"] = ""
-- L["Erasing data for %s of %s"] = ""
L["Experience Points"] = "\234\178\189\237\151\152\236\185\152 \237\143\172\236\157\184\237\138\184"
L["Factions and Realms"] = "\236\132\156\235\178\132\236\153\128 \236\167\132\236\152\129"
L["Filter"] = "\235\182\132\235\165\152"
L["Hide characters from display"] = "\237\153\148\235\169\180\236\131\129\236\151\144 \236\186\144\235\166\173\237\132\176\235\165\188 \236\136\168\234\185\129\235\139\136\235\139\164."
L["Hide %s of %s from display"] = "\237\153\148\235\169\180\236\151\144 %s - %s\235\165\188 \236\136\168\234\185\129\235\139\136\235\139\164."
L["Honor Kills"] = "\235\170\133\236\152\136 \236\138\185\236\136\152"
L["Honor Points"] = "\235\170\133\236\152\136 \236\160\144\236\136\152"
L["How long should the tooltip be displayed after the mouse is moved out."] = "\235\167\136\236\154\176\236\138\164\235\165\188 \237\136\180\237\140\129\236\151\144 \236\156\132\236\185\152\236\139\156\236\188\176\236\157\132 \235\149\140 \235\170\135 \236\180\136 \237\155\132\236\151\144 \235\130\152\237\131\128\235\130\152\235\138\148\236\167\128 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164." -- Needs review
L["Ignore Characters"] = "\236\186\144\235\166\173\237\132\176 \236\160\156\236\153\184"
L["Is the Burning Crusade expansion installed?"] = "\235\182\136\237\131\128\235\138\148 \236\132\177\236\160\132 \237\153\149\236\158\165\237\140\169\236\157\180 \236\132\164\236\185\152\235\144\152\236\150\180 \236\158\136\236\138\181\235\139\136\234\185\140?"
L["Justice Points"] = "\236\160\149\236\157\152 \236\160\144\236\136\152"
L["Keep displaying the tooltip when the mouse is over it. If uncheck, the tooltip is displayed only when mousing over the icon."] = "\235\167\136\236\154\176\236\138\164\235\165\188 \236\157\180\235\143\153\236\139\156\236\188\176\236\157\132 \235\149\140 \237\136\180\237\140\129\236\157\132 \235\170\135 \236\180\136 \235\143\153\236\149\136 \237\145\156\236\139\156\237\149\160\236\167\128 \234\178\176\236\160\149\237\149\169\235\139\136\235\139\164. \236\132\160\237\131\157\237\149\152\236\167\128 \236\149\138\236\156\188\235\169\180 \235\167\136\236\154\176\236\138\164\235\165\188 \236\157\180\235\143\153\236\139\156\236\188\176\236\157\132\235\149\140\235\167\140 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164." -- Needs review
L["Lvl: %d"] = "\235\160\136\235\178\168 : %d" -- Needs review
L["Main Settings"] = "\236\163\188\236\154\148 \236\132\164\236\160\149"
L["Minimap Icon"] = "\235\175\184\235\139\136\235\167\181 \236\149\132\236\157\180\236\189\152"
L["None"] = "\236\151\134\236\157\140"
L["Opacity"] = "\237\136\172\235\170\133\235\143\132"
L["% opacity of the tooltip background"] = "\237\136\180\237\140\129 \235\176\176\234\178\189\236\157\152 \237\136\172\235\170\133\235\143\132"
L["Open configuration dialog"] = "\236\132\164\236\160\149 \236\176\189 \236\151\180\234\184\176"
L["Percent Rest"] = "\237\156\180\236\139\157\236\131\129\237\131\156 \235\176\177\235\182\132\236\156\168"
L["PVP"] = true
L["rested"] = "\237\156\180\236\139\157"
L["Rested XP"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152"
L["Rested XP Countdown"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152 \236\180\136\236\157\189\234\184\176"
L["Rested XP Total"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152 \236\180\157\234\179\132"
L["%s AP"] = "%s \237\136\172\236\160\144"
L["Scale"] = "\237\129\172\234\184\176"
L["Scale the tooltip (70% to 150%)"] = "\237\136\180\237\140\129\236\157\152 \237\129\172\234\184\176 (70% - 150%)"
L["%s characters "] = "%s \236\186\144\235\166\173\237\132\176 "
L["%s CP"] = "\236\160\149\235\179\181 \236\160\144\236\136\152\236\151\144 \235\140\128\237\149\156 \236\149\189\236\185\173 (\236\149\132\236\157\180\236\189\152\236\157\132 \236\130\172\236\154\169\237\149\152\236\167\128 \236\149\138\236\157\132 \236\139\156)"
L["Select the sort type"] = "\236\160\149\235\160\172 \237\152\149\236\139\157\236\157\132 \236\132\160\237\131\157\237\149\169\235\139\136\235\139\164."
L["Set the base for % display of rested XP"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152\235\165\188 %\235\161\156 \237\145\156\236\139\156\237\149\152\235\143\132\235\161\157 \234\184\176\235\179\184 \236\132\164\236\160\149\237\149\169\235\139\136\235\139\164."
L["Set the display options"] = "\237\153\148\235\169\180 \237\145\156\236\139\156 \236\132\164\236\160\149"
L["Set the PVP options"] = "PVP \237\145\156\236\139\156 \236\132\164\236\160\149"
L["Set the rested XP options"] = "\237\156\180\236\139\157\234\178\189\237\151\152\236\185\152 \237\145\156\236\139\156 \236\132\164\236\160\149"
L["Set the sort options"] = "\236\160\149\235\160\172 \237\145\156\236\139\156 \236\132\164\236\160\149"
L["Set UI options"] = "UI \236\152\181\236\133\152 \236\132\164\236\160\149"
L["%s HK"] = "%s \235\170\133\236\138\185"
L["Show Class Name"] = "\236\167\129\236\151\133\235\170\133 \237\145\156\236\139\156"
L["Show Gold"] = "\236\134\140\236\167\128\234\184\136 \237\145\156\236\139\156"
L["Show Guild Name"] = "\234\184\184\235\147\156\236\157\180\235\166\132 \237\145\156\236\139\156" -- Needs review
L["Show Item Level"] = "\236\149\132\236\157\180\237\133\156 \235\160\136\235\178\168 \237\145\156\236\139\156" -- Needs review
L["Show level total"] = "\236\160\132\236\178\180 \235\160\136\235\178\168 \237\145\156\236\139\156" -- Needs review
L["Show Location"] = "\236\156\132\236\185\152 \237\145\156\236\139\156"
L["Show Minimap Icon"] = "\235\175\184\235\139\136\235\167\181 \236\149\132\236\157\180\236\189\152 \237\145\156\236\139\156"
L["Show Played Time"] = "\237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132 \237\145\156\236\139\156"
L["Show PVP Totals"] = "PVP \236\180\157\234\179\132 \237\145\156\236\139\156"
L["Show %s"] = "%s \235\179\180\234\184\176"
L["Show Seconds"] = "\236\180\136 \237\145\156\236\139\156"
L["Show %s total"] = "\236\180\157 %s \235\179\180\234\184\176"
L["Show subzone"] = "\236\132\184\235\182\128\236\167\128\236\151\173 \237\145\156\236\139\156"
L["Show the Alterac Valley Marks"] = "\236\149\140\237\132\176\235\158\153 \234\179\132\234\179\161 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the Arathi Basin Marks"] = "\236\149\132\235\157\188\236\139\156 \235\182\132\236\167\128 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character arena points"] = "\236\186\144\235\166\173\237\132\176 \237\136\172\234\184\176\236\158\165 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character badges of Justice"] = "\236\186\144\235\166\173\237\132\176\236\157\152 \236\160\149\236\157\152\236\157\152 \235\172\184\236\158\165\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character class beside the level"] = "\235\160\136\235\178\168 \236\152\134\236\151\144 \236\186\144\235\166\173\237\132\176\236\157\152 \236\167\129\236\151\133\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character guild name"] = "\236\186\144\235\166\173\237\132\176\236\157\152 \234\184\184\235\147\156\236\157\180\235\166\132\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164." -- Needs review
L["Show the character honor kills"] = "\236\186\144\235\166\173\237\132\176 \235\170\133\236\152\136 \236\138\185\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character honor points"] = "\236\186\144\235\166\173\237\132\176 \235\170\133\236\152\136 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character item level (iLevel)"] = "\236\186\144\235\166\173\237\132\176\236\157\152 \236\149\132\236\157\180\237\133\156 \235\160\136\235\178\168\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164." -- Needs review
L["Show the character location"] = "\236\186\144\235\166\173\237\132\176\236\157\152 \236\156\132\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the character rested XP"] = "\236\186\144\235\166\173\237\132\176 \237\156\180\236\139\157\234\178\189\237\151\152\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the Eye of the Storm Marks"] = "\237\143\173\237\146\141\236\157\152 \235\136\136 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the honor related stats for all characters"] = "\235\170\168\235\147\160 \236\186\144\235\166\173\237\132\176\236\151\144 \235\140\128\237\149\156 \235\170\133\236\152\136 \236\131\129\237\131\156\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the time remaining before the character is 100% rested"] = "\236\186\144\235\166\173\237\132\176\234\176\128 100% \237\156\180\236\139\157\237\149\152\234\184\176 \236\160\132 \235\130\168\236\157\128 \236\139\156\234\176\132\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the total levels for all characters"] = "\235\170\168\235\147\160 \236\186\144\235\166\173\237\132\176\236\157\152 \236\160\132\236\178\180 \235\160\136\235\178\168\236\157\132 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164." -- Needs review
L["Show the total %s for all characters"] = "\235\170\168\235\147\160 \236\186\144\235\166\173\237\132\176\236\151\144 \235\140\128\237\149\156 \236\180\157 %s \235\179\180\234\184\176"
L["Show the total XP for all characters"] = "\235\170\168\235\147\160 \236\186\144\235\166\173\237\132\176\236\151\144 \235\140\128\237\149\156 \236\180\157 \234\178\189\237\151\152\236\185\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show the Warsong Gulch Marks"] = "\236\160\132\236\159\129\235\133\184\235\158\152 \237\152\145\234\179\161 \236\160\144\236\136\152\235\165\188 \237\145\156\236\139\156\237\149\169\235\139\136\235\139\164."
L["Show XP Progress"] = "\234\178\189\237\151\152\236\185\152 \236\131\129\237\131\156 \237\145\156\236\139\156"
L["Show XP total"] = "\234\178\189\237\151\152\236\185\152 \236\180\157\234\179\132 \237\145\156\236\139\156"
L["Show zone"] = "\236\167\128\236\151\173 \237\145\156\236\139\156"
L["Show zone/subzone"] = "\236\167\128\236\151\173/\236\132\184\235\182\128\236\167\128\236\151\173 \237\145\156\236\139\156"
L["%s HP"] = "%s \235\170\133\236\160\144"
L["%s JP"] = true
L["Sort"] = "\236\160\149\235\160\172"
L["Sort in reverse order"] = "\236\151\173\236\136\156\236\156\188\235\161\156 \236\160\149\235\160\172"
L["Sort Order"] = "\236\160\149\235\160\172 \236\136\156\236\132\156"
L["Sort Type"] = "\236\160\149\235\160\172 \237\152\149\236\139\157"
L["Specify what to display"] = "\237\145\156\236\139\156\237\149\160 \236\186\144\235\166\173\237\132\176 \236\132\164\236\160\149"
L["%s : %s"] = true
L["%s (%s)"] = "%s(%s)"
L["%s %s characters "] = "%s %s \236\186\144\235\166\173\237\132\176"
L["%s (%s or %s)"] = "%s (%s \235\152\144\235\138\148 %s)"
-- L["Sticky Tooltip"] = ""
L["%s VP"] = "%s \236\154\169\236\160\144"
L["Time Played"] = "\237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132"
L["Total Cash Value: "] = "\236\180\157 \236\134\140\236\167\128\234\184\136: "
L["Total Character Levels: "] = "\236\160\132\236\178\180 \236\186\144\235\166\173\237\132\176 \235\160\136\235\178\168:" -- Needs review
L["Total Justice Points: "] = "\236\180\157 \236\160\149\236\157\152 \236\160\144\236\136\152:"
L["Total PvP: "] = "PvP \236\180\157\234\179\132: "
L["Total %s Cash Value: "] = "%s \236\180\157 \236\134\140\236\167\128\234\184\136: "
L["Total %s Time Played: "] = "\236\180\157 %s \237\148\140\235\160\136\236\157\180 \236\139\156\234\176\132: "
L["Total Time Played: "] = "\236\180\157 \237\148\140\235\160\136\236\157\180\237\149\156 \236\139\156\234\176\132: "
L["Total Valor Points: "] = "\236\180\157 \236\154\169\235\167\185 \236\160\144\236\136\152:"
L["Total XP: "] = "\234\178\189\237\151\152\236\185\152 \236\180\157\234\179\132: "
L["UI"] = true
L["Unknown"] = "\236\149\140\236\136\152\236\151\134\236\157\140"
L["Use graphics for coin and PvP currencies"] = "PVP \236\163\188\237\153\148\236\153\128 \237\153\148\237\143\144\235\165\188 \236\156\132\237\149\156 \234\183\184\235\158\152\237\148\189\236\157\132 \236\130\172\236\154\169\237\149\169\235\139\136\235\139\164."
L["Use Icons"] = "\236\149\132\236\157\180\236\189\152 \236\130\172\236\154\169"
L["Use Old Shaman Colour"] = "\234\181\172 \236\163\188\236\136\160\236\130\172 \236\131\137\236\131\129 \236\130\172\236\154\169"
L["Use the curent sort type in reverse order"] = "\236\151\173\236\136\156\236\156\188\235\161\156 \237\152\132\236\158\172 \236\160\149\235\160\172 \237\152\149\236\139\157\236\157\132 \236\130\172\236\154\169\237\149\169\235\139\136\235\139\164."
L["Use the pre-210 patch colour for the Shaman class"] = "\236\163\188\236\136\160\236\130\172 \236\167\129\236\151\133\236\151\144 \235\140\128\237\149\180 \234\179\181\234\176\156-210 \237\140\168\236\185\152 \236\131\137\236\131\129\236\157\132 \236\130\172\236\154\169\237\149\169\235\139\136\235\139\164."
L["Valor Points"] = "\236\154\169\235\167\185 \236\160\144\236\136\152"
L["Version %s (r%s)"] = "\235\178\132\236\160\132 %s (r%s)"
L["v%s - %s (Type /ap for help)"] = "v%s - %s (\235\143\132\236\155\128\235\167\144\236\157\132 \235\179\180\235\160\164\235\169\180 /ap)"
L["WG Marks"] = "\235\133\184\235\158\152\235\176\169 \236\160\144\236\136\152"


