-- Author      : Deldinor of Elune
-- Create Date : 2/13/2011 9:32:19 AM

function DailyGrind:TableCount(theTable)
	local count = 0;
	for index, value in pairs(theTable) do
		count = count + 1;
	end
	return count;
end

-- Remove quest levels added by some addons
function DailyGrind:SanitizeQuestTitle(questTitle)
	return questTitle:gsub("%[%-?%d+%] (.+)", "%1", 1);
end