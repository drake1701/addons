-- Author      : Deldinor of Elune
-- Create Date : 3/27/2013 1:13:05 PM

List = {
	Table = {},
	Title = "Generic List",
	TitleColor = "FFFFFFFF"
};

local Table = {};

function List:new (o)
	o = o or { Table = {} };
	local obj = setmetatable(o, List);
	self.__index = self;
	self:SetTable(o.Table);
	return o;
end

function List:GetTitle()
	return "|c"..tostring(self.TitleColor)..tostring(self.Title).."|r";
end

function List:HandleCommand(args)
	if table.getn(args) == 1 then
		self:PrintImportant(":");
		if self:Count() > 0 then
			for index, value in pairs(self:GetTable()) do
				print("     "..index);
			end
		else
			print("     <empty>");
		end
	elseif args[2] ~= nil then
		local action = args[2]:trim():lower();
		local value = "";
		if args[3] ~= nil then
			value = args[3]:trim():gsub("\"", "");		-- get rid of double-quotes (people may assume they're necessary around the name)
			value = value:gsub("<", ""):gsub(">", "")	-- and angle brackets, in case people take the documentation too literally...
		end
		if action == "add" then
			self:Add(value);
		elseif action == "remove" or action == "rem" then
			self:Remove(value);
		elseif action == "clear" then
			self:Clear();
			self:Print(" cleared.");
		elseif action == "help" then
			self:ShowHelp();
		end
	else
		self:ShowHelp();
	end
end

function List:Print(text)
	DailyGrind:PrintDG(self:GetTitle()..tostring(text));
end

function List:PrintImportant(text)
	DailyGrind:PrintImportantDG(self:GetTitle()..tostring(text));
end

function List:Count()
	return DailyGrind:TableCount(self:GetTable());
end

function List:Add(item)
	if item == "" then
		self:PrintImportant(" needs something to add!");
		return;
	end
	if not self:Contains(item) then
		local table = self:GetTable();
		table[item] = self:Count() + 1;
		self:SetTable(table);
		self:PrintImportant(": \""..item.."\" added.");
	else
		self:PrintImportant(": \""..self:FindIndex(item).."\" already exists");
	end
end

function List:Set(item, value)
	local table = self:GetTable();
	table[item] = value;
	self:SetTable(table);
end

function List:Remove(item)
	if item == "" then
		self:PrintImportant(" needs something to remove!");
		return;
	end
	if self:Contains(item) then
		local index = self:FindIndex(item);
		local table = self:GetTable();
		table[index] = nil;
		self:SetTable(table);
		self:PrintImportant(": \""..index.."\" removed.");
	else
		self:PrintImportant(": \""..item.."\" not found.");
	end
end

function List:Clear()
	self:SetTable({});
end

function List:FindIndex(indexToFind)
   	for index, value in pairs(self:GetTable()) do
		indexLowered = index:gsub("%*", "%.%*"):lower();
		indexToFindLowered = indexToFind:lower();
   		if indexLowered == indexToFindLowered or indexToFindLowered:find("^"..indexLowered.."$") then
			return index;
		end
	end
end

function List:FindIndexByValue(valueToFind)
   	for index, value in pairs(self:GetTable()) do
		if value == valueToFind then
			return index;
		end
	end
end

function List:Contains(item)
	return self:FindIndex(item) ~= nil;
end

function List:Populate(items)
	local table = {};
	for index, item in pairs(items) do
		if item ~= "" then
			table[DailyGrind:SanitizeQuestTitle(item)] = DailyGrind:TableCount(table) + 1;
		end
	end
	self:SetTable(table);
	self:Print(" updated.");
end

function List:ToString()
	local list = "";
	for index = 0, self:Count() do
		local item = self:FindIndexByValue(index);
		if item ~= nil then
			list = list..item.."\n";
		end
	end
	return list;
end

function List:GetTable()
	return Table;
end

function List:SetTable(value)
	Table = value;
end

function List:ShowHelp()
end