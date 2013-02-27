-- Do not translate here!!
-- Please go to http://www.wowace.com/addons/zomgbuffs/localization/

do
local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "enUS", true)
if not L then return end

L["Group Buff Configuration"]						= true
L["Anchor"]											= true
L["Invert"]											= true
L["Invert the need/got alpha values"]				= true
L["%s needs %s"]									= true
L["Group %d needs %s"]								= true
L["Templates"]										= true
L["Template configuration"]							= true
L["Group Spells"]									= true
L["Group spell configuration"]						= true
L["Single Spells"]									= true
L["Single spell configuration"]						= true
L["Groups"]											= true
L["Select the groups to buff"]						= true
L["Group %d"]										= true
L["Enable buffing of this group"]					= true
L["Group Template: "]								= true
L["(modified)"]										= true
L["none"]											= true
L["Enabled"]										= true
L["Disabled"]										= true
L["Behaviour"]										= true
L["Group buffing behaviour"]						= true
L["Expiry Prelude"]									= true
L["Default rebuff prelude for all group buffs"]		= true
L["Rebuff prelude for %s (0=Module default)"]		= true
L["Mark"]											= true
L["Minimum Group"]									= true
L["How many players of a group must need a buff before the group version is cast"] = true
L["%s on %s%s"]										= true
L["%s on %s"]										= true
L["Auto-Assign"]									= true
L["Auto assign sensible group assignment based the order of your name alphabilically compared to others of your class. All going well, and all using ZOMGBuffs and everyone should end up with different assignments without need for discussion"] = true
L["You are now responsible for Groups %s"]			= true
L[" and "]											= true
L["Warning: %s has auto-assigned themselves to buff groups %s, but you have the Auto Group Assignment option disabled"] = true
L["Reset on Clear"]								= true
L["If noone is selected for this buff when you disable it, then the next time it is enabled, everyone will default to ON. If disabled, the last settings will be remembered"] = true
L["%d of %d stacks remain"]							= true
L["%s remains"]										= true
L["Tracker"]										= true
L["Tracker Icon for single target exclusive buffs"]	= true
L["Enable"]											= true
L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"] = true
L["Scale"]											= true
L["Adjust the scale of the tracking icon"]			= true
L["Reset"]											= true
L["Reset the position of the tracker icon"]			= true
L["Spell Tracker"]									= true
L["MISSING!"]										= true
L["%s has expired on %s"]							= true
L["%s cooldown ready for %s"]						= true
L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"] = true
L["Sound"]											= true
L["Select a soundfile to play when player's tracked buff expires"] = true
L["This button is not clickable because it was created after you entered combat"] = true
L["Learnable"]										= true
L["Remember this spell when it's cast manually?"]	= true
L["Key-Binding"]									= true
L["Define the key used for rebuffing %s from it's Spell Tracker icon"] = true
L["No Auto-cast"]									= true
L["Disables auto-casting for %s in favor of rebuffing via tracker icons or their hotkeys"] = true
L["Lock"]											= true
L["Lock all the Tracker icons to their current position"] = true

L["TICKCLICKHELP1"]								= "|cFFFFFFFFClick|r to toggle player"
L["TICKCLICKHELP2"]								= "|cFFFFFFFFRight-Click|r to toggle everyone"
L["TICKCLICKHELP3"]								= "|cFFFFFFFFAlt-Click|r to toggle $class"
L["TICKCLICKHELP4"]								= "|cFFFFFFFFShift-Click|r to toggle $party"
end


if (GetLocale() == "deDE") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "deDE", true)
	if not L then return end
	L["Adjust the scale of the tracking icon"] = "Größe des Tracker Symbols einstellen"
