Livestock - Commands, Preferences, and General Questions

How Livestock Works:

	Livestock lets you create lists of land mounts, flying mounts, and vanity pets (also called non-combat pets, or critters) and provides
	several ways to let you randomly summon one of the list.  There are also ways to tailor the circumstances for summoning, such as always
	summoning a certain mount or pet in a certain zone or always having a specific pet out, regardless of the zone.

	Livestock has four summoning commands:
		- Summon a vanity pet from your list
		- Summon a land mount from your list
		- Summon a flying mount from your list
		- Summon a smart mount, which will select a random land mount in areas where you cannot fly and a flying mount otherwise.

	If you are mounted, using any of the "mount" commands will dismount you.

	For classes that have other travel options, such as Druids' Flight Form, Hunters' Aspect of the Cheetah, and Shamans' Ghost Wolf, Livestock's
	Smart Mount can be configured to give access to those spells as well in certain circumstances.  See the "Options and Preferences" section
	below, under Travel and Mounts, for more details.

Starting Out:  Building your Lists

	Type /livestock to bring up the menu frame.  There are three buttons which correspond to your learned pets, flying mounts, and land mounts.
	Clicking each menu button brings up a menu with the list of learned mounts or pets.  By default, all are selected.  When you activate one of
	Livestock's summons, it will choose one of the selected mounts or pets and summon it for you.  To remove an item from the list, click it and it
	will turn gray.

	You can see what your pet or mount looks like by selecting the check box on the right hand side of the main menu.  The slider underneath the 3D
	model controls the rotation speed of your pet / mount so you can view it from all angles.  Please note that excessive rotation speeds will not be
	tolerated.

	For pets, you can also designate a favorite by right-clicking its name in the menu.  If you have selected a favorite pet, it will always
	be selected when your pet auto-summons (see below under Options and Preferences), regardless of what other pets might be selected.

Using Livestock:  Controlling your Summons

	Livestock provides three main ways to activate the four summoning commands.

	Keybinding:

		Open the Blizzard keybind interface by hitting Escape, selecting Key Bindings, and scrolling down until you see Livestock Summons.  There,
		you can select keys to activate the four main summon commands, as well as additional ones to dismiss your pet and select your favorite pet.

	Buttons:
		
		Livestock provides four buttons to click on for summoning a land mount, flying mount, smart mount, or pet.  They are disabled by default,
		but can be enabled by bringing up the Livestock Options (/livestock prefs) and checking the appropriate boxes under Show / Hide Buttons.

		The buttons can be moved by holding down Shift, Ctrl, or Alt and dragging them somewhere else.  /livestock reset will put them back where
		they started.  You can change the size of the buttons by using /livestock scale <scale>, which will adjust the size AND position of the
		buttons.  Tip: select the size first, then move them.

		For the pet button, right clicking will dismiss your pet and left clicking will summon it.

	Macros:

		** IF YOU ARE CREATING A LIVESTOCK MACRO, MAKE SURE TO CLOSE YOUR MACRO WINDOW BEFORE PROCEEDING! **

		For those who prefer to use action bars, Livestock will create macros for you to place on your bars.  Open the main menu (/livestock prefs)
		and click the macro for the desired summon.  It will be created in your character-specific macro spots.  Make sure you have an open slot
		before you click these!

		The macros don't have icons attached, and will show up as the red ? icon, but you can easily adjust them to have a representative pet or mount.
		Simply insert an empty line at the beginning of the macro, and put "#showtooltip XXXXX" as the first line.  Remove the quotes first, and change
		XXXXX to be the name of the pet or mount whose icon you want to see.

		For the pet macro, right clicking the macro will dismiss your pet and left clicking will summon it.

		To have a macro that summons your favorite pet, you can use "/run Livestock.SummonFavoritePet()" without quotes in a macro of your choosing.

		(Advanced macro writers:  The macros work by issuing click commands to the buttons, which activate even if they're hidden.  This means you can
		use conditionals such as [mounted], [combat], and [btn] to create various conditions for your usage.)

