-- $Id: localization.fr.lua 158 2012-09-19 12:28:51Z arithmandar $
-- [[
-- Language: French
-- Translated by: oXid_FoX, Ksys
-- Last Updated: $Date: 2012-09-19 20:28:51 +0800 (Wed, 19 Sep 2012) $
-- ]]
--------------------------
-- Translatable strings --
--------------------------
if (GetLocale() == "frFR") then
FQ_Formats = {
	"QuêteNom",
	"[QuêteNiveau] QuêteNom",
	"[QuêteNiveau+] QuêteNom",
	"[QuêteNiveau+] QuêteNom (Tag)",
};
--
EPA_TestPatterns = {
 	"^(.+) : %s*[-%d]+%s*/%s*[-%d]+%s*$",
 	"^(.+) : terminée.$",				-- ERR_QUEST_COMPLETE_S			"%s : terminée."
 	"^(.+) \(Terminée)$",				-- ERR_QUEST_OBJECTIVE_COMPLETE_S	"%s (Terminée)"
-- 	"^Quête acceptée : .+$",			-- ERR_QUEST_ACCEPTED_S			"Quête acceptée : %s"
 	"^Expérience gagnée : .+$",			-- ERR_QUEST_REWARD_EXP_I		"Expérience gagnée : %d."
 	"^Découverte : .+$",				-- ERR_ZONE_EXPLORED			"Découverte : %s"
};
--
FQ_QUEST_TEXT =		"(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$";
--
FQ_LOADED = 		"|cff00ffffFastQuest Classic "..FASTQUEST_CLASSIC_VERSION.." est maintenant chargé. Tapez /fq pour plus de détails. Tapez /fq options pour ouvrir la fenêtre d'options.";
FQ_INFO =			"|cff00ffffFastQuest Classic: |r|cffffffff";
-- Strings in Option Frame
	FQ_OPT_OPTIONS_TITLE = "FastQuest - Options de base";
	FQ_OPT_FRM_NOTIFY_TITLE = "Options de notification";
	FQ_OPT_AUTONOTIFY_TITLE = "Auto-notification";
	FQ_OPT_AUTONOTIFY_TIP = "Notifier automatiquement les infos relatives à la quête aux joueurs proches, groupe, raid, et/ou membres de la guilde.";
	FQ_OPT_QUESTCOMPLETESOUND_TITLE	= "Quest Complete Sound"; -- Needs translation
	FQ_OPT_QUESTCOMPLETESOUND_TIP	= "Enable / Disable the notification sound when a quest is being completed."; -- Needs translation
	FQ_OPT_NOTIFYCHANNEL_TITLE = "Canal de notification";
	FQ_OPT_NOTIFYNEARBY_TITLE = "Notifier aux joueurs proches";
	FQ_OPT_NOTIFYNEARBY_TIP = "Notifier les infos relatives à la quête aux joueurs proches.";
	FQ_OPT_NOTIFYPARTY_TITLE = "Notifier au groupe";
	FQ_OPT_NOTIFYPARTY_TIP = "Notifier les infos relatives à la quête au membres du groupe.";
	FQ_OPT_NOTIFYRAID_TITLE = "Notifier au raid";
	FQ_OPT_NOTIFYRAID_TIP = "Notifier les infos relatives à la quête aux membres du raid.";
	FQ_OPT_NOTIFYGUILD_TITLE = "Notifier à la guilde";
	FQ_OPT_NOTIFYGUILD_TIP = "Notification des infos relatives à la quête aux membres de la guilde.";
	FQ_OPT_NOTIFYDETAIL_TITLE = "Notification des détails de la progression";
	FQ_OPT_NOTIFYDETAIL_TIP = "Notifier les détails de progression de la quête (exemple : 3/9 items) .";
	FQ_OPT_NOTIFYEXP_TITLE = "Notification du gain d'expérience";
	FQ_OPT_NOTIFYEXP_TIP = "Notifier l'expérience gagnée en complétant les quêtes.";
	FQ_OPT_NOTIFYZONE_TITLE = "Notification des découvertes de zone";
	FQ_OPT_NOTIFYZONE_TIP = "Notifier lorsqu'on découvre une nouvelle zone.";
	FQ_OPT_NOTIFYLEVELUP_TITLE = "Notification du level-up.";
	FQ_OPT_NOTIFYLEVELUP_TIP = "Notifier les information concernant le level-up.";
	FQ_OPT_FRM_QUESTFORMAT_TITLE = "Format d'affichage des quêtes";
	FQ_OPT_QUESTFORMAT_TITLE = "Choix du format d'affichage des quêtes";
	FQ_OPT_QUESTFORMAT_TIP = "Choix du format d'affichage des quêtes dans la fenêtre de discussion.";
	FQ_OPT_QUESTLOGOPTIONS_TITLE = "Options du journal de quêtes";
	FQ_OPT_COLOR_TITLE = "Activer les couleurs";
	FQ_OPT_COLOR_TIP = "Activer le changement de couleur des titres suivant la difficulté de la quête dans la liste de suivi.";
	FQ_OPT_MEMBERINFO_TITLE = "Afficher le nombre de joueurs suggérés";
	FQ_OPT_MEMBERINFO_TIP = "Afficher le nombre de joueurs suggérés dans le journal de quêtes.";
	FQ_OPT_MINIMAP_POSITION_TITLE = "Position sur la minimap";
	FQ_OPT_SHOWTYPE_TITLE = "Afficher le type de quêtes";
	FQ_OPT_SHOWTYPE_TIP = "Afficher le type de quêtes dans la liste de suivi.";
	FQ_OPT_NODRAG_TITLE				= "No Drag"; -- to translate
	FQ_OPT_NODRAG_TIP				= "Set the quest tracker window to be not dragable."; -- to translate
	FQ_OPT_LOCK_TITLE = "Verrouiller la liste de suivi des quêtes";
	FQ_OPT_LOCK_TIP = "Verrouiller la position de la liste de suivi des quêtes.";
	FQ_OPT_AUTOADD_TITLE = "Ajout/suppression automatique des quêtes";
	FQ_OPT_AUTOADD_TIP = "Ajout/suppression automatique des quêtes dans la liste de suivi.";
	FQ_OPT_AUTOCOMPLETE_TITLE = "Auto-validation des quêtes";
	FQ_OPT_AUTOCOMPLETE_TIP = "Valider automatiquement les quêtes finies.";
	FQ_OPT_FRM_MISC_TITLE = "Options diverses";
	FQ_OPT_SHOWMINIMAP_TITLE = "Afficher l'icône de la minimap";
	FQ_OPT_SHOWMINIMAP_TIP = "Afficher/masquer l'icône de la minimap";
	FQ_OPT_SOUNDSELECTION			= "Notification Sound: "; -- Needs translation
	FQ_BTN_OK = "OK";
	FQ_BTN_ABOUT = "Aout"; -- Needs review
	FQ_BTN_PREVIEW = "Extrait"; -- Needs review

	FQ_BUTTON_TOOLTIP = "Clic gauche pour ouvrir le journal de quêtes\nClic central pour les options Classic\nClic droit et glisser pour déplacer ce bouton.";
	FQ_TITAN_BUTTON_TOOLTIP = "Clic gauche pour ouvrir le journal de quêtes\nClic droit pour les options FastQuest Classic\n"; -- Needs review

