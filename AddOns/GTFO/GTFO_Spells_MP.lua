--------------------------------------------------------------------------
-- GTFO_Spells_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Mists of Pandaria
Author: Zensunim of Malygos
]]--

-- ***************
-- * Scholomance *
-- ***************

GTFO.SpellID["120027"] = {
	--desc = "Burn (Instructor Chillheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120037"] = {
	--desc = "Ice Wave (Instructor Chillheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111616"] = {
	--desc = "Ice Wrath (Instructor Chillheart)";
	sound = 4;
	trivialPercent = 0;
};

GTFO.SpellID["114061"] = {
	--desc = "Wondrous Rapidity (Jandice Barov)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111628"] = {
	--desc = "Dark Blaze (Lilian Voss)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114009"] = {
	--desc = "Soulflame (Rattlegore)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114873"] = {
	--desc = "Toxic Potion (Professor Slate)";
	sound = 1;
	trivialPercent = 0;
};

-- **********************
-- * Stormstout Brewery *
-- **********************

GTFO.SpellID["112993"] = {
	--desc = "Furlwind (Hoptallus)";
	sound = 1;
	tankSound = 2;
	tankSoundHeroic = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112945"] = {
	--desc = "Carrot Breath (Hoptallus)";
	sound = 1;
};

GTFO.SpellID["116170"] = {
	--desc = "Carbonation (Fizzy Brew Alemental)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106851"] = {
	--desc = "Blackout Brew (Yan-Zhu the Uncasked)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 4;
};

GTFO.SpellID["114386"] = {
	--desc = "Carbonation (Yan-Zhu the Uncasked)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106560"] = {
	--desc = "Gushing Brew (Yan-Zhu the Uncasked)";
	sound = 4;
	trivialPercent = 0;
	damageMinimum = 1;
};

GTFO.SpellID["107046"] = {
	--desc = "Water Strike (Sodden Hozen Brawler)";
	sound = 2;
	soundHeroic = 1;
	tankSound = 0;
	tankSoundHeroic = 0;
	trivialPercent = 0;
};

GTFO.SpellID["107176"] = {
	--desc = "Fire Strike (Inflamed Hozen Brawler)";
	sound = 2;
	soundHeroic = 1;
	tankSound = 0;
	tankSoundHeroic = 0;
	trivialPercent = 0;
};

GTFO.SpellID["116182"] = {
	--desc = "Suds (Sudsy Brew Alemental)";
	sound = 1;
	trivialPercent = 0;
};

-- ******************************
-- * Temple of the Jade Serpent *
-- ******************************

GTFO.SpellID["110099"] = {
	--desc = "Shadow of Doubt (Minion of Doubt)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118540"] = {
	--desc = "Jade Serpent Wave (Liu Flameheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107110"] = {
	--desc = "Jade Fire (Liu Flameheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["115167"] = {
	--desc = "Corrupted Waters (Wise Mari)";
	sound = 1;
};

GTFO.SpellID["111720"] = {
	--desc = "Swirling Sunfire (Loremaster Stonestep)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106653"] = {
	--desc = "Sha Residue (Corrupt Living Water)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106228"] = {
	--desc = "Nothingness (Sha of Doubt)";
	sound = 4;
	negatingDebuffSpellID = 106113; -- Touch of Nothingness
	trivialPercent = 0;
	negatingIgnoreTime = 2;
};

-- *********************
-- * Scarlet Cathedral *
-- *********************

GTFO.SpellID["115507"] = {
	--desc = "Flamethrower (Scarlet Flamethrower)";
	sound = 2;
	tankSound = 0;
	soundChallenge = 1;
	tankSoundChallenge = 0;
	trivialPercent = 0;
};

GTFO.SpellID["114465"] = {
	--desc = "Scorched Earth (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113766"] = {
	--desc = "Firestorm Kick (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114808"] = {
	--desc = "Blazing Fists (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["115291"] = {
	--desc = "Spirit Gale (Thalnos the Soulrender)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["110963"] = {
	--desc = "Flamestrike (High Inquisitor Whitemane)";
	sound = 2;
	soundChallenge = 1;
	trivialPercent = 0;
};

-- *****************
-- * Scarlet Halls *
-- *****************

GTFO.SpellID["114863"] = {
	--desc = "Exploding Shot (Commander Lindon)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113620"] = {
	--desc = "Burning Books (Flameweaver Koegler)";
	sound = 1;
	trivialPercent = 0;
};

