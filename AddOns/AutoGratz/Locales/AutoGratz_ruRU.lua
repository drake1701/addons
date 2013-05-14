-- AutGratz localization file
-- Lang-code: ruRU
-- Author: Kiritoss, Moonworg
-- Version: 2.0.2

local L = LibStub("AceLocale-3.0"):NewLocale("AutoGratz", "ruRU")

if not L then return end

-- General
L["Loaded"] = "AutoGratz загружен."
L["autoratz"] = true
L["ag"] = true
L["Party"] = true
L["Raid"] = true
L["Guild"] = true
L["Nearby"] = true
L["Whisper"] = true

-- About (Options)
L["Version"] = "Версия"
L["Authors"] = "Авторы"
L["Translators"] = "Переводчики"
L["Category"] = "Категория"
L["Website"] = "Вебсайт"
L["License"] = "Лицензия"

-- Gratz (Options)
L["Gratz Settings"] = "Настройки"
L["Achieve Message Label"] = "Сообщение при получении достижения"
L["Achieve Message Desc"] = "Сообщение, которое будет отображаться, когда кто-то получил достижение."
L["Achieve Message Usage"] = "Используйте '#n' как ник игрока в сообщении, используйте ';' для разделения сообщений."
L["Achieve Message"] = "Грац #n"
L["MultiAchieve Message Label"] = "Массовое сообщение получения достижения"
L["MultiAchieve Message Desc"] = "Сообщение, которое будет отображаться, когда несколько человек получают достижение."
L["MultiAchieve Message Usage"] = "Используйте ';' для разделения сообщений."
L["MultiAchieve Message"] = "Грац парни!"
L["Delay"] = "Задержка"
L["Delay Desc"] = "Время (в секундах) для сообщения."
L["Delay2"] = "Задержка 2"
L["Delay2 Desc"] = "Если больше, чем 'Задержка', сообщение будет отправлено случайно в период между 'Задержка' и 'Задержка 2'."
L["Run On Achievement"] = "При выполнении достижения"
L["Run On Achievement Desc"] = "Каналы на которых будет ожидаться выполнение достижений."

-- Ding (Options)
L["Ding Settings"] = "Ding Settings"
L["Ding Message Label"] = "Ding Message"
L["Ding Message Desc"] = "The message to be displayed when a player sends a ding."
L["Ding Message Usage"] = "Используйте ';' для разделения сообщений."
L["Ding Message"] = "Грац #n"
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