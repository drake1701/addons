--[[
	This file is a template for localizing Rematch into other languages.

	As strings are added for each update, they will appear here.

	If you'd like to translate Rematch into another language, that would be
	very much appreciated!

	Take this file and add translations for the text in quotes, then contact
	me via PM to Gello either on wowinterface.com or curse.com. If you're able
	to include the file in the message that'd be a bonus but not necessary.

	(Please make sure to use default game fonts and test to ensure text fits!)

	Thanks!
]]

local _,L = ...
if GetLocale()=="????" then

	-- New or changed strings in 3.1.8:
	L["Without Any 25s"] = "Without Any 25s"
	L["2 Pets"] = "2+ Pets"
	L["3 Pets"] = "3+ Pets"

	-- New or changed strings in 3.1.4:
	L["Only Level 25s"] = "Only Level 25s"
	L["Level 25"] = "Level 25"
	L["Reset filters on login"] = "Reset filters on login"
	L["Reset all pet browser filters (except sort order) when logging in."] = "Reset all pet browser filters (except sort order) when logging in."
	L["Load Filters"] = "Load Filters"
	L["Save Filters"] = "Save Filters"
	L["Do you want to overwrite the existing saved filters?"] = "Do you want to overwrite the existing saved filters?"

	-- New or changed strings in 3.1.3:
	L["This team did not automatically load because you've already auto-loaded a team from where you're standing."] = "This team did not automatically load because you've already auto-loaded a team from where you're standing."
	L["This pet is currently slotted."] = "This pet is currently slotted."

	-- New or changed strings in 3.1.2:

	L["Undo"] = "Undo"
	L["Revert to the last saved notes. Changes are saved when leaving these notes."] = "Revert to the last saved notes. Changes are saved when leaving these notes."
	L["Delete Notes"] = "Delete Notes"

	-- New or changed strings in 3.1.1:

	L["Show notes in battle"] = "Show notes in battle"
	L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] = "If the loaded team has notes, display and lock the notes when you enter a pet battle."
	L["Hide rarity borders"] = "Hide rarity borders"
	L["Hide the colored borders to indicate rarity around current pets and pets on the team cards."] = "Hide the colored borders to indicate rarity around current pets and pets on the team cards."
	L["Discard loaded team on changes"] = "Discard loaded team on changes"
	L["This option changes the normal behavior of Rematch and its interaction with targets. Specifically, any time you change pets or abilities, it will disregard what you have loaded in the past and always offer to load/show teams. Also, it will be very difficult to save changes to teams by targeting. The Reload button will also be disabled. \124cffff2222WARNING!\124cffffd200 This option is not recommended!"] = "This option changes the normal behavior of Rematch and its interaction with targets. Specifically, any time you change pets or abilities, it will disregard what you have loaded in the past and always offer to load/show teams. Also, it will be very difficult to save changes to teams by targeting. The Reload button will also be disabled. \124cffff2222WARNING!\124cffffd200 This option is not recommended!"

	-- New or changed strings in 3.1.0:

	L["List real names"] = "List real names"
	L["Even if a pet has been renamed, list each pet by its real name."] = "Even if a pet has been renamed, list each pet by its real name."
	L["Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."] = "Fill the leveling queue with one of each species that can level from the filtered pet browser, and for which you don't have a level 25 already."
	L["Fill Queue More"] = "Fill Queue More"
	L["Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."] = "Fill the leveling queue with one of each species that can level from the filtered pet browser, regardless whether you have any at level 25 already."
	L["\124cffccccccThere are no notes for this team.\n\nYou can add a note by right-clicking the team in the team tab and choosing Set Notes."] = "\124cffccccccThere are no notes for this team.\n\nYou can add a note by right-clicking the team in the team tab and choosing Set Notes."
	L["Notes for this team:"] = "Notes for this team:"
	L["Set Notes"] = "Set Notes"
	L["Save these notes?"] = "Save these notes?"

-- New or changed strings in 3.0.13:

	L["Reload"] = "Reload"
	L[" \124cffffd200Note:\124r Enabling this option disables the 'Reload' button."] = " \124cffffd200Note:\124r Enabling this option disables the 'Reload' button."

