-- $Id: FastQuest_Classic.lua 154 2012-09-18 14:42:40Z arithmandar $
--[[

 "FastQuest Classic" is a free software; you can redistribute it and/or modify it under the terms of the
 GNU General Public License as published by the Free Software Foundation; either version 2 of the License,
 or (at your option) any later version.

--]]

---------------------------------------------------------------------
-- Global Variables
---------------------------------------------------------------------
-- Debug, set to false in beta and official release
FQ_DEBUG = false;
FASTQUEST_CLASSIC_VERSION = GetAddOnMetadata("FastQuest_Classic", "Version");
-- Number of the format styles
FQ_nFormats = 4;
-- Default chat channel
FQ_CHATTYPE = "SAY";
-- RealmName
FQ_server = GetCVar("realmName");
-- Player character name
FQ_player = UnitName("player");

if (	FQ_player == nil or 
		FQ_player == UNKNOWNBEING or 
		FQ_player == UKNOWNBEING or 
		FQ_player == UNKNOWNOBJECT
	) then
	FQ_player = "DEFAULT";
end

local DefaultFQDOptions = {
	["FastQuest_Classic_Version"] 	= FASTQUEST_CLASSIC_VERSION,			
	["AutoAdd"] 			= true,	
	["AutoComplete"] 		= true,		
	["AutoNotify"] 			= true,	
	["ButtonPos"]			= 60,	
	["Color"] 			= true,
	["Detail"] 			= true,
	["Format"] 			= FQ_nFormats,
	["Lock"] 			= true,
	["QuestCompleteSound"]		= true,
	["MemberInfo"] 			= true,	
	["NoDrag"] 			= false,
	["NotifyDiscover"] 		= true,		
	["NotifyExp"] 			= true,	
	["NotifyGuild"] 		= false,		
	["NotifyLevelUp"]		= true,		
	["NotifyNearby"] 		= false,		
	["NotifyParty"]			= true,	
	["NotifyRaid"] 			= false,	
	["ShowButton"]			= true,	
	["Tag"] 			= true,
	["NotificationSoundChoice"]	= "iQuestComplete",
};
---------------------------------------------------------------------

FQ_Sound_List = {
	"QuestComplete",
	"AlarmClockWarning",
	"iQuestComplete",
	"MortarTeamAttack"
};

function FastQuest_FreshOptions()
	FQ_Debug_Print("FastQuest_FreshOptions()");
	FQD = FQ_CloneTable(DefaultFQDOptions);
	FQD[FQ_server] = { };
	FQD[FQ_server][FQ_player] = { };
	FQD[FQ_server][FQ_player] = {
		["nQuests"] = 0;
		["tQuests"] = { };
	};
end

--Code by Grayhoof (SCT)
function FQ_CloneTable(t)			-- return a copy of the table t
	FQ_Debug_Print("FQ_CloneTable()");
	local new = {};				-- create a new table
	local i, v = next(t, nil);		-- i is an index of t, v = t[i]
	while i do
		if type(v) == "table" then
			v = FQ_CloneTable(v);
		end
		new[i] = v;
		i, v = next(t, i);		-- get next index
	end
	return new;
end

