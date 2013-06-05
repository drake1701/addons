-- Author      : Deldinor of Elune
-- Create Date : 2/12/2011 3:01:46 PM

Blacklist = List:new {
	Title = "Blacklist",
	TitleColor = "FF808080";
}

function Blacklist:new (o)
	o = o or {};
	setmetatable(o, Blacklist);
	self.__index = self;
	return o;
end

function Blacklist:GetTable()
	return Settings.Blacklist;
end

function Blacklist:SetTable(value)
	Settings.Blacklist = value;
end

function Blacklist:ShowHelp()
	print("==  "..addonTitle.." - "..self:GetTitle().."  ==\n");
	print("Usage:");
	print("  Show List: |c"..commandColor.."/dg /blacklist (or simply /bl)");
	print("  Add: |c"..commandColor.."/dg /bl add <quest title>");
	print("  Remove: |c"..commandColor.."/dg /bl rem[ove] <quest title>");
	print("  Clear: |c"..commandColor.."/dg /bl clear");
	print(self:GetTitle().." quest titles are NOT case-sensitive, but all punctuation is required. You may may also use |c"..commandColor.."*|r as a wildcard.\n");
end