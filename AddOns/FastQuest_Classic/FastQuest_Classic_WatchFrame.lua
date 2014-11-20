-- $Id: FastQuest_Classic_WatchFrame.lua 139 2011-05-22 18:23:01Z arithmandar $

-- Hook the original Blizzard WatchFrame_Update to run inside the modded WatchFrame_Update()
H_WatchFrame_Update = WatchFrame_Update;

local watchButtonIndex = 1;
local WATCHFRAME_LINKBUTTONS = {};
local function WatchFrame_ResetLinkButtons ()
	watchButtonIndex = 1;
end

local function WatchFrame_ReleaseUnusedLinkButtons ()
	local watchButton;
	for i = watchButtonIndex, #WATCHFRAME_LINKBUTTONS do
		watchButton = WATCHFRAME_LINKBUTTONS[i];
		watchButton.type = nil
		watchButton.index = nil;
		watchButton:Hide();
		watchButton.frameCache:ReleaseFrame(watchButton);
		WATCHFRAME_LINKBUTTONS[i] = nil;
	end
end


function WatchFrame_Update (self)
--	H_WatchFrame_Update();

	local questDoneID = -1;
	local numQuestWatches = GetNumQuestWatches();
	local questIndex = 1;
	
	for i = 1, numQuestWatches do
		questIndex = GetQuestIndexForWatch(i);
		
		if ( questIndex ) then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questIndex);
			local numObjectives = GetNumQuestLeaderBoards(questIndex);

			if(isComplete) then 
				questDoneID = questIndex;
			end
		end
	end
	
	if (questDoneID > 0) then
		if (FQD.QuestCompleteSound) then
			--PlaySoundFile("Interface\\AddOns\\FastQuest_Classic\\Sounds\\QuestComplete.mp3");
			PlaySoundFile("Interface\\AddOns\\FastQuest_Classic\\Sounds\\"..FQD.NotificationSoundChoice..".mp3");
		end
		UIErrorsFrame:AddMessage("|cff00ffff"..GetQuestLogTitle(questDoneID)..FQ_QUEST_COMPLETED, 1.0, 1.0, 1.0, 1.0, 2);
		if (FQD.AutoNotify == true) then
			FastQuest_SendNotification(GetQuestLink(questDoneID)..FQ_QUEST_ISDONE);
		end
		RemoveQuestWatch(questDoneID);
		H_WatchFrame_Update();
	end

	self = self or WatchFrame; -- Speeds things up if we pass in this reference when we can conveniently.
	-- Display things in this order: quest timers, achievements, quests, addon subscriptions.
	if ( self.updating ) then
		return;
	end

	self.updating = true;
	self.watchMoney = false;
	
	local nextAnchor = nil;
	local lineFrame = WatchFrameLines;
	local maxHeight = (WatchFrame:GetTop() - WatchFrame:GetBottom()); -- Can't use lineFrame:GetHeight() because it could be an invalid rectangle (width of 0)
	
	local maxFrameWidth = WATCHFRAME_MAXLINEWIDTH;
	local maxWidth = 0;
	local maxLineWidth;
	local numObjectives;
	local totalObjectives = 0;
	
	WatchFrame_ResetLinkButtons();
	
	for i = 1, #WATCHFRAME_OBJECTIVEHANDLERS do
		nextAnchor, maxLineWidth, numObjectives = WATCHFRAME_OBJECTIVEHANDLERS[i](lineFrame, nextAnchor, maxHeight, maxFrameWidth);
		maxWidth = max(maxLineWidth, maxWidth);
		totalObjectives = totalObjectives + numObjectives
	end
	--disabled for now, might make it an option
	--lineFrame:SetWidth(min(maxWidth, maxFrameWidth));
	
	if ( totalObjectives > 0 ) then
		WatchFrameHeader:Show();
		WatchFrameCollapseExpandButton:Show();
		WatchFrameTitle:SetText(OBJECTIVES_TRACKER_LABEL.." ("..totalObjectives..")");
		WatchFrameHeader:SetWidth(WatchFrameTitle:GetWidth() + 4);
		-- visible objectives?
		if ( nextAnchor ) then
			if ( self.collapsed and not self.userCollapsed ) then
				WatchFrame_Expand(self);
			end
			WatchFrameCollapseExpandButton:Enable();
		else
			if ( not self.collapsed ) then
				WatchFrame_Collapse(self);
			end
			WatchFrameCollapseExpandButton:Disable();		
		end		
	else
		WatchFrameHeader:Hide();
		WatchFrameCollapseExpandButton:Hide();
	end
	
	WatchFrame_ReleaseUnusedLinkButtons();
	
	self.updating = nil;
end