function FastQuest_OnLoad(self)
	FQ_Debug_Print("FastQuest_OnLoad()");

	-- Register for events
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	self:RegisterEvent("QUEST_ACCEPTED");
	self:RegisterEvent("QUEST_COMPLETE");
	self:RegisterEvent("QUEST_PROGRESS");
	self:RegisterEvent("QUEST_WATCH_UPDATE");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("UI_INFO_MESSAGE");
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("WORLD_MAP_UPDATE");

	SLASH_FQ1 = "/fastquest";
	SLASH_FQ2 = "/fq";
	SlashCmdList["FQ"] = FastQuest_SlashCmd;

	-- initialize all the default options parameters
	if (FQD == nil or FQD["FastQuest_Classic_Version"] ~= FASTQUEST_CLASSIC_VERSION) then
		FastQuest_FreshOptions();
	end	

	-- Configure QuestLogFrame to be dragable
	QuestLogFrame:SetMovable(); 
	QuestLogFrame:RegisterForDrag("LeftButton"); 
	QuestLogFrame:SetScript("OnDragStart", QuestLogFrame.StartMoving); 
	QuestLogFrame:SetScript("OnDragStop", QuestLogFrame.StopMovingOrSizing);
	QuestLogFrame:SetClampedToScreen(true);

	-- Configure QuestLogFrame to be dragable
	FQ_WatchFrame_Movable();
	
	-- Add about panel
	if (LibStub:GetLibrary("LibAboutPanel", true)) then
		LibStub("LibAboutPanel").new(nil, "FastQuest_Classic");
	end
	-- Make an LDB object
	LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("FastQuest_Classic", {
		type = "launcher",
		text = BINDING_HEADER_FASTQUEST_CLASSIC,
		OnClick = function(_, msg)
			if msg == "LeftButton" then
				FastQuest_Classic_Button_OnClick();
			elseif msg == "RightButton" then
				FastQuest_Options_Toggle();
			end
		end,
		icon = "Interface\\AddOns\\FastQuest_Classic\\Images\\FastQuest_Classic_Button-Up",
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine("|cffffffff"..BINDING_HEADER_FASTQUEST_CLASSIC)
			tooltip:AddLine(FQ_TITAN_BUTTON_TOOLTIP)
		end,
	});
	-- Add support to Titan Panel
	if ( TitanPanelButton_UpdateButton ) then
		TitanPanelButton_UpdateButton("FastQuest_Classic");
	end
end


function FastQuest_OnEvent(self, event, ...)
	--FQ_Debug_Print("FastQuest_OnEvent()");
	local arg1, arg2 = ...;

	if(event == "VARIABLES_LOADED") then
		FQ_Debug_Print("VARIABLES_LOADED");
		-- initialize all the default options parameters
		if (FQD == nil or FQD["FastQuest_Classic_Version"] ~= FASTQUEST_CLASSIC_VERSION) then
			FastQuest_FreshOptions();
		end

		FastQuest_UpdatePlayer();
		FastQuest_Options_Init();
		FastQuest_Classic_Button_Init();
		FastQuest_Classic_Button_UpdatePosition();
		-- Print the addon loaded message to chat frame
		qOut(FQ_LOADED);

		--FastQuest_LinkFrame(dQuestWatchDragButton:GetName(), WatchFrame:GetName());
		--FastQuest_LockMovableParts();
		-- It seems somehow the WatchFame's height is limited to 140, we will manually set it to the MaxResize value
--[[
		local x, y = WatchFrame:GetMaxResize();
		local y1 = WatchFrame:GetHeight();
		if (y1 < y) then
			WatchFrame:SetHeight(y);
		end
]]
		--Adds a FastQuest button to the Earth Feature Frame
		if(EarthFeature_AddButton) then
			EarthFeature_AddButton(
				{
					id = "FastQuest_Classic";
					name = "FastQuest_Classic";
					subtext = "FastQuest_Classic";
					tooltip = "FastQuest Classic";
					icon = "Interface\\Addons\\FastQuest_Classic\\Images\\FastQuest_Classic_Button-Up";
					callback = FastQuest_Options_Toggle;
					test = nil;
				}
		);
		end
	-- when a player is talking to an NPC about the status of a quest and has not yet clicked the complete button
	elseif	((event == "QUEST_PROGRESS") and (FQD.AutoComplete == true)) then
		FQ_Debug_Print("QUEST_PROGRESS");
		CompleteQuest();
	elseif	((event == "QUEST_COMPLETE") and (FQD.AutoComplete == true)) then
		FQ_Debug_Print("QUEST_COMPLETE");
		if (GetNumQuestChoices() == 0) then
			GetQuestReward(QuestFrameRewardPanel.itemChoice);
		end
	elseif ((event == "QUEST_ACCEPTED") and arg1) then
		if (FQD.AutoNotify == true) then 
			FastQuest_SendNotification( FQ_QUEST_ACCEPTED..GetQuestLink(arg1) );
		end
	elseif (event == "UI_INFO_MESSAGE" and arg1) then
		FQ_Debug_Print("UI_INFO_MESSAGE");
		-- Here the quest progress like 'You have picked up 2/20 xxx items' will be detected.
		local uQuestText = gsub(arg1, FQ_QUEST_TEXT, "%1", 1);
		if ( uQuestText ~= arg1) then
			-- Only when Auto Notify is set to true and Detail also set to true, then FQ will do the notification
			if (FQD.AutoNotify == true and FQD.Detail == true) then
				FastQuest_SendNotification(FQ_QUEST_PROGRESS..arg1);
			end
			if (FQD.AutoAdd == true and GetNumQuestWatches() < MAX_WATCHABLE_QUESTS) then
				local questIndex = FastQuest_GetQuestID(uQuestText);
				if (questIndex) then
					if (not IsQuestWatched(questIndex)) then
						FastQuest_Watch(questIndex, true);
					end
				end
			end
		else
			FastQuest_CheckPatterns(arg1);
		end
	elseif (event == "CHAT_MSG_SYSTEM" and arg1) then
		FQ_Debug_Print("CHAT_MSG_SYSTEM");
		FastQuest_CheckPatterns(arg1);
	-- When player is level up, notify the party member
	elseif ((event == "PLAYER_LEVEL_UP") and arg1) then
		FQ_Debug_Print("PLAYER_LEVEL_UP");
		if ((FQD.AutoNotify == true) and (FQD.NotifyLevelUp == true)) then
			FastQuest_SendNotification(PLAYER_LEVEL_UP..": "..arg1);
		end
	elseif (event == "WORLD_MAP_UPDATE" ) then

	end