-- Information Message
	FQ_INFO_NOTIFYGUILD = "Notifier aux membres de la guilde : ";
	FQ_INFO_NOTIFYRAID = "Notifier aux membres du raid : ";
	FQ_INFO_NOTIFYNEARBY = "Notifier aux joueurs proches : ";
	FQ_INFO_NOTIFYPARTY = "Notifier aux membres du groupe : ";
	FQ_INFO_AUTOADD = "Ajout/suppression automatique des quêtes dans la liste de suivi : ";
	FQ_INFO_AUTOCOMPLETE = "Auto-validation des quêtes : ";
	FQ_INFO_AUTONOTIFY = "Auto-notification : ";
	FQ_INFO_CLEAR = "Toutes les quêtes de la liste de suivi ont été supprimées. ";
	FQ_INFO_COLOR = "Le Titre des quêtes peut être affiché en différentes couleurs :";
	FQ_INFO_DETAIL = "Notification des détails de la progression des quêtes : ";
	FQ_INFO_DISPLAY_AS = "Format sélectionné : ";
	FQ_INFO_FORMAT = "Choix du format d'affichage des quêtes : ";
	FQ_INFO_LOCK = "La liste de suivi des quêtes a été |cffff0000verrouillée|r|cffffffff";
	FQ_INFO_QUESTCOMPLETESOUND		= "Quest completion notification sound: "; -- needs translation
	FQ_INFO_MEMBERINFO = "Affichage du nombre de joueurs suggérés : ";
	FQ_INFO_NODRAG =		"No-Dragging is now set to "; -- to translate
	FQ_INFO_NOTIFYDISCOVER = "Notification des zones que vous découvrez : ";
	FQ_INFO_NOTIFYEXP = "Notifier le nombre de points d'expérience des quêtes : ";
	FQ_INFO_NOTIFYLEVELUP = "Notification de la montée de niveau : ";
	FQ_INFO_QUEST_TAG = "Affichage des marqueurs de quête (Elite, PvP, Raid, etc.) dans la liste de suivi : ";
	FQ_INFO_RESET = "La position de la liste de suiv  a été réinitialisée";
	FQ_INFO_SHOWMINIMAP = "Montrer les icônes sur la minimap";
	FQ_INFO_UNLOCK = "La liste de suivi des quêtes a été |cff00ff00déverrouillée|r|cffffffff";
	FQ_INFO_USAGE = "|cffffff00utilisation: /fastquest [command] ou /fq [command]|r|cffffffff";
