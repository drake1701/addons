--[[
Written by: Hugh@Burning Blade-US and Simca@Malfurion-US

Special thanks to Nullberri, Ro, and Warla for helping at various points throughout the addon's development.
]]--

--GLOBALS: BPBID_Options, GetBreedID_Battle, GetBreedID_Journal, SLASH_BATTLEPETBREEDID1, SLASH_BATTLEPETBREEDID2, SLASH_BATTLEPETBREEDID3

--[[v1.0.4 Minor Update
ADDED new option BPBID_Options.BattleFontFix - when checked, attempts to fix "no rarity display" bug
maybe FIXED bug where a pet with an unknown rarity (bad Blizzard item links... sigh) could be determined to be epic
UPDATED breed possibilities (Living Sandling, Carp, and Pandas)
]]--

GetAreaID = GetCurrentMapAreaID

-- get folder path and set addon namespace
local addonname, BPBID = ...

-- these global tables are used everywhere in the code and are absolutely required
local CPB = _G.C_PetBattles
local CPJ = _G.C_PetJournal

-- these basic lua functions are used in the calculating of breed IDs and must be localized due to the number and frequency of uses
local min = math.min
local abs = math.abs
local floor = math.floor
local gsub = gsub

-- these basic lua functions are used for Retrieving Breed Names
-- they're only used once but still important to localize due to the time sensitive nature of the task
local tostring = tostring
local tonumber = tonumber
local sub = string.sub

-- declare addon-wide arrays
BPBID.BasePetStats = {}
BPBID.BreedStats = {}
BPBID.BreedsPerSpecies = {}

-- declare addon-wide cache variables
BPBID.cacheTime = true
BPBID.breedCache = {}
BPBID.speciesCache = {}
BPBID.resultsCache = {}
BPBID.rarityCache = {}

-- message filter cache
BPBID.messagefilters = {}
local lastfilter = 0
local MAX_FILTERS = 30 -- constant

-- forward declaration of some simple hook status-check booleans
local PJHooked = false
BPBID.messagefiltercheck = false

