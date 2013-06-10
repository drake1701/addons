-- Author      : Deldinor
-- Create Date : 6/2/2013 12:20:00 AM

SuspendKeyList = List:new {
	Title = "Suspend Key List",
	TitleColor = "FFC1FFC5";
}

function SuspendKeyList:new (o)
	o = o or {};
	setmetatable(o, SuspendKeyList);
	self.__index = self;
	return o;
end

function SuspendKeyList:GetTable()
	return Settings.SuspendKeys;
end

function SuspendKeyList:SetTable(value)
	Settings.SuspendKeys = value;
end

function SuspendKeyList:Set(item, value)
	local table = self:GetTable();
	if not value then
		table[item] = nil;
	else
		table[item] = value;
	end
	self:SetTable(table);
end

function SuspendKeyList:ToString()
	local list = "";
	for index, item in pairs(self:GetTable()) do
		if list:len() > 0 then
			list = list.." or ";
		end
		list = list..index;
	end
	return list;
end