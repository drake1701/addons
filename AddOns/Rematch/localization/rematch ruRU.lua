-- ruRU localization by Himeric at curse.com

local _,L = ...
if GetLocale()=="ruRU" then

L["1 Pet"] = "1 Питомец"
L["2 Pets"] = "2 Питомца"
L["3 Pets"] = "3 Питомца"
L["abilities"] = "способности"
L["Add to Leveling Queue"] = "Добавить в Очередь Прокачки"
L["After a team is loaded, summon back the companion that was at your side before the load."] = "После загрузки команды оставляет уже призванного питомца."
L[ [=[After the leveling pet gains xp:

|cffffd200Ascending|cffe6e6e6 and |cffffd200Median|cffe6e6e6 sorts will swap
to the top-most pet in the queue.

|cffffd200Unsorted|cffe6e6e6 and |cffffd200Descending|cffe6e6e6 sort will
swap to the next pet in the queue.]=] ] = [=[После получения опыта:

|cffffd200По возрастанию|cffe6e6e6 и |cffffd200Средний|cffe6e6e6 сортировка меняет
на самого верхнего питомца в очереди.

|cffffd200Без сортировки|cffe6e6e6 и |cffffd200По убыванию|cffe6e6e6 меняет
на следующего в очереди питомца.]=]
L[ [=[
All species with a pet that can level already have a pet in the queue.
]=] ] = [=[
Все уникальные питомцы которых можно прокачать уже имеют питомца в очереди.
]=]
L["Also hide tooltips that warn when you can't place a pet somewhere. This is not recommended if you're new to the addon."] = "Также скрывать подсказки предупреждающие если вы не можете поставить питомца куда-либо. Это не рекомендуется если вы пользуетесь аддоном первый раз."
L["Always show or load"] = "Всегда показывать или загружать"
L["Are you sure you want to remove all pets from the leveling queue?"] = "Вы уверены что хотите удалить всех питомцев из Очереди Прокачки?"
L["Ascending"] = "По возрастанию"
L["A team already has this name."] = "Это имя уже задано для команды."
L[ [=[A team already has this name.
Click |TInterface\RaidFrame\ReadyCheck-Ready:16|t to choose a name.]=] ] = [=[Это имя уже задано для команды.
Нажмите |TInterface\RaidFrame\ReadyCheck-Ready:16|t чтобы выбрать имя.]=]
L["Auto load"] = "Автозагрузка"
L["Auto load on mouseover"] = "Автозагрузка при наведении мышью"
L["Auto load will only happen when you target, not mouseover. |cffff2222WARNING!|cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"] = "Автозагрузка только при выборе цели, а не при наведении мышью. |cffff2222Предупреждение!|cffffd200 Эта опция не рекомендуется! Часто происходит то что петы не загружаются если правым кликом бой начинается сразу!"
L["Auto Rotate"] = "Авто замена"
L["Auto show on target"] = "Показ окна при выборе цели"
L["Battle"] = "Битва"
L["Cage this pet?"] = "Посадить в клетку?"
L["Can Battle"] = "Боевые"
L["Can't Battle"] = "Не боевые"
L["|cff00ff00Enabled"] = "|cff00ff00Включено"
L["|cffddddddPossible level 25 |cff0070ddRares"] = "cffddddddВозможный уровнеь 25 |cff0070ddРедкие"
L["|cffff0000Disabled"] = "|cffff0000Отключено"
L["|cffff8800The current leveling pet is in battle and can't be swapped."] = "|cffff8800Текущий качаемый питомец в бою и не может быть перенесен"
L["|cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"] = "|cffff8800Вы в бою. Blizzard ограничивает то что вы можете делать с питомцами во время боя. Попробуйте снова после боя."
L["|cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."] = "|cffffd200PetBattleTeams выключен. Попробуйте опять когда аддон будет включен."
L["|cffffd200%s|r copied."] = "|cffffd200%s|r скопированно."
L["|cffffd200%s|r has sent you a team named |cffffd200\"%s\"|r"] = "|cffffd200%s|r отправляет вам команду с именем |cffffd200\"%s\"|r"
L["|cffffd200%s|r not copied. A team of that name already exists."] = "|cffffd200%s|r не скопировано. Команда с таким именем уже существует."
L["|cffffff00Rematch Auto Load is now"] = "|cffffff00Rematch Автозагрузка включена"
L["Choose a name."] = "Выберите имя."
L["Choose a name and icon."] = "Выберите имя и иконку"
L["Collected, "] = "Собрано,"
L["Continue to offer to load (or auto load) teams if any pets or abilities are changed in the loaded team."] = "Продолжать предлагать загрузку (или автозагрузку) команд, если какие-либо питомцы или способности изменены в загруженных командах."
L["Copy again and overwrite?"] = "Копировать и перезаписать?"
L["Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."] = "Копировать команды из аддона Pet Battle Teams в текущюю вкладку команд в Rematch."
L["Create a new tab."] = "Создать новую вкладку."
L["Current Battle Pets"] = "Текущие Боевые Питомцы"
L["Current Zone"] = "Текущая зона"
L["Damage Taken"] = "Получаемый урон"
L["Delete this tab?"] = "Удалить вкладку?"
L["Delete this team?"] = "Удалить команду?"
L["Descending"] = "По убывани"
L["Disable ESC for drawer"] = "Отключить ESC для выпадающего списка"
L["Disable ESC for window"] = "Отключить ESC для окна"
L["Disable sharing"] = "Запретить делиться командами"
L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] = "Отключает кнопку Отправить а также блокирует любые приходящие команды питомцев. Импорт и Экспорт работают."
L["Do not change the current leveling pet to the top-most pet when choosing a sort order."] = "Не менять текущего качаемного пета на на самого верхнего при выборе порядка сортировки."
L["Do not dismiss the Rematch window with ESC until there is no target."] = "Не убирать окно Rematch кнопкой ESC пока нет цели."
L["Do not place a Rematch button along the bottom of the default Pet Journal."] = "Не размешать кнопку Rematch внизу стандартного Атласа питомцев"
L["Don't display a popup when a team loads and a pet within the team can't be found."] = "Не показывать всплывающее окно когда команда загружена, а питомец в команде не был найден."
L["Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."] = "Не показывать всплывающую иконку когда новый питомец автоматически загружается в Очередь Прокачки."
L["Don't warn about missing pets"] = "Не предупреждать об отсутствующих питомцах"
L["%d teams copied successfully."] = "%d команды скопированы успешно."
L[ [=[

%d teams were not copied because teams already exist in Rematch with the same names.]=] ] = "%d команды не были скопированы, потому что команды уже существуют в Rematch с теми же именами."
L["Edit"] = "Редактировать"
L["Empty missing pet slots"] = "Очистить слоты отсутствующих питомцев"
L["Empty Queue"] = "Очистить Очередь"
L["Empty Slot"] = "Очистить слот"
L["Even alerts"] = "Также предупреждения"
L["Export"] = "Экспорт"
L["Favorite"] = "Избранное"
L["Fill Queue"] = "Заполнить очередь"
L[ [=[Fill the leveling queue with one of
each species that can level from
the filtered pet browser.]=] ] = [=[Заполнить очередь прокачки
каждым видом питомцев
из показанных в журнале
]=]
L["Filters: |cffffffff"] = "Фильтры: |cffffffff"
L["from"] = "из"
L["Go to the key binding window to create or change bindings for Rematch."] = "Перейти на окно назначения клавиш и задать клавиши для Rematch."
L["Hide journal button"] = "Скрыть кнопку журнала"
L["Hide pet toast"] = "Скрыть иконку качаемого пета"
L["Hide the more common tooltips within Rematch."] = "Скрыть большинство обычных подсказок Rematch."
L["Hide tooltips"] = "Скрыть подсказки"
L["If both you and the recipient have this option checked, teams can be sent to or from battle.net friends. Note: The recipient needs Rematch 3.0 or greater."] = "Если оба, вы и получатель, включите эту опцию, команды могут быть отправлены через battle.net. Замечание: Для получения нужно Rematch 3.0 или выше."
L["Import"] = "Импорт"
L["Import As..."] = "Импортировать как..."
L["Import Pet Battle Teams"] = "Ипортировать Pet Battle Teams"
L["Import Team"] = "Импортировать команду"
L["Incoming Rematch Team"] = "Полученная команда Rematch"
L["Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."] = "Вместо всплывающего диалога появляющегося по центру окна Rematch, показывать диалог сбоку."
L["Jump to key"] = "Переход к букве"
L["Keep companion"] = "Сохранять питомца-спутника"
L["Keep current pet on new sort"] = "Сохранять текущего питомца при новой сортировке"
L["Keep sort when emptied"] = "Сохранять сортировку при окончании списка"
L["Larger window"] = "Увеличить окно"
L["Leveling"] = "Прокачка"
L["Leveling:"] = "Прокачка:"
L["Leveling Queue Options"] = "Опции Очереди Прокачки"
L["Load"] = "Загрузить"
L["Loading..."] = "Загружается..."
L["Loading Options"] = "Опции загрузки"
L["Load Team"] = "Загрузить команду"
L["Load this team?"] = "Загрузить эту команду?"
L["Lock window height"] = "Заблокировать высоту окна"
L["Lock window position"] = "Заблокировать позицию окна"
L["Make the Rematch window larger for easier viewing."] = "Сделать окно Rematch больше для более удобного просмотра"
L["Median"] = "Средний"
L["Move Down"] = "Вниз"
L["Move To"] = "Переместить"
L["Move to End"] = "В конец"
L["Move to Top"] = "В начало"
L["Move Up"] = "Вверх"
L["Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."] = "Не показывать питомцев которые не участвуют в битвах, например Гильдейский глашатай. Замечание: большинство фильтров как редкость, уровни и способности сами исключают этих питомцев"
L["New Tab"] = "Новая вкладка"
L["New Team"] = "Новая команда"
L["Next leveling pet:"] = "Следующий качаемый питомец:"
L["No breeds known :("] = "Неизвестные бриды :("
L["No response. Lag or no Rematch?"] = "Не отвечает. Лаг или нет Rematch?"
L["Not Leveling"] = "Уже прокачан"
L["Not Tradable"] = "Не продается"
L["Once released, this pet is gone forever!"] = "Отпуская этого питомца он пропадет навсегда!"
L["One-click loading"] = "Загрузка одним нажатием"
L["Only battle pets"] = "Только боевые питомцы"
L["On target only"] = "Только при выделении цели"
L["Options"] = "Настройки"
L["Overwrite this team?"] = "Перезаписать эту команду?"
L["Owned:"] = "В наличии:"
L["Pet Battle Teams Imported"] = "Pet Battle Teams импортирован"
L["Pet Browser Options"] = "Настройки журнала питомцев"
L["Pets:"] = "Питомцы:"
L["Pets are missing!"] = "Питомцы отсутствуют!"
L["Pets Tab Closed"] = "Вкладка питомцев закрыта"
L["Place a button on the minimap to toggle Rematch."] = "Добавить иконку к миникарте для доступа к окну Rematch."
L["Press CTRL+C to copy this team to the clipboard."] = "Нажмите CTRL+C для копирования команды в буфер обмена."
L["Press CTRL+V to paste a team from the clipboard."] = "Нажмите CTRL+V для вставки команды из буфера обмена."
L["Prevent the pullout drawer from being collapsed with the Escape key."] = "Отключить закрытие выпадающего списка клавишей Escape."
L["Prevent the Rematch window from being dismissed with the Escape key."] = "Отключить закрытие окна Rematch кнопкой Escape."
L["Prevent the Rematch window from being dragged unless Shift is held."] = "Отключить перетаскивания окна Rematch если не зажата клавиша Shift."
L["Prevent the window's height from being resized with the resize grip along the bottom of the expanded window."] = "Отключить изменение высоты окна с помощью захвата нижней части окна."
L["Put Leveling Pet Here"] = "Добавить питомца для прокачки"
L["Quantity"] = "Количество"
L["Queue"] = "Очередь"
L["Queued:"] = "В очереди"
L["Rarity, "] = "Качество,"
L["Release this pet?"] = "Отпустить этого питомца?"
L[ [=[Remove all leveling pets
from the queue.]=] ] = [=[Удалить всех качаемых
питомцев из очереди]=]
L["Rename"] = "Переименовать"
L["Rename this team?"] = "Переименовать команду?"
L["Reset All"] = "Сбросить все"
L["Restore original name"] = "Восстановить оригинальное имя"
L["Reverse pullout"] = "Обратить выпадение"
L["Save As..."] = "Сохранить как..."
L["Save this team?"] = "Сохранить эту команду?"
L["Save To"] = "Сохранить в"
L["Search, "] = "Поиск,"
L["Send"] = "Отправить"
L["Sending..."] = "Отправка..."
L["Send this team?"] = "Отправить эту команду?"
L["Show dialogs at side"] = "Показывать диалог сбоку"
L["Show on injured"] = "Показывать травмированных"
L["Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."] = "Показывать активируемую вкладку вверху журнала питомцев для сортировки семейств питомцев, питомцев которые сильны или живучи против выбранных семействю"
L["Sort:"] = "Сортировка:"
L["Sort:|cffffd200Ascending"] = "Сортировка:|cffffd200Возр."
L["Sort:|cffffd200Descending"] = "Сортировка:|cffffd200Убыв."
L["Sort:|cffffd200Median"] = "Сортировка:|cffffd200Сред."
L["Sort Order:"] = "Порядок сортировки:"
L[ [=[Sort the queue for
levels closest to 10.5.]=] ] = [=[Сортировать очередь по
уровню ближайшему к 10.5]=]
L[ [=[Sort the queue from
level 1 to level 25.]=] ] = [=[Сортировать очередь
от 1 до 25 уровня]=]
L[ [=[Sort the queue from
level 25 to level 1.]=] ] = [=[Сортировать очередь
от 25 до 1 уровня]=]
L["Sources, "] = "Источники,"
L["Start Leveling"] = "Начать прокачку"
L["Stay for pet battle"] = "Оставлять во время боев"
L["Stay while targeting"] = "Оставлять пока выделена цель"
L["Stop Leveling"] = "Остановить прокачку"
L["Strong, "] = "Силен,"
L["Strong vs"] = "Силен против"
L["Strong Vs"] = "Силен Против"
L["Targeting Options"] = "Опции выбора цели"
L["Team received!"] = "Команда получена!"
L["Teams"] = "Команды"
L["Teams in this tab will be moved to the General tab."] = "Команды из этой вкладки будут перемещены во вкладку Общие."
L["The pet journal's search box can't be used while the pet tab is open, sorry!"] = "Окно журнала поиска питомцев не может быть использовано пока вкладка питомцев открыта!"
L["They do not appear to be online."] = "Получатель кажется не в сети."
L["They have team sharing disabled."] = "Получатель отключил опцию получения."
L["They're busy. Try again later."] = "Получатель занят. Попробуйте позже."
L["They're in combat. Try again later."] = "Получатель в бою. Попробуйте позже."
L[ [=[This is the leveling slot.

Drag a level 1-24 pet here to set it as the current leveling pet.

When a team is saved with the current leveling pet, that pet's place on the team is reserved for future leveling pets.

This slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet.]=] ] = [=[Это слот прокачки.

Перетащите питомца 1-24 уровня сюда для установки качаемого питомца.

Когда команда сохраняется с этим качаемым питомцем, это место в команде будет сохранено для других качаемых питомцев.

Этот слот будет работать всегда пока у вас есть качаемые питомцы. При достижении 25 уровня питомец меняется на следующего в очереди.]=]
L[ [=[This pet is already in the queue.
Pets can't move while the
queue is sorted]=] ] = [=[Этот питомец уже в очереди
Питомцев нелья сдвинуть
если очередь сортируется]=]
L[ [=[This pet will be added to the
end of the unsorted queue.]=] ] = [=[Этот питомец будет добавлен
в конец не сортированной очереди.]=]
L[ [=[This will add %d pets to the leveling queue.
%s
Are you sure you want to fill the leveling queue?]=] ] = [=[Это добавит %d питомцев в Очередь Прокачки
%s
Вы уверены что хотите заполнить Очередь Прокачки?]=]
L["|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16|t The queue is sorted"] = "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16|t Очередь рассортирована"
L["|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16|t This pet can't level"] = "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16|t Этого питомца нельзя прокачать"
L["|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16|t The queue is sorted"] = "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16|t Очередь рассортирована"
L["Toggle Auto Load"] = "Включить Автозагрузку"
L["Toggle Pets"] = "Открыть Питомцы"
L["Toggle Rematch"] = "Открыть Rematch"
L["Toggles the Rematch window to manage battle pets and teams."] = "Открыть окно Rematch для управления боевыми питомцами и командами."
L["Toggle Teams"] = "Открыть Команды"
L["Toggle Window"] = "Включить Окно"
L["Tough, "] = "Живуч,"
L["Tough vs"] = "Живуч против"
L["Tough Vs"] = "Живуч Против"
L["Tradable"] = "Продаваемые"
L["Type, "] = "Тип,"
L["Use Battle.net (beta)"] = "Использовать Battle.net (beta)"
L["Use minimap button"] = "Использовать кнопку у миникарты"
L["Use type bar"] = "Использовать меню типов"
L["Use Type Bar"] = "Использовать меню Типов"
L["When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."] = "Когда бой питомцев начат, окно Rematch остается на экране, вместо закрытия. Замечание: окно все же будет закрыто в бою против другого игрока."
L["When a team with missing pets loads and a pet is missing, empty the slot the pet would go to instead of ignoring the slot."] = "Когда загружается команда с отсутствующим питомцем - очищать слот вместо его игнорирования."
L["When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."] = "Когда вы нажимаете на иконку команды, вместо выделения команды сразу произойдет загрузка это команды. Если эта опция не выбрана, то загрузка происходит по двойному щелчку."
L["When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."] = "Когда питомцы загружены, показывать окно если любой из эти питомцев ранен. Это окно будет показывать если любой питомец мертв или отсутствует, независимо от настроек."
L["When targeting something with a saved team not already loaded, show the Rematch window."] = "Показывать окно Rematch когда выделена цель с сохраненной для нее командой."
L["When the Pets or Teams tab is opened, expand the window down the screen instead of up."] = "Вкладка Питомцы или Команды разворачивается вниз, а не вверх."
L["When the queue is emptied, preserve the sort order and auto rotate status instead of resetting them."] = "Когда очередь пуста сохранять порядок сортировки и настройки авторотации вместо их обнуления."
L["When your mouseover or target has a saved team not already loaded, load the team immediately."] = "Если при наведении мышью на цель команда для этой цели еще не загружена - то это загрузит команду автоматически."
L["While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."] = "Когда курсор над списком команд или питомцев, нажатие на любую буквенную клавишу переходит на имя питомца или команды которая начинается на эту букву."
L["Who would you like to send this team to?"] = "Кому вы хотите отправить эту команду?"
L["Window Options"] = "Опции окна"
L[ [=[You can double-click
a team to load also.]=] ] = [=[Вы также можете загрузить
команду двойным нажатием]=]
L[ [=[
You can reduce the number of pets by filtering them in Rematch's pet browser

For instance: search for "21-24" and filter Rare only to fill the queue with rares between level 21 and 24.
]=] ] = [=[
Вы можете уменьшить количество питомцев отсеяв их в журнале питомцев Rematch

Для примера: поиск по "21-24" и фильтр по Редкий покажет список Редких с уровнями от 21 до 24
]=]
L["Zone"] = "Зона"

end