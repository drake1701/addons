--[[
    Author: Valana <Team BATTLE> of Magtheridon Alliance-US
]]

local _addonName, _addonTitle =  GetAddOnInfo("TB_ReputationWatcher")
local TbReputationWatcher = LibStub("AceAddon-3.0"):NewAddon(_addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local ConfigDialog = LibStub("AceConfigDialog-3.0")
local Deformat = LibStub("LibDeformat-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(_addonName, true)

local bband = bit.band
local _db
local _changes


function TbReputationWatcher:OnInitialize()
    -- Create default settings. By default, do not automatically mark exalted factions as inactive, because it is a pain for the player to undo if he or she does not desire that behavior.
	-- Likewise, do not default ignoreActive to true.
	local defaults =
	{
		watchGains = true,
        watchGuild = true,
		watchLosses = false,
		ignoreInactive = true,
		markWatchedActive = true,
		markExaltedInactive = false,
	}
	self:ValanaOnly(defaults)

	-- Load our defaults.
    _db = LibStub("AceDB-3.0"):New(_addonName, { global = defaults, }, true)
    _db:SetProfile("Default")

    -- Create the options menus.
    LibStub("AceConfig-3.0"):RegisterOptionsTable(_addonName,
        {
            type = "group",
            name = _addonTitle,
            desc = GetAddOnMetadata(_addonName, "Notes"),
            handler = TbReputationWatcher,
            args =
            {
                subHeader =
                {
                    order = 0,
                    type = "description",
                    name = L["MENU_SUBHEADER"],
                },
                watchChanges =
                {
                    order = 10,
                    type = "group",
                    inline = true,
                    name = L["MENU_WATCH_REPUTATION_CHANGES"],
                    args =
                    {
                        watchChangesSubHeader =
                        {
                            order = 0,
                            type = "description",
                            name = L["MENU_WATCH_REPUTATION_CHANGES_SUBHEADER"],
                        },
                        watchGains =
                        {
                            order = 10,
                            type = "toggle",
                            name = L["MENU_WATCH_REPUTATION_GAINS"],
                            desc = L["MENU_WATCH_REPUTATION_GAINS_DESCRIPTION"],
                            get = "IsWatchingReputationGains",
                            set = "ToggleWatchReputationGains",
                        },
                        watchGuild =
                        {
                            order = 11,
                            type = "toggle",
                            name = L["MENU_WATCH_GUILD_REPUTATION"],
                            desc = L["MENU_WATCH_GUILD_REPUTATION_DESCRIPTION"],
                            get = "IsWatchingGuildReputation",
                            set = "ToggleWatchGuildReputation",
                            disabled = function() return not TbReputationWatcher:IsWatchingReputationGains() end,
                        },
                        watchLosses =
                        {
                            order = 12,
                            type = "toggle",
                            name = L["MENU_WATCH_REPUTATION_LOSSES"],
                            desc = L["MENU_WATCH_REPUTATION_LOSSES_DESCRIPTION"],
                            get = "IsWatchingReputationLosses",
                            set = "ToggleWatchReputationLosses",
                        },
                    },
                },
                inactiveFactions =
                {
                    order = 20,
                    type = "group",
                    inline = true,
                    name = L["MENU_INACTIVE_FACTIONS"],
                    args =
                    {
                        inactiveFactionsSubHeader =
                        {
                            order = 0,
                            type = "description",
                            name = L["MENU_INACTIVE_FACTIONS_SUBHEADER"],
                        },
                        ignoreInactive =
                        {
                            order = 10,
                            type = "toggle",
                            name = L["MENU_IGNORE_INACTIVE_FACTIONS"],
                            desc = L["MENU_IGNORE_INACTIVE_FACTIONS_DESCRIPTION"],
                            get = "IsIgnoringInactiveFactions",
                            set = "ToggleIgnoreInactiveFactions",
                        },
                        markWatchedActive =
                        {
                            order = 11,
                            type = "toggle",
                            name = L["MENU_MARK_WATCHED_FACTION_ACTIVE"],
                            desc = L["MENU_MARK_WATCHED_FACTION_ACTIVE_DESCRIPTION"],
                            get = "IsMarkingWatchedFactionActive",
                            set = "ToggleMarkWatchedFactionActive",
                            disabled = "IsIgnoringInactiveFactions",
                        },
                        markExaltedInactive =
                        {
                            order = 12,
                            type = "toggle",
                            name = L["MENU_MARK_EXALTED_FACTIONS_INACTIVE"],
                            desc = L["MENU_MARK_EXALTED_FACTIONS_INACTIVE_DESCRIPTION"],
                            get = "IsMarkingExaltedFactionsInactive",
                            set = "ToggleMarkExaltedFactionsInactive",
                        },
                    },
                },
            },
        }, "tbrw")

    -- Add our options menus to the Blizzard interface menu.
    ConfigDialog:AddToBlizOptions(_addonName)

    -- Register slash commands to quickly access the configuration menu.
    self:RegisterChatCommand("tbreputationwatcher", "OpenBlizzardConfigDialog")
    self:RegisterChatCommand("tbrepwatcher", "OpenBlizzardConfigDialog")
    self:RegisterChatCommand("tbrepwatch", "OpenBlizzardConfigDialog")
    self:RegisterChatCommand("tbrep", "OpenConfigDialog")
end

function TbReputationWatcher:OpenConfigDialog()
    ConfigDialog:Open(_addonName)
end

function TbReputationWatcher:OpenBlizzardConfigDialog()
	InterfaceOptionsFrame_OpenToCategory(_addonName)
end

function TbReputationWatcher:OnEnable()
    -- We can't seem to automatically switch the watched faction until the reputation frame is opened once. Do this before applying all settings and registering for the
	-- ReputationFrame_OnShow event. There is no need to close the frame.
    ReputationFrame:Show()
    self:ApplyAllSettings()
end

function TbReputationWatcher:ReputationFrame_OnShow(...)
    -- We need to expand all faction groups in order to properly traverse their sub-factions. It's more efficient and readable than expanding collapsed groups as we go.
    ExpandAllFactionHeaders()

	-- Let Blizzard do its thing before we reprocess the faction list based on the user's preferences.
	self.hooks[ReputationFrame].OnShow(...)

    -- Exit early if there is nothing to do.
    local numFactions, nameWatched, standingWatched = GetNumFactions(), GetWatchedFactionInfo()
    local watchedFound = not nameWatched or standingWatched == 8 or not self:IsMarkingWatchedFactionActive()
    if numFactions == 0 or (watchedFound and not self:IsMarkingExaltedFactionsInactive()) then return end

    local i, inactiveHeaderIndex = 1
    while i <= numFactions do
        local name, _, standing, _, _, _, _, _, isHeader, _, _, isWatched = GetFactionInfo(i)
        if not inactiveHeaderIndex then
            -- We are on or above the Inactive header.
            if isHeader then
                if name == FACTION_INACTIVE then
                    -- Inactive factions are grouped at the bottom of the list, so at this point we have no more exalted factions to mark as inactive. We should only keep going if we do not
					-- need to mark our watched faction as active.
                    inactiveHeaderIndex = i
                end
            elseif standing == 8 and self:IsMarkingExaltedFactionsInactive() then
                -- This faction is exalted, so mark it as inactive and preserve the iteration counter's value.
                SetFactionInactive(i)
				i = i - 1

				-- If we've just marked as inactive the last faction in a faction group, then we've removed at least one faction from the list (possibly more in the case of nested faction
				-- groups). Decrement our counter by 1 more to maintain our position.
				local numLostFactions = numFactions - GetNumFactions()
				if numLostFactions > 0 then
					numFactions = GetNumFactions()
					i = i - numLostFactions
				end
            end
        elseif isWatched then
            -- This faction is inactive and not exalted. If we weren't going to mark it as active, we would have exited the loop already.
            SetFactionActive(i)

            -- Adjust the the index of the Inactive header because it has just shifted.
			inactiveHeaderIndex = inactiveHeaderIndex + 1

			-- If we've just marked as active the first faction in a faction group, then we've added at least one faction to the list (possibly more in the case of nested faction groups).
			-- Increment our counters by the number of added factions more to maintain our position.
			local numAddedFactions = GetNumFactions() - numFactions
			if numAddedFactions > 0 then
				numFactions = GetNumFactions()
				inactiveHeaderIndex = inactiveHeaderIndex + numAddedFactions
				i = i + numAddedFactions
			end
        end

        -- We are not interested in any more factions once we have passed the Inactive header if we have no faction to mark as active.
        watchedFound = watchedFound or isWatched
        if inactiveHeaderIndex and watchedFound then break end

        -- Advance to the next faction.
        i = i + 1
    end

    -- Collapse the Inactive header once we are done (if it exists).
    if inactiveHeaderIndex then
        CollapseFactionHeader(inactiveHeaderIndex)
    end
end

-- Watch reputation changes.
-- Note that a single game event (killing a monster) may raise this event multiple times (eg. when gaining reputation with an entire faction group). For performance considerations, we
-- should cache most global functions because there is no guarantee that the second if block will short-circuit most calls following a single watched faction change.
function TbReputationWatcher:CHAT_MSG_COMBAT_FACTION_CHANGE(e, message)
    -- See if this is a reputation gain (possibly accompanied by a recruit-a-friend bonus).
	local nameChanged = Deformat(message, FACTION_STANDING_INCREASED) or Deformat(message, FACTION_STANDING_INCREASED_ACH_BONUS) or Deformat(message, FACTION_STANDING_INCREASED_BONUS) or Deformat(message, FACTION_STANDING_INCREASED_DOUBLE_BONUS)
	if not nameChanged then
		-- It's a reputation loss. If we're not interested, just exit.
		if bband(_changes, 2) == 0 then return end
		nameChanged = Deformat(message, FACTION_STANDING_DECREASED)
	elseif bband(_changes, 1) == 0 then return end

	-- Guild reputation comes in as reputation increased with "Guild". However, the faction in the reputation panel appears as the player's guild name, so adjust accordingly.
	if nameChanged == GUILD then
        if not self:IsWatchingGuildReputation() then return end
		nameChanged = GetGuildInfo("player")
	end

    -- Check whether the associated faction is already being watched. This function only deals with setting the watched faction to avoid unnecessary processing.
    if nameChanged == GetWatchedFactionInfo() then return end

    -- We need to expand all faction headers in order to properly traverse their sub-factions.
    ExpandAllFactionHeaders()
    local inactiveHeaderIndex
    local changedFound = self:IsIgnoringInactiveFactions()
    for i = 1, GetNumFactions() do
        local name, _, _, _, _, _, _, _, isHeader = GetFactionInfo(i)
        if isHeader and name == FACTION_INACTIVE then
			inactiveHeaderIndex = i
        elseif name == nameChanged then
            -- We would have exited the loop early if it was inactive and we were ignoring inactive factions, so we need to watch this one.
            changedFound = true
            SetWatchedFactionIndex(i)
        end

        -- We are not interested in any more factions once we have passed the Inactive header, if we have found the faction which experienced the reputation change or if we are ignoring
		-- inactive factions. Note: changedFound is meaningless until inactiveHeaderIndex is assigned a value (unlike watchedFound in ReputationFrame_OnShow), so it should never be read
		-- until then.
        if inactiveHeaderIndex and changedFound then break end
    end

    -- Collapse the Inactive header once we are done (if it exists).
    if inactiveHeaderIndex then
        CollapseFactionHeader(inactiveHeaderIndex)
    end
end

function TbReputationWatcher:ApplyAllSettings()
    -- Pick the appropriate regular expression pattern based on the reputation changes to watch by building a bitmask.
    _changes = 0
    if self:IsWatchingReputationGains() then
		_changes = _changes + 1
	end
	if self:IsWatchingReputationLosses() then
		_changes = _changes + 2
    end

    -- Watch the combat log for reputation changes if either option was picked.
    if _changes > 0 then
        self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
    else
        self:UnregisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
    end

	-- Process the faction list every time the reputation frame is opened, rather than every time a reputation change occurs. This should reduce the performance impact in combat, although
	-- if the player fights with the reputation frame open, certain changes may not be reflected immediately. This should only be hooked after all settings are applied.
	if not self:IsHooked(ReputationFrame, "OnShow") then
		self:HookScript(ReputationFrame, "OnShow", "ReputationFrame_OnShow")
	end
end

function TbReputationWatcher:IsWatchingReputationGains()
    return _db.global.watchGains
end

function TbReputationWatcher:ToggleWatchReputationGains()
    _db.global.watchGains = not _db.global.watchGains
    self:ApplyAllSettings()
end

function TbReputationWatcher:IsWatchingGuildReputation()
    return self:IsWatchingReputationGains() and _db.global.watchGuild
end

function TbReputationWatcher:ToggleWatchGuildReputation()
    _db.global.watchGuild = not _db.global.watchGuild
    self:ApplyAllSettings()
end

function TbReputationWatcher:IsWatchingReputationLosses()
    return _db.global.watchLosses
end

function TbReputationWatcher:ToggleWatchReputationLosses()
    _db.global.watchLosses = not _db.global.watchLosses
    self:ApplyAllSettings()
end

function TbReputationWatcher:IsIgnoringInactiveFactions()
    return _db.global.ignoreInactive
end

function TbReputationWatcher:ToggleIgnoreInactiveFactions()
    _db.global.ignoreInactive = not _db.global.ignoreInactive
    self:ApplyAllSettings()
end

function TbReputationWatcher:IsMarkingWatchedFactionActive()
    return not self:IsIgnoringInactiveFactions() and _db.global.markWatchedActive
end

function TbReputationWatcher:ToggleMarkWatchedFactionActive()
    _db.global.markWatchedActive = not _db.global.markWatchedActive
    self:ApplyAllSettings()
end

function TbReputationWatcher:IsMarkingExaltedFactionsInactive()
    return _db.global.markExaltedInactive
end

function TbReputationWatcher:ToggleMarkExaltedFactionsInactive()
    _db.global.markExaltedInactive = not _db.global.markExaltedInactive
    self:ApplyAllSettings()
end

function TbReputationWatcher:ValanaOnly(defaults)

end

