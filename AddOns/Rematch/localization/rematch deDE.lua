﻿-- Translations from 2.3.5 to 2.3.8 by Tonyleila @ wowinterface.com
-- Translations from 2.4.0 to current by Zreptil @ curse.com

local _,L = ...
if GetLocale()=="deDE" then

	L["Choosing a pet will turn off Active Sort"] = "Die Auswahl eines Tieres schaltet die aktive Sortierung aus"
	L["Damage expected"] = "Erwarteter Schaden"
	L["This team did not automatically load because you've already auto-loaded a team from where you're standing."] = "Dieses Team wurde nicht automatisch geladen, weil Du vom aktuellen Plaz schon ein automatisch geladenes Team hast"
	L["Save Preferences?"] = "Voreinstellungen speichern?"
	L["Leveling Preferences"] = "Lehrlings Voreinstellungen"
	L["In Pet Battle"] = "Im Haustierkampf"
	L["Battle Options"] = "Kampf Einstellungen"
	L["Close Rematch"] = "Rematch schliessen"
	L["%s not copied. A team of that name already exists."] = "%s wurde nicht kopiert. Ein Team mit diesem Namen existiert bereits"
	L["Auto Load is now"] = "Automatisches Laden ist jetzt"
	L["Leveling Pet"] = "Lehrling"
	L["Or any"] = "oder beliebiges"
	L["Delete Notes"] = "Notizen löschen"
	L["Show after pet battle"] = "Nach Haustierkampf anzeigen" or "Nach Kampf anzeigen"
	L["%s copied."] = "%s kopiert."
	L["You are in %s.\n\nThe leveling slot and queue are locked while you are in %s."] = "Du bist in %s.\n\nDie Warteschlange und der Lehrling sind gesperrt, während Du in %s bist."
	L["When leaving a pet battle, automatically show the Rematch window."] = "Das Rematch Fenster automatisch anzeigen, wenn der Haustierkampf verlassen wird"
	L["Pets are missing!"] = "Tiere fehlen!"
	L["Export"] = "Export"
	L["This pet is currently slotted."] = "Dieses Tier ist zur Zeit ausgewählt."
	L["Choose a new pet"] = "Wähle ein neues Tier"
	L["Expected damage taken"] =  "Erwarteter Schaden genommen"
	L["Teams"] = "Teams"
	L["All done leveling pets!"] = "Alle ausgebildeten Lehrlinge!"
	L["Team"] = "Team"
	L["a pet battle"] = "Ein Haustierkampf"
	L["Unload Team"] = "Team entladen"
	L["You can also double-click a team to load it."] = "Du kannst ein Team auch Doppelklicken, um es zu laden."
	L["  For %s pets: \124cffffd200%d"] = " Für %s Tiere: \124cffffd200%d"
	L["The minimum health of pets can be adjusted by the type of damage they are expected to receive."] = "Die minimale Gesundheit der Tiere kann anhand der Art des Schadens angepasst werden, den sie vermutlich erhalten"
	L["pet PVP"] = "Haustier PVP"
	L["Rematch's leveling queue is empty"] = "Rematch's Warteschlange ist leer"
	L["You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"] = "Du befindest Dich in einem Kampf. Blizzard hat Einschränkungen im Hinblick darauf, was mit Haustieren während eines Kampfes getan werden kann. Versuche es erneut, wenn Du den Kampf verlassen hast. Sorry!"
	L["When this team loads, your active leveling pet will go in this spot."] = "Wenn dieses Team geladen wird, geht Dein aktueller Lehrling an diesen Platz."

	-- common.lua
	L["Toggle Window"] = "Fenster umschalten"
	L["Toggle Auto Load"] = "Automatisches Laden umschalten"
	L["Toggle Pets"] = "Tiere umschalten"
	L["Toggle Teams"] = "Teams umschalten"
  L["Toggle Notes"] = "Notizen umschalten"
	L["Toggles the Rematch window to manage battle pets and teams."] = "Schaltet das Rematch Fenster fuer das Management von Tieren und Teams um."

	-- main.lua
	L["Import"] = "Import"
	L["Options"] = "Optionen"
	L["Teams"] = "Teams"
	L["\124cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"] = "\124cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"
	L["\124cffffff00Rematch Auto Load is now"] = "\124cffffff00Rematch Auto Load ist jetzt"
	L["\124cff00ff00Enabled"] = "\124cff00ff00Aktiviert"
	L["\124cffff0000Disabled"] = "\124cffff0000Deaktiviert"
	L["Current Battle Pets"] = "Aktuelle Kampftiere"
	L["\124cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."] = "\124cffffd200PetBattleTeams ist nicht aktiviert. Versuche es erneut, wenn das Addon aktiviert ist."
  L["Dismiss the summoned pet."] = "Das aktuelle Tier freilassen."
	L["Target treat onto the pet."] = "Belohnung auf das Tier anwenden."
	L["Cast this treat."] = "Diese Belohnung verfüttern."
	L["Summon a favorite pet."] = "Beschwöre einen Favoriten."
	L["Summon a leveling pet."] = "Beschwöre einen Lehrling."

	-- floatingpetcard.lua
	L["Damage Taken"] = "Erlittener Schaden"
	L["from"] = "von"
	L["abilities"] = "Fähigkeiten"
	L["No breeds known :("] = "Keine Brut bekannt :("
  L["\124cffddddddPossible Breeds"] = "\124cffddddddMögliche Brut"
	L["\124cffddddddPossible level 25 \124cff0070ddRares"] = "\124cffddddddMögliche Stufe 25 \124cff0070ddSelten"

	-- leveling.lua
	L["Leveling:"] = "Lehrlinge:"
	L["Sort:"] = "Sort:"
	L["This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the active leveling pet.\n\nWhen a team is saved with a leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."] = "Das ist der Lernplatz.\n\nZiehe ein Haustier mit Level 1-24 hierher, um es als den aktuellen Lehrling festzulegen.\n\nWenn ein Team mit einem Lehrling gespeichert wird, ist der Platz im Team für künftige Lehrlinge reserviert.\n\nDieser Platz kann so viele Lehrlinge beinhalten, wie Du willst. Wenn ein Lehrling Level 25 erreicht, dann wird das oberste Tier in der Warteschlange Dein neuer Lehrling."
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Dieses Tier kann nichts mehr lernen"
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t The queue is sorted"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Die Warteschlange ist sortiert"
	L["This pet is already in the queue. Pets can't move while the queue is sorted"] = "Dieses Tier ist schon in der Warteschlange. Tiere können nicht bewegt werden, solange die Warteschlange sortiert ist."
	L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t The queue is sorted"] = "\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Die Warteschlange ist sortiert"
	L["This pet will be added to the\nend of the unsorted queue."] = "Dieses Tier wird an das Ende\nEnde der unsortierten Warteschlange gesetzt."
	L["\124cffff8800The current leveling pet is in battle and can't be swapped."] = "\124cffff8800Der aktuelle Lehrling ist im Kampf und kann nicht ausgetauscht werden."
	L["Next leveling pet:"] = "Nächster Lehrling:"
  L["Active"] = "Aktiv"
  L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Active Sort is enabled"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Aktive Sortierung ist eingeschaltet"
  L["This pet is already in the queue.\n\nYou can't rearrange the order of pets while the queue is actively sorted."] = "Dieses Tier befindet sich schon in der Warteschlange.\n\nDie Reihenfolge kann nicht geändert werden, solange die aktive Sortierung eingeschaltet ist."
  L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Active Sort is enabled"] = "\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Aktive Sortierung ist eingeschaltet"
  L["The queue is actively sorted. This pet will be sorted with the rest."] = "Die Warteschlange wird aktiv sortiert. Dieses Tier wird entsprechend der Sortierung eingefügt."
	L["Leveling Pet Preferences"] = "Einstellungen für Lehrlinge"
	L["Minimum Health"] = "Minimale Gesundheit"
	L["Maximum Level"] = "Maximale Stufe"
	L["Or any \124TInterface\\PetBattles\\PetIcon-Magical:20:20:0:0:128:256:102:63:129:168\124t & \124TInterface\\PetBattles\\PetIcon-Mechanical:20:20:0:0:128:256:102:63:129:168\124t"] = "oder beliebiges \124TInterface\\PetBattles\\PetIcon-Magical:20:20:0:0:128:256:102:63:129:168\124t & \124TInterface\\PetBattles\\PetIcon-Mechanical:20:20:0:0:128:256:102:63:129:168\124t"
	L["This is the minimum health preferred for a leveling pet."] = "Das ist die minimale Gesundheit, die für einen Lehrling bevorzugt wird."
	L["Allow low-health Magic and Mechanical pets to ignore the Minimum Health, since their racials allow them to often survive a hit that would ordinarily kill them."] = "Lass zu, dass Magische und Mechanische Tiere mit niedriger Gesundheit die Minimale Gesundheit ignorieren, da ihre Rassefähigkeiten es ihnen erlauben, einen Schlag zu überleben, der sie normalerweise umbringen würde."
	L["This is the maximum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 23.45 is level 23 with 45% xp towards level 24."] = "Das ist die maximale Stufe, die für einen Lehrling bevorzugt wird.\n\nStufen können als Kommazahl angegeben werden. Stufe 23.45 ist Stufe 23 mit 45% ep Richtung Level 24."

	-- rmf.lua
	L["Full Sort"] = "Vollständige Sortierung"
	L["Include even the top-most pet in the sort. This can cause the top-most pet to change as it gains xp or pets get added to the queue."] = "Auch der aktuelle Lehrling wird in die Sortierung einbezogen. Dies kann dazu führen, dass der aktuelle Lehrling sich ändert, während er XP erhält oder Tiere in die Warteschlange eingefügt werden."
	L["No Preferences"] = "Keine Bevorzugung"
	L["Suspend all preferred loading of pets from the queue, except for pets that can't load."] = "Jegliche Bevorzugung beim Laden von Lehrlingen aussetzen, ausser für Tiere, die nicht geladen werden können."
	L["Load Filters"] = "Filter laden"
	L["Save Filters"] = "Filter speichern"
	L["Do you want to overwrite the existing saved filters?"] = "Willst Du die vorhandenen Filter überschreiben?"
	L["Reverse Sort"] = "Umgekehrt sortieren"
	L["Favorites First"] = "Favoriten zuerst"
	L["Empty Slot"] = "Platz leeren"
	L["Choose a name."] = "Wähle einen Namen."
	L["Restore original name"] = "Original Namen wieder herstellen"
	L["Release this pet?"] = "Dieses Haustier freilassen?"
	L["Once released, this pet is gone forever!"] = "Wenn es freigelassen wird,\nist dieses Tier für immer weg!"
	L["Cage this pet?"] = "Dieses Haustier in einen Käfig setzen?"
	L["Current Zone"] = "Aktuelle Zone"
	L["Strong Vs"] = "Stark gegen"
	L["Tough Vs"] = "Zäh gegen"
	L["Reset All"] = "Alle zurücksetzen"
	L["Use Type Bar"] = "Typ Balken benutzen"
	L["Leveling"] = "Lehrlinge"
	L["Not Leveling"] = "Kein Lehrling"
	L["Tradable"] = "Handelbar"
	L["Not Tradable"] = "Nicht handelbar"
	L["Can Battle"] = "Kann kämpfen"
	L["Can't Battle"] = "Kann nicht kämpfen"
	L["1 Pet"] = "1 Tier"
	L["2+ Pets"] = "2+ Tiere"
	L["3+ Pets"] = "3+ Tiere"
	L["Only Level 25s"] = "Nur Stufe 25er"
	L["Without Any 25s"] = "Ohne jeden 25er"
	L["Moveset Not At 25"] = "Fähigkeitengruppe nicht auf 25"
	L["In a Team"] = "In einem Team"
	L["Not In a Team"] = "Nicht in einem Team"
	L["Start Leveling"] = "Als Lehrling festlegen"
	L["Add to Leveling Queue"] = "Zu den Lehrlingen hinzufügen"
	L["Stop Leveling"] = "Lehrling entfernen"
	L["Find Similar"] = "Finde ähnliche"
	L["Put Leveling Pet Here"] = "Lehrling hier platzieren"
	L["Move to Top"] = "Ganz nach oben"
	L["Move Up"] = "Rauf bewegen"
	L["Move Down"] = "Runter bewegen"
	L["Move to End"] = "Ganz nach unten"
	L["Fill Queue"] = "Warteschlange füllen"
  L["Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."] = "Befülle die Warteschlange mit einem Tier jeder Rasse aus der Begleiterliste, das ausgebildet werden kann, für dessen Rasse Du noch keines auf Stufe 25 hast."
	L["This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"] = "Damit werden %d Tiere zur Warteschlange hinzugefügt.\n%s\nBist Du sicher, dass Du die Warteschlange füllen willst?"
	L["\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"] = "\nDu kannst die Anzahl an Tieren verrignern, indem Du sie in Rematch's Begleiterliste filterst\n\nBeispiel: suche nach \"21-24\" und setze den Filter auf Seltenheit 'Selten', um die Warteschlange mit seltenen Tieren zwischen Stufe 21 und 24 zu befüllen.\n"
	L["\nAll species with a pet that can level already have a pet in the queue.\n"] = "\nAlle Rassen mit einem Tier, das ausgebildet werden kann, haben bereits ein Mitglied in der Warteschlange.\n"
	L["Fill Queue More"] = "Warteschlange mehr füllen"
	L["Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."] = "Befülle die Warteschlange mit einem Tier jeder Rasse aus der Begleiterliste, das ausgebildet werden kann, unabhängig davon, ob Du schon welche auf Stufe 25 hast."
	L["\124cffccccccThere are no notes for this team.\n\nYou can add a note by right-clicking the team in the team tab and choosing Set Notes."] = "\124cffccccccEs gibt Notizen für dieses Team.\n\nDu kannst eine Notiz hinzufügen, indem Du das Team in der Teamliste rechtsklickst und "..L["Set Notes"].." anklickst."
	L["Notes for this team:"] = "Notizen für dieses Team:"
	L["Set Notes"] = "Notizen schreiben"
	L["Save these notes?"] = "Diese Notizen speichern?"
	L["Empty Queue"] = "Warteschlange leeren"
  L["Remove all leveling pets from the queue."] = "Alle Lehrlinge aus der Warteschlange entfernen."
	L["Are you sure you want to remove all pets from the leveling queue?"] = "Bist Du sicher, dass Du alle Lehrlinge aus der Warteschlange entfernen willst?"
	L["Queue"] = "Warteschlange"
	L["Sort By:"] = "Sortierung nach:"
	L["Sort Order:"] = "Sortierreihenfolge:"
	L["Ascending"] = "Steigend"
	L["Sort:Ascending"] = "Sortierung:Steigend"
  L["Sort all pets in the queue from level 1 to level 24."] = "Sortiere alle Lehrlinge von Stufe 1 bis Stufe 24."
	L["Sort the queue from\nlevel 1 to level 25."] = "Sortiere die Warteschlange von\nStufe 1 bis Stufe 25."
	L["Descending"] = "Fallend"
	L["Sort:Descending"] = "Sortierung:Fallend"
  L["Sort all pets in the queue from level 24 to level 1."] = "Sortiere alle Lehrlinge von Stufe 25 bis Stufe 1."
	L["Sort the queue from\nlevel 25 to level 1."] = "Sortiere die Warteschlange von\nStufe 25 bis Stufe 1."
	L["Median"] = "Mittel"
	L["Sort:Median"] = "Sortierung:Mittel"
  L["Sort all pets in the queue for levels closest to 10.5."] = "Sortiere alle Lehrlinge nach Stufen, die am nächsten an 10,5 liegen."
	L["Sort the queue for\nlevels closest to 10.5."] = "Sortiere die Warteschlange nach\nStufennähe zu 10,5."
	L["Sort:Type"] = "Sortierung:Typ"
  L["Sort all pets in the queue by their types."] = "Sortiere alle Lehrlinge anhand ihres Typs."
  L["Time"] = "Zeit"
	L["Sort:Time"] = "Sortierung:Zeit"
	L["Sort all pets in the queue by when they were added, earliest pets first."] = "Sortiere alle Lehrlinge nach dem Zeitpunkt als sie hinzugefügt wurden, das älteste zuerst."
	L["Active Sort"] = "Aktive Sortierung"
	L["When sorting the queue, Rematch will keep it sorted. The order of pets may change as they gain xp or get added/removed from the queue.\n\nYou cannot manually change the order of pets while the queue is actively sorted."] = "Wenn die Lehrlinge sortiert werden, behält Rematch die Sortierung bei. Die Reihenfolge der Lehrlinge kann sich ändern, wenn sie EP gewinnen oder zur Warteschlange hinzugefügt oder aus ihr entfernt werden.\n\nDie Sortierung der Warteschlange kann nicht manuell geändert werden, wenn sie aktiv sortiert wird."
  L["Reload"] = "Team neu laden"
	L["Auto Rotate"] = "Auto Rotate"
	L["After the leveling pet gains xp:\n\n\124cffffd200Ascending\124cffe6e6e6 and \124cffffd200Median\124cffe6e6e6 sorts will swap\nto the top-most pet in the queue.\n\n\124cffffd200Unsorted\124cffe6e6e6 and \124cffffd200Descending\124cffe6e6e6 sort will\nswap to the next pet in the queue."] = "After the leveling pet gains xp:\n\n\124cffffd200Ascending\124cffe6e6e6 and \124cffffd200Median\124cffe6e6e6 sorts will swap\nto the top-most pet in the queue.\n\n\124cffffd200Unsorted\124cffe6e6e6 and \124cffffd200Descending\124cffe6e6e6 sort will\nswap to the next pet in the queue."
	L["Fill the leveling queue with one of\neach species that can level from\nthe filtered pet browser."] = "Füllt die Warteschlange mit einem von\njeder Rasse, das ausgebildet werden kann\naus der gefilterten Begleiterliste."
	L["Remove all leveling pets\nfrom the queue."] = "Entfernt alle Lehrlinge\naus der Warteschlange."
	L["Edit"] = "Ändern"
	L["Delete this team?"] = "Dieses Team löschen?"
	L["Load"] = "Laden"
	L["Load Team"] = "Team laden"
	L["You can double-click\na team to load also."] = "Du kannst ein Team auch\nDoppelklicken um es zu laden."
	L["Rename"] = "Umbenennen"
	L["Move To"] = "Verschieben nach"
	L["Send"] = "Senden"
	L["Export"] = "Export"
	L["Save To"] = "Speichern als"
	L["Prefer Live Pets"] = "Lebende Tiere bevorzugen"
	L["When loading pets from the queue, skip dead pets and load living ones first."] = "Wenn ein Tier aus der Warteschlange geladen wird, werden tote Tiere ausgelassen und lebende zuerst geladen."
	L["Press CTRL+C to copy this team to the clipboard."] = "Drücke STRG+C, um dieses Team in die Zwischenablage zu kopieren."
	L["Press CTRL+V to paste a team from the clipboard."] = "Drücke STRG+V, um ein Team aus der Zwischenablage zu holen."

	-- options.lua
	L["Targeting Options"] = "Ziel Optionen"
	L["Auto show on target"] = "Automatisch beim Zielen anzeigen"
	L["When targeting something with a saved team not already loaded, show the Rematch window."] = "Wenn etwas anvisiert wird und das gespeicherte Team nicht schon geladen ist, wird das Rematch Fenster angezeigt."
	L["Auto load on mouseover"] = "Automatisch beim Überfahren mit der Maus laden"
	L["When your mouseover or target has saved pets not already loaded, load the pets immediately."] = "Wenn Du ein Ziel mit der Maus überfährst oder die für das Ziel gespeicherten Tiere nicht schon geladen sind, werden die Tiere sofort geladen."
	L["Auto load"] = "Automatisch laden"
	L["When your mouseover or target has a saved team not already loaded, load the team immediately."] = "Wenn Du ein Ziel mit der Maus überfährst oder die für das Ziel gespeicherten Tiere nicht schon geladen sind, werden die Tiere sofort geladen."
	L["Show after loading"] = "Nach dem Laden anzeigen"
	L["When a team is automatically loaded, show the Rematch window if it's not already shown."] = "Wenn ein Team automatisch geladen wird, wird das Rematch Fenster angezeigt, wenn es nicht schon angezeigt wird."
	L["Stay after loading"] = "Nach dem Laden offen bleiben"
	L["Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."] = "Das Rematch Fenster bleibt auf dem Bildschirm, nachdem ein Team geladen wurde wenn das Fenster durch '"..L["Auto show on target"].."' angezeigt wurde."
	L["Discard loaded team on changes"] = "Gel. Team bei Änd. verwerfen"
	L["This option changes the normal behavior of Rematch and its interaction with targets. Specifically, any time you change pets or abilities, it will disregard what you have loaded in the past and always offer to load/show teams. Also, it will be very difficult to save changes to teams by targeting. The Reload button will also be disabled. \124cffff2222WARNING!\124cffffd200 This option is not recommended!"] = "Diese Option ändert das normale Verhalten von Rematch und seine Interaktion mit Zielen. Jedes mal, wenn Du ein Tier oder eine Fähigkeit änderst, wird es das verwerfen, was Du zuletzt geladen hast und anbieten Teams zu laden / anzuzeigen. Es wird auch schwer, Änderungen an Teams beim Zielen zu speichern. Der Reload button wird ebenfalls ausgeschaltet. \124cffff2222WARNUNG!\124cffffd200 Diese Option ist nicht empfehlenswert!"
	L["On target only"] = "Nur beim Zielen"
	L["Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"] = "Es wird nur automatisch geladen, wenn etwas anvisiert wird, nicht beim Überfahren mit der Maus. \124cffff2222WARNUNG!\124cffffd200 Diese Option ist nicht empfehlenswert! Es ist oft zu spät Haustiere zu laden, wenn ein Kampf beginnt, nachdem man ein Ziel mit Rechts-Klick anvisiert hat!"
	L["Window Options"] = "Fenster Optionen"
	L["Larger window"] = "Grösseres Fenster"
	L["Make the Rematch window larger for easier viewing."] = "Macht das Rematch Fenster für einfacheres Betrachten grösser."
	L["Larger list text"] = "Grösserer Listentext"
	L["Make the text in the scrollable lists (pets, teams and options) a little bigger."] = "Mach den Text in den scrollbaren Listen (Begleiter, Teams und Optionen) ein wenig grösser."
	L["Reverse pullout"] = "Umgekehrtes Ausklappen"
	L["When the Pets or Teams tab is opened, expand the window down the screen instead of up."] = "Wenn die Begleiterliste oder Teamliste geöffnet wird, wird sie von oben nach unten ausgeklappt."
	L["Show dialogs at side"] = "Zeige Dialoge an der Seite an"
	L["Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."] = "Zeigt Dialoge an der Seite des Rematch Fensters an statt in der Mitte."
	L["Reverse dialog direction"] = "Umgekehrte Dialog Richtung"
  L["This setting controls which side of the Rematch window popup dialogs will appear.\n\nRegardless of this setting, when the window is expanded, unless the 'Show dialogs at side' option is checked, they will appear in the middle of the window.\n\n\Otherwise:\n\n\124cffffd200When this option is disabled:\124r Dialogs will appear in the direction that the pullout drawer grows.\n\n\124cffffd200When this option is enabled:\124r Dialogs will appear in the opposite direction that the pullout drawer grows."] =   "Diese Option legt fest, auf welcher Seite des Rematch Fensters Dialoge angezeigt werden.\n\nUnabhängig von dieser Option erscheinen sie in der Mitte des Fensters, wenn das Fenster vergrössert wird, ausser die Option '"..L["Show dialogs at side"].."' ist markiert.\n\n\Andererseits:\n\n\124cffffd200Wenn diese Option ausgeschaltet ist:\124r Dialoge erscheinen in der Richtung, in der die Listen ausgeklappt werden.\n\n\124cffffd200Wenn diese Option aktiv ist:\124r Dialoge erscheinen in der gegenüberliegenden Richtung, in der die Listen ausgeklappt werden."
	L["When displaying a popup dialog adjacent to the Rematch window, make them appear on the side towards the edge of the screen instead of towards the center."] = "Wenn ein Dialog angezeigt wird, der am Rematch Fenster hängt, wird er an der Seite angezeigt, die näher zum Rand als zur Mitte des Bildschirms liegt."
	L["Lock window position"] = "Fenster Position sperren"
	L["Prevent the Rematch window from being dragged unless Shift is held."] = "Das Rematch Fenster davor bewahren, bewegt oder in der Grösse verändert zu werden, ausser die Shift-Taste wird gedrückt."
	L["Lock window size"] = "Fenster Grösse sperren"
	L["Prevent the window from being resized with the resize grip along the edge of the window."] = "Das Fenster davor bewahren, mit dem Griff am Rand in der Grösse verändert zu werden."
	L["Lock window height"] = "Fenster Höhe sperren"
	L["Prevent the window's height from being resized with the resize grip along the bottom of the expanded window."] = "Verhindern, dass das Fenster mit dem Griff am unteren Rand in der Höhe verändert werden kann."
	L["Disable ESC for window"] = "ESC für das Fenster ausschalten"
	L["Prevent the Rematch window from being dismissed with the Escape key."] = "Verhindert, dass das Rematch Fenster mit der ESC-Taste geschlossen werden kann."
	L["Disable ESC for drawer"] = "ESC für Liste ausschalten"
	L["Prevent the pullout drawer from being collapsed with the Escape key."] = "Verhindert, dass die Liste mit der ESC-Taste geschlossen werden kann."
  L["Disable ESC for notes"] = "ESC für Notizen ausschalten"
  L["Prevent the notes card from being dismissed with the Escape key."] = "Verhindert, dass Notizen mit der ESC-Taste geschlossen werden können."
  L["Close everything with ESC"] = "Alles mit ESC schliessen"
  L["Escape Key Behavior"] = "Verhalten der ESC-Taste"
  L["Close all Escape-enabled Rematch windows at once with the Escape key instead of one at a time."] = "Alle Rematch Fenster auf einmal mit der ESC-Taste schliessen, anstatt eines nach dem anderen."
	L["Stay for pet battle"] = "Beim Haustierkampf offen bleiben"
	L["When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."] = "Das Rematch Fenster offen halten, wenn ein Haustierkampf beginnt, anstatt es zu verbergen. Hinweis: Das Fenster schliesst sich weiterhin während eines normalen Kampfes."
	L["Stay while targeting"] = "Offen bleiben während des Anvisierens"
	L["Do not dismiss the Rematch window with ESC until there is no target."] = "Das Rematch Fenster nicht mit der ESC-Taste schliessen bis kein Ziel mehr vorhanden ist."
	L["Loading Options"] = "Lade Optionen"
	L["One-click loading"] = "Laden mit einem Klick"
	L["When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."] = "Wenn ein Team in der Teamliste angeklickt wird, lade das Team sofort, anstatt die Teamkarte zu sperren. Wenn das hier nicht angekreuzt ist, kann ein Team mit Doppelklick geladen werden."
	L["Empty missing pet slots"] = "Empty missing pet slots"
	L["When a team with missing pets loads and a pet is missing, empty the slot the pet would go to instead of ignoring the slot."] = "When a team with missing pets loads and a pet is missing, empty the slot the pet would go to instead of ignoring the slot."
	L["Keep companion"] = "Begleiter behalten"
	L["After a team is loaded, summon back the companion that was at your side before the load."] = "Nachdem ein Team geladen wurde, wird der Begleiter wieder beschworen, der an Deiner Seite war, bevor es geladen wurde."
	L["Show on injured"] = "Bei Verletzung anzeigen"
	L["When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."] = "Wenn ein Tier geladen wird, zeige das Fenster wenn irgendwelche Tiere verletzt sind. Das Fenster wird nach wie vor angezeigt, wenn irendwelche Tiere tot oder nicht vorhanden sind, unabhängig von dieser Option."
	L["Leveling Queue Options"] = "Warteschlangen Optionen"
	L["Keep current pet on new sort"] = "Aktuellen Lehrling nicht sortieren"
	L["When sorting the queue, keep the top-most pet at the top so the current leveling pet doesn't change.\n\nThis option has no effect when the queue is actively sorted."] = "Wenn die Warteschlange sortiert wird, wird das oberste Tier beibehalten, so dass der aktuelle Lehrling nicht wechselt.\n\nDiese Option hat keinen Effekt, wenn die Warteschlange aktiv sortiert wird."
	L["Keep sort when emptied"] = "Sortierung beibehalten, wenn leer"
	L["When the queue is emptied, preserve the sort order and auto rotate status instead of resetting them."] = "Wenn die Warteschlange leer ist, werden Sortierung und automatische Rotation beibehalten."
	L["Hide pet toast"] = "Haustiernachricht verbergen"
	L["Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."] = "Keine Nachricht anzeigen, wenn ein Haustier automatisch aus der Warteschlange geladen wird."
	L["Pet Browser Options"] = "Begleiterliste Optionen"
	L["Use type bar"] = "Typ Balken verwenden"
	L["Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."] = "Zeig den Balken oberhalb der Begleiterliste an, um die Liste nach Typ, Stärke und Widerstandskraft filtern zu können."
	L["Only battle pets"] = "Nur Kampfhaustiere"
	L["Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."] = "Keine Tiere in der Begleiterliste anzeigen, die nicht kämpfen können, so wie Gildenherolde. Hinweis: die meisten Filter wie Seltenheit, Stufe oder Statistik beinhalten diese Tiere von vorne herein nicht."
	L["List real names"] = "Zeige richtige Namen an"
	L["Even if a pet has been renamed, list each pet by its real name."] = "Auch wenn ein Haustier umbenannt wurde, jedes Tier mit richtigem Namen anzeigen."
	L["Reset filters on login"] = "Filter beim Login löschen"
	L["Reset all pet browser filters (including sort) when logging in."] = "Löscht alle Begleiterlistenfilter (inklusive der Sortierung) wenn Du dich anmeldest."
	L["Inclusive \"Strong Vs\" filter"] = "Inklusive \"Stark geg.\" Filter."
	L["When filtering Strong Vs multiple types, list pets that have an ability that's strong vs one of the chosen types, instead of requiring at least one ability to be strong vs each chosen type."] = "Wenn Stark gegen mehrere Typen gefiltert wird, werden Tiere angezeigt, die eine Fähigkeit haben, die stark gegen einen der gewählten Typen ist, statt die, die mindestens eine Fähigkeit haben, die stark gegen jeden ausgewählten Typ ist"
	L["Don't reset sort with filters"] = "Sortierung nicht mit Filter löschen"
	L["When a non-standard sort is chosen, don't reset it when clicking the filter reset button at the bottom of the pet browser.\n\n\124cffffd200Note:\124r If 'Reset filters on login' is enabled, sort will still be reset on login regardless of this option."] = "Wenn eine Sortierung gewählt wurde, die nicht dem Standard entspricht, lösche sie nicht, wenn der Filter löschen Button unter der Begleiterliste geklickt wird.\n\n\124cffffd200Hinweis:\124r Wenn '"..L["Reset filters on login"].."' aktiviert ist, wird die Sortierung nach wie vor beim Login gelöscht, unabhängig von dieser Option hier."
	L["Show ability numbers"] = "Fähigkeiten Nummer anzeigen"
	L["In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."] = "Im Fähigkeitenfenster die Nummern 1 und 2 anzeigen, um dabei zu helfen, die übliche Notation wie \"Tier Name 122\" zu interpretieren, die anzeigt, welche Fähigkeiten zu benutzen sind."
	L["Use actual ability icons"] = "Verwende Icons der Fähigkeiten"
	L["In the pet card, display the actual icon of each ability instead of an icon showing the ability's type."] = "Zeige im Haustierfenster das aktuelle Symbol jeder Fähigkeit an statt des Symbols für die Art der Fähigkeit"
	L["Show notes in battle"] = "Zeige Hinweise im Kampf"
	L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] = "Wenn das geladene Team Notizen hat, zeige diese an und sperre sie wenn Du einen Haustierkampf beginnst."
	L["Only once per team"] = "Nur einmal pro Team"
  L["Only display notes automatically the first time entering battle, until another team is loaded."] = "Notizen nur anzeigen, wenn das Team einen Kampf zum erstenmal bestreitet, bis ein anderes Team geladen wird."
	L["Hide rarity borders"] = "Seltenheitsrahmen ausblenden"
	L["Hide the colored borders to indicate rarity around current pets and pets on the team cards."] = "Blendet die farbigen Rahmen, welche die Seltenheit des Tieres anzeigen, um die aktiven Haustiere und die Haustiere auf den Karten aus."
  L["Disable sharing"] = "Teilen ausschalten"
	L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] = "Schaltet den Send-Button aus und verhindert ebenfalls, dass andere Dir Tiere zusenden können. Import und Export funktionieren trotzdem."
	L["Don't warn about missing pets"] = "Nicht vor fehlenden Tieren warnen"
	L["Don't display a popup when a team loads and a pet within the team can't be found."] = "Keine Warnung anzeigen, wenn ein Team geladen wird und ein Mitglied des Teams nicht gefunden werden kann."
	L["Jump to key"] = "Zur Taste springen"
	L["While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."] = "Wenn der Mauszeiger über der Teamliste oder der Begleiterliste ist, springt diese bei Tastendruck zu dem Team oder Begleiter, das/der mit dem Buchstaben anfängt."
	L["Use Battle.net (beta)"] = "Verwende Battle.net (beta)"
	L["If both you and the recipient have this option checked, teams can be sent to or from battle.net friends. Note: The recipient needs Rematch 3.0 or greater."] = "Wenn Du und der Empfänger diese Option aktiviert haben, können Teams zwischen Euch ausgetauscht werden. Hinweis: Der Empfänger braucht Rematch 3.0 oder höher."
	L["Hide tooltips"] = "Hinweise verstecken"
	L["Hide the more common tooltips within Rematch."] = "Die einfachen Hinweise in Rematch nicht anzeigen."
	L["Even alerts"] = "auch Warnungen"
	L["Also hide tooltips that warn when you can't place a pet somewhere. This is not recommended if you're new to the addon."] = "Auch Hinweise verbergen, die Dich warnen, wenn Du ein Haustier irgendwo nicht hinsetzen kannst. Das ist nicht empfohlen, wenn das Addon neu für Dich ist."
	L["Even options"] = "auch Optionen"
	L["Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."] = "Auch Hinweise verbergen, die hier bei den Optionen angezeigt werden. Das ist nicht empfohlen, wenn das Addon neu für Dich ist."
	L["Use minimap button"] = "Minimap Button anzeigen"
	L["Place a button on the minimap to toggle Rematch."] = "Zeigt an der Minimap einen Button an, mit dem Rematch umgeschaltet werden kann."
	L["Hide journal button"] = "Button im Wildtierführer verbergen"
	L["Do not place a Rematch button along the bottom of the default Pet Journal."] = "Der Button am unteren Rand im normalen Wildtierführer wird nicht mehr angezeigt."
	L["Go to the key binding window to create or change bindings for Rematch."] = "Öffne die Tastaturbelegung, um Tastenbelegungen für RFematch zu erzeugen oder ändern."
	L["Import Pet Battle Teams"] = "Importiere Pet Battle Teams"
	L["Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."] = "Kopiert die Teams vom Addon Pet Battle Teams in die aktive Gruppe in Rematch."
	L["Toggle Rematch"] = "Rematch umschalten"
	L["\124cffffd200%s\124r copied."] = "\124cffffd200%s\124r kopiert."
	L["\124cffffd200%s\124r not copied. A team of that name already exists."] = "\124cffffd200%s\124r nicht kopiert. Es gibt bereits ein Team mit diesem Namen."
	L["Pet Battle Teams Imported"] = "Pet Battle Teams importiert"
	L["Copy again and overwrite?"] = "Erneut kopieren und überschreiben?"
	L["%d teams copied successfully."] = "%d Teams erfolgreich kopiert."
	L["\n\n%d teams were not copied because teams already exist in Rematch with the same names."] = "\n\n%d Teams wurden nicht kopiert, weil Teams mit diesem Namen schon in Rematch vorhanden waren."
	L["Pets Tab Closed"] = "Begleiterliste geschlossen"
	L["The pet journal's search box can't be used while the pet tab is open, sorry!"] = "Die Suche im Wildtierführer kann nicht verwendet werden, solange die Begleiterliste offen ist, sorry!"

	-- petloading.lua
	L["Loading..."] = "Lade..."

	-- roster.lua
	L["Battle"] = "Kampf"
	L["Quantity"] = "Anzahl"
	L["Favorite"] = "Favorit"
	L["Zone"] = "Zone"
	L["Level"] = "Stufe"
	L["Filters: \124cffffffff"] = "Filter: \124cffffffff"
	L["Search, "] = "Suche, "
	L["Similar, "] = "Ähnliche, "
	L["Type, "] = "Typ, "
	L["Strong, "] = "Stark, "
	L["Tough, "] = "Zäh, "
	L["Sources, "] = "Herkunft, "
	L["Rarity, "] = "Seltenheit, "
	L["Collected, "] = "Gesammelt, "
  L["Sort, "] = "Sortiert, "

	-- save.lua
	L["Save As..."] = "Speichern unter..."
	L["Save this team?"] = "Das Team speichern?"
	L["New Team"] = "Neues Team"
	L["A team already has this name."] = "Ein Team mit diesem Namen ist schon vorhanden."
	L["Overwrite this team?"] = "Dieses Team überschreiben?"
	L["Import Team"] = "Team importieren"
	L["A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."] = "Ein Team hat bereits diesen Namen.\nKlicke \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t um einen Namen zu wählen."
	L["Import As..."] = "Importieren als..."
	L["Send this team?"] = "Dieses Team senden?"
	L["Who would you like to send this team to?"] = "An wen möchtest Du dieses Team schicken?"
	L["Team received!"] = "Team empfangen!"
	L["Sending..."] = "Sende..."
	L["No response. Lag or no Rematch?"] = "Keine Antwort. Lag oder Rematch nicht vorhanden?"
	L["They do not appear to be online."] = "Sie scheinen nicht online zu sein."
	L["They're busy. Try again later."] = "Sie sind beschäftigt. Versuche es später noch einmal."
	L["They're in combat. Try again later."] = "Sie sind im Kampf. Versuche es später noch einmal."
	L["They have team sharing disabled."] = "Team Austausch ist bei ihnen ausgeschaltet."
	L["Incoming Rematch Team"] = "Empfange Rematch Team"
	L["\124cffffd200%s\124r has sent you a team named \124cffffd200\"%s\"\124r"] = "\124cffffd200%s\124r hat Dir ein Team mit Namen \124cffffd200\"%s\"\124r geschickt"
  L["Save leveling pets as themselves"] = "Speichere Lehrlinge als sie selbst"
  L["Save As Themselves"] = "Als Selbst speichern"
  L["Save pets without turning them into leveling pets.\n\nSo loading this team in the future will load these specific pets and not from the queue."] = "Speichert Tiere ohne sie in Lehrlinge zu verwandeln.\n\nWenn dieses Team in Zukunft geladen wird, werden die eingestellten Tiere verwendet und nicht die aktuellen Lehrlinge."

	-- teams.lua
	L["New Tab"] = "Neue Gruppe"
	L["Create a new tab."] = "Erzeuge eine neue Gruppe."
	L["Choose a name and icon."] = "Wähle einen Namen und ein Symbol."
	L["Delete this tab?"] = "Diese Gruppe löschen?"
	L["Teams in this tab will be moved to the General tab."] = "Teams in dieser Gruppe werden in die allgemeine Gruppe verschoben."
	L["Load this team?"] = "Dieses Team laden?"
	L["Rename this team?"] = "Dieses Team umbenennen?"

	-- browser.lua
	L["Queued:"] = "Lehrlinge:"
	L["Strong vs"] = "Stark geg."
	L["Tough vs"] = "Zäh geg."
	L["Pets:"] = "Tiere:"
	L["Owned:"] = "Besitz:"
  L["Your pets:"] = "Deine Tiere:"
  L["Owned: \124cffffffff%d\124r\nMissing: \124cffffffff%d\124r\nUnique: \124cffffffff%d\124r\nLevel 25: \124cffffffff%d"] = "Besitz:        \124cffffffff%d\124r\nFehlend:     \124cffffffff%d\124r\nEinzigartig: \124cffffffff%d\124r\nStufe 25:     \124cffffffff%d"
end