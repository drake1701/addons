-----------------------------------------------------
--             Author: Simca@Malfurion             --
-- Special Thanks: durandal42, foxlit, and yinzara --
-----------------------------------------------------

-- Set addon name and namespace
local addonname, ASH = ...

-- Global binding setup
BINDING_HEADER_AUTOSAFARIHAT = "Auto Safari Hat"
setglobal("BINDING_NAME_CLICK ASH_UseSafariHat:LeftButton", "Activate Safari Hat buff")

-- Localized functions and function returns to reduce run time for OnEvent and OnUpdate triggers
local _G = _G
local tonumber = _G.tonumber
local strlower = _G.string.lower
local strfind = _G.string.find
local sub = _G.strsub
local After = _G.C_Timer.After
local HasControl = _G.HasFullControl
local InCombat = _G.InCombatLockdown
local InPetBattle = _G.C_PetBattles.IsInBattle
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID
local UnitIsWildBattlePet = _G.UnitIsWildBattlePet
local GetItemInfo = _G.GetItemInfo
local GetInventoryItemID = _G.GetInventoryItemID
local SetAbility = C_PetJournal.SetAbility
local GetPetAbilityInfo = _G.C_PetJournal.GetPetAbilityInfo
local GetPetInfoByPetID = _G.C_PetJournal.GetPetInfoByPetID
local GetPetInfoBySpeciesID = _G.C_PetJournal.GetPetInfoBySpeciesID
local GetPetLoadOutInfo = _G.C_PetJournal.GetPetLoadOutInfo
local SetPetLoadOutInfo = _G.C_PetJournal.SetPetLoadOutInfo
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemID = _G.GetContainerItemID

-- Constants
local START_PET_BATTLE_DELAY = 1
local MAX_UPDATE_ATTEMPTS = 11
local UPDATE_DELAY = 1.0
local SAFARI_HAT = 92738
local TABARD_SLOT = _G.GetInventorySlotInfo("TABARDSLOT")
local HALF_TABARD = 69209
local FULL_TABARD = 69210
local PLACEHOLDER_SPECIES_ID = 5 -- a fake ID used for designating "tamer" battles
--local EMPTY_PET = "0x0000000000000000"
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS

-- Variables used to store the Secure Button, Tabard, and Pet Teams
local hatButton = false
local realTabard = false
local foundTabard = false
local realSelectedTeam = false
local realPets = {}

-- State Machine variable used to guide hat equip/unequip behavior
-- Possible values: "E" (equip), "U" (unequip), "N" (neither) (default state)
local attemptType = "N"
-- State Machine variable to check what type of fight it is (needed for TARGET_CHANGED detection pre-battle and post-battle)
-- Possible values: "T" (tamer), "W" (wild), "N" (neither) (default state)
local PetBattleType = "N"

-- Other Variables
local updateAttempts = 0            -- Used to track attempts
local petTamers = {}                -- List of pet tamers
local petTamersWithoutPopup = {}    -- List of pet tamers
local lastGUID = false              -- Used to check after a pet battle whether the target changed during the pet battle
local ASH_Time = UPDATE_DELAY + 1   -- Used to store time for OnUpdate function (starts above max so it will instantly try once)
ASH.LibStub = false                 -- Used to access LibStub; used to check if PetBattleTeams is detected and integration is supported

-- Create event handling frame and register events
local ASH_Events = CreateFrame("FRAME", "AutoSafariHat_Handler")
ASH_Events:RegisterEvent("ADDON_LOADED")
ASH_Events:RegisterEvent("GOSSIP_SHOW")
ASH_Events:RegisterEvent("PET_BATTLE_CLOSE")
ASH_Events:RegisterEvent("PLAYER_CONTROL_LOST")
ASH_Events:RegisterEvent("PLAYER_LOGIN")
ASH_Events:RegisterEvent("PLAYER_REGEN_DISABLED")
ASH_Events:RegisterEvent("PLAYER_REGEN_ENABLED")
ASH_Events:RegisterEvent("PLAYER_TARGET_CHANGED")
ASH_Events:RegisterEvent("QUEST_COMPLETE")
ASH_Events:RegisterEvent("QUEST_DETAIL")
ASH_Events:RegisterEvent("QUEST_PROGRESS")

