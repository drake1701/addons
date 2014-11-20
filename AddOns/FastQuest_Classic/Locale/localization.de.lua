-- $Id: localization.de.lua 157 2012-09-18 16:04:38Z arithmandar $
-- [[
-- Language: German
-- Translated by:  Killekille of Blackrock; 
-- Last Updated: $Date: 2012-09-19 00:04:38 +0800 (Wed, 19 Sep 2012) $
-- ]]
--------------------------
-- Translatable strings --
--------------------------
if (GetLocale() == "deDE") then
FQ_Formats = {
	"QuestName",
	"[QuestLevel] QuestName",
	"[QuestLevel+] QuestName",
	"[QuestLevel+] QuestName (Tag)",
};
--
EPA_TestPatterns = {
 	"^(.+): %s*[-%d]+%s*/%s*[-%d]+%s*$",
 	"^(.+)[^Handel] abgeschlossen.$",		-- ERR_QUEST_COMPLETE_S: "%s abgeschlossen."
 	"^(.+)\(Abgeschlossen\)%s$",			-- ERR_QUEST_OBJECTIVE_COMPLETE_S: "%s (Abgeschlossen)"
-- 	"^Quest angenommen: .+$",			-- ERR_QUEST_ACCEPTED_S: "Quest angenommen: %s"
 	"^Erhaltene Erfahrung: .+$",			-- ERR_QUEST_REWARD_EXP_I: "Erhaltene Erfahrung: %d."
 	"^Entdeckt: .+$",				-- ERR_ZONE_EXPLORED: "Entdeckt: %s"
};
--
FQ_QUEST_TEXT =		"(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$";		-- -- ERR_QUEST_ADD_FOUND_SII = "%1$s: %2$d/%3$d", ERR_QUEST_ADD_ITEM_SII = "%1$s: %2$d/%3$d", ERR_QUEST_ADD_KILL_SII = "%1$s getötet: %2$d/%3$d"
--
FQ_LOADED = 		"|cff00ffffFastQuest Classic "..FASTQUEST_CLASSIC_VERSION.." ist nun geladen. Gib /fq ein für mehr Details. Type /fq options to toggle option frame.";
FQ_INFO =			"|cff00ffffFastQuest Classic: |r|cffffffff";
-- Strings in Option Frame
FQ_OPT_OPTIONS_TITLE			= "FastQuest Classic Optionen"; 
FQ_OPT_FRM_NOTIFY_TITLE			= "Benachrichtigungsoptionen"; 
FQ_OPT_AUTONOTIFY_TITLE			= "Automatisch benachrichtigen"; 
FQ_OPT_AUTONOTIFY_TIP			= "In der Nähe befindliche Gruppen-, Raid- und/oder Gildenmitglieder automatisch über Quest-Informationen benachrichtigen.";
FQ_OPT_QUESTCOMPLETESOUND_TITLE		= "Questabschlusssound";
FQ_OPT_QUESTCOMPLETESOUND_TIP		= "Ein-/Ausschalten des Benachrichtigungssounds bei Questabschluss.";
FQ_OPT_NOTIFYCHANNEL_TITLE		= "Notify Channel"; -- Needs translation
FQ_OPT_NOTIFYNEARBY_TITLE		= "Notify Nearby"; -- Needs translation
FQ_OPT_NOTIFYNEARBY_TIP			= "Notify nearby for the quest related information."; -- Needs translation
FQ_OPT_NOTIFYPARTY_TITLE		= "Notify Party"; -- Needs translation
FQ_OPT_NOTIFYPARTY_TIP			= "Notify party members for the quest related information."; -- Needs translation
FQ_OPT_NOTIFYRAID_TITLE			= "Notify Raid"; -- Needs translation
FQ_OPT_NOTIFYRAID_TIP			= "Notify raid members for the quest related information."; -- Needs translation
FQ_OPT_NOTIFYGUILD_TITLE		= "Notify Guild"; -- Needs translation
FQ_OPT_NOTIFYGUILD_TIP			= "Notify guild members for the quest related information."; -- Needs translation
FQ_OPT_NOTIFYDETAIL_TITLE		= "Notify Details"; -- Needs translation
FQ_OPT_NOTIFYDETAIL_TIP			= "Notify the detail quest progress."; -- Needs translation
FQ_OPT_NOTIFYEXP_TITLE			= "Notify Experience Gained"; -- Needs translation
FQ_OPT_NOTIFYEXP_TIP			= "Notify the experience gained from a completed quest."; -- Needs translation
FQ_OPT_NOTIFYZONE_TITLE			= "Notify Zone Discovered"; -- Needs translation
FQ_OPT_NOTIFYZONE_TIP			= "Notify the new zone being discovered."; -- Needs translation
FQ_OPT_NOTIFYLEVELUP_TITLE		= "Notify Level Up"; -- Needs translation
FQ_OPT_NOTIFYLEVELUP_TIP		= "Notify the level up information."; -- Needs translation
FQ_OPT_FRM_QUESTFORMAT_TITLE		= "Format-Optionen zur Questanzeige";
FQ_OPT_QUESTFORMAT_TITLE		= "Select Quest Display Format"; -- Needs translation
FQ_OPT_QUESTFORMAT_TIP			= "Select the quest display format to show in chat frame."; -- Needs translation
FQ_OPT_QUESTLOGOPTIONS_TITLE		= "Quest Log Options"; -- Needs translation
FQ_OPT_COLOR_TITLE			= "Farbe einschalten";
FQ_OPT_COLOR_TIP			= "Den Questtitel im QuestTracker-Fenster in einer anderen Farbe anzeigen, abhängig vom Schwierigkeitsgrad.";
FQ_OPT_MEMBERINFO_TITLE			= "Display Suggested Member Info"; -- Needs translation
FQ_OPT_MEMBERINFO_TIP			= "Display the quest's suggested member info in the quest log window."; -- Needs translation
FQ_OPT_MINIMAP_POSITION_TITLE		= "MiniMap Position"; -- Needs translation
FQ_OPT_SHOWTYPE_TITLE			= "Show Quest Type"; -- Needs translation
FQ_OPT_SHOWTYPE_TIP			= "Show the quest type in quest tracker window."; -- Needs translation
FQ_OPT_NODRAG_TITLE			= "Nicht verschieben";
FQ_OPT_NODRAG_TIP			= "Setze das Questtracker-Fenster auf nicht verschiebbar.";
FQ_OPT_LOCK_TITLE			= "QuestTracker sperren";
FQ_OPT_LOCK_TIP				= "Die Position des QuestTracker-Fensters sperren.";
FQ_OPT_AUTOADD_TITLE			= "Automatisches Hinzufügen/Entfernen von Quests";
FQ_OPT_AUTOADD_TIP			= "Automatisches Hinzufügen/Entfernen von Quests in das QuestTracker-Fenster.";
FQ_OPT_AUTOCOMPLETE_TITLE		= "Auto Complete"; -- Needs translation
FQ_OPT_AUTOCOMPLETE_TIP			= "Automatisch abgeschlossene Quests abgeben.";
FQ_OPT_FRM_MISC_TITLE			= "Verschiedene Optione";
FQ_OPT_SHOWMINIMAP_TITLE		= "Show Minimap Icon"; -- Needs translation
FQ_OPT_SHOWMINIMAP_TIP			= "Toggle show minimap icon."; -- Needs translation
FQ_OPT_SOUNDSELECTION			= "Benachrichtigungston: ";
FQ_BTN_OK				= "OK";
FQ_BTN_ABOUT				= "Über ";
FQ_BTN_PREVIEW				= "Vorschau";

