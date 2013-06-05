-- Author      : Deldinor of Elune
-- Create Date : 2/12/2011 3:01:53 PM

RewardList = List:new {
	Title = "Reward List",
	TitleColor = "FFC1FFC5";
}

function RewardList:new (o)
	o = o or {};
	setmetatable(o, RewardList);
	self.__index = self;
	return o;
end

function RewardList:GetTable()
	return Settings.RewardList;
end

function RewardList:SetTable(value)
	Settings.RewardList = value;
end

function RewardList:ShowHelp()
	print("==  "..addonTitle.." - "..self:GetTitle().."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /rewardlist (or simply /rl)");
	print("  Add: |c"..commandColor.."/dg /rl add <item name>");
	print("  Remove: |c"..commandColor.."/dg /rl rem[ove] <item name>");
	print("  Clear: |c"..commandColor.."/dg /rl clear");
	print(self:GetTitle().." reward names are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end