--[[ Roster

	This module handles the list of pets that will be displayed in the browser.

	The actual displaying is handled in browser.lua/xml.  This just populates a list of pets
	based on filters and flags.

	The UI's live collected/type/source filters are allowed to apply normally and "first".
	If strong vs or tough vs filter is enabled, pet type filter is cleared to let all types through.
	The UI's search filter is not allowed to be applied (search is cleared when pets gathered).
	Our own search filter looks for text from what's left above (abilities too).
	Then a post-search filter discards types for strong vs and tough vs if we're in the mode.

		GetNumPets() -- returns total number of pets
		GetPetByIndex(index) -- returns petID of owned pet or speciesID of missing pet
		Update() -- updates roster with internal PET_JOURNAL_LIST_UPDATE force flag

]]

local _,L = ...
local rematch = Rematch
rematch.roster = {}
local roster = rematch.roster

roster.toughTable = {8,4,2,9,1,10,5,3,6,7} -- types that indexed types are tough vs
roster.strongTable = {4,1,6,5,8,2,9,10,3,7} -- types that indexed types are strong vs

roster.pets = {} -- table of pet indexes, created in GenerateIndexes, owned or missing, regardless of filters
roster.abilityList = rematch.abilityList -- reusable table for C_PetJournal.GetAbilityList
roster.levelList = rematch.levelList -- passed to C_PetJournal.GetAbilityList (prevents a ton of garbage creation)
roster.typeFilter = {nil,{},{}} -- 1=type, 2=strong, 3=tough
roster.rarityFilter = {} -- 1-4 poor-rare filter
roster.miscFilter = {} -- miscellaneous extra filters
roster.miscGroups = {	Tradable=L["Tradable"], NotTradable=L["Tradable"], -- radio button groups
											Leveling=L["Leveling"], NotLeveling=L["Leveling"], -- and filter result tag
											CanBattle=L["Battle"], CantBattle=L["Battle"],
											Qty1=L["Quantity"], Qty2=L["Quantity"], Qty3=L["Quantity"],
											Favorite=L["Favorite"], CurrentZone=L["Zone"],
											InATeam=L["Team"], NotInATeam=L["Team"], Level25=L["Level"], None25=L["Level"] }

roster.searchStatRanges = {} -- Level={1,24} Speed={300,305} Health={1400,nil} Power={nil,100}
roster.searchStat = {} -- [1]=stat like "Speed", [2]=operator like ">", [3]=value like 278
roster.searchStatMasks = { [PET_BATTLE_STAT_HEALTH:lower()]="Health", -- translate stats
													 [PET_BATTLE_STAT_POWER:lower()]="Power",
													 [PET_BATTLE_STAT_SPEED:lower()]="Speed",
													 [LEVEL:lower()]="Level",
													 ["health"]="Health", -- english for unlocalized versions
													 ["power"]="Power",
													 ["speed"]="Speed",
													 ["level"]="Level",
													 ["h"]="Health",
													 ["p"]="Power",
													 ["s"]="Speed",
													 ["l"]="Level",
													}

function roster:Updated()
	rematch:StartTimer("UpdateWindow",0,rematch.UpdateWindow)
end

-- returns number of pets in roster
function roster:GetNumPets()
	return #roster.pets
end

-- returns a petID/speciesID by roster index
function roster:GetPetByIndex(index)
	return roster.pets[index]
end

function roster:GetPetNameByIndex(index)
	local customName,realName,_
	local petID = roster.pets[index]
	if type(petID)=="string" then
		_,customName,_,_,_,_,_,realName = C_PetJournal.GetPetInfoByPetID(roster.pets[index])
	elseif type(petID)=="number" then
		realName = C_PetJournal.GetPetInfoBySpeciesID(petID)
	end
	return customName or realName
end

-- this populates roster.pets with petIDs or speciesIDs depending on current filters
-- note it does not (and should never) do anything to trigger a PET_JOURNAL_LIST_UPDATE
function roster:Update()
	wipe(roster.pets)

	local checkStrong = not roster:IsTypeFilterClear(2)
	local checkTough = not roster:IsTypeFilterClear(3)
	local checkRarity = not roster:IsRarityFilterClear()
	local checkStats = next(roster.searchStatRanges) and true
	local checkMisc = next(roster.miscFilter) and true

	if roster:GetMiscFilter("CurrentZone") then
		roster.currentZone = (GetRealZoneText() or ""):gsub("%-","%%-")
	end

	if roster:GetMiscFilter("InATeam") or roster:GetMiscFilter("NotInATeam") then
		rematch:ValidateAllTeams()
	end

	-- gather pets
	for i=1,C_PetJournal.GetNumPets() do
		local candidate = roster:FilterPetByIndex(i,checkStrong,checkTough,checkRarity,checkStats,checkMisc)
		if candidate then
			tinsert(roster.pets,candidate)
		end
	end

