local L = LibStub("AceLocale-3.0"):GetLocale("ZOMGBuffs", false)
local Sink, SinkVersion = LibStub("LibSink-2.0", true)
local SM = LibStub("LibSharedMedia-3.0")
assert(AceGUIWidgetLSMlists, "ZOMGBuffs requires AceGUI-3.0-SharedMediaWidgets")

--[===[@debug@
local function d(...)
	ChatFrame1:AddMessage("ZOMG: "..format(...))
end
--@end-debug@]===]

local wowVersion = tonumber((select(2, GetBuildInfo())))

BINDING_HEADER_ZOMGBUFFS = L["TITLECOLOUR"]
BINDING_NAME_ZOMGBUFFS_PORTAL = L["PORTALZ_HOTKEY"]

local qtip = LibStub("LibQTip-1.0")
--local LGT = LibStub("LibGroupTalents-1.0")
local FrameArray = {}
local AllFrameArray = {}
local secureCalls = {}
local playerClass, playerName
local buffClass, lastCheckFail

local InCombatLockdown	= InCombatLockdown
local IsUsableSpell		= IsUsableSpell
local GetSpellCooldown	= GetSpellCooldown
local GetSpellInfo		= GetSpellInfo
local UnitBuff			= UnitBuff
local UnitCanAssist		= UnitCanAssist
local UnitClass			= UnitClass
local UnitIsConnected	= UnitIsConnected
local UnitInParty		= UnitInParty
local UnitIsPVP			= UnitIsPVP
local UnitInRaid		= UnitInRaid
local UnitIsUnit		= UnitIsUnit
local UnitPowerType		= UnitPowerType

local classIcons = {
	WARRIOR	= "Interface\\Icons\\Ability_Warrior_BattleShout",
	ROGUE	= "Interface\\Icons\\Ability_Stealth",
	HUNTER	= "Interface\\Icons\\Ability_TrueShot",
	DRUID	= "Interface\\Icons\\Spell_Nature_Regeneration",
	SHAMAN	= "Interface\\Icons\\Spell_Nature_SkinofEarth",
	PALADIN	= "Interface\\Icons\\Spell_Holy_FistOfJustice",
	PRIEST	= "Interface\\Icons\\Spell_Holy_WordFortitude",
	MAGE	= "Interface\\Icons\\Spell_Holy_MagicalSentry",
	WARLOCK	= "Interface\\Icons\\Spell_Shadow_DemonBreath",
	DEATHKNIGHT = "Interface\\Icons\\Spell_DeathKnight_Subversion",
}

local classOrder = {"WARRIOR", "DEATHKNIGHT", "ROGUE", "HUNTER", "DRUID", "SHAMAN", "PALADIN", "PRIEST", "MAGE", "WARLOCK"}
if (type(CLASS_BUTTONS) == "table") then
	for class in pairs(CLASS_BUTTONS) do
		local got
		for i = 1,#classOrder do
			if (classOrder[i] == class) then
				got = true
			end
		end
		if (not got) then
			if (class ~= "PET" and class ~= "MAINASSIST" and class ~= "MAINTANK") then
				tinsert(classOrder, class)
			end
		end
	end
end
local classIndex = {}
for k,v in pairs(classOrder) do classIndex[v] = k end

local CellOnEnter, IconOnEnter, CellOnLeave, CellBarOnUpdate, CellOnMouseUp, CellOnMouseDown

local specChangers = {
	[GetSpellInfo(63645) or "Fake"] = true,			-- Activate Primary Spec
	[GetSpellInfo(63644) or "Fake"] = true,			-- Activate Secondary Spec
}

-- ShortDesc
local function ShortDesc(a)
	if (a == "MARKINGS") then	return L["Mark/Kings"]
	elseif (a == "STA") then	return L["Stamina"]
	elseif (a == "INT") then	return L["Intellect"]
	elseif (a == "SHADOWPROT") then return L["Shadow Protection"]
	elseif (a == "MIGHT") then	return L["Might"]
	end
end

local new, del, copy, deepDel
do
--[===[@debug@
	local errorTable = setmetatable({},{
		__newindex = function(self) error("Attempt to assign to a recycled table (2)") end,
		__index = function(self) return "bad table" end,
	})
	local protect = {
		__newindex = function(self) error("Attempt to assign to a recycled table") end,
		__index = function(self) return errorTable end,		--error("Attempt to access a recycled table") end,
	}
--@end-debug@]===]

	local next, select, pairs, type = next, select, pairs, type
	local list = setmetatable({},{__mode='k'})

	function new(...)
		local t = next(list)
		if t then
			list[t] = nil
--[===[@debug@
			setmetatable(t, nil)
			assert(not next(t))
--@end-debug@]===]
			for i = 1, select('#', ...) do
				t[i] = select(i, ...)
			end
			return t
		else
			t = {...}
			return t
		end
	end
	function del(t)
		if (t) then
			setmetatable(t, nil)

			wipe(t)
			t[''] = true
			t[''] = nil
			list[t] = true
--[===[@debug@
			assert(not next(t))
			setmetatable(t, protect)
--@end-debug@]===]
		end
	end
	function deepDel(t)
		if (t) then
			setmetatable(t, nil)

			for k,v in pairs(t) do
				if type(v) == "table" then
					deepDel(v)
				end
				t[k] = nil
			end
			t[''] = true
			t[''] = nil
			list[t] = true
--[===[@debug@
			assert(not next(t))
			setmetatable(t, protect)
--@end-debug@]===]
		end
	end
	function copy(old)
		if (not old) then
			return
		end
		local n = new()
		for k,v in pairs(old) do
			if (type(v) == "table") then
				n[k] = copy(v)
			else
				n[k] = v
			end
		end
		setmetatable(n, getmetatable(old))
		return n
	end
end


_G.ZOMGBuffs = LibStub("AceAddon-3.0"):NewAddon("ZOMGBuffs", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")
local z = ZOMGBuffs
z:SetDefaultModuleLibraries("AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local btr

if (Sink) then
	Sink:Embed(z)
end

z.new, z.del, z.deepDel, z.copy = new, del, deepDel, copy
z.classOrder = classOrder
z.classIndex = classIndex
z.manaClasses = {DRUID = true, SHAMAN = true, PALADIN = true, PRIEST = true, MAGE = true, WARLOCK = true}

do
	local allBuffs = {
		{opt = "mark",	ids = {1126},	class = "DRUID",	type = "MARKINGS"},		-- Mark of the Wild
		{opt = "sta",	ids = {21562, 69377},	class = "PRIEST",	type = "STA", runescroll = true},	-- Power Word: Fortitude
		{opt = "int",	ids = {1459},	class = "MAGE",		type = "INT", manaOnly = true},	-- Arcane Brilliance
-- DEPRECATED		{opt = "shadow",ids = {27683},	class = "PRIEST",	type = "SHADOWPROT"},	-- Shadow Protection
		{opt = "kings",ids = {20217},	class = "PALADIN",	type = "MARKINGS", runescroll = true},	-- Kings
		{opt = "might",ids = {19740},	class = "PALADIN",	type = "MIGHT"},	-- Might
		{opt = "food",	ids = {46899, 433},							type = "FOOD"},		-- Well Fed (Food = 433)
		{opt = "flask",												type = "FLASK",		icon = "Interface\\Icons\\INV_Potion_1"},
	}
	local otherBuffs = {
		[469] = "STA",		-- Commanding Shout
		[6307] = "STA",		-- Blood Pact
-- DEPRECATED		[54424] = "INT",	-- Fel Intelligence
		[61316] = "INT",	-- Dalaran Brilliance
	}

	z.allBuffs = {}
	z.buffTypes = {}
	for i,info in pairs(allBuffs) do
		if (info.ids) then
			local name, _, icon = GetSpellInfo(info.ids[1])
			assert(name and icon)
			info.icon = icon
			info.list = {}
			if not z.buffTypes[info.type] then
				z.buffTypes[info.type] = {}
			end
			for j,id in ipairs(info.ids) do
				local name = GetSpellInfo(id)
				info.list[name] = true
				z.buffTypes[info.type][name] = true
			end
			info.list[name] = true
		end
		tinsert(z.allBuffs, info)
	end
	for id,type in pairs(otherBuffs) do
		local name = GetSpellInfo(id)
		if not z.buffTypes[type] then
			z.buffTypes[type] = {}
		end
		z.buffTypes[type][name] = true
	end
	z.buffs = {}

	z.auras = {
		DEVOTION		= {id = 465},		-- Devotion Aura
		RETRIBUTION		= {id = 7294},		-- Retribution Aura
		CONCENTRATION	= {id = 19746},		-- Concentration Aura
		RESISTANCE		= {id = 19891},		-- Resistance Aura
		CRUSADER		= {id = 32223},		-- Crusader Aura
	}
	for key,info in pairs(z.auras) do
		local _
		info.name, _, info.icon = GetSpellInfo(info.id)
		info.key = key
	end
	z.auraCycle = {"DEVOTION", "RETRIBUTION", "CONCENTRATION", "RESISTANCE", "CRUSADER"}
	z.auraIndex = {}
	for i,name in ipairs(z.auraCycle) do
		z.auraIndex[name] = i
	end
end

z.version = tonumber(string.sub("$Revision: 217 $", 12, -3)) or 1
z.versionCompat = 65478 - 82090				-- 65478 is the compat version check
z.title = L["TITLE"]
z.titleColour = L["TITLECOLOUR"]
z.mainIcon = "Interface\\AddOns\\ZOMGBuffs\\Textures\\Icon"
z.versionRoster = {}
z.zoneFlag = GetTime()

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ZOMGBuffs", {
	type = "launcher",
	label = L["TITLECOLOUR"],
	icon = "Interface\\Addons\\ZOMGBuffs\\Textures\\Icon",
})
local LDBIcon

LDB.OnClick = function(self, button)
	if (not IsModifierKeyDown()) then
		if (button == "LeftButton") then
			z:OnClick()
		elseif (button == "RightButton") then
			z:OpenConfig()
		end
	end
end

LDB.OnEnter = function(self)
	z:OnTooltipUpdate(self)
end

LDB.OnLeave = function(self)
	if (z.qTooltip) then
		if (not z.qTooltip:IsMouseOver()) then
			z.qTooltip:Release()
			z.qTooltip = nil
		end
	end
end

-- propercase
local function propercase(str)
	return str and (strupper(strsub(str, 1, 1))..strlower(strsub(str, 2)))
end

z.classReverse = new()
for i,class in pairs(z.classOrder) do
	z.classReverse[LOCALIZED_CLASS_NAMES_MALE[class]] = class
end

-- CheckVersion
function z:CheckVersion(ver)
	ver = tonumber(string.sub(ver, 12, -3))
	if (ver) then
		if (ver > z.version) then
			z.version = ver
		end
	end
end

