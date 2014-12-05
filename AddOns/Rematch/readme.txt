Rematch is a pet journal alternative to help manage battle pet teams and pets.

Its primary purpose is to store and recall battle pet teams for targets. For instance:

- When you target Aki the Chosen, bring up the Rematch window and hit Save, you can save in her name the pets you have out.
- When you return to Aki another day, you can target her, bring up the window and it will offer you those saved pets to load.

New in 3.1.8

- Fixed a bug where renaming a team will delete its notes.
- Pet filter by quantity now filters for 1, 2+ or 3+ Pets instead of 1, 2 or 3 Pets.
- Leveling queue right-click menu items "Move to Top" and "Move to End" will dismiss menu.
- Pet filter menu items "Load Filters" and "Save Filters" will dismiss menu.
- When searching stats, you can abbreviate Health, Power, Speed and Level as H, P, S and L respectively. ie L<25 or s>300.
- New pet filter "Without Any 25s" under Miscellaneous to filter to all pets without a level 25 variant.
- Old pet filter "Only Level 25s" moved to Miscellaneous and paired with new "Without Any 25s".

How to Use

You can summon the Rematch window several ways:
- Set a key binding from options.
- /rematch command.
- The Rematch button at the bottom of the pet journal.
- 'Use Minimap Button' in options will create a minimap button.
- From its LDB button if you use a Broker infobar addon.
- Have 'Auto Show' checked in options and target something for which you have a saved team that's not already loaded.

Saving a Team

As mentioned at the top, this addon's primary purpose is to save for targets. Target an NPC, click Save, and you will be prompted to save in their name.

If you choose to keep the target's name for the team, then you'll be offered that team to load when you return to it another day.  Within options you can choose to make Rematch automatically pop up when you return to that target, or you can make the team load immediately without messing around with the addon at all.

When a team is saved with an NPC targeted, or when saving over an existing team that was initially created at the target, the team's name will be white and it will react only to that specific instance of the NPC.

If you manually name a team named after an NPC without it targeted, or you got the team from elsewhere without targeting information saved, its name will be gold and it will react to any copies of that NPC you run across in the world.

You're also free to save without regard for target.  Name your team anything you want and you can return to the teams tab later to load it back from the Teams tab.

Teams

When teams are saved, they're stored in the Teams tab.
- To load a team manually, double click it.
- You can create up to 15 additional tabs in addition to the default General team tab.
- When a team is saved, it will go to the current tab. You can change the current tab while saving at the bottom of the save dialog.
- All team names are unique, even across tabs. If you have "Aki the Chosen" in a tab named "Dailies", and you save "Aki the Chosen" in General, it will move that team to General and save it there.
- Right-click a tab to change its name or icon, delete it or re-order tabs if you've created more than one.
- When a tab is deleted, all teams within the tab are moved to the General tab.
- You can right-click a team to do various things as well, such as renaming, deleting, sharing it or attaching a note.
- You can bind a key to open the Teams tab directly.
- Searches in the team searchbox will look for matches in team names, team notes and any pet names.

Pets

The Pets tab contains a pet browser and a leveling queue.

Just about anyplace you see a pet, you can double-click it to summon the pet, or dismiss it if it was already out.

The "tooltip" for pets is a pet card with stats:
- Hold Alt to flip the card over for more about your pet.
- Click the pet to lock the card in place so you can mouseover abilities.
- When the card is locked it has a wooden frame around it. You can unlock it several ways: clicking one of the little screws in a corner, clicking the pet again from where you locked it, hitting ESCape or any other major interaction with the addon.
- You can shift+click pets and abilities to chat.

Some advantages the built-in pet browser has over the default pet journal:
- You can search the names of abilities or text within abilities.
- You can search for level and stat ranges.
- In addition to filtering pets by type, you can filter by 'Strong vs': if you filter Strong vs Dragonkin, it will list all pets with Magic attacks.
- You can also filter to pets that are Tough vs a type of attack: filtering Tough vs Elemental will list all critters.
- A 'Type Bar' to filter by the various types without going through the dropdown menus.
- A counter at the bottom of the browser tells you how many pets are listed: search level=25 and you'll see how many level 25 pets you own.

To clear filters, you can click the little X button in the search box or the type bar, or you can click the X along the bottom when filters are applied.  You can also click 'Reset All' within the filters menu.

Searches

In the search bar of the pet browser, you can not only search for names of pets and their source, but you can also search for:

- Names of abilities ("Call Lightning")
- Text within abilities ("Bleed")
- Level ranges ("level=25" or "level>10" or "level=8-13")
- Stat ranges ("health>700" or "speed=250-350" or "power>=276")

Also:

- Searches are not case sensitive. "Bleed" will work just as well as "bleed" or "BLEED".
- You can hit "Fill" on the leveling queue to add one of each species from your search results to the leveling queue.
- When you look at the pet card, abilities that contain the search text will be marked with a gold ring.
- You can also search levels, stats and text simultaneously:
"bleed health>700 level<25" : Pets with Bleed in text that have over 700hp and are under 25.
"level<25 bleed health>700" : Same thing. The order of search isn't important.
"health>700 <25 bleed" : Same again. If a stat doesn't appear with a < > or =, it assumes level.

