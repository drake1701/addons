-- Do not translate here!!
-- Please go to http://www.wowace.com/addons/zomgbuffs/localization/

do
local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "enUS", true)
if not L then return end
L["Self Buff Configuration"]								= true
L["Self"]													= true
L["Templates"]												= true
L["Template configuration"]									= true
L["Class Spells"]											= true
L["Class spell configuration"]								= true
L["Items"]													= true
L["Item configuration"]										= true
L["Main Hand"]												= true
L["Use this item or spell on the main hand weapon"]			= true
L["Off Hand"]												= true
L["Use this item or spell on the off hand weapon"]			= true
L["Ranged"]													= true
L["Use this item or spell on the ranged weapon"]			= true
L["You need |cFFFFFF80%s|r"]								= true
L["You need %s"]											= true
L["You need |c0080FF80%s|r on |c00FFFF80%s|r"]				= true
L["You need %s on |c00FFFF80%s|r"]							= true
L["You need %s on %s"]										= true
L["Tracking"]												= true
L["Tracking configuration"]									= true
L["Behaviour"]												= true
L["Self buffing behaviour"]									= true
L["Auto buffs"]												= true
L["Use auto-intelligent buffs such as Crusader Aura when mounted"] = true
L["Self Buffs Template: "]									= true
L["(modified)"]												= true
L["none"]													= true
L["Main Hand"]												= true
L["Off Hand"]												= true
L["Seals"]													= true				-- Generic Paladin 'Seal of ' description
L["Expiry Prelude"]											= true
L["Rebuff prelude for %s (0=Module default)"]				= true
L["Minimum Charges"]										= true
L["Rebuff if number of charges left is less than defined amount"] = true
L["Default"]												= true
L["Default rebuff prelude for all self buffs"]				= true
L["Warning: |cFF%s%s|r already applied by another %s"]		= true
L["Combat Warnings"]										= true
L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"] = true
L["%s, %s%d|r %s remain"]									= true
L["Learnable"]												= true
L["Remember this spell when it's cast manually?"]			= true
L["Reagent Reminder"]										= true
L["Show message when spells requiring reagents are used"]	= true
L["Alchemy Flasks"]										= true
L["Special handling for Alchemy Flasks"]				= true
L["Expiry prelude for flasks"]								= true
L["Enabled"]												= true
L["Auto-cast Alchemy Flask"]							= true
end

if (GetLocale() == "deDE") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "deDE", true)
	if not L then return end
	L["Alchemy Flasks"] = "Fläschchen des Nordens" -- Needs review