end

function FastQuest_SlashCmd(msg)
	FQ_Debug_Print("FastQuest_SlashCmd()");

	if (msg) then
		local cmd = gsub(msg, "%s*([^%s]+).*", "%1");
		local info = FQ_INFO;
		-- Display the quest type like Elite, Dungeon, PvP, etc., info in the QuestTracker window
		if( cmd == "tag" ) then FastQuest_Toggle_Tag(); return;
		-- Auto Add, automatically add the quest items / progress into QuestTracker window
		elseif( cmd == "autoadd" ) then FastQuest_Toggle_AutoAdd(); return;
		-- Auto Notify the party members regarding to your quest progress
		elseif( cmd == "autonotify" ) then 	FastQuest_Toggle_AutoNotify(); 	return;
		-- Auto Complete, automatically hands out the quest
		elseif( cmd == "autocomplete" ) then FastQuest_Toggle_AutoComplete(); return;
		-- Allow to notify the guild members regarding to your quest progress
		elseif( cmd == "notifyguild" ) then FastQuest_Toggle_NotifyGuild(); return;
		-- Allow to notify the party members regarding to your quest progress
		elseif( cmd == "notifyparty" ) then FastQuest_Toggle_NotifyParty(); return;
		-- Allow to notify the raid members regarding to your quest progress
		elseif( cmd == "notifyraid" ) then FastQuest_Toggle_NotifyRaid(); return;
		-- Always notify your quest progress even you are not in any party
		elseif( cmd == "notifynearby" ) then FastQuest_Toggle_NotifyNearby(); return;
		-- Allow to notify your detail quest progress
		elseif( cmd == "detail" ) then FastQuest_Toggle_NotifyDetails(); return;
		-- Lock the QuestTracker window
		elseif( cmd == "lock" and FQD.NoDrag == false) then FastQuest_Toggle_Lock(); return;
		-- Unlock the QuestTracker
 		elseif( cmd == "unlock" and FQD.NoDrag == false) then FastQuest_Toggle_Unlock(); return;
		elseif( cmd == "nodrag" ) then FastQuest_Toggle_Nodrag(); return;
		-- Reset the QuestTracker window's position to default
		elseif( cmd == "reset" and FQD.NoDrag == false) then FastQuest_Toggle_Reset(); return;
		elseif( cmd == "format" )then FastQuest_Toggle_Format(); return;
		elseif( cmd == "clear" ) then FastQuest_Toggle_Clear(); return;
		elseif( cmd == "color" ) then FastQuest_Toggle_Color(); return;
		elseif( cmd == "memberinfo" ) then FastQuest_Toggle_MemberInfo(); return;
		elseif( cmd == "notifyexp" ) then FastQuest_Toggle_NotifyExp(); return;
		elseif( cmd == "notifydiscover" ) then FastQuest_Toggle_NotifyDiscover(); return;
		elseif( cmd == "notifylevelup" ) then FastQuest_Toggle_NotifyLevelUp(); return;
		elseif( cmd == "options" ) then FastQuest_Options_Init(); FastQuest_Options_Toggle(); return;
		elseif( cmd == "status" ) then
			qOut("|cfffffffffq autonotify     - "..FastQuest_ShowBoolean(FQD.AutoNotify));
			qOut("|cfffffffffq notifyguild    - "..FastQuest_ShowBoolean(FQD.NotifyGuild));
			qOut("|cfffffffffq notifyraid     - "..FastQuest_ShowBoolean(FQD.NotifyRaid));
			qOut("|cfffffffffq notifynearby   - "..FastQuest_ShowBoolean(FQD.NotifyNearby));
			qOut("|cfffffffffq autoadd        - "..FastQuest_ShowBoolean(FQD.AutoAdd));
			qOut("|cfffffffffq autocomplete   - "..FastQuest_ShowBoolean(FQD.AutoComplete));
