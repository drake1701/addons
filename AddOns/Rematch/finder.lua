--[[
	This module was previously dedicated to finding the best petID for a species
	(to assign petIDs to missing pets if possible).  It will still serve that
	role but is now being expanded to track all owned pets all the time.

	Previously, a table of owned petIDs was only generated when it went to find
	a pet.  Now it will maintain that list at all times for use in other areas
	(counting unique pets, determining if user owns a 25 of species, etc).

	This adds about ~50k to the addon but will greatly improve capabilities.

	 rematch:FindBestPetID(speciesID[,otherthanPetID1,otherthanPetID2]) takes a
]]

local rematch = Rematch

rematch.ownedPets = {} -- petID of owned pets, sorted by level then rarity
rematch.ownedSpeciesAt25 = {} -- indexed by speciesID, species where the player has a level 25 pet

-- these flags/filters will be used to clear and revert flags
rematch.ownedFlags = {
	[LE_PET_JOURNAL_FLAG_COLLECTED]=true,
	[LE_PET_JOURNAL_FLAG_NOT_COLLECTED]=true
}
rematch.ownedFilters = { flags={}, types={}, sources={} }
rematch.ownedDefaultSearch = "" -- search text of default pet journal
rematch.ownedUpdating = nil -- true when updating owned pets

-- fills rematch.ownedPets with a list of all owned petIDs sorted by
-- descending level (and descending rarity)
function rematch:UpdateOwnedPets()

	-- this function *always* causes PJLU to fire in the next frame;
	-- since a PJLU can cause other addons to react with their own, we'll unregister
	-- rematch from the event for 0.1 seconds to ignore its consequences
	rematch:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")
	rematch.ownedUpdating = true
	rematch:StartTimer("UpdateOwnedBlackout",0.1,function() rematch:RegisterEvent("PET_JOURNAL_LIST_UPDATE") rematch.ownedUpdating=nil end)

	-- backup default filters (we don't touch roster at all)
	local filters = rematch.ownedFilters
	for flag in pairs(rematch.ownedFlags) do
		filters.flags[flag] = not C_PetJournal.IsFlagFiltered(flag)
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		filters.sources[i] = not C_PetJournal.IsPetSourceFiltered(i)
	end
	for i=1,C_PetJournal.GetNumPetTypes() do
		filters.types[i] = not C_PetJournal.IsPetTypeFiltered(i)
	end

	-- expand all filters so all pets are in journal
	C_PetJournal.ClearSearchFilter()
	for flag,value in pairs(rematch.ownedFlags) do
		C_PetJournal.SetFlagFilter(flag,value)
	end
	C_PetJournal.AddAllPetSourcesFilter()
	C_PetJournal.AddAllPetTypesFilter()

	-- fill ownedPets with all owned petIDs
	wipe(rematch.ownedPets)
	wipe(rematch.ownedSpeciesAt25) -- in case they cage any 25s
	for i=1,C_PetJournal.GetNumPets() do
		local petID,speciesID,_,_,level = C_PetJournal.GetPetInfoByIndex(i)
		if petID then
			tinsert(rematch.ownedPets,petID)
			if level==25 then
				rematch.ownedSpeciesAt25[speciesID] = true
			end
		end
	end

	-- restore filters to their backed-up state
	for flag in pairs(rematch.ownedFlags) do
		C_PetJournal.SetFlagFilter(flag,filters.flags[flag])
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		C_PetJournal.SetPetSourceFilter(i,filters.sources[i])
	end
	for i=1,C_PetJournal.GetNumPetTypes() do
		C_PetJournal.SetPetTypeFilter(i,filters.types[i])
	end
	C_PetJournal.SetSearchFilter(rematch.ownedDefaultSearch)

	-- now sort ownedPets by level/rarity
	local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
	local GetPetStats = C_PetJournal.GetPetStats
	table.sort(rematch.ownedPets,function(e1,e2)
		if e1 and not e2 then
			return true
		elseif e2 and not e1 then
			return false
		else
			local _,_,level1 = GetPetInfoByPetID(e1)
			local _,_,level2 = GetPetInfoByPetID(e2)
			if level1>level2 then -- level descending
				return true
			elseif level1<level2 then
				return false
			else -- levels are equal
				local _,_,_,_,rarity1 = GetPetStats(e1)
				local _,_,_,_,rarity2 = GetPetStats(e2)
				return rarity1>rarity2 -- rarity descending
			end
		end
	end)

end

-- finds best owned pet of speciesID that isn't pet1 or pet2 (if defined)
function rematch:FindBestPetID(speciesID,pet1,pet2)
	for i=1,#rematch.ownedPets do
		local petID = rematch.ownedPets[i]
		local candidateSpeciesID = C_PetJournal.GetPetInfoByPetID(petID)
		if candidateSpeciesID==speciesID and petID~=pet1 and petID~=pet2 and not C_PetJournal.PetIsRevoked(petID) then
			return petID
		end
	end
end

-- since there is no C_PetJournal.GetSearchFilter, we need to watch for it
hooksecurefunc(C_PetJournal,"SetSearchFilter",function(search)
	if not rematch.ownedUpdating then
		rematch.ownedDefaultSearch = search or ""
	end
end)
hooksecurefunc(C_PetJournal,"ClearSearchFilter",function(...)
	if not rematch.ownedUpdating then
		rematch.ownedDefaultSearch = ""
	end
end)