L["Auto buffs"] = "Automatische Stärkungszauber"
L["Behaviour"] = "Verhalten"
L["Class spell configuration"] = "Klassenzauber Konfiguration"
L["Class Spells"] = "Klassenzauber"
L["Combat Warnings"] = "Kampfwarnungen"
L["Default"] = "Standardeinstellungen"
L["Default rebuff prelude for all self buffs"] = "Standard Auslaufvorlaufzeit für alle eigenen Stärkungszauber"
L["Expiry Prelude"] = "Auslaufvorlauf"
L["Expiry prelude for flasks"] = "Auslaufvorlauf für Fläschchen"
L["Item configuration"] = "Gegenstandskonfiguration"
L["Items"] = "Gegenstände"
L["Learnable"] = "Lernfähig"
L["Main Hand"] = "Waffenhand"
L["Minimum Charges"] = "Minimale Aufladungen"
L["(modified)"] = "(verändert)"
L["none"] = "kein"
L["Off Hand"] = "Schildhand"
L["Reagent Reminder"] = "Reagenzien Erinnerung"
L["Rebuff if number of charges left is less than defined amount"] = "Stärkungszauber erneut wirken, wenn Anzahl der Aufladungen geringer als dieser festgelegte Wert ist"
L["Rebuff prelude for %s (0=Module default)"] = "Erneuerungsvorlauf für %s (0= Standardeinstellung)"
L["Remember this spell when it's cast manually?"] = "Diesen Zauber merken, sobald er manuell gewirkt wurde?"
L["Seals"] = "Siegel"
L["Self"] = "Selbst"
L["Self Buff Configuration"] = "Konfiguration für eigene Stärkungszauber"
L["Self buffing behaviour"] = "Verhalten eigener Stärkungszauber"
L["Self Buffs Template: "] = "Vorlagen für eigene Stärkungszauber:"
L["Show message when spells requiring reagents are used"] = "Erzeuge eine Meldung, wenn Zauber gewirkt werden, die Reagenzien verbrauchen"
L["Special handling for Alchemy Flasks"] = "Spezielle Behandlung für Fläschchen des Nordens" -- Needs review
L["%s, %s%d|r %s remain"] = "%s, %s%d|r %s verbleibend"
L["Template configuration"] = "Vorlagenkonfiguration"
L["Templates"] = "Vorlagen"
L["Tracking"] = "Überwachung"
L["Tracking configuration"] = "Überwachungskonfiguration"
L["Use auto-intelligent buffs such as Crusader Aura when mounted"] = "Benutze automatisch-intelligente Stärkungszauber wie Aura des Kreuzfahrers wenn auf einem Reittier"
L["Use this item or spell on the main hand weapon"] = "Wende diesen Gegenstand oder Zauber auf die Waffenhand an"
L["Use this item or spell on the off hand weapon"] = "Wende diesen Gegenstand oder Zauber auf die Schildhand an"
L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"] = "Warnmeldungen über auslaufende Stärkungszauber im Kampf. Denke daran, dass das automatische Wirken von Stärkungszaubern im Kampf nicht funktioniert, dies ist nur eine Erinnerung"
L["Warning: |cFF%s%s|r already applied by another %s"] = "Warnung: |cFF%s%s|r wurde bereits von einem anderen %s gewirkt"
L["You need |c0080FF80%s|r on |c00FFFF80%s|r"] = "Du benötigst |c0080FF80%s|r auf |c00FFFF80%s|r"
L["You need |cFFFFFF80%s|r"] = "Du benötigst |cFFFFFF80%s|r"
L["You need %s"] = "Du benötigst %s"
L["You need %s on |c00FFFF80%s|r"] = "Du benötigst %s auf |c00FFFF80%s|r"
L["You need %s on %s"] = "Du benötigst %s auf %s"

end
if (GetLocale() == "esES") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "esES", true)
	if not L then return end
	
end
if (GetLocale() == "esMX") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "esMX", true)
	if not L then return end
	
end
if (GetLocale() == "frFR") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "frFR", true)
	if not L then return end
	L["Alchemy Flasks"] = "Flacon du Grand Nord" -- Needs review
L["Auto buffs"] = "Buffs automatique"
L["Behaviour"] = "Comportement"
L["Class spell configuration"] = "Configuration des sorts de classe"
L["Class Spells"] = "Sorts de classe"
L["Combat Warnings"] = "Alertes en combat"
L["Default"] = "Défaut"
L["Default rebuff prelude for all self buffs"] = "Rebuff préventif par défaut pour tous les buffs personnels"
L["Expiry Prelude"] = "Prévention de l'expiration"
L["Expiry prelude for flasks"] = "Prévention de l'expiration pour les flacons"
L["Item configuration"] = "Configuration des objets"
L["Items"] = "Objets"
L["Learnable"] = "Peut être appris"
L["Main Hand"] = "Main principale"
L["Minimum Charges"] = "Charges minimum"
L["(modified)"] = "(modifié)"
L["none"] = "aucun"
L["Off Hand"] = "Main secondaire"
L["Reagent Reminder"] = "Pense-bête composants"
L["Rebuff if number of charges left is less than defined amount"] = "Rebuff si le nombre de charges restantes est inférieur au montant défini"
L["Rebuff prelude for %s (0=Module default)"] = "Rebuff préventif pour %s (0=valeur par défaut)"
L["Remember this spell when it's cast manually?"] = "Se rappeler de ce sort lorsqu'il est lancé manuellement ?"
L["Seals"] = "Sceau"
L["Self"] = "personnel"
L["Self Buff Configuration"] = "Configuration des buffs personnel"
L["Self buffing behaviour"] = "Comportement des buffs personnels"
L["Self Buffs Template: "] = "Modèle de buff personnel :"
L["Show message when spells requiring reagents are used"] = "Afficher un message quand des sorts requérant des composants sont utilisés"
L["Special handling for Alchemy Flasks"] = "Traitement spécial pour Flacon du Grand Nord" -- Needs review
L["%s, %s%d|r %s remain"] = "%s, %s%d|r %s restant"
L["Template configuration"] = "Configuration du modèle"
L["Templates"] = "Modèles"
L["Tracking"] = "Pistage"
L["Tracking configuration"] = "Configuration du pistage"
L["Use auto-intelligent buffs such as Crusader Aura when mounted"] = "Utiliser les buffs automatiques intelligents, comme l'aura du croisé quand vous êtes sur une monture"
L["Use this item or spell on the main hand weapon"] = "Utiliser cet objet ou sort sur l'arme en main principale"
L["Use this item or spell on the off hand weapon"] = "Utiliser cet objet ou sort sur l'arme en main secondaire"
L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"] = "Avertissement des buffs expirants en combat. Notez que les buffs ne peuvent pas être lancés automatiquement en combat, il s'agit simplement d'une notification"
L["Warning: |cFF%s%s|r already applied by another %s"] = "Attention : |cFF%s%s|r déjà appliqué par un autre %s"
L["You need |c0080FF80%s|r on |c00FFFF80%s|r"] = "Vous avez besoin de |c0080FF80%s|r sur |c00FFFF80%s|r"
L["You need |cFFFFFF80%s|r"] = "Vous avez besoin de |cFFFFFF80%s|r"
L["You need %s"] = "Vous avez besoin de %s"
L["You need %s on |c00FFFF80%s|r"] = "Vous avez besoin de %s sur |c00FFFF80%s|r"
L["You need %s on %s"] = "Vous avez besoin de %s sur %s"