L["Anchor"] = "Anker"
L[" and "] = " und"
L["Auto-Assign"] = "Auto-Einteilungen"
L["Behaviour"] = "Verhalten"
L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"] = "Erstelle ein Überwachungsysmbol für exklusive Stärkungszauber (Erdschild, Furchtzauberschutz, etc.). Denke bitte daran, dass das Symbol immer den korrekten Status des Zaubers anzeigt, aber nicht zum Erneuern auf dem aktuellen Ziel genutzt werden kann, sobald er während des Kampfes auf ein anderes Ziel gewirkt worden ist."
L["Default rebuff prelude for all group buffs"] = "Standard Erneuerungsvorlauf für alle Gruppenstärkungszauber"
L["Define the key used for rebuffing %s from it's Spell Tracker icon"] = "Wähle die Taste um %s über das Stärkungszauber Beobachtungs Symbol zu erneuern"
L["Disabled"] = "Ausgeschaltet"
L["%d of %d stacks remain"] = "%d von %d Aufladungen verbleibend"
L["Enable"] = "Einschalten"
L["Enable buffing of this group"] = "Schalte Stärkungszauber für diese Gruppe ein"
L["Enabled"] = "Eingeschaltet"
L["Expiry Prelude"] = "Auslaufvorlaufzeit"
L["Group Buff Configuration"] = "Stärkungszauberkonfiguration für Gruppen"
L["Group buffing behaviour"] = "Verhalten für Gruppenstärkungszauber"
L["Group %d"] = "Gruppe %d"
L["Group %d needs %s"] = "Gruppe %d benötigt %s"
L["Groups"] = "Gruppen"
L["Group spell configuration"] = "Gruppenzauber Konfiguration"
L["Group Spells"] = "Gruppenzauber"
L["Group Template: "] = "Gruppenvorlage:"
L["How many players of a group must need a buff before the group version is cast"] = "Anzahl der Gruppenmitglieder, die einen Stärkungszauber benötigen bevor Gruppenstärkungszauber benutzt werden"
L["Invert"] = "Umkehren"
L["Invert the need/got alpha values"] = "Vertausche die benötigt/bekommen Alpha Werte"
L["Key-Binding"] = "Tastenbelegung"
L["Learnable"] = "Lernfähig"
L["Mark"] = "Markierung"
L["Minimum Group"] = "Minimale Gruppe"
L["MISSING!"] = "FEHLT!"
L["(modified)"] = "(verändert)"
L["No Auto-cast"] = "Kein automatisches Wirken von Zaubern"
L["none"] = "kein"
L["Rebuff prelude for %s (0=Module default)"] = "Auslaufvorlaufzeit für %s (0=Standardeinstellung)"
L["Remember this spell when it's cast manually?"] = "Soll dieser Zauber beibehalten werden, sobald er manuell gewirkt worden ist?"
L["Reset"] = "Zurücksetzen"
L["Reset on Clear"] = "Zurücksetzen beim Säubern"
L["Reset the position of the tracker icon"] = "Setze die Position des Überwachungssymbols zurück"
L["Scale"] = "Skalierung"
L["%s cooldown ready for %s"] = "%s Cooldown bereit für %s"
L["Select a soundfile to play when player's tracked buff expires"] = "Wähle die Audiodatei, die beim Auslaufen eines Stärkungszaubers wiedergegeben werden soll"
L["Select the groups to buff"] = "Wähle die Gruppen, die Stärkungszauber erhalten sollen"
L["%s has expired on %s"] = "%s auf %s ist ausgelaufen"
L["Single spell configuration"] = "Einzelzielzauberkonfiguration"
L["Single Spells"] = "Einzel Zauber"
L["%s needs %s"] = "%s benötigt %s"
L["%s on %s"] = "%s auf %s"
L["%s on %s%s"] = "%s auf %s%s"
L["Sound"] = "Sound"
L["Spell Tracker"] = "Zauberüberwacher"
L["%s remains"] = "%s verbleibend"
L["Template configuration"] = "Vorlagenkonfiguration"
L["Templates"] = "Vorlagen"
L["This button is not clickable because it was created after you entered combat"] = "Diese Schaltfläche kann nicht angeklickt werden, da sie erstellt worden ist, nachdem du den Kampf beigetreten bist"
L["TICKCLICKHELP1"] = "|cFFFFFFFFKlick|r um auf Spieler zu wechseln"
L["TICKCLICKHELP2"] = "|cFFFFFFFFRechtsklick|r um auf jeden zu wechseln"
L["TICKCLICKHELP3"] = " |cFFFFFFFFAlt-Klick|r um auf $class zu wechseln"
L["TICKCLICKHELP4"] = "|cFFFFFFFFUmschalt-Klick|r um auf $party zu wechseln"
L["Tracker"] = "Überwacher"
L["Tracker Icon for single target exclusive buffs"] = "Überwachungssymbol für exklusive Einzel Stärkungszauber"
L["Warning: %s has auto-assigned themselves to buff groups %s, but you have the Auto Group Assignment option disabled"] = "Warnung: %s hat sich selbst automatisch den Gruppen %s zugewiesen, obwohl deine Auto Gruppen Einteilung Option deaktiviert ist"
L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"] = "WARNUNG: Das vorgesehene Ziel für dieses Symbol hat sich geändert, seitdem du im Kampf warst. (War zuvor %s)"
L["You are now responsible for Groups %s"] = "Du bist nun verantwortlich für die Gruppen %s"

