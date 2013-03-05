-- Credit for French localization goes to Vastilia  (WoWInterface) with support from Vorgl(Curse)

if GetLocale() == "frFR" then

	if not LivestockLocalizations then
		LivestockLocalizations = {}
	end

	local L = LivestockLocalizations

	L.LIVESTOCK_FONTSTRING_3DLABEL = "Mod\195\168le 3D"
	L.LIVESTOCK_FONTSTRING_BUTTONSTOGGLETITLE = "Commuter les boutons"
	L.LIVESTOCK_FONTSTRING_MACROBUTTONTITLE = "G\195\169n\195\169rateur des macros de Livestock"
	L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL = "Compagnons"
	L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL = "Terrestres"
	L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL = "Volantes"
	L.LIVESTOCK_FONTSTRING_SHOWWATERLABEL = "Aquatiques"
	L.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL = "Smart"
	L.LIVESTOCK_FONTSTRING_MACROBUTTONSTITLE = "Merci de lire la documentation avant de cliquer sur ces boutons!"
	L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVELABEL = "Invoquer automatiquement un compagnon quand vous vous d\195\169placez."
	L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVEFAVELABEL = "Invoque votre favori plut\195\180t qu'un compagnon al\195\169atoire."
	L.LIVESTOCK_FONTSTRING_RESTRICTAUTOSUMMONLABEL = "Ne pas invoquer automatiquement de compagnon en mode JcJ."
	L.LIVESTOCK_FONTSTRING_IGNOREPVPRESTRICTIONININSTANCESLABEL = "...sauf en instance JcE."
	L.LIVESTOCK_FONTSTRING_DONOTRAIDSUMMONLABEL = "Ne pas invoquer automatiquement de compagnon en raid."
	L.LIVESTOCK_FONTSTRING_DISMISSPETONMOUNTLABEL = "Renvoyer le compagnon avant de prendre une monture volante ou d'invoquer la forme de vol."
	L.LIVESTOCK_FONTSTRING_DRUIDTOGGLELABEL = "Permettre la forme de vol avec le 'Smart Mounting.'"
	L.LIVESTOCK_FONTSTRING_SAFEFLIGHTLABEL = "Anti-chute: Activer une monture ne vous fait pas chuter en vol."
	L.LIVESTOCK_FONTSTRING_AUTODISMISSONSTEALTHLABEL = "Renvoyer le compagnon avec Camouflage, Feindre la mort, ou Invisibilit\195\169."
	L.LIVESTOCK_FONTSTRING_PVPDISMISSLABEL = "Renvoie uniquement quand vous \195\170tes en mode JcJ."
	L.LIVESTOCK_FONTSTRING_MOUNTINSTEALTHLABEL = "Permettre \195\160 Livestock de stopper Camouflage lors de la monte."
	L.LIVESTOCK_FONTSTRING_USECOMBATFORMSLABEL = "'Smart Mounting' vous bascule en Loup fant\195\180me / Forme de voyage en combat."
	L.LIVESTOCK_FONTSTRING_USEMOVINGFORMSLABEL = "'Smart Mounting' vous bascule en Loup fant\195\180me / Forme de voyage en bougeant (hors combat)."
	L.LIVESTOCK_FONTSTRING_SMARTCATFORMLABEL = "'Smart Mounting' bascule le lanceur de sorts en forme f\195\169line \195\160 l'int\195\169rieur."
	L.LIVESTOCK_FONTSTRING_WATERWALKINGLABEL = "'Smart Mounting' invoque %s quand vous \195\170tes sous l'eau."
	L.LIVESTOCK_FONTSTRING_CRUSADERSUMMONLABEL = "Lance automatiquement 'Smart Mounting' apr\195\168s l'invocation d'Aura de crois\195\169."
	
	L.LIVESTOCK_MENU_MORE = "Plus..."
	L.LIVESTOCK_MENU_SELECTALL = "Tout s\195\169lectionner"
	L.LIVESTOCK_MENU_SELECTNONE = "Tout d\195\169s\195\169lectionner"
	
	L.LIVESTOCK_ZONE_WINTERGRASP = "Joug-d'hiver"
	
	L.LIVESTOCK_TOOLTIP_VERY = "tr\195\168s"
	L.LIVESTOCK_TOOLTIP_EXTREMELY = "extr\195\170mement"
	L.LIVESTOCK_TOOLTIP_FAST = "rapide"
	L.LIVESTOCK_TOOLTIP_FAST2 = "vite"
	L.LIVESTOCK_TOOLTIP_LOCATION = "endroit"
	L.LIVESTOCK_TOOLTIP_CHANGES = "change"
	L.LIVESTOCK_TOOLTIP_NORTHREND = "Norfendre"
	L.LIVESTOCK_TOOLTIP_OUTLAND = "Outreterre"
	
	L.LIVESTOCK_INTERFACE_CRITTERMACROCREATED = "|cFF4444DDLivestock:|r La macro des compagnons al\195\169atoires a \195\169t\195\169 cr\195\169\195\169e dans l'onglet des macros de votre personnage!"
	L.LIVESTOCK_INTERFACE_LANDMACROCREATED = "|cFF4444DDLivestock:|r La macro des montures al\195\169atoires a \195\169t\195\169 cr\195\169\195\169e dans l'onglet des macros de votre personnage!"
	L.LIVESTOCK_INTERFACE_FLYINGMACROCREATED = "|cFF4444DDLivestock:|r La macro des montures volantes al\195\169atoires a \195\169t\195\169 cr\195\169\195\169e dans l'onglet des macros de votre personnage!"
	L.LIVESTOCK_INTERFACE_SMARTMACROCREATED = "|cFF4444DDLivestock:|r La macro 'Smart Mounting' a \195\169t\195\169 cr\195\169\195\169e dans l'onglet des macros de votre personnage!"
	L.LIVESTOCK_INTERFACE_NOCRITTERSCHECKED = "|cFF4444DDLivestock:|r Il n'y a pas de compagnons dans votre liste. Tapez "..LIVESTOCK_INTERFACE_SLASHSTRING.." et cliquez sur le bouton "..L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL.." pour faire votre s\195\169lection."
	L.LIVESTOCK_INTERFACE_NOLANDMOUNTSCHECKED = "|cFF4444DDLivestock:|r Il n'y a pas de montures terrestres dans votre liste. Tapez "..LIVESTOCK_INTERFACE_SLASHSTRING.." et cliquez sur le bouton "..L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL.." pour faire votre s\195\169lection."
	L.LIVESTOCK_INTERFACE_NOFLYINGMOUNTSCHECKED = "|cFF4444DDLivestock:|r Il n'y a pas de montures volantes dans votre liste. Tapez "..LIVESTOCK_INTERFACE_SLASHSTRING.." et cliquez sur le bouton "..L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL.." pour faire votre s\195\169lection."
	L.LIVESTOCK_INTERFACE_RESETSAVEDDATA = "|cFF4444DDLivestock:|r Les donn\195\169es ont \195\169t\195\169 effac\195\169es et menus reconstruits. Vous devez aller dans les menus des compagnons et des montures pour d\195\169s\195\169lectionner ceux que vous ne voulez pas invoquer."
	L.LIVESTOCK_INTERFACE_NOFAVEPET = "|cFF4444DDLivestock:|r Vous n'avez pas encore choisi votre compagnon favori! Faites un clic droit sur un familier dans le menu d\195\169roulant pour en faire votre favori."
	L.LIVESTOCK_INTERFACE_LISTFAVEPET = "|cFF4444DDLivestock: |r Votre compagnon favori actuel est %s."
	L.LIVESTOCK_INTERFACE_MAINPANEL = "Livestock"
	L.LIVESTOCK_INTERFACE_PREFSPANEL1 = "Compagnons"
	L.LIVESTOCK_INTERFACE_PREFSPANEL2 = "Smart et Mouvement"
	
end
