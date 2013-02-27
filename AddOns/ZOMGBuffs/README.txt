ZOMGBuffs
Zek <Bloodhoof-EU>

ZOMGBuffs
All in one buffing mod for all classes. Overview of important raid buffs, and instant access rebuff on right click.

Main Mod
- Responsible for loading class specific modules.
- Has FuBar/Minimap icon for options menu (Sorry, I just don't like Waterfall at all), and info tooltip.
- Single click minimap icon to quickly enable/disable auto-buffing.
- Raid popup list with complete buff overview (just mouseover the floating ZOMG icon).
  + Highlights missing buffs for whole raid at a glance.
  + Shows time remaining on your buffs on whole raid.
  + Allows instant rebuff with Right-Click as assigned by seperately loaded modules, without having to muck around finding the player in the raid frames.
  + Shows in-combat reminder (swirly thing around icon) if someone needs a rebuff mid-fight.
- Auto Buy reagents to defined levels.

ZOMGSelfBuffs
- Handles all self buffing needs including temporary weapon enchants and poisons.
- Can remind you in-combat when something needs rebuffing.
- Special cases to auto buff Crusader Aura for paladins when mounted, and aspect of cheetah for hunters in cities.
ZOMGBuffTehRaid
- Group class buffing module for Mages, Priests, Druids, Shamans and Warlocks.
- Allows you to define which groups you're responsible for.
- Enable or Disable buffs by clicking on the minimap tooltip for that buff.
- Single target (non group buffs) can be enabled on a per-person basis by tickboxes in the raid popup list.
  + Click to toggle one player.
  + Right-Click to toggle everyone.
  + Alt-Click to toggle class.
  + Shift-Click to toggle party.
- Tracking Icon for Fear Ward and Earthen Shield. Showing time left and stack count when applicable, and allowing easy click rebuff.

Common Behaviour for Buffing modules
- Manually casting a buff will be remembered (with a few exceptions which shouldn't) as the new required auto buff.
- Click the tooltip sectoin for that mod will cycle through buffs.
- Shift Clicking the tooltip section for that mod will remove it's entry from the template.
- Template save/load/conditionals.
- Simple mousewheel rebuffing in one common interface.
- Simple Right-Click rebuffing of your defined buffs for whichever module you have loaded
- Definable pre-expiry rebuff setting.
- Options to auto-learn in or out of combat. Auto learn means that if you cast a spell, then it'll assume you want this from now on and rebuff as needed.
- Options to not buff when:
  + Not everyone in raid is present (definable to a % of people present).
  + Not everyone in a party is present.
  + You are resting.
  + You are low on mana.
  + You have the Spirit Tap buff (geiv mana regen!).
  + You are stealthed.
  + You are shapeshifted.