--
	FQ_MUST_RELOAD = "Vous devez recharger l'UI pour que ce changement soit effectif. Tapez /console reloadui";
--
	FQ_USAGE_NOTIFYGUILD = "Activer/désactiver la notification automatique aux membres de la guilde.";
	FQ_USAGE_NOTIFYRAID = "Activer/désactiver la notification automatique aux membres du raid.";
	FQ_USAGE_NOTIFYNEARBY = "Activer/désactiver la notification automatique aux joueurs proches.";
	FQ_USAGE_NOTIFYPARTY = "Activer/désactiver la notification automatique aux membres du groupe.";
	FQ_USAGE_AUTOADD = "Activer/désactiver la mise à jour automatique des quêtes dans la liste de suivi.";
	FQ_USAGE_AUTOCOMPLETE = "Activer/désactiver l'auto-validation des quêtes lorsque vous les rendez. (Vous ne verrez pas les infos de fin de quête du PNJ.)";
	FQ_USAGE_AUTONOTIFY = "Activer/désactiver la notification automatique aux membres du groupe";
	FQ_USAGE_CLEAR = "Vider complêtement la liste des quêtes.";
	FQ_USAGE_COLOR = "Activer/désactiver la coloration du titre des quêtes dans la liste de suivi.";
	FQ_USAGE_DETAIL = "Activer/désactiver la notification simplifiée des quêtes.";
	FQ_USAGE_FORMAT = "Changement du format d'affichage des quêtes.";
	FQ_USAGE_LOCK = "Verrouille/déverrouille la liste de suivi.";
	FQ_USAGE_MEMBERINFO = "Activer/désactiver l'affichage du nombre de joueurs suggérés.";
	FQ_USAGE_NODRAG =		"Toggle dragging of quest tracker. Vous devez rechargez l'UI pour que ce changement soit effectif."; -- to translate
	FQ_USAGE_NOTIFYDISCOVER = "Activer/désactiver la notification automatique des zones que vous découvrez.";
	FQ_USAGE_NOTIFYEXP = "Activer/désactiver la notification automatique du gain d'expérience des quêtes.";
	FQ_USAGE_NOTIFYLEVELUP = "Activer/désactiver la notification automatique lors du level-up.";
	FQ_USAGE_RESET = "Réinitialise la position de la liste de suivi.";
	FQ_USAGE_STATUS = "Affiche l'état de toutes les options de FastQuest Classic.";
	FQ_USAGE_OPTIONS = "Afficher/cacher la fenêtre des options.";
	FQ_USAGE_TAG = "Affichage des marqueurs de quête (Elite, PvP, Raid, etc.)";
--
	--BINDING_CATEGORY_FASTQUEST_CLASSIC		= "Quest Enhancement"; -- to translate ?
	BINDING_HEADER_FASTQUEST_CLASSIC = "FastQuest Classic";
	BINDING_NAME_FASTQUEST_OPTIONS = "Basculer en Options Classic";
	BINDING_NAME_FQ_TAG = "Marquage des quêtes O/N";
	BINDING_NAME_FQ_FORMAT = "Format d'affichage des quêtes";
	BINDING_NAME_FQ_AOUTNOTIFY = "Auto-notification de progression des quêtes";
	BINDING_NAME_FQ_AOUTCOMPLETE = "Auto-validation des quêtes";
	BINDING_NAME_FQ_AOUTADD = "Ajout/suppression automatique des quêtes";
	BINDING_NAME_FQ_LOCK = "Verrouiller/déverrouiller le suivi des quêtes";
--
	FQ_QUEST_PROGRESS = "Progression de la quête : ";
	FQ_QUEST_ACCEPTED	= "Quête acceptée : ";
--
	FQ_QUEST_ISDONE = " est maintenant terminée!";
	FQ_QUEST_COMPLETED = " (Quête terminée)";
	FQ_DRAG_DISABLED = "FastQuest Classic: Le Drag'n Drop est désactivé, utilisez /fq nodrag pour activer/désactiver. Vous devrez aussi rechargez l'UI pour que ce changement soit effectif";
--
	FQ_ENABLED = "|cff00ff00Activé|r|cffffffff";
	FQ_DISABLED = "|cffff0000Désactivé|r|cffffffff";
	FQ_LOCK = "|cffff0000Verrouillé|r|cffffffff";
	FQ_UNLOCK = "|cff00ff00Déverrouillé|r|cffffffff";
--
end
