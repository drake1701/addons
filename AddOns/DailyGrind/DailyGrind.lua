-- Author      : Deldinor of Elune
-- Create Date : 2/1/2011 7:31:49 AM

addonName = "DailyGrind";
addonFullName = "Daily Grind";

dgDebugText = "DEBUG";
debugModeEnabled = false;
disableTurnIn = false;

DailyGrind = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0");
DailyGrind.version = GetAddOnMetadata(addonName, "Version");

BINDING_HEADER_DAILYGRIND = addonFullName;

local titleColor = "FF70B7FF";
addonTitle = "|c"..titleColor..addonFullName.."|r";
addonAbbr = "|c"..titleColor.."[DG]|r";
commandColor = "FFFFC654";
disabledText = "|cFFFF0000DISABLED|r";
enabledText = "|cFF00FF00ENABLED|r";
maxQuests = 25;
repeatableWarning = "Be aware that this may cause undesired behavior with certain NPCs.";

CharacterBlacklist = nil;
CharacterNpcBlacklist = nil;
CharacterRewardList = nil;
CharacterSuspendKeyList = nil;
AccountQuestHistory = nil;

function DailyGrind:OnInitialize()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, self.Options)
	local configDialog = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.DailyGrind = configDialog:AddToBlizOptions(addonName, addonFullName, nil, "General")
	
    self:RegisterChatCommand("dailygrind", "ChatCommand");
    self:RegisterChatCommand("dg", "ChatCommand");
    self:InitializeSettings();
end

function DailyGrind:InitializeSettings()
	if not Settings then
		Settings = self.defaultSettings;
		
		-- Upgrade from 1.x settings
		if DailyGrindSettings then
			Settings.Enabled = DailyGrindSettings.Enabled;
			Settings.Blacklist = DailyGrindSettings.Blacklist;
			Settings.NpcBlacklist = DailyGrindSettings.NpcBlacklist;
			Settings.RewardList = DailyGrindSettings.Rewards;
			Settings.AutoAcceptAllEnabled = DailyGrindSettings.AutoAcceptAllEnabled;
			Settings.RepeatableQuestsEnabled = DailyGrindSettings.RepeatableQuestsEnabled;
			Settings.SuspendKeys = {};
			Settings.SuspendKeys[DailyGrindSettings.SuspendKey] = true;
			DailyGrindSettings = nil;
		end
	end
	
	if not QuestHistory then
		QuestHistory = {};
		
		-- Upgrade from 1.x settings
		if DailyGrindQuests then
			QuestHistory = DailyGrindQuests;
			DailyGrindQuests = nil;
		end
	end	
	
	-- Initialize lists
	CharacterBlacklist = Blacklist:new();
	CharacterNpcBlacklist = NpcBlacklist:new();
	CharacterRewardList = RewardList:new();
	CharacterSuspendKeyList = SuspendKeyList:new();
	AccountQuestHistory = QuestList:new();
end

function DailyGrind:OnEnable()
    self:RegisterEvent("GOSSIP_SHOW");
    self:RegisterEvent("QUEST_GREETING");
    self:RegisterEvent("QUEST_DETAIL");
    self:RegisterEvent("QUEST_PROGRESS");
    self:RegisterEvent("QUEST_COMPLETE");
    self:RegisterEvent("QUEST_AUTOCOMPLETE");
end

