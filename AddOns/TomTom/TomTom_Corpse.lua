--[[-------------------------------------------------------------------------
--  Simple module for TomTom that creates a waypoint for your corse
--  if you happen to die.  No humor, no frills, just straightforward
--  corpse arrow.  Based on code written and adapted by Yssarill.
-------------------------------------------------------------------------]]--

local L = TomTomLocals
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ALIVE")
eventFrame:RegisterEvent("PLAYER_DEAD")
eventFrame:RegisterEvent("PLAYER_UNGHOST")
eventFrame:Hide()

-- Local variables to store map, floor, x, y and uid or corpse waypoint
local m,f,x,y,uid

local function StartCorpseSearch()
    if not IsInInstance() then
        eventFrame:Show()
    end
end

local function ClearCorpseArrow()
    if uid then
        TomTom:RemoveWaypoint(uid)
        m,f,x,y,uid = nil, nil, nil, nil, nil
    end
end

local function GetCorpseLocation()
    -- If the player isn't dead or a ghost, drop out
    if not UnitIsDeadOrGhost("player") then
        if m or f or x or y then
            ClearCorpseArrow()
        end
    end

    -- Cache the result so we don't scan the maps multiple times
    if m and f and x and y then
        return m, f, x, y
    end

    --  See if the player corpse is on the current map
    local om = GetCurrentMapAreaID()
    local of = GetCurrentMapDungeonLevel()

    local cx, cy = GetCorpseMapPosition()
    if cx ~= 0 and cy ~= 0 then
        m = om
        f = of
        x = cx
        y = cy
    end
end

local function SetCorpseArrow()
    if m and f and x and y then
        uid = TomTom:AddMFWaypoint(m, f, x, y, {
            title = L["My Corpse"],
            persistent = false,
			corpse = true,
        })
        return uid
    end
end

local counter, throttle = 0, 0.5
eventFrame:SetScript("OnUpdate", function(self, elapsed)
    counter = counter + elapsed
    if counter < throttle then
        return
    else
        counter = 0
        if TomTom.profile.general.corpse_arrow then
            if GetCorpseLocation() then
                if SetCorpseArrow() then
                    self:Hide()
                end
            end
        else
            self:Hide()
        end
    end
end)

eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "TomTom" then
        self:UnregisterEvent("ADDON_LOADED")
        if UnitIsDeadOrGhost("player") then
            StartCorpseSearch()
        end
    end

    if event == "PLAYER_ALIVE" then
        if UnitIsDeadOrGhost("player") then
            StartCorpseSearch()
        else
            ClearCorpseArrow()
        end
    elseif event == "PLAYER_DEAD" then
        -- Cheat a bit and avoid the map flipping
        SetMapToCurrentZone()
        m = GetCurrentMapAreaID()
        f = GetCurrentMapDungeonLevel()
        if not IsInInstance() then
            x,y = GetPlayerMapPosition("player")
        end
        StartCorpseSearch()
    elseif event == "PLAYER_UNGHOST" then
        ClearCorpseArrow()
    end
end)

if IsLoggedIn() then
    eventFrame:GetScript("OnEvent")(eventFrame, "ADDON_LOADED", "TomTom")
end