Fine-tuning Livestock:  Options and Preferences

	Livestock has many options for adjusting its behavior to your liking.  There are four categories of options: display / interface options, pet options,
	travel / mount options, and zone / subzone options.  (The zone / subzone options may be accessed through slash commands as well: see "Slash Commands"
	for more information.)

	Display / Interface Options:  Reach these by typing /livestock prefs, or by selecting Livestock under the AddOns list of the Interface options
	menu.  The options to show / hide the Livestock buttons are here, as well as to create Livestock Macros.  Finally, there are filters to adjust whether
	or not the Livestock dropdown lists contain your slow (non-epic) land and flying mounts.  If you un-select these, the names will disappear and the
	mounts will be unselected from your lists.

	Vanity Pets:  These options relate to Livestock's ability to summon a pet when you move (i.e. always have a pet out).  You must check the first option
	to access most of the other options.  Some of the options may not be available to your race and class -- for example, only Night Elves, Hunters, Mages,
	Rogues, and Druids can access the option involving Stealth / Feign Death / Invisibility.

	Travel and Mounts:  These options relate to Livestock's ability to get you onto a mount.  Some of them place restrictions on when Livestock can and
	cannot mount or dismount you, while others provide options for certain classes to expand what can be done with Smart Mounting.

	** For an in-depth explanation of the preferences, visit http://recompense.wowinterface.com/portal.php?id=474&a=faq&faqid=344 **

	Zones and Subzones:  These options let you control what pet you will automatically summon in specific zones or subzones.  You can also control what
	mount is summoned for you when you use the SmartMount feature.  To designate a pet or mount for a specific zone or subzone, drag it from your Companion
	window (usually keybound to Shift-P) to the desired box.  To erase a saved pet or mount, follow the directions on the options screen.

Slash Commands for Livestock

	There are a few slash commands for Livestock, and are listed below. /livestock and /ls both work for commands.

	"/livestock" - This will bring up the menu bar containing the Livestock dropdown lists for mounts and pets as well as the 3D viewer.

	"/livestock prefs" - This will bring up the menu in the Interface Options containing the main preferences and settings for the addon.

	"/livestock scale <scale>" - This is used to set the scale of the Livestock Buttons, if used.  Replace <scale> with a number, but be warned that
	large numbers (larger than 2.0) may scale off of your screen before you can move them.

	"/livestock reset" - Moves the Livestock buttons back to the middle of the screen if you lose them.

	"/livestock <'zone' / 'subzone'> <[itemLink] / [name] / nopet / whatpet / nomount / whatmount>" - This is the non-graphical interface for designating pets and
	mounts to be used in specific zones or subzones. Note that this *will* override favorite pets if you're in a zone with a designated pet.  The pets
	portion	works only if you've selected the option to automatically summon a pet when you move.  (To use the graphical interface, type /livestock prefs,
	expand the options menu by clicking on the "+" button, and click on Zones and Subzones.)

		The first argument is either "zone" or "subzone" and designates whether you are changing / viewing the pet or mount for the zone or subzone that
		you're in.

		The second argument can either be an itemLink (or text in brackets) of one of your learned pets or mounts or one of the words "nopet", "nomount", "whichpet", or
		"whichmount".  If it is an itemLink (or text), then Livestock will designate that pet or mount for the zone or suzone you're in, depending on the first
		argument.  If it's "nomount" or "nopet", it will clear out the designated pet or mount for the zone.  "whichpet" and "whichmount" display the
		stored pet or mount for that zone.

		Example:  While standing in Orgrimmar, "/livestock zone [Brown Snake]" will set the Brown Snake to be used whenever you don't have a pet out in
		Orgrimmar.  When in the Violet Hold subzone of Dalaran, "/livestock subzone whichmount" will tell you what mount you've told Livestock to use in
		the Violet Hold subzone of Dalaran.

		Subzones take priorities over zones.  This lets you, for example, specify a land mount to use in Dalaran but a flying mount to use specifically
		in the subzone of Krasus's Landing.

	"/livestock mount/nomount/pet/nopet" - This will add or remove pets and mounts from the list of possible random summons. The pet or mount needs to be
	summoned when you issue the command.
	
	"/livestock redo" - Sometimes Livestock starts behaving funny and summoning mounts you haven't checked in your list.  When this happens, it's a bug.
	The fastest way to eliminate the issue is to use the "/livestock redo" command.  This resets everything back to default, so you have to reset your
	settings and select your mounts again, but usually resolves the problem.  (This is a sloppy fix for a bug that I still can't find quite yet.)
	
	"/livestock debug" - Prints out useful debugging information that can assist the developers in solving problems. Use the command again to turn off
	the debugging output.
	
