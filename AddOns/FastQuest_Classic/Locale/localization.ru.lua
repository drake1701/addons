-- $Id: localization.ru.lua 149 2011-12-05 03:44:04Z arithmandar $
-- [[
-- Language: Russian
-- Translated by:  StingerSoft
-- Last Updated: $Date: 2011-12-05 11:44:04 +0800 (Mon, 05 Dec 2011) $
-- ]]
--------------------------
-- Translatable strings --
--------------------------
if (GetLocale() == "ruRU") then
FQ_Formats = {
	"Название задания",
	"[Уровень] Название",
	"[Уровень+] Название",
	"[Уровень+] Название (Тип)",
};
--
EPA_TestPatterns = {
	"^(.+): %s*[-%d]+%s*/%s*[-%d]+%s*$",
 	"^(.+)[^Торговля] выполнено.$",						-- ERR_QUEST_COMPLETE_S
 	"^(.+)\(Цель достигнута\)$",						-- ERR_QUEST_OBJECTIVE_COMPLETE_S
-- 	"^Получено задание: .+$",						-- ERR_QUEST_ACCEPTED_S
 	"^Получено опыта: .+$",							-- ERR_QUEST_REWARD_EXP_I
 	"^Открыта новая территория: .+$",					-- ERR_ZONE_EXPLORED
};
--
FQ_QUEST_TEXT =		"(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$";
--
FQ_LOADED = 		"|cff00ffffFastQuest Classic "..FASTQUEST_CLASSIC_VERSION.." загружен. Для информации введите /fq. Для открытия окна настроек /fq options."
FQ_INFO =			"|cff00ffffFastQuest Classic: |r|cffffffff";
-- Strings in Option Frame
FQ_OPT_OPTIONS_TITLE			= "Настройки FastQuest Classic";
FQ_OPT_FRM_NOTIFY_TITLE			= "Настройки извещения";
FQ_OPT_AUTONOTIFY_TITLE			= "Авто-извещение";
FQ_OPT_AUTONOTIFY_TIP			= "Автоматически извещает о информации связанной с заданием, ближайших, группе, рейду, и/или гильдии.";
FQ_OPT_QUESTCOMPLETESOUND_TITLE		= "Quest Complete Sound"; -- Needs translation
FQ_OPT_QUESTCOMPLETESOUND_TIP		= "Enable / Disable the notification sound when a quest is being completed."; -- Needs translation
FQ_OPT_NOTIFYCHANNEL_TITLE		= "Извещать в канал";
FQ_OPT_NOTIFYNEARBY_TITLE		= "Извещать ближайших";
FQ_OPT_NOTIFYNEARBY_TIP			= "Извещать ближайших, о информации связанной с заданием.";
FQ_OPT_NOTIFYPARTY_TITLE		= "Извещать группу";
FQ_OPT_NOTIFYPARTY_TIP			= "Извещать участников группы, о информации связанной с заданием.";
FQ_OPT_NOTIFYRAID_TITLE			= "Извещать рейд";
FQ_OPT_NOTIFYRAID_TIP			= "Извещать участников рейда, о информации связанной с заданием.";
FQ_OPT_NOTIFYGUILD_TITLE		= "Извещать гильдию";
FQ_OPT_NOTIFYGUILD_TIP			= "Извещать участников гильдии о информации связанной с заданием.";
FQ_OPT_NOTIFYDETAIL_TITLE		= "Извещать о деталях";
FQ_OPT_NOTIFYDETAIL_TIP			= "Извещать о деталях выполнения задания.";
FQ_OPT_NOTIFYEXP_TITLE			= "Извещать о получении опыта";
FQ_OPT_NOTIFYEXP_TIP			= "Извещать о получении опыта за выполнение задания.";
FQ_OPT_NOTIFYZONE_TITLE			= "Извещать о открытии территории";
FQ_OPT_NOTIFYZONE_TIP			= "Извещать о открытии новой территории.";
FQ_OPT_NOTIFYLEVELUP_TITLE		= "Извещать повышение уровня";
FQ_OPT_NOTIFYLEVELUP_TIP		= "Извещать о повышение уровня.";
FQ_OPT_FRM_QUESTFORMAT_TITLE		= "Настройки отображения заданий";
FQ_OPT_QUESTFORMAT_TITLE		= "Выбор формата вида задания";
FQ_OPT_QUESTFORMAT_TIP			= "Выбор формата вида задания для отображения в чате.";
FQ_OPT_QUESTLOGOPTIONS_TITLE		= "Настройки журнала заданий";
FQ_OPT_COLOR_TITLE			= "Включить цвета";
FQ_OPT_COLOR_TIP			= "Включить окраску названия заданий в окне отслеживания заданий в зависимости от уровня их сложности.";
FQ_OPT_MEMBERINFO_TITLE			= "Показывать рекомендации";
FQ_OPT_MEMBERINFO_TIP			= "Показывать рекомендации числа игроков к заданию в журнале заданий.";
FQ_OPT_MINIMAP_POSITION_TITLE		= "Позиция у мини-карты";
FQ_OPT_SHOWTYPE_TITLE			= "Показ тип задания";
FQ_OPT_SHOWTYPE_TIP			= "Показывать тип задания в окне слежения заданий.";
FQ_OPT_NODRAG_TITLE			= "No Drag";
FQ_OPT_NODRAG_TIP			= "Set the quest tracker window to be not dragable.";
FQ_OPT_LOCK_TITLE			= "Блокировать окно слежения";
FQ_OPT_LOCK_TIP				= "Блокировать позицию окна слежения.";
FQ_OPT_AUTOADD_TITLE			= "Авто добавить/удалить задания";
FQ_OPT_AUTOADD_TIP			= "Автоматически добавить/удалить задания в окне слежения за ними.";
FQ_OPT_AUTOCOMPLETE_TITLE		= "Авто сдача";
FQ_OPT_AUTOCOMPLETE_TIP			= "Автоматически сдавать выполненные задания.";
FQ_OPT_FRM_MISC_TITLE			= "Разное";
FQ_OPT_SHOWMINIMAP_TITLE		= "Показать иконку у мни-карты";
FQ_OPT_SHOWMINIMAP_TIP			= "Вкл/выкл отображение иконки у мини-карты.";
FQ_OPT_SOUNDSELECTION			= "Notification Sound: "; -- Needs translation
FQ_BTN_OK				= "OK";
FQ_BTN_ABOUT				= "About"; -- Needs translation
FQ_BTN_PREVIEW				= "Preview"; -- Needs translation

