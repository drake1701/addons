


------------------------------
-- Target Tracker
------------------------------

local TrackedUnits = {}					-- Tracked Enemy Units (Returns UnitID)
local TrackedUnitTargetGUID = {}		-- Enemy Unit Targets (Returns GUID of the Unit's Targets)
local TrackedUnitTargetHistory = {}		-- Previously determined Target (to determine if changes happened)
local TargetWatcher
local GetGroupInfo = TidyPlatesUtility.GetGroupInfo
local GetCombatEventResults = TidyPlatesUtility.GetCombatEventResults
local inRaid = false
local RecentDamageTime = {}
local RecentDamageTarget = {}

local TANK_ROLE, DPS_ROLE = 2, 1

local function CombatLogWatcher(...)
	local timestamp, combatevent, sourceGUID, destGUID, destName, destFlags, destRaidFlag, auraType, spellid, spellname, stackCount = GetCombatEventResults(...)

	if combatevent == "SWING_DAMAGE" and (TrackedUnits[sourceGUID] == nil) then
		-- if the destination swing targets a group member, store the GUID and the Time in the Table
		local unitid = TidyPlatesUtility.GroupMembers.GUID[destGUID]
		if unitid then
			RecentDamageTime[sourceGUID] = GetTime()
			RecentDamageTarget[sourceGUID] = destGUID
			TidyPlates:Update()
		end
	end
end

local function GetRecentDamageTarget(guid)
	local damageTime = RecentDamageTime[guid]
	if damageTime and GetTime() > ( damageTime + 5 ) then
		return RecentDamageTarget[guid]
	end
end

local function TargetWatcherEvents(frame, event, ...)
	if not UnitInRaid("player") then return end

	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		CombatLogWatcher(...)
		return
	end

	local widget, plate
	local target, unitid, guid
	local changes = false
	local groupSize = tonumber(GetNumGroupMembers())
	TrackedUnits = wipe(TrackedUnits)

	-- Store target history
	for guid, target in pairs(TrackedUnitTargetGUID) do
		TrackedUnitTargetHistory[guid] = target
		TrackedUnitTargetGUID[guid] = nil
	end

	-- Reset the Tracking List
	for guid in pairs(TrackedUnits) do TrackedUnits[guid] = nil end

	-- Build a list of Trackable targets (via target, focus, and raid members)

	-- Add Target to Tracked Units List
	guid = UnitGUID("target")
	if guid then TrackedUnits[guid] = "target" end

	-- Add Focus to Tracked Units List
	guid = UnitGUID("focus")
	if guid then TrackedUnits[guid] = "focus" end

	-- Add Group TargetOfs to Tracked Units List
	if groupSize then
		for index = 1, groupSize do
			unitid = "raid"..index.."target"
			guid = UnitGUID(unitid)
			if guid then TrackedUnits[guid] = unitid end
		end

		-- Build a list of the target's targets and check for changes
		for guid, unitid in pairs(TrackedUnits) do
			if unitid then
				local targetofUnitid = unitid.."target"
				TrackedUnitTargetGUID[guid] = UnitGUID(targetofUnitid)


				-- Is there some way to determine if the target is an NPC?
				--[[
				if "Black Ox Statue" = UnitName(targetofUnitid) then
					TankGUIDs[guid] = TrackedUnitTargetGUID[guid]
				end
				--]]

				if TrackedUnitTargetGUID[guid] ~= TrackedUnitTargetHistory[guid] then changes = true end
			end
		end
	end

	if event == "PLAYER_REGEN_ENABLED" then
		wipe(RecentDamageTime)
	end

	-- Call for indicator Update, if needed
	if changes then
		TidyPlates:Update()			-- To Do: Make a better update hook: either update specific GUIDs or update only indicators
	end
end


---------------
-- Tank Monitor
---------------
local TankGUIDs = {}		-- Store the GUIDs of all active tanks
local TankWatcher

local function IsTankedByAnotherTank(unit)
	local targetGuid, targetName
	local guid = unit.guid

	if unit.isTarget then
		targetGuid = UnitGUID("targettarget")				-- Nameplate is a target
		--targetName = UnitName("targettarget")
	elseif unit.isMouseover then
		targetGuid = UnitGUID("mouseovertarget")		-- Nameplate is a mouseover
		--targetName = UnitName("mouseovertarget")
	elseif guid then
		targetGuid = TrackedUnitTargetGUID[guid] or GetRecentDamageTarget(guid)	-- Nameplate is arbitrary (hopefully it's been moused during its life)
		--targetName = UnitName(
	end

	-- Suggested Change: If the unit is NOT attacking a non-tank, return false.  So, everything that is not a player character is OK to be attacked.
	-- Suggested Change: Create a new function, "AttackingSquishy(unit)"?
	-- Suggested Change:
	--[[
	TankGUIDs should be altered to GroupRoleByGUID
	TankGUIDs = {}
		nil = Unknown
		1 = Healer/DPS
		2 = Tank
	--]]

--[[

	/run print(GetTotemInfo(1))
	= true Black Ox Statue 407749 900 Interface\Icons\monk_ability_summonoxstatue

--]]

	-- ie. If the evaluated unit's  target is equal to one of the tanks, then it's tanked
	if targetGuid and TankGUIDs[targetGuid] == TANK_ROLE then	-- If the mob is tanked by an actual tank...
		return true

	-- Experimental...
	elseif targetGuid and not TankGUIDs[targetGuid] then		-- If the mob is attacking something outside your group...
		return true
	end
end

--[[
	- Druid: Bear form					SpellID: 5487		-- UnitAura
	- Paladin: Righteous Fury			SpellID: 25780
	- Warrior: Defensive stance			SpellID: 71			-- GetShapeshiftFormID(), 18
	- Death Knight: Blood Presence		SpellID: 48263
	- Monk:
--]]

local TankAuras = {
	["5487"] = true, 		-- Druid: Bear Form
	["25780"] = true, 		-- Paladin: Righteous Fury
	-- ["71"] = true,
	["48263"] = true, 		-- DK: Blood
	["115069"] = true, 		-- Monk: Stance of the Sturdy Ox
}

local TankStances = {
	["18"] = true,			-- Warrior: Defensive Stance
	--["23"] = true,		-- Monk: Defensive Stance
	--["5"] = true,			-- Druid: Bear Form
}

--TidyPlatesWidgets.IsTankingAuraActive = false

local function CheckPlayerAuras()
	local spellID, name, _
	local tankAura = false
	-- Check Auras
	for i = 1, 40 do
		name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)	-- 11th
		if TankAuras[tostring(spellID)] then
			tankAura = true
		end
	end
	-- Check Stances
	if GetShapeshiftFormID() == 18 then -- Defensive Stance (Warrior)
		tankAura = true
	end

	if GetShapeshiftFormID() == 23 then -- Stance of the Sturdy Ox (Monk)
		tankAura = true
	end

	if TidyPlatesWidgets.IsTankingAuraActive ~= tankAura then
		TidyPlatesWidgets.IsTankingAuraActive = tankAura
		TidyPlates:RequestDelegateUpdate()
	end
end

local function CheckAssignments()

	-- If we detect the ox statue, add it to this list:
	-- local oxGuid = UnitGUID(ox)
	-- TankGUIDs[oxGuid] = true


	if UnitInRaid("player") then
		local index
		inRaid = true
		local groupType, groupSize = GetGroupInfo()

		for index = 1, groupSize do
			local raidid = "raid"..tostring(index)

			if not UnitIsUnit("player", raidid) then		-- Skip over the Player
				local isTank = GetPartyAssignment("MAINTANK", raidid) or ("TANK" == UnitGroupRolesAssigned(raidid))

				if isTank then
					TankGUIDs[UnitGUID(raidid)] = TANK_ROLE		-- Tank = 2
				else
					TankGUIDs[UnitGUID(raidid)] = DPS_ROLE		-- DPS = 1
				end

			end
		end
	else
		inRaid = false
		TankGUIDs = wipe(TankGUIDs)
		if HasPetUI("player") and UnitName("pet") then
			TankGUIDs[UnitGUID("pet")] = TANK_ROLE
		end
	end
end

local function TankWatcherEvents(frame, event, ...)
	if event == "UNIT_AURA" or event == "UPDATE_SHAPESHIFT_FORM" then
		local unitid = ...
		if unitid == "player" then CheckPlayerAuras() end
		return
	end

	CheckAssignments()
	CheckPlayerAuras()
end


local function QueueUpdate()
	TankWatcher:SetScript("OnUpdate", TankWatcherEvents)
end

local function EnableTankWatch()
	-- Target-Of Watcher
	if not TargetWatcher then TargetWatcher = CreateFrame("Frame") end
	TargetWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	TargetWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
	TargetWatcher:RegisterEvent("PLAYER_REGEN_DISABLED")
	TargetWatcher:RegisterEvent("PLAYER_TARGET_CHANGED")
	TargetWatcher:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	TargetWatcher:RegisterEvent("UNIT_TARGET")
	TargetWatcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TargetWatcher:SetScript("OnEvent", TargetWatcherEvents)
	TargetWatcherEvents()

	-- Party Tanks
	if not TankWatcher then TankWatcher = CreateFrame("Frame") end
	TankWatcher:RegisterEvent("GROUP_ROSTER_UPDATE")
	TankWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	TankWatcher:RegisterEvent("PARTY_MEMBERS_CHANGED")
	TankWatcher:RegisterEvent("PARTY_CONVERTED_TO_RAID")
	TankWatcher:RegisterEvent("UNIT_AURA")
	TankWatcher:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	TankWatcher:SetScript("OnEvent", TankWatcherEvents)
	QueueUpdate()
end

local function DisableTankWatch()
	-- Target-Of Watcher
	if TargetWatcher then
		TargetWatcher:SetScript("OnEvent", nil)
		TargetWatcher:UnregisterAllEvents()
		TargetWatcher = nil
	end

	-- Party Tanks
	if TankWatcher then
		TankWatcher:SetScript("OnEvent", nil)
		TankWatcher:UnregisterAllEvents()
		TankWatcher = nil
	end
end

TidyPlatesWidgets.EnableTankWatch = EnableTankWatch
TidyPlatesWidgets.DisableTankWatch = DisableTankWatch
TidyPlatesWidgets.IsTankedByAnotherTank = IsTankedByAnotherTank
--TidyPlatesWidgets.GetRecentDamageTarget = GetRecentDamageTarget