end
if (GetLocale() == "esES") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "esES", true)
	if not L then return end
	
end
if (GetLocale() == "esMX") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "esMX", true)
	if not L then return end
	
end
if (GetLocale() == "frFR") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "frFR", true)
	if not L then return end
	L["Adjust the scale of the tracking icon"] = "Ajuster l'échelle de l'icône de suivi"
L["Anchor"] = "Ancrage"
L[" and "] = " et "
L["Auto-Assign"] = "Assignation automatique"
L["Auto assign sensible group assignment based the order of your name alphabilically compared to others of your class. All going well, and all using ZOMGBuffs and everyone should end up with different assignments without need for discussion"] = "Assignation automatique intelligente, basée sur le classement alphabétique des membres de votre classe. Si tout va bien et que tout le monde utilise ZOMGBuffs, chacun devrait recevoir un assignement différent et unique sans besoin de concertation"
L["Behaviour"] = "Comportement"
L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"] = "Créé un icône de suivi pour certains sorts exclusifs (bouclier de terre, gardien de peur). A noter que l'icône pourra toujours afficher le statut correct du sort, mais si vous changez la cible en combat, l'action du clic se fera sur la personne définie avant d'entrer combat."
L["Default rebuff prelude for all group buffs"] = "Rebuff préventif par défaut pour les buffs de groupe"
L["Define the key used for rebuffing %s from it's Spell Tracker icon"] = "Définit la touche utilisée pour rebuffer %s à partir de l'icône de suivi de sort"
L["Disabled"] = "Inactif"
L["Disables auto-casting for %s in favor of rebuffing via tracker icons or their hotkeys"] = "Désactive l'auto-casting de %s en faveur d'un rebuff via l'icône de suivi ou sa touche de raccourci"
L["%d of %d stacks remain"] = "%d stacks restant sur %d"
L["Enable"] = "Activé"
L["Enable buffing of this group"] = "Activer les prise en charge de ce groupe"
L["Enabled"] = "Activé"
L["Expiry Prelude"] = "Prévention de l'expiration"
L["Group Buff Configuration"] = "Configuration des buffs de groupe"
L["Group buffing behaviour"] = "Comportement pour les buffs de groupe"
L["Group %d"] = "Groupe %d"
L["Group %d needs %s"] = "Le groupe %d a besoin de %s"
L["Groups"] = "Groupes"
L["Group spell configuration"] = "Configuration des sorts de groupe"
L["Group Spells"] = "Sorts de groupe"
L["Group Template: "] = "Modèle de groupe :"
L["How many players of a group must need a buff before the group version is cast"] = "Nombre de joueur minimum d'un groupe nécessitant un buff avant de lancer un buff de groupe"
L["If noone is selected for this buff when you disable it, then the next time it is enabled, everyone will default to ON. If disabled, the last settings will be remembered"] = "Si personne n'est sélectionné pour ce buff quand vous le désactivez, alors la prochaine fois qu'il sera activé, tout le monde sera sur ON par défaut. Si désactivé, les réglages précédents seront conservés"
L["Invert"] = "Inversion"
L["Invert the need/got alpha values"] = "Intervertit les valeurs de transparence de besoin/a"
L["Key-Binding"] = "Touche raccourci"
L["Learnable"] = "Peut être appri"
L["Mark"] = "Marque"
L["Minimum Group"] = "Groupe minimum"
L["MISSING!"] = "MANQUANT !"
L["(modified)"] = "(modifié)"
L["No Auto-cast"] = "Pas d'auto-incantation"
L["none"] = "aucun"
L["Rebuff prelude for %s (0=Module default)"] = "Rebuff préventif pour %s (0=valeur par défaut)"
L["Remember this spell when it's cast manually?"] = "Se rappeler de ce sort quand il est lancé manuellement ?"
L["Reset"] = "Réinitialiser"
L["Reset on Clear"] = "Réinitialiser sur effacement"
L["Reset the position of the tracker icon"] = "Réinitialiser la position de l'icône de suivi"
L["Scale"] = "Echelle"
L["%s cooldown ready for %s"] = "%s cooldown prêt pour %s"
L["Select a soundfile to play when player's tracked buff expires"] = "Sélectionner un fichier audio à jouer quand le buff suivi du joueur expire"
L["Select the groups to buff"] = "Sélectionner les groupes a buffer"
L["%s has expired on %s"] = "%s a expiré sur %s"
L["Single spell configuration"] = "Configuration des sorts uniques"
L["Single Spells"] = "Sorts uniques"
L["%s needs %s"] = "%s a besoin de %s"
L["%s on %s"] = "%s sur %s"
L["%s on %s%s"] = "%s sur %s%s"
L["Sound"] = "Son"
L["Spell Tracker"] = "Suivi de sort"
L["%s remains"] = "%s restent"
L["Template configuration"] = "Configuration du modèle"
L["Templates"] = "Modèles"
L["This button is not clickable because it was created after you entered combat"] = "Ce bouton n'est pas clicable car il a été créé après l'entrée en combat"
L["TICKCLICKHELP1"] = "|cFFFFFFFFClic|r pour changer de joueur"
L["TICKCLICKHELP2"] = "|cFFFFFFFFClic droit|r pour changer tout le monde"
L["TICKCLICKHELP3"] = "|cFFFFFFFFAlt-Clic|r pour changer de $class"
L["TICKCLICKHELP4"] = "|cFFFFFFFFShift-Clic|r pour changer de $party"
L["Tracker"] = "Suivi"
L["Tracker Icon for single target exclusive buffs"] = "Icône de suivi pour buff de cible unique"
L["Warning: %s has auto-assigned themselves to buff groups %s, but you have the Auto Group Assignment option disabled"] = "Attention : %s a été auto-assigné pour buffer les groupes %s, cependant vous n'avez pas activé l'option d'auto-assignation"
L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"] = "ATTENTION : La cible prévue pour cette icône a changé depuis que vous êtes entré en combat (C'était %s)"
L["You are now responsible for Groups %s"] = "Vous êtes maintenant responsable des buffs du groupe %s"

end
if (GetLocale() == "koKR") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "koKR", true)
	if not L then return end
	
