LIVESTOCK_INTERFACE_SLASHSTRING = "/livestock"
LIVESTOCK_INTERFACE_SLASHSTRING_SHORT = "/ls"

LIVESTOCK_HEADER = "|cFF4444DDLivestock:|r "

LivestockLocalizations = {}

local L = LivestockLocalizations

L.LIVESTOCK_FONTSTRING_LIVESTOCKMENU = "Livestock Menu"
L.LIVESTOCK_FONTSTRING_3DLABEL = "3D Model"
L.LIVESTOCK_FONTSTRING_BUTTONSTOGGLETITLE = "Show / Hide Buttons"
L.LIVESTOCK_FONTSTRING_MACROBUTTONTITLE = "Livestock Macro Generator"
L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL = "Critters"
L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL = "Land"
L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL = "Flying"
L.LIVESTOCK_FONTSTRING_SHOWWATERLABEL = "Water"
L.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL = "Smart"
L.LIVESTOCK_FONTSTRING_MACROBUTTONSTITLE = "Please read the documentation before clicking these buttons!"
L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVELABEL = "Automatically summon a vanity pet when you move."
L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVEFAVELABEL = "Summon your favorite pet instead of a random pet."
L.LIVESTOCK_FONTSTRING_RESTRICTAUTOSUMMONLABEL = "Do not automatically summon a pet if you are flagged for PVP."
L.LIVESTOCK_FONTSTRING_IGNOREPVPRESTRICTIONININSTANCESLABEL = "...unless you are in a PVE instance."
L.LIVESTOCK_FONTSTRING_DONOTRAIDSUMMONLABEL = "Do not automatically summon a pet if you are in a raid or group."
L.LIVESTOCK_FONTSTRING_DISMISSPETONMOUNTLABEL = "Dismiss your pet whenever you mount a flying mount, cast a flying form or enter a vehicle."
L.LIVESTOCK_FONTSTRING_CYCLETIMERTOGGLELABEL = "Automatically change your pet after                             seconds."
L.LIVESTOCK_FONTSTRING_DRUIDTOGGLELABEL = "Enable Flight Form behavior in flying areas."
L.LIVESTOCK_FONTSTRING_TRAVELFORMLABEL = "Enable Travel Form behavior in land areas."
L.LIVESTOCK_FONTSTRING_WORGENTOGGLELABEL = "Enable Running Wild behavior with Smart Mounting."
L.LIVESTOCK_FONTSTRING_SAFEFLIGHTLABEL = "Safe Flight: Mounting while in the air will not dismount you."
L.LIVESTOCK_FONTSTRING_AUTODISMISSONSTEALTHLABEL = "Dismiss your vanity pet when you Stealth, Feign Death, or cast Invisibility."
L.LIVESTOCK_FONTSTRING_PVPDISMISSLABEL = "Only dismiss when you are flagged for PVP."
L.LIVESTOCK_FONTSTRING_MOUNTINSTEALTHLABEL = "Allow Livestock mounting to break Stealth effects."
L.LIVESTOCK_FONTSTRING_USECOMBATFORMSLABEL = "Smart Mounting casts Ghost Wolf / Travel Form in combat."
L.LIVESTOCK_FONTSTRING_USEMOVINGFORMSLABEL = "Smart Mounting casts Ghost Wolf / Travel Form while moving (out of combat)."
L.LIVESTOCK_FONTSTRING_SMARTCATFORMLABEL = "Smart Mounting shifts you from caster form into Cat Form indoors."
L.LIVESTOCK_FONTSTRING_WATERWALKINGLABEL = "Smart Mounting casts %s when underwater."
L.LIVESTOCK_FONTSTRING_INDOORHUNTERASPECTSLABEL = "Smart Mounting casts AotC / AotP when indoors."
L.LIVESTOCK_FONTSTRING_MOVINGHUNTERASPECTSLABEL = "Smart Mounting casts AotC / AotP when moving (outdoors, out of combat)."
L.LIVESTOCK_FONTSTRING_GROUPHUNTERASPECTSLABEL = "Smart Mounting casts AotC (instead of AotP) in a group."
L.LIVESTOCK_FONTSTRING_MOUNTHUNTERASPECTSLABEL = "Smart Mounting cancels AotC / AotP when mounting."
L.LIVESTOCK_FONTSTRING_SLOWFALLLABEL = "Smart Mounting casts Levitate / Slow Fall when falling (out of combat)."
L.LIVESTOCK_FONTSTRING_MOONKINLABEL = "Cast Moonkin Form when dismounting from Flight Form or Travel Form (balance druids)."
L.LIVESTOCK_FONTSTRING_NEWPETLABEL = "New companion pets are disabled by default."
L.LIVESTOCK_FONTSTRING_NEWMOUNTLABEL = "New mounts are disabled by default."
L.LIVESTOCK_FONTSTRING_WATERSTRIDERLABEL = "Use Azure Water Strider on water if you can't fly."
L.LIVESTOCK_FONTSTRING_WATERSTRIDER2LABEL = "Use Azure Water Strider while underwater."
L.LIVESTOCK_FONTSTRING_ZENFLIGHTLABEL = "Smart Mounting casts Zen Flight when moving (outdoors, out of combat)."
L.LIVESTOCK_FONTSTRING_FLYLANDLABEL = "Include flying mounts in the land mount menu."
L.LIVESTOCK_FONTSTRING_NAGRANDLABEL = "Use Garrison Mounts when in Nagrand zone."