FQ_BUTTON_TOOLTIP			= "[Левый-клик] - открывает журнал заданий.\n[Средний-клик] - настройки FastQuest Classic.\n[Удержывая правый-клик + движение] - перемещает данную кнопку.";
FQ_TITAN_BUTTON_TOOLTIP			= "[Левый-клик] - открывает журнал заданий.\n[правый-клик] - настройки FastQuest Classic.";

-- Information Message
FQ_INFO_NOTIFYGUILD = 	"Извещать гильдию относительно моего продвижения по заданию: ";
FQ_INFO_NOTIFYRAID = 	"Извещать рейд относительно моего продвижения по заданию: ";
FQ_INFO_NOTIFYNEARBY = 	"Извещать ближайших относительно моего продвижения по заданию: ";
FQ_INFO_NOTIFYPARTY = 	"Извещать группу относительно моего продвижения по заданию: ";
FQ_INFO_AUTOADD = 	"Автоматически добавить/удалить изменённые задания в окне слежения: ";
FQ_INFO_AUTOCOMPLETE = 	"Автоматически сдавать выполненные задания: ";
FQ_INFO_AUTONOTIFY = 	"Автоматическое извещение моего продвижения по заданию: ";
FQ_INFO_CLEAR =		"Все задания в окне слежения убраны. ";
FQ_INFO_COLOR =		"Окраска заглавий заданий: ";
FQ_INFO_DETAIL =	"Извещать о деталях продвижения по заданию: ";
FQ_INFO_DISPLAY_AS =	"Выбранный формат: ";
FQ_INFO_FORMAT =	"переключение между форматом вывода ";
FQ_INFO_LOCK =		"Передвигаемые компоненты |cffff0000Заблокированы|r|cffffffff";
FQ_INFO_QUESTCOMPLETESOUND		= "Quest completion notification sound: ";
FQ_INFO_MEMBERINFO = 	"Рекомендации числа игроков к заданию: ";
FQ_INFO_NODRAG =		"No-Dragging is now set to ";
FQ_INFO_NOTIFYDISCOVER = "Извещать о открытии новой территории. ";
FQ_INFO_NOTIFYEXP = 	"Извещать о получении опыта за выполнение задания. ";
FQ_INFO_NOTIFYLEVELUP = "Извещение о повышении уровня: ";
FQ_INFO_QUEST_TAG =		"Отображение тегов задания (PvP, Рейд, и т.д.) в окне слежения: ";
FQ_INFO_RESET = 		"Позиция окна слежения сброшена";
FQ_INFO_SHOWMINIMAP =	"Показать иконку у мини-карты: ";
FQ_INFO_UNLOCK =		"Передвигаемые компоненты |cff00ff00Разблакированы|r|cffffffff";
FQ_INFO_USAGE = 		"|cffffff00используйте: /fastquest [command] или /fq [command]|r|cffffffff";
--
FQ_MUST_RELOAD =		"Для применения данных настроек, вам нужно перезагрузить интерфейс. Введите /console reloadui";
--
FQ_USAGE_NOTIFYGUILD =	"Вкл/выкл автоматическое извещение участников гильдии.";
FQ_USAGE_NOTIFYRAID =	"Вкл/выкл автоматическое извещение участников рейда.";
FQ_USAGE_NOTIFYNEARBY =	"Вкл/выкл автоматическое извещение ближайших на зоне.";
FQ_USAGE_NOTIFYPARTY =	"Вкл/выкл автоматическое извещение участников группы.";
FQ_USAGE_AUTOADD =		"Вкл/выкл автоматического добавление изменений заданий в окне слежения.";
FQ_USAGE_AUTOCOMPLETE =	"Вкл/выкл автоматического сдавания выполненных заданий. (Вы не будете видеть информацию о завершении задания у НИПа.)";
FQ_USAGE_AUTONOTIFY =	"Вкл/выкл автоматическое извещение участников группы..";
FQ_USAGE_CLEAR =		"Очистка окна слежения от всех заданий.";
FQ_USAGE_COLOR =		"Переключение окраски заглавий заданий в окне слежения.";
FQ_USAGE_DETAIL =		"Переключение извещений задания в коротком формате или детальном.";
FQ_USAGE_FORMAT =		"Переключение формата вывода извещений.";
FQ_USAGE_LOCK =			"Блокировать/Разблокировать окно слежение.";
FQ_USAGE_MEMBERINFO = 	"Вкл/выкл рекомендаций числа игроков к заданию.";
FQ_USAGE_NODRAG =		"Toggle dragging of quest tracker, you must reload UI to apply.";
FQ_USAGE_NOTIFYDISCOVER = "Вкл/выкл автоматическое извещение открытия новой территории.";
FQ_USAGE_NOTIFYEXP =	"Вкл/выкл автоматическое извещение получения опыта за выполнение задания.";
FQ_USAGE_NOTIFYLEVELUP = "Вкл/выкл автоматическое извещение повышения уровня.";
FQ_USAGE_RESET =		"Сброс позиции окна слежения";
FQ_USAGE_STATUS =		"Показать статус по всем настройкам FastQuest Classic.";
FQ_USAGE_OPTIONS =		"Переключение окна настроек.";
FQ_USAGE_TAG =			"Вкл/выкл отображение тегов задания (PvP, Рейд, и т.д.) ";
--
--BINDING_CATEGORY_FASTQUEST_CLASSIC		= "Quest Enhancement";
BINDING_HEADER_FASTQUEST_CLASSIC	= "FastQuest Classic";
BINDING_NAME_FASTQUEST_OPTIONS		= "Toggle FQ Options";
BINDING_NAME_FQ_TAG					= "Toggle Quest Tag";
BINDING_NAME_FQ_FORMAT				= "Quest Display Format";
BINDING_NAME_FQ_AOUTNOTIFY			= "Авто оповещение о прогрессе выполнения задания";
BINDING_NAME_FQ_AOUTCOMPLETE		= "Auto Commit Quest";
BINDING_NAME_FQ_AOUTADD				= "Авто добавка окна слежения";
BINDING_NAME_FQ_LOCK				= "Блок/Разблок окна слежения";
--
FQ_QUEST_PROGRESS =		"Продвижение задания: ";
FQ_QUEST_ACCEPTED = 		"Получено задание: ";
--
FQ_QUEST_ISDONE =		" выполнено!";	-- The sentence will be "[xxxx] is now completed!", where xxxx refer to quest name
FQ_QUEST_COMPLETED =	" (Задание выполнено)";
FQ_DRAG_DISABLED =		"FastQuest Classic: перемещение отключено, используйте /fq nodrag чтобы переключить, и вам также нужно перезагрузить интерфейс для применение изменений";
--
FQ_ENABLED =			"|cff00ff00Включено|r|cffffffff";
FQ_DISABLED =			"|cffff0000Отключено|r|cffffffff";
FQ_LOCK =				"|cffff0000Блакированно|r|cffffffff";
FQ_UNLOCK =				"|cff00ff00Разблокированно|r|cffffffff";
--
 end