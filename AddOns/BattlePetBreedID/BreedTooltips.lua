--[[
Written by: Hugh@Burning Blade-US and Simca@Malfurion-US

Special thanks to Ro for letting me bounce solutions off him regarding tooltip conflicts.
]]--

--GLOBALS: BPBID_Options

--[[ (have the "titles" stand out more than the 
Tooltip (what it will look like):
[Current Breed:] S/B
[Possible Breed(s):] B/B, S/S, P/S,
   H/S, S/B
[Species Base Stats:] 8/8/8
[Breed S/B Stats:] 8.5/8.5/8.5
(Optionally other breeds' stats at level 1 poor here too)
['[S/B at 25:]']
['['[B/B at 25:]']']
['['[S/S at 25:]']']
['['[P/S at 25:]']']
['['[H/S at 25:]']']
(Do not include existing breed in this list)

1 bracket = gold color
2 brackets = color of pet's rarity OR always rare (based on an option)
3 brackets = color of pet's rarity OR always rare (based on another option)
]]--

-- get folder path and set addon namespace
local addonname, BPBID = ...

-- the only localized functions needed here
local CPBGN = _G.C_PetBattles.GetName
local GPII = C_PetJournal.GetPetInfoByPetID
local GPIS = C_PetJournal.GetPetInfoBySpeciesID
local GPS = C_PetJournal.GetPetStats
local ceil = math.ceil

-- forward declaration of a potential tooltip conflict source
local extratip

-- this is the new Battle Pet BreedID "Breed Tooltip" creation and setup function
function BPBID_SetBreedTooltip(parent, speciesID, tblBreedID, rareness)
	
	-- impossible checks (if missing parent, speciesID, or "rareness")
	local rarity
	if (not parent) or (not speciesID) then return end
	if (rareness) then
		rarity = rareness
	else
		rarity = 3
	end
	
	-- set local reference to my tooltip or create it if it doesn't exist
	-- it inherits TooltipBorderedFrameTemplate AND GameTooltipTemplate to match Blizzard's "psuedo-tooltips" yet still make it easy to use 
	local breedtip = _G["BPBID_BreedTooltip"] or CreateFrame("GameTooltip", "BPBID_BreedTooltip", nil, "TooltipBorderedFrameTemplate,GameTooltipTemplate")
	
	-- check for existence of LibExtraTip and see if it has hooked our parent
	if (BPBID.LibExtraTip) and (BPBID.LibExtraTip.GetExtraTip) then extratip = BPBID.LibExtraTip:GetExtraTip(parent) end
	
	-- set positioning/parenting/ownership of Breed Tooltip
	if extratip then
		-- another addon has attached to our parent, we must adapt!
		breedtip:SetParent(extratip)
		breedtip:SetOwner(extratip, "ANCHOR_NONE")
		breedtip:SetPoint("TOPLEFT", extratip, "BOTTOMLEFT", 0, 2)
		breedtip:SetPoint("TOPRIGHT", extratip, "BOTTOMRIGHT", 0, 2)
	else
		-- we're good; attach to the tooltip normally
		breedtip:SetParent(parent)
		breedtip:SetOwner(parent, "ANCHOR_NONE")
		breedtip:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 2)
		breedtip:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, 2)
	end
	
	-- remove backdrop created as part of GameTooltipTemplate
	breedtip:SetBackdrop(nil)
	
	-- set line for "Current pet's breed"
	if (BPBID_Options.Breedtip.Current) and (tblBreedID) then
		local current = "\124cFFD4A017Current Breed:\124r "
		local largest = #tblBreedID
		for i = 1, largest do
			if (i == 1) then
				current = current .. BPBID.RetrieveBreedName(tblBreedID[i])
			elseif (i == 2) and (i == largest) then
				current = current .. " or " .. BPBID.RetrieveBreedName(tblBreedID[i])
			elseif (i == largest) then
				current = current .. ", or " .. BPBID.RetrieveBreedName(tblBreedID[i])
			else
				current = current .. ", " .. BPBID.RetrieveBreedName(tblBreedID[i])
			end
		end
		breedtip:AddLine(current, 1, 1, 1, 1)
	end
	
	-- set line for "Current pet's possible breeds"
	if (BPBID_Options.Breedtip.Possible) then
		local possible = "\124cFFD4A017Possible Breed"
		if (speciesID) and (BPBID.BreedsPerSpecies[speciesID]) then
			local largest = #BPBID.BreedsPerSpecies[speciesID]
			for i = 1, largest do
				if (largest == 1) then
					possible = possible .. ":\124r " .. BPBID.RetrieveBreedName(BPBID.BreedsPerSpecies[speciesID][i])
				elseif (i == 1) then
					possible = possible .. "s:\124r " .. BPBID.RetrieveBreedName(BPBID.BreedsPerSpecies[speciesID][i])
				elseif (i == 2) and (i == largest) then
					possible = possible .. " and " .. BPBID.RetrieveBreedName(BPBID.BreedsPerSpecies[speciesID][i])
				elseif (i == largest) then
					possible = possible .. ", and " .. BPBID.RetrieveBreedName(BPBID.BreedsPerSpecies[speciesID][i])
				else
					possible = possible .. ", " .. BPBID.RetrieveBreedName(BPBID.BreedsPerSpecies[speciesID][i])
				end
			end
		else
			possible = possible .. "s:\124r Unknown"
		end
		breedtip:AddLine(possible, 1, 1, 1, 1)
	end
	
	-- have to have BasePetStats from here on out
	if (BPBID.BasePetStats[speciesID]) then
		
		-- set line for "Pet species' base stats"
		if (BPBID_Options.Breedtip.SpeciesBase) then
			local speciesbase = "\124cFFD4A017Base Stats:\124r " .. BPBID.BasePetStats[speciesID][1] .. "/" .. BPBID.BasePetStats[speciesID][2] .. "/" .. BPBID.BasePetStats[speciesID][3]
			breedtip:AddLine(speciesbase, 1, 1, 1, 1)
		end
		
		local extrabreeds
		-- check duplicates (have to have BreedsPerSpecies and tblBreedID for this)
		if (BPBID.BreedsPerSpecies[speciesID]) and (tblBreedID) then
			extrabreeds = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
			-- "inspection" time! if the breed is not found in the array, it doesn't get passed on to extrabreeds and is effectively discarded
			for q = 1, #tblBreedID do
				for i = 1, #BPBID.BreedsPerSpecies[speciesID] do
					local j = BPBID.BreedsPerSpecies[speciesID][i]
					if (tblBreedID[q] == j) then extrabreeds[j - 2] = false end -- if the breed is found in both tables, flag it as false
					if (extrabreeds[j - 2]) then extrabreeds[j - 2] = j end
				end
			end
		end
			
		-- set line for "Current breed's base stats (level 1 Poor)" (have to have tblBreedID for this)
		if (BPBID_Options.Breedtip.CurrentStats) and (tblBreedID) then
			for i = 1, #tblBreedID do
				local currentbreed = tblBreedID[i]
				local currentstats = "\124cFFD4A017Breed " .. BPBID.RetrieveBreedName(currentbreed) .. "*:\124r " .. (BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) .. "/" .. (BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) .. "/" .. (BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3])
				breedtip:AddLine(currentstats, 1, 1, 1, 1)
			end
		end
			
		-- set line for "All breeds' base stats (level 1 Poor)" (have to have BreedsPerSpecies for this)
		if (BPBID_Options.Breedtip.AllStats) and (BPBID.BreedsPerSpecies[speciesID]) then
			if (not BPBID_Options.Breedtip.CurrentStats) or (not extrabreeds) then
				for i = 1, #BPBID.BreedsPerSpecies[speciesID] do
					local currentbreed = BPBID.BreedsPerSpecies[speciesID][i]
					local allstatsp1 = "\124cFFD4A017Breed " .. BPBID.RetrieveBreedName(currentbreed)
					local allstatsp2 = ":\124r " .. (BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) .. "/" .. (BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) .. "/" .. (BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3])
					local allstats -- will be defined by the if statement below to see the asterisk needs to be added
					
					if (not extrabreeds) or ((extrabreeds[currentbreed - 2]) and (extrabreeds[currentbreed - 2] > 2)) then
						allstats = allstatsp1 .. allstatsp2
					else
						allstats = allstatsp1 .. "*" .. allstatsp2
					end
					
					breedtip:AddLine(allstats, 1, 1, 1, 1)
				end
			else
				for i = 1, 10 do
					if (extrabreeds[i]) and (extrabreeds[i] > 2) then
						local currentbreed = i + 2
						local allstats = "\124cFFD4A017Breed " .. BPBID.RetrieveBreedName(currentbreed) .. ":\124r " .. (BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) .. "/" .. (BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) .. "/" .. (BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3])
						breedtip:AddLine(allstats, 1, 1, 1, 1)
					end
				end
			end
		end
			
		-- set line for "Current breed's stats at level 25" (have to have tblBreedID for this)
		if (BPBID_Options.Breedtip.CurrentStats25) and (tblBreedID) then
			for i = 1, #tblBreedID do
				local currentbreed = tblBreedID[i]
				local hex = "\124cFF0070DD" -- always use rare color by default
				local quality = 3 -- always use rare pet quality by default
				
				-- unless the user specifies they want the real color OR the pet is epic/legendary quality
				if (not BPBID_Options.Breedtip.AllStats25Rare) or (rarity > 3) then
					hex = ITEM_QUALITY_COLORS[rarity].hex
					quality = rarity
				end
				
				local currentstats25 = hex .. BPBID.RetrieveBreedName(currentbreed) .. "* at 25:\124r " .. ceil((BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) * 25 * (quality / 10 + 1) * 5 + 100 - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) * 25 * (quality / 10 + 1) - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3]) * 25 * (quality / 10 + 1) - 0.5)
				breedtip:AddLine(currentstats25, 1, 1, 1, 1)
			end
		end
			
		-- set line for "All breeds' stats at level 25" (have to have BreedsPerSpecies for this)
		if (BPBID_Options.Breedtip.AllStats25) and (BPBID.BreedsPerSpecies[speciesID]) then
			local hex = "\124cFF0070DD" -- always use rare color by default
			local quality = 3 -- always use rare pet quality by default
			
			-- unless the user specifies they want the real color OR the pet is epic/legendary quality
			if (not BPBID_Options.Breedtip.AllStats25Rare) or (rarity > 3) then
				hex = ITEM_QUALITY_COLORS[rarity].hex
				quality = rarity
			end
			
			-- choose loop (whether I have to show ALL breeds including the one I am looking at or just the other breeds besides the one I'm looking at)
			if ((rarity == 3) and (BPBID_Options.Breedtip.CurrentStats25Rare ~= BPBID_Options.Breedtip.AllStats25Rare)) or (not BPBID_Options.Breedtip.CurrentStats25) or (not extrabreeds) then
				for i = 1, #BPBID.BreedsPerSpecies[speciesID] do
					local currentbreed = BPBID.BreedsPerSpecies[speciesID][i]
					local allstats25p1 = hex .. BPBID.RetrieveBreedName(currentbreed)
					local allstats25p2 = " at 25:\124r " .. ceil((BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) * 25 * (quality / 10 + 1) * 5 + 100 - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) * 25 * (quality / 10 + 1) - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3]) * 25 * (quality / 10 + 1) - 0.5)
					local allstats25 -- will be defined by the if statement below to see the asterisk needs to be added
					
					if (not extrabreeds) or ((extrabreeds[currentbreed - 2]) and (extrabreeds[currentbreed - 2] > 2)) then
						allstats25 = allstats25p1 .. allstats25p2
					else
						allstats25 = allstats25p1 .. "*" .. allstats25p2
					end
					
					breedtip:AddLine(allstats25, 1, 1, 1, 1)
				end
			else
				for i = 1, 10 do
					if (extrabreeds[i]) and (extrabreeds[i] > 2) then
						local currentbreed = i + 2
						local allstats25 = hex .. BPBID.RetrieveBreedName(currentbreed) .. " at 25:\124r " .. ceil((BPBID.BasePetStats[speciesID][1] + BPBID.BreedStats[currentbreed][1]) * 25 * (quality / 10 + 1) * 5 + 100 - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][2] + BPBID.BreedStats[currentbreed][2]) * 25 * (quality / 10 + 1) - 0.5) .. "/" .. ceil((BPBID.BasePetStats[speciesID][3] + BPBID.BreedStats[currentbreed][3]) * 25 * (quality / 10 + 1) - 0.5)
						breedtip:AddLine(allstats25, 1, 1, 1, 1)
					end
				end
			end
		end
	end
	
	-- fix wordwrapping on smaller tooltips
	if _G["BPBID_BreedTooltipTextLeft1"] then
		_G["BPBID_BreedTooltipTextLeft1"]:CanNonSpaceWrap(true)
	end
	
	-- fix fonts to all match (if multiple lines exist, which they should 99.9% of the time)
	if _G["BPBID_BreedTooltipTextLeft2"] then
		-- get fonts from line 1
		local fontpath, fontheight, fontflags = _G["BPBID_BreedTooltipTextLeft1"]:GetFont()
		
		-- set iterator at line 2 to start
		local iterline = 2
		
		-- match all fonts to line 1
		while _G["BPBID_BreedTooltipTextLeft" .. iterline] do
			_G["BPBID_BreedTooltipTextLeft" .. iterline]:SetFont(fontpath, fontheight, fontflags)
			_G["BPBID_BreedTooltipTextLeft" .. iterline]:CanNonSpaceWrap(true)
			iterline = iterline + 1
		end
	end
	
	-- resize height automatically when reshown
	breedtip:Show()
	
	-- reset extratip value
	extratip = false