L.LIVESTOCK_MENU_MORE = "More   >>>"
L.LIVESTOCK_MENU_SELECTALL = "Select all"
L.LIVESTOCK_MENU_SELECTNONE = "Select none"

L.LIVESTOCK_ZONE_WINTERGRASP = "Wintergrasp"

L.LIVESTOCK_SPELL_EXPERTRIDING = GetSpellInfo(34090)		-- "Expert Riding"
L.LIVESTOCK_SPELL_ARTISANRIDING = GetSpellInfo(34091)		-- "Artisan Riding"
L.LIVESTOCK_SPELL_MASTERRIDING = GetSpellInfo(90265)		-- "Master Riding"
L.LIVESTOCK_SPELL_COLDWEATHER = GetSpellInfo(54197)		-- "Cold Weather Flying"
L.LIVESTOCK_SPELL_FLIGHTMASTER = GetSpellInfo(90267)		-- "Flight Master's License"
L.LIVESTOCK_SPELL_WISDOMWINDS = GetSpellInfo(115913)		-- "Wisdom of the Four Winds"

L.LIVESTOCK_SPELL_TRAVELFORM = GetSpellInfo(783)			-- "Travel Form"
L.LIVESTOCK_SPELL_FLIGHTFORM = GetSpellInfo(165962)		-- "Flight Form"
L.LIVESTOCK_SPELL_BEARFORM = GetSpellInfo(5487)			-- "Bear Form"
L.LIVESTOCK_SPELL_CATFORM = GetSpellInfo(768)			-- "Cat Form"
L.LIVESTOCK_SPELL_TREEOFLIFE = GetSpellInfo(33891)		-- "Tree of Life"
L.LIVESTOCK_SPELL_MOONKINFORM = GetSpellInfo(24858)		-- "Moonkin Form"
L.LIVESTOCK_SPELL_GHOSTWOLF = GetSpellInfo(2645)			-- "Ghost Wolf"
L.LIVESTOCK_SPELL_STEALTH = GetSpellInfo(1784)			-- "Stealth"
L.LIVESTOCK_SPELL_FEIGNDEATH = GetSpellInfo(5384)			-- "Feign Death"
L.LIVESTOCK_SPELL_CHEETAH = GetSpellInfo(5118)			-- "Aspect of the Cheetah"
L.LIVESTOCK_SPELL_PACK = GetSpellInfo(13159)				-- "Aspect of the Pack"
L.LIVESTOCK_SPELL_INVISIBILITY = GetSpellInfo(66)			-- "Invisibility"
L.LIVESTOCK_SPELL_VANISH = GetSpellInfo(1856)			-- "Vanish"
L.LIVESTOCK_SPELL_CLOAKING = GetSpellInfo(4079)			-- "Cloaking"
L.LIVESTOCK_SPELL_PROWL = GetSpellInfo(5215)				-- "Prowl"
L.LIVESTOCK_SPELL_SHADOWMELD = GetSpellInfo(58984)		-- "Shadowmeld"
L.LIVESTOCK_SPELL_WATERWALKING = GetSpellInfo(546)		-- "Water Walking"
L.LIVESTOCK_SPELL_LEVITATE = GetSpellInfo(1706)			-- "Levitate"
L.LIVESTOCK_SPELL_SLOWFALL = GetSpellInfo(130)			-- "Slow Fall"
L.LIVESTOCK_SPELL_PATHOFFROST = GetSpellInfo(3714)		-- "Path of Frost"
L.LIVESTOCK_SPELL_FOOD = GetSpellInfo(108030)			-- "Food"
L.LIVESTOCK_SPELL_DRINK = GetSpellInfo(430)				-- "Drink"
L.LIVESTOCK_SPELL_HAUNTED = GetSpellInfo(101168)			-- "Haunted"
L.LIVESTOCK_SPELL_TWILIGHTSERPENT = GetSpellInfo(56184)	-- "Twilight Serpent"
L.LIVESTOCK_SPELL_SAPPHIREOWL = GetSpellInfo(56186)		-- "Sapphire Owl"
L.LIVESTOCK_SPELL_RUBYHARE = GetSpellInfo(56121)			-- "Ruby Hare"
L.LIVESTOCK_SPELL_RUNNINGWILD = GetSpellInfo(87840)		-- "Running Wild"
L.LIVESTOCK_SPELL_SEALEGS = GetSpellInfo(76377)			-- "Sea Legs"
L.LIVESTOCK_SPELL_CAMOUFLAGE = GetSpellInfo(51753)		-- "Camouflage"
L.LIVESTOCK_SPELL_ZENFLIGHT = GetSpellInfo(125883)		-- "Zen Flight"