-- Text output function
local function ASH_Output(outputText)
    if AutoSafariHatOptions.DisableText or not outputText then
        return
    end

    print("ASH: " .. outputText)
end

-- Tooltip notification line for battle pets when missing Safari Hat buff
do
    -- Hold original OnTooltipSetUnit script
    local origScript = GameTooltip:GetScript("OnTooltipSetUnit")

    local function ASH_OnTooltipSetUnit(self, ...)
        -- Get unit info from 
        local unitName, unitID = self:GetUnit()

        -- If the unit is a Battle Pet, the user doesn't have the buff, and the user wants to be notified
        if unitID and UnitIsWildBattlePet(unitID) and not UnitBuff("player", "Safari Hat") and AutoSafariHatOptions.WildPetHat then
            -- Using AddDoubleLine instead of AddLine because the height of the new line is wrong when using AddLine
            GameTooltip:AddDoubleLine("Safari Hat buff not active!", "", 1, 0, 0)
        end

        -- Go through the rest of the established routine
        if origScript then
            origScript(self, ...)
        end
    end

    -- Set new OnTooltipSetUnit script
    GameTooltip:SetScript("OnTooltipSetUnit", ASH_OnTooltipSetUnit)
end

-- ASH_UseSafariHat button handling
local ASH_ButtonHide, ASH_ButtonOnClick, ASH_ButtonSetup, ASH_ButtonShow
do
    -- ASH_UseSafariHat button hooks
    function ASH_ButtonOnClick()
        -- Detect if we have a Safari Hat
        local haveHat = false
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, GetContainerNumSlots(bag) do
                local itemID = GetContainerItemID(bag, slot)
                if itemID == SAFARI_HAT then
                    haveHat = true
                    break
                end
            end

            -- Check if we need to continue
            if haveHat then
                break
            end
        end

        -- Alert if Safari Hat is missing
        if not haveHat then
            ASH_Output("Failed to cast Safari Hat - you have no Safari Hat item in your inventory.")
        end

        for i = 1, 4 do
            if _G["StaticPopup" .. i]:IsShown() then
                -- Click "Accept" button to start battle
                _G["StaticPopup" .. i].button1:SetButtonState("PUSHED")
                _G["StaticPopup" .. i].button1:Click()
            end
        end
    end
    local function ASH_ButtonOnEnter()
        for i = 1, 4 do
            if _G["StaticPopup" .. i]:IsShown() then
                _G["StaticPopup" .. i].button1:LockHighlight()
            end
        end
    end
    local function ASH_ButtonOnLeave()
        for i = 1, 4 do
            _G["StaticPopup" .. i].button1:SetButtonState("NORMAL")
            _G["StaticPopup" .. i].button1:UnlockHighlight()
        end
    end

    -- StaticPopup Button hooks
    function ASH_ButtonShow()
        if InPetBattle() or InCombat() or (not HasControl()) or (PetBattleType ~= "T") or ((AutoSafariHatOptions.Items ~= 1) and (AutoSafariHatOptions.Items ~= 3)) or (not AutoSafariHatOptions.TamerPetHat) then
            return
        end

        local currentButton
        for i = 1, 4 do
            if _G["StaticPopup" .. i]:IsShown() and _G["StaticPopup" .. i].button1 and _G["StaticPopup" .. i].button1:IsShown() then
                currentButton = _G["StaticPopup" .. i].button1
            end
        end

        -- We didn't find any active Static Popup dialogs
        if not currentButton then
            return
        end

        -- Match size and position to StaticPopup1Button1
        hatButton:ClearAllPoints()
        hatButton:SetAllPoints(currentButton)

        -- Match frame strata and frame level to StaticPopup1Button1
        hatButton:SetFrameStrata(currentButton:GetFrameStrata())
        hatButton:SetFrameLevel(currentButton:GetFrameLevel() + 1)

        -- Set frame to be transparent and show it
        hatButton:SetAlpha(0)
        hatButton:Show()
    end
    function ASH_ButtonHide()
        -- Remove highlighting (just in case it hasn't been yet)
        ASH_ButtonOnLeave()

        if InPetBattle() or InCombat() or not HasControl() then
            return
        end

        -- Hide button
        hatButton:Hide()
    end

    function ASH_ButtonSetup()
        -- Create the button and set the proper attributes
        hatButton = CreateFrame("Button", "ASH_UseSafariHat", UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
        hatButton:SetAttribute("type", "item")
        hatButton:SetAttribute("item", "Safari Hat")
        hatButton:SetAttribute("unit", nil)
        hatButton:SetPoint("CENTER", UIParent)
        hatButton:Enable()
        hatButton:Hide()

        -- Hook StaticPopup1Button1 handling script into OnClick for this button
        hatButton:HookScript("OnClick", ASH_ButtonOnClick)

        -- Hook OnEnter and OnLeave functions (to simulate button highlighting)
        hatButton:HookScript("OnEnter", ASH_ButtonOnEnter)
        hatButton:HookScript("OnLeave", ASH_ButtonOnLeave)

        -- Hook OnShow and OnHide functions for all Static Popup boxes
        for i = 1, 4 do
            _G["StaticPopup" .. i]:HookScript("OnShow", ASH_ButtonShow)
            _G["StaticPopup" .. i].button1:HookScript("OnShow", ASH_ButtonShow)
            _G["StaticPopup" .. i]:HookScript("OnHide", ASH_ButtonHide)
        end
    end
end

-- PetBattleTeams integration
local ASH_EquipPetBattleTeam, ASH_UnequipPetBattleTeam
do
    function ASH_EquipPetBattleTeam(speciesID, rememberTeam)
        if not AutoSafariHatOptions.AutoPetBattleTeams or not ASH.LibStub then
            return
        end

        local TeamManager = ASH.LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams"):GetModule("TeamManager")
        if not TeamManager then
            return
        end

        local name = strlower(UnitName("target"))
        if not name then
            return
        end

        local numTeams = TeamManager:GetNumTeams()
        
        if rememberTeam then
            -- Reset variables in case we don't have a matching team (or it's already selected) so we don't try to swap back some previous team after the battle
            realPets = {}
            realSelectedTeam = false
        end

        for teamIndex = 1, numTeams do

            if TeamManager:TeamExists(teamIndex) then
                local teamName = strlower(TeamManager:GetTeamName(teamIndex))

                if strfind(name, teamName) or strfind(teamName, name) or teamName == name then

                    -- Don't do anything if team was already selected
                    if not TeamManager:IsSelected(teamIndex) then

                        if rememberTeam then
                            realSelectedTeam = TeamManager:GetSelected()
                        end

                        if not AutoSafariHatOptions.DisableText then
                            ASH_Output("Equipping team named '" .. TeamManager:GetTeamName(teamIndex) .. "'.")
                        end

                        if rememberTeam then
                            -- Save the current pets and abilities to restore after the battle is over
                            for petIndexInTeam = 1, 3 do
                                local petGUID, ability1, ability2, ability3, locked = GetPetLoadOutInfo(petIndexInTeam)
                                if petGUID and not locked then
                                    realPets[petIndexInTeam] = { petGUID = petGUID, ability1 = ability1, ability2 = ability2, ability3 = ability3 }
                                    local petName = select(2,GetPetInfoByPetID(petGUID))
                                    if not petName then
                                        petName = select(8,GetPetInfoByPetID(petGUID))
                                    end
                                    -- ASH_Output("Saving pet '" .. petName .. "' in slot " .. petIndexInTeam)

                                else -- There is no pet in this slot or the slot is not yet available (the user doesn't have high enough level pets)
                                    realPets[petIndexInTeam] = false
                                    -- ASH_Output("Saving no pet to slot " .. petIndexInTeam)
                                end
                            end
                        end

                        TeamManager:SetSelected(teamIndex)
                    end

                    return
                end
            end
        end

        -- Inform the user only if we know it is an unobtainable species or a tamer fight
        if speciesID and ((speciesID == PLACEHOLDER_SPECIES_ID) or not select(11, GetPetInfoBySpeciesID(speciesID))) then
            ASH_Output("No existing team named '" .. UnitName("target") .. "'.  To auto-select a team, name a team containing the name of the tamer/pet you are fighting.")
        end
    end

    function ASH_UnequipPetBattleTeam()
        if not realSelectedTeam or not AutoSafariHatOptions.AutoPetBattleTeams or not ASH.LibStub then
            return
        end

        local TeamManager = ASH.LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams"):GetModule("TeamManager")
        if not TeamManager then
            return
        end

        if TeamManager and not TeamManager:IsSelected(realSelectedTeam) then
            -- Here we are setting the selected team for TeamManager but we don't want to bind the pets, we're going to do that manually
            local prevSelected = TeamManager:GetSelected()
            TeamManager.db.global.selected = realSelectedTeam
            TeamManager.callbacks:Fire("TEAM_UPDATED",prevSelected)
            TeamManager.callbacks:Fire("SELECTED_TEAM_CHANGED",realSelectedTeam)

            ASH_Output("Setting selected team to " .. TeamManager:GetTeamName(realSelectedTeam) .. "'.")
        end

        -- Let's restore the pets and abilities
        for petIndexInTeam = 1, 3 do
            local petGUID, ability1, ability2, ability3, locked = GetPetLoadOutInfo(petIndexInTeam)
            local realPet = realPets[petIndexInTeam]
            if realPet then
                local logMessage = "Pet in slot " .. petIndexInTeam .. " set to "
                local changed = false
                if realPet.petGUID ~= petGUID then
                    changed = true
                    SetPetLoadOutInfo(petIndexInTeam, realPet.petGUID)
                    local petName = select(2,GetPetInfoByPetID(realPet.petGUID)) or select(8,GetPetInfoByPetID(realPet.petGUID))
                    logMessage = logMessage .. "\"" ..  petName .. "\" "
                end

                if (realPet.ability1 ~= ability1) then
                    changed = true
                    SetAbility(petIndexInTeam,1,realPet.ability1)
                    logMessage = logMessage .. " 1=" .. (GetPetAbilityInfo(realPet.ability1)) .. " "
                end

                if (realPet.ability2 ~= ability2) then
                    changed = true
                    SetAbility(petIndexInTeam,2,realPet.ability2)
                    logMessage = logMessage .. " 2=" .. (GetPetAbilityInfo(realPet.ability2)) .. " "
                end

                if (realPet.ability3 ~= ability3) then
                    changed = true
                    SetAbility(petIndexInTeam,3,realPet.ability3)
                    logMessage = logMessage .. " 3=" .. (GetPetAbilityInfo(realPet.ability3))
                end

                if changed then
                    ASH_Output(logMessage)
                else
                    local petName = select(2,GetPetInfoByPetID(realPet.petGUID)) or select(8,GetPetInfoByPetID(realPet.petGUID))
                    ASH_Output("Pet '" .. petName .. "' in slot " .. petIndexInTeam .. " was already correct")
                end
            -- Empty pet slots are no longer possible in 6.0.2/6.0.3 - it is unknown if this is a bug or is intended.
            --[[elseif not locked and petGUID and petGUID ~= EMPTY_PET then
                SetPetLoadOutInfo(petIndexInTeam, EMPTY_PET)
                ASH_Output("Removing pet from slot " .. petIndexInTeam)]]--
            else
                ASH_Output("Pet in slot " .. petIndexInTeam .. " is locked or was attempted to be emptied (which is no longer possible).")
            end
        end

        if PetJournal_UpdatePetLoadOut then
            PetJournal_UpdatePetLoadOut()
        end

        realSelectedTeam = false
        realPets = {}
    end
end

-- Equip/Unequip Guild Tabard handling
local ASH_EquipItem, ASH_OnUpdate, ASH_UnequipItem, CeaseUpdateAttempts
do
    -- Initial equip/unequip functions (first try)
    function ASH_EquipItem()
        -- Equip Guild Tabard
        if (AutoSafariHatOptions.Items == 2 or AutoSafariHatOptions.Items == 3) and GetInventoryItemID("player", TABARD_SLOT) ~= HALF_TABARD and GetInventoryItemID("player", TABARD_SLOT) ~= FULL_TABARD then
            realTabard = _G.GetInventoryItemLink("player", TABARD_SLOT)

            tabardType = false

            -- Iterate bags to find your best tabard type
            for bag = 0, 4 do
                for slot = 1, _G.GetContainerNumSlots(bag) do
                    local itemID = _G.GetContainerItemID(bag, slot)
                    if itemID == FULL_TABARD then
                        tabardType = FULL_TABARD
                        break
                    elseif itemID == HALF_TABARD then
                        tabardType = HALF_TABARD
                    end
                end
            end

            -- Equip tabard
            if tabardType then
                _G.EquipItemByName(tabardType)
            elseif not AutoSafariHatOptions.DisableText then
                -- Inform user they don't have a tabard
                ASH_Output("While you have the option for a guild tabard set, I could not find a guild reputation tabard in your bags. You must have either the Illustrious Guild Tabard or the Renowned Guild Tabard for this option to function correctly.")
            end
        end

        -- Start OnUpdate system to check if equipment is correct and fix if not
        if attemptType == "U" then
            -- Attempt to Equip but use existing OnUpdate run
            attemptType = "E"
        elseif attemptType ~= "E" then
            -- Attempt to Equip and start OnUpdate
            attemptType = "E"
            ASH_Events:SetScript("OnUpdate", ASH_OnUpdate)
        end
    end
    function ASH_UnequipItem()
        -- Equip original Tabard
        if (AutoSafariHatOptions.Items == 2 or AutoSafariHatOptions.Items == 3) and (GetInventoryItemID("player", TABARD_SLOT) == HALF_TABARD or GetInventoryItemID("player", TABARD_SLOT) == FULL_TABARD) then
            _G.EquipItemByName(realTabard)
        end

        -- Start OnUpdate system to check if equipment is correct and fix if not)
        if attemptType == "E" then
            -- Attempt to Unequip but use existing OnUpdate run
            attemptType = "U"
        elseif attemptType ~= "U" then
            -- Attempt to Unequip and start OnUpdate
            attemptType = "U"
            ASH_Events:SetScript("OnUpdate", ASH_OnUpdate)
        end

        if AutoSafariHatOptions.Items ~= 2 and AutoSafariHatOptions.Items ~= 3 then
            realTabard = false
        end
    end

    -- Delayed equipping/unequipping code
    function CeaseUpdateAttempts()
        ASH_Events:SetScript("OnUpdate", nil)
        attemptType = "N"
        ASH_Time = UPDATE_DELAY + 1
        updateAttempts = 0
    end
    function ASH_OnUpdate(self, elapsed)
        -- Update elapsed time (occurs every frame)
        ASH_Time = ASH_Time + elapsed

        -- Don't run more than once per UPDATE_DELAY
        if ASH_Time > UPDATE_DELAY then

            -- Stop future tries if too many attempts
            if updateAttempts < MAX_UPDATE_ATTEMPTS then
                local ASHI = AutoSafariHatOptions.Items -- Just for readability and to speed up access slightly

                -- If we're trying to equip
                if attemptType == "E" then

                    -- For this to work we must have found a tabard when this OnUpdate event was originally commissioned
                    if tabardType and (ASHI == 2 or ASHI == 3) and GetInventoryItemID("player", TABARD_SLOT) ~= tabardType then
                        _G.EquipItemByName(tabardType)
                    end

                    -- Advanced conditional: if wearing safari hat and 1; if wearing guild tabard and 2; if wearing hat and tabard and 3; if 4
                    if (ASHI == 1) or (ASHI == 2 and (not tabardType or GetInventoryItemID("player", TABARD_SLOT) == tabardType)) or (ASHI == 3 and (not tabardType or GetInventoryItemID("player", TABARD_SLOT) == tabardType)) or (ASHI == 4) then
                        -- Equip was successful
                        CeaseUpdateAttempts()
                    end

                -- If we're trying to unequip
                elseif attemptType == "U" then

                    -- If wearing guild tabard
                    if (ASHI == 2 or ASHI == 3) and (GetInventoryItemID("player", TABARD_SLOT) == HALF_TABARD or GetInventoryItemID("player", TABARD_SLOT) == FULL_TABARD) then
                        _G.EquipItemByName(realTabard)
                    end

                    -- Advanced conditional: if not wearing safari hat and 1; if not wearing guild tabard and 2; if not wearing hat and tabard and 3; if 4
                    if (ASHI == 1) or (ASHI == 2 and GetInventoryItemID("player", TABARD_SLOT) ~= HALF_TABARD and GetInventoryItemID("player", TABARD_SLOT) ~= FULL_TABARD) or (ASHI == 3 and GetInventoryItemID("player", TABARD_SLOT) ~= HALF_TABARD and GetInventoryItemID("player", TABARD_SLOT) ~= FULL_TABARD) or (ASHI == 4) then
                        -- Unequip was successful
                        CeaseUpdateAttempts()
                    end
                end
            else
                -- We've tried many times, but have always failed
                CeaseUpdateAttempts()
            end

            -- Increment attempt counter and reset time to 0
            updateAttempts = updateAttempts + 1
            ASH_Time = 0
        end
    end
end

local function ASH_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonname then
        -- Set options to defaults if not already found
        if not AutoSafariHatOptions then
            AutoSafariHatOptions = {}
            AutoSafariHatOptions.Items = 1
            AutoSafariHatOptions.WildPetHat = true
            AutoSafariHatOptions.TamerPetHat = true
            AutoSafariHatOptions.AutoQuestAccept = true
            AutoSafariHatOptions.AutoQuestComplete = true
            AutoSafariHatOptions.AttemptCombatFix = true
            AutoSafariHatOptions.AutoPetBattleTeams = true
            AutoSafariHatOptions.DisableText = false
        end

        -- Set new option to defaults if not already found
        if not AutoSafariHatOptions.Items then
            AutoSafariHatOptions.Items = 1
        end

        -- Set option to see when user last changed options
        if AutoSafariHatOptions.ManualChange == nil then
            AutoSafariHatOptions.ManualChange = false
        end

        -- Set up secure Safari Hat button
        ASH_ButtonSetup()

        -- Unregister event since no further need to check addon loading
        ASH_Events:UnregisterEvent("ADDON_LOADED")

    elseif event == "PLAYER_LOGIN" then
        -- Set up conditions for possible later integration with PetBattleTeams
        local _, _, _, enabled = _G.GetAddOnInfo("PetBattleTeams")

        if enabled and _G["LibStub"] then
            -- Since we only need LibStub to integrate with other addons that already use LibStub,
            -- We can rely on LibStub existing and hook into it without including it in this addon.
            ASH.LibStub = _G["LibStub"]
        end

    -- WildPetHat event and unequipping on target change for all events
    elseif event == "PLAYER_TARGET_CHANGED" then
        if InPetBattle() or InCombat() or not HasControl() or PetBattleType == "T" then
            return
        end

        if UnitIsWildBattlePet("target") and AutoSafariHatOptions.WildPetHat then
            PetBattleType = "W"
            ASH_EquipPetBattleTeam(UnitBattlePetSpeciesID("target"), true)
            ASH_EquipItem()
        elseif PetBattleType or attemptType == "E" then
            PetBattleType = "F"
            ASH_UnequipPetBattleTeam()
            ASH_UnequipItem()
        end

    -- TamerPetHat, AutoQuestAccept, and AutoQuestComplete events
    elseif event == "GOSSIP_SHOW" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE" then
        if _G.IsShiftKeyDown() then
            return
        end

        local validTamer, _, tamerID

        if UnitExists("npc") then -- (Fixes edge case where the tamer has been detargeted)
            _, _, _, _, _, tamerID = strsplit("-", UnitGUID("npc"))
            tamerID = tonumber(tamerID)

            if tamerID and petTamers[tamerID] then
                validTamer = true -- Could improve with dynamic, tooltip-based tamer/trainer detection, but it is likely not worth the time (either mine or the in-game processing time)
            end
        elseif UnitExists("target") then
            _, _, _, _, _, tamerID = strsplit("-", UnitGUID("target"))
            tamerID = tonumber(tamerID)

            if tamerID and petTamers[tamerID] then
                validTamer = true -- Could improve with dynamic, tooltip-based tamer/trainer detection, but it is likely not worth the time (either mine or the in-game processing time)
            end
        end

        if validTamer then
            -- Cease any unequip attempts now (fixes edge case)
            if attemptType == "U" then
                CeaseUpdateAttempts()
            end

            if event == "GOSSIP_SHOW" then
                -- Check if any quests are completable
                local questindex
                if AutoSafariHatOptions.AutoQuestComplete and _G.GetGossipActiveQuests() then
                    -- Check if any quests are completable
                    local questcomp
                    for i = 1, _G.GetNumGossipActiveQuests() do
                        questcomp = select(4 + ((i - 1) * 5), _G.GetGossipActiveQuests())
                        if questcomp then
                            questcompleted = true
                            questindex = i
                            break
                        end
                    end
                end

                -- First check available quests, then check if there are active quests AND we know it is completed (questindex), then lastly auto-battle
                if AutoSafariHatOptions.AutoQuestAccept and _G.GetGossipAvailableQuests() then
                    _G.SelectGossipAvailableQuest(1)
                    _G.CloseGossip()
                elseif AutoSafariHatOptions.AutoQuestAccept and _G.GetGossipActiveQuests() and questindex then
                    _G.SelectGossipActiveQuest(questindex)
                    _G.CloseGossip()
                elseif AutoSafariHatOptions.TamerPetHat and GetGossipOptions() then
                    if HasControl() and not InCombat() and not InPetBattle() then
                        -- Determine gossip battle option
                        local gossipOptions = { _G.GetGossipOptions() }
                        local battleOption
                        for i = #gossipOptions, 1, -1 do
                            if gossipOptions[i] and gossipOptions[i] ~= "gossip" then
                                battleOption = i
                                break
                            end
                        end

                        -- Select gossip battle option, equip items, start battle, set battle type, close gossip window
                        if battleOption then
                            PetBattleType = "T"
                            ASH_EquipPetBattleTeam(PLACEHOLDER_SPECIES_ID, true)
                            ASH_EquipItem()

                            -- Check if the tamer has a popup window for us to use the Safari Hat secure button workaround
                            if petTamersWithoutPopup[tamerID] then  -- We can't do the workaround
                                -- Check for the hat buff
                                if (AutoSafariHatOptions.Items == 1 or AutoSafariHatOptions.Items == 3) and not UnitBuff("player", "Safari Hat") then
                                    -- Detect if we have a Safari Hat (so that we don't incessantly bug people with one)
                                    local haveHat = false
                                    for bag = 0, NUM_BAG_SLOTS do
                                        for slot = 1, GetContainerNumSlots(bag) do
                                            local itemID = GetContainerItemID(bag, slot)
                                            if itemID == SAFARI_HAT then
                                                haveHat = true
                                                break
                                            end
                                        end

                                        -- Alert if Safari Hat buff is missing while we have the Safari Hat item in our bags
                                        if haveHat then
                                            -- We need to break here anyway, might as well tuck the output statement here instead of doing two checks
                                            ASH_Output("You're not wearing a Safari Hat, and there is no way for the addon to hook into this specific Pet Tamer to give the buff to you!")
                                            break
                                        end
                                    end
                                end

                                -- Start the pet battle
                                After(START_PET_BATTLE_DELAY, function()
                                    -- Select proper gossip option
                                    _G.SelectGossipOption(1)
                                    -- Don't exit NPC interaction dialog; if it fails it is because the user didn't have a Darkmoon Game Token and we should let them see the error
                                end)
                            else -- We can do our workaround
                                -- Select proper gossip option
                                _G.SelectGossipOption(1)

                                -- Check for the hat buff
                                if (AutoSafariHatOptions.Items == 1 or AutoSafariHatOptions.Items == 3) and not UnitBuff("player", "Safari Hat") then
                                    -- If missing, show the secure fake button over 'Yes'
                                    ASH_ButtonShow()
                                else
                                    -- Start the pet battle
                                    After(START_PET_BATTLE_DELAY, function()
                                        -- Click all StaticPopup dialog Button1s
                                        ASH_ButtonOnClick()
                                        -- Exit NPC interaction dialog (though this should happen automatically)
                                        _G.CloseGossip()
                                    end)
                                end
                            end
                        end
                    end
                end
            elseif AutoSafariHatOptions.AutoQuestAccept and event == "QUEST_DETAIL" then
                _G.AcceptQuest()
                _G.CloseGossip()
            elseif AutoSafariHatOptions.AutoQuestComplete and event == "QUEST_PROGRESS" and _G.IsQuestCompletable() then
                _G.CompleteQuest()
                _G.CloseGossip()
            elseif AutoSafariHatOptions.AutoQuestComplete and event == "QUEST_COMPLETE" and _G.GetNumQuestChoices() < 2 then
                _G.GetQuestReward(_G.GetNumQuestChoices())
                _G.CloseGossip()
            end
        end

    -- Unequipping on pet battle end for all events
    elseif event == "PET_BATTLE_CLOSE" then
        if HasControl() and not InCombat() then
            if UnitIsWildBattlePet("target") and AutoSafariHatOptions.WildPetHat then
                PetBattleType = "W"
                ASH_EquipPetBattleTeam(UnitBattlePetSpeciesID("target"), false)
                ASH_EquipItem()
            else
                PetBattleType = "F"
                ASH_UnequipPetBattleTeam()
                ASH_UnequipItem()
            end
        end

    -- Abandon attempts to equip or unequip if we enter combat
    elseif event == "PLAYER_REGEN_DISABLED" then
        if ASH_UseSafariHat:IsShown() then ASH_ButtonHide() end
        if attemptType ~= "N" then CeaseUpdateAttempts() end
    elseif event == "PLAYER_CONTROL_LOST" then
        if attemptType ~= "N" then CeaseUpdateAttempts() end

    -- Restart attempts to equip or unequip after leaving combat
    elseif event == "PLAYER_REGEN_ENABLED" then
        if AutoSafariHatOptions.AttemptCombatFix and HasControl() and not InCombat() and not InPetBattle() then
            if UnitIsWildBattlePet("target") and AutoSafariHatOptions.WildPetHat then
                PetBattleType = "W"
                ASH_EquipPetBattleTeam(UnitBattlePetSpeciesID("target"), true)
                ASH_EquipItem()
            else
                PetBattleType = "F"
                ASH_UnequipPetBattleTeam()
                ASH_UnequipItem()
            end
        end
    end
end

-- Set our event handler function
ASH_Events:SetScript("OnEvent", ASH_OnEvent)

-- Create slash commands
SLASH_AUTOSAFARIHAT1 = "/autosafarihat"
SLASH_AUTOSAFARIHAT2 = "/ash"
SlashCmdList["AUTOSAFARIHAT"] = function(message)

    if string.lower(message) == "dismiss" then
        AutoSafariHatOptions.DisableText = true
    else
        InterfaceOptionsFrame:Show()
        InterfaceOptionsFrameTab2:Click()

        local i = 1
        local currAddon = "InterfaceOptionsFrameAddOnsButton" .. i
        while _G[currAddon] do
            if _G[currAddon]:GetText() == "Auto Safari Hat" then
                _G[currAddon]:Click()
                break
            end
            i = i + 1
            currAddon = "InterfaceOptionsFrameAddOnsButton" .. i
        end
    end
end

-- Array of tamer NPC IDs defined down here for readability's sake
do
    petTamers[63194] = true
    petTamers[64330] = true
    petTamers[65648] = true
    petTamers[65651] = true
    petTamers[65655] = true
    petTamers[65656] = true
    petTamers[66126] = true
    petTamers[66135] = true
    petTamers[66136] = true
    petTamers[66137] = true
    petTamers[66352] = true
    petTamers[66372] = true
    petTamers[66412] = true
    petTamers[66422] = true
    petTamers[66436] = true
    petTamers[66442] = true
    petTamers[66452] = true
    petTamers[66466] = true
    petTamers[66478] = true
    petTamers[66512] = true
    petTamers[66515] = true
    petTamers[66518] = true
    petTamers[66520] = true
    petTamers[66522] = true
    petTamers[66550] = true
    petTamers[66551] = true
    petTamers[66552] = true
    petTamers[66553] = true
    petTamers[66557] = true
    petTamers[66635] = true
    petTamers[66636] = true
    petTamers[66638] = true
    petTamers[66639] = true
    petTamers[66675] = true
    petTamers[66730] = true
    petTamers[66733] = true
    petTamers[66734] = true
    petTamers[66738] = true
    petTamers[66739] = true
    petTamers[66741] = true
    petTamers[66815] = true
    petTamers[66819] = true
    petTamers[66822] = true
    petTamers[66824] = true
    petTamers[66918] = true
    petTamers[67370] = true
    petTamers[68462] = true
    petTamers[68463] = true
    petTamers[68464] = true
    petTamers[68465] = true
    petTamers[71924] = true
    petTamers[71926] = true
    petTamers[71927] = true
    petTamers[71929] = true
    petTamers[71930] = true
    petTamers[71931] = true
    petTamers[71932] = true
    petTamers[71933] = true
    petTamers[71934] = true
    petTamers[73626] = true
    petTamers[83837] = true
    petTamers[85519] = true
    petTamers[87110] = true
    petTamers[87122] = true
    petTamers[87123] = true
    petTamers[87124] = true
    petTamers[87125] = true
    
    petTamersWithoutPopup[67370] = true
    petTamersWithoutPopup[85519] = true
end