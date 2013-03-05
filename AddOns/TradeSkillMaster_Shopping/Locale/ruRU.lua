-- ------------------------------------------------------------------------------------- --
-- 					TradeSkillMaster_Shopping - AddOn by Sapu94							 	  	  --
--   http://wow.curse.com/downloads/wow-addons/details/tradeskillmaster_shopping.aspx    --
--																													  --
--		This addon is licensed under the CC BY-NC-ND 3.0 license as described at the		  --
--				following url: http://creativecommons.org/licenses/by-nc-nd/3.0/			 	  --
-- 	Please contact the author via email at sapu94@gmail.com with any questions or		  --
--		concerns regarding this license.																	  --
-- ------------------------------------------------------------------------------------- --

-- TradeSkillMaster_Shopping Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_Shopping/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Shopping", "ruRU")
if not L then return end

L["12 hours"] = "12 часов"
L["24 hours"] = "24 часа"
L["48 hours"] = "48 часов"
L["Accept"] = "Принять"
L["Add Item"] = "Добавить предмет"
L["Add Item / Search Term"] = "Добавить предмет / поисковое выражение"
L["Add item to dealfinding list"] = "Добавить предмет в список dealfinding"
L["Add Item to Dealfinding List"] = "Добавить предмет в список Dealfinding"
L["Add Item to New List"] = "Добавить предмет в новый список"
L["Add Item to Selected List"] = "Добавить предмет в выбранный список"
L["Add item to shopping list"] = "Добавить предмет в список покупок"
L["Add Item to Shopping List"] = "Добавить предмет в список покупок"
L["Additional Options:"] = "Дополнительные опции:"
L["Add Search Term"] = "Добавить поисковое выражение"
-- L["A disenchant search will look for auctions which can be purchased and disenchanted for a profit."] = ""
L["Are you sure you want to delete the selected profile?"] = "Вы действительно хотите удалить выбранный профиль?"
L["Auction Buyout:"] = "Цена выкупа:"
L["Auction Buyout (Stack Price):"] = "Цена выкупа (цена стопки):"
L["Auction Duration"] = "Срок аукциона"
L["Auction Item Price"] = "Цена за предмет"
-- L["Auction not found. Restarting search."] = ""
-- L["Auction not found. Skipped."] = ""
L["Auctions"] = "Лоты"
L["Auction Stack Price"] = "Цена за стопку"
-- L["Automatically Expand Single Result"] = ""
-- L["A vendor search will look for auctions which can be purchased and then sold to a vendor for a profit."] = ""
-- L["Below are some general options for the Shopping module."] = ""
-- L["Below are various special searches that TSM_Shopping can perform. The scans will use data from your most recent scan (or import) if the data is less than an hour old. Data can come from TSM_AuctionDB or TSM_WoWuction. Otherwise, they will do a scan of the entire AH which may take several minutes."] = ""
L["Bid Percent"] = "Процент ставки"
L["Cancel"] = "Отмена"
-- L["Canceling"] = ""
-- L["Cannot change current item while scanning."] = ""
-- L["Cannot create auction with 0 buyout."] = ""
--[==[ L[ [=[|cffffbb11No dealfinding or shopping lists found. You can create shopping/dealfinding lists through the TSM_Shopping options.

TIP: You can search for multiple items at a time by separating them with a semicolon. For example: "volatile life; volatile earth; volatile water"|r]=] ] = "" ]==]
--[==[ L[ [=[|cffffff00Inline Filters:|r You can easily add common search filters to your search such as rarity, level, and item type. For example '%sarmor/leather/epic/85/i350/i377|r' will search for all leather armor of epic quality that requires level 85 and has an ilvl between 350 and 377 inclusive. Also, '%sinferno ruby/exact|r' will display only raw inferno rubys (none of the cuts).
]=] ] = "" ]==]
--[==[ L[ [=[|cffffff00Multiple Search Terms:|r You can search for multiple things at once by simply separated them with a ';'. For example '%selementium ore; obsidium ore|r' will search for both elementium and obsidium ore.
]=] ] = "" ]==]
--[==[ L[ [=[Click on an item to search for it.
Shift-click to post it at the listed item value.]=] ] = "" ]==]
-- L["Click on this icon to enter disenchanting mode."] = ""
-- L["Click on this icon to enter milling mode."] = ""
-- L["Click on this icon to enter prospecting mode."] = ""
-- L["Click on this icon to enter transformation mode."] = ""
-- L["Click to shop for this item."] = ""
L["Copy From"] = "Скопировать из"
L["Copy the settings from one existing profile into the currently active profile."] = "Скопировать настройки существующего профиля в текущий."
L["Crafting Cost:"] = "Цена крафта:"
-- L["Crafting Mats"] = ""
L["Create a new empty profile."] = "Создать новый пустой профиль."
L["Current Profile:"] = "Текущий профиль:"
-- L["Data Imported to Group: %s"] = ""
L["Dealfinding list deleted: \"%s\""] = "Удалён список Dealfinding: \"%s\""
L["Dealfinding List Name"] = "Имя списка Dealfinding"
L["Dealfinding Lists"] = "Списки Dealfinding"
L["Dealfinding Search"] = "Поиск Dealfinding"
L["Default"] = "По умолчанию"
L["Default Undercut"] = "По умолчанию подрезать на"
L["Delete a Profile"] = "Удалить профиль"
L["Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."] = "Удалить существующие и неиспользуемые профили и очистить файл SavedVariables."
L["Delete / Export List"] = "Удаление / Экспорт списка"
L["Delete List"] = "Удалить список"
L["Destroying Modes to Use:"] = "Используемые режимы уничтожения:"
-- L["Destroying Results Default Sort (requires reload)"] = ""
-- L["Determines what percent of the buyout price Shopping will use for the starting bid when posting auctions."] = ""
-- L["Did not add search term \"%s\". Already in this list."] = ""
-- L["Disenchantable Armor"] = ""
-- L["Disenchantable Weapons"] = ""
L["Disenchanting"] = "Распыление"
-- L["Disenchant Search"] = ""
-- L["% Disenchant Value"] = ""
-- L["Enter the search term you would list to add below. You can add multiple search terms at once by separating them with semi-colons. For example, \"elementium ore; volatile\""] = ""
--[==[ L[ [=[Enter what you want to search for in this box. You can also use the following options for more complicated searches.
]=] ] = "" ]==]
L["Even Stacks Only"] = "Только полные стаки"
-- L["Even Stacks Only (Ore/Herbs)"] = ""
-- L["Even Stacks (Ore/Herbs)"] = ""
L["Existing Profiles"] = "Существующие профили"
L["% Expected Cost"] = "% ожидаемой цены"
-- L["Export List"] = ""
-- L["Fallback Price Percent"] = ""
-- L["Fallback Price Source"] = ""
L["General Options"] = "Общие настройки"
-- L["Here you can add an item or a search term to this shopping list."] = ""
-- L["Here you can add an item to this dealfinding list."] = ""
-- L["Here you can choose in which situations Shopping should run a destroying search rather than a regular search for the target item."] = ""
-- L["Here, you can remove items from this list."] = ""
-- L["Here, you can remove search terms from this list."] = ""
-- L["Here, you can set the maximum price you want to pay for each item in this list."] = ""
-- L["Hide Items in Auctioning Groups"] = ""
-- L["How long auctions should be posted for."] = ""
-- L["How much to undercut other auctions by, format is in \"#g#s#c\", \"50g30s\" means 50 gold, 30 silver."] = ""
-- L["If checked, items which are in Auctioning groups will not be shown in the quick posting window."] = ""
-- L["If checked, only 5/10/15/20 stacks of ore and herbs will be shown."] = ""
-- L["If checked, only 5/10/15/20 stacks of ore and herbs will be shown. Note that this setting is the same as the one that shows up when you run a Destroying search."] = ""
-- L["If checked, the quick posting window will automatically open by default."] = ""
-- L["If checked, the results of a dealfinding scan will include items above the maximum price. This can be useful if you sometimes want to buy items that are just above your max price."] = ""
-- L["If there are none of an item on the auction house, Shopping will use this percentage of the fallback price source for the default post price."] = ""
-- L["If there are none of an item on the auction house, Shopping will use this price source for the default post price."] = ""
-- L["If the results of a search only contain one unique item, it will be automatically expanded to show all auctions of that item if this option is enabled."] = ""
-- L["Ignore Existing Items"] = ""
-- L["Import Dealfinding List"] = ""
-- L["Imported List"] = ""
-- L["Import List"] = ""
-- L["Import Shopping List"] = ""
-- L["Invalid Exact Only Filter"] = ""
-- L["Invalid Filter"] = ""
L["Invalid folder name. A folder with this name may already exist."] = "Неверное имя папки. Возможно, папка с таким именем уже существует."
-- L["Invalid Item Level"] = ""
-- L["Invalid Item Rarity"] = ""
-- L["Invalid Item SubType"] = ""
-- L["Invalid Item Type"] = ""
-- L["Invalid list name. A list with this name may already exist."] = ""
-- L["Invalid Min Level"] = ""
L["Invalid money format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = "Введён неверный денежный формат, должен быть \"#g#s#c\", \"25g4s50c\" - это 25 золотых, 4 серебряных, 50 медных."
-- L["Invalid search term."] = ""
-- L["Invalid Usable Only Filter"] = ""
L["Item"] = "Предмет"
-- L["Item Buyout:"] = ""
-- L["Item is already in dealfinding list: %s"] = ""
-- L["Item Level"] = ""
L["Items"] = "Предметы"
-- L["Item Settings"] = ""
L["Item to Add"] = "Добавить предмет"
-- L["Last Scan"] = ""
-- L["Left-Click: |cffffffffRun this recent search.|r"] = ""
-- L["Left-Click: |cffffffffRun this shopping/dealfinding list.|r"] = ""
-- L["List Data"] = ""
-- L["List Data (just select all and copy the data from inside this box)"] = ""
-- L["List Management"] = ""
-- L["List Name"] = ""
-- L["List to Add Item to:"] = ""
L["% Market Value"] = "% рыноч. цены"
-- L["MAX"] = ""
L["% Max Price"] = "% макс. цены"
-- L["Max Price Per Item"] = ""
L["Milling"] = "Измельчение"
L["Mode:"] = "Режим:"
-- L["Name of New List to Add Item to:"] = ""
-- L["Name of the new dealfinding list."] = ""
-- L["Name of the new shopping list."] = ""
L["New"] = "Новый"
-- L["New Dealfinding List"] = ""
-- L["New List Name"] = ""
-- L["No items found that can be turned into:"] = ""
-- L["Nothing below dealfinding price from last scan."] = ""
-- L["Nothing below vendor price from last scan."] = ""
-- L["Nothing to search for."] = ""
-- L["Nothing worth disechanting from last scan."] = ""
-- L["No valid search terms. Aborting search."] = ""
-- L["Only even stacks (5/10/15/20) of this item will be purchased. This is useful for buying herbs / ore to mill / prospect."] = ""
-- L["Open Quick Auctions Window by Default"] = ""
-- L["Opens a new window that allows you to import a dealfinding list."] = ""
-- L["Opens a new window that allows you to import a shopping list."] = ""
L["Options"] = "Настройки"
-- L["Over an hour ago"] = ""
-- L["Performing a full scan due to no recent scan data being available. This may take several minutes."] = ""
-- L["Post"] = ""
-- L["Posting"] = ""
-- L["Posting Options"] = ""
-- L["Price Per Crafting Mat"] = ""
-- L["Price Per Enchanting Mat"] = ""
-- L["Price Per Gem"] = ""
-- L["Price Per Ink"] = ""
-- L["Price Per Item"] = ""
-- L["Price Per Item/Stack"] = ""
-- L["Price Per Stack"] = ""
-- L["Price Per Target Item"] = ""
-- L["Primary Filter"] = ""
-- L["Professions to Buy Materials for:"] = ""
L["Profiles"] = "Профили"
L["Prospecting"] = "Просеивание"
-- L["Purchasing"] = ""
-- L["Quantity Needed:"] = ""
-- L["Quick Posting"] = ""
-- L["Quick Posting Options"] = ""
-- L["Quick Post Max Stack Size"] = ""
-- L["Quick Post Price Source"] = ""
-- L["Recent Searches"] = ""
-- L["Remove"] = ""
-- L["Remove Item"] = ""
-- L["Remove Search Term"] = ""
-- L["Rename List"] = ""
L["Reset Profile"] = "Очистить профиль"
-- L["Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."] = ""
-- L["Right-Click: |cffffffffCreate shopping list from this recent search.|r"] = ""
-- L["Right-Click: |cffffffffOpen the options for this shopping/dealfinding list|r"] = ""
-- L["Saved Searches"] = ""
L["Scanning"] = "Сканирование"
-- L["Scanning page %s of %s for filter %s of %s..."] = ""
-- L["Scanning page %s of %s for filter %s of %s: %s"] = ""
-- L["Searching for item..."] = ""
-- L["Search Mode: %sDestroying Search|r"] = ""
-- L["Search Mode: %sRegular Search|r"] = ""
-- L["Search Results Default Sort (requires reload)"] = ""
-- L["Search Results Market Value Price Source"] = ""
-- L["Secondary Filter"] = ""
-- L["Select all the professions for which you would like to buy materials."] = ""
-- L["Select Mode"] = ""
-- L["Select Primary Filter"] = ""
L["Seller"] = "Продавец"
-- L["Shift-Right-Click: |cffffffffDelete this shopping/dealfinding list. Cannot be undone!|r"] = ""
-- L["Shift-Right-Click: |cffffffffRemove from recent searches.|r"] = ""
-- L["Shop for materials required by the Crafting queue."] = ""
L["Shopping - Crafting Mats"] = "Shopping - Материалы для крафта"
-- L["Shopping/Dealfinding Lists"] = ""
-- L["Shopping/Dealfinding list with name \"%s\" already exists. Creating group under name \"%s\" instead."] = ""
-- L["Shopping for:"] = ""
-- L["Shopping list deleted: \"%s\""] = ""
-- L["Shopping List Name"] = ""
-- L["Shopping Lists"] = ""
-- L["Shopping Options"] = ""
L["Shopping - Quick Posting"] = "Shopping - Быстрое выставление"
-- L["Show/Hide the quick posting frame. This frame shows all the items in your bags and allows you to quickly post them."] = ""
-- L["Show/Hide the saved searches frame. This frame shows all your recent searches as well as your shopping and dealfinding lists."] = ""
-- L["Show/Hide the special searches frame. This frame shows all the special searches such as vendor, disenchanting, resale, and more."] = ""
-- L["Showing summary of all %s auctions for list \"%s\""] = ""
-- L["Showing summary of all %s auctions for \"%sDealfinding Search|r\""] = ""
-- L["Showing summary of all %s auctions that match filter \"%s\""] = ""
-- L["Show Results Above Dealfinding Price"] = ""
L["%s is already in a dealfinding list and has been removed from this list."] = "%s уже находится в списке dealfinding и был удалён из текущего списка."
L["%s item(s) will be removed (already in a dealfinding list)"] = "%s предмет(а/ов) будет удалён (уже в списке dealfinding)"
-- L["Skipped the following search term because it's invalid."] = ""
-- L["Skipped the following search term because it's too long. Blizzard does not allow search terms over 63 characters."] = ""
-- L["%s minute(s), %s second(s) ago with %s"] = ""
-- L["Special Searches"] = ""
-- L["Specifies the default sorting for results in the \"Destroying\" feature."] = ""
-- L["Specifies the default sorting for results in the \"Search\" feature."] = ""
-- L["Specifies the market value price source for results in the \"Search\" feature."] = ""
-- L["Specifies the price source listed in the quick post window. This is the price used when you shift-click on an item."] = ""
-- L["%s removed from recent searches."] = ""
-- L["Stack Info:"] = ""
L["Stack Size"] = "Размер стопки"
-- L["stacks of"] = ""
-- L["Starts a dealfinding search which searches for all your dealfinding lists at once."] = ""
-- L["Summary of all %s auctions that can be turned into:"] = ""
-- L["Switch List Type"] = ""
-- L["Switch Type"] = ""
-- L["The data you are trying to import is invalid."] = ""
-- L["The item you entered was invalid. See the tooltip for the \"%s\" editbox for info about how to add items."] = ""
-- L["The list you are trying to import is not a dealfinding list. Please use the shopping list import feature instead."] = ""
-- L["The list you are trying to import is not a shopping list. Please use the dealfinding list import feature instead."] = ""
-- L["The options below control the \"Post\" button that is shown at the bottom of the auction frame inside the \"Search\" feature."] = ""
-- L["The options below control the \"Quick Posting\" window that is shown on the right of auction frame inside the \"Search\" feature. When you shift-click on an item within this window, it will be posted according to the settings below as well as the duration and bid percent settings set in the \"Post Options\" section below."] = ""
-- L["This is the maximum price you want to pay per item (NOT per stack) for this item. You will be prompted to buy all items on the AH that are below this price."] = ""
-- L["This item is already in the \"%s\" Dealfinding List."] = ""
-- L["This item is already in this group."] = ""
L["Time Left"] = "Срок"
--[==[ L[ [=[Total value of your auctions: %s
Incoming gold: %s]=] ] = "" ]==]
-- L["Transforming"] = ""
-- L["Unknown"] = ""
-- L["Unknown Filter"] = ""
-- L["Use the box below to create a new dealfinding list. A dealfinding list is a list of items along with a max price you'd like to pay for each item. This is the equivalent of a \"snatch list\"."] = ""
-- L["Use the box below to create a new shopping list. A shopping list is a list of items and search terms you frequently search for."] = ""
--[==[ L[ [=[Use the button below to convert this list from a Dealfinding list to a Shopping list.

NOTE: Doing so will remove all item settings from the list! This cannot be undone.]=] ] = "" ]==]
--[==[ L[ [=[Use the button below to convert this list from a Shopping list to a Dealfinding list.

NOTE: Doing so will remove all search terms from this list as well as any items that are already in a dealfinding list! This cannot be undone.]=] ] = "" ]==]
-- L["Use this checkbox to temporarily modify the post duration. You can change the default value in the Shopping options."] = ""
-- L["% Vendor Price"] = ""
-- L["Vendor Search"] = ""
-- L["WARNING: No recent scan data found. Scans may take several minutes."] = ""
-- L["When you shift-click an item in the quick post window, a single auction will be created in as large a stack as possible, up to this stack size."] = ""
-- L["Which list to add this item to."] = ""
-- L["You can change the active database profile, so you can have different settings for every character."] = ""
L["You can either create a new profile by entering a name in the editbox, or choose one of the already exisiting profiles."] = "Задайте имя нового профиля или выберите один из уже существующих."
L["You can either drag an item into this box, paste (shift click) an item link into this box, or enter an itemID."] = "Можно перетащить предмет в это поле, вставить его название (через shift+клик) или ввести его itemID."
-- L["You currently have %s of this item and it stacks up to %s."] = ""