-- New or changed strings in 3.0.11:

	L["Even options"] = "Even options"
	L["Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."] = "Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."
	L["Larger list text"] = "Larger list text"
	L["Make the text in the scrollable lists (pets, teams and options) a little bigger."] = "Make the text in the scrollable lists (pets, teams and options) a little bigger."
	L["Reverse dialog direction"] = "Reverse dialog direction"
	L["When displaying a popup dialog adjacent to the Rematch window, make them appear on the side towards the edge of the screen instead of towards the center."] = "When displaying a popup dialog adjacent to the Rematch window, make them appear on the side towards the edge of the screen instead of towards the center."
	L["In a Team"] = "In a Team"
	L["Not In a Team"] = "Not In a Team"

-- New or changed strings in 3.0.10:

	L["Stay after loading"] = "Stay after loading"
	L["Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."] = "Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."
	L["Show after loading"] = "Show after loading"
	L["When a team is automatically loaded, show the Rematch window if it's not already shown."] = "When a team is automatically loaded, show the Rematch window if it's not already shown."

-- New or changed strings in 3.0.9:

	L["Show dialogs at side"] = "Show dialogs at side"
	L["Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."] = "Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."

-- New or changed strings in 3.0.1 to 3.0.7:

	L["Queued:"] = "Queued:"
	L["When targeting something with a saved team not already loaded, show the Rematch window."] = "When targeting something with a saved team not already loaded, show the Rematch window."
	L["Auto load"] = "Auto load"
	L["When your mouseover or target has a saved team not already loaded, load the team immediately."] = "When your mouseover or target has a saved team not already loaded, load the team immediately."
	L["On target only"] = "On target only"
	L["Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"] = "Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"
	L["Always show or load"] = "Always show or load"
	L["Continue to offer to load (or auto load) teams if any pets or abilities are changed in the loaded team."] = "Continue to offer to load (or auto load) teams if any pets or abilities are changed in the loaded team."
	L["Prevent the Rematch window from being dragged unless Shift is held."] = "Prevent the Rematch window from being dragged unless Shift is held."
	L["Don't warn about missing pets"] = "Don't warn about missing pets"
	L["Don't display a popup when a team loads and a pet within the team can't be found."] = "Don't display a popup when a team loads and a pet within the team can't be found."
	L["Jump to key"] = "Jump to key"
	L["While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."] = "While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."
	L["Pets are missing!"] = "Pets are missing!"
	L["Press CTRL+C to copy this team to the clipboard."] = "Press CTRL+C to copy this team to the clipboard."
	L["Press CTRL+V to paste a team from the clipboard."] = "Press CTRL+V to paste a team from the clipboard."