--			qOut("|cfffffffffq color          - "..FastQuest_ShowBoolean(FQD.Color));
			qOut("|cfffffffffq detail         - "..FastQuest_ShowBoolean(FQD.Detail));
--			qOut("|cfffffffffq lock(unlock)   - "..FastQuest_ShowLock(FQD.Lock));
			qOut("|cfffffffffq memberinfo     - "..FastQuest_ShowBoolean(FQD.MemberInfo));
			qOut("|cfffffffffq notifyexp      - "..FastQuest_ShowBoolean(FQD.NotifyExp));
			qOut("|cfffffffffq notifydiscover - "..FastQuest_ShowBoolean(FQD.NotifyDiscover));
			qOut("|cfffffffffq notifylevelup  - "..FastQuest_ShowBoolean(FQD.NotifyLevelUp));
			qOut("|cfffffffffq tag            - "..FastQuest_ShowBoolean(FQD.Tag));
			return;
		else
			qOut(info..FQ_INFO_USAGE);
			qOut("|cffffffff/fq autonotify     - "..FQ_USAGE_AUTONOTIFY);
			qOut("|cffffffff/fq notifyguild    - "..FQ_USAGE_NOTIFYGUILD);
			qOut("|cffffffff/fq notifyraid     - "..FQ_USAGE_NOTIFYRAID);
			qOut("|cffffffff/fq notifynearby   - "..FQ_USAGE_NOTIFYNEARBY);
			qOut("|cffffffff/fq autoadd        - "..FQ_USAGE_AUTOADD);
			qOut("|cffffffff/fq autocomplete   - "..FQ_USAGE_AUTOCOMPLETE);
--			qOut("|cffffffff/fq clear          - "..FQ_USAGE_CLEAR);
--			qOut("|cffffffff/fq color          - "..FQ_USAGE_COLOR);
			qOut("|cffffffff/fq detail         - "..FQ_USAGE_DETAIL);
			qOut("|cffffffff/fq format         - "..FQ_USAGE_FORMAT);
--			qOut("|cffffffff/fq lock(unlock)   - "..FQ_USAGE_LOCK);
			qOut("|cffffffff/fq memberinfo     - "..FQ_USAGE_MEMBERINFO);
			qOut("|cffffffff/fq notifyexp      - "..FQ_USAGE_NOTIFYEXP);
			qOut("|cffffffff/fq notifydiscover - "..FQ_USAGE_NOTIFYDISCOVER);
			qOut("|cffffffff/fq options        - "..FQ_USAGE_OPTIONS);
--			qOut("|cffffffff/fq reset          - "..FQ_USAGE_RESET);
			qOut("|cffffffff/fq status         - "..FQ_USAGE_STATUS);
			qOut("|cffffffff/fq tag            - "..FQ_USAGE_TAG);
			return;
		end
	end
end

-- Check message's pattern from UI_INFO_MESSAGE and CHAT_MSG_SYSTEM
function FastQuest_CheckPatterns(message)
	FQ_Debug_Print("FastQuest_CheckPatterns()");

	-- 2006/08/21: If AutoNotify is set to false, then the party members should not be notified.
	if (FQD.AutoNotify == false) then
		return;
	end
	if (GetNumSubgroupMembers() == 0 and FQD.NotifyNearby == false) then
		return;
	end
	for index, value in pairs(EPA_TestPatterns) do
		if ( string.find(message, value) ) then
			FastQuest_CheckDefaultChat(false);
			-- if the message type is experience gained, and user set not to notify
			if (value == EPA_TestPatterns[5] and FQD.NotifyExp == false) then
				break;
			-- if the message type is zone discovered, and user set not to notify
			elseif (value == EPA_TestPatterns[6] and FQD.NotifyDiscover == false) then
				break;
			else
				FastQuest_SendNotification(message);
			end
			break;
		end
	end
