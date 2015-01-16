
-- todo: convert ability buttons to a parentArray

local _,L = ...
local rematch = Rematch
local card = RematchFloatingPetCard

rematch.breedNames = {nil,nil,"B/B","P/P","S/S","H/H","H/P","P/S","H/S","P/B","S/B","H/B"}

do
	card.back.damageTaken:SetText(L["Damage Taken"])
	card.back.weakFrom:SetText(L["from"])
	card.back.weakAbilities:SetText(L["abilities"])
	card.back.strongFrom:SetText(L["from"])
	card.back.strongAbilities:SetText(L["abilities"])
	card.main.slotted:SetText(L["This pet is currently slotted."])
	card.isleveling:SetText(L["When this team loads, your active leveling pet will go in this spot."])
end

-- desturates floating pet cards that are not owned
local function SetCardDesaturate(desat)
	card.abilitiesBG:SetDesaturated(desat)
	card.leftTitleBG:SetDesaturated(desat)
	card.rightTitleBG:SetDesaturated(desat)
	card.lineAbilitiesBG:SetDesaturated(desat)
	card.lineTitleBG:SetDesaturated(desat)
	if desat then
		card.back:SetBackdropBorderColor(.75,.75,.75)
		card:SetBackdropBorderColor(.75,.75,.75)
	else
		card.back:SetBackdropBorderColor(1,.82,0)
		card:SetBackdropBorderColor(1,.82,0)
	end
end

rematch.vulnerabilities = {{4,5},{1,3},{6,8},{5,2},{8,7},{2,9},{9,10},{10,1},{3,4},{7,6}}

