-- Author      : Deldinor of Elune
-- Create Date : 10/25/2012 9:58:54 PM

function DailyGrind:ChatCommand(input)
	local args = { strsplit(" ", input:trim(), 3) };
	local command = args[1]:lower();
	
	if command == "" then
		self:Debug("Default action");
		self:ShowOptions();
	
  	elseif command == "enable" or command == "on" then
		self:SetEnabled(true);
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "disable" or command == "off" then
		self:SetEnabled(false);
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "toggle" or command == "tog" then
		self:Toggle();
		print(addonAbbr.." "..self:GetStatus());
		
	elseif command == "all" then
		self:ToggleAutoAcceptAll();
		print(addonAbbr.." "..self:GetAutoAcceptAllStatus());
		
	elseif command == "blacklist" or command == "bl" then
		CharacterBlacklist:HandleCommand(args);
	
	elseif command == "npcblacklist" or command == "nbl" then
		CharacterNpcBlacklist:HandleCommand(args);
		
	elseif command == "rewardlist" or command == "rl" then
		CharacterRewardList:HandleCommand(args);
		
	elseif command == "repeatable" or command == "rpt" then
		self:ToggleRepeatableQuests();
		self:PrintDG(" "..self:GetRepeatableQuestsStatus());
	
	elseif command == "verbose" or command == "ver" then
		self:ToggleVerbose()
		self:PrintImportantDG(" "..self:GetVerboseStatus());
	
	elseif command == "trim" then
		self:TrimList();

	else
		self:ShowHelp();
		
    end
end

function DailyGrind:ResetHistory()
	AccountQuestHistory:Clear();
	self:PrintImportantDG(" Quest history reset.");
end

function DailyGrind:Toggle()
	self:SetEnabled(not self:GetEnabled());
end

function DailyGrind:SetEnabled(state)
	Settings.Enabled = state;
end

function DailyGrind:GetEnabled()
	return Settings.Enabled;
end

function DailyGrind:ToggleAutoAcceptAll()
	self:SetAutoAcceptAllEnabled(not self:GetAutoAcceptAllEnabled());
end

function DailyGrind:SetAutoAcceptAllEnabled(state)
	Settings.AutoAcceptAllEnabled = state;
end

function DailyGrind:GetAutoAcceptAllEnabled()
	return Settings.AutoAcceptAllEnabled;
end

function DailyGrind:ToggleVerbose()
	self:SetVerbose(not self:GetVerbose());
end

function DailyGrind:GetVerbose()
	return Settings.Verbose;
end

function DailyGrind:SetVerbose(state)
	Settings.Verbose = state;
end

function DailyGrind:GetStatus()
	local status = addonTitle.." - ";
	if self:GetEnabled() then
		return status..enabledText;
	else
		return status..disabledText;
	end
end

function DailyGrind:GetAutoAcceptAllStatus()
	local status = "Auto-accept all quests option is ";
	if self:GetAutoAcceptAllEnabled() then
		return status..enabledText;
	else
		return status..disabledText;
	end
end

function DailyGrind:GetVerboseStatus()
	local status = "Verbose Mode - ";
	if self:GetVerbose() then
		return status..enabledText;
	else
		return status..disabledText;
	end
end

function DailyGrind:SetRepeatableQuestsEnabled(state)
	Settings.RepeatableQuestsEnabled = state;
end

function DailyGrind:GetRepeatableQuestsEnabled()
	return Settings.RepeatableQuestsEnabled;
end

function DailyGrind:ToggleRepeatableQuests()
	self:SetRepeatableQuestsEnabled(not self:GetRepeatableQuestsEnabled());
end

function DailyGrind:GetRepeatableQuestsStatus()
	local repeatable = "Full automation of repeatable quests is ";
	if self:GetRepeatableQuestsEnabled() then
		return repeatable..enabledText..".\n|cFFFF0000"..repeatableWarning.."|r";
	else
		return repeatable..disabledText;
	end
end

function DailyGrind:ShowHelp()
	print("==]  "..self:GetStatus().."  [==\n");
	print("Dailies that you complete are added to a database. Whenever you see that daily again, you will auto-accept/complete it.");
	print("You may also set "..addonTitle.." to auto-accept ALL daily quests, whether or not you have seen them before, by using |c"..commandColor.."/dg all|r. Dailies that you complete with this option enabled will continue to be added to your database, so turning this option off later will not set you back.");
	print("Usage:  |c"..commandColor.."/dg <enable/on> <disable/off> <tog[gle]> <all> <repeatable/rpt> <ver[bose]>|r\n");
	print(CharacterRewardList:GetTitle()..": Set automatic reward preferences (|c"..commandColor.."/dg rl help|r for more info)");
	print(CharacterBlacklist:GetTitle()..": Ignore specific quests (|c"..commandColor.."/dg bl help|r for more info)");
	print(CharacterNpcBlacklist:GetTitle()..": Ignore quests from specific NPCs (|c"..commandColor.."/dg nbl help|r for more info)");
	print("Hold "..CharacterSuspendKeyList:ToString().." while speaking to an NPC to suspend automation.");
end