-- takes in lots of information, returns Breed ID as a number (or an error), and the rarity as a number
function BPBID.CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, wild, flying)
	
	-- abandon ship! (if missing inputs)
	if (not nSpeciesID) or (not nQuality) or (not nMaxHP) or (not nPower) or (not nSpeed) then return "ERR" end
	
	-- arrays are now initialized
	if (not BPBID.BasePetStats[39]) then BPBID.InitializeArrays() end
	
	local breedID, nQL, minQuality, maxQuality
	
	-- due to a Blizzard bug, some pets from tooltips will have quality = 0. this means we don't know what the quality is.
	-- so, we'll just test them all by adding another loop for rarity.
	if (nQuality < 1) or (nQuality > 4) then
		nQuality = 2
		minQuality = 1
		maxQuality = 4
	else
		minQuality = nQuality
		maxQuality = nQuality
	end
	
	-- end here and return "NEW" if species is new to the game (has unknown base stats)
	if not BPBID.BasePetStats[nSpeciesID] then
		if ((BPBID_Options.Debug) and (not CPB.IsInBattle())) then
			print("Species " .. nSpeciesID .. " is completely unknown.")
		end
		return "NEW", nQuality, {"NEW"}
	end
	
	-- localize base species stats and upconvert to avoid floating point errors (Blizzard could learn from this)
	local ihp = BPBID.BasePetStats[nSpeciesID][1] * 10
	local ipower = BPBID.BasePetStats[nSpeciesID][2] * 10
	local ispeed = BPBID.BasePetStats[nSpeciesID][3] * 10
	
	-- account for wild pet hp
	local wildfactor = 1
	if wild then wildfactor = 1.2 end
	
	-- upconvert to avoid floating point errors
	local thp = nMaxHP * 100
	local tpower = nPower * 100
	local tspeed = nSpeed * 100
	
	-- account for flying pet passive
	if flying then tspeed = tspeed / 1.5 end
	
	local trueresults = {}
	local lowest
	for i = minQuality, maxQuality do -- accounting for BlizzBug with rarity
		nQL = (i + 9) * nLevel
		
		-- higher level pets can never have duplicate breeds, so calculations can be less accurate and faster (they remain the same since version 0.7)
		if (nLevel > 2) then
		
			-- calculate diffs
			local diff3 = abs(((ihp + 5) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 5) * nQL) - tpower) + abs(((ispeed + 5) * nQL) - tspeed)
			local diff4 = abs((ihp * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 20) * nQL) - tpower) + abs((ispeed * nQL) - tspeed)
			local diff5 = abs((ihp * nQL * 5 + 10000) / wildfactor - thp) + abs((ipower * nQL) - tpower) + abs(((ispeed + 20) * nQL) - tspeed)
			local diff6 = abs(((ihp + 20) * nQL * 5 + 10000) / wildfactor - thp) + abs((ipower * nQL) - tpower) + abs((ispeed * nQL) - tspeed)
			local diff7 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs((ispeed * nQL) - tspeed)
			local diff8 = abs((ihp * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
			local diff9 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs((ipower * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
			local diff10 = abs(((ihp + 4) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs(((ispeed + 4) * nQL) - tspeed)
			local diff11 = abs(((ihp + 4) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 4) * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
			local diff12 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 4) * nQL) - tpower) + abs(((ispeed + 4) * nQL) - tspeed)
			
			-- calculate min diff
			local current = min(diff3, diff4, diff5, diff6, diff7, diff8, diff9, diff10, diff11, diff12)
			
			if not lowest or current < lowest then
				lowest = current
				nQuality = i
				
				-- determine breed from min diff
				if (lowest == diff3) then breedID = 3
				elseif (lowest == diff4) then breedID = 4
				elseif (lowest == diff5) then breedID = 5
				elseif (lowest == diff6) then breedID = 6
				elseif (lowest == diff7) then breedID = 7
				elseif (lowest == diff8) then breedID = 8
				elseif (lowest == diff9) then breedID = 9
				elseif (lowest == diff10) then breedID = 10
				elseif (lowest == diff11) then breedID = 11
				elseif (lowest == diff12) then breedID = 12
				else return "ERR-MIN", -1, {"ERR-MIN"} -- should be impossible (keeping for debug)
				end
				
				trueresults[1] = breedID
			end
		
		-- lowbie pets go here, the bane of my existance. calculations must be intense and logic loops numerous
		else
			
			-- calculate diffs much more intensely. Round calculations with 10^-2 and math.floor. Also, properly devalue HP by dividing its absolute value by 5
			local diff3 = (abs((floor(((ihp + 5) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 5) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 5) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff4 = (abs((floor((ihp * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 20) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( (ispeed * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff5 = (abs((floor((ihp * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( (ipower * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 20) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff6 = (abs((floor(((ihp + 20) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( (ipower * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( (ispeed * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff7 = (abs((floor(((ihp + 9) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 9) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( (ispeed * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff8 = (abs((floor((ihp * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 9) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 9) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff9 = (abs((floor(((ihp + 9) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( (ipower * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 9) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff10 = (abs((floor(((ihp + 4) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 9) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 4) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff11 = (abs((floor(((ihp + 4) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 4) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 9) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			local diff12 = (abs((floor(((ihp + 9) * nQL * 5 + 10000) / wildfactor * 0.01 + 0.5) / 0.01) - thp) / 5) + abs((floor( ((ipower + 4) * nQL) * 0.01 + 0.5) / 0.01) - tpower) + abs((floor( ((ispeed + 4) * nQL) * 0.01 + 0.5) / 0.01) - tspeed)
			
			-- use custom replacement code for math.min to find duplicate breed possibilities
			local numberlist = { diff3, diff4, diff5, diff6, diff7, diff8, diff9, diff10, diff11, diff12 }
			local secondnumberlist = {}
			local resultslist = {}
			local numResults = 0
			local smallest
			
			-- if we know the breeds for species, use this series of logic statements to eliminate impossible breeds
			if (BPBID.BreedsPerSpecies[nSpeciesID] and BPBID.BreedsPerSpecies[nSpeciesID][1]) then
				
				-- this half of the table stores the diffs for the breeds that passed inspection 
				secondnumberlist[1] = {}
				-- this half of the table stores the number corresponding to the breeds that passed inspection since we can no longer rely on the index
				secondnumberlist[2] = {}
				
				-- "inspection" time! if the breed is not found in the array, it doesn't get passed on to secondnumberlist and is effectively discarded
				for q = 1, #BPBID.BreedsPerSpecies[nSpeciesID] do
					local currentbreed = BPBID.BreedsPerSpecies[nSpeciesID][q]
					-- subtracting 2 from the breed to use it as an index (scale of 3-13 becomes 1-10)
					secondnumberlist[1][q] = numberlist[currentbreed - 2]
					secondnumberlist[2][q] = currentbreed
				end
				
				-- find the smallest number out of the breeds left
				for x = 1, #secondnumberlist[2] do
					-- if this breed is the closest to perfect we've seen, make it our only result (destroy all other results)
					if (not smallest) or (secondnumberlist[1][x] < smallest) then 
						smallest = secondnumberlist[1][x]
						numResults = 1
						resultslist = {}
						resultslist[1] = secondnumberlist[2][x]
					-- if we find a duplicate, add it to the list (but it can still be destroyed if better is found)
					elseif (secondnumberlist[1][x] == smallest) then
						numResults = numResults + 1
						resultslist[numResults] = secondnumberlist[2][x]
					end
				end
			
			-- if we don't know the species, use this series of logic statements to consider all possibilities
			else
				for y = 1, #numberlist do
					-- if this breed is the closest to perfect we've seen, make it our only result (destroy all other results)
					if (not smallest) or (numberlist[y] < smallest) then 
						smallest = numberlist[y]
						numResults = 1
						resultslist = {}
						resultslist[1] = y + 2
					-- if we find a duplicate, add it to the list (but it can still be destroyed if better is found)
					elseif (numberlist[y] == smallest) then
						numResults = numResults + 1
						resultslist[numResults] = y + 2
					end
				end
			end
			
			-- check to see if this is the smallest value reported out of all qualities (or if the quality is not in question)
			if not lowest or smallest < lowest then
				lowest = smallest
				nQuality = i
				
				trueresults = resultslist
				
				-- set breedID to best suited breed (or ??? if matching breeds) (or ERR-BMN if error)
				if resultslist[2] then
					breedID = "???"
				elseif resultslist[1] then
					breedID = resultslist[1]
				else
					return "ERR-BMN", -1, {"ERR-BMN"} -- should be impossible (keeping for debug)
				end
				
				-- if something is perfectly accurate, there is no need to continue (obviously)
				if (smallest == 0) then break end
			end
		end
	end
	
	-- debug section (to enable, you must manually set this value in-game using "/run BPBID_Options.Debug = true")
	if (BPBID_Options.Debug) and (not CPB.IsInBattle()) then
		if not (BPBID.BreedsPerSpecies[nSpeciesID]) then
			print("Species " .. nSpeciesID .. ": Possible breeds unknown. Current Breed is " .. breedID .. ".")
		elseif (breedID ~= "???") then
			local exists = false
			for i = 1, #BPBID.BreedsPerSpecies[nSpeciesID] do
				if (BPBID.BreedsPerSpecies[nSpeciesID][i] == breedID) then exists = true end
			end
			if not (exists) then
				print("Species " .. nSpeciesID .. ": Current breed is outside the range of possible breeds. Current Breed is " .. breedID .. ".")
			end
		end
	end
	
	-- return breed (or error)
	if breedID then
		return breedID, nQuality, trueresults
	else
		return "ERR-CAL", -1, {"ERR-CAL"} -- should be impossible (keeping for debug)
	end
end

-- match breedID to name, second number, double letter code (S/S), entire base+breed stats, or just base stats
function BPBID.RetrieveBreedName(breedID)
	-- exit if no breedID found
	if not breedID then return "ERR-ELY" end -- should be impossible (keeping for debug)
	
	-- exit if error message found
	if (sub(tostring(breedID), 1, 3) == "ERR") or (tostring(breedID) == "???") or (tostring(breedID) == "NEW") then return breedID end
	
	local numberBreed = tonumber(breedID)
	
	if (BPBID_Options.format == 1) then -- return single number
		return numberBreed
	elseif (BPBID_Options.format == 2) then -- return two numbers
		return numberBreed .. "/" .. numberBreed + 10
	else -- select correct letter breed
		if (numberBreed == 3) then
			return "B/B"
		elseif (numberBreed == 4) then
			return "P/P"
		elseif (numberBreed == 5) then
			return "S/S"
		elseif (numberBreed == 6) then
			return "H/H"
		elseif (numberBreed == 7) then
			return "H/P"
		elseif (numberBreed == 8) then
			return "P/S"
		elseif (numberBreed == 9) then
			return "H/S"
		elseif (numberBreed == 10) then
			return "P/B"
		elseif (numberBreed == 11) then
			return "S/B"
		elseif (numberBreed == 12) then
			return "H/B"
		else
			return "ERR-NAM" -- should be impossible (keeping for debug)
		end
	end
end

-- get information from pet journal and pass to calculation function
function GetBreedID_Journal(nPetID)
	if (nPetID) then
		-- get information from pet journal
		local nHealth, nMaxHP, nPower, nSpeed, nQuality = CPJ.GetPetStats(nPetID)
		local nSpeciesID, _, nLevel = CPJ.GetPetInfoByPetID(nPetID);
		
		-- pass to calculation function and then retrieve breed name
		return BPBID.RetrieveBreedName(BPBID.CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, false, false))
	else
		return "ERR-PID" -- should be impossible unless another addon calls it wrong (keeping for debug)
	end
end

-- retrieve pre-determined Breed ID from cache for pet being moused over
function GetBreedID_Battle(self)
	if (self) then
		-- determine index of BPBID.breedCache array. accepted values are 1-6 with 1-3 being your pets and 4-6 being enemy pets
		local offset = 0
		if (self.petOwner == 2) then offset = 3 end
		
		-- get name for cached breedID/speciesID
		return BPBID.RetrieveBreedName(BPBID.breedCache[self.petIndex + offset])
	else
		return "ERR_SLF" -- should be impossible unless another addon calls it wrong (keeping for debug)
	end
end

-- get pet stats and breed at the start of battle before values change
function BPBID.CacheAllPets()
	for iOwner = 1, 2 do
		local IndexMax = CPB.GetNumPets(iOwner)
		for iIndex = 1, IndexMax do
			local nSpeciesID = CPB.GetPetSpeciesID(iOwner, iIndex)
			local nLevel = CPB.GetLevel(iOwner, iIndex)
			local nMaxHP = CPB.GetMaxHealth(iOwner, iIndex)
			local nPower = CPB.GetPower(iOwner, iIndex)
			local nSpeed = CPB.GetSpeed(iOwner, iIndex)
			local nQuality = CPB.GetBreedQuality(iOwner, iIndex)
			local wild = false
			local flying = false
			
			-- if pet is wild, add 20% hp to get the normal stat
			if (CPB.IsWildBattle() and iOwner == 2) then wild = true end
			
			-- still have to account for flying passive apparently; can't get the stats snapshot before passive is applied
			if (CPB.GetPetType(iOwner, iIndex) == 3) then
				if (iOwner == 1) and ((CPB.GetHealth(iOwner, iIndex) / nMaxHP) > .5) then
					flying = true
				elseif (iOwner == 2) then
					flying = true
				end
			end
			
			-- determine index of Cache arrays. accepted values are 1-6 with 1-3 being your pets and 4-6 being enemy pets
			local offset = 0
			if (iOwner == 2) then offset = 3 end
			
			-- calculate breedID and store it in cache along with speciesID
			local breed, _, resultslist = BPBID.CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, wild, flying)
			BPBID.breedCache[iIndex + offset] = breed
			BPBID.resultsCache[iIndex + offset] = resultslist
			BPBID.speciesCache[iIndex + offset] = nSpeciesID
			BPBID.rarityCache[iIndex + offset] = nQuality
			
			-- debug section (to enable, you must manually set this value in-game using "/run BPBID_Options.Debug = true")
			if (BPBID_Options.Debug) then
				
				-- checking for new pets or pets without breed data
				if (breed == "NEW") or (not BPBID.BreedsPerSpecies[nSpeciesID]) then
					local wildnum, flyingnum = 1, 1
					if wild then wildnum = 1.2 end
					if flying then flyingnum = 1.5 end
					print(string.format("NEW Species found; Owner #%i, Pet #%i, SpeciesID %u, Base Stats %4.2f / %4.2f / %4.2f", iOwner, iIndex, nSpeciesID, ((nMaxHP * wildnum - 100) / 5) / (nLevel * (1 + (0.1 * (nQuality - 1)))), nPower / (nLevel * (1 + (0.1 * (nQuality - 1)))), (nSpeed / flyingnum) / (nLevel * (1 + (0.1 * (nQuality - 1))))))
					if (breed ~= "NEW") then SELECTED_CHAT_FRAME:AddMessage("NEW Breed found: " .. breed) end
				elseif (breed ~= "???") and (sub(tostring(breedID), 1, 3) ~= "ERR") then
					local exists = false
					for i = 1, #BPBID.BreedsPerSpecies[nSpeciesID] do
						if (BPBID.BreedsPerSpecies[nSpeciesID][i] == breed) then exists = true end
					end
					if not (exists) then
						local wildnum, flyingnum = 1, 1
						if wild then wildnum = 1.2 end
						if flying then flyingnum = 1.5 end
						print(string.format("Error - Breed does not match known breeds; Owner #%i, Pet #%i, SpeciesID %u, Base Stats %4.2f / %4.2f / %4.2f, Breed %s", iOwner, iIndex, nSpeciesID, ((nMaxHP * wildnum - 100) / 5) / (nLevel * (1 + (0.1 * (nQuality - 1)))), nPower / (nLevel * (1 + (0.1 * (nQuality - 1)))), (nSpeed / flyingnum) / (nLevel * (1 + (0.1 * (nQuality - 1)))), breed))
					end
				end
				
				-- checking if genders will ever be fixed
				if (CPB.GetStateValue(iOwner, iIndex, 78) ~= 0) then
					print("HOLY !@#$ GENDERS ARE WORKING! This pet's gender is " .. CPB.GetStateValue(iOwner, iIndex, 78))
				end
			end
		end
	end
end

-- chat filter to fix messages
function BPBID.BlizzBugChatFilter(self, event, msg, ...)
	
	-- store msg before changes
	local fixedmsg = gsub(msg, "|", "\124")
	
	-- cycle through all message filters (up to 3 at a time) replacing bugged links with fixed links
	for i = 1, #BPBID.messagefilters do
		fixedmsg = gsub(fixedmsg, BPBID.messagefilters[i].bugged, BPBID.messagefilters[i].real)
	end
	
	-- pass fixed message on to the next filter or chat window
	return false, fixedmsg, ...
end

-- hook to deconstruct messages, set up chat filter, and store bug fixes in cache
local function BPBID_Hook_ChatEdit_InsertLink(link)
	-- exit if no link found
	if (not link) then return end
	
	-- return if not a battle pet link OR if the user doesn't want us helping
	if (not strmatch(tostring(link), "|Hbattlepet:")) or (not BPBID_Options.BlizzBugChat) then return end
	
	-- store link before changes
	local petlink = link
	
	-- gsub link
	local sublink = " " .. gsub(petlink, "|", ":")
	
	-- split link
	local space, color, linktype, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID, name, h, r = strsplit(":", sublink)
	
	-- stop now if rarity bug has not occured
	if (tonumber(breedQuality) ~= -1) then return end
	
	-- set chat functions
	if (not BPBID.messagefiltercheck) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", BPBID.BlizzBugChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", BPBID.BlizzBugChatFilter)
		BPBID.messagefiltercheck = true
	end
	
	-- find current filter
	if (lastfilter == MAX_FILTERS) then
		lastfilter = 1
	else
		lastfilter = lastfilter + 1
	end
	
	-- find real rarity if possible
	local _, _, _, _, rarity = CPJ.GetPetStats(battlePetID)
	rarity = rarity - 1
	
	-- fix color
	color = ITEM_QUALITY_COLORS[rarity].hex
	
	-- assemble fixed link
	local fixedlink = color .. "\124" .. linktype .. ":" .. speciesID .. ":" .. level .. ":" .. rarity .. ":" .. maxHealth .. ":" .. power .. ":" .. speed .. ":" .. battlePetID .. "\124" .. name .. "\124" .. h .. "\124" .. r 
	
	-- create table if missing
	if not BPBID.messagefilters[lastfilter] then BPBID.messagefilters[lastfilter] = {} end
	
	-- set bugged and real
	BPBID.messagefilters[lastfilter].bugged = gsub(gsub(gsub(gsub(gsub(petlink, "|", "\124"), "%-", "%%%-"), "%[", "%%%["), "%]", "%%%]"), "%.", "%%%.")
	BPBID.messagefilters[lastfilter].real = gsub(gsub(gsub(gsub(fixedlink, "%-", "%%%-"), "%[", "%%%["), "%]", "%%%]"), "%.", "%%%.")
end

-- display breed on PetJournal's ScrollFrame
local function BPBID_Hook_HSFUpdate(scrollFrame)
	-- safety check AND make sure the user wants us here
	if (not ((scrollFrame == PetJournalListScrollFrame) or (scrollFrame == PetJournalEnhancedListScrollFrame))) or (not PetJournal:IsShown()) or (not BPBID_Options.Names.HSFUpdate) then return end
	
	-- loop for all shown buttons
	for i = 1, #scrollFrame.buttons do
		
		-- set specifics for this button
		local thisPet = scrollFrame.buttons[i]
		local petID = thisPet.petID
		
		-- assure petID is not bogus
		if (petID ~= nil) then
			
			-- get pet name to assure petID is not bogus
			local _, customName, _, _, _, _, _, name = CPJ.GetPetInfoByPetID(petID)
			if (name) then
				
				-- get pet hex color
				local _, _, _, _, rarity = CPJ.GetPetStats(petID)
				local hex = ITEM_QUALITY_COLORS[rarity - 1].hex
				
				-- FONT DOWNSIZING ROUTINE HERE COULD USE SOME WORK
				
				-- if user doesn't want rarity coloring then use default
				if (not BPBID_Options.Names.HSFUpdateRarity) then hex = "|cffffd100" end
					
				-- display breed as part of the nickname if the pet has one, otherwise use the real name
				if (customName) then
					thisPet.name:SetText(hex..customName.." ("..GetBreedID_Journal(petID)..")".."|r")
					thisPet.subName:Show()
					thisPet.subName:SetText(name)
				else
					thisPet.name:SetText(hex..name.." ("..GetBreedID_Journal(petID)..")".."|r")
					thisPet.subName:Hide()
				end
				
				-- downside font if the name/breed gets chopped off
				if (thisPet.name:IsTruncated()) then
					thisPet.name:SetFontObject("GameFontNormalSmall")
				else
					thisPet.name:SetFontObject("GameFontNormal")
				end
			end
		end
	end
end

-- create event handling frame and register event(s)
local BPBID_Events = CreateFrame("FRAME", "BPBID_Events")
BPBID_Events:RegisterEvent("ADDON_LOADED")
BPBID_Events:RegisterEvent("PLAYER_LOGIN")
BPBID_Events:RegisterEvent("PLAYER_CONTROL_LOST")
BPBID_Events:RegisterEvent("PET_BATTLE_OPENING_START")
BPBID_Events:RegisterEvent("PET_BATTLE_CLOSE")

-- OnEvent handler function
local function BPBID_Events_OnEvent(self, event, name, ...)
	if (event == "ADDON_LOADED") and (name == addonname) then
		-- create saved variables if missing
		if (not BPBID_Options) then
			BPBID_Options = {}
		end
		
		-- otherwise, none exists at all, so set to default
		if (not BPBID_Options.format) then
			BPBID_Options.format = 3
		end
		
		-- if the obsolete format choices exist, update them to defaults
		if (BPBID_Options.format == 4) or (BPBID_Options.format == 5) or (BPBID_Options.format == 6) then BPBID_Options.format = 3 end
		
		-- set the rest of the defaults
		if not (BPBID_Options.Names) then
			BPBID_Options.Names = {}
			BPBID_Options.Names.PrimaryBattle = true -- In Battle (on primary pets for both owners)
			BPBID_Options.Names.BattleTooltip = true -- In PrimaryBattlePetUnitTooltip's header (in-battle tooltips)
			BPBID_Options.Names.BPT = true -- In BattlePetTooltip's header (items)
			BPBID_Options.Names.FBPT = true -- In FloatingBattlePetTooltip's header (chat links)
			BPBID_Options.Names.HSFUpdate = true -- In the Pet Journal scrolling frame
			BPBID_Options.Names.HSFUpdateRarity = true
			BPBID_Options.Names.PJT = true -- In the Pet Journal tooltip header
			BPBID_Options.Names.PJTRarity = false -- Color Pet Journal tooltip headers by rarity
			--BPBID_Options.Names.PetBattleTeams = true -- In the Pet Battle Teams window
			
			BPBID_Options.Tooltips = {}
			BPBID_Options.Tooltips.Enabled = true -- Enable Battle Pet BreedID Tooltips
			BPBID_Options.Tooltips.BattleTooltip = true -- In Battle (PrimaryBattlePetUnitTooltip)
			BPBID_Options.Tooltips.BPT = true -- On Items (BattlePetTooltip)
			BPBID_Options.Tooltips.FBPT = true -- On Chat Links (FloatingBattlePetTooltip)
			BPBID_Options.Tooltips.PJT = true -- In the Pet Journal (GameTooltip)
			--BPBID_Options.Tooltips.PetBattleTeams = true -- In Pet Battle Teams (PetBattleTeamsTooltip)
			
			BPBID_Options.Breedtip = {}
			BPBID_Options.Breedtip.Current = true -- Current pet's breed
			BPBID_Options.Breedtip.Possible = true -- Current pet's possible breeds
			BPBID_Options.Breedtip.SpeciesBase = false -- Pet species' base stats
			BPBID_Options.Breedtip.CurrentStats = false -- Current breed's base stats (level 1 Poor)
			BPBID_Options.Breedtip.AllStats = false -- All breed's base stats (level 1 Poor)
			BPBID_Options.Breedtip.CurrentStats25 = true -- Current breed's stats at level 25
			BPBID_Options.Breedtip.CurrentStats25Rare = true -- Always assume pet will be Rare at level 25
			BPBID_Options.Breedtip.AllStats25 = true -- All breeds' stats at level 25
			BPBID_Options.Breedtip.AllStats25Rare = true -- Always assume pet will be Rare at level 25
			
			BPBID_Options.BlizzBugChat = true
			BPBID_Options.BlizzBugTooltip = true -- Fix Blizzard Chat Link Tooltip Rarity bug
			BPBID_Options.BattleFontFix = false
		end
		
		-- set new defaults added in v1.0.1
		if (BPBID_Options.Names.HSFUpdateRarity == nil) then
			BPBID_Options.BlizzBugChat = true
			
			-- set BPBID_Options.Names.HSFUpdateRarity to defaults unless its parent is unchecked
			if (BPBID_Options.Names.HSFUpdate) then
				BPBID_Options.Names.HSFUpdateRarity = true
			else
				BPBID_Options.Names.HSFUpdateRarity = false
			end
		end
		
		-- set new default added in v1.0.4
		if (BPBID_Options.BattleFontFix == nil) then
			BPBID_Options.BattleFontFix = false
		end
		
		-- if this addon loads after the Pet Journal
		if (PetJournalPetCardPetInfo) then
			
			-- hook into the OnEnter script for the frame that calls GameTooltip in the Pet Journal
			PetJournalPetCardPetInfo:HookScript("OnEnter", BPBID.Hook_PJTEnter)
			PetJournalPetCardPetInfo:HookScript("OnLeave", BPBID.Hook_PJTLeave)
				
			-- set boolean
			PJHooked = true
		end
		
		-- if this addon loads after ArkInventory
		if (ArkInventory) and (ArkInventory.TooltipSetBattlepet) then
			
			-- hook ArkInventory's Battle Pet tooltips
			hooksecurefunc(ArkInventory, "TooltipSetBattlepet", BPBID.Hook_ArkInventory)
		end
	elseif (event == "ADDON_LOADED") and (name == "Blizzard_PetJournal") then
		-- if the Pet Journal loads on demand correctly (when the player opens it)
		if (PetJournalPetCardPetInfo) then
			
			-- hook into the OnEnter script for the frame that calls GameTooltip in the Pet Journal
			PetJournalPetCardPetInfo:HookScript("OnEnter", BPBID.Hook_PJTEnter)
			PetJournalPetCardPetInfo:HookScript("OnLeave", BPBID.Hook_PJTLeave)
			
			-- set boolean
			PJHooked = true
		end
	elseif (event == "ADDON_LOADED") and (name == "ArkInventory") then	
		-- if this addon loads before ArkInventory
		if (ArkInventory) and (ArkInventory.TooltipSetBattlepet) then
			
			-- hook ArkInventory's Battle Pet tooltips
			hooksecurefunc(ArkInventory, "TooltipSetBattlepet", BPBID.Hook_ArkInventory)
		end
	elseif (event == "PLAYER_LOGIN") then
		-- hook PJ PetCard here
		if (PetJournalPetCardPetInfo) and (not PJHooked) then
			
			-- hook into the OnEnter script for the frame that calls GameTooltip in the Pet Journal
			PetJournalPetCardPetInfo:HookScript("OnEnter", BPBID.Hook_PJTEnter)
			PetJournalPetCardPetInfo:HookScript("OnLeave", BPBID.Hook_PJTLeave)
			
			-- set boolean
			PJHooked = true
		end
		
		-- check for presence of LibStub (pretty messy)
		if _G["LibStub"] then
			
			-- access LibStub
			BPBID.LibStub = _G["LibStub"]
			
			-- attempt to access LibExtraTip
			BPBID.LibExtraTip = BPBID.LibStub("LibExtraTip-1", true)
		end
	elseif (event == "PLAYER_CONTROL_LOST") then
		
		-- set this boolean so BPBID.CacheAllPets() will fire
		BPBID.cacheTime = true
	elseif (event == "PET_BATTLE_OPENING_START") then
		
		-- set this boolean so BPBID.CacheAllPets() will fire
		BPBID.cacheTime = false
	elseif (event == "PET_BATTLE_CLOSE") then
		
		-- erase cache
		for i = 1, 6 do
			BPBID.breedCache[i] = 0
			BPBID.resultsCache[i] = false
			BPBID.speciesCache[i] = 0
			BPBID.rarityCache[i] = 0
		end
		
		-- set this boolean so BPBID.CacheAllPets() will fire
		BPBID.cacheTime = true
	end
end

-- set our event handler function
BPBID_Events:SetScript("OnEvent", BPBID_Events_OnEvent)

-- hook non-tooltip functions (almost all other hooks are in BreedTooltips.lua)
hooksecurefunc("HybridScrollFrame_Update", BPBID_Hook_HSFUpdate)
hooksecurefunc("ChatEdit_InsertLink", BPBID_Hook_ChatEdit_InsertLink)

-- create slash commands
SLASH_BATTLEPETBREEDID1 = "/battlepetbreedID"
SLASH_BATTLEPETBREEDID2 = "/BPBID"
SLASH_BATTLEPETBREEDID3 = "/breedID"
SlashCmdList["BATTLEPETBREEDID"] = function(message)
	-- lowercase message for evaluation
	local msg = string.lower(message)
	
	-- retain very limited chatline functionality to not disrupt users who were used to this
	if (msg == "1") or (msg == "onenumber") or (msg == "one number") or (msg == "1 number") or (msg == "1#") then -- set it to only show one number
		BPBID_Options.format = 1
	elseif (msg == "2") or (msg == "twonumber") or (msg == "two numbers") or (msg == "twonumbers") or (msg == "2 numbers") or (msg == "2numbers") then -- set it to show two numbers
		BPBID_Options.format = 2
	elseif (msg == "3") or (msg == "twoletter") or (msg == "two letter") or (msg == "two letters") or (msg == "twoletters") then -- set it to show two letters
		BPBID_Options.format = 3
	else
		-- more importantly, show options menu in other cases
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrameTab2:Click()
		
		local i = 1
		local currAddon = "InterfaceOptionsFrameAddOnsButton" .. i
		while _G[currAddon] do
			if (_G[currAddon]:GetText() == "Battle Pet BreedID") then _G[currAddon]:Click() break end
			i = i + 1
			currAddon = "InterfaceOptionsFrameAddOnsButton" .. i
		end
	end
end