FQ_BUTTON_TOOLTIP			= "Linke Maustaste drücken, um Quest Log zu öffnen.\nMittlere Maustaste drücken, um FastQuest Classic Optionen anzuzeigen.\nRechte Maustaste gedrückt halten, um diesen Schalter zu verschieben.";
FQ_TITAN_BUTTON_TOOLTIP			= "Linksklick, um QuestLog zu öffnen.\nRechtsklick, um FastQuest Classic Optionen.";

-- Information Message
FQ_INFO_NOTIFYGUILD 		= "Automatisch die Gilden-Mitglieder über deinen Quest-Fortschritt benachrichtigen: ";
FQ_INFO_NOTIFYRAID 		= "Automatische Benachrichtigung der Raid-Mitglieder über deinen Quest-Fortschritt wurde";
FQ_INFO_NOTIFYNEARBY 		= "Notify nearby members regarding my quest progress: ";
FQ_INFO_NOTIFYPARTY 		= "Notify party members regarding my quest progress: ";
FQ_INFO_AUTOADD 		= "Automatisches Hinzufügen/Entfernen von geänderten Quests zum QuestTracker: ";
FQ_INFO_AUTOCOMPLETE 		= "Automatisches Quest beenden wurde ";
FQ_INFO_AUTONOTIFY 		= "Automatische Benachrichtigung der Gruppenmitglieder über deinen Quest-Fortschritt wurde ";
FQ_INFO_CLEAR 			= "Alle Quest-Tracker Quests wurden gelöscht ";
FQ_INFO_COLOR 			= "Quest-Titel werden in anderer Farbe anzeigt:";
FQ_INFO_DETAIL 			= "Benachrichtigen über Details zum Questfortschritt: ";
FQ_INFO_DISPLAY_AS 		= "Gewähltes Format: ";
FQ_INFO_FORMAT 			= "Zwischen Ausgabeformaten umschalten ";
FQ_INFO_LOCK 			= "Bewegbare Komponenten wurden |cffff0000gesperrt|r|cffffffff";
FQ_INFO_QUESTCOMPLETESOUND	= "Sound bei Questabschluss: ";
FQ_INFO_MEMBERINFO 		= "Quest's suggested to go with group info is now ";
FQ_INFO_NODRAG 			= "Nicht -Ziehen ist gesetzt auf ";
FQ_INFO_NOTIFYDISCOVER 		= "Über neu entdeckte Gebite benachrichtigen. ";
FQ_INFO_NOTIFYEXP 		= "Über die gewonnenen Erfahrungspunkte der Quest benachrichtigen. ";
FQ_INFO_NOTIFYLEVELUP 		= "Notify the level-up information: ";
FQ_INFO_QUEST_TAG 		= "Anzeige der Quest-Tags im QuestTracker wurde ";
FQ_INFO_RESET 			= "Bewegbare Komponenten wurden zurückgesetzt";
FQ_INFO_SHOWMINIMAP 		= "Icon an der Minimap anzeigen: ";
FQ_INFO_UNLOCK 			= "Bewegbare Komponenten wurden |cff00ff00entsperrt|r|cffffffff";
FQ_INFO_USAGE 			= "|cffffff00benutze: /fastquest [befehl] oder /fq [befehl]|r|cffffffff";
--
FQ_MUST_RELOAD 			= "Das UI muss neu geladen werden, damit die Änderungen wirksam werden. Gib /console reloadui ein";
--
FQ_USAGE_NOTIFYGUILD 		= "Umschalten der automatischen Benachrichtigung von Gilden-Mitgliedern.";
FQ_USAGE_NOTIFYRAID 		= "Umschalten der automatischen Benachrichtigung von Raid-Mitgliedern.";
FQ_USAGE_NOTIFYNEARBY 		= "Toggle automatic notification to nearby area.";
FQ_USAGE_NOTIFYPARTY 		= "Toggle automatic notification of party members.";
FQ_USAGE_AUTOADD 		= "Umschalten des automatischen Hinzufügens von geänderten Quests zum Quest-Tracker.";
FQ_USAGE_AUTOCOMPLETE 		= "Umschalten der automatischen Beendigung von Quests beim Abgeben. (Die Beenden-Meldung des NPC wird dabei nicht angezeigt!!)";
FQ_USAGE_AUTONOTIFY 		= "Umschalten der automatischen Benachrichtigung von Gruppenmitgliedern.";
FQ_USAGE_CLEAR 			= "QuestTracker-Fenster aus allen Quests löschen.";
FQ_USAGE_COLOR 			= "Farbigen Quest-Titel im Quest-Tracker-Fenster umschalten.";
FQ_USAGE_DETAIL 		= "Umschalten zwischen kurzer und detaillierter Quest-Benachrichtigung.";
FQ_USAGE_FORMAT 		= "Ausgabeformat der Benachrichtigungen umschalten.";
FQ_USAGE_LOCK 			= "(ent)sperrt das Quest-Tracker-Fenster.";
FQ_USAGE_MEMBERINFO 		= "Toggle quest's suggested to go with group info to be displayed or not.";	-- TO BE TRANSLATED
FQ_USAGE_NODRAG 		= "Verschieben des QuestTrackers umschalten. Neuladen des UI notwendig.";
FQ_USAGE_NOTIFYDISCOVER 	= "Toggle automatic notification of the new zone you discovered.";
FQ_USAGE_NOTIFYEXP 		= "Toggle automatic notification of experience gained from a quest.";
FQ_USAGE_NOTIFYLEVELUP 		= "Toggle automatic notification of level-up information.";
FQ_USAGE_RESET 			= "Zurücksetzen der beweglichen Komponenten von FastQuest Classic(Ziehen muss aktiviert sein).";
FQ_USAGE_STATUS 		= "Den FastQuest Classic Konfigurationsstatus anzeigen.";
FQ_USAGE_OPTIONS 		= "Toggle option frame.";
FQ_USAGE_TAG 			= "Anzeige der Quest-Tags umschalten (Elite, Raid, etc.) ";
--
--BINDING_CATEGORY_FASTQUEST_CLASSIC	= "Quest Erweiterung";
BINDING_HEADER_FASTQUEST_CLASSIC	= "FastQuest Classic";
BINDING_NAME_FASTQUEST_OPTIONS		= "FastQuest Classic Optionen";
BINDING_NAME_FQ_TAG			= "Quest Tag";
BINDING_NAME_FQ_FORMAT			= "Quest Format";
BINDING_NAME_FQ_AOUTNOTIFY		= "Auto-Benachrichtigung Gruppe";
BINDING_NAME_FQ_AOUTCOMPLETE		= "Auto-Bestätigen Quest";
BINDING_NAME_FQ_AOUTADD			= "Auto-Hinzufügen QuestTracker";
BINDING_NAME_FQ_LOCK			= "QuestTracker sperren/freigeben";
--
FQ_QUEST_PROGRESS 		= "Quest-Fortschritt: ";
FQ_QUEST_ACCEPTED		= "Quest angenommen:  ";
--
FQ_QUEST_ISDONE 		= " ist nun fertig!";
FQ_QUEST_COMPLETED 		= " (FERTIG)";
FQ_DRAG_DISABLED 		= "FastQuest Classic: Ziehen ist ausgeschaltet, benutze /fq nodrag zum Umschalten. Das UI muss danach neu geladen werden";
--
FQ_ENABLED 			= "|cff00ff00eingeschaltet|r|cffffffff";
FQ_DISABLED 			= "|cffff0000ausgeschaltet|r|cffffffff";
FQ_LOCK 			= "|cffff0000gesperrt|r|cffffffff";
FQ_UNLOCK 			= "|cff00ff00entsperrt|r|cffffffff";

end