end

-- Replace the built-in QuestLogTitleButton_OnClick() to enhance with several FQ features
function QuestLogTitleButton_OnClick(self, button)
	FQ_Debug_Print("QuestLogTitleButton_OnClick()");

	local qIndex = self:GetID();
	local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete = GetQuestLogTitle(qIndex);
	local LevelTag = "";
	local activeWindow = ChatEdit_GetActiveWindow();
	if (suggestedGroup == 0) then 
		suggestedGroup = ""; 
	else
		suggestedGroup = ":"..suggestedGroup;
	end
	if ( self.isHeader ) then
		if ( isCollapsed ) then
			ExpandQuestHeader(qIndex);
		else
			CollapseQuestHeader(qIndex);
		end
		return;
	end

	if (questTag) then
		if (questTag == LFG_TYPE_DUNGEON ) then
			LevelTag = "d";
		elseif (questTag == RAID ) then
			LevelTag = "r";
		elseif (questTag == PVP ) then
			Leveltag = "p";
		else
			LevelTag = "+";
		end
	end

	local s_questString;
	if (FQD.Format == 2) then
		 s_questString = "["..level.."]"..GetQuestLink(qIndex);
	elseif (FQD.Format == 1) then
		s_questString = GetQuestLink(qIndex);
	elseif (FQD.Format == 3) then
		s_questString = "["..level..LevelTag.."]"..GetQuestLink(qIndex);
	elseif (FQD.Format == 4) then
		if (questTag) then questTag = ("("..questTag..")") else questTag = "";end
		s_questString = "["..level..LevelTag.."]"..GetQuestLink(qIndex)..questTag..suggestedGroup;
	else
	end


	if ( button == "LeftButton" ) then
		QuestLog_SetSelection(qIndex);
		-- Display quest link in chat frame
		if ( IsShiftKeyDown() and activeWindow ) then
			activeWindow:Insert(s_questString);
		-- Add quest to quest watch frame
		elseif ( IsShiftKeyDown() ) then
			FastQuest_Watch(qIndex,false);
		-- Display quest detail progress in chat frame
		elseif (IsControlKeyDown() and activeWindow) then
			activeWindow:Insert(s_questString);
			local nObjectives = GetNumQuestLeaderBoards(qIndex);
			if ( nObjectives > 0 ) then
				activeWindow:Insert(":");
				for i=1, nObjectives do
					oText, oType, finished = GetQuestLogLeaderBoard(i, qIndex);
					if ( not oText or strlen(oText) == 0 or oText == "" ) then oText = oType;end
					if ( finished ) then
						activeWindow:Insert("(X "..oText..")");
					else
						activeWindow:Insert("(- "..oText..")");
					end
				end
			end
		end
		QuestLog_Update();
		WatchFrame_Update();
	elseif ( button == "RightButton" ) then
		QuestLog_SetSelection(qIndex);
		local qDescription, qObjectives = GetQuestLogQuestText();
		local s_qObjectives = string.gsub(qObjectives, "\n", "");
		local s_qDescription = string.gsub(qDescription, "\n", "");

		-- Display quest brief objective in chat frame
		if ( IsControlKeyDown() and activeWindow) then
			FastQuest_CheckDefaultChat(true);
			if (qObjectives) then
				activeWindow:Insert(s_questString..": "..s_qObjectives);
			end
			return;
		end
		FastQuest_Watch(qIndex, false);
		QuestLog_Update();
		WatchFrame_Update();
	end
end

