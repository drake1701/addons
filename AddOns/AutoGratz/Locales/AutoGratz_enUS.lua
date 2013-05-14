-- AutGratz localization file
-- Lang-code: enUS
-- Author: Spectre7, Moonworg
-- Version: 2.0.2

local L = LibStub("AceLocale-3.0"):NewLocale("AutoGratz", "enUS", true)

if not L then return end

-- General
L["Loaded"] = "AutoGratz loaded."
L["autoratz"] = true
L["ag"] = true
L["Party"] = true
L["Raid"] = true
L["Guild"] = true
L["Nearby"] = true
L["Whisper"] = true

-- About (Options)
L["Version"] = "Version"
L["Authors"] = "Authors"
L["Translators"] = "Translators"
L["Category"] = "Category"
L["Website"] = "Website"
L["License"] = "License"

-- Gratz (Options)
L["Gratz Settings"] = "Gratz Settings"
L["Achieve Message Label"] = "Achievement Message"
L["Achieve Message Desc"] = "The message to be displayed when someone get an achievement."
L["Achieve Message Usage"] = "Use '#n' for the player's name, use ';' to seperate messages."
L["Achieve Message"] = "Congratz #n"
L["MultiAchieve Message Label"] = "Multiple Achievements Message"
L["MultiAchieve Message Desc"] = "The message to be displayed when multiple people get achievements."
L["MultiAchieve Message Usage"] = "Use ';' to seperate messages."
L["MultiAchieve Message"] = "Congratz Guys"
L["Delay"] = "Delay"
L["Delay Desc"] = "The time(in seconds) it takes for the addon to reply."
L["Delay2"] = "Delay 2"
L["Delay2 Desc"] = "If higher than 'Delay', the message will be sent randomly in the time between 'Delay' and 'Delay 2'."
L["Run On Achievement"] = "Run On Achievement"
L["Run On Achievement Desc"] = "Which channels the addon will listen for achievements on."

-- Ding (Options)
L["Ding Settings"] = "Ding Settings"
L["Ding Message Label"] = "Ding Message"
L["Ding Message Desc"] = "The message to be displayed when a player sends a ding."
L["Ding Message Usage"] = "Use ';' to seperate messages."
L["Ding Message"] = "Congratz #n"
L["Spam Delay"] = "Spam Delay"
L["Spam Delay Desc"] = "The time (in seconds) it takes for the same person to trigger the add by saying ding."
L["Run On Ding"] = "Run On Ding"
L["Run On Ding Desc"] = "Which channels the addon will listen for 'ding' on."

-- Further (Options)
L["Further Settings"] = "Further Settings"
L["Afk"] = "Run When AFK"
L["Afk Desc"] = "Toggles if the addon will run when you are afk."

-- Slashcommands
L["about"] = "About"
L["about_desc"] = "About AutoGratz"
L["gratz"] = "Gratz"
L["gratz_desc"] = "Gratz Settings"
L["ding"] = "Ding"
L["ding_desc"] = "Ding Settings"
L["further"] = "Further Settings"
L["further_desc"] = "Weitere Einstellungen"
L["profiles"] = "Profiles"
L["profiles_desc"] = "Profile Settings"