end

--[[ Search box ]]

function roster:SetSearch(text)
	-- search can be text, level or stat; clear them all first
	roster.searchText = nil
	wipe(roster.searchStatRanges)

	if not text or text=="" or text==SEARCH then
		-- keep everything nil
	else
		roster.searchText = roster:ParseSearchTextForRanges(text)
		if roster.searchText then -- if we still have anything to search for after parsing
			-- searchMask is a literal/case-insensitive pattern ("Xu-Fu" becomes "[xX][uU]%-[fF][uU]")
			roster.searchMask = rematch:DesensitizedText(roster.searchText)
		end
	end
	roster:Updated()
end

-- used by SetSearch above to pull out any stat ranges and return a real search text
-- if any stat ranges are found (level=21-24, speed>250, etc) searchStatRanges filled
function roster:ParseSearchTextForRanges(text)
	if not text or not text:match("[><=-]") then
		return text -- no >, < or = here (or no text!), return text unparsed
	end
	wipe(roster.searchStatRanges)

	-- pull out operations with a declared stat ("stat=val1-val2" or "stat<val1" etc)
	text = text:gsub("%s?%w+[><=]=?%d+%-?%d*%s?",function(range)
		local stat,operator,val1,val2 = range:match("%s?(%w+)([><=]=?)(%d+)%-?(%d*)%s?")
		roster:FillStatOperation(stat,operator,val1,val2)
		return "" -- remove these operations from the text
	end)

	-- support old level searches: "11-14" "1-24" for true range (my regex-fu needs work)
	text = text:gsub("%s?=?%d+%-%d+%s?",function(range)
		local val1,val2 = range:match("(%d+)%-(%d+)")
		roster:FillStatOperation("Level","=",val1,val2)
		return ""
	end)

	-- support old level searches: "=24" "<25" ">11" etc for one number
	text = text:gsub("%s?[><=]=?%d+%s?",function(range)
		local operator, val1 = range:match("([><=]?=?)(%d+)")
		roster:FillStatOperation("Level",operator,val1,"")
		return "" -- remove these too
	end)

	if text:match("%S") then
		return text -- if any non-spaces remaining, return remainder
	else
		return nil -- only spaces left in remainder, return nil
	end
end

-- for parsing search text, populates roster.searchStatRanges with a stat's range
-- based on its operation: level<=24 speed=250-350, etc.
function roster:FillStatOperation(stat,operator,val1,val2)
	local ranges = roster.searchStatRanges
	local masks = roster.searchStatMasks
	if stat then
		stat = stat:lower()
		if masks[stat] and val1~="" then
			val1 = val1~="" and tonumber(val1)
			val2 = val2~="" and tonumber(val2)
			local key = masks[stat] -- translates to Level, Health, Power or Speed
			-- now fill in the ranges based on the operator used
			if operator=="=" and not val2 then -- stat=number
				ranges[key] = {val1,val1}
			elseif operator=="=" and type(val2)=="number" then -- stat=number-number
				ranges[key] = {val1,val2}
			elseif operator=="<" then
				ranges[key] = {0,val1-1}
			elseif operator=="<=" then
				ranges[key] = {0,val1}
			elseif operator==">" then
				ranges[key] = {val1+1,9999}
			elseif operator==">=" then
				ranges[key] = {val1,9999}
			end
		end
	end
end

--[[ Type Filter ]]

-- this function takes mode (1/nil=type, 2=strong, 3=tough) and sets that type to value.
-- it handles the brain-hurting reverse flags for normal types as well as clearing
-- the type when all types are enabled
function roster:SetTypeFilter(mode,index,value)
	if value==false then
		value = nil -- we use next(table) to quickly tell if a strong/tough filter is clear
	end
	if roster.typeFilter[mode] then
		-- if mode 2 or 3, just set its value
		roster.typeFilter[mode][index] = value
	else
		-- if mode 1 and all types aren't enabled, then set the individual type
		if not roster:IsTypeFilterClear() then
			C_PetJournal.SetPetTypeFilter(index,value)
		else -- if all types enabled, turn off all but the one we're enabling
			for i=1,10 do
				C_PetJournal.SetPetTypeFilter(i,i==index)
			end
		end
	end
	-- now go through and see if we just turned off last type for normal type, or
	-- turned on last type for strong/tough
	local missing
	for i=1,10 do
		if roster.typeFilter[mode] then
			missing = missing or not roster:GetTypeFilter(mode,i)
		else
			missing = missing or roster:GetTypeFilter(1,i)
		end
	end
	-- everything is now enabled, clear the filter
	if not missing then
		roster:ClearTypeFilter(mode)
	end
	roster:Updated()
