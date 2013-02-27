if (ZOMGSelfBuffs) then
	ZOMGBuffs:Print("Installation error, duplicate copy of ZOMGBuffs_SelfBuffs (Addons\ZOMGBuffs\ZOMGBuffs_SelfBuffs and Addons\ZOMGBuffs_SelfBuffs)")
	return
end

local wowVersion = tonumber((select(2,GetBuildInfo())))

local L = LibStub("AceLocale-3.0"):GetLocale("ZOMGSelfBuffs")
local R = LibStub("AceLocale-3.0"):GetLocale("ZOMGReagents")
--local LGT = LibStub("LibGroupTalents-1.0")
local playerClass, playerName, playerGUID
local template = {}

local InCombatLockdown	= InCombatLockdown
local IsUsableSpell		= IsUsableSpell
local GetSpellCooldown	= GetSpellCooldown
local GetSpellInfo		= GetSpellInfo
local UnitBuff			= UnitBuff
local UnitClass			= UnitClass

local z = ZOMGBuffs
local zs = z:NewModule("ZOMGSelfBuffs")
ZOMGSelfBuffs = zs

z:CheckVersion("$Revision: 216 $")

local enchantMatching		-- Table of spellName -> enchantName conversions
do
	if (GetLocale() == "enUS") then
		enchantMatching = {
			[GetSpellInfo(5761)] = "Mind Numbing Poison",			-- Mind-numbing Poison
			[GetSpellInfo(8232)] = "^Windfury$",				-- Windfury Weapon
			[GetSpellInfo(8024)] = "^Flametongue$",			-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^Earthliving$",			-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^Frostbrand$",			-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^Rockbiter$", 			-- Rockbiter Weapon
		}

	elseif (GetLocale() == "deDE") then
		enchantMatching = {
			[GetSpellInfo(3408)] = "Verkrüppelungsgift",			-- Verkrüppelndes Gift (Crippling Poison)
			[GetSpellInfo(8232)] = "^Windzorn$",				-- Windfury Weapon
			[GetSpellInfo(8024)] = "^Flammenzunge$",			-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^Lebensgeister$",		-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^Frostbrand$",			-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^Felsbeißer$",			-- Rockbiter Weapon
		}

	elseif (GetLocale() == "esES") then
		enchantMatching = {
			[GetSpellInfo(8232)] = "^Viento Furioso$",		-- Windfury Weapon
			[GetSpellInfo(8024)] = "^Lengua de Fuego$",		-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^Vida terrestre$",		-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^Estigma de Escarcha$",	-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^Muerdepiedras$",       -- Rockbiter Weapon
		}

	elseif (GetLocale() == "frFR") then
		enchantMatching = {
			[GetSpellInfo(5761)] = "Poison de Distraction mentale",	-- Poison de distraction mentale (Mind-numbing Poison)
			[GetSpellInfo(8232)] = "^Furie-des-vents$",		-- Windfury Weapon
			[GetSpellInfo(8024)] = "^Langue de feu$",			-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^Viveterre$",			-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^Arme de givre$",			-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^Croque-roc$",       -- Rockbiter Weapon
		}

	elseif (GetLocale() == "ruRU") then
		enchantMatching = {
			[GetSpellInfo(8232)] = "^Неистовство ветра$",		-- Windfury Weapon
			[GetSpellInfo(8024)] = "^Язык пламени$",			-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^Жизнь Земли$",			-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^Ледяное клеймо$",			-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^Оружие камнедробителя$",	-- Rockbiter Weapon
		}

	elseif (GetLocale() == "koKR") then		-- FIXME
		enchantMatching = {
			[GetSpellInfo(8232)] = "^??? ??$",					-- Windfury Weapon
			[GetSpellInfo(8024)] = "^??? ??$",					-- Flametongue Weapon
			[GetSpellInfo(51730)] = "^??? ??$",					-- Earthliving Weapon
			[GetSpellInfo(8033)] = "^??? ??$",					-- Frostbrand Weapon
			[GetSpellInfo(8017)] = "^??? ??$",      	 		-- Rockbiter Weapon
		}
	end
end

local weaponSlotNames = {
	mainhand = L["Main Hand"],
	offhand = L["Off Hand"],
	ranged = L["Ranged"],
}

local alchFlasks = {
	{
		item = 75525,
		spells = {
			[GetSpellInfo(79638)] = true,
			[GetSpellInfo(79639)] = true,
			[GetSpellInfo(79640)] = true
		},
	},	-- Alchemist's Flask
}

local function getAlchFlask()
	local alc = GetSpellInfo(51304)
	if not GetSpellInfo(alc) then return end
	for _, flask in ipairs(alchFlasks) do
		if GetItemCount(flask.item) > 0 then
			return flask.item, flask.spells
		end
	end
end

local new, del, deepDel, copy = z.new, z.del, z.deepDel, z.copy