end

-- display breed, quality if necessary, and breed tooltips on pet frames/tooltips in Pet Battles
local function BPBID_Hook_BattleUpdate(self)
	if not self.petOwner or not self.petIndex or not self.Name then return end
	
	-- cache all pets if it is the start of a battle
	if (BPBID.cacheTime == true) then BPBID.CacheAllPets() BPBID.cacheTime = false end
	
	-- check if it is a tooltip
	local tooltip = (self:GetName() == "PetBattlePrimaryUnitTooltip")
	
	-- calculate offset
	local offset = 0
	if (self.petOwner == 2) then offset = 3 end
	
	-- retrieve breed
	local breed = BPBID.RetrieveBreedName(BPBID.breedCache[self.petIndex + offset])
	
	-- get pet's name
	local name = CPBGN(self.petOwner, self.petIndex)
	
	if not tooltip then
		
		-- set the name header if the user wants
		if (name) and (BPBID_Options.Names.PrimaryBattle) then
			-- set standard text or use hex coloring based on font fix option
			if (BPBID_Options.BattleFontFix) then
				local _, _, _, hex = GetItemQualityColor(BPBID.rarityCache[self.petIndex + offset] - 1)
				self.Name:SetText("|c"..hex..name.." ("..breed..")".."|r")
			else
				self.Name:SetText(name.." ("..breed..")")
			end
		end
	else
		
		-- set the name header if the user wants
		if (name) and (BPBID_Options.Names.BattleTooltip) then
			-- set standard text or use hex coloring based on font fix option
			if (BPBID_Options.BattleFontFix) then
				local _, _, _, hex = GetItemQualityColor(BPBID.rarityCache[self.petIndex + offset] - 1)
				self.Name:SetText("|c"..hex..name.." ("..breed..")".."|r")
			else
				self.Name:SetText(name.." ("..breed..")")
			end
		end
		
		-- if this not the same tooltip as before
		if (BPBID.BattleNameText ~= self.Name:GetText()) and (not BPBID_Options.BattleFontFix) then
		
			-- downside font if the name/breed gets chopped off
			if self.Name:IsTruncated() then
				-- retrieve font elements
				local fontName, fontHeight, fontFlags = self.Name:GetFont()
				
				-- manually set height to perserve placing of other elements
				self.Name:SetHeight(self.Name:GetHeight())
				
				-- store font in addon namespace for later
				if not BPBID.BattleFontSize then BPBID.BattleFontSize = { fontName, fontHeight, fontFlags } end

				-- decrease the font size by 1 until it fits
				while self.Name:IsTruncated() do
					fontHeight = fontHeight - 1
					self.Name:SetFont(fontName, fontHeight, fontFlags)
				end
			elseif BPBID.BattleFontSize then
				-- reset font size to original if not truncated and original font size known
				self.Name:SetFont(BPBID.BattleFontSize[1], BPBID.BattleFontSize[2], BPBID.BattleFontSize[3])
			end
		end
		
		-- set the name text variable to match the real name text now to prepare for the next check
		BPBID.BattleNameText = self.Name:GetText()
		
		-- send to tooltip
		if (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.BattleTooltip) then
			BPBID_SetBreedTooltip(PetBattlePrimaryUnitTooltip, BPBID.speciesCache[self.petIndex + offset], BPBID.resultsCache[self.petIndex + offset], BPBID.rarityCache[self.petIndex + offset] - 1)
		end
	end
