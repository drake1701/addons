-- Author      : Deldinor of Elune
-- Create Date : 5/30/2013 11:39:48 PM

QuestList = List:new {
	Title = "Quest List",
	TitleColor = "FFC1FFC5";
}

function QuestList:new (o)
	o = o or {};
	setmetatable(o, QuestList);
	self.__index = self;
	return o;
end

function QuestList:GetTable()
	return QuestHistory;
end

function QuestList:SetTable(value)
	QuestHistory = value;
end