L.LIVESTOCK_SKILL_TAILOR = GetSpellInfo(3908)			-- "Tailoring"
L.LIVESTOCK_SKILL_ENGR = GetSpellInfo(4036)				-- "Engineering"
L.LIVESTOCK_SKILL_LW = GetSpellInfo(2108)				-- "Leatherworking"

L.LIVESTOCK_TOOLTIP_VERY = "very"
L.LIVESTOCK_TOOLTIP_EXTREMELY = "extremely"
L.LIVESTOCK_TOOLTIP_FAST = "fast"
L.LIVESTOCK_TOOLTIP_LOCATION = "location"
L.LIVESTOCK_TOOLTIP_CHANGES = "changes"
L.LIVESTOCK_TOOLTIP_NORTHREND = "Northrend"
L.LIVESTOCK_TOOLTIP_OUTLAND = "Outland"

L.LIVESTOCK_INTERFACE_CRITTERMACROCREATED = LIVESTOCK_HEADER.."Random critter summon macro created in character specific macros!"
L.LIVESTOCK_INTERFACE_LANDMACROCREATED = LIVESTOCK_HEADER.."Random land mount summon macro created in character specific macros!"
L.LIVESTOCK_INTERFACE_FLYINGMACROCREATED = LIVESTOCK_HEADER.."Random flying mount summon macro created in character specific macros!"
L.LIVESTOCK_INTERFACE_SMARTMACROCREATED = LIVESTOCK_HEADER.."Random flying/land mount smart summon macro created in character specific macros!"
L.LIVESTOCK_INTERFACE_NOCRITTERSCHECKED = LIVESTOCK_HEADER.."There are no critters in your list.  Please type "..LIVESTOCK_INTERFACE_SLASHSTRING.." and click on the Critters button to select your checklist."
L.LIVESTOCK_INTERFACE_NOLANDMOUNTSCHECKED = LIVESTOCK_HEADER.."There are no land mounts in your list.  Please type "..LIVESTOCK_INTERFACE_SLASHSTRING.." and click on the Land Mounts button to select your checklist."
L.LIVESTOCK_INTERFACE_NOFLYINGMOUNTSCHECKED = LIVESTOCK_HEADER.."There are no flying mounts in your list.  Please type "..LIVESTOCK_INTERFACE_SLASHSTRING.." and click on the Flying Mounts button to select your checklist."
L.LIVESTOCK_INTERFACE_RESETSAVEDDATA = LIVESTOCK_HEADER.."Saved data cleared and menus rewritten.  You should go through your vanity pet and mount menus to uncheck the companions you do not want summoned."
L.LIVESTOCK_INTERFACE_NOFAVEPET = LIVESTOCK_HEADER.."You haven't selected a favorite pet yet!  Right-click a pet in the pet dropdown menu to set it as your favorite."
L.LIVESTOCK_INTERFACE_LISTFAVEPET = LIVESTOCK_HEADER.."Your favorite pet is currently %s."
L.LIVESTOCK_INTERFACE_HAVENOTLEARNED = LIVESTOCK_HEADER.."You have not learned %s yet."
L.LIVESTOCK_INTERFACE_USEITEMLINK = LIVESTOCK_HEADER.."Please use "..LIVESTOCK_INTERFACE_SLASHSTRING.." [zone/subzone] <itemlink> to add your mount or pet for this area.  To delete a saved pet or mount, use /livestock [zone/subzone] [nopet/nomount].  To view your current pet or mount, use /livestock [zone/subzone] [whatpet/whatmount] or use Livestock's Zones and Subzones user interface through /livestock prefs"
L.LIVESTOCK_INTERFACE_CONFIRMZONEADD = LIVESTOCK_HEADER.."You will now summon %s for your %s in the %s %s."
L.LIVESTOCK_INTERFACE_CONFIRMZONEREMOVE = LIVESTOCK_HEADER.."You no longer have a %s selected for the %s %s."
L.LIVESTOCK_INTERFACE_DISPLAYZONEPET = LIVESTOCK_HEADER.."You have selected %s for your %s in the %s %s."
L.LIVESTOCK_INTERFACE_NOZONEPET = LIVESTOCK_HEADER.."You have not selected a %s for the %s %s."
L.LIVESTOCK_INTERFACE_ZONEFRAMEHEADER = "Zone and Subzone Pets and Mounts"
L.LIVESTOCK_INTERFACE_CURRENTZONE = "|cFFEEEE00Current Zone:|r                   %s"
L.LIVESTOCK_INTERFACE_CURRENTSUBZONE = "|cFFEEEE00Current Subzone:|r               %s"
L.LIVESTOCK_INTERFACE_CURRENTZONEPET = "|cFFEEEE00Current Zone Pet:|r             %s"
L.LIVESTOCK_INTERFACE_CURRENTSUBZONEPET = "|cFFEEEE00Current Subzone Pet:|r         %s"
L.LIVESTOCK_INTERFACE_CURRENTZONEMOUNT = "|cFFEEEE00Current Zone Mount:|r        %s"
L.LIVESTOCK_INTERFACE_CURRENTSUBZONEMOUNT = "|cFFEEEE00Current Subzone Mount:|r    %s"
L.LIVESTOCK_INTERFACE_NOPETSELECTED = "No pet currently selected."
L.LIVESTOCK_INTERFACE_NOMOUNTSELECTED = "No mount currently selected."
L.LIVESTOCK_INTERFACE_DRAGERROR = LIVESTOCK_HEADER.."You can only drag pets and mounts to this box."
L.LIVESTOCK_INTERFACE_MOUNTERROR = LIVESTOCK_HEADER.."Dragging mounts into the zone screen is currently broken. Please use the command line to set zone mounts."
L.LIVESTOCK_INTERFACE_DRAGBOXEXPL = "Drag a pet or mount to this box to set it as your desired companion\nfor the current %s. Right-click the box to erase your saved pet\nsetting; left-click to erase your saved mount setting."
L.LIVESTOCK_INTERFACE_LAUNCHWEIGHTS = "Open the Weighted Random Mounts interface"
L.LIVESTOCK_INTERFACE_USEWEIGHTS = "Use weights for random mounts with Smart Mounting."