end

-- display breed, quality if necessary, and breed tooltips on item-based pet tooltips
local function BPBID_Hook_BPTShow(speciesID, level, rarity, maxHealth, power, speed)
	-- impossible checks for safety reasons
	if (not BattlePetTooltip.Name) or (not speciesID) or (not level) or (not rarity) or (not maxHealth) or (not power) or (not speed) then return end
	
	-- fix rarity to match our system and calculate breedID and breedname
	rarity = rarity + 1
	local breedNum, quality, resultslist = BPBID.CalculateBreedID(speciesID, rarity, level, maxHealth, power, speed, false, false)
	
	-- set up name text variable for testing whether or not we're trying to resize the font of the same tooltip repeatedly
	if (not BPBID.BPTNameText) then BPBID.BPTNameText = "" end
	
	-- add the breed to the tooltip's name text
	if (BPBID_Options.Names.BPT) then
		local breed = BPBID.RetrieveBreedName(breedNum)
		
		-- BattlePetTooltip does not allow customnames for now, so we can just get this ourself (more reliable)
		local realname = GPIS(speciesID)
		
		-- write breed to tooltip
		BattlePetTooltip.Name:SetText(realname.." ("..breed..")")
		
		-- if this not the same tooltip as before
		if (BPBID.BPTNameText ~= BattlePetTooltip.Name:GetText()) then
			-- downside font if the name/breed gets chopped off
			if BattlePetTooltip.Name:IsTruncated() then
				-- retrieve font elements
				local fontName, fontHeight, fontFlags = BattlePetTooltip.Name:GetFont()
				
				-- manually set height to perserve placing of other elements
				BattlePetTooltip.Name:SetHeight(BattlePetTooltip.Name:GetHeight()) 
				
				-- store font in addon namespace for later
				if not BPBID.BPTFontSize then BPBID.BPTFontSize = { fontName, fontHeight, fontFlags } end
				
				-- decrease the font size by 1 until it fits
				while BattlePetTooltip.Name:IsTruncated() do
					fontHeight = fontHeight - 1
					BattlePetTooltip.Name:SetFont(fontName, fontHeight, fontFlags)
				end
			elseif (BPBID.BPTFontSize) then
				-- reset font size to original if not truncated AND original font size known
				BattlePetTooltip.Name:SetFont(BPBID.BPTFontSize[1], BPBID.BPTFontSize[2], BPBID.BPTFontSize[3])
			end
		end
		
		-- set the name text variable to match the real name text now to prepare for the next check
		BPBID.BPTNameText = BattlePetTooltip.Name:GetText()
	end
	
	-- color the tooltip if the game didn't know what the rarity was originally
	if (BPBID_Options.BlizzBugTooltip) and (rarity == 0) then
		BattlePetTooltip.Name:SetTextColor(ITEM_QUALITY_COLORS[quality - 1].r, ITEM_QUALITY_COLORS[quality - 1].g, ITEM_QUALITY_COLORS[quality - 1].b)
	end
	
	-- set up the breed tooltip
	if (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.BPT) then
		BPBID_SetBreedTooltip(BattlePetTooltip, speciesID, resultslist, quality - 1)
	end