end

function roster:GetTypeFilter(mode,index)
	if roster.typeFilter[mode] then
		return roster.typeFilter[mode][index]
	else
		return not C_PetJournal.IsPetTypeFiltered(index) -- note the not!
	end
end

function roster:IsTypeFilterClear(mode)
	if roster.typeFilter[mode] then
		return not next(roster.typeFilter[mode])
	else
		for i=1,10 do
			if C_PetJournal.IsPetTypeFiltered(i) then
				return false
			end
		end
		return true
	end
end

-- to prevent triggering an unnecessary PET_JOURNAL_LIST_UPDATE, add all pet types only if needed
function roster:ClearTypeFilter(mode)
	if roster.typeFilter[mode] then
		wipe(roster.typeFilter[mode])
	else
		for i=1,C_PetJournal.GetNumPetTypes() do
		  if C_PetJournal.IsPetTypeFiltered(i) then -- IsPetTypeFiltered returns true if it's unchecked
				C_PetJournal.AddAllPetTypesFilter() -- if anything unchecked, check them all
				break
		  end
		end
	end
	roster:Updated()
end

--[[ Sources Filter ]]

function roster:GetSourcesFilter(index)
	return not C_PetJournal.IsPetSourceFiltered(index)
end

function roster:SetSourcesFilter(index,value)
	if not roster:IsSourcesFilterClear() then
		C_PetJournal.SetPetSourceFilter(index,not value)
	else -- if all types enabled, turn off all but the one we're enabling
		for i=1,10 do
			C_PetJournal.SetPetSourceFilter(i,i==index)
		end
	end
	-- now go through and see if we just turned off last type for normal type, or
	-- turned on last type for strong/tough
	local missing
	for i=1,10 do
		missing = missing or roster:GetSourcesFilter(i)
	end
	-- everything is now enabled, clear the filter
	if not missing then
		roster:ClearSourcesFilter()
	end

end

function roster:IsSourcesFilterClear()
	for i=1,C_PetJournal.GetNumPetSources() do
		if C_PetJournal.IsPetSourceFiltered(i) then
			return false
		end
	end
	return true
end

function roster:ClearSourcesFilter()
	C_PetJournal.AddAllPetSourcesFilter()
end

--[[ Rarity Filter ]]

function roster:SetRarityFilter(rarity,value)
	if not value then value = nil end
	roster.rarityFilter[rarity] = value
	-- check if all rarities checked, if so wipe them all
	local filtered = 0
	for i=1,4 do
		filtered = filtered + (roster:GetRarityFilter(i) and 1 or 0)
	end
	if filtered==4 then
		for i=1,4 do
			roster.rarityFilter[i] = nil
		end
	end
	roster:Updated()
end

function roster:GetRarityFilter(rarity)
	return roster.rarityFilter[rarity]
end

function roster:IsRarityFilterClear()
	return not next(roster.rarityFilter)
end

function roster:ClearRarityFilter()
	wipe(roster.rarityFilter)
	roster:Updated()
end

--[[ Miscellaneous Filter ]]

-- the misc filters all act as radio buttons within small groups

function roster:SetMiscFilter(variable,value)
	local group = roster.miscGroups[variable]
	if group then
		for var,varGroup in pairs(roster.miscGroups) do
			if group==varGroup then
				roster.miscFilter[var] = nil
			end
		end
	end
	roster.miscFilter[variable] = value
	roster:Updated()
end

function roster:GetMiscFilter(variable)
	return roster.miscFilter[variable]
end

-- this should be an rmf function; only returns true if a misc filters other than favorite or currentzone are clear
function roster:IsMiscFilterClear()
	for var in pairs(roster.miscFilter) do
		if var~="Favorite" and var~="CurrentZone" then
			return false
		end
	end
	return true
end

function roster:ClearMiscFilter()
	wipe(roster.miscFilter)
	roster:Updated()
end

--[[ Filtering ]]

-- returns true if the speciesID has a petType we want to show
-- note that roster.abilityList should be populated before calling this
function roster:FilterPetType(speciesID,petType,mode)

	if mode==3 then
		for typeIndex in pairs(roster.typeFilter[3]) do
			if roster.toughTable[typeIndex] == petType then
				return true
			end
		end
	elseif mode==2 then
		for i=1,#roster.abilityList do
			local abilityType, noHints = select(7,C_PetBattles.GetAbilityInfoByID(roster.abilityList[i]))
			if not noHints then
				for typeIndex in pairs(roster.typeFilter[2]) do
					if roster.strongTable[typeIndex] == abilityType then
						return true
					end
				end
			end
		end
	else -- normal type
		return true -- we use all filtered pets for normal
	end

	return false