end
if (GetLocale() == "koKR") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "koKR", true)
	if not L then return end
	L["Template configuration"] = "템플릿 설정"
L["Templates"] = "템플릿"
L["Tracking"] = "트래킹"
L["Tracking configuration"] = "트래킹 설정"
L["Use this item or spell on the main hand weapon"] = "이 아이템이나 주문을 주무기 슬롯에 사용합니다."
L["Use this item or spell on the off hand weapon"] = "이 아이템이나 주문을 보조무기 슬롯에 사용합니다."

end
if (GetLocale() == "ruRU") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "ruRU", true)
	if not L then return end
	
end
if (GetLocale() == "zhCN") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "zhCN", true)
	if not L then return end
	L["Alchemy Flasks"] = "北极药剂" -- Needs review
L["Auto buffs"] = "自动Buff"
L["Behaviour"] = "行为"
L["Class spell configuration"] = "职业法术配置"
L["Class Spells"] = "职业法术"
L["Combat Warnings"] = "战斗警告"
L["Default"] = "默认"
L["Default rebuff prelude for all self buffs"] = "所有自我Buff重新Buff的默认提前时间"
L["Expiry Prelude"] = "失效预知"
L["Expiry prelude for flasks"] = "合计到期前提示"
L["Item configuration"] = "物品配置"
L["Items"] = "物品"
L["Learnable"] = "可学习"
L["Main Hand"] = "主手"
L["Minimum Charges"] = "最低数额"
L["(modified)"] = "(已修改)"
L["none"] = "无"
L["Off Hand"] = "副手"
L["Reagent Reminder"] = "材料提醒"
L["Rebuff if number of charges left is less than defined amount"] = "如果数额低于定义的数值重新补buff"
L["Rebuff prelude for %s (0=Module default)"] = "%s的提前重新Buff时间（0=模块默认）"
L["Remember this spell when it's cast manually?"] = "当手动施放时是否自动启用"
L["Seals"] = "圣印"
L["Self"] = "自我"
L["Self Buff Configuration"] = "自我Buff配置"
L["Self buffing behaviour"] = "自我Buff行为"
L["Self Buffs Template: "] = "自我Buff模板："
L["Show message when spells requiring reagents are used"] = "当法术所需材料消耗时显示信息"
L["Special handling for Alchemy Flasks"] = "北极药剂的特殊处理" -- Needs review
L["%s, %s%d|r %s remain"] = "%s, %s%d|r %s 剩余"
L["Template configuration"] = "模板配置"
L["Templates"] = "模板"
L["Tracking"] = "跟踪"
L["Tracking configuration"] = "配置跟踪"
L["Use auto-intelligent buffs such as Crusader Aura when mounted"] = "使用智能的自动Buff，例如上马时使用十字军光环"
L["Use this item or spell on the main hand weapon"] = "将这个物品或者法术使用在主手武器上"
L["Use this item or spell on the off hand weapon"] = "将这个物品或者法术使用在副手武器上"
L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"] = "在战斗中警告要消失的Buff。注意自动补Buff不能在战斗中使用，这只是简单的提醒"
L["Warning: |cFF%s%s|r already applied by another %s"] = "警告：|cFF%s%s|r已经有一个其它的 %s 在作用了"
L["You need |c0080FF80%s|r on |c00FFFF80%s|r"] = "你需要|c0080FF80%s|r给|c00FFFF80%s|r"
L["You need |cFFFFFF80%s|r"] = "你需要|cFFFFFF80%s|r"
L["You need %s"] = "你需要%s"
L["You need %s on |c00FFFF80%s|r"] = "你需要%s给|c00FFFF80%s|r"
L["You need %s on %s"] = "你需要%s给%s"