function DailyGrind:QUEST_AUTOCOMPLETE(eventName, eventQuestId)
	self:Debug("QUEST_AUTOCOMPLETE");
	
	local logIndex = GetQuestLogIndexByID(eventQuestId);
	local numAutoQuests = GetNumAutoQuestPopUps();
	
	self:Debug("Quest ID "..tostring(eventQuestId).." log index: "..tostring(logIndex));
	self:Debug("Num Auto Quests found: "..numAutoQuests);
	
	local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex);
	questTitle = self:SanitizeQuestTitle(questTitle);
	self:Debug("Quest title to complete: "..questTitle);
	
	local isDaily = isDaily or self:IsSpecialCaseQuest(questTitle);
	local isInHistory = AccountQuestHistory:Contains(questTitle);
	self:DebugQuest(isDaily, isInHistory);
	
	if (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily then
		for i = 1, numAutoQuests, 1 do
			local autoQuestId, popupType = GetAutoQuestPopUp(i);
			self:Debug("Popup "..i..": "..autoQuestId..", "..popupType);
			if autoQuestId == eventQuestId and popupType == "COMPLETE" then
				self:Debug("Attempting to complete Quest ID "..autoQuestId.." (log index: "..logIndex..")");
				ShowQuestComplete(logIndex);
				self:Debug("Completing quest "..questTitle..".");
				if not disableTurnIn then
					CompleteQuest();
				end
				return;
			end
		end
	end
end

function DailyGrind:GOSSIP_SHOW()
	self:Debug("GOSSIP_SHOW");
	
	if not Settings.Enabled or self:IsSuspendKeyDown() then
		return;
	end	
	
	local numAvailableQuests = GetNumGossipAvailableQuests();
	local numActiveQuests = GetNumGossipActiveQuests();

	self:Debug(tostring(numActiveQuests).." active quest(s) detected.");
	
	local npcName, realm = UnitName("npc");
	if CharacterNpcBlacklist:Contains(npcName) and (numAvailableQuests > 0 or numActiveQuests > 0) then
		CharacterNpcBlacklist:Print(": \""..npcName.."\" ignored.");
		return;
	end
	
	-- Turn in known completed quests.
	if numActiveQuests > 0 then
		local activeQuests = {GetGossipActiveQuests()};
		for i = 1, numActiveQuests, 1 do
			local questTitle = self:GetSanitizedActiveQuestTitle(activeQuests, i);
			local isComplete = self:IsCompleteActiveQuest(activeQuests, i)
			local isDaily = self:IsDailyActiveQuest(questTitle) or self:IsSpecialCaseQuest(questTitle);
			local isInHistory = AccountQuestHistory:Contains(questTitle);
						
			if (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily and isComplete then
				if CharacterBlacklist:Contains(questTitle) then
					CharacterBlacklist:Print(": \""..questTitle.."\" ignored.");
				else
					self:Debug("Selecting \""..questTitle.."\" via GOSSIP_SHOW");
					SelectGossipActiveQuest(i);
				end
			end
		end
	end
	
	-- Accept known available quests.
	if numAvailableQuests > 0 then
		local availableQuests = {GetGossipAvailableQuests()};
		for i = 1, numAvailableQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(availableQuests[self:GetAvailableQuestTitleIndex(i)]);
			local isDaily = self:IsDailyAvailableQuest(availableQuests, i) or self:IsSpecialCaseQuest(questTitle);
			local isRepeatable = self:IsRepeatableAvailableQuest(availableQuests, i);
			local isInHistory = AccountQuestHistory:Contains(questTitle);
			
			if ((isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily) or (isRepeatable and self:GetRepeatableQuestsEnabled()) then
				if isRepeatable then
					self:PrintRepeatable(": Attempting to turn in \""..questTitle.."\"");
				end
				if CharacterBlacklist:Contains(questTitle) then
					CharacterBlacklist:Print(": \""..questTitle.."\" ignored.");
				else
					if self:GetNumPlayerActiveQuests() < maxQuests or isRepeatable then
						self:Debug("Selecting \""..questTitle.."\" via GOSSIP_SHOW");
						SelectGossipAvailableQuest(i);
					else
						self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full.");
					end
				end
			end
		end
	end
	
end

function DailyGrind:QUEST_GREETING()
	self:Debug("QUEST_GREETING");
	
	if not Settings.Enabled or self:IsSuspendKeyDown() then 
		return; 
	end	
	
	local numAvailableQuests = GetNumAvailableQuests(); 
	local numActiveQuests = GetNumActiveQuests();

	self:Debug(tostring(numActiveQuests).." active quest(s) detected.");

	local npcName, realm = UnitName("npc");
	if CharacterNpcBlacklist:Contains(npcName) and (numAvailableQuests > 0 or numActiveQuests > 0) then
		CharacterNpcBlacklist:Print(": \""..npcName.."\" ignored.");
		return;
	end
	
	-- Turn in known completed quests. 
	if numActiveQuests > 0 then 
		for i = 1, numActiveQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(GetActiveTitle(i));
			local isComplete = self:IsCompleteActiveQuest_Greeting(questTitle)
			local isDaily = self:IsDailyActiveQuest(questTitle) or self:IsSpecialCaseQuest(questTitle);
			local isInHistory = AccountQuestHistory:Contains(questTitle);
			
			self:Debug(questTitle.." isComplete = "..tostring(isComplete));
			
			if (isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily and isComplete then 
				if CharacterBlacklist:Contains(questTitle) then 
					CharacterBlacklist:Print(": \""..questTitle.."\" ignored.");
				else
					self:Debug("Selecting \""..questTitle.."\" via QUEST_GREETING");
					SelectActiveQuest(i); 
				end 
			end 
		end 
	end

	-- Accept known available quests.
	if numAvailableQuests > 0 then 
		for i = 1, numAvailableQuests, 1 do
			local questTitle = self:SanitizeQuestTitle(GetAvailableTitle(i));
			local isTrivial, isDaily, isRepeatable = GetAvailableQuestInfo(i)
			isDaily = isDaily or self:IsSpecialCaseQuest(questTitle);
			local isInHistory = AccountQuestHistory:Contains(questTitle);
			
			if ((isInHistory or self:GetAutoAcceptAllEnabled()) and isDaily) or (isRepeatable and self:GetRepeatableQuestsEnabled()) then
				if isRepeatable then
					self:PrintRepeatable(": Attempting to turn in \""..questTitle.."\"");
				end
				if CharacterBlacklist:Contains(questTitle) then 
					CharacterBlacklist:Print(": \""..questTitle.."\" ignored.");
				else 
					if self:GetNumPlayerActiveQuests() < maxQuests then
						self:Debug("Selecting \""..questTitle.."\" via QUEST_GREETING");
						SelectAvailableQuest(i); 
					else 
						self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full."); 
					end 
				end
			end
		end
	end
	
end

function DailyGrind:QUEST_DETAIL()
	self:Debug("QUEST_DETAIL");
	
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	
	if not Settings.Enabled or self:IsSuspendKeyDown() or CharacterBlacklist:Contains(questTitle) or CharacterNpcBlacklist:Contains(npcName) then
		self:Debug("Skipping "..questTitle);
		return;
	end
	
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1 or self:IsSpecialCaseQuest(questTitle);
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = AccountQuestHistory:Contains(questTitle);
	self:DebugQuest(isDailyOrWeekly or isRepeatable, isInHistory);
	
	if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) then
		if self:GetNumPlayerActiveQuests() < maxQuests then
			self:Debug("Accepting "..questTitle);
			AcceptQuest();
		else
			self:PrintDG("Cannot auto-accept \""..questTitle.."\": Quest log is full.");
		end
	end
end

function DailyGrind:QUEST_PROGRESS()
	self:Debug("QUEST_PROGRESS");
	
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	
	if not Settings.Enabled or self:IsSuspendKeyDown() or CharacterBlacklist:Contains(questTitle) or CharacterNpcBlacklist:Contains(npcName) then
		return;
	end
	
	local isCompletable = IsQuestCompletable() == 1;
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1 or self:IsSpecialCaseQuest(questTitle);
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = AccountQuestHistory:Contains(questTitle);
	self:DebugQuest(isDailyOrWeekly or isRepeatable, isInHistory);
	
	if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) and isCompletable then
		CompleteQuest();
	end
end

function DailyGrind:QUEST_COMPLETE()
	self:Debug("QUEST_COMPLETE");
	self:CompleteQuest();
end

function DailyGrind:CompleteQuest()
	local questTitle = self:SanitizeQuestTitle(GetTitleText());
	local npcName, realm = UnitName("npc");
	local isDailyOrWeekly = QuestIsDaily() == 1 or QuestIsWeekly() == 1 or self:IsSpecialCaseQuest(questTitle);
	local isRepeatable = self:IsRepeatableQuest({GetGossipAvailableQuests()}, questTitle);
	local isInHistory = AccountQuestHistory:Contains(questTitle);
	
	self:Debug("Quest title to complete: "..questTitle);
	self:DebugQuest(isDailyOrWeekly or isRepeatable, isInHistory);

	--Attempt to turn in and record.
	if Settings.Enabled and not self:IsSuspendKeyDown() and not CharacterBlacklist:Contains(questTitle) and not CharacterNpcBlacklist:Contains(npcName) then
		if (isInHistory or self:GetAutoAcceptAllEnabled()) and (isDailyOrWeekly or isRepeatable) then
			local numQuestChoices = GetNumQuestChoices();
			if numQuestChoices <= 1 then
				self:Debug(questTitle.." reward: Single item.");
				if not disableTurnIn then
					GetQuestReward(numQuestChoices);
				end
			else
				self:Debug(questTitle.." reward: Multiple items available.");
				if not disableTurnIn then
					self:SelectReward(questTitle);
				end
			end
		end
	end
	
	if (isDailyOrWeekly or isRepeatable) and not isInHistory then
		AccountQuestHistory:Set(questTitle, 1);	-- always record, even when disabled
	end
end

function DailyGrind:SelectReward(questTitle)
	local myChoices = self:GetMatchingQuestRewards();
	local numMyChoices = self:TableCount(myChoices);
	if numMyChoices == 1 then	-- Exactly one matching item. Happy path.
		local choiceIndex, itemName;
		for index, value in pairs(myChoices) do
			choiceIndex = index;
			itemName = value;
		end
		CharacterRewardList:Print(": \""..questTitle.."\" => \""..itemName.."\" automatically selected.");
		GetQuestReward(choiceIndex);
	elseif numMyChoices > 1 then	-- 2+ matching items. Not so happy.
		CharacterRewardList:PrintImportant(": \""..questTitle.."\" => Multiple matches found:\n");
		for index, value in pairs(myChoices) do	-- Build a string that displays all the conflicting rewards.
			print(" - "..value);
		end
		print("  Please choose your reward manually and then review your "..rewardListText..".\n");
	else	-- No matching items. Sad.
		CharacterRewardList:PrintImportant(": \""..questTitle.."\" => No matching rewards found; please choose manually.");
	end
end