--[===[@debug@
-- err
local function err(self, message, ...)
	if type(self) ~= "table" then
		return error(("Bad argument #1 to `err' (table expected, got %s)"):format(type(self)), 2)
	end

	local stack = debugstack(self == z and 2 or 3)
	if not message then
		local second = stack:match("\n(.-)\n")
		message = "error raised! " .. second
	else
		local arg = { ... } -- not worried about table creation, as errors don't happen often

		for i = 1, #arg do
			arg[i] = tostring(arg[i])
		end
		for i = 1, 10 do
			table.insert(arg, "nil")
		end
		message = message:format(unpack(arg))
	end

	if getmetatable(self) and getmetatable(self).__tostring then
		message = ("%s: %s"):format(tostring(self), message)
	elseif type(rawget(self, 'GetLibraryVersion')) == "function" and AceLibrary:HasInstance(self:GetLibraryVersion()) then
		message = ("%s: %s"):format(self:GetLibraryVersion(), message)
	elseif type(rawget(self, 'class')) == "table" and type(rawget(self.class, 'GetLibraryVersion')) == "function" and AceLibrary:HasInstance(self.class:GetLibraryVersion()) then
		message = ("%s: %s"):format(self.class:GetLibraryVersion(), message)
	end

	local first = stack:gsub("\n.*", "")
	local file = first:gsub(".*\\(.*).lua:%d+: .*", "%1")
	file = file:gsub("([%(%)%.%*%+%-%[%]%?%^%$%%])", "%%%1")


	local i = 0
	for s in stack:gmatch("\n([^\n]*)") do
		i = i + 1
		if not s:find(file .. "%.lua:%d+:") and not s:find("%(tail call%)") then
			file = s:gsub("^.*\\(.*).lua:%d+: .*", "%1")
			file = file:gsub("([%(%)%.%*%+%-%[%]%?%^%$%%])", "%%%1")
			break
		end
	end
	local j = 0
	for s in stack:gmatch("\n([^\n]*)") do
		j = j + 1
		if j > i and not s:find(file .. "%.lua:%d+:") and not s:find("%(tail call%)") then
			return error(message, j+1)
		end
	end
	return error(message, 2)
end

-- argCheck
function z.argCheck(self, arg, num, kind, kind2, kind3, kind4, kind5)
	if type(num) ~= "number" then
		return err(self, "Bad argument #3 to `argCheck' (number expected, got %s)", type(num))
	elseif type(kind) ~= "string" then
		return err(self, "Bad argument #4 to `argCheck' (string expected, got %s)", type(kind))
	end
	arg = type(arg)
	if arg ~= kind and arg ~= kind2 and arg ~= kind3 and arg ~= kind4 and arg ~= kind5 then
		local stack = debugstack(self == z and 2 or 3)
		local func = stack:match("`argCheck'.-([`<].-['>])")
		if not func then
			func = stack:match("([`<].-['>])")
		end
		if kind5 then
			return err(self, "Bad argument #%s to %s (%s, %s, %s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, kind4, kind5, arg)
		elseif kind4 then
			return err(self, "Bad argument #%s to %s (%s, %s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, kind4, arg)
		elseif kind3 then
			return err(self, "Bad argument #%s to %s (%s, %s, or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, kind3, arg)
		elseif kind2 then
			return err(self, "Bad argument #%s to %s (%s or %s expected, got %s)", tonumber(num) or 0/0, func, kind, kind2, arg)
		else
			return err(self, "Bad argument #%s to %s (%s expected, got %s)", tonumber(num) or 0/0, func, kind, arg)
		end
	end
end
--@end-debug@]===]

local function getTrackOption(info)
	return z.db.profile.track[info[#info]]
end
local function setTrackOption(info, value)
	z.db.profile.track[info[#info]] = value
	z:SetBuffsList()
	z:OptionsShowList()
end

do
	local outlines = {[""] = L["None"], ["OUTLINE"] = L["Outline"], ["THICKOUTLINE"] = L["Thick Outline"]}
	local points = {TOPLEFT = L["Top Left"], TOP = L["Top"], TOPRIGHT = L["Top Right"], RIGHT = L["Right"], BOTTOMRIGHT = L["Bottom Right"], BOTTOM = L["Bottom"], BOTTOMLEFT = L["Bottom Left"], LEFT = L["Left"]}
	local getOption = function(info) return z.db.profile[info[#info]] end
	local setOption = function(info, value) z.db.profile[info[#info]] = value end
	local setOptionUpdate =
		function(info, value)
			z.db.profile[info[#info]] = value
			z:SetupForSpell()
			z:RequestSpells()
		end

	local getPCOption = function(info) return z.db.char[info[#info]] end
	local setPCOption =
		function(info, value)
			z.db.char[info[#info]] = value
		 	if (s) then
				z:SetupForSpell()
				z:RequestSpells()
			end
		end
	local function notRebuffer()
		return not z:IsRebuffer()
	end
	local function hideReagentOpts()
		return not z:AnyReagentOptions()
	end
	local function noNoticeOptions()
		return not z.db.profile.notice
	end

z.options = {
	type = 'group',
	order = 1,
	name = L["TITLECOLOUR"],
	desc = L["Configuration"],
	handler = z,
	get = getOption,
	set = setOption,
	args = {
		General = {
			type = 'group',
			name = L["Configuration"],
			desc = L["Configuration"],
			order = 1,
			guiInline = true,
			args = {
				behaviour = {
					type = 'group',
					name = L["Behaviour"],
					desc = L["General buffing behaviour"],
					order = 220,
					guiInline = true,
					args = {
						ignoreabsent = {
							type = 'toggle',
							name = L["Ignore Absent"],
							desc = L["If players are offline, AFK or in another instance, count them as being present and buff everyone else"],
							hidden = notRebuffer,
							set = setOptionUpdate,
							order = 105,
						},
						skippvp = {
							type = 'toggle',
							name = L["Skip PVP Players"],
							desc = L["Don't directly buff PVP flagged players, unless you're already flagged for PVP"],
							hidden = notRebuffer,
							set = setOptionUpdate,
							order = 108,
						},
						notresting = {
							type = 'toggle',
							name = L["Not When Resting"],
							desc = L["Don't auto buff when Resting"],
							set = setOptionUpdate,
							order = 112,
						},
						restingpvp = {
							type = 'toggle',
							name = L["...unless PvP"],
							desc = L["Allow auto buffing when resting when your PvP is enabled"],
							set = setOptionUpdate,
							order = 113,
						},
						notmounted = {
							type = 'toggle',
							name = L["Not When Mounted"],
							desc = L["Don't auto buff when Mounted"],
							set = setOptionUpdate,
							order = 114,
						},
						notstealthed = {
							type = 'toggle',
							name = L["Not When Stealthed"],
							desc = L["Don't auto buff when Stealthed"],
							set = setOptionUpdate,
							hidden = function() return playerClass ~= "DRUID" and playerClass ~= "ROGUE" end,
							order = 115,
						},
						notshifted = {
							type = 'toggle',
							name = L["Not When Shapeshifted"],
							desc = L["Don't auto buff when Shapeshifted"],
							set = setOptionUpdate,
							hidden = function() return playerClass ~= "DRUID" and playerClass ~= "SHAMAN" end,
							order = 116,
						},
						minmana = {
							type = 'range',
							name = L["Minimum Mana %"],
							desc = L["How much mana should you have before considering auto buffing"],
							get = getPCOption,
							set = setPCOption,
							min = 0,
							max = 100,
							step = 1,
							bigStep = 5,
							order = 390,
						},
						waitforraid = {
							type = 'range',
							name = L["Wait for Raid"],
							desc = L["Wait for certain amount of the raid to arrive before group and class buffing commences. Zero to always buff."],
							hidden = notRebuffer,
							set = setOptionUpdate,
							isPercent = true,
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = 0.1,
							order = 400,
						},
					},
				},
				learn = {
					order = 250,
					type = 'group',
					name = L["Learning"],
					desc = L["Setup spell learning behaviour"],
					guiInline = true,
					args = {
						learnooc = {
							type = 'toggle',
							name = L["Out of Combat"],
							desc = L["Learn buff changes out of combat"],
							get = getPCOption,
							set = setPCOption,
							order = 1,
						},
						learncombat = {
							type = 'toggle',
							name = L["In-Combat"],
							desc = L["Learn buff changes in combat"],
							get = getPCOption,
							set = setPCOption,
							order = 2,
						},
					},
				},
				reminder = {
					order = 280,
					type = 'group',
					name = L["Reminders"],
					desc = L["Options to help you notice when things need doing"],
					guiInline = true,
					args = {
						buffreminder = {
							type = 'select',
							dialogControl = "LSM30_Sound",
							name = L["Rebuff Sound"],
							desc = L["Give audible feedback when someone needs rebuffing"],
							get = getOption,
							set = function(k,v)
								setOption(k,v)
								PlaySoundFile(SM:Fetch("sound", v))
							end,
							values = AceGUIWidgetLSMlists.sound,
							hidden = function() return not SM end,
							order = 1,
						},
						notice = {
							type = 'toggle',
							name = L["Notice"],
							desc = L["Show notice on screen for buff needs"],
							order = 5,
						},
						movenotice = {
							type = 'execute',
							name = L["Notice Anchor"],
							desc = L["Show the Notice area anchor"],
							func = "MovableNoticeWindow",
							disabled = noNoticeOptions,
							order = 6,
						},
						usesink = {
							type = 'toggle',
							name = L["Sink Output"],
							desc = L["Route notification messages through SinkLib"],
							hidden = function() return not Sink end,
							disabled = noNoticeOptions,
							order = 7,
						},
						info = {
							type = 'toggle',
							name = L["Information"],
							desc = L["Give feedback about events"],
							order = 15,
						},
					},
				},
				reagents = {
					type = 'group',
					name = L["Reagents"],
					desc = L["Reagent buying options"],
					order = 990,
					guiInline = true,
					hidden = hideReagentOpts,
					args = {
						autobuyreagents = {
							type = 'toggle',
							name = L["Auto Buy Reagents"],
							desc = L["Automatically purchase required reagents from Reagents Vendor"],
							get = getPCOption,
							set = setPCOption,
							order = 1,
						},
						reagentlevels = {
							type = 'group',
							name = L["Reagents Levels"],
							desc = L["Purchase levels for reagents"],
							disabled = function() return not z.db.char.autobuyreagents end,
							order = 2,
							guiInline = true,
							args = {
							}
						},
					},
				},
				keys = {
					type = 'group',
					name = L["Hot-Key Setup"],
					desc = L["Hot-Key Setup"],
					order = 995,
					guiInline = true,
					args = {
						mousewheel = {
							type = 'toggle',
							name = L["Mousewheel Buff"],
							desc = L["Use mousewheel to trigger auto buffing"],
							set = function(v,n)
								setOption(v,n)
								z.db.profile.keybinding = nil
								z:SetKeyBindings()
							end,
							order = 50,
						},
						keybinding = {
							type = "keybinding",
							name = L["Key-Binding"],
							desc = L["Define the key used for auto buffing"],
							set = function(v,n)
								if (n == "MOUSEWHEELUP" or n == "MOUSEWHEELDOWN") then
									z.db.profile.mousewheel = true
									z.db.profile.keybinding = nil
								else
									setOption(v,n)
								end
								z:SetKeyBindings()
							end,
							disabled = function() return z.db.profile.mousewheel end,
							order = 51,
						},
					},
				},
			},
		},
		display = {
			type = 'group',
			name = L["Display"],
			desc = L["Display options"],
			order = 20,
			args = {
				alwaysLoadPortalz = {
					type = 'toggle',
					name = L["Always Load Portalz"],
					desc = L["Always load the Portalz module, even when not a Mage"],
					set = function(v,n) setOption(v,n) if (z.MaybeLoadPortalz) then z:MaybeLoadPortalz() end end,
					hidden = function() return select(2,UnitClass("player")) == "MAGE" or select(6,GetAddOnInfo("ZOMGBuffs_Portalz")) == "MISSING" end,
					order = 21,
				},
				loadraidbuffmodule = {
					type = 'toggle',
					name = L["Load Raid Module"],
					desc = L["Load the Raid Buff module. Usually for Mages, Druids & Priests, this module can also track single target spells such as Earth Shield & Blessing of Sacrifice, and allow raid buffing of Undending Breath and so on"],
					get = getPCOption,
					set = function(k,v)
						z.db.char.loadraidbuffmodule = v
						if (v) then
							LoadAddOn("ZOMGBuffs_BuffTehRaid")
							self.actions = nil
							self:SetClickConfigMenu()
						end
					end,
					hidden = function() return not z.canloadraidbuffmodule end,
					order = 25,
				},
				spellIcons = {
					type = 'toggle',
					name = L["Spell Icons"],
					desc = L["Show spell icons with spell names in messages"],
					order = 35,
				},
				short = {
					type = 'toggle',
					name = L["Short Names"],
					desc = L["Use short spell names where appropriate"],
					order = 40,
				},
				icon = {
					type = 'group',
					name = L["Icon"],
					desc = L["Settings for the mouseover icon used by the popup player buff list"],
					order = 101,
					guiInline = true,
					args = {
						showicon = {
							type = 'toggle',
							name = L["Enable"],
							desc = L["Display the mouseover icon used by the popup player buff list"],
							get = getOption,
							set = function(k,v) setOption(k,v) z:SetIconSize() end,
							disabled = InCombatLockdown,
							order = 1,
						},
						iconlocked = {
							type = 'toggle',
							name = L["Lock"],
							desc = L["Lock floating icon position"],
							get = getPCOption,
							set = setPCOption,
							order = 2,
						},
						classIcon = {
							type = 'toggle',
							name = L["Class Icon"],
							desc = L["Uses your main ZOMGBuffs spell for the floating icon, instead of the ZOMGBuffs default"],
							get = getOption,
							set = function(k,v) setPCOption(k,v) z:SetIconSize() z:CanCheckBuffs() end,
							order = 5,
						},
						iconname = {
							type = 'toggle',
							name = L["Name"],
							desc = L["Display the ZOMGBuffs logo on icon"],
							set = function(k,v) setOption(k,v) z:SetIconSize() end,
							order = 8,
						},
						iconswirl = {
							type = 'toggle',
							name = L["Swirl"],
							desc = L["Display the spell ready swirl when an autocast spell is loaded on the main icon"],
							set = function(k,v) setOption(k,v) end,
							order = 8,
						},
						iconsize = {
							type = 'range',
							name = L["Icon Size"],
							desc = L["Size of main icon"],
							get = getOption,
							set = function(k,v) setOption(k,v) z:SetIconSize() end,
							disabled = function() return InCombatLockdown() or not z.db.char.showicon end,
							min = 20,
							max = 64,
							step = 1,
							bigStep = 5,
							order = 10,
						},
						reset = {
							type = 'execute',
							name = L["Reset Icon Position"],
							desc = L["Reset the icon position to the centre of the screen"],
							func = function() z.icon:ClearAllPoints() z.icon:SetPoint("CENTER") end,
							order = 301,
							disabled = InCombatLockdown,
						},
					},
				},
				list = {
					type = 'group',
					name = L["List"],
					desc = L["Settings for the popup buff list"],
					order = 102,
					guiInline = true,
					args = {
						bufftimer = {
							type = 'toggle',
							name = L["Buff Timer"],
							desc = L["Show buff time remaining with bar"],
							set = function(k,v) setOption(k,v) z:DrawAllCells() z:OptionsShowList() end,
							order = 10,
						},
						bufftimersize = {
							type = 'range',
							name = L["Timer Size"],
							desc = L["Adjust the size of the timer text"],
							set = function(k,v) setOption(k,v) z:DrawAllCells() z:OptionsShowList() end,
							min = 0.3,
							max = 2,
							step = 0.05,
							order = 11,
						},
						threshold = {
							type = 'range',
							name = L["Timer Threshold"],
							desc = L["Buff times over this number of minutes will not be shown"],
							get = function() return floor(z.db.profile.bufftimerthreshold / 60 + 0.5) end,
							set = function(v)
								z.db.profile.bufftimerthreshold = v * 60
								z:DrawAllCells()
								z:OptionsShowList()
							end,
							min = 0,
							max = 120,
							step = 1,
							bigStep = 10,
							order = 12,
						},
						track = {
							type = 'group',
							name = L["Columns"],
							desc = L["Columns to show in buff list"],
							order = 50,
							guiInline = true,
							get = getTrackOption,
							set = setTrackOption,
							args = {
								sta = {
									type = 'toggle',
									name = GetSpellInfo(21562),		-- Power Word: Fortitude
									desc = GetSpellInfo(21562),		-- Power Word: Fortitude
									order = 1,
								},
								mark = {
									type = 'toggle',
									name = GetSpellInfo(1126),		-- Mark of the Wild
									desc = GetSpellInfo(1126),		-- Mark of the Wild
									order = 2,
								},
								int = {
									type = 'toggle',
									name = GetSpellInfo(1459),		-- Arcane Intellect
									desc = GetSpellInfo(1459),		-- Arcane Intellect
									order = 3,
								},
								kings = {
									type = 'toggle',
									name = GetSpellInfo(20217),		-- Kings
									desc = GetSpellInfo(20217),		-- Kings
									order = 4,
								},
								might = {
									type = 'toggle',
									name = GetSpellInfo(19740),		-- Might
									desc = GetSpellInfo(19740),		-- Might
									order = 5,
								},
-- DEPRECATED								shadow = {
-- DEPRECATED									type = 'toggle',
-- DEPRECATED									name = GetSpellInfo(27683),		-- Shadow Protection
-- DEPRECATED									desc = GetSpellInfo(27683),		-- Shadow Protection
-- DEPRECATED									order = 6,
-- DEPRECATED								},
								food = {
									type = 'toggle',
									name = GetSpellInfo(46899),		-- Well Fed
									desc = GetSpellInfo(46899),		-- Well Fed
									order = 7,
								},
								flask = {
									type = 'toggle',
									name = L["Flask"],
									desc = L["Is player flasked or potted"],
									order = 8,
								},
								runescroll = {
									type = 'toggle',
									name = L["RuneScroll/Drums"],
									desc = L["Always show Stamina and Mark of the Wild Columns"],
									get = getOption,
									set = function(p,v) z.db.profile[p] = v z:SetBuffsList() z:OptionsShowList() end,
									order = 20,
								},
							},
						},
						invert = {
							type = 'toggle',
							name = L["Invert"],
							desc = L["Invert the need/got alpha values"],
							set = function(k,v) setOption(k,v) z:OptionsShowList() z:PLAYER_ENTERING_WORLD() end,
							order = 110,
						},
						sort = {
							type = 'select',
							name = L["Sort Order"],
							desc = L["Select sorting order for buff overview (can't be changed during combat)"],
							get = getPCOption,
							set = function(k,v) setPCOption(k,v) z:SetSort(true) end,
							values = {ALPHA = L["Alphabetical"], CLASS = L["Class"], GROUP = L["Group"], INDEX = L["Unsorted"]},
							disabled = InCombatLockdown,
							order = 111,
						},
						groupno = {
							type = 'toggle',
							name = L["Group Number"],
							desc = L["Show the group number next to list"],
							set = function(k,v) setOption(k,v) z:DrawGroupNumbers() end,
							order = 112,
							hidden = function() return z.db.char.sort ~= "GROUP" end,
						},
						show = {
							type = 'group',
							name = L["Show"],
							desc = L["Visiblity options"],
							order = 120,
							guiInline = true,
							disabled = InCombatLockdown,
							args = {
								showSolo = {
									type = 'toggle',
									name = L["Solo"],
									desc = L["Show the popup raid list when you are not in a raid or party"],
									set = function(k,v) setOption(k,v) z:SetVisibilityOption() z:DrawGroupNumbers() end,
									disabled = InCombatLockdown,
									order = 1,
								},
								showParty = {
									type = 'toggle',
									name = L["Party"],
									desc = L["Show the popup raid list when you are in a party"],
									set = function(k,v) setOption(k,v) z:SetVisibilityOption() z:DrawGroupNumbers() end,
									disabled = InCombatLockdown,
									order = 2,
								},
								showRaid = {
									type = 'toggle',
									name = L["Raid"],
									desc = L["Show the popup raid list when you in a raid"],
									set = function(k,v) setOption(k,v) z:SetVisibilityOption() z:DrawGroupNumbers() end,
									disabled = InCombatLockdown,
									order = 3,
								},
							},
						},
						showroles = {
							type = 'toggle',
							name = L["Show Roles"],
							desc = L["Show player role icons"],
							order = 125,
						},
						border = {
							type = 'toggle',
							name = L["Border"],
							desc = L["Enable border on the list"],
							get = getPCOption,
							set = function(k,v) setPCOption(k,v) z:DrawGroupNumbers() end,
							order = 200,
						},
						bartexture = {
							type = 'select',
							dialogControl = "LSM30_Statusbar",
							name = L["Bar Texture"],
							desc = L["Set the texture for the buff timer bars"],
							values = AceGUIWidgetLSMlists.statusbar,
							order = 201,
							set = function(k,v) setOption(k,v) z:SetAllBarTextures() z:OptionsShowList() end,
						},
						width = {
							type = 'range',
							name = L["Width"],
							desc = L["Adjust width of unit list"],
							get = getPCOption,
							set = function(k,v) setPCOption(k,v) z:SetAllBarSizes() z:OptionsShowList() end,
							disabled = InCombatLockdown,
							min = 100,
							max = 300,
							step = 1,
							bigStep = 10,
							order = 202,
						},
						height = {
							type = 'range',
							name = L["Bar Height"],
							desc = L["Adjust height of the bars"],
							get = getPCOption,
							set = function(k,v) setPCOption(k,v) z:SetAllBarSizes() z:OptionsShowList() end,
							disabled = InCombatLockdown,
							min = 10,
							max = 30,
							step = 1,
							order = 203,
						},
						font = {
							type = 'group',
							name = L["Font"],
							desc = L["Font"],
							order = 204,
							guiInline = true,
							args = {
								fontface = {
									type = "select",
									dialogControl = "LSM30_Font",
									name = L["Font"],
									desc = L["Font"],
									values = AceGUIWidgetLSMlists.font,
									get = getOption,
									set = function(k,v) setOption(k,v) z:ApplyFont() z:OptionsShowList() end,
									order = 1,
								},
								fontsize = {
									type = 'range',
									name = L["Size"],
									desc = L["Size"],
									min = 5,
									max = 25,
									step = 1,
									get = getOption,
									set = function(k,v) setOption(k,v) z:ApplyFont() z:OptionsShowList() end,
									order = 2,
								},
								fontoutline = {
									type = 'select',
									name = L["Outlining"],
									desc = L["Outlining"],
									get = getOption,
									set = function(k,v) setOption(k,v) z:ApplyFont() z:OptionsShowList() end,
									values = outlines,
									order = 3,
								},
							},
						},
						anchor = {
							type = 'select',
							name = L["Anchor"],
							desc = L["Choose the anchor to use for the player list"],
							values = points,
							order = 220,
							get = getOption,
							set = function(k,v) z.db.profile.anchor = v z:SetAnchors() z:OptionsShowList() end,
							disabled = InCombatLockdown,
						},
						relpoint = {
							type = 'select',
							name = L["Relative Point"],
							desc = L["Choose the relative point for the anchor"],
							values = points,
							order = 221,
							get = getOption,
							set = function(k,v) z.db.profile.relpoint = v z:SetAnchors() z:OptionsShowList() end,
							disabled = InCombatLockdown,
						},
					},
				},
			},
		},
	},
}

	LDBIcon = LibStub("LibDBIcon-1.0", true)
	if (LDBIcon) then
		z.options.args.display.args.ShowMinimap = {
			type = "toggle",
			order = 1,
			name = L["Minimap"],
			desc = L["Show minimap icon"],
			get = function(info) return not z.db.profile.ldbIcon.hide end,
			set = function(info,v)
				z.db.profile.ldbIcon.hide = not v
				LDBIcon[z.db.profile.ldbIcon.hide and "Hide" or "Show"](LDBIcon, "ZOMGBuffs")
			end,
			width = "half",
		}
	end
end

-- IsRebuffer
function z:IsRebuffer()
	for name, module in self:IterateModules() do
		if (module.RebuffQuery) then
			return true
		end
	end
end


-- Custom roster iterator
do
	local unitCache, unitCacheMode

	local function SetCacheMode(m)
		if (unitCacheMode ~= m) then
			unitCacheMode = m
			local meta
			if (m == "raid") then
				meta = function(self, i)
					local n = "raid"..i
					self[i] = n
					return n
				end
			else
				meta = function(self, i)
					local n = i == 0 and "player" or "party"..i
					self[i] = n
					return n
				end
			end

			unitCache = setmetatable({}, {__mode = "kv", __index = meta})
		end
	end

	-- Speciallized Roster iterator to always put ME first
	-- Also benefits from not having any delay in setup between RAID_ROSTER_UPDATE and RosterLib's update
	local function iter(t)
		local index = t.index
		local pets = t.pets

		if (not index) then
			if (not playerClass) then
				playerClass = playerClass or select(2, UnitClass("player"))
			end

			if (GetNumGroupMembers() > 0 and IsInRaid()) then
				SetCacheMode("raid")
				local End = GetNumGroupMembers()
				t.End = End
				t.type = "raid"
				t.index = 0
				local unit = unitCache[End]		-- YOU are always the last raid member
				t.unit = unit
				t.doPet = pets
				t.mine = pets
				local _, _, subgroup = GetRaidRosterInfo(End)
				return unit, playerName, playerClass, subgroup, End
			else
				SetCacheMode("party")
				t.End = GetNumGroupMembers()
				t.type = "party"
				t.index = 0
				t.doPet = pets
				t.unit = "player"
				return "player", playerName, playerClass, 1, 0
			end
		end

		local unit
		local class = "Unknown"
		if (pets and t.doPet) then
			if (t.unit == "player") then
				unit = "pet"
			elseif (t.mine) then
				t.mine = nil
				unit = "raidpet"..t.End
			else
				unit = format("%spet%d", t.type, index)
			end
			if (UnitExists(unit)) then
				class = "PET"
			else
				t.doPet = nil
			end
		end

		if (not pets or not t.doPet) then
			index = index + 1
			if (index > t.End) then
				t = del(t)
				return nil
			end

			unit = unitCache[index]
			if (UnitIsUnit(unit, "player")) then
				index = index + 1
				if (index > t.End) then
					t = del(t)
					return nil
				end

				unit = unitCache[index]
			end
			class = select(2, UnitClass(unit))
		end

		t.doPet = not t.doPet

		local name, server = UnitName(unit)
		if (server and server ~= "") then
			name = format("%s-%s", name, server)
		end
		t.unit = unit
		t.index = index
		t.unit = unit
		local _, subgroup
		if (t.type == "raid") then
			_, _, subgroup = GetRaidRosterInfo(index)
		else
			subgroup = 1
		end
		if (not class) then
			-- Unknown Unit at this time, so we'll wait for the UNIT_NAME_UPDATE and re-check any we're missing
			z:RegisterEvent("UNIT_NAME_UPDATE")
			if (not z.unknownUnits) then
				z.unknownUnits = new()
			end
			z.unknownUnits[unit] = true
			class = UNKNOWN
		end
		return unit, name, class, subgroup, index
	end

	-- IterateRoster
	function z:IterateRoster(pets)
		local t = new()
		t.pets = pets
		return iter, t
	end

	function z:UNIT_NAME_UPDATE(unit)
		if (self.unknownUnits[unit]) then
			self.unknownUnits[unit] = nil
			local _, class = UnitClass(unit)
			self.classcount[class] = self.classcount[class] + 1

			self:TriggerClickUpdate(unit)

			if (not next(self.unknownUnits)) then
				self.unknownUnits = del(self.unknownUnits)
				self:UnregisterEvent("UNIT_NAME_UPDATE")
				-- Got all now, do full roster update to be sure
				self:OnRaidRosterUpdate()
			end
		end
	end

	function z:UnitRank(who)
		local index = UnitInRaid(who)
		if (index) then
			local name, rank, group = GetRaidRosterInfo(index + 1)
			return rank or 0
		elseif (GetNumPartyMembers() > 0) then
			local index = GetPartyLeaderIndex()
			if (UnitIsUnit(who, "player")) then
				return index == 0 and 2 or 0
			else
				local name = UnitName("party"..index)
				return name == who and 2 or 0
			end
		end
		return 0
	end

	function z:GetUnitID(name)
		local unit = UnitInRaid(name)
		if (unit) then
			return "raid"..(unit + 1)
		end
		if (UnitIsUnit(name, "player")) then
			return "player"
		end
		if (UnitInParty(name)) then
			for i = 1,4 do
				local test = "party"..i
				if (UnitIsUnit(test, name)) then
					return test
				end
			end
		end
		for unit,unitname in z:IterateRoster(true) do
			if (UnitIsUnit(name, unit)) then
				return unit
			end
		end
	end
end

-- GetAllActions
function z:GetAllActions()
	if (not self.actions) then
		self.actions = {
			{name = L["Target"], desc = L["Targetting"], type = "target"},
		}
		for name, mod in self:IterateModules() do
			if (mod.GetActions) then
				if (mod:IsModuleActive()) then
					if (mod.ResetActions) then
						mod:ResetActions()
					end
					local moreActions = mod:GetActions()
					if (moreActions) then
						for i,action in ipairs(moreActions) do
							action.mod = mod
							tinsert(self.actions, action)
						end
					end
				end
			end
		end
	end
end

-- DupKeybinds
function z:DupKeybinds(entry)
	local thisKey = self.db.profile.click and self.db.profile.click[entry.keycode]
	for name,menu in pairs(z.options.args.click.args)  do
		if (menu ~= entry and menu.basename) then
			local otherKey = self.db.profile.click and self.db.profile.click[menu.keycode]
			if (otherKey == thisKey) then
				return true
			end
		end
	end
end

-- CheckDupKeybindsForMenu
function z:CheckDupKeybindsForMenu()
	for name,menu in pairs(z.options.args.click.args)  do
		if (menu.basename) then
			if (self:DupKeybinds(menu)) then
				menu.name = format("|cFFFF8080%s|r", menu.basename)
			else
				menu.name = menu.basename
			end
		end
	end
end

-- SetDefaultKeybindings
function z:SetDefaultKeybindings()
	self.db.profile.click = z:DefaultClickBindings()
	z:CheckDupKeybindsForMenu()
	if (not InCombatLockdown()) then
		z:UpdateCellSpells()
	end
end

-- SetClickConfigMenu
function z:SetClickConfigMenu()
--[[         TODO
	if (self:IsRebuffer()) then
		z.options.args.click = {
			type = 'group',
			name = L["Click Config"],
			desc = L["Configure popup raid list click behaviour"],
			order = 250,
			disabled = InCombatLockdown,
			args = {
				default = {
					type = 'execute',
					name = L["Defaults"],
					desc = L["Restore default keybindings"],
					order = 1,
					func = "SetDefaultKeybindings",
				},
				spacer = {
					type = 'header',
					name = " ",
					order = 2,
				}
			}
		}

		local args = z.options.args.click.args

		local module
		self:GetAllActions()

		local function getClick(entry)
			return self.db.profile.click and self.db.profile.click[entry.keycode]
		end

		local function setClick(entry, value)
			local code = entry.keycode
			if (value and not strfind(value, "BUTTON")) then
				return
			end
			if (not self.db.profile.click) then
				self.db.profile.click = {}
			end
			self.db.profile.click[code] = value

			z:CheckDupKeybindsForMenu()

			if (not InCombatLockdown()) then
				z:UpdateCellSpells()
			end
		end

		if (self.actions) then
			for i,action in ipairs(self.actions) do
				args[action.type] = {
					type = 'text',
					name = action.name,
					basename = action.name,
					desc = format(L["Define the mouse click to use for |cFFFFFF80%s|r"], action.desc or action.name),
					validate = "keybinding",
					get = getClick,
					set = setClick,
					keycode = action.type,
					order = i + 10,
				}
				args[action.type].passValue = args[action.type]
			end
			self:CheckDupKeybindsForMenu()
		end
	end
]]
end

-- GetActionClick
function z:GetActionClick(code)
	self:GetAllActions()
	for i,action in ipairs(self.actions) do
		if (action.type == code) then
			local click = self.db.profile.click and self.db.profile.click[code]

			if (click) then
				local mod, button = strmatch(click, "^([ALTSHIFCRL-]+)-BUTTON(%d)$")
				if (not mod and not button) then
					button = strmatch(click, "^BUTTON(%d)$")
				end
				if (mod) then
					mod = strlower(mod).."-"
				end

				return mod, tonumber(button)
			end
		end
	end
end

-- LinkSpellRaw
function z:LinkSpellRaw(name, overrideName)
	if (z.linkSpells) then
		local spellLink = GetSpellLink(name)
		local spellID
		if (spellLink) then
			spellID = spellLink:match("|Hspell:(%d+)|h")

			if (spellID) then
				return format("|Hspell:%d|h%s|h|r", spellID, overrideName or name)
			end
		end
	end

	return overrideName or name
end

-- LinkSpell
function z:LinkSpell(name, hexColor, icon, overrideName)
	if (not name) then
		return "?"
	end

	if (z.linkSpells and icon) then
		local icon
		if (self.db.profile.spellIcons) then
			icon = select(3, GetSpellInfo(name))
			if (icon) then
				icon = format("|T%s:0|t", icon)
			else
				icon = ""
			end
		else
			icon = ""
		end

		return format("%s%s%s|r", icon, hexColor or "|cFFFFFF80", self:LinkSpellRaw(name, overrideName))
	end

	return format("%s%s|r", hexColor or "|cFFFFFF80", overrideName or name)
end

-- HideMeLaterz
local function HideMeLaterz()
	if (not InCombatLockdown()) then
		z.members:Hide()
	end
end

-- OptionsShowList
function z:OptionsShowList()
	if (not InCombatLockdown()) then
		self.members:Show()
		self:Schedule(HideMeLaterz, 5)
	end
end

-- AnyReagentOptions
function z:AnyReagentOptions()
	for name, module in z:IterateModules() do
		if (type(module.reagents) == "table" and next(module.reagents)) then
			return true
		end
	end
end

-- OptionsReagentList
function z:MakeOptionsReagentList()
	local place = z.options.args.General.args.reagents.args.reagentlevels
	place.args = {}
	for name, module in z:IterateModules() do
		if (module.reagents) then
			module:MakeReagentsOptions(place.args)
		end
	end
end

-- UnitHasBuff
function z:UnitHasBuff(unit, buffName)
	if (type(buffName) == "number") then
		buffName = GetSpellInfo(buffName)
		assert(buffName, "Invalid spell ID")
	end
	return UnitBuff(unit, buffName)
	--for i = 1,40 do
	--	local name = UnitBuff(unit, i)
	--	if (not name) then
	--		break
	--	end
	--	if (name == buffName) then
	--		return true
	--	end
	--end
end

-- MediaCallback
function z:MediaCallback(mediatype, key)
	if (mediatype == "statusbar" and key == self.db.profile.bartexture and self.waitingForBarTex) then
		self.waitingForBarTex = nil
		self:SetAllBarTextures()
	elseif (mediatype == "font" and key == self.db.profile.fontface and self.waitingForFont) then
		self.waitingForFont = nil
		self:ApplyFont()
	end

	if (not self.waitingForBarTex and not self.waitingForFont) then
		SM.UnregisterCallback(self, "LibSharedMedia_Registered")
		SM.UnregisterCallback(self, "LibSharedMedia_SetGlobal")
	end
end

-- GetBarTexture
function z:GetBarTexture()
	local tex = "Interface\\AddOns\\ZOMGBuffs\\Textures\\BantoBar"
	if (SM) then
		tex = SM:Fetch("statusbar", self.db.profile.bartexture)
		if (not tex) then
			self.waitingForBarTex = true
			SM.RegisterCallback(self, "LibSharedMedia_Registered", "MediaCallback")
			SM.RegisterCallback(self, "LibSharedMedia_SetGlobal", "MediaCallback")
		end
	end
	return tex
end

-- SetAllBarTextures()
function z:SetAllBarTextures()
	local tex = self:GetBarTexture()
	for k,cell in pairs(AllFrameArray) do
		cell.bar:SetStatusBarTexture(tex)
	end
end

-- GetFont
function z:GetFont()
	local font = SM and SM:Fetch("font", self.db.profile.fontface)
	if (not font) then
		self.waitingForFont = true
		SM.RegisterCallback(self, "LibSharedMedia_Registered", "MediaCallback")
		SM.RegisterCallback(self, "LibSharedMedia_SetGlobal", "MediaCallback")
	end
	return font or "", self.db.profile.fontsize, self.db.profile.fontoutline
end

-- ApplyFont
function z:ApplyFont()
	local a, b, c = self:GetFont()
	for k,cell in pairs(AllFrameArray) do
		cell.name:SetFont(a, b, c)
	end
end

-- LinkPlayer
function z:LinkPlayer(name)
	return format("|Hplayer:%s|h%s|h", name)
end

-- HexColour
function z:HexColour(r, g, b)
	return format("|cFF%02X%02X%02X", r * 255, g * 255, b * 255)
end

-- ColourGroup
function z:ColourGroup(grp)
	local r, g, b = unpack(self.groupColours[grp])
	return format("|cFF%02X%02X%02XGroup %d|r", r * 255, g * 255, b * 255, grp)
end

-- ColourUnit
function z:ColourUnit(unitid)
	if (unitid) then
		local name = UnitName(unitid)
		if (not name) then
			return unitid
		end
		if (strfind(unitid, "pet")) then
			local ownerid = unitid:gsub("pet", "")
			if (ownerid and UnitExists(ownerid)) then
				return format(L["|cFF808080%s|r [|Hplayer:%s|h%s|h's pet]"], name, UnitName(ownerid), z:ColourUnit(ownerid))
			end
		end
		local c = z:GetClassColour(select(2, UnitClass(unitid)))
		return format("|cFF%02X%02X%02X|Hplayer:%s|h%s|h|r", c.r * 255, c.g * 255, c.b * 255, name, name)
	else
		return "badunit:"..tostring(unitid)
	end
end
z.ColourUnitByName = z.ColourUnit

-- ColourClass
function z:ColourClass(upperClass, prefix, suffix)
	if (upperClass) then
		if (upperClass == "PET") then
			return "Pet"
		else
			local properClass = LOCALIZED_CLASS_NAMES_MALE[upperClass] or upperClass
			local c = self:GetClassColour(upperClass)
			return format("|cFF%02X%02X%02X%s%s%s|r", c.r * 255, c.g * 255, c.b * 255, (prefix and prefix.." ") or "", properClass, (suffix and " "..suffix) or "")
		end
	end
	return "?"
end

-- ColourClassUnit
function z:ColourClassUnit(unit)
	local properClass, upperClass = UnitClass(unit)
	local c = self:GetClassColour(upperClass)
	return format("|cFF%02X%02X%02X%s|r", c.r * 255, c.g * 255, c.b * 255, properClass)
end

-- ReagentExpired
function z:ReagentExpired(reagent)
	if (not self.zoneFlag and z.db.profile.info) then
		if (type(reagent) == "number") then
			reagent = select(2, reagent)
		else
			reagent = format("|cFFFF8080%s|r", reagent)
		end
		if (reagent) then
			self:Printf(L["You have run out of %s, now using single target buffs"], reagent)
		end
	end
end

-- noticeOnUpdate
local function noticeOnUpdate(self, elapsed)
	if (self.holdOff > 0) then
		self.holdOff = self.holdOff - elapsed
	else
		local a = max(0, self:GetAlpha() - elapsed)
		if (a <= 0) then
			self:Hide()
			self:SetAlpha(1)
		else
			self:SetAlpha(a)
		end
	end
end

-- CreateMovableNoticeWindow
function z:CreateMovableNoticeWindow()
	local f = self.noticeWindow
	f.finish = CreateFrame("Button", nil, f, "OptionsButtonTemplate")
	f.finish:SetWidth(80)
	f.finish:SetHeight(15)
	f.finish:SetText(L["Finish"])
	f.finish:SetScript("OnClick",
		function(self)
			z.noticeWindow:Hide()
		end)
	f.finish:SetPoint("BOTTOMRIGHT", f, "BOTTOM", -10, 10)

	f.default = CreateFrame("Button", nil, f, "OptionsButtonTemplate")
	f.default:SetWidth(80)
	f.default:SetHeight(15)
	f.default:SetText(DEFAULT)
	f.default:SetScript("OnClick",
		function(self)
			z.noticeWindow:ClearAllPoints()
			z.noticeWindow:SetPoint("CENTER")
			z.db.char.noticePoint = nil
		end)
	f.default:SetPoint("BOTTOMLEFT", f, "BOTTOM", 10, 10)
	self.CreateMovableNoticeWindow = nil
end

-- MovableNoticeWindow
function z:MovableNoticeWindow()
	local f = self.noticeWindow
	if (not f) then
		f = self:CreateNoticeWindow()
	end

	f.lastNotice = nil

	self:Notice(L["Position the notification area"])
	if (not f.finish) then
		self:CreateMovableNoticeWindow()
	else
		f.finish:Show()
		f.default:Show()
	end

	f:SetMovable(true)

	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	})
	f:SetBackdropColor(0, 0.5, 0, 1)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart",
		function(self)
			self:StartMoving()
		end)
	f:SetScript("OnDragStop",
		function(self)
			self:StopMovingOrSizing()
			z.db.char.noticePoint = {self:GetPoint(1)}
		end)

	f:SetScript("OnHide",
		function(self)
			self.finish:Hide()
			self.default:Hide()
			self:SetMovable(false)
			self:SetBackdrop(nil)
			self:SetScript("OnDragStart", nil)
			self:SetScript("OnDragStop", nil)
			self:EnableMouse(false)
			self:SetScript("OnHide", nil)
			self:SetScript("OnUpdate", noticeOnUpdate)
		end)

	f:SetScript("OnUpdate", nil)
end

-- CreateNoticeWindow
function z:CreateNoticeWindow()

	local f = CreateFrame("Frame", nil, UIParent)
	self.noticeWindow = f
	f.holdOff = 0
	f.lastNoticeTime = 0

	f:SetWidth(400)
	f:SetHeight(100)
	f:SetClampedToScreen(true)

	if (type(z.db.char.noticePoint) == "table") then
		f:SetPoint(unpack(z.db.char.noticePoint))
	else
		f:SetPoint("CENTER")
	end

	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.text:SetAllPoints()
	f.text:SetTextColor(1, 1, 1)
	f.text:SetJustifyH("CENTER")
	f.text:SetJustifyV("MIDDLE")

	f:SetScript("OnUpdate", noticeOnUpdate)

	self:RestorePosition(self.noticeWindow, self.db.profile.posNotice)

	self.CreateNoticeWindow = nil

	return f
end

-- ClearNotice
function z:ClearNotice()
	local f = self.noticeWindow
	if (f) then
		f.lastNoticeTime = 0
		f.lastNotice = nil
		f.holdOff = 0
		f:SetAlpha(1)
		f:Hide()
	end
end

-- Notice
function z:Notice(notice, sound)
	if (self.db.profile.notice) then
		if (notice ~= self.lastNotice or self.lastNoticeTime < GetTime() - 15) then
			self.lastNoticeTime = GetTime()
			self.lastNotice = notice

			if (sound and SM) then
				PlaySoundFile(SM:Fetch("sound", z.db.profile[sound]))
			end

			if (Sink and self.db.profile.usesink) then
				self:Pour(notice)
			else
				local f = self.noticeWindow
				if (not f) then
					f = self:CreateNoticeWindow()
				end
				f.holdOff = 3
				f.text:SetText(notice)
				f:SetAlpha(1)
				f:Show()
			end
		end
	end
end

-- Report
function z:Report(option)
	if (not IsRaidOfficer() and not IsRaidLeader()) then
		return
	end

	if (option == "missing") then
		local list = new()
		local flags = new()
		local groupCounts = new(0, 0, 0, 0, 0, 0, 0, 0)
		local groupList = new(new(), new(), new(), new(), new(), new(), new(), new())

		for partyid, name, class, subgroup, index in self:IterateRoster() do
			flags.STA, flags.MARKINGS, flags.INT, flags.MIGHT = nil, nil, nil, nil, nil
			if (UnitIsConnected(partyid) and not UnitIsDeadOrGhost(partyid)) then
				groupCounts[subgroup] = groupCounts[subgroup] + 1
				for i = 1,40 do
					local name, rank, buff, count, _, max, endTime = UnitBuff(partyid, i)
					if (not name) then
						break
					end

					for j,one in pairs(z.buffs) do
						if (z.classcount[one.class] > 0) then
							if (one.list[name]) then
								local t = one.type
								flags[t] = true
							end
						else
							flags[one.type] = true			-- Missing buff class, so flag it anyway
						end
					end
				end

				if (not flags.STA and self.classcount.PRIEST > 0) then
					if (not list.STA) then
						list.STA = new()
					end
					tinsert(list.STA, name)
					groupList[subgroup].STA = (groupList[subgroup].STA or 0) + 1
				end
				if (not flags.MARKINGS and (self.classcount.DRUID > 0 or self.classcount.PALADIN > 0)) then
					if (not list.MARKINGS) then
						list.MARKINGS = new()
					end
					tinsert(list.MARKINGS, name)
					groupList[subgroup].MARKINGS = (groupList[subgroup].MARKINGS or 0) + 1
				end
				if (not flags.MIGHT and self.classcount.PALADIN > 0) then
					if (not list.MIGHT) then
						list.MIGHT = new()
					end
					tinsert(list.MIGHT, name)
					groupList[subgroup].MIGHT = (groupList[subgroup].MIGHT or 0) + 1
				end
				if (self.manaClasses[class]) then
					if (not flags.INT and self.classcount.MAGE > 0) then
						if (not list.INT) then
							list.INT = new()
						end
						tinsert(list.INT, name)
						groupList[subgroup].INT = (groupList[subgroup].INT or 0) + 1
					end
				end
			end
		end

		-- Scan the groups for any who are completely missing a buff and replace the individual names with 'Group X'
		for i = 8,1,-1 do
			if (groupCounts[i] > 0) then
				for k,v in pairs(groupList[i]) do
					if (v == groupCounts[i]) then
						tinsert(list[k], 1, format(L["Group %d"], i))
						for unit, name, class, subgroup, index in self:IterateRoster() do
							if (subgroup == i) then
								for j = 1,#list[k] do
									if (list[k][j] == name) then
										tremove(list[k], j)
										break
									end
								end
							end
						end
					end
				end
			end
		end

		for k,v in pairs(list) do
			sort(v)
			SendChatMessage(format(L["<ZOMG> Missing %s: %s"], ShortDesc(k), table.concat(v, ", ")), strupper(self.db.profile.channel) or "RAID")
		end

		del(list)
		deepDel(groupList)
		del(groupCounts)
		del(flags)
	end
end

-- SetIconSize
function z:SetIconSize()
	if (self.db.char.showicon) then
		self.icon:Show()
		self.icon:SetScale(self.db.profile.iconsize / 36)
		self.icon:SetAttribute("*childstate-OnEnter", "enter")
		self.icon:SetClampedToScreen(true)
		self:RestorePosition(self.icon, self.db.profile.pos)
	else
		self.icon:Hide()
		self.icon:SetAttribute("*childstate-OnEnter", nil)
		self.icon:SetClampedToScreen(false)
		self.icon:ClearAllPoints()
		self.icon:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", 50, -50)		-- Push it off the screen
	end

	if (self.db.profile.iconname) then
		self.icon.name:Show()
	else
		self.icon.name:Hide()
	end
end

-- CreateBorder
function z:CreateBorder(parent)
	local border = CreateFrame("Frame", nil, parent)
	border:SetPoint("TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", 4, -4)
	border:SetFrameStrata("LOW")
	border:SetFrameLevel(parent:GetFrameLevel() + 1)

	border:SetBackdrop({
		--bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	border:SetBackdropColor(0,0,0,1)
	border:SetBackdropBorderColor(0.5,0.5,0.5,1)

	return border
end

-- GetPosition
function z:GetPosition(frame)
	if (frame) then
		if (frame:IsResizable()) then
			return {point = {frame:GetPoint(1)}, width = frame:GetWidth(), height = frame:GetHeight()}
		else
			return {point = {frame:GetPoint(1)}}
		end
	end
end

-- RestorePosition
function z:RestorePosition(frame, pos)
	if (pos and pos.point) then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(pos.point))

		if (pos.height and pos.width and frame:IsResizable()) then
			frame:SetWidth(pos.width)
			frame:SetHeight(pos.height)
		end
	end
end

-- z:SetAnchors()
function z:SetAnchors()
	--local d = self.db.char.iconborder and 5 or 0
	local d = 0
	self.members:ClearAllPoints()
	self.members:SetPoint(self.db.profile.anchor or "BOTTOMRIGHT", self.icon, self.db.profile.relpoint or "TOPLEFT", 0, d)
	self.icon:SetHitRectInsets(-d, -d, -d, -d)
end

-- CanLearn
function z:CanLearn()
	return (InCombatLockdown() and self.db.char.learncombat) or self.db.char.learnooc
end

local timerFrame = CreateFrame("Frame")
timerFrame:Hide()
timerFrame:SetScript("OnUpdate",
	function(self, elapsed)
		for func,timer in pairs(z.timers) do
			timer.delay = timer.delay - elapsed
			if timer.delay < 0 then
				if not timer.repeating then
					z.timers[func] = nil
				end

				func(unpack(timer.args))

				if timer.repeating then
					timer.delay = timer.repeating
				else
                	del(timer)
					if not next(z.timers) then
						self:Hide()
						return
					end
				end
			end
		end
	end)

z.timers = {}
function z:Schedule(func, delay, ...)
--[===[@debug@
	assert(func, "missing function for timer")
	assert(delay > 0, "timer delay is <= 0")
--@end-debug@]===]
	local t = self.timers[func]
	if not t then
		t = new()
		t.args = new(...)
	end
	t.delay = delay
	self.timers[func] = t
	timerFrame:Show()
end

function z:ScheduleRepeating(func, delay, ...)
--[===[@debug@
	assert(func, "missing function for timer")
	assert(delay > 0, "timer delay is <= 0")
--@end-debug@]===]
	local t = self.timers[func]
	if not t then
		t = new()
		t.args = new(...)
	end
	t.delay = delay
	t.repeating = delay
	self.timers[func] = t
	timerFrame:Show()
end

function z:SchedCancel(func)
	self.timers[func] = nil
	if not next(self.timers) then
		timerFrame:Hide()
		return
	end
end

-- GlobalCDSchedule
function z:GlobalCDSchedule()
	if (not InCombatLockdown()) then
		local when = self.globalCooldownEnd - GetTime() + 0.1
		if (when <= 0) then
			when = 0.1
		end
		self:Schedule(self.GlobalCooldownEnd, when, self)
	else
		self:SchedCancel(self.GlobalCooldownEnd)
	end
end

local HasIllusionBuff
do
	local worgIllusion = GetSpellInfo(43369)			-- Worg Disguise
	local murlocIllusion = GetSpellInfo(45278)			-- King Mrgl-Mrgl's Spare Suit

	function HasIllusionBuff()
		return UnitAura("player", worgIllusion) or UnitAura("player", murlocIllusion)
	end
end

local invisibility = GetSpellInfo(32612)
local shadowmeld = GetSpellInfo(58984)

-- CheckMounted
function z:CheckMounted()
	if (self.checkMountedCounter and self.checkMountedCounter > 0) then
		self.checkMountedCounter = self.checkMountedCounter - 1
		self:Schedule(self.CheckMounted, 0.2, self)
	end

	if (not InCombatLockdown()) then
		local m = IsMounted()
		if (self.mounted ~= m) then
			self.mounted = m

			self.checkMountedCounter = nil
			self:SetupForSpell()
			if (m) then
				if (ZOMGSelfBuffs) then
					ZOMGSelfBuffs:CheckBuffs()
				end
			else
				self:RequestSpells()
			end
			return
		end
	end
end

-- StartCheckMounted
function z:StartCheckMounted()
	if (not InCombatLockdown()) then
		-- self:Printf("UNIT_AURA - z.mounted = "..tostring(z.mounted)..", IsMounted() = "..tostring(IsMounted()))
		if (not IsMounted()) then
			-- Nasty hack, because IsMounted() does not work immediately after
			-- the player gains a mount buff, as it did with PLAYER_AURAS_CHANGED
			-- Currently, there are no events fired when IsMounted() is toggled on
			-- Might have to do an OnUpdate check
			self:Schedule(self.CheckMounted, 0.2, self)
			self.checkMountedCounter = 4
		else
			self:SchedCancel(self.CheckMounted)
		end
		self:CheckMounted()
		self:CheckForChange(self)
	end
end

-- CanCheckBuffs
function z:CanCheckBuffs(allowCombat, soloBuffs)
	lastCheckFail = nil
	local icon, icontex
	local p = self.db.profile

	if (self.atVendor) then
		return false, L["Selling"]
	elseif (self.atTrainer) then
		return false, L["Training"]
	elseif (self.rosterInvalid and not soloBuffs) then
		return false, "Waiting for RosterLib update"
	elseif (self.zoneFlag and self.zoneFlag > GetTime() - 5) then
		return false, L["ZONED"]
	elseif (UnitIsDeadOrGhost("player")) then
		lastCheckFail = L["DEAD"]
		icon = "skull"
	elseif (not self.icon) then
		lastCheckFail = L["ERRORICON"]
	elseif (not p.enabled) then
		lastCheckFail = L["DISABLED"]
		icon = "disabled"
	elseif (UnitOnTaxi("player")) then
		lastCheckFail = L["TAXI"]
		icon = "flying"
	elseif (UnitInVehicle("player")) then
		lastCheckFail = L["VEHICLE"]
		icon = "flying"
	elseif (InCombatLockdown() and not allowCombat) then
		lastCheckFail = L["COMBAT"]
		icon = "combat"
	elseif (HasIllusionBuff()) then		-- (UnitExists("pet") and (UnitIsCharmed("pet") or UnitIsPlayer("pet"))) or
		lastCheckFail = L["REMOTECONTROL"]
		icon = "remote"
	elseif (UnitIsCharmed("player")) then
		lastCheckFail = L["NOCONTROL"]
		icon = "nocontrol"
	elseif (IsStealthed() and p.notstealthed) then
		lastCheckFail = L["STEALTHED"]
		icon = "stealth"
	elseif (UnitBuff("player", invisibility)) then
		lastCheckFail = L["INVIS"]
		icon = "icon"
		icontex = select(3, GetSpellInfo(32612))
	elseif (UnitBuff("player", shadowmeld)) then
		lastCheckFail = L["SHADOWMELD"]
		icon = "icon"
		icontex = select(3, GetSpellInfo(58984))
	elseif (GetShapeshiftForm() > 0 and (playerClass == "DRUID" or playerClass == "SHAMAN") and p.notshifted) then
		lastCheckFail = L["SHAPESHIFTED"]
		icon = "icon"
		icontex = GetShapeshiftFormInfo(GetShapeshiftForm())
	elseif (self.icon:GetAttribute("spell") or self.icon:GetAttribute("item")) then
		return false, "Already have an icon"
	elseif (self.globalCooldownEnd > GetTime()) then
		self:GlobalCDSchedule()
		return false, "Waiting for global cooldown"
	end

	if (not lastCheckFail and not InCombatLockdown()) then
		if (IsResting() and p.notresting and not (p.restingpvp and UnitIsPVP("player"))) then
			lastCheckFail = L["RESTING"]
			icon = "resting"
		elseif ((IsMounted() or IsFlying()) and p.notmounted) then
			lastCheckFail = L["MOUNTED"]
			icon = "mounted"
		elseif (self:UnitHasBuff("player", 46755)) then		-- Drink
			lastCheckFail = L["DRINKING"]
			icon = "drink"
		elseif (self:UnitHasBuff("player", 46898)) then		-- Food
			lastCheckFail = L["EATING"]
			icon = "food"
		elseif (UnitChannelInfo("player")) then
			lastCheckFail = L["CHANNELING"]
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo("player")
			icon = "icon"
			icontex = texture
		elseif (self.db.char.minmana > 0) then
			local mana, manamax = UnitPower("player", SPELL_POWER_MANA), UnitPowerMax("player", SPELL_POWER_MANA)
			if (mana / manamax * 100 < self.db.char.minmana) then
				lastCheckFail = L["MANA"]
				icon = "mana"

				self:RegisterEvent("UNIT_POWER")
			end
		end
	end

	self:SetStatusIcon(icon, icontex)

	if (not lastCheckFail) then
		self:UnregisterEvent("UNIT_POWER")
	end

	return not lastCheckFail, lastCheckFail
end

-- SetStatusIcon
function z:SetStatusIcon(t, spellIcon)
	if (not self.icon) then
		return
	end

	local coords, status

	if (t == "skull") then
		status = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"

	elseif (t == "resting") then
		status = "Interface\\CharacterFrame\\UI-StateIcon"
		coords = new(0, 0.5, 0, 0.49)

	elseif (t == "combat") then
		status = "Interface\\CharacterFrame\\UI-StateIcon"
		coords = new(0.5, 1, 0, 0.49)

	elseif (t == "flying") then
		status = "Interface\\Icons\\Ability_Mount_Wyvern_01"
		coords = new(0.05, 0.95, 0.05, 0.95)

	elseif (t == "vehicle") then
		status = "Interface\\Icons\\Ability_Mount_Wyvern_01"

	elseif (t == "mounted") then
		status = "Interface\\Icons\\Ability_Mount_Wyvern_01"
		coords = new(0.05, 0.95, 0.05, 0.95)

	elseif (t == "mana") then
		status = "Interface\\Icons\\INV_Potion_76"

	elseif (t == "drink") then
		status = "Interface\\Icons\\INV_Drink_07"

	elseif (t == "food") then
		status = "Interface\\Icons\\INV_Drink_07"

	elseif (t == "remote") then
		status = select(3, GetSpellInfo(45112))			-- Mind Control

	elseif (t == "nocontrol") then
		status = "Interface\\Icons\\Ability_Rogue_BloodyEye"

	elseif (t == "stealth") then
		status = "Interface\\Icons\\Ability_Stealth"

	elseif (t == "icon") then
		status = spellIcon
		spellIcon = nil

	elseif (z.waitingForRaid) then
		status = "Interface\\Addons\\ZOMGBuffs\\Textures\\Clock"
	end

	if (not spellIcon) then
		local icon
		if (self.db.profile.enabled) then
			icon = "Interface\\AddOns\\ZOMGBuffs\\Textures\\Icon"
		else
			icon = "Interface\\AddOns\\ZOMGBuffs\\Textures\\IconOff"
		end
		self:SetMainIcon(icon)

		local icon = self:GetMainIcon()
		if (self.db.char.classIcon) then
			local i = classIcons[playerClass]
			if (not i) then
				self.icon.name:Hide()
			else
				icon = i
				if (self.db.profile.iconname) then
					self.icon.name:Show()
				end
				if (self.db.profile.enabled) then
					self.icon.tex:SetVertexColor(1, 1, 1)
					self.icon.tex:SetDesaturated(nil)
					self.icon.name:SetDesaturated(nil)
				else
					self.icon.name:SetDesaturated()
					if (not self.icon.tex:SetDesaturated()) then
						self.icon.tex:SetVertexColor(0.5, 0.5, 0.5)
					end
				end
			end
		end

		self.icon.tex:SetTexture(icon)

		if (status and self.icon.tex:IsShown()) then
			self.icon.status:SetTexture(status)
			self.icon.status:Show()

			if (coords) then
				self.icon.status:SetTexCoord(unpack(coords))
				del(coords)
			else
				self.icon.status:SetTexCoord(0, 1, 0, 1)
			end
		else
			self.icon.status:Hide()
		end
	else
		self.icon.name:Hide()
		self.icon.tex:SetTexture(spellIcon)
		self.icon.status:Hide()
	end
end

-- Set1CellAttr
local cellAttributeChanges = nil
local function Set1CellAttr(self, k, v)
	if (self:GetAttribute(k) ~= v) then
		if (InCombatLockdown() and not z.canChangeFlagsIC) then		-- canChangeFlagsIC is active during a cells creation, the only valid time we can change attr in combat
			local unit = self:GetAttribute("unit")
			local name = unit and UnitName(unit)

			if (name) then
				if (not cellAttributeChanges) then
					cellAttributeChanges = new()
				end
				if (not cellAttributeChanges[name]) then
					cellAttributeChanges[name] = new()
				end
				cellAttributeChanges[name][k] = v
			end

			return true			-- true = invalid for the moment until out of combat
		else
			self:SetAttribute(k, v)
			if (not self.attr) then
				self.attr = new()
			end
			self.attr[k] = v
		end
	end
end

-- SetACellSpell
function z:SetACellSpell(cell, m, b, spell)
	if (b) then
		local mod = m or ""
		local spellType = spell and "spell"
		local i1 = Set1CellAttr(cell, mod.."type"..b, spellType)
		local i2 = Set1CellAttr(cell, mod.."spell"..b, spell)
		cell.invalidAttributes = (i1 or i2) and spell
	end
end

-- ClearClickSpells
function z:ClearClickSpells(cell)
	if (cell and cell.attr) then
		cell.invalidAttributes = nil
		if (not InCombatLockdown()) then
			-- If in combat, then unit is probably nil and we'll clear the cell when we need this cell again anyway
			for key,action in pairs(cell.attr) do
				if (Set1CellAttr(cell, key, nil)) then
					cell.invalidAttributes = L["Empty"]
				end
				cell.attr[key] = nil
			end
		end
	end
end

-- IsSpellReady
function z:IsSpellReady()
	return self.icon:GetAttribute("*type*") ~= nil
end

-- SetupForSpell
function z:SetupForSpell(unit, spell, mod, reagentCount)
	local icon = self.icon
	if (not icon) then
		return
	end
	if (spell) then
		if (icon:GetAttribute("spell") or self.icon:GetAttribute("item")) then
			return
		end
	end

	if (icon:GetAttribute("*type*") ~= spell and "spell") then
		icon:SetAttribute("*type*", spell and "spell")
	end
	if (icon:GetAttribute("spell") ~= spell) then
		icon:SetAttribute("spell", spell)
	end
	if (icon:GetAttribute("unit") ~= unit) then
		icon:SetAttribute("unit", unit)
	end
	if (icon:GetAttribute("item") ~= nil) then
		icon:SetAttribute("item", nil)
	end
	if (icon:GetAttribute("target-slot") ~= nil) then
		icon:SetAttribute("target-slot", nil)
	end

	icon.mod = mod or icon.mod
	icon.castTimeToGCD = castTime
	icon.autospell = nil

	if (spell) then
		if (reagentCount) then
			self.icon.count:SetText(reagentCount)
			self.icon.count:Show()
		else
			self.icon.count:Hide()
		end
		self:SetStatusIcon(t, mod:GetSpellIcon(spell))
		if (self.db.profile.iconswirl) then
			self.icon.auto:Show()
		else
			self.icon.auto:Hide()
		end
	else
		self:ClearNotice()
		self:SetStatusIcon()
		self.icon.auto:Hide()
		self.icon.count:Hide()
		--if (ZOMGSelfBuffs) then
		--	ZOMGSelfBuffs.activeEnchant = nil
		--end
	end
end

-- SetupForSpell
function z:SetupForItem(slot, item, mod, spell, castTime)
	local icon = self.icon
	if (item or spell) then
		if (icon:GetAttribute("spell") or icon:GetAttribute("item")) then
			return
		end
	end

	icon:SetAttribute("*type*", item and "item" or spell and "spell")
	icon:SetAttribute("item", item)
	icon:SetAttribute("target-slot", slot)
	icon:SetAttribute("spell", spell)
	icon:SetAttribute("unit", nil)
	icon.mod = mod or icon.mod
	icon.autospell = nil
	icon.castTimeToGCD = castTime

	if (item) then
		local itemName, itemString, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(item)
		self:SetStatusIcon(nil, itemTexture)
		if (self.db.profile.iconswirl) then
			icon.auto:Show()
		else
			icon.auto:Hide()
		end

		local reagentCount = GetItemCount(item)
		if (reagentCount) then
			icon.count:SetText(reagentCount)
			icon.count:Show()
		else
			icon.count:Hide()
		end
	elseif (spell) then
		self:SetStatusIcon(nil, mod:GetSpellIcon(spell))
		if (self.db.profile.iconswirl) then
			icon.auto:Show()
		else
			icon.auto:Hide()
		end
		icon.count:Hide()
	else
		self:ClearNotice()
		self:SetStatusIcon()
		icon.auto:Hide()
		icon.count:Hide()
		--if (ZOMGSelfBuffs) then
		--	ZOMGSelfBuffs.activeEnchant = nil
		--end
	end
end

-- SetSort
function z:SetSort(show)
	if (z.db.char.sort == "CLASS") then
		self.members:SetAttribute("sortMethod", "NAME")
		self.members:SetAttribute("groupingOrder", table.concat(classOrder, ","))
		self.members:SetAttribute("groupBy", "CLASS")

	elseif (z.db.char.sort == "ALPHA") then
		self.members:SetAttribute("sortMethod", "NAME")
		self.members:SetAttribute("groupBy", nil)
		self.members:SetAttribute("groupingOrder", nil)

	elseif (z.db.char.sort == "GROUP") then
		self.members:SetAttribute("sortMethod", nil)
		self.members:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
		self.members:SetAttribute("groupBy", "GROUP")

	else
		self.members:SetAttribute("sortMethod", nil)
		self.members:SetAttribute("groupBy", nil)
		self.members:SetAttribute("groupingOrder", nil)
	end

	if (show) then
		self:OptionsShowList()
		z:DrawGroupNumbers()
	end
end

-- CreateAutoCast
function z:CreateAutoCast(icon)
	local a = CreateFrame("Frame", nil, icon)
	a:Hide()
	a:SetAllPoints()
	a.tex = {}
	for i = 1,2 do
		a.tex[i] = a:CreateTexture(nil, "OVERLAY")
		a.tex[i]:SetTexture("Interface\\BUTTONS\\UI-AutoCastableOverlay")
		a.tex[i]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		a.tex[i]:SetAllPoints()

		local g = a.tex[i]:CreateAnimationGroup()
		a.tex[i].anim = g
		local r = g:CreateAnimation("Rotation")
		g.rotate = r

		r:SetDuration(4 + i * 0.5)
		r:SetDegrees(i == 1 and 360 or -360)
		r:SetOrigin("CENTER", 0, 0)
		g:SetLooping("REPEAT")
	end
	a:SetScript("OnShow",
		function(self)
			for i,tex in ipairs(self.tex) do
				tex.anim:Play()		-- Bugfix for animations getting hidden (still in WoW 3.1.1a)
				tex.anim:Stop()
				tex.anim:Play()
			end
		end
	)
	return a
end

-- z:OnStartup
function z:OnStartup()
	local icon = CreateFrame("Button", "ZOMGBuffsButton", UIParent, "SecureUnitButtonTemplate,SecureHandlerEnterLeaveTemplate,ActionButtonTemplate")

	local LibButtonFacade = LibStub("LibButtonFacade",true)
	if (LibButtonFacade) then
		if (self.db.char.ButtonFacade) then
			LibButtonFacade:Group("ZOMGBuffs", "Buffs"):Skin(unpack(self.db.char.ButtonFacade))
		end
		LibButtonFacade:RegisterSkinCallback("ZOMGBuffs",
			function(_, skin, glossAlpha, gloss, _, _, colors)
				local db = self.db.char
				local bf = db.ButtonFacade
				if (bf) then		-- Don't create lots of tables. ever!
					bf[1] = skin
					bf[2] = glossAlpha
					bf[3] = gloss
					bf[4] = colors
				else
					db.ButtonFacade = {skin, glossAlpha, gloss, colors}
				end
			end
		)

		LibButtonFacade:Group("ZOMGBuffs", "Buffs"):AddButton(icon)
	end

	self:UpdateListWidth()

	self.icon = icon
	icon:SetClampedToScreen(true)
	icon:SetHeight(32)
	icon:SetWidth(32)
	icon.tex = ZOMGBuffsButtonIcon
	icon.tex:SetTexture("Interface\\AddOns\\ZOMGBuffs\\Textures\\Icon")
	icon:SetPoint("CENTER")
	icon:SetMovable(true)
	icon:RegisterForClicks("AnyUp")

	icon.name = icon:CreateTexture(nil, "OVERLAY")
	icon.name:SetAllPoints()
	icon.name:SetTexture("Interface\\AddOns\\ZOMGBuffs\\Textures\\IconText")

	icon.status = icon:CreateTexture(nil, "OVERLAY")
	icon.status:SetPoint("BOTTOMRIGHT", -1, 1)
	icon.status:SetWidth(18)
	icon.status:SetHeight(18)
	icon.status:Hide()

	icon.auto = self:CreateAutoCast(icon)

	icon.count = icon:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	icon.count:Hide()
	icon.count:SetPoint("TOPLEFT")
	icon.count:SetPoint("BOTTOMRIGHT", -2, 2)
	icon.count:SetJustifyH("RIGHT")
	icon.count:SetJustifyV("BOTTOM")

	icon:SetScript("OnDragStart",
		function(self)
			if (not z.db.char.iconlocked) then
				self:StartMoving()
			end
		end)
	icon:SetScript("OnDragStop",
		function(self)
			self:StopMovingOrSizing()
			z.db.profile.pos = z:GetPosition(self)
		end)
	icon:HookScript("OnEnter", IconOnEnter)
	icon:HookScript("OnLeave", IconOnLeave)
	icon:HookScript("OnClick",
		function(self, button)
			local command
			if (z.db.profile.mousewheel) then
				command = GetBindingAction(button)
			elseif (z.db.profile.keybinding) then
				command = GetBindingAction(z.db.profile.keybinding)
			end
			if (command) then
				pcall(RunBinding, command)
			end

			if (self:GetAttribute("*type*")) then
				z.clickCast = true
				z.clickList = nil

				if (z.noticeWindow) then
					z.noticeWindow:Hide()
				end

				z.globalCooldownEnd = GetTime() + (self.castTimeToGCD or 1.5)
				--if (ZOMGSelfBuffs) then
				--	ZOMGSelfBuffs.activeEnchant = nil
				--end
				z:GlobalCDSchedule()

				z:SetupForSpell()
			end
		end)

	icon.UpdateTooltip = IconOnEnter

	icon:RegisterForDrag("LeftButton")

	icon:SetAttribute("_onenter", [[
			local list = self:GetFrameRef("list")
			if (list) then
				list:Show()
			end
		]])
	icon:SetAttribute("_onleave", [[
			local list = self:GetFrameRef("list")
			if (list and not list:IsUnderMouse(true) and not self:IsUnderMouse(true)) then
				list:Hide()
			end
		]])

	local members = CreateFrame("Frame", "ZOMGBuffsList", icon, "SecureRaidGroupHeaderTemplate")
	members:Hide()
	self.members = members
	self:SetVisibilityOption()
	members:UnregisterEvent("UNIT_NAME_UPDATE")				-- Fix for that old lockup issue
	members:SetClampedToScreen(true)
	members:SetClampRectInsets(0, 8, z.db.profile.height, 0)
	members:SetWidth(z.totalListWidth or self.db.profile.width)
	members:SetHeight(self.db.profile.height)
	members:SetFrameStrata("DIALOG")

	icon:SetFrameRef("list", members)				-- So the icon can access the list via GetFrameRef shown above

	members:HookScript("OnShow", function(self) z:DrawGroupNumbers() z:RegisterEvent("MODIFIER_STATE_CHANGED") end)
	members:HookScript("OnHide", function(self) z:UnregisterEvent("MODIFIER_STATE_CHANGED") end)

	self.onLeaveFuncString = [[
			local list = self:GetParent()
			if (list and not list:IsUnderMouse(true) and not list:GetParent():IsUnderMouse(true)) then
				list:Hide()
			end
		]]

	members.InitialConfigFunction = function(self, frame)
		if not frame then
			frame = self[#self]
		else
			self[#self+1] = frame
		end
		-- This gets queued if in combat
		z:SetTargetClick(frame)
		z:InitCell(frame)

		-- Get initial list item spell, doesn't work in combat :(
		-- z.canChangeFlagsIC = true
		z:UpdateOneCellSpells(frame)
		-- z.canChangeFlagsIC = nil

		if (not InCombatLockdown()) then
			frame.wrapped = true
			SecureHandlerWrapScript(frame, "OnEnter", members, "")
			SecureHandlerWrapScript(frame, "OnLeave", members, z.onLeaveFuncString)
		end
	end

	members:SetAttribute("cellWidth", z.totalListWidth or z.db.profile.width)
	members:SetAttribute("cellHeight", z.db.profile.height)
	members:SetAttribute("template", "SecureUnitButtonTemplate")
	members:SetAttribute("sortMethod", "NAME")
	members:SetAttribute("initialConfigFunction",
	[[
	local header = self:GetParent()
	header:CallMethod("InitialConfigFunction")
	self:SetWidth(header:GetAttribute("cellWidth"))
	self:SetHeight(header:GetAttribute("cellHeight"))
	]])

	WorldFrame:HookScript("OnMouseDown", function()
		if (not InCombatLockdown()) then
			z.members:Hide()
		end
	end)

	self:SetAnchors()

	if (not InCombatLockdown()) then
		self.members:Show()
		self.members:Hide()
	end

	self.OnStartup = nil
end

-- SetTargetClick
function z:SetTargetClick(cell, secure)
	local targetMod, targetButton = self:GetActionClick("target")
	if (targetButton) then
		targetMod = targetMod or ""

		-- TODO: *typeN for target if nothing else on that button
		if (secure) then
			cell:SetAttribute(targetMod.."type"..targetButton, "target")
			local key = targetMod.."type"..targetButton
			if (not cell.attr) then
				cell.attr = new()
			end
			cell.attr[key] = "target"
		else
			Set1CellAttr(cell, targetMod.."type"..targetButton, "target")
		end
	end
end

-- SetVisibilityOption
function z:SetVisibilityOption()
	if (not InCombatLockdown()) then
		self.members:SetAttribute("showRaid", self.db.profile.showRaid)					-- So it works for raid group
		self.members:SetAttribute("showParty", self.db.profile.showParty)				-- So it works in a party
		self.members:SetAttribute("showPlayer", self.db.profile.showParty)				-- So it works for self in party
		self.members:SetAttribute("showSolo", self.db.profile.showSolo)					-- So it works when solo
	end
end

-- SayWhatWeDid
function z:SayWhatWeDid(spell, name, rank)
	if (self.icon.mod and self.icon.mod.SayWhatWeDid) then
		self.icon.mod:SayWhatWeDid(self.icon, spell, name, rank)
	end
end

-- onAttrChanged
local function onCellAttrChanged(self, name, value)
	if (name == "unit") then
		-- Maintain a unitid -> unit frame table
		for k,v in pairs(FrameArray) do
			if (v == self) then
				FrameArray[k] = nil
				break
			end
		end
		self.partyid = value
		if (value) then
			FrameArray[value] = self
		end

		if (value) then
			if (self.lastID ~= value or self.lastName ~= UnitName(value)) then
				self.lastID = value
				self.lastName = UnitName(value)

				self:DrawCell()

				z:UpdateOneCellSpells(self)
			end
		else
			if (cellAttributeChanges and self.lastName) then
				cellAttributeChanges[self.lastName] = deepDel(cellAttributeChanges[self.lastName])
			end

			z:ClearClickSpells(self)

			self.lastID = nil
			self.lastName = nil
		end
	end
end

local defaultColour = {r = 0.5, g = 0.5, b = 1}
function z:GetClassColour(class)
	return (class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]) or defaultColour
end

-- z:SetAllBarSizes()
function z:SetAllBarSizes()
	self:UpdateListWidth()
	if (AllFrameArray and not InCombatLockdown() and self.members) then
		local w = self.totalListWidth or self.db.profile.width
		local h = self.db.profile.height

		self.members:SetClampRectInsets(0, 8, h, 0)

		for k,v in pairs(AllFrameArray) do
			v:SetHeight(h)
			v:SetWidth(w)

			if (btr) then
				btr:CheckTickColumns(v)
			end

			for i,icon in pairs(v.buff) do
				icon:SetWidth(h)
				icon:SetHeight(h)
			end
			v.bar:ClearAllPoints()
			if (#z.buffs == 0) then
				v.bar:SetPoint("TOPLEFT")
			else
				v.bar:SetPoint("TOPLEFT", v.buff[#z.buffs], "TOPRIGHT")
			end
			v.bar:SetPoint("BOTTOMRIGHT")
		end
	end
end

-- PeriodicListCheck
function z:PeriodicListCheck()
	local any
	for unitid,frame in pairs(FrameArray) do
		local highlight, rebuffer
		for name, module in self:IterateModules() do
			if (module.RebuffQuery) then
				rebuffer = true
				if (module:IsModuleActive()) then
					if (module:RebuffQuery(unitid)) then
						highlight = true
						any = true
						break
					end
				end
			end
		end

		local c = self:GetClassColour(select(2, UnitClass(unitid)))
		if (not highlight or not rebuffer) then
			frame.name:SetTextColor(c.r / 3, c.g / 3, c.b / 3)
		else
			frame.name:SetTextColor(c.r, c.g, c.b)
		end
	end

	if (any and self.db.profile.iconswirl) then
		self.icon.auto:Show()
	else
		self.icon.auto:Hide()
	end
end

-- IsFlaskOrPot
local findFlask = L["FIND_FLASK"]
local findPot = L["FIND_POT"]
local function IsFlaskOrPot(name, icon)
	if (strfind(name, findFlask) or strfind(name, findPot)) then
		return true
	end
	return strfind(icon, "INV_Potion_")
end

-- DrawCell(self)
local function DrawCell(self)
	local partyid = self:GetAttribute("unit")		-- self.partyid
	if (not partyid or not UnitExists(partyid)) then
		return
	end

	local onAlpha, offAlpha
	if (z.db.profile.invert) then
		onAlpha = 0.2
		offAlpha = 1
	else
		onAlpha = 1
		offAlpha = 0.2
	end

	local unitname = UnitName(partyid)
	local class = select(2, UnitClass(partyid))
	local c = z:GetClassColour(class)

	if (z.db.char.sort == "CLASS") then
		self.groupMarker:Show()
		self.groupMarker:SetVertexColor(c.r, c.g, c.b)
	else
		local id = strmatch(partyid, "^raid(%d+)$")
		if (id) then
			local _, _, group = GetRaidRosterInfo(tonumber(id))
			self.groupMarker:Show()
			self.groupMarker:SetVertexColor(unpack(z.groupColours[group]))
		else
			self.groupMarker:Hide()
		end
	end

	local got, need = 0, 0
	for j,icon in ipairs(self.buff) do
		icon.spellName = nil
		local b = z.buffs[j]
		if (not b) then
			icon:SetTexture(nil)
		else
			if (UnitIsDeadOrGhost(partyid) or not UnitIsConnected(partyid)) then
				icon:SetTexture(nil)
			else
				if (b.manaOnly and not z.manaClasses[class]) then
					icon:SetTexture(nil)
				else
					if (b.type == "FLASK") then
						local oldPot = z.oldPots and z.oldPots[unitname]
						if (oldPot) then
							icon:SetTexture(oldPot)
							icon:Show()
							icon:SetAlpha(offAlpha)
						else
							icon:SetTexture(nil)
						end
					else
						if (b.icon) then
							icon:SetTexture(b.icon)
						end
						icon:Show()
						icon:SetAlpha(offAlpha)
					end
					need = need + 1
				end

			end
		end
	end

	local myMax, myEnd

	if (btr) then
		btr:CheckTickColumns(self)
	end

	if (not UnitIsDeadOrGhost(partyid) and UnitIsConnected(partyid)) then
		for i = 1,40 do
			local name, rank, tex, count, _, maxDuration, endTime, caster = UnitBuff(partyid, i)
			if (not name) then
				break
			end

			if ((caster == "player" or z.overrideBuffBar) and maxDuration and maxDuration > 0 and (not myMax or myMax > maxDuration)) then
				if (z:ShowBuffBar(self, name, tex)) then
					myMax, myEnd, mySource = maxDuration, endTime, caster
				end
			end

			for j,icon in pairs(self.buff) do
				local buff = z.buffs[j]
				if (buff) then
					if (not buff.manaOnly or z.manaClasses[class]) then
						if (buff.list and buff.list[name]) or (z.buffTypes[buff.type] and z.buffTypes[buff.type][name]) then
							icon:Show()
							icon:SetAlpha(onAlpha)
							icon:SetTexture(tex)			-- TEST
							icon.spellName = name
							got = got + 1
						elseif (buff.type == "FLASK") then
							if (IsFlaskOrPot(name, tex)) then
								if (not z.oldPots) then
									z.oldPots = new()
								end
								z.oldPots[unitname] = tex
								icon:SetTexture(tex)
								icon:Show()
								icon:SetAlpha(onAlpha)
								got = got + 1
							end
						end
					end
				end
			end
		end
	end

	local bar = self.bar
	if (myMax) then
		local now = GetTime()
		local startTime = myEnd - myMax
		local endTime = myEnd
		bar:SetMinMaxValues(startTime, endTime)
		bar:SetValue(endTime - now)
		bar:SetScript("OnUpdate", CellBarOnUpdate)
		if (z.db.profile.bufftimer) then
			bar.timer:Show()
			bar.timer:SetScale(z.db.profile.bufftimersize)
		else
			bar.timer:Hide()
		end
	else
		bar.timer:Hide()
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0)
		bar:SetScript("OnUpdate", nil)
	end

	local highlight, rebuffer
	for modname, module in z:IterateModules() do
		if (module.RebuffQuery) then
			rebuffer = true
			if (module:IsModuleActive()) then
				if (module:RebuffQuery(partyid)) then
					highlight = true
					break
				end
			end
		end
	end

	-- Wierdo check for UnitInParty/Raid here because of a bug with GetPartyAssignment that spams
	-- system messages during zoning for people that ARE in your party/raid
	local icon
	if (z.db.profile.showroles and not z.zoneFlag) then
		--if (select(2, IsInInstance()) == "party") then
			-- No point getting it otherwise, as they can be wrong. Usually the values you had
			-- from previous instance if you're running more than one with the same people
			local role = UnitGroupRolesAssigned(partyid)
			if (role == "TANK") then
				icon = "|TInterface\\GroupFrame\\UI-Group-MainTankIcon:0|t"
			elseif (role == "HEALER") then
				icon = "|TInterface\\Addons\\ZOMGBuffs\\Textures\\RoleHealer:0|t"
			elseif (role == "DAMAGER") then
				icon = "|TInterface\\GroupFrame\\UI-Group-MainAssistIcon:0|t"
			end

		--else
		--	if (GetPartyAssignment("MAINTANK", partyid)) then
		--		icon = "|TInterface\\GroupFrame\\UI-Group-MainTankIcon:0|t"
		--	elseif (GetPartyAssignment("MAINASSIST", partyid)) then
		--		icon = "|TInterface\\GroupFrame\\UI-Group-MainAssistIcon:0|t"
		--	end
		--end
	end
	if (icon) then
		self.name:SetFormattedText("%s %s", unitname, icon)
	else
		self.name:SetText(unitname)
	end

	if (UnitIsConnected(partyid) and not UnitIsDeadOrGhost(partyid)) then
		if (self.invalidAttributes or not highlight or (not rebuffer and got >= need)) then
			self.name:SetTextColor(c.r / 3, c.g / 3, c.b / 3)
		else
			self.name:SetTextColor(c.r, c.g, c.b)
			if (InCombatLockdown()) then
				if (z.db.profile.iconswirl) then
					z.icon.auto:Show()
				else
					z.icon.auto:Hide()
				end
			end
		end
	else
		self.name:SetTextColor(0.4, 0.4, 0.4)
	end
end

-- GetBuffRoster
function z:GetBuffRoster()			-- TODO - remove after testing
	return self.buffRoster
end

-- ShowGroupNumber
function z:ShowGroupNumber(group, cell)
	if (not self.groupNumbers) then
		self.groupNumbers = new()
	end
	local no = self.groupNumbers[group]
	if (not no) then
		no = cell:CreateFontString(nil, "BORDER", "NumberFontNormal")
		no:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE")
		self.groupNumbers[group] = no
		no:SetJustifyH("LEFT")
	end

	no:SetParent(cell)
	no:ClearAllPoints()
	no:SetPoint("TOPLEFT", cell, "TOPRIGHT", 2, 0)
	no:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", 30, 0)

	no:SetText(group)
	no:SetTextColor(unpack(self.groupColours[group]))
	no:Show()
end

-- DrawGroupNumbers
function z:DrawGroupNumbers()
	if (self.members and self.groupColours) then
		if (self.groupNumbers) then
			for i = 1,8 do
				local no = self.groupNumbers[i]
				if (no) then
					no:Hide()
				end
			end
		end

		if (self.db.profile.groupno and self.db.char.sort == "GROUP") then
			local group = 0

			local list = new()
			for i = 1,40 do
				local name, rank, subgroup = GetRaidRosterInfo(i)
				if (name) then
					list[i] = subgroup
				else
					break
				end
			end

			-- We don't use RosterLib here because the group numebrs will get out of sync
			-- immediately after a group change until roster lib updates later
			for i = 1,40 do
				local cell = self.members:GetAttribute("child"..i)
				if (not cell) then
					break
				end

				local unitid = cell:GetAttribute("unit")
				if (unitid) then
					local idNumber = strmatch(unitid, "^raid(%d+)$")
					if (idNumber) then
						local no = list[tonumber(idNumber)]
						if (no and no > group) then
							group = list[tonumber(idNumber)]
							self:ShowGroupNumber(group, cell)
						end
					end
				end
			end

			del(list)
		end

		if (btr) then
			btr:CheckTickTitles(self.members)
		end

		-- Border
		local border = self.members.border
		if (self.db.profile.border) then
			local topChild = self.members:GetAttribute("child1")
			if (topChild) then
				if (not border) then
					border = self:CreateBorder(self.members)
					self.members.border = border
				end

				local bottomChild
				local i = 0
				repeat
					i = i + 1
					local unitButton = self.members:GetAttribute("child"..i)
					if (unitButton and unitButton:IsShown()) then
						bottomChild = unitButton
					end
				until not (unitButton)

				border:ClearAllPoints()
				border:SetPoint("TOPLEFT", topChild, "TOPLEFT", -5, 4)
				border:SetPoint("BOTTOMRIGHT", bottomChild, "BOTTOMRIGHT", 6, -4)

				border:Show()
			end
		else
			if (border) then
				self.members.border:Hide()
			end
		end
	end
end

-- UpdateOneCellSpells
function z:UpdateOneCellSpells(frame)
	self:ClearClickSpells(frame)
	self:SetTargetClick(frame)
	if (self.SetClickSpells) then
		self:SetClickSpells(frame)
	end

	if (self.members and not frame.wrapped) then
		if (not InCombatLockdown()) then
			frame.wrapped = true
			SecureHandlerWrapScript(frame, "OnEnter", self.members, "")
			SecureHandlerWrapScript(frame, "OnLeave", self.members, self.onLeaveFuncString)
		end
	end
end

-- UpdateCellSpells
function z:UpdateCellSpells()
	for unit,frame in pairs(FrameArray) do
		self:UpdateOneCellSpells(frame)
	end
end

-- TriggerClickUpdate
function z:TriggerClickUpdate(unit)
	local f = FrameArray[unit]
	if (f) then
		self:UpdateOneCellSpells(f)
	end
end

-- RegisterSetClickSpells
function z:RegisterSetClickSpells(mod, func)
	if (not z.SetClickSpells) then
		self.setClickSpellsList = {}
		function z:SetClickSpells(cell)
			for mod,func in pairs(self.setClickSpellsList) do
				func(mod, cell)
			end
		end
	end
	self.setClickSpellsList[mod] = func
end

-- GetSpellColour
function z:GetSpellColour(spellName)
	local colour
	for name, module in self:IterateModules() do
		if (module.GetSpellColour) then
			colour = module:GetSpellColour(spellName)
			if (colour) then
				return colour
			end
		end
	end
end

-- Shfit, Alt, Ctrl <--- order is important
do
	local leftModsDesc = {"", L["Shift-"], L["Alt-"], L["Ctrl-"]}
	local leftMods = {"", "shift-", "alt-", "ctrl-"}
	local combos = {"000", "010", "100", "001", "011", "110", "101", "111"}
	local rightModDesc = {L["Left Button"], L["Right Button"], L["Middle Button"], L["Button Four"], L["Button Five"]}
	rightModDesc["*"] = ""
	leftModsDesc["*"] = ""

	local function cellOrIconTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_"..(z.db.profile.anchor or "TOPLEFT"))

		local unit1 = self:GetAttribute("unit")
		local name = unit1 and UnitExists(unit1) and UnitName(unit1)

		if (unit1) then
			local c = z:GetClassColour(select(2, UnitClass(unit1)))
			GameTooltip:SetText(name or "", c.r, c.g, c.b)
		else
			GameTooltip:ClearLines()
		end

		local line = 1
		for rightMod = 1,5 do
			local lastSpell
			for ind,c in ipairs(combos) do
				local j = c:sub(1, 1) == "1" and 2 or 1
				local k = c:sub(2, 2) == "1" and 3 or 1
				local l = c:sub(3, 3) == "1" and 4 or 1
				local leftMod = format("%s%s%s", leftMods[j], leftMods[k], leftMods[l])

				local Type = self:GetAttribute(leftMod, "type", rightMod)
				if (not Type and self == z.icon) then
					Type = self:GetAttribute("*", "type", "*")
					if (Type) then
						leftMod = "*"
						rightMod = "*"
					end
				end
				if (Type) then
					local spell = self:GetAttribute(leftMod, "spell", rightMod)
					if (spell or Type == "target") then
						local unit = self:GetAttribute(leftMod, "unit", rightMod)
						if (spell ~= lastSpell or Type == "target") then
							local leftModDesc = format("%s%s%s", leftModsDesc[j], leftModsDesc[k], leftModsDesc[l])
							lastSpell = spell

							local match1 = tostring(strfind(leftMod, "ctrl-") and 1 or 0) .. tostring(strfind(leftMod, "shift-") and 1 or 0) .. tostring(strfind(leftMod, "alt-") and 1 or 0)
							local match2 = tostring(IsControlKeyDown() and 1 or 0) .. tostring(IsShiftKeyDown() and 1 or 0) .. tostring(IsAltKeyDown() and 1 or 0)

							local buttonColour = ((match1 == match2) and "|cFFFFFFFF") or "|cFF808080"

							local unitShow
							if (unit and unit ~= unit1) then
								unitShow = format(L[" on %s"], z:ColourUnit(unit))
							else
								unitShow = ""
							end

							if (spec and line == 1 and Type ~= "target") then
								GameTooltip:AddDoubleLine(" ", spec, nil, nil, nil, 0.5, 0.5, 0.5)
								spec = nil
							end

							local spellColour = z:GetSpellColour(spell) or "|cFFFFFF80"
							if (Type == "target") then
								if (spec and line == 1) then
									GameTooltip:AddDoubleLine(format(L["%s%s%s|r to target"], buttonColour, leftModDesc, rightModDesc[rightMod]), spec, nil, nil, nil, 0.5, 0.5, 0.5)
									spec = nil
								else
									GameTooltip:AddLine(format(L["%s%s%s|r to target"], buttonColour, leftModDesc, rightModDesc[rightMod]))
								end
							else
								--GameTooltip:AddLine(format(L["%s%s%s|r to cast %s%s|r%s"], buttonColour, leftModDesc, rightModDesc[rightMod], spellColour, spell, unitShow))
								GameTooltip:AddDoubleLine(format("%s%s%s|r", buttonColour, leftModDesc, rightModDesc[rightMod]),
														format("%s%s|r%s", spellColour, spell, unitShow))
							end
							line = line + 1
						end
					end
				end
				if (self == z.icon) then
					break
				end
			end
			if (self == z.icon) then
				break
			end
		end
	end

	-- IconOnEnter
	function IconOnEnter(self)
		cellOrIconTooltip(self)

		if (not z.db.profile.enabled) then
			GameTooltip:SetText(z.titleColour)
			GameTooltip:AddLine(L["Auto-casting is disabled"])
			GameTooltip:AddLine(L["You can re-enable it by single clicking the ZOMGBuffs minimap/fubar icon"])

		elseif (lastCheckFail) then
			if (GameTooltip:IsShown()) then
				GameTooltip:AddLine(" ")
			else
				GameTooltip:SetText(z.titleColour)
				GameTooltip:AddLine(L["Suspended"], 1, 1, 1)
			end
			GameTooltip:AddLine(format(L["Not Refreshing because %s"], lastCheckFail), nil, nil, nil, 1)
		elseif (z.waitingForRaid) then
	    	if (GameTooltip:IsShown()) then
	    		GameTooltip:AddLine(" ")
			else
				GameTooltip:SetText(z.titleColour)
			end

			if (z.waitingForRaid) then
	    		GameTooltip:AddLine(format(L["Waiting for %d%% of raid to arrive before buffing commences (%d%% currently present)"], z.db.profile.waitforraid * 100, z.waitingForRaid), nil, nil, nil, 1)
			end
		end

		if (not GameTooltip:IsShown()) then
			GameTooltip:SetText(z.titleColour)
		end

		GameTooltip:Show()
	end

	-- IconOnLeave
	function IconOnLeave()
		GameTooltip:Hide()
	end

	-- ShowBuffBar
	function z:ShowBuffBar(cell, spellName, tex)
		if (z.overrideBuffBar) then
			if (z.overrideBuffBar == "tick") then
				local btr = ZOMGBuffTehRaid
				if (btr) then
					local found = btr.lookup[spellName]
					local key = btr.tickColumns[z.overrideBuffBarIndex]
					if (found and found.type == key) then
						return true
					end
				end

			elseif (z.overrideBuffBar == "buff") then
				local buff = z.buffs[z.overrideBuffBarIndex]
				if (buff) then
					if (buff.type == "FLASK") then
						if (IsFlaskOrPot(spellName, tex)) then
							return true
						end
					else
						if (z.buffTypes[buff.type] and z.buffTypes[buff.type][spellName]) then
							return true
						end
					end
				end
			end
		else
			for name, module in z:IterateModules() do
				if (module.ShowBuffBar and module:ShowBuffBar(cell, spellName, tex)) then
					return true
				end
			end
		end
	end

	-- onUpdateIconMouseover
	local function onUpdateIconMouseover(self)
		if (not self.buff) then
			return
		end

		-- Get's mouse position within the cell and works out which icon we're pointing at
		local l, b, w, h = self:GetRect()
		local x, y = GetCursorPosition()
		x = x / UIParent:GetScale()
		y = y / UIParent:GetScale()

		if (x > l and x < l + w) then
			if (y > b and y < b + h) then
				local offset = x - l
				if (self.ticks) then
					for i = 1,#self.ticks do
						if (self.ticks[i]:IsShown()) then
							offset = offset - self.ticks[i]:GetWidth()
						end
					end
				end

				local index = 1 + floor(offset / self.buff[1]:GetWidth())
				if (index > 0) then
					if (index ~= z.mouseIndex) then
						z.mouseIndex = index
						local oldBar, oldIndex = z.overrideBuffBar, z.overrideBuffBarIndex

						if (index <= #z.buffs) then
							-- One of the normal icons (raid buffs, food, pots)
							z.overrideBuffBar = "buff"
							z.overrideBuffBarIndex = index
						else
							z.overrideBuffBar = nil
							z.overrideBuffBarIndex = nil
						end

						if (z.overrideBuffBar ~= oldBar or z.overrideBuffBarIndex ~= oldIndex) then
							z:DrawAllCells()
						end
					end
				end
			end
		end
	end

	-- CellOnEnter
	function CellOnEnter(self)
		z.mouseIndex = nil
		z.overrideBuffBar = nil
		z.overrideBuffBarIndex = nil

		self:SetScript("OnUpdate", onUpdateIconMouseover)
		cellOrIconTooltip(self)

		if (self.invalidAttributes) then
			GameTooltip:AddLine(format(L["Out-of-date spell (should be %s). Will be updated when combat ends"], self.invalidAttributes), 1, 0, 0, 1)
		end

		-- Disabled until LGT is fixed
		--if (self ~= z.icon) then
			--local unit = self:GetAttribute("unit")
			--local spec, s1, s2, s3 = LGT:GetUnitTalentSpec(unit)
			--if (spec) then
			--	local _, class = UnitClass(unit)
			--	if (class == "DEATHKNIGHT" or (class == "DRUID" and s2 > s1 + s3)) then
			--		local role = LGT:GetUnitRole(unit)
			--		spec = format("%s (%s)", spec, role == "tank" and TANK or DAMAGE)
			--	end

			--	GameTooltipTextRight1:SetText(spec)
			--	GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
			--	GameTooltipTextRight1:Show()
			--end
		--end

		GameTooltip:Show()
	end

	-- CellOnLeave
	function CellOnLeave(self)
		z.mouseIndex = nil
		z.overrideBuffBar = nil
		z.overrideBuffBarIndex = nil
		self:SetScript("OnUpdate", nil)
		GameTooltip:Hide()
	end
end

function CellOnMouseDown(self, button)
	z:CallMethodOnAllModules("CellOnMouseDown", self, button)
end

function CellOnMouseUp(self, button)
	if (InCombatLockdown()) then
		z.icon.auto:Hide()
	end
	z.clickCast = true
	z.clickList = true
end

-- CellBarOnUpdate
function CellBarOnUpdate(self, elapsed)
	local startTime, endTime = self:GetMinMaxValues()
	if (GetTime() >= endTime) then
		self:SetMinMaxValues(0, 1)
		self:SetValue(0)
		self:SetScript("OnUpdate", nil)
		self.timer:Hide()
	else
		local remaining = endTime - GetTime()
		self:SetValue(startTime + remaining)

		if (remaining <= z.db.profile.bufftimerthreshold) then
			self.timer.text:SetText(date("%M:%S", remaining):gsub("^0", ""))
			self.timer:Show()
		else
			self.timer:Hide()
		end
	end
end

-- InitCell
function z:InitCell(cell)
	tinsert(AllFrameArray, cell)

	cell:SetNormalTexture("Interface\\AddOns\\ZOMGBuffs\\Textures\\FrameBack")
	local t = cell:GetNormalTexture()
	cell.bg = t

	cell.groupMarker = cell:CreateTexture(nil, "BORDER")
	cell.groupMarker:SetTexture("Interface\\AddOns\\ZOMGBuffs\\Textures\\FrameBack")
	cell.groupMarker:Hide()
	cell.groupMarker:SetPoint("TOPLEFT", cell, "TOPRIGHT", 0, 0)
	cell.groupMarker:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", 2, 0)

	t:SetVertexColor(0, 0, 0, 1)
	t:SetDrawLayer("BORDER")
	t:SetDrawLayer("BORDER")
	cell:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight")

	cell:SetScript("OnEnter", CellOnEnter)
	cell:SetScript("OnLeave", CellOnLeave)
	cell:SetScript("OnMouseDown", CellOnMouseDown)
	cell:SetScript("OnMouseUp", CellOnMouseUp)
	cell:RegisterForClicks("AnyUp")
	--cell.UpdateTooltip = CellOnEnter

	local h = cell:GetHeight()
	local w = cell:GetWidth()

	local prev
	cell.buff = {}
	for i = 1,#self.allBuffs do
		local b = cell:CreateTexture(nil, "ARTWORK")
		b:SetHeight(z.db.profile.height)
		b:SetWidth(z.db.profile.height)

		if (i == 1) then
			b:SetPoint("TOPLEFT", 0, 0)
		else
			b:SetPoint("TOPLEFT", prev, "TOPRIGHT", 0, 0)
		end

		cell.buff[i] = b
		prev = b
	end

	local tex = self:GetBarTexture()

	cell.bar = CreateFrame("StatusBar", nil, cell)
	cell.bar:SetStatusBarTexture(tex)
	cell.bar:SetStatusBarColor(1, 1, 0.5, 0.5)
	cell.bar:SetMinMaxValues(0, 1)
	cell.bar:SetValue(0)
	if (#self.buffs == 0) then
		cell.bar:SetPoint("TOPLEFT")
	else
		cell.bar:SetPoint("TOPLEFT", cell.buff[#self.buffs], "TOPRIGHT")
	end
	cell.bar:SetPoint("BOTTOMRIGHT")

	local timer = CreateFrame("Frame", nil, cell.bar)
	cell.bar.timer = timer
	timer:SetScale(self.db.profile.bufftimersize)
	timer:SetPoint("RIGHT")
	timer:SetWidth(1)
	timer:SetHeight(1)
	timer.text = timer:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	timer.text:SetPoint("RIGHT")
	timer.text:SetJustifyH("RIGHT")

	local a, b, c = self:GetFont()
	cell.name = cell.bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	cell.name:SetFont(a, b, c)
	cell.name:SetPoint("TOPLEFT", 2, 0)
	cell.name:SetPoint("BOTTOMRIGHT")
	cell.name:SetJustifyH("LEFT")

	cell.DrawCell = DrawCell

	cell:SetScript("OnAttributeChanged", onCellAttrChanged)
	cell:SetScript("OnShow", DrawCell)
end

-- SecureCall
function z:SecureCall(f, s)
	if (InCombatLockdown()) then
		secureCalls[f] = s or self
	else
		local c = (s or self)[f]
		if (not c) then
			c = f
		end
		if (c) then
			c(s or self)
		end
	end
end

local dummy = CreateFrame("Frame")
dummy:Hide()
dummy:SetScript("OnUpdate",
	function(self)
		if (z.rosterInvalid) then
			z.rosterInvalid = nil
			z:OnRaidRosterUpdate()
		end
		self:Hide()
	end)

-- RAID_ROSTER_UPDATE
function z:RAID_ROSTER_UPDATE()
	self.unknownUnits = del(self.unknownUnits)
	self:UnregisterEvent("UNIT_NAME_UPDATE")

	self:DrawGroupNumbers()
	self.rosterInvalid = true
	dummy:Show()
end

-- OnRaidRosterUpdate
function z:OnRaidRosterUpdate()
	self:CheckStateChange()
	local delList = copy(z.versionRoster)
	local any

	self.classcount = setmetatable({}, {__index = function() return 0 end})
	for unit, unitname, unitclass, subgroup, index in self:IterateRoster() do
		if (unitname ~= UNKNOWN) then
			self.classcount[unitclass] = self.classcount[unitclass] + 1
			delList[unitname] = nil
			any = true
		end
	end
	self:SetBuffsList()

	if (any) then
		for name,ver in pairs(delList) do
			z.versionRoster[name] = nil
			if (z.oldPots) then
				z.oldPots[name] = nil
			end
			if (z.buffRoster) then
				z.buffRoster[name] = nil
			end
		end
	end

	if (GetNumGroupMembers() == 0) then
		deepDel(self.buffRoster)
		self.buffRoster = new()

		if (self.wasInGroup) then
			reqHistorySpec = {}
			reqHistoryCap = {}
			reqHistoryBT = {}
			reqHistoryHello = {}
			self.wasInGroup = nil
		end
	else
		if (not self.wasInGroup) then
			reqHistorySpec = {}
			reqHistoryCap = {}
			reqHistoryBT = {}
			reqHistoryHello = {}
			self.wasInGroup = true
		end
	end

	-- Roster changed, so trigger a check if nothing queued
	if (self.icon and self.icon:GetAttribute("*type*") == nil) then
		self:RequestSpells()
	end

	for name, module in self:IterateModules() do
		if (module.OnRaidRosterUpdate and module:IsModuleActive()) then
			module:OnRaidRosterUpdate()
		end
	end

	self.StartupDone = true
	self:UpdateCellSpells()
	if (self:UpdateListWidth()) then
		self:SetAllBarSizes()
	end

	del(delList)
end

-- UpdateListWidth
function z:UpdateListWidth()
	local old = self.totalListWidth
	-- Work out how wide the list will be in total. The width option now specifies the list of
	-- the name part only, the actual width varies based on how many icons will be shown
	if (not InCombatLockdown()) then
		local icons = 0
		icons = icons + #self.buffs

		self.totalListWidth = self.db.profile.width + icons * z.db.profile.height
		if (self.members) then
			self.members:SetWidth(self.totalListWidth)
			self.members:SetAttribute("cellWidth", self.totalListWidth)
		end
	else
		self.updateListWidthOOC = true
	end

	return self.totalListWidth ~= old
end

-- RegisterBuffer
function z:RegisterBuffer(mod, priority)
	-- Priority if not given will be next one in list
	if (not self.registeredBuffers) then
		self.registeredBuffers = {}
	end
	if (priority) then
		tinsert(self.registeredBuffers, 1, mod)
	else
		tinsert(self.registeredBuffers, mod)
	end
end

do
	local dummy = CreateFrame("Frame")
	dummy:Hide()
	dummy:SetScript("OnUpdate",
		function(self)
			z:RequestSpellsActual()
			self:Hide()
		end)

	-- z:RequestSpells()
	function z:RequestSpells()
		dummy:Show()
	end
end

-- RequestSpellsActual
function z:RequestSpellsActual()
	if (self.registeredBuffers) then
		for i,module in ipairs(self.registeredBuffers) do
			module:CheckBuffs()
			if (self.icon and self.icon:GetAttribute("*type*")) then
				break
			end
		end
	end
end

-- CheckForChange
-- Will re-request buffs if the icon currently has one that
-- belongs to the calling module, else it'll leave it alone
function z:CheckForChange(mod)
	if (self.icon) then
		if (not self.icon.mod or self.icon.mod == mod) then
			self:SetupForSpell()
			self.icon.castTimeToGCD = nil
			self:RequestSpells()
		elseif (not self.icon:GetAttribute("*type*")) then
			self:RequestSpells()
		end
	end
end

-- IsBlacklisted
function z:IsBlacklisted(name)
	local skip
	local failedRecently = self.blackList and self.blackList[name]
	if (failedRecently) then
		if (GetTime() > failedRecently) then		-- We failed a cast recently on this person
			self.blackList[name] = nil
		else
			return true
		end
	end
end

-- Blacklist
function z:Blacklist(name)
	if (UnitIsUnit(name, "player")) then
		return
	end

	if (not self.blackList) then
		self.blackList = {}
	end

	self.blackList[name] = GetTime() + 10			-- Flag player as un-castable for 10 seconds
	if (z.db.profile.info) then
		self:Printf(L["%s blacklisted for 10 seconds"], z:ColourUnitByName(name))
		self.globalCooldownEnd = GetTime() + (self.castTimeToGCD or 1.5)
		self:GlobalCDSchedule()
	end
end

-- AnyBlacklisted
function z:AnyBlacklisted()
	return self.blackList and next(self.blackList)
end

-- GlobalCooldownEnd()
function z:GlobalCooldownEnd()
	self:RequestSpells()
end

-- UNIT_AURA
function z:UNIT_AURA(e, unit)
	local u = FrameArray[unit]
	if (u) then
		u:DrawCell()
	end

	if (unit == "player") then
		if (self:UnitHasBuff("player", 46755) or self:UnitHasBuff("player", 46898)) then	-- Food/Drink
			self:SetupForSpell()
		else
			self:StartCheckMounted()
		end
	end
end

-- UNIT_SPELLCAST_SENT
function z:UNIT_SPELLCAST_SENT(e, player, spell, rank, targetName)
	if (player == "player") then
		local start, dur = GetSpellCooldown(spell)
		if (start and dur <= 1.5) then
			self.globalCooldownEnd = start + dur
		else
			self.globalCooldownEnd = GetTime() + 1.5
		end
		if (ZOMGSelfBuffs and ZOMGSelfBuffs.activeEnchantLoaded) then
			self.globalCooldownEnd = self.globalCooldownEnd + ZOMGSelfBuffs.activeEnchantLoaded
			ZOMGSelfBuffs.activeEnchantLoaded = nil
			if (spell == ZOMGSelfBuffs.lastEnchantSet) then
				ZOMGSelfBuffs.activeEnchant = GetTime()
			end
		end

		self.lastCastS = spell
		self.lastCastR = rank
		self.lastCastN = targetName
	end
end

-- UNIT_SPELLCAST_SUCCEEDED
function z:UNIT_SPELLCAST_SUCCEEDED(e, player, spell, rank)
	if (player == "player") then
		if (self.clickCast) then
			z:SayWhatWeDid(spell, self.lastCastN, rank)
		end

		local curIconSpell = self.icon:GetAttribute("spell")
		local curIconTarget = self.icon:GetAttribute("unit")
		if (curIconSpell == spell and curIconTarget and ((self.lastCastN == "" and curIconTarget == "player") or (self.lastCastN and UnitIsUnit(curIconTarget, self.lastCastN)))) then
			-- We lagged a lot apparently, and we've just cast the spell that's on the icon, so clear it and re-check
			self:SetupForSpell()
			self.globalCooldownEnd = GetTime() + 0.5
		end

		if (spell == self.lastCastS and rank == self.lastCastR) then
			for name, module in self:IterateModules() do
				if (module.SpellCastSucceeded and module:IsModuleActive()) then
					module:SpellCastSucceeded(self.lastCastS, self.lastCastR, self.lastCastN, not self.clickCast, self.clickList)
				end
			end
		end

		if (not InCombatLockdown()) then
			if (self.globalCooldownEnd > GetTime()) then
				self:GlobalCDSchedule()
			else
				if (self.icon and not self.icon:GetAttribute("*type*")) then
					self:RequestSpells()
				end
			end
		end

		self.lastCastS, self.lastCastR, self.lastCastN = nil, nil, nil
		self.clickCast = nil
		self.clickList = nil
	end
end

-- UNIT_SPELLCAST_FAILED
function z:UNIT_SPELLCAST_FAILED(e, player)
	if (player == "player") then
		self:CallMethodOnAllModules("SpellCastFailed", self.lastCastS, self.lastCastN, not self.clickCast)

		self.lastCastS, self.lastCastR, self.lastCastN = nil, nil, nil
		self.clickCast = nil
		self.clickList = nil

		self:Schedule(self.GlobalCooldownEnd, 0.5, self)
	end
end

-- UNIT_SPELLCAST_STOP
function z:UNIT_SPELLCAST_STOP(e, player, spell, rank)
	if (player == "player") then
		self.clickCast = nil
		self.clickList = nil
	end
end

-- PLAYER_REGEN_ENABLED
function z:PLAYER_REGEN_ENABLED()
	z.canChangeFlagsIC = nil
	if (cellAttributeChanges) then
		for unitid,cell in pairs(FrameArray) do
			local name = UnitName(unitid)
			if (name) then
				local attr = cellAttributeChanges[name]
				if (attr) then
					if (not cell.attr) then
						cell.attr = new()
					end
					for k,v in pairs(attr) do
						cell:SetAttribute(k, v)
						cell.attr[k] = v
					end
					cell.invalidAttributes = nil
				end
			end
		end
		cellAttributeChanges = deepDel(cellAttributeChanges)
	end

	for k,v in pairs(secureCalls) do
		if (v[k]) then
			v[k](v)
		end
		secureCalls[k] = nil
	end
	if (buffClass) then
		self:SchedCancel(self.PeriodicListCheck)
		self.icon.auto:Hide()
	end
	self:RequestSpells()

	for name, module in self:IterateModules() do
		if (module.OnRegenEnabled and module:IsModuleActive()) then
			module:OnRegenEnabled()
		end
	end

	if (self.updateListWidthOOC) then
		self.updateListWidthOOC = nil
		self:UpdateListWidth()
	end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- PLAYER_REGEN_DISABLED
function z:PLAYER_REGEN_DISABLED()
	self:SchedCancel(HideMeLaterz)
	self:SetupForSpell()
	if (buffClass) then
		self:ScheduleRepeating(self.PeriodicListCheck, 10, self)
	end

	for name, module in self:IterateModules() do
		if (module.OnRegenDisabled and module:IsModuleActive()) then
			module:OnRegenDisabled()
		end
	end

	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

-- PLAYER_CONTROL_LOST
function z:PLAYER_CONTROL_LOST()
	self.lostControl = true
	self:SetupForSpell()
end

-- PLAYER_CONTROL_GAINED
function z:PLAYER_CONTROL_GAINED()
	self.lostControl = nil
	self.globalCooldownEnd = 1.5
	self:GlobalCDSchedule()
end

-- UNIT_SPELLCAST_CHANNEL_START
function z:UNIT_SPELLCAST_CHANNEL_START(e, player, spell, rank)
	if (UnitIsUnit(player, "player")) then
		self:SetupForSpell()
	end
end

-- UNIT_PET
-- When a pet is activated, trigger a check for them.
-- Everyone else might be buffed and nothing scheduled for checking for a long time
function z:UNIT_PET(e, ownerid)
	if (self.icon and not self.icon:GetAttribute("*type*")) then
		local petid

		-- Since we'll get a UNIT_PET event for raid1 and party1 and potentially player all from
		-- the same unit, we'll limit those events here depending what sort of group we're in:
		if (GetNumGroupMembers() > 0 and strfind(ownerid, "^raid(%d+)$")) then
			petid = ownerid:gsub("^raid(%d+)", "raidpet%1")
		elseif (GetNumGroupMembers() > 0 and strfind(ownerid, "^party(%d+)$")) then
			petid = ownerid:gsub("^party(%d+)", "partypet%1")
		elseif (ownerid == "player") then
			petid = "pet"
		end

		if (petid and UnitExists(petid) and UnitCanAssist("player", petid)) then
			for name, module in self:IterateModules() do
				if (module.RebuffQuery and module:IsModuleActive()) then
					if (module:RebuffQuery(petid)) then
						module:CheckBuffs()
					end
				end
			end
		end
	end
end

-- PLAYER_LEAVING_WORLD
function z:PLAYER_LEAVING_WORLD()
	self.zoneFlag = GetTime()
	self:SchedCancel(self.PeriodicListCheck)
	self:SchedCancel(self.GlobalCooldownEnd)
	self:SetupForSpell()
end

-- PLAYER_ENTERING_WORLD
function z:PLAYER_ENTERING_WORLD()
	self:SetMainIcon()
	self.zoneFlag = GetTime()
	self:SetupForSpell()
	self:SchedCancel(self.PeriodicListCheck)
	self:SchedCancel(self.GlobalCooldownEnd)
	self:Schedule(self.FinishedZoning, 5, self)

	-- Buff timers aren't available immediately upon zoning
	self:CheckStateChange()
	self:StartCheckMounted()
end

-- FinishedZoning
function z:FinishedZoning()
	self:OnRaidRosterUpdate()
	self.zoneFlag = false
	self:DrawAllCells()
	self:RequestSpells()
end

-- PLAYER_UPDATE_RESTING
function z:PLAYER_UPDATE_RESTING()
	if (IsResting() and z.db.profile.notresting) then
		self:SetupForSpell()
		self:CanCheckBuffs()
	else
		if (not self.icon:GetAttribute("spell") and not self.icon:GetAttribute("item")) then
			self:RequestSpells()
		end
	end
end

-- SetKeyBindings
function z:SetKeyBindings()
	if (not self.icon) then
		return
	end

	ClearOverrideBindings(self.icon)

	if (self.db.profile.mousewheel and self.enabled) then
		SetOverrideBindingClick(self.icon, true, "MOUSEWHEELUP", self.icon:GetName(), "MOUSEWHEELUP")
		SetOverrideBindingClick(self.icon, true, "MOUSEWHEELDOWN", self.icon:GetName(), "MOUSEWHEELDOWN")
	end

	if (self.db.profile.keybinding) then
		SetOverrideBindingClick(self.icon, true, self.db.profile.keybinding, self.icon:GetName(), "LeftButton")
	end
end

-- OnClick
function z:OnClick()
	if (not IsAltKeyDown()) then
		self.db.profile.enabled = not self.db.profile.enabled
		if (self.db.profile.enabled) then
			self:RequestSpells()
		else
			self.atTrainer, self.atVendor = nil
			self:SetupForSpell()
			self:SchedCancel(self.GlobalCooldownEnd)
		end
		if (not self.icon:GetAttribute("spell") and not self.icon:GetAttribute("item")) then
			self:SetStatusIcon()
		end

		self:Printf(L["Auto-casting %s"], (self.db.profile.enabled and L["|cFF80FF80Enabled"]) or L["|cFFFF8080Disabled"])
	end
end

-- OnTooltipUpdate
function z:OnTooltipUpdate(parent)
	self.linkSpells = nil
	parent = parent or self.lastTooltipParent
	self.lastTooltipParent = parent

	local tooltip = qtip:Acquire('ZOMGBuffsTooltip', 1)
	tooltip:Clear()
	tooltip:SetHeaderFont(GameFontNormalLarge)
	tooltip:AddHeader(format("%s |cFF808080r%s|r", z.titleColour, tostring(z.version)))
	tooltip:SetScript("OnHide", function(self)
		tooltip:Release(self)
		z.qTooltip = nil
	end)
	self.qTooltip = tooltip
	tooltip:SmartAnchorTo(parent)
	tooltip:SetAutoHideDelay(0.2, parent)
	tooltip:Show()
	tooltip:EnableMouse()

	if (self.waitingForRaid) then
		tooltip:AddLine("|cFFFF8080"..format(L["Waiting for %d%% of raid to arrive before buffing commences (%d%% currently present)"], z.db.profile.waitforraid * 100, self.waitingForRaid))
	end

	tooltip:SetColumnLayout(2, "LEFT", "RIGHT")
	for name, module in self:IterateModules() do
		if (module.TooltipUpdate and module:IsModuleActive()) then
			module:TooltipUpdate(tooltip)
		end
	end

	--tooltip:SetColumnLayout(1, "LEFT")
	tooltip:AddSeparator(1, 0.5, 0.5, 0.5)
	local line = tooltip:AddLine(" ")
	tooltip:SetCell(line, 1, L["HINT"], nil, "LEFT", 2, nil, nil, nil, 250)
	--tooltip:SetCellColor(line, 1, 0.2, 1, 0.2)

	self.linkSpells = true
end

-- GetMerchantBuyItemList
function z:GetMerchantBuyItemList()
	local list = new()
	local level = UnitLevel("player")
	for name, module in z:IterateModules() do
		if (module.reagents and module.db and module.db.char and module.db.char.reagents) then
			for item,info in pairs(module.reagents) do
				local itemname = item
				if (itemname and (not info.maxLevel or level <= info.maxLevel) and (not info.minLevel or level >= info.minLevel)) then
					local num = module.db.char.reagents[item]
					if (num and num > 0) then
						list[item] = num
					end
				end
			end
		end
	end
	return list
end

-- MERCHANT_SHOW
function z:MERCHANT_SHOW()
	self:SetupForSpell()
	self.atVendor = true
	if (not self.db.char.autobuyreagents) then
		return
	end

	if (self.lastMerchantBuy and GetTime() < self.lastMerchantBuy + 5) then
		return
	end
	self.lastMerchantBuy = GetTime()

	local list = z:GetMerchantBuyItemList()
	if (next(list)) then
		local numMerchantItems = GetMerchantNumItems()
		local doneItems = new()				-- Double check there's no error in what we buy

		for i = 1,numMerchantItems do
			local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(i)
			local itemLink = GetMerchantItemLink(i)
			local itemId = tonumber(strmatch(itemLink or "", "|Hitem:(%d+):"))
			if (itemId) then
				local required = list[name] or list[itemId]
				if (required and not doneItems[name]) then
					doneItems[name] = true
					local bought = 0
					local got = GetItemCount(itemId)
					local splitStacks

					if (list[itemId]) then
						-- If we're searching for specific ItemIDs (rogue poisons) we need to check if we
						-- have any of the old poisons in bags. They've all been renamed and all cast the
						-- same spell, but GetItemCount() only looks at the first one. So if you have a
						-- single old one for example, ZOMG will hapily keep buying stacks of new ones for
						-- your enjoyment - Ugly fix, but it works
						for modname, module in z:IterateModules() do
							if (module.reagents and module.db and module.db.char and module.db.char.reagents) then
								for RitemID,Rinfo in pairs(module.reagents) do
									if (RitemID == itemId) then
										if (Rinfo.alternateCount) then
											local items = new(strsplit(",", Rinfo.alternateCount))
											for i,id in ipairs(items) do
												splitStacks = true
												got = got + GetItemCount(id)
											end
											del(items)
										end
									end
								end
							end
						end
					end

					local get = quantity					-- Stacked vendor items come in this amount always
					if (got < required) then
						local stackSize = select(8, GetItemInfo(itemId))
						if (not stackSize) then
							-- Item is not in local cache
							stackSize = 5
						end

						while (got + quantity <= required) do
							if (quantity > 1) then
								BuyMerchantItem(i)		-- Buying stacked items (Symbol of Kings for example in 20s)
							else
								get = min(required - got, stackSize)
								BuyMerchantItem(i, get)		-- None stacked vendor can be bought to max of stackSize at a time
							end
							got = got + get
							bought = bought + get
						end
					end

					if (bought > 0) then
						self:Printf(L["Bought |cFF80FF80%d|cFFFFFF80 %s|r from vendor, you now have |cFF80FF80%d|r"], bought, itemLink or name, got)
						-- TODO - Put newly bought stacks into same bag as matching reagents
					end
				end
			end
		end

		del(doneItems)
	end

	del(list)
end

-- MERCHANT_CLOSED
function z:MERCHANT_CLOSED()
	self.atVendor = nil
	self:RequestSpells()
end

-- TRAINER_SHOW
function z:TRAINER_SHOW()
	self:SetupForSpell()
	self.atTrainer = true
end

-- TRAINER_CLOSED
function z:TRAINER_CLOSED()
	self.atTrainer = nil
	self:RequestSpells()
end

-- PLAYER_DEAD
function z:PLAYER_DEAD()
	self:SetupForSpell()
end

-- PLAYER_DEAD
function z:PLAYER_ALIVE()
	self:RequestSpells()
end

-- UNIT_POWER
-- This is enabled when we failed a mana check in self:CanCheckBuffs()
function z:UNIT_POWER(e, unit, powtype)
	if (unit == "player" and powtype == "MANA") then
		local mana, manamax = UnitPower("player", SPELL_POWER_MANA), UnitPowerMax("player", SPELL_POWER_MANA)
		if (mana / manamax * 100 >= self.db.char.minmana) then
			self:UnregisterEvent("UNIT_POWER")
			self:RequestSpells()
		end
	end
end

-- COMBAT_LOG_EVENT_UNFILTERED
local mask = COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
function z:COMBAT_LOG_EVENT_UNFILTERED(e, ev, timestamp, event, hideCaster, srcGUID, srcName, srcFlags, ...)
	if (event == "UNIT_DIED") then
		if (self.icon and band(srcFlags, mask)) then
			local loadedUnit = self.icon:GetAttribute("unit")
			if (UnitIsUnit(srcName, loadedUnit)) then
				self:SetupForSpell()
				self:RequestSpells()
			end
		end
	end
end

-- MODIFIER_STATE_CHANGED
function z:MODIFIER_STATE_CHANGED()
	self:DrawAllCells()
end

function z:DefaultClickBindings()
	return {
		target = "BUTTON1",
		stamina = "BUTTON2",
		shadowprot = "SHIFT-BUTTON2",
		fearward = "ALT-BUTTON1",
		mark = "BUTTON2",
		thorns = "CTRL-BUTTON2",
		int = "BUTTON2",
		focusmagic = "CTRL-BUTTON1",
		water = "ALT-BUTTON2",
		earthshield = "BUTTON2",
		seeinvis = "BUTTON2",
		breath = "SHIFT-BUTTON2",
		kings = "BUTTON2",
		might = "SHIFT-BUTTON2",
		freedom = "CTRL-BUTTON1",
		sacrifice = "ALT-BUTTON1",
		beacon = "SHIFT-BUTTON1",
	}
end

function z:OnProfileChanged(event, database, newProfileKey)
	self:SetIconSize()
	self:RestorePosition(self.icon, self.db.profile.pos)
	self:SetKeyBindings()
	self:SetAllBarSizes()
	z:CallMethodOnAllModules("SetupDB")
	z:CallMethodOnAllModules("OnResetDB")
end

-- OnInitialize
function z:OnInitialize()
	self.maxVersionSeen = 0

	self.db = LibStub("AceDB-3.0"):New("ZOMGBuffsNewDB", nil, "Default")
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self.db:RegisterDefaults({
		profile = {
			showMinimapButton = true,
			bufftimer = true,
			bufftimersize = 0.6,
			bufftimerthreshold = 10 * 60,
			invert = true,
			notice = true,
			usesink = false,
			sinkopts = {},
			info = true,
			mousewheel = true,
			notresting = true,
			notmounted = true,
			notstealthed = true,
			notshifted = true,
			enabled = true,
			bartexture = "BantoBar",
			waitforraid = 0,				-- Wait for % of raid
			ignoreabsent = true,			-- Ignore absent players (offline, afk, out of zone)
			channel = "Raid",				-- Report channel
			skippvp = true,					-- Don't directly buff PVP players
			groupno = true,
			alwaysLoadPortalz = true,
			showSolo = true,
			showParty = true,
			showRaid = true,
			track = {
				sta = true,
				mark = true,
				int = true,
				shadow = false,
				kings = true,
				might = true,
				food = true,
				flask = true,
			},
			click = z:DefaultClickBindings(),
			buffreminder = "None",
			spellIcons = true,
			showroles = true,
			iconswirl = true,
			showFubar = true,
			width = 150,
			height = 14,
			fontface = "Arial Narrow",
			fontsize = 12,
			fontoutline = "",
			anchor = "BOTTOMRIGHT",
			relpoint = "TOPRIGHT",
			iconsize = 36,
			border = false,
		},
		char = {
			firstStartup = true,
			showicon = true,
			iconlocked = false,
			classIcon = false,
			sort = "GROUP",
			autobuyreagents = false,
			minmana = 0,
			learnooc = true,
			learncombat = true,
			loadraidbuffmodule = true,
		}
	})
	if (self.db.char.pos) then
		self.db.profile.pos = self.db.char.pos
		self.db.char.pos = nil
	end
	if (self.db.char.fontface) then
		self.db.profile.width = self.db.char.width
		self.db.profile.height = self.db.char.height
		self.db.profile.fontface = self.db.char.fontface
		self.db.profile.fontsize = self.db.char.fontsize
		self.db.profile.fontoutline = self.db.char.fontoutline
		self.db.profile.anchor = self.db.char.anchor
		self.db.profile.relpoint = self.db.char.relpoint
		self.db.profile.iconsize = self.db.char.iconsize
		self.db.profile.border = self.db.char.border
		self.db.char.width = nil
		self.db.char.height = nil
		self.db.char.fontface = nil
		self.db.char.fontsize = nil
		self.db.char.fontoutline = nil
		self.db.char.anchor = nil
		self.db.char.relpoint = nil
		self.db.char.iconsize = nil
		self.db.char.border = nil
	end

	self:SetKeyBindings()

	self.globalCooldownEnd = 0
	playerClass = playerClass or select(2, UnitClass("player"))

	self:SetupOptions()

	self.OnInitialize = nil
end

-- SetupOptions
function z:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ZOMGBuffs", self.options)
	local ACD3 = LibStub("AceConfigDialog-3.0")

	self.optionsFrames.General = ACD3:AddToBlizOptions("ZOMGBuffs", nil, nil, "General")
	self.optionsFrames.Display = ACD3:AddToBlizOptions("ZOMGBuffs", L["Display"], "ZOMGBuffs", "display")
	--self.optionsFrames.Icons = ACD3:AddToBlizOptions("ZOMGBuffs", L["Icons"], "ZOMGBuffs", "icons")
	--self.optionsFrames.ShowWhen = ACD3:AddToBlizOptions("ZOMGBuffs", L["Show When"], "ZOMGBuffs", "show")
	self:RegisterChatCommand("zomg", "OpenConfig")

	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
	-- Add ordering data to the option table generated by AceDBOptions-3.0
	self.options.args.Profiles.order = -2

	self.SetupOptions = nil
end

-- RegisterModuleOptions
function z:RegisterModuleOptions(name, optionTbl, displayName)
	self.options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ZOMGBuffs", displayName, "ZOMGBuffs", name)
end

local function d(...)
	ChatFrame1:AddMessage(format(...))
end

-- ToggleOptions
function z:OpenConfig()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.General)
end

-- IsInBattlegrounds
function z:IsInBattlegrounds()
	for i = 1,50 do
		local r = GetBattlefieldStatus(i)
		if (not r) then
			return nil
		end
		if (r == "active") then
			return true
		end
	end
end

-- GetGroupNumber
function z:GetGroupNumber(unit)
	-- Fix for rosterlib's occasional group barf
	if (GetNumGroupMembers() > 0) then
		local id = UnitInRaid(unit)		--strmatch(unit, "(%d+)")
		if (id) then
			id = id + 1
			local subgroup = select(3, GetRaidRosterInfo(id))
			return subgroup
		end
	end
	return 1
end

-- MaybeLoadPortalz
function z:MaybeLoadPortalz()
	if (ZOMGPortalz) then
		self.MaybeLoadPortalz = nil
		return
	end

	if (self.db.profile.alwaysLoadPortalz) then
		LoadAddOn("ZOMGBuffs_Portalz")
		--if (ZOMGPortalz) then
		--	self.options.args["ZOMGPortalz"] = ZOMGPortalz:GetModuleOptions()
		--end
		self.MaybeLoadPortalz = nil
	end
end

-- DrawAllCells
function z:DrawAllCells()
	for k,v in pairs(FrameArray) do
		v:DrawCell()
	end
end

-- SetBuffsList
function z:SetBuffsList()
	if not self.members then return end
	local havetypes = {}

	del(self.buffs)
	self.buffs = new()
	for k,v in pairs(self.allBuffs) do
		if (self.db.profile.track[v.opt] and not havetypes[v.type] and (not v.class or self.classcount[v.class] > 0 or (v.runescroll and self.db.profile.runescroll))) then
			tinsert(self.buffs, v)
			havetypes[v.type] = true
		end
	end
	self:SetAllBarSizes()
	if (self.icon and self.members and self.members:IsShown()) then
		self:DrawAllCells()
	end
end

-- CreateHelpFrame
local helpFrame
function z:CreateHelpFrame()
	helpFrame = CreateFrame("Frame", nil, UIParent, "DialogBoxFrame")
	helpFrame:SetFrameStrata("TOOLTIP")
	helpFrame:SetWidth(600)
	helpFrame:SetPoint("CENTER", 0, 100)
	helpFrame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	helpFrame:SetBackdropColor(0,0,0,1)
	helpFrame:EnableMouse(true)
	helpFrame:RegisterForDrag("LeftButton")
	helpFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	helpFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	helpFrame:SetScale(0.9)
	helpFrame:SetMovable(true)
	helpFrame:SetClampedToScreen(true)

	local text = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	helpFrame.title = text
	text:SetPoint("TOP", 0, -10)

	text = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	helpFrame.text = text

	text:SetPoint("TOPLEFT", 10, -30)
	text:SetWidth(helpFrame:GetWidth() - 20)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("TOP")

	local b = CreateFrame("Button", nil, main, "OptionsButtonTemplate")
	b:GetRegions():SetAllPoints(b)			-- Makes the text part (first region) fit all over button, instead of just centered and fuxed when scaled
	b:SetScript("OnClick", function(self) helpFrame:Hide() end)
	b:SetText(CLOSE)
	helpFrame.close = b

	helpFrame:Hide()
	z.CreateHelpFrame = nil

	function helpFrame:DoTokens(str)
		for i = 1,100 do
			local part = strmatch(str, "{[^{^}]*}")
			if (not part) then
				break
			end
			local subpart = part:sub(2, -2)
			local newpart
			if (subpart:lower() == "version") then
				newpart = "r"..z.version
			else
				newpart = GetAddOnMetadata("ZOMGBuffs", subpart)
				if (newpart) then
					newpart = format("|cFFFFFF80%s|r", newpart)
				else
					newpart = "|cFFFF8080nil|r"
				end
			end
			part = part:gsub("-", "--")
			str = str:gsub(part, newpart)
		end
		return str
	end

	function helpFrame:SetHelp(title, help)
		self:Hide()
		self.title:SetText(title)
		self.text:SetText(help)
		self:Show()
	end

	helpFrame:SetScript("OnShow",
		function(self)
			local title = self:DoTokens(self.title:GetText())
			local text = self:DoTokens(self.text:GetText())
			self.title:SetText(title)
			self.text:SetText(text)

			self:SetHeight(self.text:GetHeight() + 80)
		end)

	helpFrame:SetScript("OnHide",
		function(self)
			self.text:SetText("")
			self:SetHeight(80)
		end)

	return helpFrame
end

-- PrintAddonInfo
function z:PrintAddonInfo()
	local f = z:GetHelpFrame()
	f:SetHelp(L["TITLECOLOUR"].." r"..self.version, L["ABOUT"])
end

-- GetHelpFrame
function z:GetHelpFrame()
	if (not helpFrame) then
		self:CreateHelpFrame()
	end
	return helpFrame
end

-- LibGroupTalents_Update
function z:LibGroupTalents_Update(e, guid, unit, newSpec, n1, n2, n3, oldSpec, o1, o2, o3)
	if (UnitIsUnit("player", unit)) then
		self:CallMethodOnAllModules("OnSpellsChanged")
	end
end

-- SPELLS_CHANGED
function z:SPELLS_CHANGED()
	self:CallMethodOnAllModules("OnSpellsChanged")
end

-- ADDON_LOADED
function z:ADDON_LOADED(addon)
	if (addon == "ZOMGBuffs_BuffTehRaid") then
		btr = ZOMGBuffTehRaid
	end
end

-- CheckStateChange
function z:CheckStateChange()
	local party = GetNumGroupMembers() > 0
	local raid = party and IsInRaid()
	local instance, Type = IsInInstance()

	local state, reason
	if (instance and Type == "pvp") then
		state, reason = "bg", L["You are now in a battleground"]
	elseif (instance and Type == "arena") then
		state, reason = "arena", L["You are now in an arena"]
	elseif (raid) then
		state, reason = "raid", L["You are now in a raid"]
	elseif (party) then
		state, reason = "party", L["You are now in a party"]
	else
		state, reason = "solo", L["You are now solo"]
	end

	if (state ~= self.state) then
		self.state = state
		self:CallMethodOnAllModules("OnStateChanged", state, reason)
	end
end

-- CallMethodOnAllModules
function z:CallMethodOnAllModules(func, ...)
	for name, module in self:IterateModules() do
		if (module[func] and module:IsModuleActive()) then
			module[func](module, ...)
		end
	end
end

-- PARTY_MEMBERS_CHANGED
function z:PARTY_MEMBERS_CHANGED()
	self:RAID_ROSTER_UPDATE()
end

-- OnEnableOnce
function z:OnEnableOnce()
	if (SM) then
		SM:Register("statusbar", "BantoBar",	"Interface\\AddOns\\ZOMGBuffs\\Textures\\BantoBar")
		SM:Register("statusbar", "Blizzard",	"Interface\\TargetingFrame\\UI-StatusBar")
		SM:Register("sound", "Bats",			"Sound\\Doodad\\BatsFlyAway.wav")
		SM:Register("sound", "Firework",		"Sound\\Doodad\\G_FireworkBoomGeneral2.wav")
		SM:Register("sound", "Clockwork",		"Sound\\Doodad\\G_GasTrapOpen.wav")
		SM:Register("sound", "Gong",			"Sound\\Doodad\\G_GongTroll01.wav")
		SM:Register("sound", "Wisp",			"Sound\\Event Sounds\\Wisp\\WispPissed1.wav")
		SM:Register("sound", "Fog Horn",		"Sound\\Doodad\\ZeppelinHorn.wav")
		SM:Register("sound", "Error",			"Sound\\interface\\Error.wav")
		SM:Register("sound", "Drop",			"Sound\\interface\\DropOnGround.wav")
		SM:Register("sound", "Whisper",			"Sound\\interface\\igTextPopupPing02.wav")
		SM:Register("sound", "Friend Login",	"Sound\\interface\\FriendJoin.wav")
		SM:Register("sound", "Socket Clunk",	"Sound\\interface\\JewelcraftingFinalize.wav")
		SM:Register("sound", "Ping",			"Sound\\interface\\MapPing.wav")
	end

	if (Sink) then
		self:SetSinkStorage(self.db.profile.sinkopts)
	end

	-- Table to make sure we don't re-load the same module again if someone screws up
	-- their installation and has a double set of folders in addons and in ZOMGBuffs proper
	local matchList = {
		ZOMGBuffs_SelfBuffs = ZOMGSelfBuffs,
		ZOMGBuffs_BuffTehRaid = ZOMGBuffTehRaid,
		ZOMGBuffs_Portalz = ZOMGPortalz,
	}

	playerClass = playerClass or select(2, UnitClass("player"))
	for i = 1,GetNumAddOns() do
		local name,_,_,enabled,loadable = GetAddOnInfo(i)
		if (name and loadable and strfind(name, "ZOMGBuffs_")) then
			local d = GetAddOnMetadata(i, "X-ZOMGBuffs")
			if (d) then
				local load
				local c = GetAddOnMetadata(i, "X-Classes")
				if (c) then
					load = strfind(strupper(c), playerClass)
					if (not load) then
						c = GetAddOnMetadata(i, "X-Classes-Optional")
						if (c) then
							if (strfind(strupper(c), playerClass)) then
								self.canloadraidbuffmodule = true
								if (self.db.char.loadraidbuffmodule) then
									load = true
								end
							end
						end
					end
				else
					load = true
				end
				if (load) then
					local match = matchList[name]
					if (not match or not _G[matchList[match]]) then
						LoadAddOn(i)
					end
				end
			end
		end
	end

	btr = ZOMGBuffTehRaid

	self:MaybeLoadPortalz()

	buffClass = self:IsRebuffer()

	self.actions = nil
	self:SetClickConfigMenu()

	-- Replace old keybindings with the defaults that we messed up before r69331
	local command = GetBindingAction("MOUSEWHEELUP")
	if (command == "CLICK ZOMGBuffsButton:MOUSEWHEELUP") then
		SetBinding("MOUSEWHEELUP", "CAMERAZOOMIN")
	end
	command = GetBindingAction("MOUSEWHEELDOWN")
	if (command == "CLICK ZOMGBuffsButton:MOUSEWHEELDOWN") then
		SetBinding("MOUSEWHEELDOWN", "CAMERAZOOMOUT")
	end

	self.mounted = IsMounted()

	self.linkSpells = true
	self.OnEnableOnce = nil
end

function z:GetTitle()
	return L["TITLECOLOUR"]
end

-- RegisterTablet
function z:RegisterTablet(ldbParent)
	if (not ldbParent) then
		return
	end

	if not tablet:IsRegistered(ldbParent) then
		tablet:Register(ldbParent,
			'children', function()
				tablet:SetTitle(self:GetTitle())
				if type(self.OnTooltipUpdate) == "function" then
					if self:IsEnabled() then
						self:OnTooltipUpdate()
					end
				end
			end,
			'clickable', true,
			'point', function(frame)
				if frame:GetTop() > GetScreenHeight() / 2 then
					local x = frame:GetCenter()
					if x < GetScreenWidth() / 3 then
						return "TOPLEFT", "BOTTOMLEFT"
					elseif x < GetScreenWidth() * 2 / 3 then
						return "TOP", "BOTTOM"
					else
						return "TOPRIGHT", "BOTTOMRIGHT"
					end
				else
					local x = frame:GetCenter()
					if x < GetScreenWidth() / 3 then
						return "BOTTOMLEFT", "TOPLEFT"
					elseif x < GetScreenWidth() * 2 / 3 then
						return "BOTTOM", "TOP"
					else
						return "BOTTOMRIGHT", "TOPRIGHT"
					end
				end
			end
		)
	end
end

-- SetMainIcon
function z:SetMainIcon(icon)
	self.mainIcon = icon or self.mainIcon
	LDB.icon = self.mainIcon
end
function z:GetMainIcon()
	return LDB.icon
end

-- OnEnable
function z:OnEnable()
	if (not self.buffRoster) then
		self.buffRoster = {}
	end
	playerName = UnitName("player")
	playerClass = playerClass or select(2, UnitClass("player"))
	z.versionRoster[playerName] = self.version
	z.maxVersionSeen = max(z.maxVersionSeen or 0, self.version)
	btr = ZOMGBuffTehRaid

	if LDBIcon then
		self.db.profile.ldbIcon = self.db.profile.ldbIcon or {}
		LDBIcon:Register("ZOMGBuffs", LDB, self.db.profile.ldbIcon)
	end

	self.groupColours = {{1, 1, 0.5}, {1, 0.5, 1}, {0.5, 1, 1}, {1, 0.5, 0.5}, {0.5, 1, 0.5}, {0.5, 0.5, 1}, {0.5, 0.5, 0.5}, {1, 1, 0}, {1, 0, 1}, {0, 1, 1}}

	if (self.OnEnableOnce) then
		self:OnEnableOnce()
	end

	self:SetClickConfigMenu()
	self:OnRaidRosterUpdate()

	if (z.db.char.firstStartup) then
		z.db.char.firstStartup = false
		z.db.char.sort = "GROUP"
	end

	if (not self.icon) then
		self:OnStartup()
		self:RestorePosition(self.icon, self.db.char.pos)
		self:SetIconSize()
	elseif (self.members) then
		self.members:RegisterEvent("PARTY_MEMBERS_CHANGED")
	end

	--LGT.RegisterCallback(self, "LibGroupTalents_Update")

	self:MakeOptionsReagentList()
	self:SetSort()

	self.enabled = true
	self:SetKeyBindings()

	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("MERCHANT_CLOSED")
	self:RegisterEvent("TRAINER_SHOW")
	self:RegisterEvent("TRAINER_CLOSED")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("PLAYER_ALIVE")

	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	self.icon:Show()
end

-- OnDisable
function z:OnDisable()
	z.options.args.behaviour.args.reagentlevels.args = nil
	if (z.options.args.click) then
		z.options.args.click.args = nil
		z.options.args.click = nil
	end
	self.atTrainer, self.atVendor = nil
	self.oldPots = del(self.oldPots)
	self:SetupForSpell()
	self.enabled = nil
	self.icon:Hide()
	self.members:UnregisterAllEvents()
	self.buffRoster = nil
	self.blackList = nil
	self.groupColours = nil
	self:UnhookAll()
end
