-- Author      : Deldinor of Elune
-- Create Date : 10/20/2012 10:21:57 PM

NpcBlacklist = List:new {
	Title = "NPC Blacklist",
	TitleColor = "FFA9A9A9";
}

function NpcBlacklist:new (o)
	o = o or {};
	setmetatable(o, NpcBlacklist);
	self.__index = self;
	return o;
end

function NpcBlacklist:GetTable()
	return Settings.NpcBlacklist;
end

function NpcBlacklist:SetTable(value)
	Settings.NpcBlacklist = value;
end

function NpcBlacklist:ShowHelp()
	print("==  "..addonTitle.." - "..self:GetTitle().."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /npcblacklist (or simply /nbl)");
	print("  Add: |c"..commandColor.."/dg /nbl add <NPC name>");
	print("  Remove: |c"..commandColor.."/dg /nbl rem[ove] <NPC name>");
	print("  Clear: |c"..commandColor.."/dg /nbl clear");
	print(self:GetTitle().." NPC names are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end