function FastQuest_ChangeTitle(questLogTitle, questLogTitleText, level, questTag, suggestedGroup, isHeader, isDaily, Watch)
	--FQ_Debug_Print("FastQuest_ChangeTitle()");

	local ColorTag = "";
	local DifTag = "";
	local LevelTag = "";
	local cQuestLevel = FastQuest_GetDiffColor(level);
	local LevelString = "";
	if (questLogTitleText and not isHeader) then
		if (FQD.Color == true) then
			ColorTag = string.format("|cff%02x%02x%02x", cQuestLevel.r * 255, cQuestLevel.g * 255, cQuestLevel.b * 255);
		else
			ColorTag = "";
		end
		if (FQD.Tag == true) then
			if (questTag ~= nil) then
				if (isDaily) then
					questTag = format(DAILY_QUEST_TAG_TEMPLATE, questTag);
				end
				DifTag = (" ("..questTag..") ");

				if (questTag == LFG_TYPE_DUNGEON ) then LevelTag = "d";
				elseif (questTag == RAID ) then LevelTag = "r";
				elseif (questTag == PVP ) then LevelTag = "p";
				else LevelTag = "+"; end

			elseif (isDaily) then
				DifTag = (" ("..DAILY..") ");
			end
		end

		if (FQD.Format == 1) then
			LevelString = "";
		elseif (FQD.Format == 2) then
			LevelString = "["..level.."] ";
		elseif (FQD.Format == 3) then
			LevelString = "["..level..LevelTag.."] ";
		elseif (FQD.Format == 4) then
			LevelString = "["..level..LevelTag.."] ";
		end

		if (Watch) then
			questLogTitle:SetText(ColorTag..LevelString..questLogTitleText..DifTag);
		else
			if (suggestedGroup > 0 and FQD.MemberInfo == true) then
				questLogTitle:SetText(ColorTag.." "..LevelString..questLogTitleText.." ("..suggestedGroup..") ");
			else
				questLogTitle:SetText(ColorTag.." "..LevelString..questLogTitleText.." ");
			end
		end
	end
end

function FastQuest_LinkFrame(dButton, pFrame)
	FQ_Debug_Print("FastQuest_LinkFrame()");
	if (FQD.NoDrag == false) then
		_G[pFrame]:ClearAllPoints();
		_G[pFrame]:SetPoint("TOPLEFT", dButton, "TOPRIGHT", 0, 0);
	else
		qOut(FQ_DRAG_DISABLED);
		FQD.Lock = true;
	end
end

--[[ We did not need dQuestWatchDragButton now
function FastQuest_LockMovableParts()
	--FQ_Debug_Print("FastQuest_LockMovableParts()");

-- Disable below codes since now the WtachFrame's dragging is not working properly
	if (
		( GetNumQuestWatches() > 0 ) and 
		( WatchFrame:IsVisible() ) and 
		( FQD.Lock == false ) and 
		( FQD.NoDrag == false )
		) then
		dQuestWatchDragButton:Show();
	else
		dQuestWatchDragButton:Hide();
	end
end
]]

function FastQuest_UpdatePlayer()
	FQ_Debug_Print("FastQuest_UpdatePlayer()");

	if ( FQD[FQ_server] == nil ) then
		FQD[FQ_server] = {};
	end
	--if ( FQD[FQ_server][FQ_player] == nil or FQD[FQ_server][FQ_player].tQuests == nil ) then
	if ( FQD[FQ_server][FQ_player] == nil) then
		FQD[FQ_server][FQ_player] = {
			["nQuests"] = 0;
			["tQuests"] = { };
		};
		for i=1, MAX_WATCHABLE_QUESTS, 1 do
			FQD[FQ_server][FQ_player].tQuests[i] = " ";
		end;
	end
end

function FastQuest_GetDiffColor(level)
	--FQ_Debug_Print("FastQuest_GetDiffColor()");

	local lDiff = level - UnitLevel("player");
	if (lDiff >= 0) then
		for i= 1.00, 0.10, -0.10 do
			color = {r = 1.00, g = i, b = 0.00};
			if ((i/0.10)==(10-lDiff)) then return color; end
		end
	elseif ( -lDiff < GetQuestGreenRange() ) then
		for i= 0.90, 0.10, -0.10 do
			color = {r = i, g = 1.00, b = 0.00};
			if ((9-i/0.10)==(-1*lDiff)) then return color; end
		end
	elseif ( -lDiff == GetQuestGreenRange() ) then
		color = {r = 0.50, g = 1.00, b = 0.50};
	else
		color = {r = 0.75, g = 0.75, b = 0.75};
	end
	return color;
end

function FastQuest_Watch(questIndex, auto)
	FQ_Debug_Print("FastQuest_Watch()");

	if (questIndex) then
		if ((IsQuestWatched(questIndex)) and (auto == false)) then
			RemoveQuestWatch(questIndex);
			--QuestLog_Update();
			WatchFrame_Update();
			--WatchFrame:SetPoint("TOPLEFT", "dQuestWatchDragButton", "BOTTOMRIGHT", 0, 0);
		else
			-- If the quest does not have any objective item, we will not add this quest into the WatchFrame