Leveling Pets

Thanks to suggestions from Behub, Aloek and others, Rematch has a robust system to make leveling pets easy.

In the Pets tab there is a leveling slot with a shiny gold border. You can drag a pet here to mark it as your leveling pet. (You can also right-click a pet elsewhere like in the journal and choose 'Start Leveling')

- Any teams saved with a leveling pet will reserve that pet's slot for future leveling pets.
- When you see a shiny gold border around a pet anywhere in Rematch, it means that is a leveling pet.

So if you save teams for various tamers with the leveling pet loaded, when you return to those tamers later with a different leveling pet, it will load that new leveling pet in their saved places.

The Leveling Queue

In addition to the gold-bordered leveling slot, there is a leveling queue you can store any number of pets that you intend to level.

As soon as your current leveling pet reaches 25 (grats!), if there are any leveling pets waiting it will swap the top-most pet in the queue to the leveling slot.

From the gear button to the right of the leveling slot you can:
- Sort the queue by level: Ascending (level 1 to 25), Descending (25 to 1) or Median (closest to level 10.5).
- Create your own order by dragging pets around and inserting them between other pets, or by right-clicking a pet and choosing the move options.
- Use the Auto Rotate option to move to a new pet in the queue after each successful pet battle.
- Fill the queue from pets in the browser. For instance, search "21-24", filter for Rare and hit Fill to add 21-24 rare pets to the leveling queue.
- Empty the queue. It will ask for confirmation before clearing the queue.
- If you want to switch to another pet for one fight without changing the order, double-click the pet in the queue.  You can drag it to the leveling slot or right-click the pet and choose Start Leveling.
- If the current leveling pet is loaded, you can navigate around the queue with previous/next buttons when you mouseover the leveling pet.

Sharing Teams

There are two ways to share battle pet teams when you right-click it in the Teams tab:

Send will send a team to someone online on your faction.
- When a user receives a team that you Send, they'll receive a popup displaying the team with the option to save it.  If they're in combat or they have another team waiting (or a similar dialog up) it will inform you that they're busy and you should try again later.
- To send a team cross-realm, include their name, such as Gello-Hyjal.
- In options you can choose to block incoming pets if you'd like.

Export will create a WeakAuras-like text string that you can copy to the clipboard.
- You can paste the team anywhere else: in an email, on forums, in a text file, etc.
- Any other Rematch user can use this string to Import the same team. The Import button is in the bottomright of the main window.

If you receive or import a team that includes pets you don't have, that's fine. They'll be greyed out and only the pets you have will attempt to load. You can keep the team as is for the day when you get the pet, or you can choose to save over it if you find a suitable substitute for the missing pet.

Note: Battle.net and RealID are not totally supported yet. At present there's a test mode you can try if you'd like.  If both you and your battle.net friend have the option enabled, it will attempt to send via the team via battle.net.

Other addons

A major goal with this addon was to make it behave well regardless of what other battle pet addons you're using.

In some cases, it even takes advantage of the awesome addons others have created. For instance:
- If you have the addon Battle Pet Breed ID enabled, pets will display breed information. If you click a pet and mouseover its stats, you can see all possible breeds for the pet.
- If you have the addon Pet Battle Teams enabled, there will be a button at the end of options to import your teams from PBT.
- If you choose to continue using PBT alongside Rematch (many do!), make sure you lock your PBT teams or auto save in PBT is disabled. The default behavior of PBT is to change the pets in your currently-selected team to whatever is loaded.
ogether if you choose.
- If you have a Broker infobar addon, it will create a button on your bars to toggle Rematch.

Future plans

With Warlords of Draenor going live, my addon-writing time will have to compete with my WoW-playing time, but there are still plans for this addon.  They're loosely grouped into three priorities:

Short term:
- Set a minimum health and maximum xp for teams with a leveling pet.  So that teams will pull a different pet from the queue (if any available) when the current leveling pet doesn't meet the criterea.
- Support multiple leveling pets. When saving a team any pet in the queue will mark the slot as a leveling slot. When loading a team with multiple leveling pets it will pull as many pets as needed.
- Look for multiple sources for breed data.

Mid term:
- Custom sorting: by power, speed, favorites mixed with rest, reverse sort, etc.
- An alternate view of current pets that stacks them vertically.
- Pet Treat, Lesser Pet Treat and Safari Hat buttons in the alternate view, with cooldown spinners on the treats to tell how much time is left on the buff.
- Mass Export/Import of teams.
- Some alternate method of tagging pets. A "second" favorites at least.

Long term:
- Allow the window to be resized horizontally the way it can be resized vertically now.
- Rework the pet card to get more information on the card, such as breeds owned.
- Understudy pet slot on the pet card for loading an alternate pet if that pet is dead or injured.
- Possibly some method of choosing alternate teams if the saved team has dead or injured pets.
- Re-evaluate UI. The small square buttons could afford to be wider.

If you have any comments, suggestions or bugs to report feel free to post them here in the comments. Thanks!

Special thanks to those providing translations to other clients!
deDE: Tonyleila at wowinterface (Leilameda at EU-Anetheron)
zhCN: Zkpjy at wowinterface
zhTW: Leg883 at curse
esES and esMX: Phanx at curse
