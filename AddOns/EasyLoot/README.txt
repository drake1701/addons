An automatic loot filter.
When enabled and automatic loot is disabled, it automatically loots using a
user defined filter so that only items with a quality/rarity above a certain level
gets looted automatically.

The user can also define exceptions from the general quality rule.
By typing "/el show" you can bring up the UI for adding:
    "AutoLoot" (always loot)
    "Ignore" (never loot)
    "Destroy" (destroy the item once picked up)
    "Need" (automatically roll need)
    "Greed" (automatically rool greed)
Enter the name into the text box at the bottom of the window and press the
add button under the column that you want to put your item into.
You can also shift click an item in your inventory or in AtlasLoot
for example after you have activated the text box to copy the name of the
item automatically.
If you don't click in the text box before you shift click the item the link
will appear in the "default" window (usually chat).
Pressing the button next to the text field will bring up a tool where you
can search your bags for items with names containing a specific text.

Items under "Need" or "Greed" will automatically be removed from the list
if you loot an item with that name. To prevent this to happen click the check
box next to the item name so that you get a small bag icon instead. This will
prevent the item from being removed and you will keep rolling for it until
you manually remove it from the list by clicking on the name or by clicking on
the bag icon and then looting the item.

From version 1.2.0.0 there is a second check box in the greed list which indicates
whether you want to automatically disenchant the item as it gets looted instead of
the normal greed roll.

From version 1.3.0.0 AtlasLoot wishlist can be used for items that you want to
roll need on. Just put the item in the list and the addon with do the rest.
This is an optional dependency so no need to have AtlasLoot installed.

From version 1.5.2.0 you can set the addon to delete grey items that are looted.
This is to help skinners to keep tidy bags and not flood them. When looting a grey
item it will destroy any items with the same itemID (same item) in the inventory.
You will not get a warning when the items are destroyed!

Using the "Greed on"/"Disenchant on" and the drop down will give you the option
to greed or disenchant (de will cause greed if there is not enchanter in the group)
on items of the specified quality or lower.
"Always greed on BoE items" will do just that if checked instead of disenchanting
items that will Bind on Equip.
Setting an item level in the text box marked "Item Level" will cause items that
level or lower to be treated the same way as for matching quality (DE or Greed
depending on your settings).

Other settings include:
    Loot rules settings (when to use the addon depending on the loot rule).
    Enabling/disabling the use of the addon in game.
    Quality/rarity threshold.

The settings can be found in the AddOn tab of the Blizzard Interface Options
or by typing "/el options"

Note: The Need/Greed functionality only works when the default "roll for loot" window
appears. It does not work if the group/raid uses Master Looter.
If a need/greed item is looted by you it will be removed from your need list unless
marked with bag.

NOTE:
You will not get any warnings when you disenchant items! You can see what happens
in the log as usual but you can not undo any disenchanting and the author of this
addon does not take any responsibility for loot getting disenchanted by mistake!