-- petID can be a speciesID; fromBrowser will turn on searchHits for the reason the pet is listed
function rematch:ShowFloatingPetCard(petID,relativeTo,fromBrowser)

	if rematch:MenuJustClosed() then
		return -- if mouse happens to be over a pet just as menu closes, don't show card
	end

	if (card.petID and card.petID==petID) or not petID or petID==rematch.emptyPetID or card.locked then
		return -- already displaying this card or it's a nil/empty petID
	end

	rematch:SmartAnchor(card,relativeTo)
	card:SetScale(RematchSettings.LargeWindow and 1.25 or 1)

	card.back:SetShown(IsAltKeyDown())

	local speciesID,icon,customName,realName,level,xp,maxXp,displayID,isFavorite,icon,petType,sourceText,description,canBattle,creatureID

	if type(petID)=="string" then
		speciesID,customName,level,xp,maxXp,displayID,isFavorite,realName,icon,petType,creatureID,sourceText,description,_,canBattle,tradable,unique = C_PetJournal.GetPetInfoByPetID(petID)
	elseif type(petID)=="number" and petID~=0 then
		speciesID = petID
		petID = nil
		realName,icon,petType,creatureID,sourceText,description,_,canBattle,tradable,unique = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	else
		realName = L["Leveling Pet"]
		icon = rematch.levelingIcon
	end

	card.petID = petID or speciesID

	if petID~=0 then -- leveling pets have no back of card
		card.back.source:SetText(format("%s%s%s",sourceText,tradable and "" or "\n\124cffff0000"..BATTLE_PET_NOT_TRADABLE,unique and "\n\124cffffd200"..ITEM_UNIQUE or ""))
		card.back.description:SetText(description)
		-- set vulnerabilities
		card.back.strongType:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[rematch.vulnerabilities[petType][1]])
		card.back.weakType:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[rematch.vulnerabilities[petType][2]])
		card.titleCapture:EnableMouse(true)
	else
		card.back:Hide()
		card.titleCapture:EnableMouse(false)
	end

	local model
	if petID==0 then
		model = card.levelingModel
		model:SetModel("Interface\\Buttons\\talktomequestion_ltblue.m2")
		model:SetModelScale(2.5)
		card.model:Hide()
	else
		model = card.model
		if displayID and displayID~=0 then
			if ( displayID ~= model.displayID ) then
				model.creatureID = nil
				model.displayID = displayID
				model:SetDisplayInfo(displayID)
				model:SetDoBlend(false)
			end
		elseif creatureID and creatureID~=0 then
			if ( creatureID ~= model.creatureID ) then
				model.creatureID = creatureID
				model.displayID = nil
				model:SetCreature(creatureID)
				model:SetDoBlend(false)
			end
		end
		card.levelingModel:Hide()
	end
	model:Show()
	model:SetAnimation(0)

	SetPortraitToTexture(card.icon.icon,icon)
	if petID==0 then
		card.petType.icon:SetTexCoord(0,1,0,1)
		SetPortraitToTexture(card.petType.icon,"Interface\\Icons\\Garrison_Building_Menagerie")
	else
		card.petType.icon:SetTexCoord(0.4921875,0.796875,0.50390625,0.65625)
		card.petType.icon:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
	end
	card.name:SetText(customName or realName)

	if customName then
		card.realName:SetText(realName)
		card.realName:Show()
	else
		card.realName:Hide()
	end

	local roster = Rematch.roster

	-- show searchHit border around pet icon if pet source caused the hit
	local searchText,searchMask = fromBrowser and roster.searchText, roster.searchMask
	if searchText and sourceText and sourceText:match(searchMask) then -- or realName:match(searchMask) or (customName or ""):match(searchMask)) then
		card.icon.searchHit:Show()
	else
		card.icon.searchHit:Hide()
	end

	-- show searchHit border around type icon if type or tough vs filtered
	card.petType.searchHit:SetShown(fromBrowser and (not roster:IsTypeFilterClear() or not roster:IsTypeFilterClear(3)))

	if speciesID and canBattle then
		C_PetJournal.GetPetAbilityList(speciesID,rematch.abilityList,rematch.levelList)
		for i=1,#rematch.abilityList do
			local _,name, icon, _, description, _, abilityType, noHints = C_PetBattles.GetAbilityInfoByID(rematch.abilityList[i])
			local index = tostring(i)
			if RematchSettings.RealAbilityIcons then
				card.abilities[index].type:SetTexture(icon)
			else
				card.abilities[index].type:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[abilityType])
			end
			card.abilities[index].name:SetText(name)
			card.abilities[index].abilityID = rematch.abilityList[i]
			card.abilities[index].searchHit:Hide()
			-- show searchHit border around abilities that contain search text
			if searchText and description and (description:match(searchMask) or name:match(searchMask)) then
				card.abilities[index].searchHit:Show()
			end
			-- show searchHit border around abilities that are strong vs cadidates
			if fromBrowser and not noHints then
				for typeIndex in pairs(roster.typeFilter[2]) do
					if roster.strongTable[typeIndex] == abilityType then
						card.abilities[index].searchHit:Show()
					end
				end
			end
		end
		card.cantbattle:Hide()
		card.isleveling:Hide()
		card.abilities:Show()
		if petID then -- this is a pet we own with actual stats

			SetCardDesaturate(false)
			card.stats.level:SetText(level)

			local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(petID)
			if health==0 then
				card.stats.hpBar:Hide()
				card.stats.health:SetText(DEAD)
				model:SetAnimation(1) -- death animation
			else
				card.stats.hpBar:SetWidth(48*(health/maxHealth))
				card.stats.hpBar:Show()
				if health<maxHealth then
					card.stats.health:SetText(format("%d/%d",health,maxHealth))
				else
					card.stats.health:SetText(maxHealth)
				end
			end
			card.stats.power:SetText(power)
			card.stats.speed:SetText(speed)

			local color = ITEM_QUALITY_COLORS[rarity-1]
			card.stats.quality:SetText(_G["BATTLE_PET_BREED_QUALITY"..rarity])
			card.stats.quality:SetVertexColor(color.r,color.g,color.b)

			if rematch.breedSource then
				card.stats.breed:SetText(rematch:GetBreed(petID))
				card.stats.breed:Show()
				card.stats.breedIcon:Show()
			end

			if level<25 then
				card.stats.xpBar:SetMinMaxValues(0,maxXp)
				card.stats.xpBar:SetValue(xp)
				card.stats.xpBar.rankText:SetFormattedText(PET_BATTLE_CURRENT_XP_FORMAT_BOTH, xp, maxXp, xp/maxXp*100)
				card.stats.xpBar:Show()
			else
				card.stats.xpBar:Hide()
			end
			-- if any pets of this species are 25, color pennant gold
			if rematch.ownedSpeciesAt25[speciesID] then
				card.stats.pennant:SetVertexColor(1,.82,0)
			else
				card.stats.pennant:SetVertexColor(1,1,1)
			end
			card.stats:Show()

			-- display "This pet is currently slotted." if they're slotted and this card isn't
			-- anchored to a currently slotted pet (they're the one ones with a healthBG widget)
			if C_PetJournal.PetIsSlotted(petID) and not select(2,card:GetPoint(1)).healthBG then
				card.main.slotted:SetPoint("BOTTOM",0,level<25 and 12 or 0)
				card.main.slotted:Show()
			else
				card.main.slotted:Hide()
			end

		else -- this is not a pet we own, hide stats
			SetCardDesaturate(true)
			card.stats:Hide()
		end

	else -- this pet can't battle
		SetCardDesaturate(not petID)
		card.abilities:Hide()
		card.stats:Hide()
		card.cantbattle:SetShown(petID~=0)
		card.isleveling:SetShown(petID==0)
		card.main.slotted:Hide()
	end

	card:Show()
end

function rematch:HideFloatingPetCard(force)
	if not card.locked or force then
		card:Hide()
	end
end

function rematch:FloatingPetCardOnHide()
	card.petID = nil
	card.locked = nil
	self.lockFrame:Hide()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function rematch:LockFloatingPetCard()
	card.locked = not card.locked
	card.lockFrame:SetShown(card.locked)
end

function rematch:FloatingPetCardAbilityOnEnter()
	self.name:SetTextColor(1,1,1)
	local petID = card.petID
	if petID and self.abilityID then
		rematch.ShowAbilityCard(self,petID,self.abilityID)
	end
end

function rematch:FloatingPetCardAbilityOnLeave()
	self.name:SetTextColor(1,.82,.5)
	rematch:HideAbilityCard()
end

function rematch:FloatingPetCardAbilityOnClick()
	if IsModifiedClick("CHATLINK") then
		rematch:ChatLinkAbility(card.petID,self.abilityID)
	end
end

--[[ breed support

	Breed support is provided by Battle Pet Breed ID by Simca:
	http://www.curse.com/addons/wow/battle_pet_breedid

]]

function rematch:GetBPBIDBreedName(breed)
	if BPBID_Options.format==1 then
		return breed
	elseif BPBID_Options.format==2 then
		return format("%d/%d",breed,breed+10)
	elseif rematch.breedNames[breed] then
		return rematch.breedNames[breed]
	else
		return "ERR"
	end
end

-- populates card.main.breedTable with all possible breeds and stats for the card's species
function rematch:ShowBreedTable()

	local speciesID = type(card.petID)=="string" and C_PetJournal.GetPetInfoByPetID(card.petID) or card.petID
	local currentBreed = card.stats.breed:IsVisible() and card.stats.breed:GetText()

	if not rematch.breedSource or not speciesID or not select(8,C_PetJournal.GetPetInfoBySpeciesID(speciesID)) then
		return -- leave if BPBID not loaded, invalid species or pet can't battle
	end
	card.main.blackout:SetAlpha(1) -- darken main area so table stands out

	local row = card.main.breedTable.row

	for i=1,10 do
		row[i]:Hide()
	end
	card.main.breedTable.highlight:Hide()

	local info = rematch.info
	rematch:FillBreedTable(speciesID,info)

	if #info>0 then -- breeds are known
		for i=1,#info do
			row[i]:Show()
			row[i].breed:SetText(info[i][1])
			if info[i][1]==currentBreed then
				card.main.breedTable.highlight:SetPoint("BOTTOMLEFT",row[i],"BOTTOMLEFT")
				card.main.breedTable.highlight:Show()
			end
			row[i].health:SetText(info[i][2])
			row[i].power:SetText(info[i][3])
			row[i].speed:SetText(info[i][4])
		end
		card.main.breedTable.title:SetText(rematch.breedSource=="PetTracker_Breeds" and L["\124cffddddddPossible Breeds"] or L["\124cffddddddPossible level 25 \124cff0070ddRares"])
		card.main.breedTable:SetHeight(44+#info*14)
	else
		card.main.breedTable.title:SetText(L["No breeds known :("])
		card.main.breedTable:SetHeight(44)
	end
	card.main.breedTable:Show()
end

-- takes a table (breeds) and fills it with all known breeds and their stats as a 25 rare: { breedName, health, power, speed }
function rematch:FillBreedTable(speciesID,breeds)
	wipe(breeds)
	if rematch.breedSource=="BattlePetBreedID" then
		if not BPBID_Arrays.BreedsPerSpecies then
			BPBID_Arrays.InitializeArrays()
		end
		local data,numBreeds = BPBID_Arrays
		if data.BreedsPerSpecies[speciesID] then
			for i=1,#data.BreedsPerSpecies[speciesID] do
				local breed = data.BreedsPerSpecies[speciesID][i]
				local breedText = rematch:GetBPBIDBreedName(breed)
				local health = ceil((data.BasePetStats[speciesID][1] + data.BreedStats[breed][1]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) * 5 + 100 - 0.5)
				local power = ceil((data.BasePetStats[speciesID][2] + data.BreedStats[breed][2]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) - 0.5)
				local speed = ceil((data.BasePetStats[speciesID][3] + data.BreedStats[breed][3]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) - 0.5)
				tinsert(breeds,{breedText,health,power,speed})
			end
		end
	elseif rematch.breedSource=="LibPetBreedInfo-1.0" then
		local lib = rematch.breedLib
		for _,breed in pairs(lib:GetAvailableBreeds(speciesID)) do
			tinsert(breeds,{lib:GetBreedName(breed),lib:GetPetPredictedStats(speciesID,breed,4,25)})
		end
	elseif rematch.breedSource=="PetTracker_Breeds" then
		for _,breed in pairs(PetTracker.Breeds[speciesID]) do
			local health, power, speed = unpack(PetTracker.BreedStats[breed])
			health = health*50
			power = power*50
			speed = speed*50
			tinsert(breeds,{(PetTracker:GetBreedIcon(breed,.85)),health>0 and format("%d%%",health) or "-    ",power>0 and format("%d%%",power) or "-    ",speed>0 and format("%d%%",speed) or "-    "})
		end
	end
end

function rematch:HideBreedTable()
	card.main.blackout:SetAlpha(0)
	card.main.breedTable:Hide()
end

--[[ Ability Card ]]

-- instead of duplicating all the tables and parsing to create our own ability tooltip,
-- we just set a default tooltip, copy its strings and textures to our own, then
-- hide the default before it's rendered on screen.
function rematch:ShowAbilityCard(petID,abilityID)

	local card = RematchAbilityCard
	local tooltip = FloatingPetBattleAbilityTooltip
	if petID and abilityID then
		local _,maxHealth,power,speed
		if type(petID)=="string" then
			_,maxHealth,power,speed = C_PetJournal.GetPetStats(petID)
		else
			maxHealth,power,speed = 100,0,0 -- missing pets are weak!
		end

		local _, name, icon, _, _, _, _, noStrongWeakHints = C_PetBattles.GetAbilityInfoByID(abilityID)

		-- do stuff we can handle on our own
		card.icon:SetTexture(icon)
		card.name:SetText(name)
		card.hints:SetShown(not noStrongWeakHints)

		-- now make default do all the work
		FloatingPetBattleAbility_Show(abilityID,maxHealth,power,speed)

		-- at this point, default tooltip is filled in. now copy default's hard work
		card.typeIcon:SetTexture(tooltip.AbilityPetType:GetTexture())

		local bottom -- tracks the bottom-most line shown, nil if we anchor to the top

		local hasDuration = tooltip.Duration:IsVisible()
		if hasDuration then
			card.duration:SetText(tooltip.Duration:GetText())
			bottom = card.duration
		end
		card.duration:SetShown(hasDuration)

		local hasCooldown = tooltip.MaxCooldown:IsVisible()
		if hasCooldown then
			card.cooldown:SetText(tooltip.MaxCooldown:GetText())
			if not bottom then
				card.cooldown:SetPoint("TOPLEFT",card.duration,"TOPLEFT")
			else
				card.cooldown:SetPoint("TOPLEFT",bottom,"BOTTOMLEFT",0,-5)
			end
			bottom = card.cooldown
		end
		card.cooldown:SetShown(hasCooldown)

		card.description:SetText(tooltip.Description:GetText())
		if not bottom then
			card.description:SetPoint("TOPLEFT",card.duration,"TOPLEFT")
		else
			card.description:SetPoint("TOPLEFT",bottom,"BOTTOMLEFT",0,-5)
		end

		if not noStrongWeakHints then
			card.hints.strong:SetTexture(tooltip.StrongAgainstType1:GetTexture())
			card.hints.weak:SetTexture(tooltip.WeakAgainstType1:GetTexture())
		end

		tooltip:Hide() -- we're done with default tooltip, no need to show it

		rematch:SmartAnchor(card,self)

		card:SetAlpha(0)
		card:SetScript("OnUpdate",rematch.ResizeAbilityCard)
		card:Show()

	end
end

function rematch:ResizeAbilityCard()
	self:SetScript("OnUpdate",nil)
	local top = self:GetTop()
	if self.hints:IsVisible() then
		self:SetHeight(top-self.hints:GetBottom())
	else
		self:SetHeight(top-self.hints:GetTop()+3)
	end
	self:SetAlpha(1)
end

function rematch:HideAbilityCard()
	RematchAbilityCard:Hide()
end