L.LIVESTOCK_INTERFACE_CONFIRMREMOVE = LIVESTOCK_HEADER.."%s will no longer be summoned."
L.LIVESTOCK_INTERFACE_CONFIRMADD = LIVESTOCK_HEADER.."%s will be summoned."
L.LIVESTOCK_INTERFACE_NOPET = LIVESTOCK_HEADER.."No pet is currently summoned."
L.LIVESTOCK_INTERFACE_NOMOUNT = LIVESTOCK_HEADER.."No mount is currently summoned."
L.LIVESTOCK_INTERFACE_UNKNOWN = LIVESTOCK_HEADER.."Unknown mount type. Please report to Livestock developer.\nMount name: %s, Mount type: %s"
L.LIVESTOCK_INTERFACE_ADD = LIVESTOCK_HEADER.."%s has been added."
L.LIVESTOCK_INTERFACE_REMOVE = LIVESTOCK_HEADER.."%s has been removed."

L.LIVESTOCK_INTERFACE_MAINPANEL = "Livestock"
L.LIVESTOCK_INTERFACE_PREFSPANEL1 = "Vanity Pets"
L.LIVESTOCK_INTERFACE_PREFSPANEL2 = "Travel & Mounts"
L.LIVESTOCK_INTERFACE_PREFSPANEL3 = "Zones and Subzones"
L.LIVESTOCK_INTERFACE_PREFSPANEL4 = "Random Mount Weight Assignment"

L.LIVESTOCK_EQUIPMENT_DONCARLOS = GetItemInfo(38506)	-- "Don Carlos' Famous Hat"
L.LIVESTOCK_EQUIPMENT_BLOODSAIL = GetItemInfo(12185)	-- "Bloodsail Admiral's Hat"