end

-- returns true if one of the passed parameters has a hit with the searchMask
-- it will also search abilities populated in roster.abilityList
function roster:FilterSearchText(...)

	for i=1,select("#",...) do
		local text = select(i,...)
		if text and text:match(roster.searchMask) then
			return true
		end
	end

	for i=1,#roster.abilityList do
		local _,name,_,_,description = C_PetBattles.GetAbilityInfoByID(roster.abilityList[i])
		if name:match(roster.searchMask) or description:match(roster.searchMask) then
			return true
		end
	end

end

-- returns the petID or speciesID if pet journal index should be listed in browser
-- if checkType is true, a test for type is also applied
-- if searchText is true, a test for searchMask is also applied
function roster:FilterPetByIndex(index,checkStrong,checkTough,checkRarity,checkStats,checkMisc)

	local maxHealth, power, speed, rarity, _ -- filled if GetPetStats needed
	local	petID, speciesID, owned, customName, level, favorite, _, speciesName, _, petType, _, source, description, isWild, canBattle, isTradable, _, obtainable = C_PetJournal.GetPetInfoByIndex(index)
	C_PetJournal.GetPetAbilityList(speciesID, roster.abilityList, roster.levelList)

	if not canBattle and RematchSettings.OnlyBattlePets then
		return false
	end

	-- check rarity if flag set
	if checkRarity then
		if petID and canBattle then
			_, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(petID)
			if not roster:GetRarityFilter(rarity) then
				return false
			end
		else
			return false
		end
	end

	if checkMisc then
		if roster:GetMiscFilter("Level25") and (not level or level<25) then
			return false
		end
		if roster:GetMiscFilter("Favorite") and not favorite then
			return false
		end
		if roster:GetMiscFilter("CurrentZone") then
			if not source or not source:match(roster.currentZone) then
				return false
			end
		end
		if roster:GetMiscFilter("Leveling") and not rematch:IsPetLeveling(petID) then
			return false
		end
		if roster:GetMiscFilter("NotLeveling") and rematch:IsPetLeveling(petID) then
			return false
		end
		if roster:GetMiscFilter("Tradable") and not isTradable then
			return false
		end
		if roster:GetMiscFilter("NotTradable") and isTradable then
			return false
		end
		if roster:GetMiscFilter("CanBattle") and not canBattle then
			return false
		end
		if roster:GetMiscFilter("CantBattle") and canBattle then
			return false
		end
		if roster:GetMiscFilter("None25") and rematch.ownedSpeciesAt25[speciesID] then
			return false
		end
		-- check for Qty1-3
		local qty = roster:GetMiscFilter("Qty1") and 1 or roster:GetMiscFilter("Qty2") and 2 or roster:GetMiscFilter("Qty3") and 3
		if qty then
			local count = C_PetJournal.GetNumCollectedInfo(speciesID)
			if not count then
				return false
			elseif qty==3 and count<3 then
				return false
			elseif qty==2 and count<2 then
				return false
			elseif qty==1 and count~=1 then
				return false
			end
		end
		-- check for InATeam or NotInATeam
		local inATeam = roster:GetMiscFilter("InATeam")
		local notInATeam = roster:GetMiscFilter("NotInATeam")
		if inATeam or notInATeam then
			if not owned then
				return false
			end
			local found
			for teamName,team in pairs(RematchSaved) do
				for i=1,3 do
					if petID==team[i][1] then
						if notInATeam then
							return false
						end
						found = true
						break
					end
				end
				if found then
					break -- don't need to look through rest of teams
				end
			end
			if not found and inATeam then
				return false
			end
		end

	end

	-- check tough types first since it's fastest check
	if checkTough then
		if not roster:FilterPetType(speciesID,petType,3) then
			return false
		end
	end
	if checkStrong then
		if not roster:FilterPetType(speciesID,petType,2) then
			return false
		end
	end

	-- check for level or stat ranges in roster.searchStatRanges
	if checkStats then
		if not petID or not canBattle then
			return
		end
		for stat,range in pairs(roster.searchStatRanges) do
			if stat=="Level" then
				if level<range[1] or level>range[2] then
					return false
				end
			else -- non-level stat, will need to GetPetStats if not done already
				if not maxHealth then
					_, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(petID)
				end
				if stat=="Speed" then
					if speed<range[1] or speed>range[2] then
						return false
					end
				elseif stat=="Health" then
					if maxHealth<range[1] or maxHealth>range[2] then
						return false
					end
				elseif stat=="Power" then
					if power<range[1] or power>range[2] then
						return false
					end
				end
			end
		end
	end

	-- if there's a legitimate text search string
	if roster.searchText then
		if not roster:FilterSearchText(customName,speciesName,source) then
			return false
		end
	end

	return petID or speciesID,favorite