-- Strings in prior versions:

	-- common.lua
	L["Toggle Window"] = "Toggle Window"
	L["Toggle Auto Load"] = "Toggle Auto Load"
	L["Toggle Pets"] = "Toggle Pets"
	L["Toggle Teams"] = "Toggle Teams"
	L["Toggles the Rematch window to manage battle pets and teams."] = "Toggles the Rematch window to manage battle pets and teams."

	-- main.lua
	L["Import"] = "Import"
	L["Options"] = "Options"
	L["Teams"] = "Teams"
	L["\124cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"] = "\124cffff8800You're in combat. Blizzard has restrictions on what we can do with pets during combat. Try again when you're out of combat. Sorry!"
	L["\124cffffff00Rematch Auto Load is now"] = "\124cffffff00Rematch Auto Load is now"
	L["\124cff00ff00Enabled"] = "\124cff00ff00Enabled"
	L["\124cffff0000Disabled"] = "\124cffff0000Disabled"
	L["Current Battle Pets"] = "Current Battle Pets"
	L["\124cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."] = "\124cffffd200PetBattleTeams is not enabled. Try again when the addon is enabled."

	-- floatingpetcard.lua
	L["Damage Taken"] = "Damage Taken"
	L["from"] = "from"
	L["abilities"] = "abilities"
	L["No breeds known :("] = "No breeds known :("
	L["\124cffddddddPossible level 25 \124cff0070ddRares"] = "\124cffddddddPossible level 25 \124cff0070ddRares"

	-- leveling.lua
	L["Leveling:"] = "Leveling:"
	L["Sort:"] = "Sort:"
	L["This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the current leveling pet.\n\nWhen a team is saved with the current leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."] = "This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the current leveling pet.\n\nWhen a team is saved with the current leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"
	L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t The queue is sorted"] = "\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t The queue is sorted"
	L["This pet is already in the queue.\nPets can't move while the\nqueue is sorted"] = "This pet is already in the queue.\nPets can't move while the\nqueue is sorted"
	L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t The queue is sorted"] = "\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t The queue is sorted"
	L["This pet will be added to the\nend of the unsorted queue."] = "This pet will be added to the\nend of the unsorted queue."
	L["\124cffff8800The current leveling pet is in battle and can't be swapped."] = "\124cffff8800The current leveling pet is in battle and can't be swapped."
	L["Next leveling pet:"] = "Next leveling pet:"

	-- rmf.lua
	L["Empty Slot"] = "Empty Slot"
	L["Choose a name."] = "Choose a name."
	L["Restore original name"] = "Restore original name"
	L["Release this pet?"] = "Release this pet?"
	L["Once released, this pet is gone forever!"] = "Once released, this pet is gone forever!"
	L["Cage this pet?"] = "Cage this pet?"
	L["Current Zone"] = "Current Zone"
	L["Strong Vs"] = "Strong Vs"
	L["Tough Vs"] = "Tough Vs"
	L["Reset All"] = "Reset All"
	L["Use Type Bar"] = "Use Type Bar"
	L["Leveling"] = "Leveling"
	L["Not Leveling"] = "Not Leveling"
	L["Tradable"] = "Tradable"
	L["Not Tradable"] = "Not Tradable"
	L["Can Battle"] = "Can Battle"
	L["Can't Battle"] = "Can't Battle"
	L["1 Pet"] = "1 Pet"
	L["Start Leveling"] = "Start Leveling"
	L["Add to Leveling Queue"] = "Add to Leveling Queue"
	L["Stop Leveling"] = "Stop Leveling"
	L["Put Leveling Pet Here"] = "Put Leveling Pet Here"
	L["Move to Top"] = "Move to Top"
	L["Move Up"] = "Move Up"
	L["Move Down"] = "Move Down"
	L["Move to End"] = "Move to End"
	L["Fill Queue"] = "Fill Queue"
	L["This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"] = "This will add %d pets to the leveling queue.\n%s\nAre you sure you want to fill the leveling queue?"
	L["\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"] = "\nYou can reduce the number of pets by filtering them in Rematch's pet browser\n\nFor instance: search for \"21-24\" and filter Rare only to fill the queue with rares between level 21 and 24.\n"
	L["\nAll species with a pet that can level already have a pet in the queue.\n"] = "\nAll species with a pet that can level already have a pet in the queue.\n"
	L["Empty Queue"] = "Empty Queue"
	L["Are you sure you want to remove all pets from the leveling queue?"] = "Are you sure you want to remove all pets from the leveling queue?"
	L["Queue"] = "Queue"
	L["Sort Order:"] = "Sort Order:"
	L["Ascending"] = "Ascending"
	L["Sort:\124cffffd200Ascending"] = "Sort:\124cffffd200Ascending"
	L["Sort the queue from\nlevel 1 to level 25."] = "Sort the queue from\nlevel 1 to level 25."
	L["Descending"] = "Descending"
	L["Sort:\124cffffd200Descending"] = "Sort:\124cffffd200Descending"
	L["Sort the queue from\nlevel 25 to level 1."] = "Sort the queue from\nlevel 25 to level 1."
	L["Median"] = "Median"
	L["Sort:\124cffffd200Median"] = "Sort:\124cffffd200Median"
	L["Sort the queue for\nlevels closest to 10.5."] = "Sort the queue for\nlevels closest to 10.5."
	L["Auto Rotate"] = "Auto Rotate"
	L["After the leveling pet gains xp:\n\n\124cffffd200Ascending\124cffe6e6e6 and \124cffffd200Median\124cffe6e6e6 sorts will swap\nto the top-most pet in the queue.\n\n\124cffffd200Unsorted\124cffe6e6e6 and \124cffffd200Descending\124cffe6e6e6 sort will\nswap to the next pet in the queue."] = "After the leveling pet gains xp:\n\n\124cffffd200Ascending\124cffe6e6e6 and \124cffffd200Median\124cffe6e6e6 sorts will swap\nto the top-most pet in the queue.\n\n\124cffffd200Unsorted\124cffe6e6e6 and \124cffffd200Descending\124cffe6e6e6 sort will\nswap to the next pet in the queue."
	L["Fill the leveling queue with one of\neach species that can level from\nthe filtered pet browser."] = "Fill the leveling queue with one of\neach species that can level from\nthe filtered pet browser."
	L["Remove all leveling pets\nfrom the queue."] = "Remove all leveling pets\nfrom the queue."
	L["Edit"] = "Edit"
	L["Delete this team?"] = "Delete this team?"
	L["Load"] = "Load"
	L["Load Team"] = "Load Team"
	L["You can double-click\na team to load also."] = "You can double-click\na team to load also."
	L["Rename"] = "Rename"
	L["Move To"] = "Move To"
	L["Send"] = "Send"
	L["Export"] = "Export"
	L["Save To"] = "Save To"

	-- options.lua
	L["Targeting Options"] = "Targeting Options"
	L["Auto show on target"] = "Auto show on target"
	L["Window Options"] = "Window Options"
	L["Larger window"] = "Larger window"
	L["Make the Rematch window larger for easier viewing."] = "Make the Rematch window larger for easier viewing."
	L["Reverse pullout"] = "Reverse pullout"
	L["When the Pets or Teams tab is opened, expand the window down the screen instead of up."] = "When the Pets or Teams tab is opened, expand the window down the screen instead of up."
	L["Lock window position"] = "Lock window position"
	L["Lock window height"] = "Lock window height"
	L["Prevent the window's height from being resized with the resize grip along the bottom of the expanded window."] = "Prevent the window's height from being resized with the resize grip along the bottom of the expanded window."
	L["Disable ESC for window"] = "Disable ESC for window"
	L["Prevent the Rematch window from being dismissed with the Escape key."] = "Prevent the Rematch window from being dismissed with the Escape key."
	L["Disable ESC for drawer"] = "Disable ESC for drawer"
	L["Prevent the pullout drawer from being collapsed with the Escape key."] = "Prevent the pullout drawer from being collapsed with the Escape key."
	L["Stay for pet battle"] = "Stay for pet battle"
	L["When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."] = "When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."
	L["Loading Options"] = "Loading Options"
	L["One-click loading"] = "One-click loading"
	L["When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."] = "When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."
	L["Empty missing pet slots"] = "Empty missing pet slots"
	L["When a team with missing pets loads and a pet is missing, empty the slot the pet would go to instead of ignoring the slot."] = "When a team with missing pets loads and a pet is missing, empty the slot the pet would go to instead of ignoring the slot."
	L["Keep companion"] = "Keep companion"
	L["After a team is loaded, summon back the companion that was at your side before the load."] = "After a team is loaded, summon back the companion that was at your side before the load."
	L["Show on injured"] = "Show on injured"
	L["When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."] = "When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."
	L["Leveling Queue Options"] = "Leveling Queue Options"
	L["Keep current pet on new sort"] = "Keep current pet on new sort"
	L["Do not change the current leveling pet to the top-most pet when choosing a sort order."] = "Do not change the current leveling pet to the top-most pet when choosing a sort order."
	L["Keep sort when emptied"] = "Keep sort when emptied"
	L["When the queue is emptied, preserve the sort order and auto rotate status instead of resetting them."] = "When the queue is emptied, preserve the sort order and auto rotate status instead of resetting them."
	L["Hide pet toast"] = "Hide pet toast"
	L["Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."] = "Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."
	L["Pet Browser Options"] = "Pet Browser Options"
	L["Use type bar"] = "Use type bar"
	L["Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."] = "Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."
	L["Only battle pets"] = "Only battle pets"
	L["Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."] = "Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."
	L["Disable sharing"] = "Disable sharing"
	L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] = "Disable the Send button and also block any incoming pets sent by others. Import and Export still work."
	L["Use Battle.net (beta)"] = "Use Battle.net (beta)"
	L["If both you and the recipient have this option checked, teams can be sent to or from battle.net friends. Note: The recipient needs Rematch 3.0 or greater."] = "If both you and the recipient have this option checked, teams can be sent to or from battle.net friends. Note: The recipient needs Rematch 3.0 or greater."
	L["Hide tooltips"] = "Hide tooltips"
	L["Hide the more common tooltips within Rematch."] = "Hide the more common tooltips within Rematch."
	L["Even alerts"] = "Even alerts"
	L["Also hide tooltips that warn when you can't place a pet somewhere. This is not recommended if you're new to the addon."] = "Also hide tooltips that warn when you can't place a pet somewhere. This is not recommended if you're new to the addon."
	L["Use minimap button"] = "Use minimap button"
	L["Place a button on the minimap to toggle Rematch."] = "Place a button on the minimap to toggle Rematch."
	L["Hide journal button"] = "Hide journal button"
	L["Do not place a Rematch button along the bottom of the default Pet Journal."] = "Do not place a Rematch button along the bottom of the default Pet Journal."
	L["Go to the key binding window to create or change bindings for Rematch."] = "Go to the key binding window to create or change bindings for Rematch."
	L["Import Pet Battle Teams"] = "Import Pet Battle Teams"
	L["Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."] = "Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."
	L["Toggle Rematch"] = "Toggle Rematch"
	L["\124cffffd200%s\124r copied."] = "\124cffffd200%s\124r copied."
	L["\124cffffd200%s\124r not copied. A team of that name already exists."] = "\124cffffd200%s\124r not copied. A team of that name already exists."
	L["Pet Battle Teams Imported"] = "Pet Battle Teams Imported"
	L["Copy again and overwrite?"] = "Copy again and overwrite?"
	L["%d teams copied successfully."] = "%d teams copied successfully."
	L["\n\n%d teams were not copied because teams already exist in Rematch with the same names."] = "\n\n%d teams were not copied because teams already exist in Rematch with the same names."
	L["Pets Tab Closed"] = "Pets Tab Closed"
	L["The pet journal's search box can't be used while the pet tab is open, sorry!"] = "The pet journal's search box can't be used while the pet tab is open, sorry!"

	-- petloading.lua
	L["Loading..."] = "Loading..."

	-- roster.lua
	L["Battle"] = "Battle"
	L["Quantity"] = "Quantity"
	L["Favorite"] = "Favorite"
	L["Zone"] = "Zone"
	L["Filters: \124cffffffff"] = "Filters: \124cffffffff"
	L["Search, "] = "Search, "
	L["Type, "] = "Type, "
	L["Strong, "] = "Strong, "
	L["Tough, "] = "Tough, "
	L["Sources, "] = "Sources, "
	L["Rarity, "] = "Rarity, "
	L["Collected, "] = "Collected, "

	-- save.lua
	L["Save As..."] = "Save As..."
	L["Save this team?"] = "Save this team?"
	L["New Team"] = "New Team"
	L["A team already has this name."] = "A team already has this name."
	L["Overwrite this team?"] = "Overwrite this team?"
	L["Import Team"] = "Import Team"
	L["A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."] = "A team already has this name.\nClick \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t to choose a name."
	L["Import As..."] = "Import As..."
	L["Send this team?"] = "Send this team?"
	L["Who would you like to send this team to?"] = "Who would you like to send this team to?"
	L["Team received!"] = "Team received!"
	L["Sending..."] = "Sending..."
	L["No response. Lag or no Rematch?"] = "No response. Lag or no Rematch?"
	L["They do not appear to be online."] = "They do not appear to be online."
	L["They're busy. Try again later."] = "They're busy. Try again later."
	L["They're in combat. Try again later."] = "They're in combat. Try again later."
	L["They have team sharing disabled."] = "They have team sharing disabled."
	L["Incoming Rematch Team"] = "Incoming Rematch Team"
	L["\124cffffd200%s\124r has sent you a team named \124cffffd200\"%s\"\124r"] = "\124cffffd200%s\124r has sent you a team named \124cffffd200\"%s\"\124r"

	-- teams.lua
	L["New Tab"] = "New Tab"
	L["Create a new tab."] = "Create a new tab."
	L["Choose a name and icon."] = "Choose a name and icon."
	L["Delete this tab?"] = "Delete this tab?"
	L["Teams in this tab will be moved to the General tab."] = "Teams in this tab will be moved to the General tab."
	L["Load this team?"] = "Load this team?"
	L["Rename this team?"] = "Rename this team?"

	-- browser.lua
	L["Strong vs"] = "Strong vs"
	L["Tough vs"] = "Tough vs"
	L["Pets:"] = "Pets:"
	L["Owned:"] = "Owned:"

end