end
if (GetLocale() == "ruRU") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "ruRU", true)
	if not L then return end
	
end
if (GetLocale() == "zhCN") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "zhCN", true)
	if not L then return end
	L["Adjust the scale of the tracking icon"] = "更改跟踪图标的缩放等级"
L["Anchor"] = "锚点"
L[" and "] = "以及"
L["Auto-Assign"] = "自动分配"
L["Auto assign sensible group assignment based the order of your name alphabilically compared to others of your class. All going well, and all using ZOMGBuffs and everyone should end up with different assignments without need for discussion"] = "无需讨论，依据你的职业所有玩家的名字的字母顺序合理化自动分配，所有使用ZOMGBuffs插件的玩家最终将被分配指定Buff不同的队伍。"
L["Behaviour"] = "行为"
L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"] = "为部分例外法术（大地之盾，防护恐惧结界）创建一个跟踪图标。这个图标可以永远显示法术正确的状态，但是如果你在战斗中更改了目标，那么点击图标依然还在作用于进入战斗之前设置的目标。"
L["Default rebuff prelude for all group buffs"] = "所有群体Buff重新Buff的默认提前时间"
L["Define the key used for rebuffing %s from it's Spell Tracker icon"] = "定义从法术追踪图标补buff  %s 的键位"
L["Disabled"] = "禁用"
L["Disables auto-casting for %s in favor of rebuffing via tracker icons or their hotkeys"] = "禁用 %s 的自动施放来通过追踪器图标或他们的热键来补buff"
L["%d of %d stacks remain"] = "剩余%d/%d组"
L["Enable"] = "启用"
L["Enable buffing of this group"] = "对该队开启Buff"
L["Enabled"] = "启用"
L["Expiry Prelude"] = "失效预知"
L["Group Buff Configuration"] = "队伍Buff配置"
L["Group buffing behaviour"] = "群体Buff行为"
L["Group %d"] = "%d队"
L["Group %d needs %s"] = "队伍%d需要%s"
L["Groups"] = "队伍"
L["Group spell configuration"] = "群体法术配置"
L["Group Spells"] = "群体法术"
L["Group Template: "] = "队伍模板："
L["How many players of a group must need a buff before the group version is cast"] = "队伍要有多少人需要Buff时才使用群体Buff"
L["If noone is selected for this buff when you disable it, then the next time it is enabled, everyone will default to ON. If disabled, the last settings will be remembered"] = "当你禁用这个Buff的时候如果没有指定给任何人，那么下次再开启的时候默认对所有人开启。如果该选项关闭，那么将记住上一次的设置。"
L["Invert"] = "反转"
L["Invert the need/got alpha values"] = "反转“需要Buff/已经Buff”透明度值"
L["Key-Binding"] = "按键绑定"
L["Learnable"] = "可学习"
L["Mark"] = "爪子"
L["Minimum Group"] = "最小队伍"
L["MISSING!"] = "缺失！"
L["(modified)"] = "(已修改)"
L["No Auto-cast"] = "不自动施放"
L["none"] = "无"
L["Rebuff prelude for %s (0=Module default)"] = "%s的提前重新Buff时间（0=模块默认）"
L["Remember this spell when it's cast manually?"] = "当手动施放时是否自动启用"
L["Reset"] = "重置"
L["Reset on Clear"] = "清除时重置"
L["Reset the position of the tracker icon"] = "重置跟踪图标的位置"
L["Scale"] = "缩放"
L["%s cooldown ready for %s"] = "%s 冷却就绪在 %s"
L["Select a soundfile to play when player's tracked buff expires"] = "选择一个当玩家跟踪的Buff失效后播放的声音"
L["Select the groups to buff"] = "选择要Buff的队伍"
L["%s has expired on %s"] = "%s的%s失效了"
L["Single spell configuration"] = "单体法术配置"
L["Single Spells"] = "单体法术"
L["%s needs %s"] = "%s需要%s"
L["%s on %s"] = "%s -> %s"
L["%s on %s%s"] = "%s -> %s%s"
L["Sound"] = "声音"
L["Spell Tracker"] = "法术跟踪"
L["%s remains"] = "%s 剩余"
L["Template configuration"] = "模板配置"
L["Templates"] = "模板"
L["This button is not clickable because it was created after you entered combat"] = "这个按钮无法点击，因为它是在你进入战斗之后创建的"
L["TICKCLICKHELP1"] = "|cFFFFFFFF鼠标左键|r切换玩家"
L["TICKCLICKHELP2"] = "|cFFFFFFFF鼠标右键|r切换所有人"
L["TICKCLICKHELP3"] = "|cFFFFFFFFAlt点击|r切换$class"
L["TICKCLICKHELP4"] = "|cFFFFFFFFShift点击|r切换$party"
L["Tracker"] = "跟踪"
L["Tracker Icon for single target exclusive buffs"] = "单体目标例外Buff跟踪图标"
L["Warning: %s has auto-assigned themselves to buff groups %s, but you have the Auto Group Assignment option disabled"] = "警告：%s 已经自动分配他们自己Buff %s队，而你没有开启自动队伍分配选项"
L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"] = "警告：自从进入战斗以来，这个图标预期的作用目标已经被更改（之前是 %s）"
L["You are now responsible for Groups %s"] = "你现在负责Buff %s队"

