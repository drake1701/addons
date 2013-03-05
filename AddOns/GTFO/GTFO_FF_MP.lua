--------------------------------------------------------------------------
-- GTFO_FF_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Friendly Fire List - Mists of Pandaria
Author: Zensunim of Malygos
]]--

-- ***************
-- * Scholomance *
-- ***************

GTFO.FFSpellID["111616"] = {
	--desc = "Ice Wrath (Instructor Chillheart)";
	sound = 1;
	tankSound = 0; -- TODO: Find out if people need to get away from the tank?
	trivialPercent = 0;
};

-- ********************
-- * Mogu'shan Vaults *
-- ********************

GTFO.FFSpellID["116434"] = {
	--desc = "Arcane Resonance (Feng the Accursed)";
	sound = 1;
};

-- ***************************
-- * Gate of the Setting Sun *
-- ***************************

GTFO.FFSpellID["113645"] = {
	--desc = "Sabotage (Saboteur Kip'tilak)";
	sound = 3;
};

-- *****************************
-- * Terrace of Endless Spring *
-- *****************************
-- TODO: Expel Corruption (Protector Kaolan) (FF damage based on distance, find out what the min distance is and amt dmg taken for it)

-- ********************
-- * Throne of Thunder *
-- ********************
-- TODO: Biting Cold (Frost King Malakk) (Is the player stunned?  If so, this alert is unnecessary) -- Biting Cold is not FF damage, so not detectable
-- TODO: Frostbite (Frost King Malakk) (Alert when only 1 stack is left)