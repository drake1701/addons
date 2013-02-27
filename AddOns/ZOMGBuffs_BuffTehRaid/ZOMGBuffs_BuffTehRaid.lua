if (ZOMGBuffTehRaid) then
	ZOMGBuffs:Print("Installation error, duplicate copy of ZOMGBuffs_BuffTehRaid (Addons\ZOMGBuffs\ZOMGBuffs_BuffTehRaid and Addons\ZOMGBuffs_BuffTehRaid)")
	return
end

--[===[@debug@
local function d(...)
	ChatFrame1:AddMessage("ZOMG: "..format(...))
end
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):GetLocale("ZOMGBuffTehRaid")
local R = LibStub("AceLocale-3.0"):GetLocale("ZOMGReagents")
local SM = LibStub("LibSharedMedia-3.0")
local playerClass
local template

local z = ZOMGBuffs
local zg = z:NewModule("ZOMGBuffTehRaid", "AceBucket-3.0")
ZOMGBuffTehRaid = zg

z:CheckVersion("$Revision: 215 $")

local new, del, deepDel, copy = z.new, z.del, z.deepDel, z.copy
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

local function UnitFullName(unit)
	local name, server = UnitName(unit)
	if (server and server ~= "") then
		name = format("%s-%s", name, server)
	end
	return name
end

local function getOption(info)
	return zg.db.char[info[#info]]
end
local function setOption(info, value, update)
	if (not value or value == 0) then
		zg.db.char[info[#info]] = nil
	else
		zg.db.char[info[#info]] = value
	end
	if (update) then
		z:CheckForChange(zg)
	end
end

local function getProfileOption(info)
	return zg.db.profile[info[#info]]
end
local function setProfileOption(info, value, update)
	if (not value or value == 0) then
		zg.db.profile[info[#info]] = nil
	else
		zg.db.profile[info[#info]] = value
	end
	if (update) then
		z:CheckForChange(zg)
	end
end

local function getPrelude(info)
	return zg.db.char.rebuff[info[#info]] or 0
end
local function setPrelude(info, value)
	if (not value or value == 0) then
		zg.db.char.rebuff[info[#info]] = nil
	else
		zg.db.char.rebuff[info[#info]] = value
	end
	z:CheckForChange(zg)
end

do
	local function trackerDisabled()
		return not zg.db.profile.tracker
	end
	
	zg.options = {
		type = 'group',
		order = 2,
		name = "|cFFFF8080Z|cFFFFFF80O|cFF80FF80M|cFF8080FFG|rBuffTehRaid",
		desc = L["Group Buff Configuration"],
		handler = zg,
		get = getOption,
		set = setOption,
		args = {
			template = {
				type = 'group',
				name = L["Templates"],
				desc = L["Template configuration"],
				order = 50,
				hidden = function() return not zg:IsModuleActive() end,
				args = {
				}
			},
			tracker = {
				type = 'group',
				name = L["Tracker"],
				desc = L["Tracker Icon for single target exclusive buffs"],
				hidden = function() return not zg:IsModuleActive() end,
				order = 100,
				args = {
					tracker = {
						type = 'toggle',
						name = L["Enable"],
						desc = L["Create a tracking icon for certain exclusive spells (Earth Shield, Fear Ward). Note that the icon can always display the correct status of the spell, but if you change targets in combat then the click action will be to the player who it was last set to before entering combat"],
						order = 1,
					},
					lock = {
						type = 'toggle',
						name = L["Lock"],
						desc = L["Lock all the Tracker icons to their current position"],
						order = 10,
					},
					tracksound = {
						type = 'select',
						dialogControl = "LSM30_Sound",
						name = L["Sound"],
						desc = L["Select a soundfile to play when player's tracked buff expires"],
						get = getProfileOption,
						set = function(k,v)
							setProfileOption(k,v)
							PlaySoundFile(SM:Fetch("sound", v))
						end,
						values = AceGUIWidgetLSMlists.sound,
						disabled = function() return not SM or not zg.db.profile.tracker end,
						order = 20,
					},
					trackerscale = {
						type = 'range',
						name = L["Scale"],
						desc = L["Adjust the scale of the tracking icon"],
						func = timeFunc,
						get = getProfileOption,
						set = function(k,v)
							setProfileOption(k,v)
							if (zg.trackIcon) then
								zg.trackIcon:SetPosition()
							end
						end,
						disabled = trackerDisabled,
						min = 0,
						max = 2,
						isPercent = true,
						step = 0.05,
						order = 150,
					},
					reset = {
						type = 'execute',
						name = L["Reset"],
						desc = L["Reset the position of the tracker icon"],
						order = 200,
						disabled = trackerDisabled,
						func = function() zg.db.char.postracker = nil end,
					}
				}
			},
			behaviour = {
				type = 'group',
				name = L["Behaviour"],
				desc = L["Group buffing behaviour"],
				order = 201,
				hidden = function() return not zg:IsModuleActive() end,
				args = {
					default = {
						type = 'range',
						name = L["Expiry Prelude"],
						desc = L["Default rebuff prelude for all group buffs"],
						func = timeFunc,
						order = 2,
						get = getPrelude,
						set = setPrelude,
						min = 0,
						max = 15 * 60,
						step = 1,
						bigStep = 15,
						order = 100,
					},
				},
			},
		}
	}
end

-- ColourSpellFromKey(key)
local function ColourSpellFromKey(key)
	local name = key.name or key.spellname
	local colour = z:HexColour(unpack(key.colour or {1, 1, 1}))
	return format("%s%s|r", colour, name), colour
end

-- ToggleKeyType
local function ToggleKeyType(keytype, onoff)
	if (onoff == nil) then
		onoff = not template[keytype]
	end

	if (onoff) then
		zg:ModifyTemplate(keytype, true)
		z:SetupForSpell()
		zg:CheckBuffs()
		if (not z:IsSpellReady()) then
			z:RequestSpells()
		end
	else
		zg:ModifyTemplate(keytype, nil)
		z:CheckForChange(zg)
	end
end

-- OnModifyTemplate
function zg:ExclusiveTarget(key)
	if (template[key]) then
		local buff = self.buffs[key]
		if (buff and buff.exclusive) then
			local list = template.limited and template.limited[key]
			if (list) then
				return (next(list))
			end
		end
	end
end

-- OnModifyTemplate
function zg:OnModifyTemplate(key, value)
	local buff = self.buffs[key]
	if (buff) then
		if (buff.limited) then
			if (value) then
				local enDone
				self:RegisterTickColumn(key)

				if (not template.limited or not template.limited[key]) then
					if (not template.limited) then
						template.limited = new()
					end
					if (not template.limited[key]) then
						template.limited[key] = new()
					end

					if (buff.exclusive) then
						if (not buff.notself) then
							template.limited[key][UnitName("player")] = true
						end
					else
						for unit, unitname, unitclass, subgroup, index in z:IterateRoster() do
							template.limited[key][unitname] = true
						end
					end
				end

				if (buff.exclusive) then
					if (template.limited and template.limited[key]) then
						local name = next(template.limited[key])
						if (name) then
							if (UnitInParty(name) or UnitInRaid(name)) then
								self:AddSpellTracker(key, name)
								if (buff.onEnable) then
									buff.onEnable(name)
									enDone = true
								end
							end
						end
					end
				end

				if (not enDone and buff.onEnable) then
					buff.onEnable()
				end
			else
				self:UnregisterTickColumn(key)
				self:StopSpellTracker(key)
			end
		elseif buff.dup and value then
			for i,s in pairs(self.buffs) do
				if (buff.dup == s.dup and i ~= key) then
					self:ModifyTemplate(i, nil)
				end
			end
		end
	end
end

do
	local function getLearnable(k)
		return not zg.db.char.notlearnable or not zg.db.char.notlearnable[k]
	end
	local function setLearnable(k, v)
		if (v == false) then
			if (not zg.db.char.notlearnable) then
				zg.db.char.notlearnable = {}
			end
			zg.db.char.notlearnable[k] = true
		else
			if (zg.db.char.notlearnable) then
				zg.db.char.notlearnable[k] = nil
				-- Don't nil this array, else next time we startup the defaults will be reset from the noauto values
			end
		end
	end

	local function getKeybinding(k)
		return zg.db.char.keybindings[k]
	end
	local function setKeybinding(k, v)
		local oldkey = zg.db.char.keybindings[k]
		if (oldKey) then
			SetBinding(oldKey, nil)
		end
		zg.db.char.keybindings[k] = v
		zg:SetTrackerKeyBindings()
	end

	local function getAutocast(k)
		return zg.db.char.noautocast[k]
	end
	local function setAutocast(k, v)
		zg.db.char.noautocast[k] = v and true or nil
		z:SetupForSpell()
		zg:CheckBuffs()
	end
	local function getPrelude(k)
		return zg.db.char.rebuff[k] or 0
	end
	local function setPrelude(k, value)
		if (not value or value == 0) then
			zg.db.char.rebuff[k] = nil
		else
			zg.db.char.rebuff[k] = value
		end
		z:CheckForChange(zg)
	end

	-- SetMenu
	function zg:MakeSpellOptions()
		if (self.options.args.singlespells or self.options.args.groupspells) then
			return
		end

		local groupArgs, singleArgs

		local list = self:SortedBuffList()
		for i,key in ipairs(list) do
			local info = self.buffs[key]
			if (GetSpellInfo(info.spellname)) then
				local name = info.name or info.spellname
				local cName = ColourSpellFromKey(info)
				local menu = {
					type = "group",
					name = cName,
					desc = cName,
					order = i,
					args = {
					}
				}

				menu.args.nolearn = {
					type = "toggle",
					name = L["Learnable"],
					desc = L["Remember this spell when it's cast manually?"],
					order = 1,
					get = function() return getLearnable(key) end,
					set = function(_, val) setLearnable(key, val) end,
				}

				if (not info.noaura) then
					menu.args.rebuff = {
						type = "range",
						name = L["Expiry Prelude"],
						desc = format(L["Rebuff prelude for %s (0=Module default)"], cName),
						func = timeFunc,
						order = 50,
						get = function() return getPrelude(key) end,
						set = function(_, val) setPrelude(key, val) end,
						min = 0,
						max = 30 * 60,
						step = 1,
						bigStep = 15,
					}
				end

				if (info.limited) then
					if (info.exclusive) then
						menu.args.noautocast = {
							type = 'toggle',
							name = L["No Auto-cast"],
							desc = format(L["Disables auto-casting for %s in favor of rebuffing via tracker icons or their hotkeys"], cName),
							get = function() return getAutocast(key) end,
							set = function(_, val) setAutocast(key, val) end,
							order = 5,
						}

						menu.args.keybinding = {
							type = 'keybinding',
							name = L["Key-Binding"],
							desc = format(L["Define the key used for rebuffing %s from it's Spell Tracker icon"], cName),
							get = function() return getKeybinding(key) end,
							set = function(_, val) setKeybinding(key, val) end,
							order = 20,
						}
					end

					if (not singleArgs) then
						local menu = {
							type = 'group',
							name = L["Single Spells"],
							desc = L["Single spell configuration"],
							order = 5,
							args = {
								resetOnClear = {
									type = 'toggle',
									name = L["Reset on Clear"],
									desc = L["If noone is selected for this buff when you disable it, then the next time it is enabled, everyone will default to ON. If disabled, the last settings will be remembered"],
									get = getProfileOption,
									set = setProfileOption,
									order = 1000,
								},
							}
						}
						self.options.args.singlespells = menu
						singleArgs = menu.args
					end

					singleArgs[name] = menu
				else
					if (not groupArgs) then
						local menu = {
							type = 'group',
							name = L["Group Spells"],
							desc = L["Group spell configuration"],
							order = 1,
							args = {
							}
						}
					
						self.options.args.groupspells = menu
						groupArgs = menu.args
					end

					groupArgs[name] = menu
				end
			end
		end
		del(list)
	end
end

-- TickInitForTemplate
function zg:TickInitForTemplate()
	self:MakeTickLookup()

	for Type,buff in pairs(self.buffs) do
		if (buff.limited) then
			if (template[Type]) then
				local enDone
				self:RegisterTickColumn(Type)

				if (buff.exclusive) then
					if (template.limited and template.limited[Type]) then
						local name = next(template.limited[Type])
						if (name) then
							if (not buff.notself or not UnitIsUnit(name, "player")) then
								if (name == "pet" or UnitPlayerOrPetInParty(name) or UnitPlayerOrPetInRaid(name)) then
									self:AddSpellTracker(Type, name)
									if (buff.onEnable) then
										buff.onEnable(name)
										enDone = true
									end
								end
							end
						end
					end
				end

				if (not enDone and buff.onEnable) then
					buff.onEnable()
				end
			else
				self:UnregisterTickColumn(Type)
				self:StopSpellTracker(Type)
			end
		end
	end

	if (z.icon and z.members) then
		z:DrawGroupNumbers()
		z:DrawAllCells()
	end
end

-- SelectTemplate
function zg:OnSelectTemplate(templateName)
	template = self:GetTemplates().current
	self:TickInitForTemplate()
end

-- GetBuffedMembers
function zg:GetBuffedMembers()
	local temp = new()
	local totals = 0
	local minTimeLeft
	local totalMembers, totalPresent = 0, 0
	local anyBlacklisted
	local notInRaid = not UnitInRaid("player")

	for unitid, unitname, unitclass, grp, index in z:IterateRoster() do
		anyBlacklisted = anyBlacklisted or z:IsBlacklisted(unitname)
		totalMembers = totalMembers + 1
		totals = totals + 1

		if (notInRaid) then
			local pvpBlock = (z.db.profile.skippvp and UnitIsPVP(unitid)) and not UnitIsPVP("player")
			local present = UnitIsConnected(unitid) and UnitCanAssist("player", unitid) and not pvpBlock
			local absent						-- They're not in zone, afk, or offline
			if (not present and z.db.profile.ignoreabsent) then
				if (pvpBlock) then
					absent = true
				elseif (not UnitIsConnected(unitid)) then
					absent = true
				elseif (UnitIsAFK(unitid)) then
					absent = true
				end
			end

			if (present) then
				local foundBuffs
				local manaUser = z.manaClasses[unitclass]	--   UnitPowerType(unitid) == 0
				totalPresent = totalPresent + 1

				if (not manaUser) then
					foundBuffs = new()
				end

				for i = 1,40 do
					local name, rank, buff, count, _, maxDuration, endTime, isMine = UnitBuff(unitid, i)
					if (not name) then
						break
					end
					
					local buff = self.lookup[name]
					if (buff) then
						local dur = maxDuration and maxDuration ~= 0 and endTime and (endTime - GetTime())
						if (template[buff.type]) then
							if (not manaUser) then
								foundBuffs[buff.type] = true
							end

							local requiredTimeLeft = (self.db.char.rebuff and self.db.char.rebuff[buff.type]) or self.db.char.rebuff.default
							local needsBuff = not buff.onlyManaUsers or manaUser
							if (not needsBuff or (not requiredTimeLeft or not dur or dur > requiredTimeLeft)) then
								temp[buff.type] = (temp[buff.type] or 0) + 1
							end

							if (needsBuff and dur and (not minTimeLeft or dur - requiredTimeLeft < minTimeLeft)) then
								minTimeLeft = dur - requiredTimeLeft
							end
						end
					end
				end

				if (not manaUser) then
					for key,info in pairs(self.buffs) do
						if (info.onlyManaUsers and not foundBuffs[key]) then
							temp[key] = (temp[key] or 0) + 1
						end
					end
					del(foundBuffs)
				end

			elseif (absent) then
				totalPresent = totalPresent + 1
				for code,info in pairs(self.buffs) do
					temp[code] = (temp[code] or 0) + 1
				end
			end
		end
	end

	return temp, totals, minTimeLeft, totalPresent / totalMembers, anyBlacklisted
end

-- FindUnitInRangeMissing
function zg:FindUnitInRangeMissing(typ)
	local t = self.buffs[typ]
	if (not t) then
		error(format("Unrecognised type %q", tostring(typ)), 2)
	end
	local buffEveryone = not t.onlyManaUsers
	local rangeCheckSpell = t.spellname
	local limitedPeople = t.limited and template.limited and template.limited[typ]

	local requiredTimeLeft = (self.db.char.rebuff and self.db.char.rebuff[typ]) or self.db.char.rebuff.default

	for unitid, unitname, unitclass in z:IterateRoster() do
		local manaUser = z.manaClasses[unitclass]
		if (buffEveryone or manaUser) then
			if (not t.limited or (limitedPeople and limitedPeople[unitname])) then
				if (not z:IsBlacklisted(unitname)) then
					if (UnitIsConnected(unitid) and UnitCanAssist("player", unitid) and IsSpellInRange(rangeCheckSpell, unitid) == 1 and ((not z.db.profile.skippvp or not UnitIsPVP(unitid)) or UnitIsPVP("player"))) then
						local got
						for i = 1,40 do
							local name, rank, buff, count, _, max, endTime = UnitBuff(unitid, i)
							if (not name) then
								break
							end

							local buff = self.lookup[name]
							if (buff and buff.type == typ) then
								local dur = endTime and (endTime - GetTime())
								if (max and max ~= 0 and dur and dur < requiredTimeLeft) then
									return unitid
								end
								got = true
								break
							end
						end

						if (not got) then
							return unitid
						end
					end
				end
			end
		end
	end
end

-- CheckBuffsTimer
function zg:CheckBuffsTimer()
	self:CheckBuffs()
end

-- CheckBuffs
function zg:CheckBuffs()
	if (not self.db or not template or not z:CanCheckBuffs()) then
		return
	end

	local temp, totals, minTimeLeft, percentPresent, anyBlacklisted = self:GetBuffedMembers()
	local db = self.db.char

	if (z.db.profile.waitforraid > 0 and not InCombatLockdown()) then
		-- See if enough of raid present
		if (percentPresent < z.db.profile.waitforraid) then	-- Wait for % of raid before buffing
			z.waitingForRaid = floor(percentPresent * 100)
			z:Schedule(self.CheckBuffsTimer, 5, self)
			return
		end
	end
	z.waitingForRaid = nil

	-- Now go through this and find anything we need to buff
	local notInRaid = not IsInRaid()
	local any
	
	if (totals > 0) then
		for k,v in pairs(template) do			-- k = spellType (INT, STA etc.), v = buff data for that type
			if (k ~= "modified" and k ~= "state" and k ~= "limited") then
				local typeSpec = self.buffs[k]
				if (typeSpec and not zg.db.char.noautocast[typeSpec.type]) then
					local spell = typeSpec.spellname
					local start, dur = GetSpellCooldown(spell)
					local now, later = IsUsableSpell(spell)
					if (now and (start == 0 or GetTime() - 0.5 > start + dur)) then
						local gotBuff = temp[k] or 0
						if (not gotBuff or gotBuff < totals) then
							local missingBuff = totals - gotBuff

							local unit = self:FindUnitInRangeMissing(k)
							if (unit) then
								local colour = typeSpec.colour and z:HexColour(unpack(typeSpec.colour))
								local toBuff = typeSpec.spellname
								local whoNotice = typeSpec.group and ((GetNumGroupMembers() > 0 and RAID) or (GetNumGroupMembers() > 0 and PARTY)) or z:ColourUnit(unit)
								z:Notice(format(L["%s needs %s"], whoNotice, z:LinkSpell(toBuff, colour, true, z.db.profile.short and typeSpec.name)), "buffreminder")
								any = true

								local special = typeSpec.spellPrefs and typeSpec.spellPrefs[toBuff]
								if (special and IsUsableSpell(special)) then
									z:SetupForSpell(unit, special, self)
								else
									z:SetupForSpell(unit, toBuff, self)
								end

								if (any) then
									break
								end
							end
						end
					else
						if (not now) then
							minTimeLeft = 10		-- Check again in 10 secs, not enough mana atm
						else
							-- Set min time left to cooldown end for this spell
							local minTimeLeft2 = min((start + dur) - GetTime(), minTimeLeft or 0)
							if (minTimeLeft2 >= 0.02 and (not minTimeLeft or minTimeLeft2 < minTimeLeft)) then
								minTimeLeft = minTimeLeft2
							end
						end
					end
				end
			end
		end
	end

	if (anyBlacklisted) then
		minTimeLeft = 1.5
	end
	if (any) then
		z.waitingForRaid = nil
		z:SchedCancel(self.CheckBuffsTimer)
	elseif not self.timerCheck then
		z:Schedule(self.CheckBuffsTimer, minTimeLeft or 60, self)
	end
end

-- UNIT_AURA
function zg:UNIT_AURA(e, unit)
	if (not InCombatLockdown()) then
		if (UnitInParty(unit) or UnitInRaid(unit)) then
			local spell = z.icon and z.icon:GetAttribute("spell")
			if (spell) then
				local buff = self.lookup[spell]
				if (buff) then
					local queuedUnit = z.icon and z.icon:GetAttribute("unit")
					if (queuedUnit) then
						local match
						if (buff.group) then
							match = z:GetGroupNumber(queuedUnit) == z:GetGroupNumber(unit)
						else
							match = UnitIsUnit(unit, queuedUnit)
						end

						if (match) then
							local found
							for i = 1,40 do
								local name = UnitBuff(unitid, i)
								if (not name) then
									break
								end

								local buff2 = self.lookup[name]
								if (buff2) then
									if (buff2.type == buff.type) then
										found = true
									end
								end
							end

							if (found) then
								-- They have just been buffed with what we have queued, so clear this queue item and re-check
								z:SetupForSpell()
								self:CheckBuffs()
							end
						end
					end
				end
			end
		end
	end
end

-- GetActionInsert
function zg:GetActionInsert(buff)
	local spellname = buff.spellname
	local altbuff = buff.spellPrefs and buff.spellPrefs[spellname]
	if (altbuff and IsUsableSpell(altbuff)) then
		spellname = altbuff
	end
	tinsert(self.actions, {name = spellname, type = buff.keycode})
end

-- GetActions
function zg:GetActions()
	if (self.buffs and not self.actions) then
		self.actions = {}

		local list = self:SortedBuffList()
		for i,key in ipairs(list) do
			local buff = self.buffs[key]

			if (buff.spellname and GetSpellInfo(buff.spellname)) then		-- GetSpellCooldown(buff.list[1])) then
				if (buff.keycode) then
					self:GetActionInsert(buff)
				end
			end
		end

		del(list)
	end
	return self.actions
end

-- ResetActions
function zg:ResetActions()
	self.actions = nil
end

-- RebuffQuery
function zg:RebuffQuery(unit)
	if (self.db and template and UnitIsConnected(unit) and UnitCanAssist("player", unit) and not UnitIsDeadOrGhost(unit)) then
		local got = new()

		for i = 1,40 do
			local name = UnitBuff(unit, i)
			if (not name) then
				break
			end

			local info = self.lookup[name]
			if (info) then
				got[info.type] = true
			end
		end

		local _, class = UnitClass(unit)
		local manaUser = class and z.manaClasses[class]			--  UnitPowerType(unit) == 0
		local limited = template.limited
		for key,info in pairs(self.buffs) do
			if (template[key] and not got[key]) then
				if (not info.onlyManaUsers or manaUser) then
					if (info.limited) then
						if (limited and limited[key] and limited[key][UnitFullName(unit)]) then
							del(got)
							return true
						end
					else
						del(got)
						return true
					end
				end
			end
		end

		del(got)
	end

	return
end

-- OnModuleInitialize
function zg:OnModuleInitialize()
	playerClass = select(2, UnitClass("player"))

	if (playerClass == "PRIEST") then
		self.buffs = {
			STA = {
				o = 1,
				name = SPELL_STAT3_NAME,
				id = 21562,
				group = true,
				aliases = { 6307, 469 },	-- Commanding Shout, Blood Pact
				required = true,
				colour = {0.7, 0.7, 1},
				keycode = "stamina",
			},
-- DEPRECATED			SHADOWPROT = {
-- DEPRECATED				o = 2,
-- DEPRECATED				id = 27683,
-- DEPRECATED				group = true,
-- DEPRECATED				colour = {0.7, 0.2, 0.7},
-- DEPRECATED				keycode = "shadowprot",
-- DEPRECATED			},
			FEARWARD = {
				o = 3,
				id = 6346,
				colour = {1, 0.7, 0.3},
				limited = true,						-- Allow limited targets config
				exclusive = true,					-- Can only be cast on 1 target
				keycode = "fearward",
			}
		}

	elseif (playerClass == "DRUID") then
		self.buffs = {
			MARK = {
				o = 1,
				name = L["Mark"],
				id = 1126,
				aliases = { 20217 },					-- Blessing of Kings
				group = true,
				required = true,
				colour = {0.9, 0.5, 0.9},
				keycode = "mark",
			},
-- DEPRECATED			THORNS = {
-- DEPRECATED				o = 2,
-- DEPRECATED				id = 467,
-- DEPRECATED				colour = {0.7, 0.7, 0.3},
-- DEPRECATED				limited = true,						-- Allow limited targets config
-- DEPRECATED				keycode = "thorns",
-- DEPRECATED			}
		}

	elseif (playerClass == "MAGE") then
		self.buffs = {
			INT = {
				o = 1,
				name = SPELL_STAT4_NAME,
				id = 1459,
				spellPrefs = {
					[GetSpellInfo(1459)] = GetSpellInfo(61316),	-- Dalaran Brilliance
				},
				group = true,
				required = true,
				onlyManaUsers = true,
				colour = {0.3, 0.3, 1},
				keycode = "int"
			},
-- DEPRECATED			FOCUSMAGIC = {
-- DEPRECATED				o = 2,
-- DEPRECATED				id = 54646,						-- Focus Magic
-- DEPRECATED				onlyManaUsers = true,
-- DEPRECATED				colour = {0.80, 0.2, 1},
-- DEPRECATED				limited = true,						-- Allow limited targets config
-- DEPRECATED				exclusive = true,					-- Can only be cast on 1 tarrget
-- DEPRECATED				notself = true,
-- DEPRECATED				keycode = "focusmagic",
-- DEPRECATED				defaultRebuff = 5,
-- DEPRECATED			} 
		}
	elseif (playerClass == "SHAMAN") then
		self.buffs = {
			EARTHSHIELD = {
				o = 1,
				id = 974,
				onEnable = function(unit)
					if (unit and UnitIsUnit("player", unit)) then
						local zs = ZOMGSelfBuffs
						if (zs) then
							zs:ModifyTemplate((GetSpellInfo(324)), nil)		-- Lightning Shield
							zs:ModifyTemplate((GetSpellInfo(52127)), nil)		-- Water Shield
						end
					end
				end,
				colour = {0.7, 0.7, 0.2},
				limited = true,						-- Allow limited targets config
				exclusive = true,					-- Can only be cast on 1 target
				stacks = 9,
				keycode = "earthshield",
			},
			WATERWALK = {
				o = 2,
				id = 546,						-- Water Walking
				reagent = 17058,					-- Fish Oil
				colour = {0.5, 0.5, 1},
				limited = true,						-- Allow limited targets config
				nopet = true,
				keycode = "water",
			},
-- DEPRECATED			WATERBREATH = {
-- DEPRECATED				o = 2,
-- DEPRECATED				id = 131,						-- Water Breathing
-- DEPRECATED				reagent = 17057,					-- Shiny Fish Scales
-- DEPRECATED				colour = {0.2, 0.8, 1},
-- DEPRECATED				limited = true,						-- Allow limited targets config
-- DEPRECATED				nopet = true,
-- DEPRECATED				keycode = "breath",
-- DEPRECATED			}
		}
	
	elseif (playerClass == "WARLOCK") then
		self.buffs = {
-- DEPRECATED			DARKINTENT = {
-- DEPRECATED				o = 1,
-- DEPRECATED				id = 80398,
-- DEPRECATED				colour = {0.43, 0, 1},
-- DEPRECATED				limited = true,						-- Allow limited targets config
-- DEPRECATED				exclusive = true,					-- Can only be cast on 1 tarrget
-- DEPRECATED				notself = true,
-- DEPRECATED				keycode = "darkintent",
-- DEPRECATED				defaultRebuff = 5,
-- DEPRECATED			},
			WATERBREATH = {
				o = 2,
				id = 5697,						-- Unending Breath
				colour = {0.4, 0.6, 1},
				limited = true,						-- Allow limited targets config
				keycode = "breath",
			}
		}

	elseif (playerClass == "PALADIN") then
		self.buffs = {
			KINGS = {
				o = 1,
				id = 20217,
				aliases = { 1126 },					-- Mark of the Wild
				group = true,
				required = true,
				dup = 1,
				colour = {1, 0.5, 1},
				keycode = "kings",
			},
			MIGHT = {
				o = 2,
				id = 19740,
				group = true,
				dup = 1,
				colour = {1, 0.5, 0.5},
				keycode = "might",
			},
			BEACON = {
				o = 3,
				id = 53563,						-- Beacon of Light
				colour = {1, 1, 0.5},
				limited = true,						-- Allow limited targets config
				exclusive = true,
				keycode = "beacon",
				defaultRebuff = 5,
			},
			FREEDOM = {
				o = 4,
				id = 1044,						-- Hand of Freedom
				colour = {1, 0.8, 0.1},
				limited = true,						-- Allow limited targets config
				exclusive = true,
				keycode = "freedom",
				defaultRebuff = 5,
			},
			SACRIFICE = {
				o = 5,
				id = 6940,						-- Hand of Sacrifice
				colour = {1, 0, 0},
				limited = true,						-- Allow limited targets config
				exclusive = true,
				notself = true,
				keycode = "sacrifice",
				defaultRebuff = 5,
			},
		}	
	elseif (playerClass == "WARRIOR") then
		self.buffs = {
-- DEPRECATED			VIGILANCE = {
-- DEPRECATED				o = 1,
-- DEPRECATED				id = 50720,						-- Vigilance
-- DEPRECATED				colour = {1, 1, 0.7},
-- DEPRECATED				limited = true,						-- Allow limited targets config
-- DEPRECATED				exclusive = true,
-- DEPRECATED				notself = true,
-- DEPRECATED				keycode = "vigilance",
-- DEPRECATED			},
		}

	elseif (playerClass == "ROGUE") then
		self.buffs = {
			TRICKS = {
				o = 1,
				id = 57934,						-- Tricks of the Trade
				colour = {0.3, 1, 0.7},
				limited = true,						-- Allow limited targets config
				exclusive = true,
				notself = true,
				noaura = true,						-- This gives no aura when applied, and should not auto learn on cast
				noautobuff = true,					-- Special case for Tricks
				keycode = "tricks",
			},
		}

	elseif (playerClass == "DEATHKNIGHT") then
		self.buffs = {
			TRICKS = {
				o = 1,
				id = 49016,						-- Unholy Frenzy (was hysteria before)
				colour = {0.3, 1, 0.7},
				limited = true,						-- Allow limited targets config
				exclusive = true,
				keycode = "tricks",
			},
		}
	end

	if (not self.buffs) then
		return
	end

	self.keycodeLookup = del(self.keycodeLookup)
	self.keycodeLookup = new()
	self.spellIcons = new()
	for key,info in pairs(self.buffs) do
		local name, _, icon = GetSpellInfo(info.id)
		if (not name) then
			error("No spell info for SpellID "..info.id)
		end
		info.spellname = name
		self.spellIcons[name] = icon
		self.keycodeLookup[info.keycode] = key
	end
	
	z:RegisterSetClickSpells(self, function(self, cell)
		if (zg.actions) then
			for i,action in ipairs(zg.actions) do
				local Mod, button = z:GetActionClick(action.type)
				if (button) then
					local key = self.keycodeLookup[action.type]
					local buff = key and self.buffs[key]
					if (not buff or not buff.notself) then
						z:SetACellSpell(cell, Mod, button, action.name)
					end
				end
			end
		end
	end)

	local defaultForClass = {Default = {}, current = {}}
	for k,v in pairs(self.buffs) do
		if (v.required) then
			defaultForClass.Default[k] = true
		end
	end

	self.db = z.db:RegisterNamespace("BuffTehRaid",	{
		char = {
			noautocast = {TRICKS = true},
			reagent = {},
			keybindings = {},
			templates = defaultForClass,
			defaultTemplate = "Default",
			groupcast = 2,
			rebuff = {
				default = 30,
			},
			notlearnable = {TRICKS = true},
		},
		profile = {
			tracksound = "Gong",
			tracker = true,
			trackerscale = 1,
			resetOnClear = true,
		}
	} )

	self.lookup = {}
	self.required = 0
	for k,v in pairs(self.buffs) do
		v.type = k
		self.lookup[v.spellname] = v

		if v.aliases then
			for _, aliasid in ipairs(v.aliases) do
				local name = GetSpellInfo(aliasid)
				if (not name) then
					error("No spell info for SpellID "..aliasid)
				end
				self.lookup[name] = v
			end
		end
	end
	if (playerClass == "MAGE") then
		self.lookup[GetSpellInfo(61316)] = self.buffs.INT			-- Dalaran Brilliance
		--self.lookup[GetSpellInfo(57567)] = self.buffs.INT			-- Fel Intellegence	(only for improved.. need to detect who cast it... sigh)
	end

	for k,buff in pairs(self.buffs) do
		if (buff.limited) then
			self:RegisterTickHandler(k, self, zg.TickColumnCallback, buff.spellname, buff.id)
		end
	end

	z:RegisterBuffer(self)

	self.OnModuleInitialize = nil
end

-- GetSpellIcon
function zg:GetSpellIcon(spell)
	return self.spellIcons[spell]
end

-- TickColumnCallback
function zg:TickColumnCallback(unit, key, enable)
	local handler = self.tickHandlers[key]
	if (not handler) then
		error(format("No handler for key %q", tostring(key)), 2)
	end
	local column = self.tickColumnLookup[key]
	if (not column) then
		error(format("No column for key %q", tostring(key)), 2)
	end
	if (column) then
		local name = UnitFullName(unit)
		if (name) then
			if (enable == nil) then
				local list = template.limited and template.limited[key]
				return (list and list[name] and 1) or nil
			else
				if (enable) then
					self:AddLimitedSpell(name, key)
				else
					self:RemoveLimitedSpell(name, key)
				end
			end
		end
	end
end

-- RegisterTickHandler
function zg:RegisterTickHandler(id, Module, Func, spellname, spellid)
	if (not self.tickHandlers) then
		self.tickHandlers = {}
	end
	self.tickHandlers[id] = {module = Module, func = Func, spell = spellname, spellID = spellid}
end

-- RegisterTickColumn
function zg:RegisterTickColumn(key)
	if (not self:IsTickColumnRegistered(key)) then
		if (not self.tickHandlers[key]) then
			error(format("No handler for key %q", tostring(key)), 2)
		end
		if (not self.tickColumns) then
			self.tickColumns = {}
		end
		tinsert(self.tickColumns, key)
		self.anyTickColumns = true

		self:MakeTickLookup()

		if (z.icon and z.members) then
			z:DrawGroupNumbers()
			z:DrawAllCells()
		end
	end
end

-- MakeTickLookup
function zg:MakeTickLookup()
	if (self.tickColumns) then
		del(self.tickColumnLookup)
		self.tickColumnLookup = new()
		for i,key in ipairs(self.tickColumns) do
			self.tickColumnLookup[key] = i
		end
	end
end

-- RegisterTickColumn
function zg:UnregisterTickColumn(key)
	local index = self:IsTickColumnRegistered(key)
	if (index) then
		tremove(self.tickColumns, index)

		if (z.icon and z.members) then
			z:DrawGroupNumbers()
			z:DrawAllCells()
		end
	end
end

-- IsTickColumnRegistered
function zg:IsTickColumnRegistered(id)
	if (self.tickColumns) then
		for i,key in ipairs(self.tickColumns) do
			if (key == id) then
				return i
			end
		end
	end
end

-- tickOnClick
local function tickOnClick(self, button)
	if (not zg.tickColumns) then
		-- Shouldn't be happening
		return
	end
	local index = self:GetID()
	local parent = self:GetParent()
	local unitid = parent:GetAttribute("unit")
	local key = zg.tickColumns[index]
	local handler = zg.tickHandlers[key]
	local buff = zg.buffs[key]
	if (not key) then
		error(format("No key for column %s", tostring(index)))
	end
	if (not handler) then
		error(format("No handler for %q", tostring(key)))
	end
	if (not buff) then
		error(format("No buff for %q", tostring(key)))
	end

	if (buff.notself and UnitIsUnit("player", unitid)) then
		self:SetChecked(nil)
	else
		local enable = self:GetChecked() and true or false
		local offIndex

		if (buff.dup and enable) then
			-- If it's a dup type buff (amplify/dampen magic), then turn off the matching buff for what we turned on
			for key2, buff2 in pairs(zg.buffs) do
				if (buff2.dup == buff.dup and key2 ~= key) then
					local index2 = zg:IsTickColumnRegistered(key2)
					if (index2) then
						offIndex = index2
					end
				end
			end
		end

		if (not buff.exclusive and button == "LeftButton" and IsAltKeyDown()) then
			local class = select(2, UnitClass(unitid))
			local func = function(unit) return select(2, UnitClass(unit)) == class end
			zg:TickSome(index, func, enable)	-- Tick all of this class
			if (offIndex) then
				zg:TickSome(offIndex, func, false)
			end

		elseif (not buff.exclusive and button == "LeftButton" and IsShiftKeyDown()) then
			local group = z:GetGroupNumber(unitid)
			local func = function(unit) local g1 = z:GetGroupNumber(unit) return g1 and g1 == group end
			zg:TickSome(index, func, enable)
			if (offIndex) then
				zg:TickSome(offIndex, func, false)
			end

		elseif (not buff.exclusive and button == "RightButton") then
			zg:TickSome(index, nil, enable)												-- Tick everyone
			if (offIndex) then
				zg:TickSome(offIndex, nil, false)
			end

		else
			zg:TickOne(index, UnitFullName(unitid), enable)									-- Tick this one
			if (offIndex) then
				zg:TickOne(offIndex, UnitFullName(unitid), false)
			end
		end

		z:DrawAllCells()
	end
end

-- tickOnEnter
local function tickOnEnter(self)
	local index = self:GetID()
	local parent = self:GetParent()
	local unitid = parent:GetAttribute("unit")
	local key = zg.tickColumns[index]
	local handler = zg.tickHandlers[key]
	local buff = zg.buffs[key]

	if (not buff.exclusive) then
		local cgroup = z:ColourGroup(z:GetGroupNumber(unitid))
		local cclass = z:ColourClass(select(2, UnitClass(unitid)))
		local done
		for i = 1,20 do
			local help = L:HasTranslation("TICKCLICKHELP"..i) and L["TICKCLICKHELP"..i]
			if (not help) then
				break
			end
			if (not done) then
				done = true
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				GameTooltip:SetText(format(L["%s on %s"], ColourSpellFromKey(buff), z:ColourUnitByName(UnitFullName(unitid))))
			end
			help = help:gsub("$class", cclass)
			help = help:gsub("$party", cgroup)
			GameTooltip:AddLine(help)
		end

		if (done) then
			GameTooltip:Show()
		end
	end

	if (z.overrideBuffBar ~= "tick" or z.overrideBuffBarIndex ~= index) then
		z.overrideBuffBar = "tick"
		z.overrideBuffBarIndex = index
		z:DrawAllCells()
	end
end

-- tickOnLeave
local function tickOnLeave(self)
	GameTooltip:Hide()

	if (z.overrideBuffBar and z.overrideBuffBarIndex) then
		z.overrideBuffBar = nil
		z.overrideBuffBarIndex = nil
		z:DrawAllCells()
	end
end

-- TickOne
function zg:TickOne(index, unitname, enable)
	local key = self.tickColumns[index]
	if (not key) then
		error(format("No key for column %s", tostring(index)), 2)
	end
	local handler = self.tickHandlers[key]
	if (not handler) then
		error(format("No handler for %s", tostring(key)), 2)
	end

	handler.func(handler.module, unitname, key, enable)
end

-- TickSome
function zg:TickSome(index, matchfunc, enable)
	for unitid, unitname, unitclass, subgroup in z:IterateRoster() do
		if (not matchfunc or matchfunc(unitid)) then
			self:TickOne(index, unitname, enable)
		end
	end
end

-- CreateTick
function zg:CreateTick()
	local tick = CreateFrame("CheckButton")
	tick:SetHeight(z.db.profile.height)
	tick:SetWidth(z.db.profile.height)
	tick:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	tick:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	tick:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
	tick:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	tick:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	tick:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	tick:SetScript("OnClick", tickOnClick)
	tick:SetScript("OnEnter", tickOnEnter)
	tick:SetScript("OnLeave", tickOnLeave)

	return tick
end

-- AquireTick
function zg:AquireTick(cell)
	if (not self.freeTicks) then
		self.freeTicks = {}
	end
	local tick = tremove(self.freeTicks, 1)
	if (not tick) then
		tick = self:CreateTick()
	end

	if (not cell.ticks) then
		cell.ticks = {}
	end
	tinsert(cell.ticks, tick)
	tick:SetParent(cell)
	tick:Show()
	tick:SetID(#cell.ticks)
	tick:Enable()

	if (#cell.ticks == 1) then
		tick:SetPoint("LEFT")
	else
		tick:SetPoint("LEFT", cell.ticks[#cell.ticks - 1], "RIGHT")
	end

	return tick
end

-- KillTick
function zg:KillTick(cell)
	local tick = tremove(cell.ticks, #cell.ticks)
	if (tick) then
		tinsert(self.freeTicks, tick)
		tick:Hide()
		tick:SetParent(nil)
	end
end

-- CheckTickColumns
function zg:CheckTickColumns(cell)
	local count = (self.tickColumns and #self.tickColumns) or 0
	-- Add any more we need
	while (not cell.ticks or #cell.ticks < count) do
		local tick = self:AquireTick(cell)
	end
	-- Remove any to be recycled
	while (cell.ticks and #cell.ticks > count) do
		self:KillTick(cell)
	end

	local b = z.buffs[1] and cell.buff and cell.buff[1]
	if (b) then
		b:ClearAllPoints()
		if (count == 0) then
			b:SetPoint("TOPLEFT", 0, 0)
		else
			b:SetPoint("TOPLEFT", cell.ticks[count], "TOPRIGHT")
		end
	else
		if (count > 0) then
			cell.bar:ClearAllPoints()
			cell.bar:SetPoint("TOPLEFT", cell.ticks[count], "TOPRIGHT")
			cell.bar:SetPoint("BOTTOMRIGHT")
		end
	end

	if (self.tickColumns) then
		-- Go thru the ticks we have and assign them their values
		local any
		local unit = cell:GetAttribute("unit")
		if (unit) then
			local myself = UnitIsUnit("player", unit)
			for index,key in ipairs(self.tickColumns) do
				local handler = self.tickHandlers[key]
				if (type(handler) ~= "table" or not handler.func or not handler.module) then
					error(format("No handler for %q", tostring(key)))
				end
				local tick = cell.ticks[index]
				if (myself and self.buffs[key].notself) then
					tick:SetChecked(nil)
					tick:Disable()
				else
					tick:Enable()
					tick:SetChecked(handler.func(handler.module, unit, key))
				end
				any = true
			end
		end

		if (not any) then
			self.tickColumns = del(self.tickColumns)
		end
	end
end

-- CheckTickTitles
function zg:CheckTickTitles(members)
	local topChild = members:GetAttribute("child1")
	if (topChild) then
		local show = topChild:IsShown()

		if (self.tickColumns) then
			for i,key in ipairs(self.tickColumns) do
				local relative = topChild.ticks and topChild.ticks[i]
				if (relative) then
					local handler = self.tickHandlers[key]
					if (not handler) then
						error(format("No handler for %q", tostring(key)))
					end

					if (not members.limitedIcons) then
						members.limitedIcons = {}
					end
					local icons = members.limitedIcons

					local icon = icons[i]
					if (not icon) then
						icon = members:CreateTexture(nil, "BORDER")
						icons[i] = icon
					end
					icon:SetWidth(z.db.profile.height)
					icon:SetHeight(z.db.profile.height)
					local name, rank, tex = GetSpellInfo(handler.spellID)
					icon:SetTexture(tex)

					icon:ClearAllPoints()
					icon:SetPoint("BOTTOM", relative, "TOP", 0, (self.db.profile.border and 3) or 1)
					if show then
						icon:Show()
					else
						icon:Hide()
					end
				end
			end
			if (members.limitedIcons) then
				for i = #self.tickColumns + 1,#members.limitedIcons do
					members.limitedIcons[i]:Hide()
				end
			end
		else
			if (members.limitedIcons) then
				for i,icon in ipairs(members.limitedIcons) do
					icon:Hide()
				end
			end
		end
	end
end

-- HasGroupBuffs
function zg:HasGroupBuffs()
	if (self.buffs) then
		for key,info in pairs(self.buffs) do
			if (info.group) then
				return true
			end
		end
	end
end

-- HasAnyNonExclusiveBuffs
function zg:HasAnyNonExclusiveBuffs()
	if (self.buffs) then
		for key,info in pairs(self.buffs) do
			if (not info.exclusive) then
				return true
			end
		end
	end
end

-- ShowBuffBar
function zg:ShowBuffBar(cell, name)
	if (self.lookup) then
		local prefix = SecureButton_GetModifierPrefix(cell)
		for button = 1,5 do
			local spell = cell:GetAttribute(prefix, "spell", button)
			if (spell == name) then
				return true
			else
				local find = self.lookup[spell]
				if (find) then
					if (find.spellname == name) then
						return true
					end
				end
			end
		end
	end
end

-- GetSpellColour
function zg:GetSpellColour(spellName)
	local def = self.lookup and self.lookup[spellName]
	if (def) then
		return z:HexColour(unpack(def.colour))
	end
end

-- OneOfYours
function zg:OneOfYours(spell)
	return self.lookup[spell]
end

-- SayWhatWeDid
function zg:SayWhatWeDid(icon, spell, name, rank)
	if (not z.db.profile.info) then
		return
	end

	local s = spell or icon:GetAttribute("spell")
	if (s) then
		local found = self.lookup[s]
		if (found) then
			local _, colour = ColourSpellFromKey(found)
			local reagent = found.reagent
			local reagentString
			if (reagent) then
				local count = GetItemCount(reagent)
				if (count > 0) then
					local colourCount
					if (count < 5) then
						colourCount = "|cFFFF4040"
					elseif (count < 10) then
						colourCount = "|cFFFFFF40"
					else
						colourCount = "|cFF40FF40"
					end
					reagentString = format(" (%s%d|r)", colourCount, count - 1)
				else
					reagentString = ""
				end
			else
				reagentString = ""
			end

			local whoNotice = found.group and (((GetNumGroupMembers() > 0 and IsInRaid()) and RAID) or (GetNumGroupMembers() > 0 and PARTY)) or z:ColourUnitByName(name)
			self:Printf(L["%s on %s%s"], z:LinkSpell(s, colour, true, z.db.profile.short and found.name), whoNotice, reagentString)
		end
	end
end

-- OnRegenEnabled
function zg:OnRegenEnabled()
	if (self.stopSpellTracking) then
		for i,key in ipairs(self.stopSpellTracking) do
			self:StopSpellTracker(key)
		end
		self.stopSpellTracking = del(self.stopSpellTracking)
	end

	if (self.trackIcons) then
		for i,icon in ipairs(self.trackIcons) do
			icon:SetAlpha(1)
			if (icon:IsShown()) then
				if (icon.dummy) then
					self:SwitchTrackIconForReal(icon)
				else
					local unit = icon:GetAttribute("unit")
					if (not UnitIsUnit(icon.target, unit)) then
						icon:SetTrackerAttributes(icon.target, icon.key)
						icon:UpdateAura()
					end
				end
			end
		end
	end
end

do
	-- SmoothColour
	local function SmoothColour(percentage)
		local r, g
		if (percentage < 0.5) then
			g = min(1, max(0, 2 * percentage))
			r = 1
		else
			g = 1
			r = min(1, max(0, 2 * (1 - percentage)))
		end
		return r, g, 0
	end

	-- icon.UpdateUsable
	local function iconUpdateUsable(self)
		local start, duration, enable = GetSpellCooldown(self.spell)
		if (enable == 1) then
			self.icon:SetVertexColor(1, 1, 1)
		else
			self.needsCooldown = true
			self.icon:SetVertexColor(0.5, 0.5, 0.5)
		end
	end

	-- icon.UpdateCooldown
	local function iconUpdateCooldown(self)
		local start, duration, enable = GetSpellCooldown(self.spell)
		if (start) then
			CooldownFrame_SetTimer(self.cooldown, start, duration, enable)

			if (enable == 1 and (start == 0 or (start+duration) - GetTime() < 1.5)) then
				local got, count, endTime, maxDuration = self:GetSpellFromUnit()
				if (not got) then
					self.swirl:Show()
				end

				if (self.wasOnCooldown) then
					local buff = zg.buffs[self.key]
					if (buff and self.needsCooldown) then
						self.needsCooldown = nil
						z:Notice(format(L["%s cooldown ready for %s"], ColourSpellFromKey(buff), z:ColourUnitByName(self.target)))
						PlaySoundFile(SM:Fetch("sound", zg.db.profile.tracksound))
					end
				end
				self.wasOnCooldown = nil
			else
				if (enable == 1 and start > 0) then
					self.startSwirl = (start + duration) - GetTime()
				end
				self.swirl:Hide()
				self.wasOnCooldown = true
			end
		end
	end

	local sacredShield, _, sacredShieldIcon = GetSpellInfo(53601)

	-- icon.SacredShieldTimer
	local function iconSacredShieldTimer(self)
		for i = 1,40 do
			local name, rank, texture, count, _, maxDuration, endTime = UnitBuff(self.target, i, "PLAYER")
			if (name == sacredShield and texture == sacredShieldIcon) then
				return name, rank, texture, count, _, maxDuration, endTime
			end
		end
	end

	-- icon.GetSpellFromUnit
	local function iconGetSpellFromUnit(self)
		local name, rank, buff, count, _, maxDuration, endTime
		if (self.spell == sacredShield) then
			-- Special case for Sacred Shield because the buffed aura and the proc have
			-- the same name so we check the texture matches the buff's spell info
			-- Otherwise the aura timer can go a bit wobbly as it matches wrong one
			name, rank, buff, count, _, maxDuration, endTime = self:SacredShieldTimer()
		else
			name, rank, buff, count, _, maxDuration, endTime = UnitBuff(self.target, self.spell, nil, "PLAYER")
		end
		if (name and endTime) then
			self.timeLeft = endTime - GetTime()
			self.maxTime = maxDuration
			return name ~= nil, count, endTime, maxDuration
		end
		self.timeLeft = nil
	end

	-- icon.UpdateAura
	local function iconUpdateAura(self)
		local buff = zg.buffs[self.key]
		local got, count, endTime, maxDuration = self:GetSpellFromUnit()
		if (got) then
			if (endTime) then
				self.timeLeft = endTime - GetTime()
			end

			self.stacks = count
			self.count:SetText(count)

			if (not UnitIsVisible(self.target) or not self.initialStacks or self.initialStacks < 2) then
				self.count:Hide()
			else
				self.count:Show()
				local r, g, b = SmoothColour(self.stacks / self.initialStacks)
				self.count:SetTextColor(r, g, b)
			end
			self.swirl:Hide()
			self.had = true
			return
		else
			self.timeLeft = nil
		end

		local start, duration, enable = GetSpellCooldown(self.spell)
		if (self.had) then
			self.had = nil
			if (UnitIsVisible(self.target)) then
				if (self.temp) then
					zg:StopSpellTracker(self.key)
					return
				end

				if (buff and not buff.noaura) then
					if not UnitIsUnit(self.target, "pet") then			-- We don't need to hear this for the pet, and besides, it causes problems..
						z:Notice(format(L["%s has expired on %s"], ColourSpellFromKey(buff), z:ColourUnitByName(self.target)))
						PlaySoundFile(SM:Fetch("sound", zg.db.profile.tracksound))
						if (enable == 1) then
							self.needsCooldown = nil
						end
					end
				end
			end
		end

		self.name:Hide()
		self.stacks = 0
		self.count:SetText("0")
		self.count:SetTextColor(1, 0, 0)

		if (enable == 1 and (start == 0 or (start+duration) - GetTime() < 1.5)) then
			self.swirl:Show()
		else
			self.swirl:Hide()
		end
	end

	-- icon.UpdateTooltip
	local function iconUpdateTooltip(self)
		local got, count, endTime, maxDuration = self:GetSpellFromUnit()
		local buff = zg.buffs[self.key]
		if (not buff) then return end
		local buffColour = z:HexColour(unpack(buff.colour))
		local keyb
		if (self.keybinding) then
			keyb = format(" (|cFF80FF80%s|r)", self.keybinding)
		else
			keyb = ""
		end

		local target = self.target
		if target == "pet" and not UnitExists("pet") then
			target = zg.db.char.lastPetName
		end

		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(format("%s %s", z.titleColour, L["Spell Tracker"]), 1, 1, 1)
		GameTooltip:AddLine(format(L["%s on %s%s"], ColourSpellFromKey(buff), z:ColourUnitByName(target), keyb))

		if (not got) then
			GameTooltip:AddLine(L["MISSING!"], 1, 0, 0)
		else
			local buff = zg.buffs[self.key]
			if (buff) then
				-- We refresh initial stacks here, during login this is usually wrong because talents are not yet read
				self.initialStacks = type(buff.stacks) == "function" and buff.stacks() or buff.stacks
			end

			local r, g, b
			if (self.stacks and self.initialStacks and self.initialStacks > 1) then
				r, g, b = SmoothColour(self.stacks / self.initialStacks)
				GameTooltip:AddLine(format(L["%d of %d stacks remain"], self.stacks or 0, self.initialStacks or 0), r, g, b)
			end
			if (endTime) then
				local r, g, b = SmoothColour((endTime - GetTime()) / maxDuration)
				GameTooltip:AddLine(format(L["%s remains"], date("%M:%S", endTime - GetTime()) or "0:00"), r, g, b)
			end
		end

		local unit = self:GetAttribute("unit")
		if (unit and not UnitIsUnit(self.target, unit)) then
			GameTooltip:AddLine(format(L["WARNING: The intended target for this icon has changed since you entered combat. (Was %s)"], z:ColourUnit(unit)), 1, 0.5, 0.5, 1)
		end

		if (self.dummy) then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["This button is not clickable because it was created after you entered combat"], 0.5, 1, 0.5, 1)
		end

		GameTooltip:Show()
	end

	-- icon.OnDragStart
	local function iconOnDragStart(self)
		if (not zg.db.char.lock) then
			self:StartMoving()
		end
	end

	-- icon.OnDragStop
	local function iconOnDragStop(self)
		self:StopMovingOrSizing()
		if (self.posKey) then
			if (not zg.db.char.postracker) then
				zg.db.char.postracker = {}
			end
			zg.db.char.postracker[self.posKey] = z:GetPosition(self)
		end

		if (self.swirl:IsShown()) then
			self.swirl:Hide()
			self.swirl:Show()				-- Trigger animation resume
		end
	end

	-- icon.OnUpdate
	local function iconOnUpdate(self, elapsed)
		if (self.timeLeft) then
			self.timeLeft = self.timeLeft - elapsed
			if (self.timeLeft > 0) then
				if (self.timeLeft < 5) then
					self.name:SetFormattedText("%1.1f", self.timeLeft)
				else
					self.name:SetText(date("%M:%S", self.timeLeft):gsub("^0", ""))
				end
				local r, g, b = SmoothColour(self.timeLeft / self.maxTime)
				self.name:SetTextColor(r, g, b)
				self.name:Show()
			else
				self.timeLeft = nil
			end
		else
			self.name:Hide()
		end

		if (self.startSwirl) then
			self.startSwirl = self.startSwirl - elapsed
			if (self.startSwirl <= 0) then
				self.startSwirl = nil
				self:UpdateCooldown()
			end
		end
	end

	-- icon.OnEvent
	local function iconOnEvent(self, event, unit, ...)
		local f = self[event]
		if (f) then
			f(self, unit, ...)
		end
	end

	local function iconUNIT_AURA(self, unit)
		if (UnitIsUnit(unit, self.target)) then
			self:UpdateAura()
		end
	end

	local function iconACTIONBAR_UPDATE_COOLDOWN(self)
		self:UpdateCooldown()
	end

	local function iconACTIONBAR_UPDATE_USABLE(self)
		self:UpdateUsable()
	end

	local function iconPLAYER_ENTERING_WORLD(self)
		-- Put text back where we need it, things like ButtonFacade move things around during login
		self:SetTextAnchors()
	end

	local function iconUNIT_SPELLCAST_SUCCEEDED(self, player, spell, rank)
		if (UnitIsUnit(player, "player") and spell == self.spell) then
			self:UpdateAura()
			self:UpdateCooldown()
		end
	end

	-- icon.OnShow
	local function iconOnShow(self)
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		self:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:SetPosition()
		self:UpdateAura()
		self:SetTextAnchors()
		self:UpdateCooldown()
		self:UpdateUsable()
		zg:SetTrackerKeyBindings()
	end

	-- icon.OnHide
	local function iconOnHide(self)
		self.swirl:Hide()
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		self:UnregisterEvent("ACTIONBAR_UPDATE_USABLE")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")

		if (not InCombatLockdown()) then
			if (self.keybinding) then
				SetBinding(self.keybinding, nil)
				self.keybinding = nil
			end
		end
	end

	-- icon.SetPosition
	local function iconSetPosition(self)
		if (not InCombatLockdown() or self.dummy) then
			self:SetPoint("CENTER")
			self:SetScale(zg.db.profile.trackerscale)
			if (type(zg.db.char.postracker) == "table") then
				pos = zg.db.char.postracker[self.posKey]
				if (pos) then
					z:RestorePosition(self, pos)
				end
			end
		end
	end

	-- icon.SetTrackerAttributes
	local function iconSetTrackerAttributes(self, target, key)
		local buff = zg.buffs[key]
		local spell = buff.spellname
		self.target = target
		self.key = key
		self.spell = spell
		self.initialStacks = type(buff.stacks) == "function" and buff.stacks() or buff.stacks
		self.count:Hide()
		self.name:Hide()
		local name, rank, tex = GetSpellInfo(buff.id)
		self.icon:SetTexture(tex)

		local oldUnit = self:GetAttribute("unit")
		if (oldUnit and not UnitIsUnit(oldUnit, target) and UnitExists(target)) then
			self.timeLeft = nil
			self.had = nil
			self.needsCooldown = nil
		end

		if (not self.dummy and not InCombatLockdown()) then
			self:SetAttribute("unit", self.target)
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", self.spell)
		end

		local newUnit = self:GetAttribute("unit")
		if (newUnit and not UnitIsUnit(newUnit, target)) then
			self.icon:SetVertexColor(1, 0, 0)
		else
			self.icon:SetVertexColor(1, 1, 1)
		end
	end

	-- icon.SetTextAnchors
	local function iconSetTextAnchors(self)
		self.name:ClearAllPoints()
		self.name:SetPoint("TOPLEFT")
		self.name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -20)

		self.count:ClearAllPoints()
		self.count:SetPoint("BOTTOMLEFT")
		self.count:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 20)
	end

	-- icon.OnLeave
	local function iconOnLeave()
		GameTooltip:Hide()
	end

	-- CreateTrackIcon
	function zg:CreateTrackIcon(key)
		local iname, inh

		if (InCombatLockdown()) then
			self.dummytrackIconIndex = (self.dummytrackIconIndex or 0) + 1
			inh = "ActionButtonTemplate"
			iname = "ZOMGDummyTrackIcon"..self.dummytrackIconIndex
		else
			inh = "SecureActionButtonTemplate,ActionButtonTemplate"
			iname = "ZOMGTrackIcon"..key
		end
		assert(not _G[iname])

		local icon = CreateFrame("Button", iname, UIParent, inh)
		icon.dummy = InCombatLockdown()
		icon.posKey = key

		local LibButtonFacade = LibStub("LibButtonFacade",true)
		if (LibButtonFacade) then
			LibButtonFacade:Group("ZOMGBuffs", "Buffs"):AddButton(icon)
		end

		if (not self.trackIcons) then
			self.trackIcons = {}
		end
		if (InCombatLockdown()) then
			tinsert(self.trackIcons, icon)
		else
			self.trackIcons[key] = icon
		end

		icon:RegisterForDrag(nil)

		icon.icon = getglobal(iname.."Icon")
		icon.border = getglobal(iname.."Border")
		icon.normal = getglobal(iname.."NormalTexture")
		icon.flash = getglobal(iname.."Flash")
		icon.hotkey = getglobal(iname.."HotKey")
		icon.name = getglobal(iname.."Name")
		icon.count = getglobal(iname.."Count")
		icon.cooldown = getglobal(iname.."Cooldown")

		icon.name:SetJustifyV("TOP")
		icon.name:SetNonSpaceWrap(true)
		icon.name:SetFontObject("NumberFontNormal")
		icon.count:SetJustifyH("CENTER")

		icon.icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
		icon.border:SetVertexColor(0, 1, 0, 0.6)
		icon.normal:SetVertexColor(1, 1, 1, 0.5)
		icon:SetWidth(36)
		icon:SetHeight(36)
		
		icon.swirl = z:CreateAutoCast(icon)

		icon:RegisterForClicks("AnyUp")
		icon:RegisterForDrag("LeftButton")
		icon:SetMovable(true)

		icon.UpdateCooldown			= iconUpdateCooldown
		icon.UpdateUsable			= iconUpdateUsable
		icon.GetSpellFromUnit		= iconGetSpellFromUnit
		icon.SacredShieldTimer		= iconSacredShieldTimer
		icon.UpdateAura				= iconUpdateAura
		icon.UpdateTooltip			= iconUpdateTooltip
		icon.SetPosition			= iconSetPosition
		icon.SetTrackerAttributes	= iconSetTrackerAttributes
		icon.SetTextAnchors			= iconSetTextAnchors

		icon.UNIT_AURA				= iconUNIT_AURA
		icon.ACTIONBAR_UPDATE_COOLDOWN = iconACTIONBAR_UPDATE_COOLDOWN
		icon.ACTIONBAR_UPDATE_USABLE = iconACTIONBAR_UPDATE_USABLE
		icon.PLAYER_ENTERING_WORLD	= iconPLAYER_ENTERING_WORLD
		icon.UNIT_SPELLCAST_SUCCEEDED = iconUNIT_SPELLCAST_SUCCEEDED

		icon:Hide()

		icon:SetScript("OnDragStart",	iconOnDragStart)
		icon:SetScript("OnDragStop",	iconOnDragStop)
		icon:SetScript("OnUpdate",		iconOnUpdate)
		icon:SetScript("OnEvent",		iconOnEvent)
		icon:SetScript("OnEnter",		icon.UpdateTooltip)
		icon:SetScript("OnLeave",		iconOnLeave)
		icon:SetScript("OnShow",		iconOnShow)
		icon:SetScript("OnHide",		iconOnHide)

		return icon
	end
end

-- SetTrackerKeyBindings
function zg:SetTrackerKeyBindings()
	if (self.db.char.keybindings and not InCombatLockdown()) then
		if (self.trackIcons) then
			for i,icon in pairs(self.trackIcons) do
				if (icon.keybinding) then
					SetBinding(icon.keybinding, nil)
					icon.keybinding = nil
				end
			end

			for i,icon in pairs(self.trackIcons) do
				if (not icon.dummy and icon:IsShown()) then
					local key = self.db.char.keybindings[icon.posKey]
					if (key) then
						SetBindingClick(key, icon:GetName(), "LeftButton")
						icon.keybinding = key
					end
				end
			end
		end
	end
end

-- AddSpellTracker
function zg:AddSpellTracker(key, target)
	if (not self.db.profile.tracker) then
		return
	end
	local buff = self.buffs[key]
	if (not buff) then
		return
	end

	if (buff.notself and UnitIsUnit("player", target)) then
		return
	end

	local icon = self:IsSpellTracking(key)
	if (icon) then
		if (UnitIsUnit(icon.target, target)) then
			return
		end
	else
		icon = self:GetFreeTrackIcon(key)
	end

	icon:SetTrackerAttributes(target, key)

	if (not InCombatLockdown() or icon.dummy) then
		icon:Show()
	end
	icon:UpdateAura()

	return icon
end

-- SwitchTrackIconForReal
function zg:SwitchTrackIconForReal(icon)
	if (icon.dummy) then
		local target, key, spell = icon.target, icon.key, icon.spell
		icon:Hide()

		local newIcon = self:AddSpellTracker(key, target)
		newIcon:SetPosition()
	end
end

-- GetFreeTrackIcon
function zg:GetFreeTrackIcon(key)
	local dummy = InCombatLockdown()
	if (self.trackIcons) then
		if (dummy) then
			for i,icon in ipairs(self.trackIcons) do
				if (not icon.key and dummy == icon.dummy) then
					icon.remove = nil
					icon.temp = nil
					icon.had = nil
					icon.needsCooldown = nil
					icon.spell = nil
					icon.key = nil
					icon.target = nil
					icon.posKey = key
					return icon
				end
			end
		else
			local icon = self.trackIcons[key]
			if (icon) then
				return icon
			end
		end
	end
	return self:CreateTrackIcon(key)
end

-- StopSpellTracker
function zg:StopSpellTracker(key)
	local icon = self:IsSpellTracking(key)
	if (icon) then
		if (not icon.dummy and InCombatLockdown()) then
			self.stopSpellTracking = self.stopSpellTracking or new()
			tinsert(self.stopSpellTracking, key)
		else
			icon:SetAttribute("unit", nil)
			icon:SetAttribute("type", nil)
			icon:SetAttribute("spell", nil)
			icon:Hide()
			icon.key = nil
		end

		if (not InCombatLockdown()) then
			z:RequestSpells()
		end
	end
end

-- IsSpellTracking
function zg:IsSpellTracking(key)
	if (self.trackIcons) then
		local icon = self.trackIcons[key]
		if (icon and icon.key == key and icon:IsShown()) then
			return icon
		else
			for i,icon in ipairs(self.trackIcons) do
				if (icon.key == key and icon:IsShown()) then
					return icon
				end
			end
		end
	end
end

-- IsTrackingPlayer
function zg:IsTrackingPlayer(unitname)
	if (self.trackIcons) then
		for i,icon in ipairs(self.trackIcons) do
			if (not icon.dummy and not icon.temp and icon:IsShown()) then
				return true
			end
		end
	end
end

-- GetNewIconIndex
--[[
function zg:GetNewIconIndex()
	if (not self.trackerIndices) then
		self.trackerIndices = new(1)
		return 1
	else
		for i,index in ipairs(self.trackerIndices) do
			if (i ~= index) then
				tinsert(self.trackerIndices, i, i)
				return i
			end
		end

		local last = self.trackerIndices[#self.trackerIndices]
		if (last) then
			last = last + 1
		else
			last = 1
		end

		tinsert(self.trackerIndices, last)
		return last
	end
end

-- FreeIconIndex
function zg:FreeIconIndex(index)
	if (self.trackerIndices) then
		for i,find in ipairs(self.trackerIndices) do
			if (find == index) then
				tremove(self.trackerIndices, i)
				if (not next(self.trackerIndices)) then
					self.trackerIndices = del(self.trackerIndices)
				end
				return
			end
		end
	end
end
]]
   
-- SpellCastSucceeded
function zg:SpellCastSucceeded(spell, rank, target, manual, listClick)
	if (z:CanLearn()) then
		if UnitIsUnit(target, "pet") then
			self.db.char.lastPetName = UnitName(target)
		end
		
		local info = self.lookup and self.lookup[spell]
		if (info) then
			if (UnitInRaid(target) or UnitInParty(target) or UnitIsUnit(target, "pet")) then
				if (not self.db.char.notlearnable[info.type]) then
					if (info.exclusive) then
						self:ModifyTemplate(info.type, true)
						self:AddLimitedSpell(target, info.type)			-- Always add for things like Earth Shield, Fear Ward

					elseif (info.limited and (manual or listClick)) then
						self:AddLimitedSpell(target, info.type)
					else
						self:ModifyTemplate(info.type, true)
					end
				end
			end
		end
	end
end

-- AddLimitedSpell
function zg:AddLimitedSpell(name, key)
	if (not self.tickHandlers[key]) then
		error(format("No handler for %q", tostring(key)), 2)
	end
	if UnitIsUnit(name, "pet") then
		name = "pet"
	end

	local buff = self.buffs[key]
	if (not buff) then
		error(format("No self.buff for %q", key))
	end

	if (not template.limited) then
		template.limited = new()
	end

	if (buff.exclusive or not template.limited[key]) then
		del(template.limited[key])
		template.limited[key] = new()
	end

	if (not template.limited[key][name]) then
		template.limited[key][name] = true
	end

	--z:CheckForChange(self)
	z:SetupForSpell()
	z:RequestSpells()

	if (buff.exclusive) then
		self:AddSpellTracker(key, name)
		if (buff.onEnable) then
			buff.onEnable(name)
		end
	end
end

-- RemoveLimitedSpell
function zg:RemoveLimitedSpell(name, key)
	local part = template.limited and template.limited[key]
	if (part) then
		if UnitIsUnit(name, "pet") then
			name = "pet"
		end

		if (part[name]) then
			part[name] = nil
			z:CheckForChange(self)
		end

		if (not next(part) and self.buffs[key].exclusive) then
			self:StopSpellTracker(key)
		end

		if (self.db.profile.resetOnClear) then
			if (not next(part)) then
				template.limited[key] = del(template.limited[key])
			end
			if (not next(template.limited)) then
				template.limited = del(template.limited)
			end
		end
	end
end

-- UNIT_SPELLCAST_FAILED
function zg:SpellCastFailed(spell, name, manual)
	if (not manual) then
		if (self.lookup[spell]) then
			z:Blacklist(name)
		end
	end
end

-- OnSpellsChanged
function zg:OnSpellsChanged()
	self.actions = nil
	self:ValidateTemplate(template)
	self:GetActions()
	z:UpdateCellSpells()
	self:MakeSpellOptions()
	z:CheckForChange(self)
end

-- OnRaidRosterUpdate
function zg:OnRaidRosterUpdate()
	-- Some magic to clear our X-Realm names from our settings if they no longer exist to us
	local lim = template and template.limited
	if (lim) then
		for key,list in pairs(lim) do
			for name in pairs(list) do
				if (name ~= "pet" and not UnitInRaid(name) and not UnitInParty(name)) then
					list[name] = nil
					self:StopSpellTracker(key)
					if (not next(list)) then
						lim[key] = nil
						break
					end
				end
			end
		end
	end
end

-- ValidateTemplate
function zg:ValidateTemplate(template)
	for key,info in pairs(self.buffs) do
		if (not GetSpellInfo(info.spellname)) then
			if (template[key]) then
				self:ModifyTemplate(key, nil)
				if (z.icon and z.icon:GetAttribute("spell") == info.spellname) then
					z:SetupForSpell()			-- Clear loaded icon
				end
			end

			-- Also stop the spell tracker for newly forgotten spells
			if (info.exlusive) then
				self:StopSpellTracker(key)
			end
		end
	end
end

-- SortedBuffList
function zg:SortedBuffList()
	local list = new()
	for Type,info in pairs(self.buffs) do
		local o = info.o
		local insertPos = #list + 1
		for i,k in ipairs(list) do
			if (self.buffs[k].o > o) then
				insertPos = i
				break
			end
		end
		tinsert(list, insertPos, Type)
	end
	return list
end

local function TooltipToggleKeyType(frame, keytype, button)
	if (button == "LeftButton") then
		return ToggleKeyType(keytype)
	end
end

-- TooltipUpdate
function zg:TooltipUpdate(tooltip)
	if (template) then
		tooltip:AddSeparator(1, 0.5, 0.5, 0.5)
		tooltip:AddLine(L["Group Template: "].."|cFFFFFFFF"..(self:GetSelectedTemplate() or L["none"]), (template and template.modified and "|cFFFF4040"..L["(modified)"].."|r") or "")

		local list = self:SortedBuffList()
		for i,k in ipairs(list) do
			local key = self.buffs[k]
			if (GetSpellInfo(key.spellname)) then		-- GetSpellCooldown(key.list[1])) then
				local endis
				if (template[key.type]) then
					endis = "|cFF80FF80"..L["Enabled"].."|r"
				else
					endis = "|cFFFF8080"..L["Disabled"].."|r"
				end

				local name, rank, tex = GetSpellInfo(key.id)
				local checkIcon = tex and "|T"..tex..":0|t " or ""

				local line = tooltip:AddLine(checkIcon..ColourSpellFromKey(key), endis)
				tooltip:SetLineScript(line, "OnMouseDown", TooltipToggleKeyType, key.type)
			end
		end
		del(list)
	end


--[[
	if (template) then
		cat:AddLine('text', " ")
		cat:AddLine(
			"text", L["Group Template: "].."|cFFFFFFFF"..(self:GetSelectedTemplate() or L["none"]),
			"text2", (template and template.modified and "|cFFFF4040"..L["(modified)"].."|r") or ""
		)

		local list = self:SortedBuffList()
		for i,k in ipairs(list) do
			local key = self.buffs[k]
			if (GetSpellInfo(key.spellname)) then		-- GetSpellCooldown(key.list[1])) then
				local endis
				if (template[key.type]) then
					endis = "|cFF80FF80"..L["Enabled"].."|r"
				else
					endis = "|cFFFF8080"..L["Disabled"].."|r"
				end

				local name, rank, tex = GetSpellInfo(key.id)
				local checkIcon = tex

				cat:AddLine(
					"text", ColourSpellFromKey(key),
					"text2", endis,
					"func", ToggleKeyType,
					"arg1", key.type,
					"hasCheck", checkIcon and true,
					"checked", checkIcon and true,
					"checkIcon", checkIcon
				)
			end
		end
		del(list)
	end
]]
end

-- OnResetDB
function zg:OnResetDB()
	if (self.db) then
		template = self:GetTemplates().current

		for k,v in pairs(template) do
			if (k ~= "modified" and k ~= "state" and k ~= "limited") then
				if (not self.buffs[k]) then
					template[k] = nil
				end
			end
		end

		if (not self.db.char.firstRun) then
			self.db.char.firstRun = true
			for key,buff in pairs(self.buffs) do
				if (buff.defaultRebuff) then
					self.db.char.rebuff[key] = buff.defaultRebuff
				end
			end
		end

		self:TickInitForTemplate()

		if (self.trackerIcons) then
			for i,icon in pairs(self.trackerIcons) do
				icon:SetPosition()
			end
		end
		self:SetTrackerKeyBindings()
	end
end

-- OnModuleEnable
function zg:OnModuleEnable()
	if (self.db) then
		local class = select(2, UnitClass("player"))
		if (class ~= playerClass and self.OnModuleInitialize) then
			self:OnModuleInitialize()
		end

		local pos = zg.db.char.postracker
		if (pos and pos[1]) then
			-- Import old tracker icon positions to new save indexes
			local n = {}
			zg.db.char.postracker = n

			if (class == "PALADIN") then
				n.BEACON = pos[2]
				n.SACRIFICE = pos[3]
				n.FREEDOM = pos[4]
			elseif (class == "SHAMAN") then
				n.EARTHSHIELD = pos[1]
			elseif (class == "MAGE") then
				n.FOCUSMAGIC = pos[1]
			elseif (class == "PRIEST") then
				n.FEARWARD = pos[1]
			elseif (class == "WARRIOR") then
				n.VIGILANCE = pos[1]
			end
		end

		z:MakeOptionsReagentList()
		self:OnResetDB()
		
		self:OnSpellsChanged()

		self:RegisterBucketEvent("UNIT_AURA", 0.2)				-- We don't care who

		z:CheckForChange(self)
	end
end

-- OnDisable
function zg:OnDisable()
	z:CheckForChange(self)
end