end
if (GetLocale() == "zhTW") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGBuffTehRaid", "zhTW", true)
	if not L then return end
	L["Adjust the scale of the tracking icon"] = "更改跟蹤圖示的縮放等級"
L["Anchor"] = "錨點"
L[" and "] = "以及"
L["Auto-Assign"] = "自動分配"
L["Auto assign sensible group assignment based the order of your name alphabilically compared to others of your class. All going well, and all using ZOMGBuffs and everyone should end up with different assignments without need for discussion"] = "無需討論，依據你的職業所有玩家的名字的字母順序合理化自動分配，所有使用ZOMGBuffs插件的玩家最終將被分配指定Buff不同的隊伍。"
L["Behaviour"] = "行為"
L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"] = "為部分例外法術（大地之盾，防護恐懼結界）創建一個跟蹤圖示。這個圖示可以永遠顯示法術正確的狀態，但是如果你在戰鬥中更改了目標，那麼點擊圖示依然還在作用於進入戰鬥之前設置的目標。"
L["Default rebuff prelude for all group buffs"] = "所有群體Buff重新Buff的默認提前時間"
L["Define the key used for rebuffing %s from it's Spell Tracker icon"] = "自定的按鍵用於重新buff %s 的法術追踪圖示"
L["Disabled"] = "禁用"
L["Disables auto-casting for %s in favor of rebuffing via tracker icons or their hotkeys"] = "禁用 %s 的自動施法有利於rebuff時跟據他們的追踪圖標或熱鍵"
L["%d of %d stacks remain"] = "剩餘%d/%d組"
L["Enable"] = "啟用"
L["Enable buffing of this group"] = "對該隊開啟Buff"
L["Enabled"] = "啟用"
L["Expiry Prelude"] = "失效預知"
L["Group Buff Configuration"] = "隊伍Buff配置"
L["Group buffing behaviour"] = "群體Buff行為"
L["Group %d"] = "%d隊"
L["Group %d needs %s"] = "隊伍%d需要%s"
L["Groups"] = "隊伍"
L["Group spell configuration"] = "群體法術配置"
L["Group Spells"] = "群體法術"
L["Group Template: "] = "隊伍範本："
L["How many players of a group must need a buff before the group version is cast"] = "隊伍要有多少人需要Buff時才使用群體Buff"
L["If noone is selected for this buff when you disable it, then the next time it is enabled, everyone will default to ON. If disabled, the last settings will be remembered"] = "當你禁用這個Buff的時候如果沒有指定給任何人，那麼下次再開啟的時候默認對所有人開啟。如果該選項關閉，那麼將記住上一次的設置。"
L["Invert"] = "反轉"
L["Invert the need/got alpha values"] = "反轉“需要Buff/已經Buff”透明度值"
L["Key-Binding"] = "按鍵綁定"
L["Learnable"] = "可學習"
L["Mark"] = "爪子"
L["Minimum Group"] = "最小隊伍"
L["MISSING!"] = "缺失！"
L["(modified)"] = "(已修改)"
L["No Auto-cast"] = "沒有自動施法"
L["none"] = "無"
L["Rebuff prelude for %s (0=Module default)"] = "%s的提前重新Buff時間（0=模組默認）"
L["Remember this spell when it's cast manually?"] = "當手動施放時是否自動啟用"
L["Reset"] = "重置"
L["Reset on Clear"] = "清除時重置"
L["Reset the position of the tracker icon"] = "重置跟蹤圖示的位置"
L["Scale"] = "縮放"
L["%s cooldown ready for %s"] = "%s 冷卻在 %s完成"
L["Select a soundfile to play when player's tracked buff expires"] = "選擇一個當玩家跟蹤的Buff失效後播放的聲音"
L["Select the groups to buff"] = "選擇要Buff的隊伍"
L["%s has expired on %s"] = "%s的%s失效了"
L["Single spell configuration"] = "單體法術配置"
L["Single Spells"] = "單體法術"
L["%s needs %s"] = "%s需要%s"
L["%s on %s"] = "%s -> %s"
L["%s on %s%s"] = "%s -> %s%s"
L["Sound"] = "聲音"
L["Spell Tracker"] = "法術跟蹤"
L["%s remains"] = "%s 剩餘"
L["Template configuration"] = "範本配置"
L["Templates"] = "範本"
L["This button is not clickable because it was created after you entered combat"] = "這個按鈕無法點擊，因為它是在你進入戰鬥之後創建的"
L["TICKCLICKHELP1"] = "|cFFFFFFFF滑鼠左鍵|r切換玩家"
L["TICKCLICKHELP2"] = "|cFFFFFFFF滑鼠右鍵|r切換所有人"
L["TICKCLICKHELP3"] = "|cFFFFFFFFAlt點擊|r切換$class"
L["TICKCLICKHELP4"] = "|cFFFFFFFFShift點擊|r切換$party"
L["Tracker"] = "跟蹤"
L["Tracker Icon for single target exclusive buffs"] = "單體目標例外Buff跟蹤圖示"
L["Warning: %s has auto-assigned themselves to buff groups %s, but you have the Auto Group Assignment option disabled"] = "警告：%s 已經自動分配他們自己Buff %s隊，而你沒有開啟自動隊伍分配選項"
L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"] = "警告：自從進入戰鬥以來，這個圖示預期的作用目標已經被更改（之前是 %s）"
L["You are now responsible for Groups %s"] = "你現在負責Buff %s隊"

end
