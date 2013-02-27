-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_AuctionDB - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_auctiondb.aspx   --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_AuctionDB Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_AuctionDB/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_AuctionDB", "ruRU")
if not L then return end

L["A full auction house scan will scan every item on the auction house but is far slower than a GetAll scan. Expect this scan to take several minutes or longer."] = "Полный скан Аукциона просканирует каждый товар, но намного дольше, чем GetAll скан. Ждите, это займёт несколько минут или более."
L["A GetAll scan is the fastest in-game method for scanning every item on the auction house. However, it may disconnect you from the game and has a 15 minute cooldown."] = "GetAll скан - самый быстрый внутриигровой способ просканировать каждый лот на Аукционе. Однако, он может вызвать разрыв соединения, а также имеет 15-ти минутный таймаут."
L["Alchemy"] = "Алхимия"
L["Any items in the AuctionDB database that contain the search phrase in their names will be displayed."] = "Будут отображены все товары из базы данных AuctionDB содержащие поисковую фразу в названии."
L["A profession scan will scan items required/made by a certain profession."] = "Скан профессии просканирует товары нужные для /изготовленные с помощью определённой профессии."
L["Are you sure you want to clear your AuctionDB data?"] = "Вы точно хотите очистить базу AuctionDB?"
L["Ascending"] = "Возрастание"
L["AuctionDB - Market Value"] = "AuctionDB - Рыночная стоимость"
L["AuctionDB - Minimum Buyout"] = "AuctionDB - Минимальный выкуп"
L["Blacksmithing"] = "Кузнечное дело"
L["|cffff0000WARNING:|r As of 4.0.1 there is a bug with GetAll scans only scanning a maximum of 42554 auctions from the AH which is less than your auction house currently contains. As a result, thousands of items may have been missed. Please use regular scans until blizzard fixes this bug."] = "|cffff0000Внимание: с патча 4.0.1 из-за бага GetAll сканирует только 42554 лота, что меньше общего количества лотов сейчас на вашем аукционе. Тысячи лотов могут быть не учтены. До тех пор, пока Blizzard не исправит эту ошибку, пользуйтесь обычным способом сканирования. "
L["Cooking"] = "Кулинария"
L["Descending"] = "Убывание"
L["Disenchant source:"] = "Источник распыления:" -- Needs review
L["Disenchant Value:"] = "Стоимость Распыления:" -- Needs review
L["Display disenchant value in tooltip."] = "Показывать в подсказке стоимость распыления." -- Needs review
L["Done Scanning"] = "Сканирование завершено"
L["Enable display of AuctionDB data in tooltip."] = "Показ данных AuctionDB в подсказке."
L["Enchanting"] = "Наложение чар"
L["Engineering"] = "Инженерное дело"
L["General Options"] = "Общие настройки"
L["Hide poor quality items"] = "Скрыть товары низкого качества"
L["If checked, poor quality items won't be shown in the search results."] = "Не показывать товары низкого качества в результатах поиска."
L["If checked, the disenchant value of the item will be shown. This value is calculated using the average market value of materials the item will disenchant into."] = "Если отмечено, будет показана цена распыление. Эта величина рассчитывается по средней рыночной стоимости материалов." -- Needs review
L["Inscription"] = "Начертание"
L["Invalid value entered. You must enter a number between 5 and 500 inclusive."] = "Введено неверное значение. Значение должно быть числом от 5 до 500 включительно."
L["Item Link"] = "Ссылка на товар"
L["Item MinLevel"] = "Мин.уровень товара"
L["Items per page"] = "Товаров на страницу"
L["Items %s - %s (%s total)"] = "Товаров %s - %s (%s всего)"
L["Item SubType Filter"] = "Фильтр по подтипу товара"
L["Item Type Filter"] = "Фильтр по типу товара"
L["It is strongly recommended that you reload your ui (type '/reload') after running a GetAll scan. Otherwise, any other scans (Post/Cancel/Search/etc) will be much slower than normal."] = "Настоятельно рекомендуем перезагрузить ваш интерфейс (наберите в чате '/reload') после выполнения GetAll скана. Иначе, любые другие сканы (Выставить/Отменить/Поиск/т.д.) будут намного медленнее, чем обычно."
L["Jewelcrafting"] = "Ювелирное дело"
L["Last Scanned"] = "Последний скан"
L["Last Scanned:"] = "Последнее сканирование: " -- Needs review
L["Leatherworking"] = "Кожевничество"
L["Market Value"] = "Рыночная цена"
L["Market Value:"] = "Рыночная цена:" -- Needs review
L["Min Buyout"] = "Мин Выкуп" -- Needs review
L["Min Buyout:"] = "Мин Выкуп:" -- Needs review
L["Minimum Buyout"] = "Минимальный выкуп"
L["Never scan the auction house again!"] = "Никогда не сканируйте Аукцион вновь!"
L["Next Page"] = "Далее"
L["No items found"] = "Ничего не найдено"
L["Not Ready"] = "Не готово"
L["Num(Yours)"] = "Число(Ваших)"
L["Options"] = "Опции"
L["Previous Page"] = "Назад"
L["Professions:"] = "Профессии:"
L["Ready"] = "Готово"
L["Ready in %s min and %s sec"] = "Готовность через %s мин %s сек."
L["Refresh"] = "Обновить"
L["Refreshes the current search results."] = "Обновляет текущие результаты поиска."
L["Removed %s from AuctionDB."] = "Удалено %s из AuctionDB."
L["Reset Data"] = "Сбросить данные"
L["Resets AuctionDB's scan data"] = "Сбрасывает данные сканирования модуля AuctionDB"
-- L["Result Order:"] = ""
L["Run Full Scan"] = "Полный скан"
L["Run GetAll Scan"] = "GetAll скан"
L["Run Profession Scan"] = "Скан профессии"
L["Run Scan"] = "Сканирование"
L["%s ago"] = "%s назад"
L["Scan interrupted."] = "Сканирование прервано."
L["Scanning..."] = "Сканирование..."
L["Scan the auction house with AuctionDB to update its market value and min buyout data."] = "Просканируйте Аукцион с помощью AuctionDB для обновления данных о рыночной стоимости и минимальном выкупе."
L["Search"] = "Поиск"
L["Search Options"] = "Опции поиска"
-- L["Seen Last Scan:"] = ""
L["Select how you would like the search results to be sorted. After changing this option, you may need to refresh your search results by hitting the \"Refresh\" button."] = "Выберите каким образом сортировать результаты поиска. После изменения данной настройки, вам может понадобиться обновление поисковых результатов с помощью кнопки \"Обновить\"."
L["Select professions to include in the profession scan."] = "Выберите профессии для включения в скан профессий."
L["Select whether to sort search results in ascending or descending order."] = "Выберите, следует ли отсортировать результаты поиска в порядке возрастания или убывания." -- Needs review
L["Select whether to use market value or min buyout for calculating disenchant value."] = "Выберите, следует ли использовать рыночную стоимость или мин выкупа для расчета цены распыления." -- Needs review
L["Shift-Right-Click to clear all data for this item from AuctionDB."] = "Shift+ПКМ для очистки всех данных об этом товаре из AuctionDB."
L["Sort items by"] = "Сортировать по"
L["%s - Scanning page %s/%s of filter %s/%s"] = "%s - Сканирую страницу %s/%s фильтра %s/%s"
L["Tailoring"] = "Портняжное дело."
L["The author of TradeSkillMaster has created an application which uses blizzard's online auction house APIs to update your AuctionDB data automatically. Check it out at the link in TSM_AuctionDB's description on curse or at: %s"] = "Автор TSM создал приложение, которое использует Blizzard API аукциона для  автоматического обновления базы данных AuctionDB. Пройдите по ссылке для получения более полной информации: %s"
L["This determines how many items are shown per page in results area of the \"Search\" tab of the AuctionDB page in the main TSM window. You may enter a number between 5 and 500 inclusive. If the page lags, you may want to decrease this number."] = "Определяет сколько товаров показывать на одну страницу в области результатов вкладки \"Поиск\" раздела AuctionDB главного окна TSM. Можно ввести значение от 5 до 500 включительно. Если страница лагает, может потребоваться уменьшить это значение."
-- L["Total Seen Count:"] = ""
L["Use the search box and category filters above to search the AuctionDB data."] = "Используйте поисковое поле и фильтры по категориям выше для поиска по данным AuctionDB."
L["Waiting for data..."] = "Ожидание данных..."
L["You can filter the results by item subtype by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in the item type dropdown and \"Herbs\" in this dropdown."] = "Результаты можно отфильтровать по подтипу товара с помощью этого выпадающего списка. Например, если требуется найти все травы, нужно выбрать \"Хозяйственные товары\" в списке типа товара и \"Трава\" в данном списке."
L["You can filter the results by item type by using this dropdown. For example, if you want to search for all herbs, you would select \"Trade Goods\" in this dropdown and \"Herbs\" as the subtype filter."] = "Результаты можно отфильтровать по типу товара с помощью этого выпадающего списка. Например, если требуется найти все травы, нужно выбрать \"Хозяйственные товары\" в данном списке и \"Трава\" в списке подтипа товара."
L["You can use this page to lookup an item or group of items in the AuctionDB database. Note that this does not perform a live search of the AH."] = "Эту страницу можно использовать для поиска товаров или групп товаров в базе данных AuctionDB. Учтите, что это не \"живой\" поиск по АД."
 