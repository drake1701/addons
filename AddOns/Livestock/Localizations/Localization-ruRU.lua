if GetLocale() == "ruRU" then

	if not LivestockLocalizations then
		LivestockLocalizations = {}
	end

	local L = LivestockLocalizations

	L.LIVESTOCK_FONTSTRING_3DLABEL = "3D Модель"
	L.LIVESTOCK_FONTSTRING_BUTTONSTOGGLETITLE = "Показать / Спрятать кнопки"
	L.LIVESTOCK_FONTSTRING_MACROBUTTONTITLE = "Генерация макроса Livestock"
	L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL = "Спутники"
	L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL = "Наземный транспорт"
	L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL = "Летающий транспорт"
	L.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL = "Smart"
	L.LIVESTOCK_FONTSTRING_MACROBUTTONSTITLE = "Ознакомьтесь с документацией прежде чем нажимать эти кнопки!"
	L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVELABEL = "Автоматически вызывать спуника при движении."
	L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVEFAVELABEL = "Вызывать выбранного спутника вместо случайного."

	L.LIVESTOCK_FONTSTRING_RESTRICTAUTOSUMMONLABEL = "Не вызывать спутника автоматически, если стоит ПвП-флаг."
	L.LIVESTOCK_FONTSTRING_DONOTRAIDSUMMONLABEL = "Не вызывать спутника при нахождении в рейде."  
	L.LIVESTOCK_FONTSTRING_DRUIDTOGGLELABEL = "Использовать 'Облик птицы' при использовании функции Smart."
	L.LIVESTOCK_FONTSTRING_SAFEFLIGHTLABEL = "Безопасный полет: слезть с леающего транспорта возможно только на земле."
	L.LIVESTOCK_FONTSTRING_AUTODISMISSONSTEALTHLABEL = "Отзыв спуника во время использования умений 'Притвориться мертвым', 'Незаметность' или 'Невидимость'."
	L.LIVESTOCK_FONTSTRING_PVPDISMISSLABEL = "Отзывать спутника только если стоит ПвП-флаг." 
	L.LIVESTOCK_FONTSTRING_MOUNTINSTEALTHLABEL = "Разрешить Livestock прерывать действие 'незаметности'."
	L.LIVESTOCK_FONTSTRING_USECOMBATFORMSLABEL = "Функция Smart должна использовать 'Призрачного волка' или 'Походную форму' в бою." 		L.LIVESTOCK_FONTSTRING_SMARTCATFORMLABEL = "Функция Smart может использовать 'Облик кошки' в помещениях."
	L.LIVESTOCK_FONTSTRING_WATERWALKINGLABEL = "Функция Smart может использовать заклинание 'Хождение по воде' под водой."
	L.LIVESTOCK_FONTSTRING_CRUSADERSUMMONLABEL = "Автоматически вызывать Smart-транспорт после использования 'Ауры воина Света'."

	L.LIVESTOCK_MENU_MORE = "Еще   >>>"
	L.LIVESTOCK_MENU_SELECTALL = "Включить все"
	L.LIVESTOCK_MENU_SELECTNONE = "Отключить все"

	L.LIVESTOCK_ZONE_WINTERGRASP = "Ледяных Оков"

	L.LIVESTOCK_TOOLTIP_VERY = "очень"
	L.LIVESTOCK_TOOLTIP_EXTREMELY = "невероятно"
	L.LIVESTOCK_TOOLTIP_FAST = "быстрое"
	L.LIVESTOCK_TOOLTIP_LOCATION = "местанахождения"
	L.LIVESTOCK_TOOLTIP_CHANGES = "меняется"
	L.LIVESTOCK_TOOLTIP_NORTHREND = "Нордскол"
	L.LIVESTOCK_TOOLTIP_OUTLAND = "Запределье"

	L.LIVESTOCK_INTERFACE_CRITTERMACROCREATED = "|cFF4444DDLivestock:|r Макрос вызова случайного спутника создан среди макросов персонажа!"
	L.LIVESTOCK_INTERFACE_LANDMACROCREATED = "|cFF4444DDLivestock:|r Макрос вызова случайного наземного транспорта создан среди макросов персонажа!"
	L.LIVESTOCK_INTERFACE_FLYINGMACROCREATED = "|cFF4444DDLivestock:|r Макрос вызова случайного летающего транспорта создан среди макросов персонажа!"
	L.LIVESTOCK_INTERFACE_SMARTMACROCREATED = "|cFF4444DDLivestock:|r 'Smart' макрос выбора наземного/летающего транспорта создан среди макросов персонажа!"
	L.LIVESTOCK_INTERFACE_NOCRITTERSCHECKED = "|cFF4444DDLivestock:|r В вашем списке отсутствуют спуники. Пожалуйста наберите "..LIVESTOCK_INTERFACE_SLASHSTRING.." и Нажмите на кнопку спутников в появившемся меню."
	L.LIVESTOCK_INTERFACE_NOLANDMOUNTSCHECKED = "|cFF4444DDLivestock:|r В вашем списке отсутствует наземный транспорт. Пожалуйста наберите "..LIVESTOCK_INTERFACE_SLASHSTRING.." и Нажмите на кнопку наземных в появившемся меню."
	L.LIVESTOCK_INTERFACE_NOFLYINGMOUNTSCHECKED = "|cFF4444DDLivestock:|r В вашем списке отсутствуют летающий транспорт. Пожалуйста наберите "..LIVESTOCK_INTERFACE_SLASHSTRING.." и Нажмите на кнопку летающих в появившемся меню."
	L.LIVESTOCK_INTERFACE_RESETSAVEDDATA = "|cFF4444DDLivestock:|r Сохранные данные были перезаписаны, а меню обновлены. Пожалуйста, выберите в соотстветствующих меню спутников и транспорт, который вы хотите использовать."
	L.LIVESTOCK_INTERFACE_NOFAVEPET = "|cFF4444DDLivestock:|r Вы еще не выбрали спутника. Нажмите на нужном спутнике правую кнопку мыши в меню Спутников."
	
	L.LIVESTOCK_INTERFACE_LISTFAVEPET = "|cFF4444DDLivestock: |r На данный момент выбранный Вами спутник: %s." 
	L.LIVESTOCK_INTERFACE_PREFSPANEL = "Настройки Livestock"

end
