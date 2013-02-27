-- Revision: $Id: Core.lua 6 2009-07-17 08:15:45Z riskynet $
local L = LibStub("AceLocale-3.0"):GetLocale("FastQuest", true)
FastQuest = LibStub("AceAddon-3.0"):NewAddon("FastQuest", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "FastQuest",
    handler = FastQuest,
    type = "group",
    args = {
        toggle = {
            order = 1,
            type = "toggle",
            name = L["AddOn Enable"],
            desc = L["Enable/Disable FastQuest"],
            get = "GetToggle",
            set = "Toggle",
        },
        accept = {
            order = 2,
            type = "toggle",
            name = L["Auto Accept Quests"],
            desc = L["Enable/Disable auto quest accepting"],
            get = "GetAccept",
            set = "Accept"
        },
        greeting = {
            order = 3,
            type = "toggle",
            name = L["Skip Greetings"],
            desc = L["Enable/Disable NPC's greetings skip for one or more quests"],
            get = "GetGreeting",
            set = "Greeting"
        },
        escort = {
            order = 4,
            type = "toggle",
            name = L["Auto Accept Escorts"],
            desc = L["Enable/Disable auto escort accepting"],
            get = "GetEscort",
            set = "Escort",
        },
        complete = {
            order = 5,
            type = "toggle",
            name = L["Auto Complete Quests"],
            desc = L["Enable/Disable auto quest complete"],
            get = "GetComplete",
            set = "Complete",
        },
        config = {
            order = 6,
            type = "execute",
            name = L["Config"],
            desc = L["Open configuration"],
            func = function() InterfaceOptionsFrame_OpenToCategory("FastQuest") end,
            guiHidden = true,
        },
    },
}

local defaults = {
    profile = {
        toggle = true,
        accept = true,
        greeting = true,
        escort = false,
        complete = true,
    },
}

function FastQuest:OnInitialize()
    FastQuest:Print("FastQuest v" .. GetAddOnMetadata("FastQuest", "Version") .. " " .. L["Initialized, type /fq for settings or /fq config for config dialog"]);
    self.db = LibStub("AceDB-3.0"):New("FQDB", defaults, "Default");
    
    LibStub("AceConfig-3.0"):RegisterOptionsTable("FastQuest", options, {"fastquest", "fq"});
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FastQuest", "FastQuest");
end

function FastQuest:OnEnable()
    self:RegisterEvent("QUEST_GREETING")
    self:RegisterEvent("GOSSIP_SHOW")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
end

function FastQuest:QUEST_GREETING(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.greeting) and ( not IsControlKeyDown() ) then
        local numact,numava = GetNumActiveQuests(), GetNumAvailableQuests()
        if numact+numava == 0 then return end

        if numava > 0 then
            SelectAvailableQuest(1);
        end
        if numact > 0 then
            SelectActiveQuest(1);
        end
    end
end

function FastQuest:GOSSIP_SHOW(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.greeting) and ( not IsControlKeyDown() ) then
        if GetGossipAvailableQuests() then
            SelectGossipAvailableQuest(1);
        elseif GetGossipActiveQuests() then
            SelectGossipActiveQuest(1);
        end
    end
end

function FastQuest:QUEST_DETAIL(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.accept) and ( not IsControlKeyDown() ) then
        AcceptQuest();
    end
end

function FastQuest:QUEST_ACCEPT_CONFIRM(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.escort) and ( not IsControlKeyDown() ) then
        ConfirmAcceptQuest();
    end
end

function FastQuest:QUEST_PROGRESS(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.complete) and ( not IsControlKeyDown() ) then
        CompleteQuest();
    end
end

function FastQuest:QUEST_COMPLETE(eventName, ...)
    if (self.db.profile.toggle) and (self.db.profile.complete) and ( not IsControlKeyDown() ) then
        if GetNumQuestChoices() == 0 then
            GetQuestReward(QuestFrameRewardPanel.itemChoice);
        end
    end
end

function FastQuest:GetToggle(info)
    return self.db.profile.toggle;
end

function FastQuest:Toggle(info, value)
    self.db.profile.toggle = value;
    if self.db.profile.toggle then
        FastQuest:Print(L["FastQuest Enabled"]);
    else
        FastQuest:Print(L["FastQuest Disabled"]);
    end
end

function FastQuest:GetAccept(info)
    return self.db.profile.accept;
end

function FastQuest:Accept(info, value)
    self.db.profile.accept = value;
    if self.db.profile.accept then
        FastQuest:Print(L["Auto Accept Quests Enabled"]);
    else
        FastQuest:Print(L["Auto Accept Quests Disabled"]);
    end
end

function FastQuest:GetGreeting(info)
    return self.db.profile.greeting;
end

function FastQuest:Greeting(info, value)
    self.db.profile.greeting = value;
    if self.db.profile.greeting then
        FastQuest:Print(L["Skip Greetings Enabled"]);
    else
        FastQuest:Print(L["Skip Greetings Disabled"]);
    end
end

function FastQuest:GetEscort(info)
    return self.db.profile.escort;
end

function FastQuest:Escort(info, value)
    self.db.profile.escort = value;
    if self.db.profile.escort then
        FastQuest:Print(L["Auto Accept Escorts Enabled"]);
    else
        FastQuest:Print(L["Auto Accept Escorts Disabled"]);
    end
end

function FastQuest:GetComplete(info)
    return self.db.profile.complete;
end

function FastQuest:Complete(info, value)
    self.db.profile.complete = value;
    if self.db.profile.complete then
        FastQuest:Print(L["Auto Complete Quests Enabled"]);
    else
        FastQuest:Print(L["Auto Complete Quests Disabled"]);
    end
end