end

--[[ Sorting ]]

-- NYI

--[[ filterResults ]]

function roster:GetFilterResults()
	local filters = L["Filters: \124cffffffff"]

	if roster.searchText or next(roster.searchStatRanges) then
		filters = filters..L["Search, "]
	end
	if not roster:IsTypeFilterClear() then
		filters = filters..L["Type, "]
	end
	if not roster:IsTypeFilterClear(2) then
		filters = filters..L["Strong, "]
	end
	if not roster:IsTypeFilterClear(3) then
		filters = filters..L["Tough, "]
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		if C_PetJournal.IsPetSourceFiltered(i) then
			filters = filters..L["Sources, "]
			break
		end
	end
	if not roster:IsRarityFilterClear() then
		filters = filters..L["Rarity, "]
	end
	if C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED) or C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED) then
		filters = filters..L["Collected, "]
	end
	for var,group in pairs(roster.miscGroups) do
		if roster:GetMiscFilter(var) then
			filters = filters..group..", "
		end
	end

	filters = filters:gsub(", $","")

	return (filters~=L["Filters: \124cffffffff"]) and filters
end

function roster:ClearAllFilters()
	rematch:ClearAllTypeFilters()
	roster:ClearRarityFilter()
	roster:SetSearch("")
	roster:ClearMiscFilter()
	C_PetJournal.AddAllPetSourcesFilter()
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED,true)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED,true)
end


-- this saves a snapshot of filters to be recalled later with roster:LoadFilters
-- used for both persistent filters across sessions and default filters
function roster:SaveFilters(filters)
	if type(filters)~="table" then
		return
	end
	-- save collected
	filters.collected = C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED)
	filters.notCollected = C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED)
	-- save types
	filters.types = {}
	for i=1,3 do
		if not roster:IsTypeFilterClear(i) then
			filters.types[i] = {}
			for j=1,10 do
				if i==1 then
					filters.types[i][j] = C_PetJournal.IsPetTypeFiltered(j)
				else
					filters.types[i][j] = roster.typeFilter[i][j]
				end
			end
		end
	end
	-- save sources
	for i=1,C_PetJournal.GetNumPetSources() do
		if C_PetJournal.IsPetSourceFiltered(i) then
			filters.sources = filters.sources or {}
			filters.sources[i] = true
		end
	end
	-- save misc
	if next(roster.miscFilter) then
		filters.misc = {}
		for k,v in pairs(roster.miscGroups) do
			filters.misc[k] = roster.miscFilter[k]
		end
	end
	-- save rarities
	if not roster:IsRarityFilterClear() then
		filters.rarities = {}
		for i=1,4 do
			filters.rarities[i] = roster.rarityFilter[i]
		end
	end
	-- save sort
	filters.sorting = C_PetJournal.GetPetSortParameter()
end

function roster:LoadFilters(filters)
	if type(filters)~="table" then
		return
	end
	-- load collected
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, not filters.collected)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, not filters.notCollected)
	-- load types
	for i=1,3 do
		if not filters.types[i] then
			if i==1 then
				C_PetJournal.AddAllPetTypesFilter()
			else
				wipe(roster.typeFilter[i])
			end
		else
			for j=1,10 do
				if i==1 then
					C_PetJournal.SetPetTypeFilter(j,not filters.types[i][j])
				else
					roster.typeFilter[i][j] = filters.types[i][j]
				end
			end
		end
	end
	-- load collected
	if not filters.sources then
		C_PetJournal.AddAllPetSourcesFilter()
	else
		for i=1,C_PetJournal.GetNumPetSources() do
			C_PetJournal.SetPetSourceFilter(i,not filters.sources[i])
		end
	end
	-- load misc
	wipe(roster.miscFilter)
	if filters.misc then
		for k,v in pairs(filters.misc) do
			roster.miscFilter[k] = v
		end
	end
	-- load rarities
	wipe(roster.rarityFilter)
	if filters.rarities then
		for i=1,4 do
			roster.rarityFilter[i] = filters.rarities[i]
		end
	end
	-- load sort
	C_PetJournal.SetPetSortParameter(filters.sorting)
	roster:Updated()
end