end

-- display breed, quality if necessary, and breed tooltips on pet tooltips from chat links
local function BPBID_Hook_FBPTShow(speciesID, level, rarity, maxHealth, power, speed, name)
	-- impossible checks for safety reasons
	if (not FloatingBattlePetTooltip.Name) or (not speciesID) or (not level) or (not rarity) or (not maxHealth) or (not power) or (not speed) then return end

	-- fix rarity to match our system and calculate breedID and breedname
	rarity = rarity + 1
	local breedNum, quality, resultslist = BPBID.CalculateBreedID(speciesID, rarity, level, maxHealth, power, speed, false, false)
	
	-- avoid strange quality errors (investigate further?)
	if (not quality) then return end
	
	-- add the breed to the tooltip's name text
	if (BPBID_Options.Names.FBPT) then
		local breed = BPBID.RetrieveBreedName(breedNum)
		
		-- account for possibility of not having the name passed to us
		local realname
		if (not name) then
			realname = GPIS(speciesID)
		else
			realname = name
		end
		
		-- write breed to tooltip
		FloatingBattlePetTooltip.Name:SetText(realname.." ("..breed..")")
		
		-- could potentially try to avoid collisons better here but it will be hard because these aren't even really GameTooltips
		-- resize all relevant parts of tooltip to avoid cutoff breeds/names (since Blizzard made these static-sized!)
		-- use alternative method (Simca has this stored) if this doesn't work long-term
		local stringwide = FloatingBattlePetTooltip.Name:GetStringWidth() + 14
		if stringwide < 238 then stringwide = 238 end
		
		FloatingBattlePetTooltip:SetWidth(stringwide + 22)
		FloatingBattlePetTooltip.Name:SetWidth(stringwide)
		FloatingBattlePetTooltip.BattlePet:SetWidth(stringwide)
		FloatingBattlePetTooltip.PetType:SetPoint("TOPRIGHT", FloatingBattlePetTooltip.Name, "BOTTOMRIGHT", 0, -2)
		FloatingBattlePetTooltip.Level:SetWidth(stringwide)
		FloatingBattlePetTooltip.Delimiter:SetWidth(stringwide + 13)
		FloatingBattlePetTooltip.JournalClick:SetWidth(stringwide)
	end
	
	-- color the tooltip if the game didn't know what the rarity was originally
	if (BPBID_Options.BlizzBugTooltip) and (rarity == 0) then
		FloatingBattlePetTooltip.Name:SetTextColor(ITEM_QUALITY_COLORS[quality - 1].r, ITEM_QUALITY_COLORS[quality - 1].g, ITEM_QUALITY_COLORS[quality - 1].b)
	end
	
	-- set up the breed tooltip
	if (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.FBPT) then
		BPBID_SetBreedTooltip(FloatingBattlePetTooltip, speciesID, resultslist, quality - 1)
	end