--[[
			if ((GetNumQuestLeaderBoards(questIndex) == 0) and (auto == false)) then
				UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
				return;
			end
]]

			-- Set an error message if trying to show too many quests
				
			if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then -- Check this first though it's less likely, otherwise they could make the frame bigger and be disappointed
				UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0);
				return;
			end

			AddQuestWatch(questIndex);
-- 			QuestLog_Update();
			WatchFrame_Update();
--			WatchFrameLines:SetPoint("TOPLEFT", "dQuestWatchDragButton", "BOTTOMRIGHT", 0, 0);
		end
	end
end

function FastQuest_GetQuestID(str)
	local questSelected = GetQuestLogSelection();
	for i=1, GetNumQuestLogEntries(), 1 do
		SelectQuestLogEntry(i);
		local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if (questLogTitleText == str ) then return i; end
		if(not isHeader) then
			for j = 1, GetNumQuestLeaderBoards() do
				local oText, oType, finished = GetQuestLogLeaderBoard(j);
				if ((oText==nil) or (oText=="")) then
					oText = oType;
				end
				if (string.find(gsub(oText,"(.*): %d+/%d+","%1",1),gsub(str,"(.*): %d+/%d+","%1",1))) then
					SelectQuestLogEntry(questSelected);
					return i;
				end
			end
			local qDescription, qObjectives = GetQuestLogQuestText();
			if(string.find(qObjectives, str)) then
				SelectQuestLogEntry(questSelected);
				return i;
			end
		end
	end
	SelectQuestLogEntry(questSelected);
	return nil;
end

function FastQuest_CheckDefaultChat(bool)
	if (GetNumSubgroupMembers() == 0) then
		FQ_CHATTYPE = "SAY";
	else
		if (FQD.NotifyGuild == true) then
			FQ_CHATTYPE = "GUILD";
		elseif (FQD.NotifyRaid == true and IsInRaid() ) then
			FQ_CHATTYPE = "RAID";
		else
			FQ_CHATTYPE = "PARTY";
		end
	end
end

-- This function will deal with all the condition to notify quest event
function FastQuest_SendNotification(message)
	FQ_Debug_Print("FastQuest_SendNotification()");

	-- If NotifyNearby is set to true, then quest event will be send via "SAY" channel
	if (FQD.NotifyNearby == true) then
		SendChatMessage(message, "SAY");
	end
	if (FQD.NotifyParty == true and GetNumSubgroupMembers() > 0) then
		SendChatMessage(message, "PARTY");
	end
	if (FQD.NotifyRaid == true and IsInRaid() ) then
		SendChatMessage(message, "RAID");
	end
	if (FQD.NotifyGuild == true and IsInGuild() == 1 ) then
		SendChatMessage(message, "GUILD");
	end
end

function FastQuest_ShowLock ( bool )
	if( bool == true ) then
		return FQ_LOCK;
	else
		return FQ_UNLOCK;
	end
end

function qOut (msg)
	if( DEFAULT_CHAT_FRAME and msg) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

function FQ_Debug_Print(msg)
	if (FQ_DEBUG) then
		qOut("FQ DEBUG: "..msg);
	end
end

function FQ_WatchFrame_Movable()
	-- We have some problem in the questframe position and will need to be fixed in the future
	if (FQD.NoDrag == false) then
		FQD.Lock = true;
		WatchFrame:EnableMouse(true);
		WatchFrame:SetMovable(); 
		WatchFrame:RegisterForDrag("LeftButton"); 
		WatchFrame:SetScript("OnDragStart", FQ_WatchFrame_StartMoving); 
		WatchFrame:SetScript("OnDragStop", FQ_WatchFrame_StopMoving);
		WatchFrame:SetClampedToScreen(true);
	else
		FQD.Lock = false;
		WatchFrame:RegisterForDrag(nil); 
		WatchFrame:EnableMouse(false);
		WatchFrame:SetMovable(false); 
	end
end

function FQ_WatchFrame_StartMoving()
	WatchFrame:StartMoving(self);
end

function FQ_WatchFrame_StopMoving()
	WatchFrame:StopMovingOrSizing();

	FQ_WatchFrame_Top = WatchFrame:GetTop();
	FQ_WatchFrame_Left = WatchFrame:GetLeft();
	FQ_WatchFrame_Width = WatchFrame:GetWidth();
	FQ_WatchFrame_Height = WatchFrame:GetHeight();
end