end
if (GetLocale() == "zhTW") then
	local L = LibStub("AceLocale-3.0"):NewLocale("ZOMGSelfBuffs", "zhTW", true)
	if not L then return end
	L["Alchemy Flasks"] = "北方精鍊藥劑" -- Needs review
L["Auto buffs"] = "自動Buff"
L["Auto-cast Alchemy Flask"] = "ZOMGSelfBuffs - 自我增益模組" -- Needs review
L["Behaviour"] = "行為"
L["Class spell configuration"] = "職業法術配置"
L["Class Spells"] = "職業法術"
L["Combat Warnings"] = "戰鬥警告"
L["Default"] = "默認"
L["Default rebuff prelude for all self buffs"] = "所有自我Buff重新Buff的默認提前時間"
L["Expiry Prelude"] = "失效預知"
L["Expiry prelude for flasks"] = "精煉藥劑到期前的提示"
L["Item configuration"] = "物品配置"
L["Items"] = "物品"
L["Learnable"] = "可學習"
L["Main Hand"] = "主手"
L["Minimum Charges"] = "最少的數額"
L["(modified)"] = "(已修改)"
L["none"] = "無"
L["Off Hand"] = "副手"
L["Reagent Reminder"] = "材料提醒"
L["Rebuff if number of charges left is less than defined amount"] = "如果低於規定的數額時就rebuff"
L["Rebuff prelude for %s (0=Module default)"] = "%s的提前重新Buff時間（0=模組默認）"
L["Remember this spell when it's cast manually?"] = "當手動施放時是否自動啟用"
L["Seals"] = "聖印"
L["Self"] = "自我"
L["Self Buff Configuration"] = "自我Buff配置"
L["Self buffing behaviour"] = "自我Buff行為"
L["Self Buffs Template: "] = "自我Buff範本："
L["Show message when spells requiring reagents are used"] = "當法術所需材料消耗時顯示資訊"
L["Special handling for Alchemy Flasks"] = "北方精鍊藥劑的特別處理" -- Needs review
L["%s, %s%d|r %s remain"] = "%s, %s%d|r %s 剩餘"
L["Template configuration"] = "範本配置"
L["Templates"] = "範本"
L["Tracking"] = "跟蹤"
L["Tracking configuration"] = "配置跟蹤"
L["Use auto-intelligent buffs such as Crusader Aura when mounted"] = "使用智慧的自動Buff，例如上馬時使用十字軍光環"
L["Use this item or spell on the main hand weapon"] = "將這個物品或者法術使用在主手武器上"
L["Use this item or spell on the off hand weapon"] = "將這個物品或者法術使用在副手武器上"
L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"] = "在戰鬥中警告要消失的Buff。注意自動補Buff不能在戰鬥中使用，這只是簡單的提醒"
L["Warning: |cFF%s%s|r already applied by another %s"] = "警告：|cFF%s%s|r已經有一個其他的 %s 在作用了"
L["You need |c0080FF80%s|r on |c00FFFF80%s|r"] = "你需要|c0080FF80%s|r給|c00FFFF80%s|r"
L["You need |cFFFFFF80%s|r"] = "你需要|cFFFFFF80%s|r"
L["You need %s"] = "你需要%s"
L["You need %s on |c00FFFF80%s|r"] = "你需要%s給|c00FFFF80%s|r"
L["You need %s on %s"] = "你需要%s給%s"

end