end

-- display breed, quality if necessary, and breed tooltips on Pet Journal tooltips
function BPBID.Hook_PJTEnter(self, motion)
	-- impossible check for safety reasons
	if (not GameTooltip:IsVisible()) then return end
	
	if (PetJournalPetCard.petID) then
		-- get data from PetID (which can get from the current PetCard since we know the current PetCard has to be responsible for the tooltip too)
		local speciesID, _, level = GPII(PetJournalPetCard.petID)
		local _, maxHealth, power, speed, rarity = GPS(PetJournalPetCard.petID)
		
		-- calculate breedID and breedname
		local breedNum, quality, resultslist = BPBID.CalculateBreedID(speciesID, rarity, level, maxHealth, power, speed, false, false)
		
		-- if fields become nil due to everything being filtered, show the special runthrough tooltip and escape from the function
		if not quality then
			BPBID_SetBreedTooltip(GameTooltip, PetJournalPetCard.speciesID, false, false)
			return
		end
		
		-- add the breed to the tooltip's name text
		if (BPBID_Options.Names.PJT) then
			local breed = BPBID.RetrieveBreedName(breedNum)
			
			-- write breed to tooltip
			GameTooltipTextLeft1:SetText(GameTooltipTextLeft1:GetText().." ("..breed..")")
			
			-- resize to avoid cutting off breed
			GameTooltip:Show()
		end
		
		-- color tooltip header
		if (BPBID_Options.Names.PJTRarity) then
			GameTooltipTextLeft1:SetTextColor(ITEM_QUALITY_COLORS[quality - 1].r, ITEM_QUALITY_COLORS[quality - 1].g, ITEM_QUALITY_COLORS[quality - 1].b)
		end
		
		-- set up the breed tooltip
		if (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.PJT) then
			BPBID_SetBreedTooltip(GameTooltip, speciesID, resultslist, quality - 1)
		end
	elseif (PetJournalPetCard.speciesID) and (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.PJT) then
		-- set up the breed tooltip for a special runthrough (no known breed)
		BPBID_SetBreedTooltip(GameTooltip, PetJournalPetCard.speciesID, false, false)
	end