local function getOption(info)
	return zs.db.char[info[#info]]
end
local function setOption(info, value, update)
	zs.db.char[info[#info]] = value
	if (update) then
		z:CheckForChange(zs)
	end
end
local function getPrelude(info)
	return zs.db.char.rebuff[info[#info]] or 0
end

local function setPrelude(info, value)
	local k = info[#info]
	if ((not value or value == 0) and k ~= "default") then
		zs.db.char.rebuff[k] = nil
	else
		zs.db.char.rebuff[k] = value
	end
end

zs.options = {
	type = "group",
	order = 1,
	name = "|cFFFF8080Z|cFFFFFF80O|cFF80FF80M|cFF8080FFG|rSelfBuffs",
	desc = L["Self Buff Configuration"],
	handler = zs,
	get = getOption,
	set = setOption,
	args = {
		alchFlasks = {
			type = "group",
			name = L["Alchemy Flasks"],
			desc = L["Special handling for Alchemy Flasks"],
			order = 5,
			hidden = function()
				if (zs:IsModuleActive()) then
					if getAlchFlask() then
						return false
					end
				end
				return true
			end,
			args = {
				enable = {
					type = "toggle",
					name = L["Enabled"],
					desc = L["Auto-cast Alchemy Flask"],
					get = function() return zs.db.char.flask end,
					set = function(n,val) zs.db.char.flask = val end,
					order = 1,
				},
				flask = {
					type = "range",
					name = L["Expiry Prelude"],
					desc = L["Expiry prelude for flasks"],
					order = 60,
					get = getPrelude,
					set = setPrelude,
					min = 0,
					max = 15 * 60,
					step = 5,
					bigStep = 60,
				},
			}
		},
		template = {
			type = "group",
			name = L["Templates"],
			desc = L["Template configuration"],
			order = 10,
			args = {
			}
		},
		behaviour = {
			type = "group",
			name = L["Behaviour"],
			desc = L["Self buffing behaviour"],
			order = 201,
			args = {
				combatnotice = {
					type = "toggle",
					name = L["Combat Warnings"],
					desc = L["Warn about expiring buffs in combat. Note that auto buffing cannot be done in combat, this is simply a reminder"],
					set = function(k,v) setOption(k, v, true) end,
					order = 5,
				},
				default = {
					type = "range",
					name = L["Expiry Prelude"],
					desc = L["Default rebuff prelude for all self buffs"],
					func = timeFunc,
					get = getPrelude,
					set = setPrelude,
					min = 0,
					max = 15 * 60,
					step = 5,
					bigStep = 60,
					order = 10,
				},
				useauto = {
					type = "toggle",
					name = L["Auto buffs"],
					desc = L["Use auto-intelligent buffs such as Crusader Aura when mounted"],
					set = function(k,v) setOption(k, v, true) end,
					order = 15,
				},
				reagentNotices = {
					type = 'toggle',
					name = L["Reagent Reminder"],
					desc = L["Show message when spells requiring reagents are used"],
					order = 20,
				},
			},
		},
	}
}

-- SetupForItem
function zs:SetupForItem(slot, itemName)
	local spell, item
	local t1, t2 = IsUsableSpell(itemName)
	spell = (t1 or t2) and itemName
	if (not spell) then
		item = itemName
	end
	if (spell or item) then
		z:SetupForItem(slot, item, self, spell, item and 4 or nil)	-- 4 for when casting poisons onto weapons, we need more than 1.5 secs for next check
		self.activeEnchantLoaded = item and 3 or 0
		self.lastEnchantSet = spell or item
		return true
	end
end

-- GetCurrentItemEnchant
do
	local tempTip, durMatch, encMatchHour, encMatchMin, encMatchSec
	function zs:GetCurrentItemEnchant(slot)
		local hasEnchant, Expiration, Charges = select(1 + (3 * (slot - 16)), GetWeaponEnchantInfo())
		if (hasEnchant) then
			local tipName = "ZOMGBuffTempTip"
			-- See what enchant is, so we can make sure it's the right one

			if (not tempTip) then
				tempTip = CreateFrame("GameTooltip", tipName, UIParent, "GameTooltipTemplate")
			end

			if (not durMatch) then
				-- ConvertGlobalString - Shamelessly pulled from Parser-3.0
				local function ConvertGlobalString(str, first)
					-- Escape lua magic chars.
					local pattern = str:gsub("([%(%)%.%*%+%-%[%]%?%^%$%%])", "%%%1")

					-- Convert %1$s to (..-) and %1$d to (%d+).
					-- We don't care about the capture order, it's always the same for these strings
					pattern = pattern:gsub("%%%%%d%%%$s", "(..-)")
					pattern = pattern:gsub("%%%%%d%%%$d", "(%%d+)")

					-- Convert %s to (..-) and %d to (%d+).
					pattern = pattern:gsub("%%%%s", "(..-)")
					pattern = pattern:gsub("%%%%d", "(%%d+)")

					-- Strip out "|4singular:plural;"
					pattern = pattern:gsub("|4%a+:(%a+);", "%1-")

					if pattern:sub(-5) == "(..-)" then
						pattern = pattern:sub(1, -6) .. "(.+)"
					end

					return "^" .. pattern
				end

				durMatch = ConvertGlobalString(DURABILITY_TEMPLATE)
				encMatchHour = ConvertGlobalString(ITEM_ENCHANT_TIME_LEFT_HOURS)
				encMatchMin = ConvertGlobalString(ITEM_ENCHANT_TIME_LEFT_MIN)
				encMatchSec = ConvertGlobalString(ITEM_ENCHANT_TIME_LEFT_SEC)
			end

			tempTip:SetOwner(UIParent, "ANCHOR_NONE")
			local ok, cd = tempTip:SetInventoryItem("player", slot)
			if (ok and cd) then
				local spellFind, timeLeft
				for i = 1,200 do
					local leftRegion = getglobal(format("%sTextLeft%d", tipName, i))
					if (not leftRegion) then
						break
					end
					local left = leftRegion:GetText()
					if (not left) then
						break
					end
					spellFind, timeLeft = strmatch(left, encMatchHour)
					if (not spellFind) then
						spellFind, timeLeft = strmatch(left, encMatchMin)
						if (not spellFind) then
							spellFind, timeLeft = strmatch(left, encMatchSec)
						end
					end
					if (spellFind and timeLeft) then
						break
					end
				end
				tempTip:Hide()

				if (spellFind and timeLeft) then
					return spellFind, Expiration / 1000 / 60
				end
			end
			tempTip:Hide()
		end
	end
end

-- CheckEnchant
function zs:CheckEnchant(slot, spellOrItem) -- seems like only shaman get weapon buffs now
	if (spellOrItem) then
		if (not self.activeEnchant or self.activeEnchant < GetTime() - (playerClass == "ROGUE" and 3.5 or 2.5)) then
			local itemLink = GetInventoryItemLink("player", slot)
			if (itemLink) then
				local name, tex, quality, itemLevel, _, itemType, subType = GetItemInfo(itemLink)

				if (itemLevel == 1 and quality < 2) then
					-- Ignore itemLevel == 1 (Argent Lances etc)
					return
				end
				if (name) then
					if (subType == "Fishing Poles" or itemType == "Quest") then
						return
					end
				end
			end

			local hasEnchant, Expiration, Charges = select(1 + (3 * (slot - 16)), GetWeaponEnchantInfo())
			if (hasEnchant) then
				local lookFor = enchantMatching[spellOrItem]

				if (lookFor or playerClass ~= "SHAMAN") then		-- Shaman weapon enchants do not match spell names, so we won't check them
					local enc, timeLeft = self:GetCurrentItemEnchant(slot)
					if (enc) then
						local temp = (lookFor or spellOrItem):gsub("%-", "%%-")
						local found, pos = strfind(enc, temp)
						if (not found) then
							hasEnchant = nil
						end
					end
				end
			end

			if (not hasEnchant or Expiration / 1000 < self.db.char.rebuff.default) then
				if (InCombatLockdown() or self:SetupForItem(slot, spellOrItem)) then
					local itemLink = GetInventoryItemLink("player", slot)
					if (not itemLink) then
						itemLink = (slot == 16 and L["Main Hand"]) or (slot == 17 and L["Off Hand"]) or (slot == 18 and L["Ranged"]) or L["Unknown"]
					end
					z:Notice(format(L["You need %s on |c00FFFF80%s|r"], z:LinkSpell(spellOrItem, nil, true), itemLink), "buffreminder")
					return true
				end
			end
		else
			z:GlobalCDSchedule()
		end
	end
end

-- CheckWeaponBuff
function zs:CheckWeaponBuffs()
	return self:CheckEnchant(16, template.mainhand) or (OffhandHasWeapon() and self:CheckEnchant(17, template.offhand))
end

-- CheckBuffs
function zs:CheckBuffs()
	if (not self.classBuffs) then
		return
	end

	--local myBuffs
	if (self.db.char.useauto and not InCombatLockdown()) then
		if (z.globalCooldownEnd > GetTime()) then
			z:GlobalCDSchedule()
			return
		end

		-- Special case for Crusader Aura when mounted, and Aspect of Cheetah when resting
		for k,v in pairs(self.classBuffs) do
			if (v.auto) then
				local name, rank, buff, count, _, max, endTime, isMine, isStealable = UnitBuff("player", k)
				isMine = isMine == "player"
				if (not name or not isMine) then
					if (v.auto()) then
						if (not UnitOnTaxi("player") and not UnitIsDeadOrGhost("player")) then
							z:SetupForSpell()
							z:SetupForSpell("player", k, self)
							z:Notice(format(L["You need %s"], z:LinkSpell(k, nil, true)), "buffreminder")
							if z.icon then
								z.icon.autospell = true
							end
							return
						end
					end
				end
			end
		end
	end

	if (not z:CanCheckBuffs(self.db.char.combatnotice, true)) then
		if (IsMounted() and not z.db.profile.notmounted) then
			z:SetupForSpell()
		end
		return
	end

	if (z.icon and z.icon.autospell) then
		if (not InCombatLockdown()) then
			z:SetupForSpell()
		end
	end

	local any

	local charges = self.db.char.charges
	local minTimeLeft
	for k,v in pairs(template) do
		if (v) then
			local cb = self.classBuffs[k]
			if (cb and (cb.who == "self" or cb.who == "single" or cb.who == "party")) then
				if (not cb.skip or not cb.skip()) then
					local name, rank, buff, count, _, max, endTime, isMine, isStealable = UnitBuff("player", k)
					if not name and cb.aliasNames then
						for ak,av in pairs(cb.aliasNames) do
							name, rank, buff, count, _, max, endTime, isMine, isStealable = UnitBuff("player", ak)
							if name then break end
						end
					end
					local timeLeft = (endTime or 0) ~= 0 and (endTime - GetTime())
					local requiredTimeLeft = self.db.char.rebuff[(cb and cb.rebuff) or k] or self.db.char.rebuff.default

					local c = charges and charges[k]
					if (c) then
						if (not cb.charges) then
							-- Spell type changed from a charges one to not (Inner Fire for 4.0)
							charges[k] = nil
						else
							local cdef = cb.charges
							if (type(cdef) == "function") then
								cdef = cdef()
							end
							--if (c > cdef) then
								--if (LGT:GetUnitTalents("player")) then
								--	c = cdef
								--	charges[k] = cdef
								--end
							--end
						end
					end

					if ((c and ((count or 0) < (c or 0))) or (endTime ~= 0 and (not timeLeft or timeLeft < requiredTimeLeft))) then
						-- Need recast
						local start, duration, enable = GetSpellCooldown(k)
						if ((start and (start == 0 or start + duration <= GetTime())) and enable == 1 and IsUsableSpell(k)) then
							if (not InCombatLockdown() or not cb.nocombatnotice) then
								z:Notice(format(L["You need %s"], z:LinkSpell(k, nil, true)), "buffreminder")
							end
							if (not InCombatLockdown()) then
								z:SetupForSpell("player", k, self)
							end
							any = true
							break
						elseif (start and start ~= 0) then
							local temp = (start + duration) - GetTime()
							if (not minTimeLeft or temp < minTimeLeft) then
								minTimeLeft = temp	-- Soon to cooldown spells caught here
							end
						end
					elseif (timeLeft and timeLeft < 10000) then
						local t = timeLeft - requiredTimeLeft
						if (not minTimeLeft or t < minTimeLeft) then
							minTimeLeft = t
						end
					end
				end
			end
		end
	end

	if (not any) then
		-- Handle Alchemy Flasks
		local flaskitem, flaskspells = getAlchFlask()
		if self.db.char.flask and flaskitem then
			local skip		-- Skip Alchemy Flasks if any other potions/elixirs/flasks are buffed
			local found, foundtime
			for i = 1,1000 do
				local name, rank, buff, count, _, max, endTime, isMine, isStealable = UnitBuff("player", i)
				if not name then break end
				buff = strlower(buff)
				if (flaskspells[name]) then
					found = name
					foundtime = endTime
				elseif (strmatch(buff, "inv_potion") or strmatch(buff, "inv_alchemy")) then
					skip = true
				end
			end
			if (found or not skip) then
				local requiredTimeLeft = self.db.char.rebuff.flask or self.db.char.rebuff.default
				if (not found or foundtime - GetTime() < requiredTimeLeft) then
					z:SetupForItem(nil, (GetItemInfo(flaskitem)), self)
					any = true
				end
			end
		end
	end

	if (not any and (template.mainhand or template.offhand or template.ranged)) then
		if (self:CheckWeaponBuffs()) then
			any = true
		end
	end

	if (not any and (minTimeLeft or 0) > 0) then
		z:Schedule(self.CheckBuffs, minTimeLeft or 60, self)
	else
		z:SchedCancel(self.CheckBuffs)
	end
end

-- GetClassBuffs
function zs:GetClassBuffs()
	local classBuffs
	if (playerClass == "DRUID") then
		classBuffs = {
			{id = 22812, o = 5, duration = 0.20, default = 5, who = "self", c = "A0A020", noauto = true, nocombatnotice = true}, -- Barkskin
			{id = 16689, o = 6, duration = 0.75, default = 5, who = "self", c = "80FF80", noauto = true, skip = function() return IsIndoors() end}, -- Nature's Grasp
			{id = 5217, o = 7, duration = 0.1, default = 1, who = "self", c = "FF8080", noauto = true}, -- Tiger's Fury
		}
		self.reagents = {
			[GetItemInfo(17034) or R["Maple Seed"]]			= {20, 1, 50},
		}
		self.notifySpells = {
			[GetSpellInfo(20484)] = {		-- Rebirth
				GetItemInfo(17034) or R["Maple Seed"],
			},
		}

	elseif (playerClass == "MAGE") then
		classBuffs = {
			{id = 7302,  o = 1,	duration = 30,  who = "self", dup = 1, c = "0000FF"},							-- Frost Armor
			{id = 30482, o = 2,	duration = 30,  who = "self", dup = 1, c = "FF0000"},							-- Molten Armor
			{id = 6117,  o = 3,	duration = 30,  who = "self", dup = 1, c = "8080FF"},							-- Mage Armor
			{id = 11426, o = 5,	duration = 1,   who = "self", default = 5, c = "B0B0FF", noauto = true, cancancel = true}, -- Ice Barrier
			{id = 1463,  o = 7,	duration = 1,   who = "self", default = 5, noauto = true, c = "FFB0B0", cancancel = true},	-- Mana Shield
		}
		local singlePort = GetItemInfo(17031) or R["Rune of Teleportation"]
		local groupPort = GetItemInfo(17032) or R["Rune of Portals"]
		local arcanePowder = GetItemInfo(17020) or R["Arcane Powder"]
		self.reagents = {
			[groupPort]	= {20, 1, 100},
			[singlePort]	= {20, 1, 100},
			[arcanePowder]	= {20, 1, 500, minLevel = 70},
		}
		local singles = {3561, 3562, 3563, 3565, 3566, 3567, 32271, 32272, 33690, 35715, 53140 }
		local groups = {10059, 11416, 11417, 11418, 11419, 11420, 32266, 32267, 33691, 35717, 53142 }
		self.notifySpells = {
			[GetSpellInfo(43987)] = {	-- Ritual of Refreshment
				arcanePowder,
			},

		}
		for i,id in pairs(singles) do
			self.notifySpells[(GetSpellInfo(id))] = singlePort
		end
		for i,id in pairs(groups) do
			self.notifySpells[(GetSpellInfo(id))] = groupPort
		end

	elseif (playerClass == "PRIEST") then
		classBuffs = {
			{id = 17, o = 1, duration = 0.5, default = 5, who = "single", noauto = true, c = "C0C0FF"},	-- Power Word: Shield
			{id = 588, o = 2, duration = 30, who = "self", dup = 1, c = "FFA080"},				-- Inner Fire
			{id = 73413, o = 3, duration = 30, who = "self", dup = 1, c = "FFA080"},			-- Inner Will
			{id = 15473, o = 9, duration = -1, who = "self", c = "A020A0"},					-- Shadowform
			{id = 15286, o = 3, duration = 30, who = "self", c = "8080A0"},					-- Vampiric Embrace
		}

	elseif (playerClass == "WARLOCK") then
		classBuffs = {
-- DEPRECATED			{id = 687, o = 1, duration = 30, who = "self", dup = 1, c = "FF80FF"},					-- Demon Armor
-- DEPRECATED			{id = 28176, o = 2, duration = 30, who = "self", dup = 1, c = "10D020"},					-- Fel Armor
			{id = 6229, o = 4, duration = 0.5, default = 5, dup = 2, who = "self", noauto = true, c = "FF60FF", aliases = {91711}},				-- Shadow Ward / Nether Ward
-- DEPRECATED			{id = 19028, o = 7, duration = -1, who = "self", noauto = true, c = "20FF80", skip = function() return not UnitExists("pet") end},				-- Soul Link
-- DEPRECATED			{id = 79268, o = 9, duration = 0.15, who = "self", c = "9482C9", nocombatnotice = true,		-- Soul Harvest
-- DEPRECATED				skip = function() return not (UnitPower("player", SPELL_POWER_SOUL_SHARDS) < 3) end		-- Skip if shards are full
-- DEPRECATED			},
		}

	elseif (playerClass == "HUNTER") then
		classBuffs = {
			{id = 19506, o = 1, duration = -1, who = "self", c = "FFFFFF"},					-- Trueshot Aura
			{id = 13165, o = 2, duration = -1, who = "self", dup = 1, c = "4090FF"},		-- Aspect of the Hawk
			{id = 82661, o = 3, duration = -1, who = "self", dup = 1, c = "FFCF60"},		-- Aspect of the Fox
			{id = 5118, o = 6, duration = -1, who = "self", dup = 1, c = "FFFF80", auto =
					function()
						if (IsResting() and not IsMounted() and not UnitOnTaxi("player")) then
							local spell = GetSpellInfo(59641)
							if (UnitAura("player", spell) == nil) then
								return z.db.profile.notresting
							end
						end
					end},	-- Aspect of the Cheetah
			{id = 13159, o = 7, duration = -1, who = "self", dup = 1, c = "B0B0B0"},		-- Aspect of the Pack
-- DEPRECATED			{id = 20043, o = 8, duration = -1, who = "self", dup = 1, c = "20FF20"},		-- Aspect of the Wild
		}

	elseif (playerClass == "SHAMAN") then
		local onEnableShield = function(key)
			local btr = ZOMGBuffTehRaid
			if (btr) then
				local who = btr:ExclusiveTarget("EARTHSHIELD")
				if (who and UnitIsUnit(who, "player")) then
					btr:ModifyTemplate("EARTHSHIELD", nil)
				end
			end
		end

		classBuffs = {
			{id = 324, o = 1, dup = 2, charges = 3, duration = 10, who = "self", c = "8080FF", onEnable = onEnableShield},					-- Lightning Shield
			{id = 52127, o = 2, dup = 2, charges = 3, duration = 10, who = "self", noauto = true, c = "4040FF", onEnable = onEnableShield},	-- Water Shield
			{id = 8232, o = 4, duration = 30, who = "weapon", c = "FFFFFF", dup = 1},		-- Windfury Weapon
			{id = 8024, o = 5, duration = 30, who = "weapon", c = "FF8080", dup = 1},		-- Flametongue Weapon
			{id = 8033, o = 6, duration = 30, who = "weapon", c = "8080FF", dup = 1},		-- Frostbrand Weapon
			{id = 51730, o = 7, duration = 30, who = "weapon", c = "FFFF80", dup = 1},		-- Earthliving Weapon
			{id = 8017,  o = 8, duration = 30, who = "weapon", c = "80FF80", dup = 1},		-- Rockbiter Weapon
		}
		self.reagents = {
			[GetItemInfo(17030) or R["Ankh"]] = {10, 1, 50, minLevel = 30},
		}
		self.notifySpells = {
			[GetSpellInfo(27740)] = GetItemInfo(17030) or R["Ankh"],										-- Reincarnation
		}

	elseif (playerClass == "WARRIOR") then
		classBuffs = {
			{id = 6673, o = 1, duration = 2, dup = 1, who = "self", c = "FF4040", checkdups = true,		-- Battle Shout
				aliases = { 8076, 57330 },
				-- Strength of Earth, Horn of Winter
			},
			{id = 469, o = 2, duration = 2, dup = 1, who = "self", c = "40FF40", checkdups = true,		-- Commanding Shout
				aliases = { 6307, 21562 }, -- Blood Pact, Power Word: Fortitude
			},
			{id = 18499, o = 4, duration = 0.165, who = "self", noauto = true, c = "FFFF40"},				-- Berserker Rage
		}

	elseif (playerClass == "ROGUE") then
		classBuffs = {
			{id = 2818, o = 1, dup = 1, duration = 60, who = "self", c = "66ff66"},	-- Deadly Poison
			{id = 8680, o = 2, dup = 1, duration = 60, who = "self", c = "66ff66" },	-- Wound Poison
			{id = 3409, o = 3, dup = 2, duration = 60, who = "self", c = "339933"},	-- Crippling Poison
			{id = 5760, o = 4, dup = 2, duration = 60, who = "self", c = "339933"},	-- Mind-numbing Poison
			{id = 113952, o = 5, dup = 2, duration = 60, who = "self", c = "339933"},	-- Paralytic Poison
			{id = 112961, o = 5, dup = 2, duration = 60, who = "self", c = "339933"},	-- Leeching Poison
		}

	elseif (playerClass == "PALADIN") then
		local function skipFunc()
			return zs.db.char.useauto and IsMounted() and not z.db.profile.notmounted
		end

		classBuffs = {
			{id = 20154, o = 1,  duration = 30, who = "self", dup = 1, noauto = true, c = "C0C0FF", rebuff = L["Seals"]},	-- Seal of Righteousness
			{id = 20165, o = 3,  duration = 30, who = "self", dup = 1, noauto = true, c = "FFA040", rebuff = L["Seals"]},	-- Seal of Insight
			{id = 31801, o = 4,  duration = 30, who = "self", dup = 1, noauto = true, c = "FFD010", rebuff = L["Seals"]},	-- Seal of Truth
			{id = 20164, o = 5,  duration = 30, who = "self", dup = 1, noauto = true, c = "A0FFA0", rebuff = L["Seals"]},	-- Seal of Justice
			{id = 25780, o = 10, duration = 30, who = "self", c = "FFD020", cancancel = true},								-- Righteous Fury
-- DEPRECATED			{id = 465, o = 14, duration = -1, who = "self", dup = 2, mounted = true, c = "8090C0", checkdups = true, skip = skipFunc},		-- Devotion Aura
-- DEPRECATED			{id = 7294, o = 15, duration = -1, who = "self", dup = 2, mounted = true, c = "D040D0", checkdups = true, skip = skipFunc},		-- Retribution Aura
-- DEPRECATED			{id = 19746, o = 16, duration = -1, who = "self", dup = 2, mounted = true, c = "C020E0", checkdups = true, skip = skipFunc},		-- Concentration Aura
-- DEPRECATED			{id = 19891, o = 17, duration = -1, who = "self", dup = 2, mounted = true, c = "E06020", checkdups = true, skip = skipFunc},		-- Resistance Aura
			{id = 32223, o = 18, duration = -1, who = "self", dup = 2, mounted = true, c = "D0D060", noauto = true, auto = function(v) return IsMounted() end, c = "FFFFFF"},	-- Crusader Aura
			{id = 54428, o = 22, duration = 0.25, who = "self", c = "FFFF70", noauto = true,		-- Divine Plea
				skip = function()
					local mana, maxmana = UnitMana("player"), UnitManaMax("player")
					return (mana / maxmana) > 0.9					-- Skip if over 90% mana
				end
			},
		}

	elseif (playerClass == "DEATHKNIGHT") then
		classBuffs = {
			{id = 49222, o = 1, duration = 5, charges = 3, who = "self", c = "209020"},		-- Bone Shield
			{id = 57330, o = 3, duration = 2, who = "self", c = "808080",					-- Horn of Winter
				aliases = { 6673, 8076 },
				-- Battle Shout, Strength of Earth
            },
            {id = 48263, o = 5, who = "self", dup = 1, c = "F03030"},						-- Blood Presence
            {id = 48266, o = 6, who = "self", dup = 1, c = "3030F0"},						-- Frost Presence
            {id = 48265, o = 7, who = "self", dup = 1, c = "30F030"},						-- Unholy Presence
		}
	end

	local errors
	if (classBuffs) then
		self.classBuffs = {}
		for i,data in pairs(classBuffs) do
			if (data.id) then
				local name, _, icon = GetSpellInfo(data.id)
				if (name) then
					if (data.aliases) then
						data.aliasNames = {}
						for _,v in ipairs(data.aliases) do
							local name = GetSpellInfo(v)
							if name then
								data.aliasNames[name] = v
							end
						end
					end
					self.classBuffs[name] = data
				else
					-- Store the errors now till end, so the rest will still function even with unknown spells
					errors = (errors and (errors .. ", ") or "") .. tostring(data.id)
				end
			else
				self.classBuffs[i] = data
			end
		end
	else
		self.classBuffs = nil
		return
	end

	local altList = new()
	for k,v in pairs(self.classBuffs) do
		tinsert(altList, v)
	end

	local setLearnable = not self.db.char.notlearnable
	if (setLearnable) then
		self.db.char.notlearnable = {}
	end

	local rebuff = self.db.char.rebuff
	for k,v in pairs(self.classBuffs) do
		if (setLearnable) then
			if (v.noauto) then
				self.db.char.notlearnable[k] = true
			end
		end

		if (v.default and not not rebuff[k]) then
			rebuff[k] = v.default
		end

		if (v.who == "self" or v.who == "single" or v.who == "party") then
			--local t1, t2 = IsUsableSpell(k)
			local t1 = GetSpellCooldown(k)
			if (not t1) then	--not (t1 or t2)) then
				-- Remove any spells we don't have
				local o = v.o
				self.classBuffs[k] = nil

				for i = 1,#altList do
					if (altList[i].o > o) then
						altList[i].o = altList[i].o - 1
					end
				end
			end
		end
	end

	del(altList)

	self:MakeSpellOptions()
	self:MakeItemOptions()
	z:CheckForChange(self)

	if (errors) then
		error("No spell for spellID "..errors.." (class:".. playerClass ..")")
	end
end

-- OneOfYours
function zs:OneOfYours(spell)
	return self.classBuffs[spell]
end

-- GetSpellIcon
function zs:GetSpellIcon(spell)
	local info = self.classBuffs[spell]
	if (info) then
		local name, _, icon = GetSpellInfo(info.id)
		return icon
	else
		local icon = select(10, GetItemInfo(spell))
		if (icon) then
			return icon
		end
	end
end

local strClasses = {PALADIN = true, WARRIOR = true, DEATHKNIGHT = true}
local casterClasses = {MAGE = true, WARLOCK = true, PRIEST = true}

-- MakeSpellOptions
do
	local function setFunc(info)
		-- Untick any marked as 'dup' (Mutually exclusive buffs, such as Paladin Seals & Hunter Aspects)
		local k = info[#info]
		local b = zs.classBuffs[k]
		if (b) then
			local old = template[k]
			if (b.dup) then
				for i,s in pairs(zs.classBuffs) do
					if (b.dup == s.dup) then
						zs:ModifyTemplate(i, nil)
					end
				end
			end
			zs:ModifyTemplate(k, not old)
		end
		z:SetupForSpell()
		zs:CheckBuffs()
	end

	local function getLearnable(k)
		return not zs.db.char.notlearnable or not zs.db.char.notlearnable[k]
	end
	local function setLearnable(k, v)
		if (v == false) then
			if (not zs.db.char.notlearnable) then
				zs.db.char.notlearnable = {}
			end
			zs.db.char.notlearnable[k] = true
		else
			if (zs.db.char.notlearnable) then
				zs.db.char.notlearnable[k] = nil
				-- Don't nil this array, else next time we startup the defaults will be reset from the noauto values
			end
		end
	end

	local function getCharges(k)
		return zs.db.char.charges and zs.db.char.charges[k] or 0
	end
	local function setCharges(k, v)
		if (v and v > 0) then
			if (not zs.db.char.charges) then
				zs.db.char.charges = {}
			end
			zs.db.char.charges[k] = v
		else
			zs.db.char.charges[k] = nil
			if (not next(zs.db.char.charges)) then
				zs.db.char.charges = nil
			end
		end
	end

	local function getPrelude(k)
		return zs.db.char.rebuff[k] or 0
	end
	local function setPrelude(k, value)
		if ((not v or v == 0) and k ~= "default") then
			zs.db.char.rebuff[k] = nil
		else
			zs.db.char.rebuff[k] = value
		end
	end

	function zs:MakeSpellOptions()
		local any
		local args = {}

		local order = 1
		local notDone, needBreak
		for i = 1,25 do
			local done
			for k,v in pairs(self.classBuffs) do
				if (v.o == i and (v.who == "self" or v.who == "single" or v.who == "party")) then
					if (not v.exclude or not v.exclude()) then
						if (needBreak and any) then
							--args["header"..order] = {
							--	type = "header",
							--	name = " ",
							--	order = order,
							--}
							order = order + 1
						end
						needBreak = nil

						any = true
						notDone = nil
						done = true
						local cName
						if (v.c) then
							cName = format("|cFF%s%s|r", v.c, k)
						else
							cName = k
						end

						args[k] = {
							type = "group",
							name = cName,
							desc = cName,
							order = order,
							args = {
								enabled = {
									type = "toggle",
									name = L["Enabled"],
									desc = cName,
									get = function() return template[k] end,
									set = function(_, val) zs:ModifyTemplate(k, val) end,
									order = 1,
								},
								nolearn = {
									type = "toggle",
									name = L["Learnable"],
									desc = L["Remember this spell when it's cast manually?"],
									order = 2,
									get = function() return getLearnable(k) end,
									set = function(info, val) setLearnable(k, val) end,
								}
							}
						}

						if ((v.duration or 0) > 0) then
							args[k].args.rebuff = {
								type = "range",
								name = L["Expiry Prelude"],
								desc = format(L["Rebuff prelude for %s (0=Module default)"], v.rebuff or cName),
								func = timeFunc,
								order = 10,
								get = function() return getPrelude(k) end,
								set = function(info,val) setPrelude(k,val) end,
								min = 0,
								max = (v.duration / 2) * 60,
								step = (v.duration <= 60 and 1) or 5,
								bigStep = (v.duration <= 60 and 5) or 60,
							}
						end

						local c = v.charges
						if (c) then
							if (type(c) == "function") then
								c = c()
							end
							args[k].args.charges = {
								type = "range",
								name = L["Minimum Charges"],
								desc = L["Rebuff if number of charges left is less than defined amount"],
								func = timeFunc,
								order = 20,
								get = function() return getCharges(k) end,
								set = function(info,val) setCharges(k,val) end,
								min = 0,
								max = c,
								step = 1,
							}
						end

						order = order + 1
						break
					end
				end
			end

			if (not done and not notDone) then
				needBreak = true
			end
		end

		if (any) then
			if (not zs.options.args.spells) then
				zs.options.args.spells = {
					type = "group",
					name = L["Class Spells"],
					desc = L["Class spell configuration"],
					order = 1,
					hidden = function() return not zs:IsModuleActive() end,
					args = args,
				}
			end
		end

		del(list)
	end
end

local function getFunc(k)
	local a,b = strmatch(k, "^(%a+):(.+)$")
	if (a == "mainhand") then
		return b == template.mainhand
	elseif (a == "offhand") then
		return b == template.offhand
	elseif (a == "ranged") then
		return b == template.ranged
	end
end
local function setFunc(k,v)
	local a,b = strmatch(k, "^(%a+):(.+)$")
	zs.activeEnchant = nil
	zs:ModifyTemplate(a, v and b)
end

local function hideOHWeapon()
	return GetInventoryItemLink("player", 17) == nil
end
local function hideRangedWeapon()
	return playerClass ~= "ROGUE" or GetInventoryItemLink("player", 18) == nil
end

-- MakeItemOptions
function zs:MakeItemOptions()
	local any
	local args = {
	}

	for k,v in pairs(self.classBuffs) do
		if (v.who == "weapon") then
			local spell, item
			local t1, t2 = IsUsableSpell(k)
			spell = (t1 or t2) and k
			if (not spell) then
				item = k
			end
			if (spell or item) then
				local e1, e2, e3
				e1 = "mainhand:"..k
				e2 = "offhand:"..k
				e3 = "both:"..k
				e4 = "ranged:"..k

				local spellIcon
				if (item) then
					spellIcon = select(10, GetItemInfo(item))
				else
					spellIcon = v.id and select(3, GetSpellInfo(v.id))
				end

				any = true
				args[k] = {
					type = "group",
					name = spell or item,
					desc = spell or item,
					order = v.o,
					args = {
						mainhand = {
							type = "toggle",
							name = L["Main Hand"],
							desc = L["Use this item or spell on the main hand weapon"],
							order = 1,
							get = function() return getFunc(e1) end,
							set = function(info,val) setFunc(e1, val) end,
						},
						offhand = {
							type = "toggle",
							name = L["Off Hand"],
							desc = L["Use this item or spell on the off hand weapon"],
							order = 2,
							hidden = hideOHWeapon,
							get = function() return getFunc(e2) end,
							set = function(info,val) setFunc(e2, val) end,
						},
						ranged = {
							type = "toggle",
							name = L["Ranged"],
							desc = L["Use this item or spell on the ranged weapon"],
							order = 3,
							hidden = hideRangedWeapon,
							get = function() return getFunc(e4) end,
							set = function(info,val) setFunc(e4, val) end,
						},
					}
				}
			end
		end
	end

	if (any) then
		args.learnable = {
			type = "toggle",
			name = L["Learnable"],
			desc = L["Learnable"],
			order = 1000,
			hidden = true,
			get = function() return self.db.char.itemsLearnable end,
			set = function(k,n) self.db.char.itemsLearnable = n end,
		}

		if (not zs.options.args.item) then
			zs.options.args.item = {
				type = "group",
				name = L["Items"],
				desc = L["Item configuration"],
				order = 2,
				hidden = function() return not zs:IsModuleActive() end,
				args = {
				}
			}
		end
		zs.options.args.item.args = args
	end

	del(list)
end

-- ValidateTemplate
-- Cleanup a bug that would put any casted spell into the template..
function zs:ValidateTemplate(template)
	if (template) then
		for key in pairs(template) do
			local buff = self.classBuffs[key]
			if (not buff) then
				if (key ~= "modified" and key ~= "mainhand" and key ~= "offhand" and key ~= "ranged") then
					template[key] = nil
				end
			elseif (buff.who == "weapon") then
				template[key] = nil
			end
		end
	end
end

-- SelectTemplate
function zs:OnSelectTemplate(templateName)
	template = self:GetTemplates().current
	self:ValidateTemplate()

	for key,buff in pairs(self.classBuffs) do
		if (template[key]) then
			if (buff.onEnable) then
				buff.onEnable(key)
			end
		end
	end
end

-- OnModifyTemplate
function zs:OnModifyTemplate(key, value)
	if (value) then
		local buff = self.classBuffs[key]
		if (buff and buff.dup) then
			for k,v in pairs(self.classBuffs) do
				if (v.dup == buff.dup and k ~= key) then
					self:ModifyTemplate(k, nil)
				end
			end
		end

		local buff = self.classBuffs[key]
		if (buff and buff.onEnable) then
			buff.onEnable(key)
		end
	end
end

-- SpellCastFailed
function zs:SpellCastFailed(spell, rank, manual)
	if (not manual) then
		self.activeEnchant = nil
		self:CheckBuffs()
	end
end

-- ChecksAfterItemChanges
function zs:ChecksAfterItemChanges()
	self.activeEnchant = nil
	self:CheckBuffs()
	self:MakeItemOptions()
end

-- UNIT_INVENTORY_CHANGED
function zs:UNIT_INVENTORY_CHANGED(e, unit)
	if (unit == "player") then
		if (not any and minTimeLeft) then
			z:Schedule(self.ChecksAfterItemChanges, 5, self)
		else
			z:SchedCancel(self.ChecksAfterItemChanges)
		end

		if (self.checkReagentUsage) then
			if (self.checkReagentUsage.time + 5 >= GetTime()) then
				local count = GetItemCount(self.checkReagentUsage.reagent)

				if (count < self.checkReagentUsage.count) then
					local colourCount
					if (count < 2) then
						colourCount = "|cFFFF4040"
					elseif (count < 5) then
						colourCount = "|cFFFFFF40"
					else
						colourCount = "|cFF40FF40"
					end

					self:Printf(L["%s, %s%d|r %s remain"], self.checkReagentUsage.spell, colourCount, count, self.checkReagentUsage.reagent)
					self.checkReagentUsage = del(checkReagentUsage)
				end
			else
				self.checkReagentUsage = del(checkReagentUsage)
			end
		end
	end
end

-- OnSpellsChanged
function zs:OnSpellsChanged()
	playerName = UnitName("player")
	playerClass = select(2, UnitClass("player"))
	playerGUID = UnitGUID("player")
	self:GetClassBuffs()
end

-- SpellCastSucceeded
function zs:SpellCastSucceeded(spell, rank, target, manual)
	if (self.db.char.itemsLearnable) then
		local ospell = spell
		local buff = self.classBuffs[spell]
		if (buff and buff.who == "weapon") then
			if (z.icon and z.icon.mod == self) then
				z:SetupForSpell()
			end
			self.activeEnchant = nil
		end

		if (manual) then
			if (z:CanLearn() and (not zs.db.char.notlearnable or not zs.db.char.notlearnable[spell])) then
				if (buff) then
					if (buff.who == "weapon") then
						--self:ModifyTemplate("mainhand", spell)
						--z:SetupForSpell()			-- Avoid race condition with weapon buffs not refreshing immediately
					else
						self:ModifyTemplate(spell, true)
					end
				end
			end
		end
	end

	-- Check for a spell used with a consumable reagent not covered in raid/blessings
	if (self.notifySpells and self.db.char.reagentNotices) then
		local found = self.notifySpells[spell]
		if (found) then
			local reagent
			if (type(found) == "table") then
				reagent = found[rank]
				if (not reagent) then
					reagent = found[#found]
				end
			else
				reagent = found
			end

			if (reagent) then
				self.checkReagentUsage = {
					reagent = reagent,
					spell = spell,
					time = GetTime(),
					count = GetItemCount(reagent)
				}
			end
		end
	end
end

-- GetPaladinAuraKey
function zs:GetPaladinAuraKey()
	if (playerClass == "PALADIN") then
		if (template) then
			for spell in pairs(template) do
				for key,info in pairs(z.auras) do
					if (info.name == spell) then
						return info.key
					end
				end
			end
		end
	end
end

-- SetPaladinAuraKey
function zs:SetPaladinAuraKey(key)
	local aura = key and z.auras[key]
	if (aura) then
		self:ModifyTemplate(aura.name, true)
	else
		local oldaura = self:GetPaladinAuraKey()
		if (oldaura) then
			self:ModifyTemplate(z.auras[oldaura].name, nil)
		end
	end
end

-- TooltipOnClick
function zs:TooltipOnClick(name, subType)
	if (name) then
		if (name == "flask") then
			if (IsShiftKeyDown()) then
				self.db.char.flask = nil
				if (z.qTooltip) then
					z:OnTooltipUpdate()
				end
			end
		else
			if (IsShiftKeyDown()) then
				self:ModifyTemplate(name, nil)
			else
				local b
				if (weaponSlotNames[name]) then
					b = self.classBuffs[template[name]]
				else
					b = self.classBuffs[name]
				end

				local nextOne, firstOne, replaceTo
				local lowest = 99
				if (b and b.dup) then
					for find,s in pairs(self.classBuffs) do
						if (not s.exclude or s.exclude()) then
							if (b.dup == s.dup) then
								if (s.o < lowest) then
									lowest = s.o
									firstOne = find
								end
								if (s.o == b.o + 1) then
									replaceTo = find
								end
							end
						end
					end
				elseif (subType) then
					local lowest
					for find,s in pairs(self.classBuffs) do
						if (s.who == subType) then
							if (not lowest or s.o < lowest) then
								firstOne = find
							end
						end
					end
				end

				if (replaceTo or firstOne) then
					if (weaponSlotNames[name]) then
						self.activeEnchant = nil
						self:ModifyTemplate(name, replaceTo or firstOne)
					else
						if (name ~= (replaceTo or firstOne)) then
							self:ModifyTemplate(name, nil)
							self:ModifyTemplate(replaceTo or firstOne, true)
						end
					end
				end
			end
		end
	end
end

local function SuperTooltipOnClick(frame, keytype, button)
	if (button == "LeftButton") then
		return zs:TooltipOnClick(keytype)
	end
end

local function SuperTooltipOnClickItem(frame, keytype, button)
	if (button == "LeftButton") then
		return zs:TooltipOnClick(keytype, "weapon")
	end
end

-- AddItem
function zs:AddItem(tooltip, which, item)
	local name = weaponSlotNames[which]
	local itemName = item
	local checkIcon
	if (itemName) then
		checkIcon = select(10, GetItemInfo(itemName))
	end
	checkIcon = checkIcon and "|T"..checkIcon..":0|t " or ""

	local line = tooltip:AddLine("|cFFFFFF80"..name, itemName and (checkIcon.."|cFF80FF80"..itemName) or "|cFFFF8080"..NONE)
	tooltip:SetLineScript(line, "OnMouseDown", SuperTooltipOnClickItem, which)
end

-- SortedBuffList
function zs:SortedBuffList()
	local list = new()
	for name,info in pairs(self.classBuffs) do
		if (info.who == "self") then
			local insertPos = #list + 1
			for i,key in ipairs(list) do
				if (self.classBuffs[key].who == "self" and self.classBuffs[key].o > info.o) then
					insertPos = i
					break
				end
			end
			tinsert(list, insertPos, name)
		end
	end
	return list
end

-- HasItemOptions
function zs:HasItemOptions()
	for name,info in pairs(self.classBuffs) do
		if (info.who == "weapon") then
			return true
		end
	end
end

-- TooltipUpdate
function zs:TooltipUpdate(tooltip)
	if (template and self.classBuffs) then
		tooltip:AddSeparator(1, 0.5, 0.5, 0.5)
		tooltip:AddLine(L["Self Buffs Template: "].."|cFFFFFFFF"..(zs:GetSelectedTemplate() or L["none"]),
							(template and template.modified and "|cFFFF4040"..L["(modified)"].."|r") or "")

		local itemOptions = self:HasItemOptions()
		if (template.mainhand or itemOptions) then
			self:AddItem(tooltip, "mainhand", template.mainhand)
		end
		if (template.offhand or itemOptions) then
			if (OffhandHasWeapon()) then
				self:AddItem(tooltip, "offhand", template.offhand)
			end
		end

		local list = self:SortedBuffList()
		for i,key in ipairs(list) do
			if (template[key]) then
				local buff = self.classBuffs[key]
				local checkIcon = buff.id and select(3, GetSpellInfo(buff.id))
				local c = "|cFF"..((buff and buff.c) or "FFFF80")
				checkIcon = checkIcon and "|T"..checkIcon..":0|t " or ""

				local line = tooltip:AddLine(checkIcon..c..key)
				tooltip:SetLineScript(line, "OnMouseDown", SuperTooltipOnClick, key)
			end
		end
		del(list)

		local flask = getAlchFlask()
		if (self.db.char.flask and flask) then
			local checkIcon = select(10, GetItemInfo(flask))
			checkIcon = checkIcon and "|T"..checkIcon..":0|t " or ""

			local line = tooltip:AddLine(checkIcon..GetItemInfo(flask))
			tooltip:SetLineScript(line, "OnMouseDown", SuperTooltipOnClick, "flask")
		end
	end
end

-- OnModuleInitialize
function zs:OnModuleInitialize()
	self.db = z.db:RegisterNamespace("SelfBuffs",	{
		char = {
			useauto = true,
			itemsLearnable = true,
			templates = { Default = { classBuffs = {} }, current = {} },
			defaultTemplate = "Default",
			reagents = {},
			combatnotice = true,
			rebuff = {
				default = 30,
				[L["Seals"]] = 60,
			},
			reagentNotices = true,
		},
	} )

	--z:RegisterChatCommand({"/zomgself", "/zomgselfbuffs"}, zs.options)
	--self.OnMenuRequest = self.options
	--z.options.args.ZOMGSelfBuffs = self.options

	z:RegisterBuffer(self, 1)
	self:OnSpellsChanged()

	self.OnModuleInitialize = nil
end

-- OnResetDB
function zs:OnResetDB()
	template = self:GetTemplates().current
end

-- OnModuleEnable
function zs:OnModuleEnable()
	self:OnResetDB()

	playerName = UnitName("player")
	playerClass = select(2, UnitClass("player"))
	playerGUID = UnitGUID("player")

	self:OnSpellsChanged()
	z:MakeOptionsReagentList()

	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	z:CheckForChange(self)

	self:ValidateTemplate(template)
end

-- OnModuleDisable
function zs:OnModuleDisable()
	z:CheckForChange(self)
	self.classBuffs = nil
	self.activeEnchant = nil
end