-- ***************************
-- * Gate of the Setting Sun *
-- ***************************

GTFO.SpellID["115458"] = {
	--desc = "Acid Bomb (Striker Ga'dok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["116297"] = {
	--desc = "Strafing Run (Striker Ga'dok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107122"] = {
	--desc = "Viscous Fluid (Commander Ri'mok)";
	sound = 1;
};

GTFO.SpellID["107121"] = {
	--desc = "Frenzied Assault (Commander Ri'mok)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["111735"] = {
	--desc = "Tar (Raigonn)";
	sound = 2;
	applicationOnly = true;
};

GTFO.SpellID["107279"] = {
	--desc = "Engulfing Winds (Raigonn)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107275"] = {
	--desc = "Engulfing Winds (Raigonn)";
	sound = 1;
	trivialPercent = 0;
	test = true; -- Verify correct spell IDs and avoidability
};

GTFO.SpellID["111644"] = {
	--desc = "Screeching Swarm (Raigonn)";
	sound = 2;
	tankSound = 0;
	trivialPercent = 0;
};


-- ********************
-- * Mogu'shan Palace *
-- ********************

GTFO.SpellID["120101"] = {
	--desc = "Magnetic Field (Ming the Cunning)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["123651"] = {
	--desc = "Whirlwind (Kargesh Ribcrusher)";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["120562"] = {
	--desc = "Lightning Storm (Harthak Stormcaller)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119374"] = {
	--desc = "Whirlwind (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119573"] = {
	--desc = "Ring of Fire - Flames (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119311"] = {
	--desc = "Stream of Blades (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

-- ***********************
-- * Shado-Pan Monastery *
-- ***********************
-- TODO: Invoke Lightning (Gu Cloudstrike) (possibly FF?, benign for normal, must test for heroic/chal?)

GTFO.SpellID["128889"] = {
	--desc = "Static Field (Gu Cloudstrike)";
	sound = 1;
};

GTFO.SpellID["102572"] = {
	--desc = "Lightning Breath (Gu Cloudstrike)";
	soundChallenge = 1;
	tankSoundChallenge = 0; -- TODO: Verify the tank for avoiding this in challenge mode (?)
	test = true;
};

GTFO.SpellID["106645"] = {
	--desc = "Whirling Steel (Flying Snow)";
	sound = 1;
	tankSound = 2;
	soundHeroic = 1;
	tankSoundHeroic = 1;
};

GTFO.SpellID["106854"] = {
	--desc = "Fists of Fury Strike (Master Snowdrift)";
	sound = 1;
};

GTFO.SpellID["106944"] = {
	--desc = "Shadows of Destruction (Destroying Sha)";
	sound = 1;
	tankSound = 0; -- TODO: Verify the tank can avoid this in challenge mode by moving
};

GTFO.SpellID["131241"] = {
	--desc = "Fire Arrow (Shado-Pan Fire Archer)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112933"] = {
	--desc = "Ring of Malice (Taran Zhu)";
	sound = 1;
};

GTFO.SpellID["131522"] = {
	--desc = "Ring of Malice (Taran Zhu)";
	sound = 1;
};

GTFO.SpellID["112918"] = {
	--desc = "Pool of Shadows (Taran Zhu)";
	sound = 2;
	soundChallenge = 1;
};

-- **************************
-- * Siege of Nivzao Temple *
-- **************************

GTFO.SpellID["120593"] = {
	--desc = "Sap Puddle";
	sound = 2;
	applicationOnly = true;
};

GTFO.SpellID["119941"] = {
	--desc = "Sap Residue (Vizier Jin'bak)";
	sound = 1; -- Modify to do low-damage alert when below minimum stacks?
	applicationOnly = true;
	minimumStacks = 9; -- This amount may need to be adjusted based on gear, challenge modes, etc.
	test = true;
};

GTFO.SpellID["128359"] = {
	--desc = "Caustic Tar (Commander Vo'jak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120760"] = {
	--desc = "Thousand Blades (Commander Vo'jak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121443"] = {
	--desc = "Caustic Pitch (Wing Leader Ner'onok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121447"] = {
	--desc = "Quick-Dry Resin (Wing Leader Ner'onok)";
	soundFunction = function() 
		local power = UnitPower("player", ALTERNATE_POWER_INDEX) or 0;
		-- Alert only when gaining net power over time, not when the player is actively jumping
		if (power > ((GTFO.VariableStore.QuickDryResin or 0) + 5)) then
			GTFO.VariableStore.QuickDryResin = power;
			return 1;
		elseif (power < (GTFO.VariableStore.QuickDryResin or 0)) then
			-- Player is jumping, set a new baseline
			GTFO.VariableStore.QuickDryResin = power;
			return 0;
		else
			return 0;
		end
	end;
	alwaysAlert = true;
};

-- *****************
-- * Heart of Fear *
-- *****************

GTFO.SpellID["123812"] = {
	--desc = "Pheromones of Zeal (Imperial Vizier Zor'lok)";
	-- Alert once and then ignore briefly to allow the player to run through the stuff
	-- before yelling at the player for being too slow
	soundFunction = function() 
		if (not GTFO_FindEvent("ZorlokZealStart")) then
			GTFO_AddEvent("ZorlokZealIgnore", 8);
		end
		GTFO_AddEvent("ZorlokZealStart", 15);
		return 1;
	end;
	ignoreEvent = "ZorlokZealIgnore";
	alwaysAlert = true;
};

GTFO.SpellID["122336"] = {
	--desc = "Sonic Ring (Imperial Vizier Zor'lok)";
	sound = 1;
	negatingDebuffSpellID = 122706; -- Noise Cancelling
	trivialPercent = 0;
};

GTFO.SpellID["122760"] = {
	--desc = "Exhale (Imperial Vizier Zor'lok)";
	sound = 1;
	tankSound = 0;
	negatingDebuffSpellID = 122761; -- Exhale
	negatingIgnoreTime = 2;
};

GTFO.SpellID["122718"] = {
	--desc = "Force and Verve (Imperial Vizier Zor'lok)";
	sound = 1;
	trivialPercent = 0;
	negatingDebuffSpellID = 122706; -- Noise Cancelling
};

-- TODO: Blade Tempest (Blade Lord Ta'yak)

GTFO.SpellID["123120"] = {
	--desc = "Pheromone Trail (Garalon)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["122064"] = {
	--desc = "Corrosive Resin (Wind Lord Mel'jarak)";
	alwaysAlert = true;
	soundFunction = function() 
		local resin = GTFO_DebuffStackCount("player", 122064) or 0;
		local equal = (resin == GTFO.VariableStore.StackCounter);
		GTFO.VariableStore.StackCounter = resin;
		if (resin > 0 and equal) then
			return 1;
		end
	end;
};

GTFO.SpellID["122125"] = {
	--desc = "Corrosive Resin Pool (Wind Lord Mel'jarak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126912"] = {
	--desc = "Grievous Whirl (Kor'thik Fleshrender)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
	trivialPercent = 0;
};

GTFO.SpellID["122784"] = {
	--desc = "Reshape Life (Amber-Shaper Un'sok)";
	soundFunction = function() 
		GTFO_AddEvent("ReshapeLife", 5);
		GTFO.VariableStore.DisableGTFO = true;
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["122005"] = {
	--desc = "Molten Amber (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121995"] = {
	--desc = "Amber Scalpel (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["122504"] = {
	--desc = "Burning Amber (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
	ignoreEvent = "ReshapeLife";
};

-- TODO: Stick Resin (Grand Empress Shek'zeer)

GTFO.SpellID["124868"] = {
	--desc = "Visions of Demise (Grand Empress Shek'zeer)";
	sound = 4;
	trivialPercent = 0;
	ignoreSelfInflicted = true;
};

-- ********************
-- * Mogu'shan Vaults *
-- ********************

GTFO.SpellID["116060"] = {
	--desc = "Amethyst Petrification (Stone Guard)";
	-- Drives the Amethyst Pool alert being set to low
	soundFunction = function() 
		GTFO_AddEvent("AmethystPool", 5);
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["130774"] = {
	--desc = "Amethyst Pool (Stone Guard)";
	soundFunction = function() 
		if (GTFO_FindEvent("AmethystPool")) then
			return 2;
		else
			return 1;
		end
	end;
	alwaysAlert = true;
};

GTFO.SpellID["116038"] = {
	--desc = "Jasper Petrification (Stone Guard)";
	-- Drives the Jasper Chains alert being turned off
	soundFunction = function() 
		GTFO_AddEvent("JasperChains", 5);
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["130404"] = {
	--desc = "Jasper Chains (Stone Guard)";
	sound = 4;
	ignoreEvent = "JasperChains";
};

GTFO.SpellID["116793"] = {
	--desc = "Wildfire (Feng the Accursed)";
	sound = 1;
};

GTFO.SpellID["116040"] = {
	--desc = "Epicenter (Feng the Accursed)";
	sound = 1;
	damageMinimum = 100000;
	test = true; -- TODO: Need adjustments for different difficulty levels
};

GTFO.SpellID["116434"] = {
	--desc = "Arcane Resonance (Feng the Accursed)";
	sound = 4;
};

GTFO.SpellID["116365"] = {
	--desc = "Arcane Velocity (Feng the Accursed)";
	sound = 1;
	negatingDebuffSpellID = 116417; -- Arcane Resonance (TODO: there are 4 types, but 116417 is used for normal 10/25, need more info on other difficulties)
	negatingIgnoreTime = 2;
	damageMinimum = 85000; -- TODO: Might need adjustments for Heroic
	test = true; -- TODO: This is a complicated alert, needs to be adjusted by damage amount and arcane resonance debuff
};

GTFO.SpellID["118094"] = {
	--desc = "Volley - First Shot (The Spirit Kings)";
	sound = 2;
	soundHeroic = 1;
};

GTFO.SpellID["118105"] = {
	--desc = "Volley - Second Shot (The Spirit Kings)";
	sound = 1;
};

GTFO.SpellID["117558"] = {
	--desc = "Coalescing Shadows (The Spirit Kings)";
	sound = 1;
};

-- TODO: Undying Shadow (The Spirit Kings) (Needs more information on this one)

GTFO.SpellID["124947"] = {
	--desc = "Celestial Breath (Elegon)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["116661"] = {
	--desc = "Energy Conduit (Elegon)";
	sound = 1;
};

-- TODO: Overcharged (Elegon) (Stack count varies by strategy, research needed for highest limit)

-- TODO: Energy of Creation (Will of the Emperor) (Heroic only, FF too?)

-- *****************************
-- * Terrace of Endless Spring *
-- *****************************

GTFO.SpellID["117988"] = {
	--desc = "Defiled Ground - Damage (Protector Kaolan)";
	sound = 1;
};

GTFO.SpellID["118091"] = {
	--desc = "Defiled Ground - Debuff (Protector Kaolan)";
	sound = 1;
	applicationOnly = true;
};

-- TODO: Expel Corruption (Protector Kaolan) (FF damage based on distance, find out what the min distance is and amt dmg taken for it)

GTFO.SpellID["117398"] = {
	--desc = "Lightning Prison (Elder Regail)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["123121"] = {
	--desc = "Spray (Lei Shi)";
	soundFunction = function() 
		-- Don't alert during Hide special
		if UnitExists("Boss1Target") then
			if (GTFO.TankMode) then
				if (not UnitIsUnit("Boss1Target", "player")) then
					if (GTFO_FindEvent("LeiShiSpray")) then
						-- Tanks that don't have aggro should avoid spray
						return 1;
					else
						-- Ignore first spray to give the tank a chance to get into/out of position
						-- TODO: Verify and adjust if it needs to ignore more than once
						GTFO_AddEvent("LeiShiSpray", 5);
					end
					return 0;
				end
			else
				return 1;
			end
		end
	end;
};

-- TODO: Scary Fog (Lei Shi)
-- TODO: Dread Spray (Sha of Fear) (could be a fail alert)

GTFO.SpellID["119887"] = {
	--desc = "Death Blossom (Sha of Fear)";
	sound = 1;
};

-- ****************
-- * World Bosses *
-- ****************

GTFO.SpellID["119610"] = {
	--desc = "Bitter Thoughts (Sha of Anger)";
	soundFunction = function() 
		-- Reduce the spam
		GTFO_AddEvent("BitterThoughts", .75);
		return 1;
	end;
	ignoreEvent = "BitterThoughts";
	test = true; -- Doesn't work anyway, no combat log info for this debuff
};

-- ********************
-- * Theramore's Fall *
-- ********************

GTFO.SpellID["128880"] = {
	--desc = "Crackling Flames";
	sound = 1;
};

-- ********************************
-- * Crypt of the Forgotten Kings *
-- ********************************

GTFO.SpellID["120742"] = {
	--desc = "Anger (Cloud of Anger)";
	sound = 1;
};

GTFO.SpellID["128970"] = {
	--desc = "Bladestorm (Crypt Guardian)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["119667"] = {
	--desc = "Fire Trap";
	sound = 1;
	applicationOnly = true;
};


-- *************************
-- * Arena of Annihilation *
-- *************************

GTFO.SpellID["123929"] = {
	--desc = "Stone Spin (Scar-Shell)";
	sound = 1;
};

GTFO.SpellID["123959"] = {
	--desc = "Flameline (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123967"] = {
	--desc = "Lava Pool (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123965"] = {
	--desc = "Flame Wall (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123976"] = {
	--desc = "Trailblaze (Chagan Firehoof)";
	sound = 1;
};

GTFO.SpellID["125566"] = {
	--desc = "Whirlpool (Maki Waterblade)";
	sound = 1;
};

GTFO.SpellID["125626"] = {
	--desc = "Jade Lightning Strike (Cloudbender Kobo)";
	sound = 1;
};

GTFO.SpellID["131694"] = {
	--desc = "Twister (Cloudbender Kobo)";
	sound = 1;
};

GTFO.SpellID["125580"] = {
	--desc = "Cyclone Kick (Cloudbender Kobo)";
	sound = 2;
};

-- *********************
-- * Brewmoon Festival *
-- *********************

GTFO.SpellID["124380"] = {
	--desc = "Twirlwind (Den Mother Moof)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125405"] = {
	--desc = "Fire Lines (Warbringer Qobi)";
	sound = 1;
	trivialPercent = 0;
};

-- **********************
-- * Greenstone Village *
-- **********************

GTFO.SpellID["119402"] = {
	--desc = "Terror Shards (Greenstone Terrorizer)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["118819"] = {
	--desc = "Pollen Puff (Belligerent Blossom)";
	sound = 1;
};

GTFO.SpellID["122211"] = {
	--desc = "Jade Burn (Jade Destroyer)";
	sound = 1;
};

-- ***********************
-- * Assault on Zan'vess *
-- ***********************

GTFO.SpellID["133847"] = {
	--desc = "Whirlwind (Team Leader Scooter)";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
};

-- ***********************
-- * Dagger in the Dark *
-- ***********************

GTFO.SpellID["133001"] = {
	--desc = "Gas Bomb (Rak'gor Bloodrazor)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["132758"] = {
	--desc = "Whirlwind (Darkhatched Lizard-Lord)";
	sound = 1;
	tankSound = 0;
	trivialPercent = 0;
};

-- *******************
-- * Brawler's Guild *
-- *******************

-- TODO: Fire line (Vian the Volatile)
GTFO.SpellID["133610"] = {
	--desc = "Fire Lines - Impact (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133611"] = {
	--desc = "Fire Lines - Residue (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133303"] = {
	--desc = "Volatile Flames (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133287"] = {
	--desc = "Heated Pokers (Dungeon Master Vishas)";
	sound = 1;
};

GTFO.SpellID["133236"] = {
	--desc = "Explosion (Fran and Riddoh)";
	sound = 1;
};

GTFO.SpellID["132661"] = {
	--desc = "Firewall (Sanoriak)";
	sound = 1;
};

GTFO.SpellID["129888"] = {
	--desc = "Solar Beam (Leona Earthwind)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["133156"] = {
	--desc = "Shock Field (Deekan)";
	sound = 1;
};

GTFO.SpellID["133576"] = {
	--desc = "Electric Dynamite (Millie Watt)";
	sound = 1;
};

GTFO.SpellID["133289"] = {
	--desc = "Flames of Fallen Glory (Fjoll)";
	sound = 1;
};

GTFO.SpellID["133157"] = {
	--desc = "Leperous Spew (Leper Gnome Quintet)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 12;
};

-- TODO: Get Off! (Millhouse Manastorm) -- How does melee avoid it?
-- TODO: Get Off! (Zen'shar) -- How does melee avoid it?  Does this boss have this ability?
-- TODO: Laser Disc? (Disruptron)
-- TODO: Destructolaser (Epicus Maximus)

-- ************
-- * Pandaria *
-- ************

GTFO.SpellID["131107"] = {
	--desc = "Creeping Doubt (Koukou)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["131492"] = {
	--desc = "Rain of Fire (Gatrul'lon Flamecaller)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["117718"] = {
	--desc = "Incinerate (Gormali Incinerator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125403"] = {
	--desc = "Harsh Winds (Torik-Ethis)";
	sound = 1;
};

GTFO.SpellID["130289"] = {
	--desc = "Gloom Whirl (Sha of Despair)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["129930"] = {
	--desc = "Torrent of Despair (Maw of Despair)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["125800"] = {
	--desc = "Spinning Crane Kick (Nasra Spothide)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118441"] = {
	--desc = "Freezing Winds";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125241"] = {
	--desc = "Voidcloud (Borginn Darkfist)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120331"] = {
	--desc = "Emperor's Brand";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["116076"] = {
	--desc = "Burning Stare of the Angry Monkey! (Monkey Idol Target)";
	sound = 1;
};

GTFO.SpellID["110295"] = {
	--desc = "Noxious Fumes";
	sound = 2;
};

GTFO.SpellID["126065"] = {
	--desc = "Consuming Rune";
	sound = 1;
};

GTFO.SpellID["126625"] = {
	--desc = "Sha Corruption (Spirit of Hatred)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126632"] = {
	--desc = "Whirlwind of Anger (Spirit of Hatred)";
	sound = 1;
};

GTFO.SpellID["128099"] = {
	--desc = "Sha Corruption (Wake of Horror)";
	sound = 1;
};

GTFO.SpellID["126792"] = {
	--desc = "Sha Spit (Adjunct Kree'zot)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125321"] = {
	--desc = "Bananarang (Various Monkey Rare Mobs)";
	sound = 1;
};

GTFO.SpellID["129729"] = {
	--desc = "Creeping Fog (Shuffling Mistlurker)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125372"] = {
	--desc = "Blade Flurry (Gar'lok)";
	sound = 1;
};

GTFO.SpellID["128097"] = {
	--desc = "Blade Flurry (Vor'thik Dreadsworn)";
	sound = 1;
};

GTFO.SpellID["129657"] = {
	--desc = "Lightning Pool (Subjugated Serpent)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114685"] = {
	--desc = "Flame Spout";
	sound = 1;
};

GTFO.SpellID["126913"] = {
	--desc = "Thunder's Call";
	sound = 2;
};

GTFO.SpellID["126910"] = {
	--desc = "Molten Fists";
	sound = 2;
};

GTFO.SpellID["126916"] = {
	--desc = "Shadow's Fury";
	sound = 2;
};

GTFO.SpellID["128517"] = {
	--desc = "Firewall (Hozen Chiefs)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["130069"] = {
	--desc = "Sha Eruption (Adjunct Zet'uk)";
	sound = 1;
};

GTFO.SpellID["126336"] = {
	--desc = "Caustic Pitch (Vyraxxis)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["126394"] = {
	--desc = "Crow Storm (Prophet Khar'zul)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126443"] = {
	--desc = "Shadow Fog (Prophet Khar'zul)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["128385"] = {
	--desc = "Sonic Field (Kor'thik Resonator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["128385"] = {
	--desc = "Sonic Field (Kor'thik Resonator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["126285"] = {
	--desc = "Freezing Water (Huo-Shuang)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["132020"] = {
	--desc = "Lightning Pool (Zhao-Ren)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["128421"] = {
	--desc = "Shadow Geyser (Darkened Horrors)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["128428"] = {
	--desc = "Corrosive Resin (Karanosh)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126976"] = {
	--desc = "Liquid Jade (Jade Construct)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["127467"] = {
	--desc = "Lightning Crash (Trap)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["127473"] = {
	--desc = "Arrow Trap (Trap)";
	sound = 1;
	trivialPercent = .5;
};

GTFO.SpellID["127252"] = {
	--desc = "Lightning Crash (Zhao-Jin the Bloodletter)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135868"] = {
	--desc = "Ignite Fuel (Shredmaster Packle)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118260"] = {
	--desc = "Steaming Puddle (Brewmaster Chani)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["133800"] = {
	--desc = "Heavy Metal (Mercurial Visage)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126573"] = {
	--desc = "Burning! (Shonuf)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["124866"] = {
	--desc = "Rain Dance (Cournith Waterstrider)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135784"] = {
	--desc = "Infinite Sadness (Ishi)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135060"] = {
	--desc = "Cave In";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["134771"] = {
	--desc = "Mortal Throw (Ubunti the Shade)";
	sound = 1;
	trivialPercent = 0;
};

-- ***********
-- * Unknown *
-- ***********

GTFO.SpellID["123020"] = {
	--desc = "Burning Amber (Unknown)";
	sound = 1;
	trivialPercent = 0;
	test = true; -- Verify
};