end

function BPBID.Hook_PJTLeave(self, motion)
	-- uncolor tooltip header
	if (BPBID_Options.Names.PJTRarity) then
		GameTooltipTextLeft1:SetTextColor(1, 1, 1)
	end
	
	-- reshow Floating Battle Pet Tooltip if it is still up
	if (PetJournalPetCard.petID) and (FloatingBattlePetTooltip:IsVisible()) then
		-- get data from PetID (which can get from the current PetCard since we know the current PetCard has to be responsible for the tooltip too)
		local speciesID, _, level = GPII(PetJournalPetCard.petID)
		local _, maxHealth, power, speed, rarity = GPS(PetJournalPetCard.petID)
		
		BPBID_Hook_FBPTShow(speciesID, level, rarity, maxHealth, power, speed)
	end
end

-- non-optional ArkInventory compability, but follow the example of BattlePetTooltip
function BPBID.Hook_ArkInventory(tooltip, h, i)
	-- if the user has chosen not to let ArkInventory handle Battle Pets then we won't need to intervene
	if (not ArkInventory.db.global.option.tooltip.battlepet.enable) or (tooltip ~= GameTooltip) then return end
	
	-- decode string
	local class, speciesID, level, rarity, maxHealth, power, speed = ArkInventory.ObjectStringDecode( h )
	
	-- escape if not a battlepet link
	if class ~= "battlepet" then return end
	
	-- impossible checks for safety reasons
	if (not speciesID) or (not level) or (not rarity) or (not maxHealth) or (not power) or (not speed) then return end
	
	-- fix rarity to match our system and calculate breedID and breedname
	rarity = rarity + 1
	local breedNum, quality, resultslist = BPBID.CalculateBreedID(speciesID, rarity, level, maxHealth, power, speed, false, false)
	
	-- fix width if too small
	if (GameTooltip:GetWidth() < 210) then
		GameTooltip:SetMinimumWidth(210)
		GameTooltip:Show()
	end
	
	-- add the breed to the tooltip's name text (unsupported atm)
	--[[if (BPBID_Options.Names.BPT) then
		local breed = BPBID.RetrieveBreedName(breedNum)
		
		-- BattlePetTooltip does not allow customnames for now, so we can just get this ourself (more reliable)
		local realname = GPIS(speciesID)
		
		-- write breed to tooltip
		tooltip.Name:SetText(realname.." ("..breed..")")
	end]]--
	
	-- rarity color bug is handled by ArkInventory
	
	-- set up the breed tooltip
	if (BPBID_Options.Tooltips.Enabled) and (BPBID_Options.Tooltips.BPT) then
		BPBID_SetBreedTooltip(GameTooltip, speciesID, resultslist, quality - 1)
	end
end

-- hook our tooltip functions
hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", BPBID_Hook_BattleUpdate)
hooksecurefunc("BattlePetToolTip_Show", BPBID_Hook_BPTShow)
hooksecurefunc("FloatingBattlePet_Show", BPBID_Hook_FBPTShow)
-- BPBID.Hook_PJTEnter is called by the ADDON_LOADED event of Blizzard_PetJournal in BattlePetBreedID's Core
-- BPBID.Hook_PJTLeave is called by the ADDON_LOADED event of Blizzard_PetJournal in BattlePetBreedID's Core
-- HSFUpdate and ChatEdit_InsertLink are handled in BattlePetBreedID's Core entirely because they are unrelated to tooltips