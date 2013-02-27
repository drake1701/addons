-- Livestock:  For summoning random mounts, flying mounts, and critters.

-- Concept:  Khanthal (Uldum)

-- Copyright (c) 2008 Scott Snowman (Recompense on Uldum(US)), scott.snowman@gmail.com

-- All rights reserved.


-- Namespace and saved variable tables
Livestock = {}
LivestockSettings = {}

-- Saved variable default values and version string.
local defaults = {
	Critters = {},
	Mounts = {},
	Zones = {},
	Weights = {},
	showcritter = 0, -- show or hide the Vanity Pets button
	showland = 0, -- show or hide the Land Mounts button
	showflying = 0, -- show or hide the Flying Mounts button
	showsmart = 0, -- show or hide the Smart Mounts button
--	useslowland = 1, -- enable / disable seeing non-epic land mounts in the land mount menu
--	useslowflight = 1, -- enable / disable seeing non-epic flying mounts in the flying mount menu
	scale = 1, --  scale of the Livestock buttons
	druidlogic = 0, -- enable / disable including Flight Forms in Smart Mount behavior (for druids only)
	worgenlogic = 0, -- enable / disable including Running Wild in Smart Mount behavior (worgens only)
	summononmove = 0, -- enable / disable automatic summoning whenever movement is initiated
	summonfaveonmove = 0, -- change the above setting to summon the favorite pet instead of a random pet
	dismisspetonmount = 0, -- dismiss any critter out when mounting or birdforming
	restrictautosummon = 0, -- restrict autosummoning to only occur when not PVP flagged
	ignorepvprestrictionininstances = 0, -- ignore the PVP restriction in an instance
	safeflying = 1, -- enable /disable the ability to dismount yourself in the air when calling a Livestock mounting function
	dismissonstealth = 0, -- enable / disable the automatic dismissal of vanity pets when you cast Stealth, Vanish, Feign Death, Shadowmeld, or Invisibility
	PVPdismiss = 0, -- restrict the above setting to work only when your PVP flag is enabled
	mountinstealth = 0, -- enable / disable the ability for Livestock mounting to break stealth effects
	smartcatform = 0, -- enable / disable turning into Cat Form indoors when using Smart Mounting (for druids only)
	favoritepet = 0, -- index for a user-defined favorite pet
	waterwalking = 0, -- for shamans to use Water Walking when underwater or not
	combatforms = 1, -- whether or not combat should switch Smart Mounting for shamans / druids
	crusadermount = 0, -- for paladins, toggles if Crusader Aura should trigger a Smart Mount Summon afterward
	donotsummoninraid = 0, -- do not automatically summon a pet if you are in a raid
	movingform = 0, -- check for movement to assume an instant-cast travel form
	indooraspects = 0, -- Smart Mounting casts AotC / AotP when inside
	movingaspects = 0, -- Smart Mounting casts AotC / AotP when outside and moving
	groupaspects = 0, -- Smart Mounting casts AotC when in a group
	slowfall = 0, -- Smart Mounting casts Slow Fall / Levitate while falling and not in combat
	useweights = 0, -- Whether or not Smart Mounting should use weighted summons
	moonkin = 0, -- Cast Moonkin Form when dismounting from Flight Form (balance druids)
	newpet = 0, -- New companion pets are disabled by default
	version = 1.6, -- MoP updates
	}
	
LIVESTOCK_VERSION = GetAddOnMetadata("Livestock", "Version")

-- Localization tables

local L = LivestockLocalizations

local stringstable = { -- strings to be localized in the GUI.  This table is indexed by the name of the fontstring with each value being the string that should be displayed.  This allows for a quick iteration to set the strings correctly.
	["LivestockMenuFrame3DLabel"] = L.LIVESTOCK_FONTSTRING_3DLABEL,
	["LivestockMainPreferencesFrameButtonsToggleTitle"] = L.LIVESTOCK_FONTSTRING_BUTTONSTOGGLETITLE,
	["LivestockMainPreferencesFrameMacroTitle"] = L.LIVESTOCK_FONTSTRING_MACROBUTTONTITLE,
	--["LivestockMainPreferencesFrameOtherTitle"] = L.LIVESTOCK_FONTSTRING_OTHERTITLE,
	["LivestockMainPreferencesFrameShowCrittersLabel"] = L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL,
	["LivestockMainPreferencesFrameShowLandMountsLabel"] = L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL,
	["LivestockMainPreferencesFrameShowFlyingMountsLabel"] = L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL,
	["LivestockMainPreferencesFrameShowSmartMountsLabel"] = L.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL,
	["LivestockMainPreferencesFrameMacroText"] = L.LIVESTOCK_FONTSTRING_MACROBUTTONSTITLE,
	--["LivestockMainPreferencesFrameUseSlowLandText"] = L.LIVESTOCK_FONTSTRING_USESLOWLANDLABEL,
	--["LivestockMainPreferencesFrameUseSlowFlyingText"] = L.LIVESTOCK_FONTSTRING_USESLOWFLYINGLABEL,
	["LivestockMainPreferencesFrameOpenLivestockMenuButton"] = L.LIVESTOCK_FONTSTRING_LIVESTOCKMENU,
	["LivestockPetPreferencesFrameAutoSummonOnMoveText"] = L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVELABEL,
	["LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText"] = L.LIVESTOCK_FONTSTRING_AUTOSUMMONONMOVEFAVELABEL,
	["LivestockPetPreferencesFrameRestrictAutoSummonOnPVPText"] = L.LIVESTOCK_FONTSTRING_RESTRICTAUTOSUMMONLABEL,
	["LivestockPetPreferencesFrameIgnorePVPRestrictionInInstancesText"] = L.LIVESTOCK_FONTSTRING_IGNOREPVPRESTRICTIONININSTANCESLABEL,
	["LivestockPetPreferencesFrameRestrictAutoSummonOnRaidText"] = L.LIVESTOCK_FONTSTRING_DONOTRAIDSUMMONLABEL,
	["LivestockPetPreferencesFrameDismissPetOnMountText"] = L.LIVESTOCK_FONTSTRING_DISMISSPETONMOUNTLABEL,
	["LivestockSmartPreferencesFrameDruidToggleText"] = L.LIVESTOCK_FONTSTRING_DRUIDTOGGLELABEL,
	["LivestockSmartPreferencesFrameWorgenToggleText"] = L.LIVESTOCK_FONTSTRING_WORGENTOGGLELABEL,
	["LivestockSmartPreferencesFrameOpenLivestockMenuButton"] = L.LIVESTOCK_FONTSTRING_LIVESTOCKMENU,
	["LivestockCritterMenuButton"] = L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL,
	["LivestockLandMountMenuButton"] = L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL,
	["LivestockFlyingMountMenuButton"] = L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL,
	["LivestockWaterMountMenuButton"] = L.LIVESTOCK_FONTSTRING_SHOWWATERLABEL,
	["LivestockCritterMacroButton"] = L.LIVESTOCK_FONTSTRING_SHOWCRITTERSLABEL,
	["LivestockLandMountMacroButton"] = L.LIVESTOCK_FONTSTRING_SHOWLANDLABEL,
	["LivestockFlyingMountMacroButton"] = L.LIVESTOCK_FONTSTRING_SHOWFLYINGLABEL,
	["LivestockComboMacroButton"] = L.LIVESTOCK_FONTSTRING_SHOWSMARTLABEL,
	["LivestockSmartPreferencesFrameSafeFlightText"] = L.LIVESTOCK_FONTSTRING_SAFEFLIGHTLABEL,
	["LivestockPetPreferencesFrameAutoDismissOnStealthText"] = L.LIVESTOCK_FONTSTRING_AUTODISMISSONSTEALTHLABEL,
	["LivestockPetPreferencesFramePVPDismissText"] = L.LIVESTOCK_FONTSTRING_PVPDISMISSLABEL,
	["LivestockSmartPreferencesFrameMountInStealthText"] = L.LIVESTOCK_FONTSTRING_MOUNTINSTEALTHLABEL,
	["LivestockSmartPreferencesFrameSmartCatFormText"] = L.LIVESTOCK_FONTSTRING_SMARTCATFORMLABEL,
	["LivestockSmartPreferencesFrameToggleWaterWalkingText"] = L.LIVESTOCK_FONTSTRING_WATERWALKINGLABEL,
	["LivestockSmartPreferencesFrameToggleCombatFormsText"] = L.LIVESTOCK_FONTSTRING_USECOMBATFORMSLABEL,
	["LivestockSmartPreferencesFrameToggleMovingFormsText"] = L.LIVESTOCK_FONTSTRING_USEMOVINGFORMSLABEL,
	["LivestockSmartPreferencesFrameToggleCrusaderMountText"] = L.LIVESTOCK_FONTSTRING_CRUSADERSUMMONLABEL,
	["LivestockSmartPreferencesFrameIndoorHunterAspectsText"] = L.LIVESTOCK_FONTSTRING_INDOORHUNTERASPECTSLABEL,
	["LivestockSmartPreferencesFrameMovingHunterAspectsText"] = L.LIVESTOCK_FONTSTRING_MOVINGHUNTERASPECTSLABEL,
	["LivestockSmartPreferencesFrameGroupHunterAspectsText"] = L.LIVESTOCK_FONTSTRING_GROUPHUNTERASPECTSLABEL,
	["LivestockSmartPreferencesFrameSlowFallWhileFallingText"] = L.LIVESTOCK_FONTSTRING_SLOWFALLLABEL,
	["LivestockSmartPreferencesFrameMoonkinText"] = L.LIVESTOCK_FONTSTRING_MOONKINLABEL,
	["LivestockSmartPreferencesFrameNewPetText"] = L.LIVESTOCK_FONTSTRING_NEWPETLABEL,
	}
	
local restrictSummonForTheseBuffs = { -- buffs that, when present, should prevent autosummoning from happening
	L.LIVESTOCK_SPELL_STEALTH,
	L.LIVESTOCK_SPELL_PROWL,
	L.LIVESTOCK_SPELL_INVISIBILITY,
	L.LIVESTOCK_SPELL_VANISH,
	L.LIVESTOCK_SPELL_CLOAKING,
	L.LIVESTOCK_SPELL_SHADOWMELD,
	L.LIVESTOCK_SPELL_FOOD,
	L.LIVESTOCK_SPELL_DRINK,
	L.LIVESTOCK_SPELL_HAUNTED,
	L.LIVESTOCK_SPELL_FLIGHTFORM,
	L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM,
	L.LIVESTOCK_SPELL_TWILIGHTSERPENT,
	L.LIVESTOCK_SPELL_RUBYHARE,
	L.LIVESTOCK_SPELL_SAPPHIREOWL,
	L.LIVESTOCK_SPELL_CAMOUFLAGE,
	}
	
local restrictSummonForThisEquipment = { -- equipment that, when worn, should prevent autosummoning from happening
	L.LIVESTOCK_EQUIPMENT_BLOODSAIL,
	L.LIVESTOCK_EQUIPMENT_DONCARLOS,
	}
	
local hiddenBuffs = { -- buffs that indicate the player is invisible in some way
	L.LIVESTOCK_SPELL_STEALTH,
	L.LIVESTOCK_SPELL_PROWL,
	L.LIVESTOCK_SPELL_INVISIBILITY,
	L.LIVESTOCK_SPELL_VANISH,
	L.LIVESTOCK_SPELL_CLOAKING,
	L.LIVESTOCK_SPELL_SHADOWMELD,
	L.LIVESTOCK_SPELL_CAMOUFLAGE,
	}

-- Variable declaration
BINDING_HEADER_LIVESTOCKHEADER = "Livestock Summons" -- Keybindings menu
_G["BINDING_NAME_CLICK LivestockComboButton:LeftButton"] = "Random Smart Mount" -- Keybindings
_G["BINDING_NAME_CLICK LivestockLandMountsButton:LeftButton"] = "Random Land Mount"
_G["BINDING_NAME_CLICK LivestockFlyingMountsButton:LeftButton"] = "Random Flying Mount"

local eastereggtext, currentcritter, createdMaps
local donotsummon = true
local debug = false
local modelcounter, class = 0
local mountfail, critterfail
local NUMBER_OF_CRITTER_MENUS, NUMBER_OF_LAND_MENUS, NUMBER_OF_FLYING_MENUS, NUMBER_OF_WATER_MENUS = 1, 1, 1, 1  -- constants for menu appearance and building
local crittersText, landText, flyingText, waterText, mountstable, critterstable, temp = {}, {}, {}, {}, {}, {}, {} -- tables that will be reused
local buildtable = { -- this table contains information that we will use for building and rebuilding menus as well as hiding menus
	["CRITTER"] = {token = "Critter", text = crittersText, settings = LivestockSettings.Critters},
	["LAND"] = {token = "Land", text = landText, settings = LivestockSettings.Mounts},
	["FLYING"] = { token = "Flying", text = flyingText, settings = LivestockSettings.Mounts},
	["WATER"] = { token = "Water", text = waterText, settings = LivestockSettings.Mounts},
	}
local menuLength = 45
local buttonHeight = 15

local sayings = {
	"Please... no more...",
	"Can I get a new master?",
	"Why did I sign up for this gig?",
	"*HRRRRKKK*",
	"Only you can prevent animal vomit!",
	"We are not amused.",
	"Great job, spin doctor.",
	"You spin me right round,\nbaby right round...",
	"PLEASE put the button back in the box!!",
	"So... dizzy...",
	"You expecting me to\ntake off or something?",
	"Animal cruelty detected.\nContacting PETA... please hold.",
	"Does your mother know you treat\nanimals like this?",
	"Don't you have quests\nto do or something?",
	"I think you're a bit confused.  He said\n'spell rotation' NOT 'pet rotation!'",
	"Stop this thing, I want a refund!",
	"When I can see straight again, I'm\nreporting you for being mean.",
	"OK, OK!  I'm sorry I\npeed in your backpack!",
	}

CreateFrame("GameTooltip","LivestockTooltip",UIParent,"GameTooltipTemplate") -- Build our own tooltip to use for scanning.

--Event handlers:
	
function Livestock.OnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Livestock" then
		for k, v in pairs(defaults) do
			if not LivestockSettings[k] then
				if k == "version" then -- clear mounts/critters if version detect is missing
					LivestockSettings.Critters = {}
					LivestockSettings.Mounts = {}
				end
				LivestockSettings[k] = v
			end
		end
		if LivestockSettings.version < defaults.version then
			LivestockSettings.Critters = {}
			LivestockSettings.Mounts = {}
			LivestockSettings.version = defaults.version
		end
		for k, v in pairs(LivestockSettings) do
			if not defaults[k] then
				LivestockSettings[k] = nil
			end
		end-- syncs the saved variables to match the structure of the defaults.  Keys in the defaults not in the SV will be added from the defaults.  Keys in the SV not in the defaults will be set to nil.
		currentcritter = 1
		hooksecurefunc("MoveForwardStart", Livestock.MoveSummon) -- hooking forward movement to summon a critter if the player has selected the correct option.
		hooksecurefunc("MoveBackwardStart", Livestock.MoveSummon) -- backward movement
		hooksecurefunc("TurnLeftStart", Livestock.MoveSummon) -- turning left
		hooksecurefunc("TurnRightStart", Livestock.MoveSummon) -- turning right
		hooksecurefunc("ToggleAutoRun", Livestock.MoveSummon) -- auto-run
		hooksecurefunc("TurnOrActionStart", Livestock.MoveSummon) -- right-click
		hooksecurefunc("CameraOrSelectOrMoveStart", Livestock.MoveSummon) -- left-click
		
		Livestock.companionFrame:RegisterEvent("COMPANION_LEARNED")
		Livestock.companionFrame:RegisterEvent("PET_JOURNAL_PET_DELETED")
		Livestock.companionFrame:RegisterEvent("UPDATE_SUMMONPETS_ACTION")
	elseif event == "PLAYER_ENTERING_WORLD" then
		if not createdMaps then
			Livestock.CreateStateMaps(LivestockComboButton)
			createdMaps = true
		end
	end
end

function Livestock.CompanionEvent(self, event, ...)
	local unit, spell, rank = ...
	
--	if event == "PET_JOURNAL_LIST_UPDATE" or event == "COMPANION_LEARNED" or event == "PET_JOURNAL_PET_DELETED" or event == "UPDATE_SUMMONPETS_ACTION" then print(event) end

	if event == "PLAYER_LOGIN" then -- when the player logs in, make sure the map is set right for Smart Detection and sort out the companions
		local numPets, numOwned = C_PetJournal.GetNumPets(true)
		if numOwned == 0 then
			donotsummon = true
		end
		SetMapToCurrentZone()
		class = select(2, UnitClass("player"))
		return
	elseif event == "COMPANION_LEARNED" or event == "PET_JOURNAL_PET_DELETED" or event == "UPDATE_SUMMONPETS_ACTION" then -- when a new companion is learned, sort out the companions again and then rebuild the three menus
		Livestock.RenumberCompanions()
		Livestock.RebuildMenu("CRITTER")
		Livestock.RebuildMenu("LAND")
		Livestock.RebuildMenu("FLYING")
		Livestock.RebuildMenu("WATER")
		return
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		if unit == "player" then
			if spell == L.LIVESTOCK_SPELL_STEALTH or spell == L.LIVESTOCK_SPELL_PROWL or spell == L.LIVESTOCK_SPELL_FEIGNDEATH or 
			   spell == L.LIVESTOCK_SPELL_VANISH or spell == L.LIVESTOCK_SPELL_SHADOWMELD then
				if LivestockSettings.dismissonstealth == 1 then
					if LivestockSettings.PVPdismiss == 0 then
						Livestock.DismissCritter()
					elseif UnitIsPVP("player") then
						Livestock.DismissCritter()
					end
				end
			elseif spell == L.LIVESTOCK_SPELL_CAMOUFLAGE or spell == L.LIVESTOCK_SPELL_INVISIBILITY then
				self:RegisterEvent("UNIT_AURA")				
			elseif spell == L.LIVESTOCK_SPELL_CRUSADERAURA and LivestockSettings.crusadermount == 1 and not IsMounted() then
				Livestock.RenumberCompanions()
				if Livestock.LandOrFlying() == "FLYING" then
					Livestock.PickFlyingMount()
				else
					Livestock.PickLandMount()
				end
			elseif (spell == L.LIVESTOCK_SPELL_FLIGHTFORM or spell == L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) and LivestockSettings.dismisspetonmount == 1 then
				Livestock.DismissCritter()
			end
		end
		return
	elseif event == "UNIT_AURA" and unit == "player" then
		if C_PetJournal.GetSummonedPetGUID() == nil then
			self:UnregisterEvent("UNIT_AURA")
		elseif LivestockSettings.dismissonstealth == 1 and Recompense.CheckBuffsAgainstTable(hiddenBuffs) then
			if LivestockSettings.PVPdismiss == 0 then
				Livestock.DismissCritter()
			elseif UnitIsPVP("player") then
				Livestock.DismissCritter()
			end
		end
		return
	elseif event == "UNIT_SPELLCAST_SENT" then
		if unit == "player" then
			if spell == "Living Flare" then
				donotsummon = true
			end
		end
		return
	elseif event == "UI_INFO_MESSAGE" then
		if ... == "Legion Gateway Destroyed (Complete)" then
			donotsummon = nil
		end
		return
	elseif event == "UNIT_ENTERED_VEHICLE" then
		if unit == "player" and LivestockSettings.dismisspetonmount == 1 then
			Livestock.DismissCritter()
		end
	end
end

-- Menu creation:

function Livestock.BuildMenu(kind) -- type is a string, either "CRITTER", "LAND", "FLYING", or "WATER"
	local token, texttable = buildtable[kind].token, buildtable[kind].text -- buildtable contains references and variables that are specific to each type of menu, indexed by the same string as the variable type
	local settings, mounts, critters, MENUS = LivestockSettings.Mounts
	local lastCritter = nil
	
	Livestock.RecycleTable(mountstable)
	Livestock.RecycleTable(critterstable)
	Livestock.RecycleTable(texttable)
	
	if kind == "CRITTER" then
		critters = 0 -- reset critters to 0 so we can start counting critters
		settings = LivestockSettings.Critters
		for k in orderedPairs(settings) do -- Check the list of critters, increment critters, and add the index of the critters to critterstable
			if k ~= lastCritter then -- filter out duplicates
				critters = critters + 1
				tinsert(critterstable, settings[k].index)
				lastCritter = k
			end
		end
		NUMBER_OF_CRITTER_MENUS = math.ceil( critters / menuLength ) -- break the number of critters into groups of menuLength
		MENUS = NUMBER_OF_CRITTER_MENUS -- make the local MENUS equal to the constant
		
	elseif kind == "LAND" then
		mounts = 0 -- reset mounts to 0 so we can start counting land mounts
		for k in orderedPairs(settings) do -- Check the list of mounts, pull out fast land mounts (or slow ones if the filter lets them through), increment mounts, and add the index of the mounts to mountstable
			if (settings[k].type == "land") then
				mounts = mounts + 1
				tinsert(mountstable, settings[k].index)
			end
		end
		NUMBER_OF_LAND_MENUS = math.ceil( mounts / menuLength ) -- break land mounts into groups of menuLength
		MENUS = NUMBER_OF_LAND_MENUS -- same as above

	elseif kind == "FLYING" then -- code is the same for flying mounts with the appropriate changes; perhaps this could be a function call?
		mounts = 0
		for k in orderedPairs(settings) do
			if (settings[k].type == "flying") then
				mounts = mounts + 1
				tinsert(mountstable, settings[k].index)
			end
		end
		NUMBER_OF_FLYING_MENUS = math.ceil( mounts / menuLength)
		MENUS = NUMBER_OF_FLYING_MENUS --  same as above
		
	elseif kind == "WATER" then -- code is the same for water mounts with the appropriate changes; perhaps this could be a function call?
		mounts = 0
		for k in orderedPairs(settings) do
			if (settings[k].type == "water") then
				mounts = mounts + 1
				tinsert(mountstable, settings[k].index)
			end
		end
		NUMBER_OF_WATER_MENUS = math.ceil( mounts / menuLength)
		MENUS = NUMBER_OF_WATER_MENUS --  same as above
	end
	
	
	for currentMenu = 1, MENUS do -- iterate over however many menus we're going to need
	
		local menuframe = _G["Livestock"..token.."Menu"..currentMenu] or CreateFrame("Frame","Livestock"..token.."Menu"..currentMenu, LivestockMenuFrame, "LivestockBlueFrameTemplate") -- make the background of the menu (or reference it if it already exists), naming it with the proper token and number
		menuframe:SetID(currentMenu) -- associate the number of the menu with the frame in a way that's unrelated to the name
		
		if currentMenu == 1 then -- if this is the first menu in a group, we need to parent it to the button that called it
			local header
			if kind == "CRITTER" then
				header = "LivestockCritterMenuButton"
			elseif kind == "LAND" then
				header = "LivestockLandMountMenuButton"
			elseif kind == "FLYING" then
				header = "LivestockFlyingMountMenuButton"
			elseif kind == "WATER" then
				header = "LivestockWaterMountMenuButton"
			end
			menuframe:SetPoint("TOPLEFT", header ,"BOTTOMLEFT",0,-10) -- set the first menu to appear below the associated button
		else
			local lastmenu = "Livestock"..token.."Menu"..(currentMenu-1)
			menuframe:SetPoint("TOPLEFT",lastmenu,"TOPRIGHT",3,0)  -- set other menus to appear to the right of the previous menu
		end
		
		if currentMenu == 1 and MENUS > 1 then  -- if there's more than 1 menu and this is the first menu, we'll have menuLength animals, 1 "More", and Check / Uncheck All
			menuframe:SetHeight(((menuLength + 3) * buttonHeight) + 21)
		elseif currentMenu ~= MENUS then -- the middle menus need menuLength + 1 blocks total (menuLength animals, 1 More)
			menuframe:SetHeight(((menuLength + 1) * buttonHeight) + 21)
		elseif MENUS > 1 then -- the last menu , which doesn't have check / uncheck all, depends on the number of companions.  If it's a multiple of menuLength, we need menuLength buttons.  If not, it depends on how many there are
			if (mounts or critters) % menuLength ~= 0 then
				menuframe:SetHeight(((mounts or critters) % menuLength * buttonHeight) + 21)
			else
				menuframe:SetHeight(menuLength * buttonHeight + 21)
			end
		else -- there's only one menu, so no "More", but check and uncheck are needed
			menuframe:SetHeight((((mounts or critters) + 2) * buttonHeight) + 21)
		end
		
		local endButton -- this is the number of buttons in the menu...
		
		if currentMenu ~= MENUS then
			endButton = menuLength -- menuLength if it's not the last menu
		elseif MENUS > 1 then
			if (mounts or critters) % menuLength ~= 0 then
				endButton = (mounts or critters) % menuLength -- last menu will be the remainder from the other groups of menuLength if its not a multiple of menuLength
			else
				endButton = menuLength -- if it is a multiple of menuLength, then there will be menuLength buttons in the last menu
			end
		elseif MENUS == 1 then
			endButton = (mounts or critters) -- if there's only one menu, it has the number of mounts or critters in it
		end
			
		local maxWidth = 100 -- default width of the buttons
			
		for button = 1, endButton do -- iterate over the buttons we need
			local menubutton = _G["Livestock"..token.."Menu"..currentMenu.."Button"..button] or CreateFrame("Button", "Livestock"..token.."Menu"..currentMenu.."Button"..button, menuframe, "LivestockMenuButtonTemplate") -- create or reference the button, with the appropriate name and number
			menubutton:Show()
			local text = _G["Livestock"..token.."Menu"..currentMenu.."Button"..button.."Text"] -- reference the text of the button
			
			local name, creatureID, _
			if kind == "CRITTER" then
				_, _, _, _, _, _, _, name, _, _, creatureID = C_PetJournal.GetPetInfoByIndex(critterstable[(currentMenu - 1) * menuLength + button])
			elseif kind == "LAND" or kind == "FLYING" or kind == "WATER" then
				creatureID, name = GetCompanionInfo("MOUNT", mountstable[(currentMenu - 1) * menuLength + button] )
			end -- get the ID and name of the companion for the button by mapping the position of the button in the menus(s) to the index of the companion

			if name and creatureID then
				menubutton.critterID = creatureID 
				menubutton.which = "toggle"..kind
				menubutton.name = name  -- associate the info for the companion with the frame itself to be used for mousing over / clicking

				if text then
					if text.SetText ~= nil then
						text:SetText(name)
					end
					tinsert(texttable, text) -- set the text of the button to reflect the name of the companion, and store the fontstring itself in a table of fontstrings
				end
			end
			
			if name and kind == "LAND" then
				local name2 = strconcat(name, "-")
				if settings[name2] then
					name = name2
				end
			end

			if name and text and settings[name].show == 1 then -- if the name isn't nil (Blizzard bug sometimes returns nil for companion names >:o) and the settings say this companion is selected then
				if text.SetTextColor ~= nil then
					text:SetTextColor(1, 1, 1) -- set the color of the text to be white
				end
			elseif name and text then
				if text.SetTextColor ~= nil then
					text:SetTextColor(0.4, 0.4, 0.4) -- otherwise set the color to be grey
				end
			elseif not name then -- debug message if the name is nil
				local which, index
				local creatureID, creatureName, spellID
				local numPets, numOwned = C_PetJournal.GetNumPets(true)
				if mounts then 
					which = "MOUNT"
					index = mountstable[(currentMenu - 1) * menuLength + button]
					creatureID, creatureName, spellID = GetCompanionInfo(which, index)
					DEFAULT_CHAT_FRAME:AddMessage("Max "..kind.." "..which.." is " .. (mounts or "nil"))
				else
					which = "CRITTER"
					index = critterstable[(currentMenu - 1) * menuLength + button]
					spellID, _, _, _, _, _, _, creatureName, _, _, creatureID = C_PetJournal.GetPetInfoByIndex(critterstable[(currentMenu - 1) * menuLength + button])
					DEFAULT_CHAT_FRAME:AddMessage("Max "..which.." is " .. (critters or "nil"))
				end
				DEFAULT_CHAT_FRAME:AddMessage(string.format("Error for "..which.." %u at menu build, ID: %s, name: %s, spellID: %s", index, (creatureID or "nil"), (creatureName or "nil"), (spellID or "nil")))
			end
			
			menubutton:SetHeight(buttonHeight) -- give the button a height
			if button == 1 then -- parent it to the menu's TOPLEFT corner if it's the first button, else underneath the previous button
				menubutton:SetPoint("TOPLEFT", menuframe, "TOPLEFT", 20, -10)
			else
				menubutton:SetPoint("TOPLEFT", _G[menuframe:GetName().."Button"..(button - 1)], "BOTTOMLEFT")
			end

			if button == endButton and token and currentMenu then -- set all the buttons to have the same width as the widest button.  Do this by iterating over the buttons, getting the width of their text, and then setting the buttons' width to be the width of the text plus a cushion of 50
				for i = 1, endButton do
					local textWidth = 0
					if _G["Livestock"..token.."Menu"..currentMenu.."Button"..i.."Text"].GetWidth ~= nil then
						textWidth = _G["Livestock"..token.."Menu"..currentMenu.."Button"..i.."Text"]:GetWidth()
					else
						textWidth = maxWidth
					end
					if textWidth > maxWidth then
						maxWidth = textWidth + 20
					end
				end
				for i = 1, endButton do
					if _G["Livestock"..token.."Menu"..currentMenu.."Button"..i].SetWidth ~= nil then
						_G["Livestock"..token.."Menu"..currentMenu.."Button"..i]:SetWidth(maxWidth)
					end
				end
			end
			menuframe:SetWidth(maxWidth + 30) -- bump up the size of the menu frame background to compensate and make sure the border and background look nice
		end
		
		if currentMenu ~= MENUS then -- if we're not at the last menu, we need a "More" button
			local moreframe = _G["Livestock"..token.."Menu"..currentMenu.."MoreButton"] or CreateFrame("Button", "Livestock"..token.."Menu"..currentMenu.."MoreButton", _G["Livestock"..token.."Menu"..currentMenu], "LivestockMenuButtonTemplate") --  reference or create the button
			moreframe:SetHeight(buttonHeight)
			moreframe:SetWidth(maxWidth) -- height and width match those of the other buttons
			local t = _G[moreframe:GetName().."Text"]
			t:SetText(L.LIVESTOCK_MENU_MORE)
			moreframe:SetPoint("TOPLEFT", "Livestock"..token.."Menu"..currentMenu.."Button"..endButton, "BOTTOMLEFT") -- stick it underneath the last button in the menu
			moreframe.which = "more"..kind -- associate a string with the frame to use for mouseover
		end
		
		if currentMenu == 1 then -- the first menu needs "Select all / none" buttons
			local check = _G["Livestock"..token.."MenuCheckButton"] or CreateFrame("Button", "Livestock"..token.."MenuCheckButton", _G["Livestock"..token.."Menu1"], "LivestockMenuButtonTemplate")
			check.which = "check"..kind
			local uncheck = _G["Livestock"..token.."MenuUncheckButton"] or CreateFrame("Button", "Livestock"..token.."MenuUncheckButton", _G["Livestock"..token.."Menu1"], "LivestockMenuButtonTemplate")
			uncheck.which = "uncheck"..kind
			check:SetHeight(buttonHeight)
			check:SetWidth(maxWidth)
			uncheck:SetHeight(buttonHeight)
			uncheck:SetWidth(maxWidth) -- reference them or make them, show them, set their heights and widths, associate info with the frame, etc.
			_G[check:GetName().."Text"]:SetText(L.LIVESTOCK_MENU_SELECTALL)
			_G[check:GetName().."Text"]:SetTextColor(1, 1, 0)
			_G[uncheck:GetName().."Text"]:SetText(L.LIVESTOCK_MENU_SELECTNONE)
			_G[uncheck:GetName().."Text"]:SetTextColor(1, 1, 0) -- set their text and color (yellow to stand out)
			if _G["Livestock"..token.."Menu1MoreButton"] then -- if the first menu has a More button, stick the Check All button under the More button.  Otherwise, stick it under the last menu button.
				check:SetPoint("TOPLEFT", _G["Livestock"..token.."Menu1MoreButton"], "BOTTOMLEFT")
			else
				check:SetPoint("TOPLEFT", _G["Livestock"..token.."Menu1Button"..endButton], "BOTTOMLEFT")
			end
			uncheck:SetPoint("TOPLEFT", check, "BOTTOMLEFT") -- stick the Uncheck All button under the Check All button... and we're done!
		end
	end
end

function Livestock.BuildMenus() -- call the build menu function on all three menus to initialize them
	Livestock.BuildMenu("CRITTER")
	Livestock.BuildMenu("LAND")
	Livestock.BuildMenu("FLYING")
	Livestock.BuildMenu("WATER")
end

function Livestock.RebuildMenu(kind) -- the menus change when you learn new companions, so we need to rebuild them occasionally.  kind is a string as before, either "CRITTER", "LAND", "FLYING", or "WATER"
 
	for i = 1, 8 do  -- iterate over 8 menus, which is definitely more than we need right now
		for j = 1, menuLength do -- it's easiest just to assume menuLength animals in each menu and break when there aren't than to see how many animals there actually are
			if _G["Livestock"..buildtable[kind].token.."Menu"..i.."Button"..j] then -- if the button exists, then hide it
				_G["Livestock"..buildtable[kind].token.."Menu"..i.."Button"..j]:Hide()
			else -- if it doesn't exist, we are out of animals and should stop looping
				break
			end
		end
		if _G["Livestock"..buildtable[kind].token.."Menu"..i] then
			_G["Livestock"..buildtable[kind].token.."Menu"..i]:Hide() -- once all the buttons are hidden, check to see if the menu exists.  if it does, hide it as well.  If not, stop looping.
		else
			break
		end
	end
	
	Livestock.BuildMenu(kind) -- call BuildMenu to create the new button, adjust the old ones, resize things if needed, create a new menu if needed, etc.
	
end

-- GUI functions:

function Livestock.RestoreUI(self, elapsed)
	if InCombatLockdown() then return end
-- UI elements in tables to make it easier to set up.  It's not good to declare these inside a function, but the variables aren't available the right way until after the UI loads so this function needs to have the tables declared here.
	local buttonstable = {
	["LivestockSmartButton"] = LivestockSettings.showsmart,
	["LivestockCrittersButton"] = LivestockSettings.showcritter,
	["LivestockLandMountsButton"] = LivestockSettings.showland,
	["LivestockFlyingMountsButton"] = LivestockSettings.showflying,
	}

	local checkstable = {
	["LivestockMainPreferencesFrameShowSmartMounts"] = LivestockSettings.showsmart,
	["LivestockMainPreferencesFrameShowCritters"] = LivestockSettings.showcritter,
	["LivestockMainPreferencesFrameShowLandMounts"] = LivestockSettings.showland,
	["LivestockMainPreferencesFrameShowFlyingMounts"] = LivestockSettings.showflying,
	--["LivestockMainPreferencesFrameShowSlowLandMounts"] = LivestockSettings.useslowland,
	--["LivestockMainPreferencesFrameShowSlowFlyingMounts"] = LivestockSettings.useslowflight,
	["LivestockPetPreferencesFrameToggleAutosummon"] = LivestockSettings.summononmove,
	["LivestockPetPreferencesFrameToggleAutosummonFavorite"] = LivestockSettings.summonfaveonmove,
	["LivestockPetPreferencesFrameRestrictAutoSummonOnPVP"] = LivestockSettings.restrictautosummon,
	["LivestockPetPreferencesFrameIgnorePVPRestrictionInInstances"] = LivestockSettings.ignorepvprestrictionininstances,
	["LivestockPetPreferencesFrameRestrictAutoSummonOnRaid"] = LivestockSettings.donotsummoninraid,
	["LivestockPetPreferencesFrameDismissPetOnMount"] = LivestockSettings.dismisspetonmount,
	["LivestockSmartPreferencesFrameToggleDruidLogic"] = LivestockSettings.druidlogic,
	["LivestockSmartPreferencesFrameToggleWorgenLogic"] = LivestockSettings.worgenlogic,
	["LivestockSmartPreferencesFrameToggleSafeFlying"] = LivestockSettings.safeflying,
	["LivestockPetPreferencesFrameToggleDismissOnStealth"] = LivestockSettings.dismissonstealth,
	["LivestockPetPreferencesFrameToggleDismissOnStealthPVPOnly"] = LivestockSettings.PVPdismiss,
	["LivestockSmartPreferencesFrameToggleMountInStealth"] = LivestockSettings.mountinstealth,
	["LivestockSmartPreferencesFrameToggleSmartCatForm"] = LivestockSettings.smartcatform,
	["LivestockSmartPreferencesFrameToggleWaterWalking"] = LivestockSettings.waterwalking,
	["LivestockSmartPreferencesFrameToggleCombatForms"] = LivestockSettings.combatforms,
	["LivestockSmartPreferencesFrameToggleMovingForms"] = LivestockSettings.movingform,
	["LivestockSmartPreferencesFrameToggleCrusaderMount"] = LivestockSettings.crusadermount,
	["LivestockSmartPreferencesFrameIndoorHunterAspects"] = LivestockSettings.indooraspects,
	["LivestockSmartPreferencesFrameMovingHunterAspects"] = LivestockSettings.movingaspects,
	["LivestockSmartPreferencesFrameGroupHunterAspects"] = LivestockSettings.groupaspects,
	["LivestockSmartPreferencesFrameSlowFallWhileFalling"] = LivestockSettings.slowfall,
	["LivestockSmartPreferencesFrameMoonkin"] = LivestockSettings.moonkin,
	["LivestockPetPreferencesFrameNewPet"] = LivestockSettings.newpet,
	}

	for k, v in pairs(buttonstable) do -- show and scale each of the buttons if its setting is saved as 1 (shown)
		if v == 1 then
			_G[k]:Show()
			_G[k]:SetScale(LivestockSettings.scale)
		end
	end
	
	for k, v in pairs(checkstable) do -- check each box if its setting is saved as 1 (checked)
		if v == 1 then
			_G[k]:SetChecked(true)
		end
	end
	
	for k, v in pairs(stringstable) do -- localize the fontstrings in the GUI
		_G[k]:SetText(v)
	end
	
	if LivestockSettings.summononmove == 0 then
		LivestockSettings.summononmove = 1
		Livestock.ClickedAutoSummon()
	end
	
	if class ~= "DRUID" and class ~= "SHAMAN" then
		LivestockSmartPreferencesFrameToggleCombatFormsText:SetTextColor(0.4, 0.4, 0.4)
		LivestockSmartPreferencesFrameToggleMovingFormsText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if class ~= "DRUID" then -- Gray out the text for the druid-only options if the player isn't a druid.  The disabling of the button is done in the buttons' OnLoad scripts.
		LivestockSmartPreferencesFrameDruidToggleText:SetTextColor(0.4, 0.4, 0.4)
		LivestockSmartPreferencesFrameSmartCatFormText:SetTextColor(0.4, 0.4, 0.4)
		LivestockSmartPreferencesFrameMoonkinText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if class ~= "HUNTER" then
		LivestockSmartPreferencesFrameIndoorHunterAspectsText:SetTextColor(0.4, 0.4, 0.4)
		LivestockSmartPreferencesFrameMovingHunterAspectsText:SetTextColor(0.4, 0.4, 0.4)
		LivestockSmartPreferencesFrameGroupHunterAspectsText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if class ~= "MAGE" and class ~= "PRIEST" then
		LivestockSmartPreferencesFrameSlowFallWhileFallingText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	local text = format(L.LIVESTOCK_FONTSTRING_WATERWALKINGLABEL, (class == "PRIEST" and L.LIVESTOCK_SPELL_LEVITATE) or (class == "DEATHKNIGHT" and L.LIVESTOCK_SPELL_PATHOFFROST) or L.LIVESTOCK_SPELL_WATERWALKING)
	LivestockSmartPreferencesFrameToggleWaterWalkingText:SetText(text)

	if class ~= "SHAMAN" and class ~= "DEATHKNIGHT" and class ~= "PRIEST" then
		LivestockSmartPreferencesFrameToggleWaterWalkingText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if class ~= "PALADIN" then
		LivestockSmartPreferencesFrameToggleCrusaderMountText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	local race = select(2, UnitRace("player"))
	
	if race ~= "Worgen" then
		LivestockSmartPreferencesFrameWorgenToggleText:SetTextColor(0.4, 0.4, 0.4)
	end

	if (not LivestockPetPreferencesFrameToggleDismissOnStealth:IsEnabled() ) or LivestockSettings.dismissonstealth == 0 then
		LivestockPetPreferencesFrameToggleDismissOnStealthPVPOnly:Disable()
		LivestockPetPreferencesFramePVPDismissText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if LivestockSettings.favoritepet == 0 then
		LivestockPetPreferencesFrameToggleAutosummonFavorite:Disable()
		LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if LivestockSettings.restrictautosummon == 0 then
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstances:Disable()
		LivestockPetPreferencesFrameIgnorePVPRestrictionInInstancesText:SetTextColor(0.4, 0.4, 0.4)
	end
	
	if LivestockSettings.summononmove == 1 then
		donotsummon = nil
	end

	self:Hide()
end

function Livestock.HideDropdowns() --  hide all the visible dropdown menus
	for k in pairs(buildtable) do
		for j = 1, 8 do -- the number of menus may change per type, but it's certainly not more than 8
			if _G["Livestock"..buildtable[k].token.."Menu"..j] and _G["Livestock"..buildtable[k].token.."Menu"..j]:IsVisible() then
				_G["Livestock"..buildtable[k].token.."Menu"..j]:Hide()
			end
		end
	end
end

function Livestock.HeaderButtonOnClick(token) -- when we click a main menu button, we should hide all dropdowns (so they don't overlap) and show the relevant menu, but only if it wasn't visible in the first place.  This lets the buttons act as true toggles.
	Livestock.RenumberCompanions()
	Livestock.BuildMenus()

	local menu, visible = _G["Livestock"..token.."Menu1"]
	if menu and menu:IsVisible() then
		visible = true
	end
	Livestock.HideDropdowns()
	if menu and not visible then
		menu:Show()
	end
end

function Livestock.MenuButtonOnClick(self, button) -- self is the button clicked on, button is the mouse button used

	local action, companionType = strmatch(self.which, "(%l+)"), strmatch(self.which, "(%u+)") -- since the buttons come with a string attached that is of the format "actionTYPE" where action is the function of the button and TYPE is the capitalized animal type, this declaration breaks them apart into two again
	local settings
	
	if companionType == "CRITTER" then
		settings = LivestockSettings.Critters
	else
		settings = LivestockSettings.Mounts
	end
	
	if action == "toggle" then -- if this is a toggle type button then
	
		local name, text = self.name, _G[self:GetName().."Text"] -- name was associated with the frame to be the name of the animal inside, and text is a reference to the text string of the button
		
		if button == "RightButton" and companionType == "CRITTER" then -- Right-clicking a pet in the menu makes it the favorite pet.
			Livestock.MakeFavoritePet(name)
			return
		end
		
		if companionType == "LAND" and name then
			local name2 = strconcat(name, "-")
			if settings[name2] then
				name = name2
			end
		end
		settings[name].show = 1 - settings[name].show -- toggle the shown setting
		if settings[name].show == 1 then
			text:SetTextColor(1, 1, 1)
		else
			text:SetTextColor(0.4, 0.4, 0.4) --  color the fontstring according to the new setting
		end
		
	elseif action == "check" then -- if this is a "check all" button
		
		for k in pairs(settings) do -- if these are critters or if the mounts in the settings have the same type as the companionType, lowercased (either "land" or "flying") then toggle them on
			if companionType == "CRITTER" then
				settings[k].show = 1
			end
			if companionType == "WATER" and settings[k].type == "water" then
				settings[k].show = 1
			end
			if companionType == "LAND" and settings[k].type == "land" then
				settings[k].show = 1
			end
			if companionType == "FLYING" and settings[k].type == "flying" then
				settings[k].show = 1
			end
		end
		for _, v in ipairs(buildtable[companionType].text) do -- iterate over the fontstrings and set them all to white
			v:SetTextColor(1, 1, 1)
		end
		
	elseif action == "uncheck" then --  otherwise it should be an "uncheck all" button
		
		for k in pairs(settings) do -- if these or critters or if the mounts in the settings have the same type as the companionType, lowercased (either "land" or "flying") then toggle them on
			if companionType == "CRITTER" then
				settings[k].show = 0
			end
			if companionType == "WATER" and settings[k].type == "water" then
				settings[k].show = 0
			end
			if companionType == "LAND" and settings[k].type == "land" then
				settings[k].show = 0
			end
			if companionType == "FLYING" and settings[k].type == "flying" then
				settings[k].show = 0
			end
		end
		for _, v in ipairs(buildtable[companionType].text) do -- iterate over the fontstrings and set them all to grey
			v:SetTextColor(0.4, 0.4, 0.4)
		end
	end
end

function Livestock.MenuButtonOnDoubleClick(self)
	local action, companionType = strmatch(self.which, "(%l+)"), strmatch(self.which, "(%u+)")
	local settings = (companionType == "CRITTER" and LivestockSettings.Critters) or LivestockSettings.Mounts
	if action == "toggle" then
		local index = settings[self.name].index
		local petID = settings[self.name].petID
		if companionType == "CRITTER" then
			C_PetJournal.SummonPetByGUID(petID)
		else
			CallCompanion("MOUNT", index)
		end
	end
	Livestock.MenuButtonOnClick(self, "LeftButton")
end

function Livestock.MenuButtonOnEnter(self) -- code for mousing over a menu button.  self is the menu button
	local which = self.which --  "which" was a string associated with the button
	
	if strsub(which, 1, 6) == "toggle" then -- if this is a toggle button, when we mouseover, we should show the 3D model if the viewer is visible
		local id = self.critterID -- the id of the creature was associated with the button when the menu was built
		if LivestockModel:IsVisible() then
			LivestockModel:SetCreature(id)
			LivestockModel.angle = 0.71
		end
	
	elseif strsub(which, 1, 4) == "more" then -- if this is a more button, mousing over needs to show the next menu
		_G["Livestock"..buildtable[strsub(which, 5, strlen(which))].token.."Menu"..(self:GetParent():GetID() + 1)]:Show() -- find the menu associated with the button by getting its parent, adding 1 to the number of the menu, and then showing the resulting menu.  The table reference looks up the right token for the name of the menu based on the end of the "which" string
	end
end

function Livestock.ClickedAutoSummon()
	LivestockSettings.summononmove = 1 - LivestockSettings.summononmove
	if LivestockSettings.summononmove == 0 then
		LivestockPetPreferencesFrameToggleAutosummonFavorite:Disable()
		LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText:SetTextColor(0.4, 0.4, 0.4)
		LivestockPetPreferencesFrameRestrictAutoSummonOnPVP:Disable()
		LivestockPetPreferencesFrameRestrictAutoSummonOnPVPText:SetTextColor(0.4, 0.4, 0.4)
		LivestockPetPreferencesFrameRestrictAutoSummonOnRaid:Disable()
		LivestockPetPreferencesFrameRestrictAutoSummonOnRaidText:SetTextColor(0.4, 0.4, 0.4)
		LivestockPetPreferencesFrameDismissPetOnMount:Disable()
		LivestockPetPreferencesFrameDismissPetOnMountText:SetTextColor(0.4, 0.4, 0.4)
		donotsummon = true
	elseif LivestockSettings.favoritepet ~= 0 then
		LivestockPetPreferencesFrameToggleAutosummonFavorite:Enable()
		LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText:SetTextColor(1, 1, 1)
	end
	if LivestockSettings.summononmove == 1 then
		LivestockPetPreferencesFrameRestrictAutoSummonOnPVP:Enable()
		LivestockPetPreferencesFrameRestrictAutoSummonOnPVPText:SetTextColor(1, 1, 1)
		LivestockPetPreferencesFrameRestrictAutoSummonOnRaid:Enable()
		LivestockPetPreferencesFrameRestrictAutoSummonOnRaidText:SetTextColor(1, 1, 1)
		LivestockPetPreferencesFrameDismissPetOnMount:Enable()
		LivestockPetPreferencesFrameDismissPetOnMountText:SetTextColor(1, 1, 1)
		donotsummon = nil
	end
end

function Livestock.SpinModel(self, elapsed) -- this is the OnUpdate script for the model
	local angle = self.angle or 0.71
	modelcounter = modelcounter + elapsed
	if modelcounter > 0.05 then
		angle = angle + LivestockSpinSlider:GetValue()
		self:SetFacing(angle)
		modelcounter = 0
	end
	self.angle = angle
end  -- while the frame is visible, this code uses a counter to keep track of the total time the frame was last redrawn.  Every 0.05 sec, the model rotates according to the value established by the slider in the viewer

function Livestock.SpinSliderChanged(self) -- easter egg text to show up when you drag the 3D model spin slider so far over it "escapes" the box
	if self:GetValue() > 0.623 and (not eastereggtext) then -- if the slider is dragged above the appropriate value and there's no easteregg text shown
		Livestock.HideDropdowns() -- hide the menus or else the cursor ends up going into one of them which changes the model
		eastereggtext = true
		LivestockEasterEgg:Show()
		LivestockEasterEgg:SetText(sayings[random(#sayings)])
	elseif self:GetValue() < 0.623 then
		LivestockEasterEgg:Hide()
		eastereggtext = nil
	end
end

function Livestock.ScaleButtons(value) -- scale the buttons and reset them to their default positions
	if not LivestockCrittersButton then -- this script fires before the buttons are set, so return early if that's the case
		return
	end
	LivestockSettings.scale = value
	LivestockCrittersButton:SetScale(value)
	LivestockCrittersButton:ClearAllPoints()
	LivestockCrittersButton:SetPoint("CENTER",-50,-150)
	LivestockLandMountsButton:ClearAllPoints()
	LivestockLandMountsButton:SetScale(value)
	LivestockLandMountsButton:SetPoint("CENTER",0,-150)
	LivestockFlyingMountsButton:ClearAllPoints()
	LivestockFlyingMountsButton:SetScale(value)
	LivestockFlyingMountsButton:SetPoint("CENTER",50,-150)
	LivestockSmartButton:ClearAllPoints()
	LivestockSmartButton:SetScale(value)
	LivestockSmartButton:SetPoint("CENTER",0,-190)
end

-- Data functions

function Livestock.RecycleTable(table)
	for k in pairs(table) do
		table[k] = nil
	end
end

function Livestock.CreateStateMaps(self)

--	Smart mounting depends on 6 variables - mounted status, indoors/outdoors status, combat status, flyable/noflyable status, and two user settings that are relevant for druids only.
--	The first four can be handled with a state map, and while they have 16 possible combinations, there are really only 6 relevant outcomes for Smart Mounting from these combinations.  The following states are handled by the "smartmap" state:

--	7:  In Flight Form:  Druids in flight form need to check against the safe flight setting to see if they should be canceling their flight form.
--	6:  Swimming:  Swimming takes precedence over all other settings.  Druids use Aquatic Form in this case, and shaman can select to use Water Walking.
--	1:  Indoors.  Should do nothing unless the player is a druid and wants to turn into a cat (or a hunter and wants to use aspect of the pact)
--	2:  Mounted:  Should dismount.  This will get checked later against the safe flight setting to see if the player is flying and shouldn't dismount.
--	3:  In Combat:  Should do nothing, unless the player is a druid or a shaman or a hunter, in which case they should cast Travel Form or Ghost Wolf or AOTC if the combat forms option is selected.
--	4:  Flyable area, not in combat:  Should summon a random flying mount, with the possibility of druids shifting into flight forms.  If a druid is in a form, they need to cancel it if they're not shifting into a flight form.
--	5:  Non-flyable area, not in combat;  Should summon a random land mount.  If a druid is in a form, they need to cancel it.

--	To handle the form canceling, there is also a "form" map which tracks the druid's current form.  (Non-druids change forms as well but these form changes don't affect their ability to CallCompanion() )

--	These attributes are set at runtime to transfer settings and localization strings from tables where they can't be accessed in the secure handler to attributes of the secure button where they can be.
--	Note that druid forms may change, as feral druids only have 5 forms and others can have 6.  "form5" and "form6" attempt to figure out which forms are actually present to be able to cancel them effectively.

	self:SetAttribute("catform", LivestockSettings.smartcatform)
	self:SetAttribute("druidlogic", LivestockSettings.druidlogic)
	self:SetAttribute("worgenlogic", LivestockSettings.worgenlogic)
	self:SetAttribute("playerclass", select(2, UnitClass("player")))
	self:SetAttribute("flightspell", GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_FLIGHTFORM) or "nil")
	self:SetAttribute("bearspell", GetSpellInfo(L.LIVESTOCK_SPELL_DIREBEARFORM) or L.LIVESTOCK_SPELL_BEARFORM)
	self:SetAttribute("form5", GetSpellInfo(L.LIVESTOCK_SPELL_TREEOFLIFE) or GetSpellInfo(L.LIVESTOCK_SPELL_MOONKINFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_FLIGHTFORM) or "nil")
	self:SetAttribute("form6", ( GetSpellInfo(L.LIVESTOCK_SPELL_TREEOFLIFE) or GetSpellInfo(L.LIVESTOCK_SPELL_MOONKINFORM) ) and (GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_FLIGHTFORM)))
	self:SetAttribute("sealspell", L.LIVESTOCK_SPELL_AQUATICFORM)
	self:SetAttribute("catspell", L.LIVESTOCK_SPELL_CATFORM)
	self:SetAttribute("travelspell", L.LIVESTOCK_SPELL_TRAVELFORM)
	self:SetAttribute("wolfspell", L.LIVESTOCK_SPELL_GHOSTWOLF)
	self:SetAttribute("moonkinspell", L.LIVESTOCK_SPELL_MOONKINFORM)
	self:SetAttribute("waterwalking", (class == "SHAMAN" and L.LIVESTOCK_SPELL_WATERWALKING) or (class == "PRIEST" and L.LIVESTOCK_SPELL_LEVITATE) or (class == "DEATHKNIGHT" and L.LIVESTOCK_SPELL_PATHOFFROST))
	self:SetAttribute("aotc", L.LIVESTOCK_SPELL_CHEETAH)
	self:SetAttribute("aotp", GetSpellInfo(L.LIVESTOCK_SPELL_PACK) and L.LIVESTOCK_SPELL_PACK)
	self:SetAttribute("waterwalkingtoggle", LivestockSettings.waterwalking)
	self:SetAttribute("combatformstoggle", LivestockSettings.combatforms)
	self:SetAttribute("indooraspects", LivestockSettings.indooraspects)
	self:SetAttribute("safeflying", LivestockSettings.safeflying)
	self:SetAttribute("mountinstealth", LivestockSettings.mountinstealth)
	self:SetAttribute("movingform", LivestockSettings.movingform)
	self:SetAttribute("movingaspects", LivestockSettings.movingaspects)
	self:SetAttribute("groupaspects", LivestockSettings.groupaspects)
	self:SetAttribute("moonkin", LivestockSettings.moonkin)
	
--	Wrap the following script to occur when the attribute of the ComboButton changes.  This will happen whenever the user toggles a setting, changes forms, or adjusts their indoor/outdoor, swimming, combat, flyable, or mounted status.
--	Essentially, it changes the button to have different behaviors according to the classification above of the states.  It also sets a flag in the button's mounttype attribute that indicates whether the PostClick handler should summon a mount or not.
--	When druids change forms, the state is updated again with the same information, but the updated form info is taken into account.  This allows for smart mounting to effectively cancel the form that was just cast because the type is usually set to cast the form spell that was just cast.

	SecureHandlerWrapScript(self, "OnAttributeChanged", self, [[
	local class, catform, druidlogic, bearspell, flightspell, sealspell, catspell, travelspell, wolfspell, worgenlogic = self:GetAttribute("playerclass"), self:GetAttribute("catform"), self:GetAttribute("druidlogic"), self:GetAttribute("bearspell"), self:GetAttribute("flightspell"), self:GetAttribute("sealspell"), self:GetAttribute("catspell"), self:GetAttribute("travelspell"), self:GetAttribute("wolfspell"), self:GetAttribute("worgenlogic")
	local waterwalkingspell = self:GetAttribute("waterwalking")
	local waterwalkingtoggle = self:GetAttribute("waterwalkingtoggle")
	local combatformstoggle = self:GetAttribute("combatformstoggle")
	local safeflying = self:GetAttribute("safeflying")
	local mountinstealth = self:GetAttribute("mountinstealth")
	local indooraspects = self:GetAttribute("indooraspects")
	local movingform = self:GetAttribute("movingform")
	local movingaspects = self:GetAttribute("movingaspects")
	local groupaspects = self:GetAttribute("groupaspects")
	local moonkinspell = self:GetAttribute("moonkinspell")
	local moonkin = self:GetAttribute("moonkin")
	
	if name == "state-form" or name == "catform" or name == "druidlogic" or name == "worgenlogic" or name == "waterwalkingtoggle" or name == "combatformstoggle" or name == "indooraspects" 
	   or name == "safeflying" or name == "mountinstealth" or name == "movingform" or name == "movingaspects" or name == "groupaspects" or name == "moonkin" then
		self:SetAttribute("state-smartmap",self:GetAttribute("state-smartmap"))
		
	elseif name == "state-smartmap" then
		self:SetAttribute("type", nil)
		self:SetAttribute("spell", nil)
		if value == 1 then
			if class == "DRUID" then
				if catform == 1 then
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", catspell)
				end
			elseif class == "HUNTER" then
				if indooraspects == 1 then
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", ((PlayerInGroup() and groupaspects == 0 and self:GetAttribute("aotp")) or self:GetAttribute("aotc")))
				end
			elseif class == "SHAMAN" then
				if movingform == 1 then
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", wolfspell)
				end
			end
		elseif value == 2 then
			self:SetAttribute("type", "macro")
			self:SetAttribute("macrotext", "/run Livestock.Dismount()")
			self:SetAttribute("mounttype", nil)
		elseif value == 3 then
			if class == "DRUID" and combatformstoggle == 1 then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", "/cast !"..travelspell)
			elseif class == "SHAMAN" and combatformstoggle == 1 then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", wolfspell)
			end
			self:SetAttribute("mounttype", nil)
		elseif value == 4 or value == 5 then
			if class == "DRUID" then
				local spell
				if GetShapeshiftForm() == 1 then
					spell = bearspell
				elseif GetShapeshiftForm() == 3 then
					spell = catspell
				elseif GetShapeshiftForm() == 4 then
					spell = travelspell
				elseif GetShapeshiftForm() == 5 then
					spell = self:GetAttribute("form5")
				elseif GetShapeshiftForm() == 6 then
					spell = self:GetAttribute("form6")
				end
				if spell and spell ~= moonkinspell then
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", spell)
				end
			end
		elseif value == 6 then
			if class == "DRUID" then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", sealspell)
			elseif tonumber(waterwalkingtoggle) == 1 and (class == "SHAMAN" or class == "PRIEST" or class == "DEATHKNIGHT") then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", waterwalkingspell)
				self:SetAttribute("unit", "player")
			elseif IsMounted() then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", "/run Livestock.Dismount()")
				self:SetAttribute("mounttype", nil)
			end
		elseif value == 7 then
			if class == "DRUID" and safeflying == 1 then
				self:SetAttribute("type", nil)
				self:SetAttribute("spell", nil)
			elseif class == "DRUID" then
				self:SetAttribute("type", "spell")
				if moonkin == 1 then
					self:SetAttribute("spell", moonkinspell)
				else
					self:SetAttribute("spell", flightspell)
				end
			end
		end
	end
	
	]])

	RegisterStateDriver(self, "smartmap", "[form:6] 7; [swimming] 6; [indoors, nomounted] 1; [noindoors, mounted] 2; [combat, noindoors, nomounted] 3; [nocombat, noindoors, nomounted, flyable] 4; [nocombat, noindoors, nomounted, noflyable] 5")
	RegisterStateDriver(self, "form", "[form:1] 1; [form:2] 2; [form:3] 3; [form:4] 4; [form:5] 5; [form:6] 6; 0")
end

function Livestock.RenumberCompanions() -- because the game does not distinguish between learning a new mount or a new critter, it's safest just to redo both indices
	local numPets, numOwned = C_PetJournal.GetNumPets(true)

	Livestock.RecycleTable(mountstable)
	Livestock.RecycleTable(critterstable)

	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, false)
	C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_FAVORITES, false)
	C_PetJournal.AddAllPetTypesFilter()
	C_PetJournal.AddAllPetSourcesFilter()
	C_PetJournal.ClearSearchFilter()

	for i = 1, numOwned do
		local petID, _, _, _, _, _, _, name = C_PetJournal.GetPetInfoByIndex(i)
		if name and not LivestockSettings.Critters[name] then -- sometimes Blizzard's code returns nil for the name.  If we have a valid name but no associated data in the SV, then we need to add it.
			if petID and C_PetJournal.PetIsSummonable(petID) then
				LivestockSettings.Critters[name] = { -- save the index and set the default show value to on
					show = 1,
					index = i,
					petID = petID,
				}
				if LivestockSettings.newpet == 1 then
					LivestockSettings.Critters[name].show = 0
				end
				critterstable[name] = true
				print(format(L.LIVESTOCK_INTERFACE_ADD, name))
			end
		elseif name then -- if there is a valid name, then make sure the index matches up because indices change when you learn a new companion
			if petID then
				local health = C_PetJournal.GetPetStats(petID)
				if C_PetJournal.PetIsSummonable(petID) or (not C_PetJournal.PetIsSummonable(petID) and health <= 0) then
					LivestockSettings.Critters[name].index = i
					LivestockSettings.Critters[name].petID = petID
					critterstable[name] = true
				end
			end
		else --  debug message if the name is returned as nil
			critterfail = true
			return
		end
	end

	-- cleanup any critters that got deleted
	for name, v in pairs(LivestockSettings.Critters) do
		if not critterstable[name] then
			LivestockSettings.Critters[name] = nil
			print(format(L.LIVESTOCK_INTERFACE_REMOVE, name))
		end
	end
		
	for i = 1, GetNumCompanions("MOUNT") do
		local _, name, spellID, _, _, mountFlags = GetCompanionInfo("MOUNT",i)
		if name and not LivestockSettings.Mounts[name] then -- if the name is valid and we don't have SV data for it, we need to make it
			local name2 = strconcat(name, "-")
			LivestockSettings.Mounts[name] = { -- save the index and set the default show value to on
				show = 1,
				index = i,
				spellID = spellID,
			}
			mountstable[name] = true
			print(format(L.LIVESTOCK_INTERFACE_ADD, name))
			
			--[[ mountFlags explanation
				Ground 0x01
				Fly 0x02
				Float 0x04
				Underwater 0x08
				Jump 0x10
				
				Flying mounts = 7
				Water mounts = 12
				Sandstone Drake = 15
				Multi-purpose that can't swim = 23 (Red Flying Cloud and possibly others)
				Ground mounts = 29 (includes swimming turtles)
				Multi-purpose = 31
			]]

			if mountFlags == 7 or mountFlags == 15 then -- flying mount
				LivestockSettings.Mounts[name].type = "flying"
			elseif mountFlags == 31 or mountFlags == 23 then -- variable
				LivestockSettings.Mounts[name].type = "flying"
				LivestockSettings.Mounts[name2] = { 
					show = 1,
					index = i,
					type = "land",
					spellID = spellID,
				}
				mountstable[name2] = true
			elseif mountFlags == 12 then -- water
				LivestockSettings.Mounts[name].type = "water"
			elseif mountFlags == 29 then -- otherwise, a land mount
				LivestockSettings.Mounts[name].type = "land"
				-- swimming turtle exception
				if spellID == 30174 or spellID == 64731 then
					LivestockSettings.Mounts[name].type = "water"
				end
			else
				print(format(L.LIVESTOCK_INTERFACE_UNKNOWN, name, mountFlags))
			end
		elseif name then -- if we do have SV data for it, update the index
			local name2 = strconcat(name, "-")
			LivestockSettings.Mounts[name].index = i
			LivestockSettings.Mounts[name].spellID = spellID
			mountstable[name] = true
			if LivestockSettings.Mounts[name2] then
				LivestockSettings.Mounts[name2].index = i
				LivestockSettings.Mounts[name2].spellID = spellID
				mountstable[name2] = true
			end
		else
			mountfail = true
			return
		end
	end

	-- cleanup any mounts that got deleted
	for name, v in pairs(LivestockSettings.Mounts) do
		if not mountstable[name] then
			LivestockSettings.Mounts[name] = nil
			print(format(L.LIVESTOCK_INTERFACE_REMOVE, name))
		end
	end
		
end

function Livestock.LandOrFlying() -- since [flyable] has been fixed, check for flying and CWF and fly unless you're in WG and there's a battle going on.

	SetMapToCurrentZone() -- make sure that the map accurately reflects the zone you're in
	local continent = GetCurrentMapContinent()
	local flightForm = GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_FLIGHTFORM)
	local _,_,_,expertRiding = GetAchievementInfo(890) -- Expert Riding achievement
	local CWF = IsUsableSpell(54197) -- Cold Weather Flying
	local mflying = IsUsableSpell(90267) -- flight master's license
	local pandaFlying = IsUsableSpell(115913) -- Wisdom of the Four Winds

	if continent == L.LIVESTOCK_CONTINENT_OUTLAND then -- if we're in Outland
		if (expertRiding or flightForm) and IsFlyableArea() then
			return "FLYING"
		else
			return "LAND"
		end
	elseif continent == L.LIVESTOCK_CONTINENT_NORTHREND then -- if we're in Northrend
		if IsFlyableArea() then
			local zone = GetZoneText() -- Check the zone
			if not CWF then -- no CWF means no flying
				return "LAND"
			end
			local _, _, isActive = GetWorldPVPAreaInfo(1)
			return ((zone == L.LIVESTOCK_ZONE_WINTERGRASP and isActive == true) and "LAND") or "FLYING" -- check to see if a battle is in progress and if so, we're on a land mount.  If not, flying mount.and if so, we're on a land mount.  If not, flying mount.
		else
			return "LAND"
		end
	elseif continent == L.LIVESTOCK_CONTINENT_PANDARIA then -- if we're in Pandaria
		if IsFlyableArea() and pandaFlying then
			return "FLYING"
		else
			return "LAND"
		end
	else -- we are in azeroth
		if IsFlyableArea() and mflying then -- have flight master's license and in flyable area
			return "FLYING"
		else
			return "LAND" -- anywhere else we should get a land mount.
		end
	end
end

function Livestock.SmartPreClick(self)
	
	local state = self:GetAttribute("state-smartmap")
	local race = select(2, UnitRace("player"))

	if (debug) then
		print(format("PREDEBUG: '%s' is mount-type, state is '%d'", self.mounttype or "nil", self:GetAttribute("state-smartmap")))
	end

	if not InCombatLockdown() then
		if IsFalling() and LivestockSettings.slowfall == 1 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", (class == "PRIEST" and L.LIVESTOCK_SPELL_LEVITATE) or L.LIVESTOCK_SPELL_SLOWFALL)
			self:SetAttribute("unit", "player")
			return
		end
		if class == "SHAMAN" then -- Clear out Ghost Wolf from combat if it's there
			if not IsIndoors() and self:GetAttribute("spell") == L.LIVESTOCK_SPELL_GHOSTWOLF then
				self:SetAttribute("spell", nil)
			end
		elseif (class == "PRIEST" or class == "DEATHKNIGHT") and state ~= 6 then -- clear out any possible remnant of underwater spells if we're out of the water.  No need to compare to the spell because these classes only ever have one spell in their Smart Button.
			if self:GetAttribute("spell") then
				self:SetAttribute("spell", nil)
			end
		elseif class == "HUNTER" then -- clear out Aspects if we're not inside
			if not IsIndoors() and self:GetAttribute("spell") then
				self:SetAttribute("spell", nil)
			end
		end
	end

	if state == 1 then
		if class == "SHAMAN" then
			if LivestockSettings.movingform == 1 and GetUnitSpeed("player") ~= 0 then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", L.LIVESTOCK_SPELL_GHOSTWOLF)
				self.mounttype = nil
				self.clearmovingform = true
			end
		end
	elseif state == 2 then --  if mounted, clear out any mounted attributes and return, which will lead to a dismount (in the Click handler) and nothing in the PostClick.  Druids go to flight form if they have it.
		self.mounttype = nil
		if class == "DRUID" and not InCombatLockdown() and Livestock.LandOrFlying() == "FLYING" and LivestockSettings.druidlogic == 1 then
			if GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or GetSpellInfo(L.LIVESTOCK_SPELL_FLIGHTFORM) then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM or L.LIVESTOCK_SPELL_FLIGHTFORM)
			end
		end
		return
	
	elseif state == 3 then -- maybe in combat
		if not InCombatLockdown() then
			self.mounttype = Livestock.LandOrFlying()
		
			if LivestockSettings.movingaspects == 1 and GetUnitSpeed("player") ~= 0 then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", (GetNumGroupMembers() ~= 0 and LivestockSettings.groupaspects == 0 and GetSpellInfo(L.LIVESTOCK_SPELL_PACK) and L.LIVESTOCK_SPELL_PACK) or L.LIVESTOCK_SPELL_CHEETAH)
				self.mounttype = nil
			end
		
			if LivestockSettings.dismisspetonmount == 1 and self.mounttype == "FLYING" then
				Livestock.DismissCritter()
			end
		end
		
	elseif state == 4 then -- handle "flyable" areas

		self.mounttype = Livestock.LandOrFlying()
		
		if LivestockSettings.movingaspects == 1 and GetUnitSpeed("player") ~= 0 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", (GetNumGroupMembers() ~= 0 and LivestockSettings.groupaspects == 0 and GetSpellInfo(L.LIVESTOCK_SPELL_PACK) and L.LIVESTOCK_SPELL_PACK) or L.LIVESTOCK_SPELL_CHEETAH)
			self.mounttype = nil
		end
		
		if LivestockSettings.dismisspetonmount == 1 and self.mounttype == "FLYING" then
			Livestock.DismissCritter()
		end
		
		if class == "SHAMAN" then
			if LivestockSettings.movingform == 1 and GetUnitSpeed("player") ~= 0 then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", L.LIVESTOCK_SPELL_GHOSTWOLF)
				self.mounttype = nil
				self.clearmovingform = true
				return
			end
		end

		if class == "DRUID" then
			if LivestockSettings.movingform == 1 and GetUnitSpeed("player") ~= 0 then
				if self.mounttype == "LAND" or (self.mounttype == "FLYING" and LivestockSettings.druidlogic == 0) then
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", L.LIVESTOCK_SPELL_TRAVELFORM)
					self.mounttype = nil
					self.clearmovingform = true
					return
				end
			end

			if LivestockSettings.druidlogic == 1 and self.mounttype == "FLYING" then
				self:SetAttribute("type", "spell")
				self:SetAttribute("spell", GetSpellInfo(L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM) or L.LIVESTOCK_SPELL_FLIGHTFORM)
				self.mounttype = nil
			end
		end

		if self.mounttype == "LAND" and race == "Worgen" and LivestockSettings.worgenlogic == 1 and GetUnitSpeed("player") == 0 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", L.LIVESTOCK_SPELL_RUNNINGWILD)
			self.mounttype = nil
		end
		
	elseif state == 5 then -- if in a land area, set the button to mount a land mount or possibly cast an instant travel form spell
		local _, _, isActive = GetWorldPVPAreaInfo(1)
		if LivestockSettings.movingform == 1 and GetUnitSpeed("player") ~= 0 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", (class == "SHAMAN" and L.LIVESTOCK_SPELL_GHOSTWOLF) or L.LIVESTOCK_SPELL_TRAVELFORM)
			self.clearmovingform = true
		elseif LivestockSettings.movingaspects == 1 and GetUnitSpeed("player") ~= 0 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", (GetNumGroupMembers() ~= 0 and LivestockSettings.groupaspects == 0 and GetSpellInfo(L.LIVESTOCK_SPELL_PACK) and L.LIVESTOCK_SPELL_PACK) or L.LIVESTOCK_SPELL_CHEETAH)
		elseif race == "Worgen" and LivestockSettings.worgenlogic == 1 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", L.LIVESTOCK_SPELL_RUNNINGWILD)
			self.mounttype = nil
		elseif (GetZoneText() == L.LIVESTOCK_ZONE_WINTERGRASP and isActive == false) then
			self.mounttype = "FLYING"		
		else
			self.mounttype = "LAND"
		end
		return
		
	elseif state == 6 then -- swimming
		self.mounttype = "WATER"
	
	elseif state == 7 then -- flight form
		if LivestockSettings.moonkin == 1 and LivestockSettings.safeflying == 0 then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", L.LIVESTOCK_SPELL_MOONKINFORM)
			self.mounttype = nil
		end
	
	end
end

function Livestock.SmartPostClick(self)

	if (debug) then
		print(format("POSTDEBUG: '%s' is mount-type, state is '%d'", self.mounttype or "nil", self:GetAttribute("state-smartmap")))
	end

	if Recompense.CheckBuffsAgainstTable(hiddenBuffs) and LivestockSettings.mountinstealth == 0 then -- respect the setting to not mount in stealth
		return
	end
	
	if self.mounttype then
		Livestock.RenumberCompanions()
		if self.mounttype == "LAND" then
			Livestock.PickLandMount()
		elseif self.mounttype == "WATER" then
			Livestock.PickWaterMount()
		else
			Livestock.PickFlyingMount()
		end
	end
	
	self.mounttype = nil
	
	if self.clearmovingform then
		self.clearmovingform = nil
		self:SetAttribute("type", nil)
		self:SetAttribute("spell", nil)
		self:SetAttribute("macrotext", nil)
	end
	
end

function Livestock.NonSmartPreClick(self)

	local race = select(2, UnitRace("player"))

	if IsFlying() and LivestockSettings.safeflying == 1 then -- trying to summon a land or flying mount in the air should fail to set any attributes and not flag anything for summoning.  No smush deaths.
		return
	end
	
	if IsMounted() then -- if we're mounted or in a vehicle, dismount / get out and don't set any attributes or flag anything for summoning.  No dismount only to try and resummon.
		Dismount()
		return
	elseif UnitInVehicle("player") then
		VehicleExit()
		return
	elseif InCombatLockdown() then -- get out of this function if we can't set attributes, because we can't mount in combat anyway.  We've already dismounted by this point.
		return
	end
	
	if ( IsStealthed() and LivestockSettings.mountinstealth == 0 ) then -- respect the setting to not mount up if you're stealthed
		return
	end
	
	if IsIndoors() then -- can't mount indoors, and this isn't smart mount
		return
	end

	if strfind(self:GetName(), "Flying") then  -- now that dismounting is out of the way, we can assume we need to summon a mount.  Attach the kind of mount needed to the button.
		self.typeofmount = "flying"
		if LivestockSettings.dismisspetonmount == 1 then
			Livestock.DismissCritter()
		end
	else
		self.typeofmount = "land"
	end
	
	if class == "SHAMAN" then
		local buffs, name = 0
		repeat
			buffs = buffs + 1
			name = UnitBuff("player", buffs)
		until not name or name == L.LIVESTOCK_SPELL_GHOSTWOLF
		if name then -- name will be the name of the form at this point
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell",name) -- by casting the spell that we had on in the first place, we effectively remove the spell.
		end
	end
	
	if class == "DRUID" then -- see if we need to cancel a form to summon a mount.
		local buffs, name = 0
		repeat
			buffs = buffs + 1
			name = UnitBuff("player", buffs)
		until not name or name == L.LIVESTOCK_SPELL_BEARFORM or name == L.LIVESTOCK_SPELL_DIREBEARFORM or name == L.LIVESTOCK_SPELL_CATFORM or name == L.LIVESTOCK_SPELL_TRAVELFORM or name == L.LIVESTOCK_SPELL_TREEOFLIFE or name == L.LIVESTOCK_SPELL_FLIGHTFORM or name == L.LIVESTOCK_SPELL_SWIFTFLIGHTFORM
		if name then -- name will be the name of the form at this point
			self:SetAttribute("type","spell")
			self:SetAttribute("spell",name) -- by casting the spell that we had on in the first place, we effectively remove the spell.
		end
	end

	if self.typeofmount == "land" and race == "Worgen" and LivestockSettings.worgenlogic == 1 and GetUnitSpeed("player") == 0 then
		self:SetAttribute("type", "spell")
		self:SetAttribute("spell", L.LIVESTOCK_SPELL_RUNNINGWILD)
		self.typeofmount = nil
	end
end

function Livestock.NonSmartPostClick(self)
	if InCombatLockdown() then -- exit setting attributes if we're in combat.  Past here is mounting code, which can't be done in combat anyway.
		return
	end
	
	if self.typeofmount then -- summon the relevant mount
		Livestock.RenumberCompanions()
		if self.typeofmount == "land" then
			Livestock.PickLandMount()
		elseif self.typeofmount == "flying" then
			Livestock.PickFlyingMount()
		end
		self.typeofmount = nil -- clear the mount flag
	end
	
	self:SetAttribute("type", nil) -- clear the attributes of the button in case they were used
	self:SetAttribute("spell", nil)
	
end

function Livestock.MakeFavoritePet(name)
	LivestockSettings.favoritepet = name
	print(format(L.LIVESTOCK_INTERFACE_LISTFAVEPET, LivestockSettings.favoritepet))
	LivestockPetPreferencesFrameToggleAutosummonFavorite:Enable()
	LivestockPetPreferencesFrameAutoSummonOnMoveFavoriteText:SetTextColor(1, 1, 1)
end

function Livestock.AddToZone(which, item, fromDrag)
	local where = (which == "zone") and GetRealZoneText() or GetSubZoneText()
	if item == "whatpet" or item == "whatmount" then
		local whatKind = (item == "whatpet" and "critter") or "mount"
		if LivestockSettings.Zones[where] and LivestockSettings.Zones[where][whatKind] then
			print(format(L.LIVESTOCK_INTERFACE_DISPLAYZONEPET, LivestockSettings.Zones[where][whatKind], whatKind == "mount" and "mount" or "pet", which, where))
			return
		else
			print(format(L.LIVESTOCK_INTERFACE_NOZONEPET, (whatKind == "mount" and "mount" or "pet"), which, where))
			return
		end
	elseif item == "nomount" or item == "nopet" then
		print(format(L.LIVESTOCK_INTERFACE_CONFIRMZONEREMOVE, item:match("no(.+)"), which, where))
		if LivestockSettings.Zones[where] then
			LivestockSettings.Zones[where][item:match("no(.+)") == "pet" and "critter" or "mount"] = nil
			Livestock.UpdateZoneTexts()
		end
		return
	elseif (not item:match("%[(.+)%]") and not fromDrag) then
		print(L.LIVESTOCK_INTERFACE_USEITEMLINK)
		return
	end
	if not fromDrag then
		item = item:match("%[(.+)%]")
	end
	if not (LivestockSettings.Critters[item] or LivestockSettings.Mounts[item]) then
		print(format(L.LIVESTOCK_INTERFACE_HAVENOTLEARNED, item))
		return
	end
	local whatKind = (LivestockSettings.Critters[item] and "critter") or "mount"
	if not LivestockSettings.Zones[where] then
		LivestockSettings.Zones[where] = {}
	end
	LivestockSettings.Zones[where][whatKind] = item
	print(format(L.LIVESTOCK_INTERFACE_CONFIRMZONEADD, item, whatKind, which, where))
	Livestock.UpdateZoneTexts(fromDrag)
end

-- Summon functions

function Livestock.PickCritter()
	local shown = 0
	
	Livestock.RecycleTable(temp)
	
	for k in pairs(LivestockSettings.Critters) do -- go through all the critters
		if LivestockSettings.Critters[k].show == 1 and LivestockSettings.Critters[k].petID ~= C_PetJournal.GetSummonedPetGUID() then
			tinsert(temp, LivestockSettings.Critters[k].petID) -- if a critter is marked as selected and it's NOT currently out in the game world, add its petID to the temp table
		elseif LivestockSettings.Critters[k].show == 1 then
			shown = shown + 1 -- count the total number of critters marked as selected
		end
	end
	
	if #temp == 0 and shown ~= 1 then -- if there are no critters in the list AND the number of critters selected isn't 1, then there must be 0 critters selected.  Prompt user to select some.
		print(L.LIVESTOCK_INTERFACE_NOCRITTERSCHECKED)
	elseif #temp ~= 0 then -- otherwise, there are some critters in the list.
		currentcritter = temp[random(#temp)] -- set the newest critter to be one of the random indices among those in the temp table.
		C_PetJournal.SummonPetByGUID(currentcritter) -- call the critter
	end
end

function Livestock.DismissCritter()
	if debug then
		print("Dismissing your current critter.")
	end
	if C_PetJournal.GetSummonedPetGUID() then
		C_PetJournal.SummonPetByGUID(C_PetJournal.GetSummonedPetGUID())
	end
end

function Livestock.SummonFavoritePet()
	if LivestockSettings.favoritepet ~= 0 then
		C_PetJournal.SummonPetByGUID(LivestockSettings.Critters[LivestockSettings.favoritepet].petID)
	else
		print(L.LIVESTOCK_INTERFACE_NOFAVEPET)
	end
end

function Livestock.PickLandMount()
	local engineeringLevel = Livestock.GetProfSkillLevel(L.LIVESTOCK_SKILL_ENGR)
	local tailoringLevel = Livestock.GetProfSkillLevel(L.LIVESTOCK_SKILL_TAILOR)
	local serpentFlying = IsUsableSpell(130487) -- Cloud Serpent Riding

	SetMapToCurrentZone()
	local zoneID = GetCurrentMapAreaID()

	if IsMounted() and ( not IsFlying() or LivestockSettings.safeflying == 0 ) then -- if we're already mounted and NOT flying (no accidents, please!) then dismount and don't pick another mount
		Dismount()
		return
	end
	
	if UnitInVehicle("player") and not IsFlying() then
		VehicleExit()
		return
	end
	
	if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetSubZoneText()]["mount"]].index)
		return
	elseif LivestockSettings.Zones[GetZoneText()] and LivestockSettings.Zones[GetZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetZoneText()]["mount"]].index)
		return
	end

	Livestock.RecycleTable(temp)

	for k in pairs(LivestockSettings.Mounts) do -- go through the land mounts and add the ones that are selected to the temp table
		if (LivestockSettings.Mounts[k].type == "land") and LivestockSettings.Mounts[k].show == 1 then
			if LivestockSettings.Mounts[k].spellID == 61451 and tailoringLevel < 300 then
				-- don't try to use the Flying Carpet
			elseif (LivestockSettings.Mounts[k].spellID == 61309 or 
				LivestockSettings.Mounts[k].spellID == 75596) and tailoringLevel < 425 then
				-- don't try to use the Magnificent Flying Carpet or Frosty Flying Carpet
			elseif LivestockSettings.Mounts[k].spellID == 44153 and engineeringLevel < 300 then
				-- don't try to use the Flying Machine
			elseif LivestockSettings.Mounts[k].spellID == 44151 and engineeringLevel < 375 then
				-- don't try to use the Turbo-Charged Flying Machine
			elseif (LivestockSettings.Mounts[k].spellID == 25953 or
				LivestockSettings.Mounts[k].spellID == 26056 or
				LivestockSettings.Mounts[k].spellID == 26054 or
				LivestockSettings.Mounts[k].spellID == 26055) and zoneID ~= 766 then
				-- don't try to use the AQ40 mounts
			elseif (LivestockSettings.Mounts[k].spellID == 127170 or
				LivestockSettings.Mounts[k].spellID == 123992 or
				LivestockSettings.Mounts[k].spellID == 127156 or
				LivestockSettings.Mounts[k].spellID == 123993 or
				LivestockSettings.Mounts[k].spellID == 127169 or
				LivestockSettings.Mounts[k].spellID == 127161 or
				LivestockSettings.Mounts[k].spellID == 127164 or
				LivestockSettings.Mounts[k].spellID == 127165 or
				LivestockSettings.Mounts[k].spellID == 127158 or
				LivestockSettings.Mounts[k].spellID == 113199 or
				LivestockSettings.Mounts[k].spellID == 127154 or
				LivestockSettings.Mounts[k].spellID == 129918 or
				LivestockSettings.Mounts[k].spellID == 124408 or
				LivestockSettings.Mounts[k].spellID == 132036) and not serpentFlying then
				-- don't try to use the cloud serpent mounts
			else
				tinsert(temp, LivestockSettings.Mounts[k].index)
			end
		end
	end
	
	if #temp == 0 then -- if no mounts are selected, prompt the user to select one
		print(L.LIVESTOCK_INTERFACE_NOLANDMOUNTSCHECKED)
		return
	end
	
	if (debug) then
		local number = temp[random(#temp)]
		local _, creatureName = GetCompanionInfo("MOUNT",number)
		print(format("MOUNT: '%s' is mount-index, land mount is '%s'", number, creatureName))
		CallCompanion("MOUNT",number) -- call a random mount
	else
		CallCompanion("MOUNT",temp[random(#temp)]) -- call a random mount
	end
end

function Livestock.PickFlyingMount()
	local engineeringLevel = Livestock.GetProfSkillLevel(L.LIVESTOCK_SKILL_ENGR)
	local tailoringLevel = Livestock.GetProfSkillLevel(L.LIVESTOCK_SKILL_TAILOR)
	local serpentFlying = IsUsableSpell(130487) -- Cloud Serpent Riding

	if IsFlying() and LivestockSettings.safeflying == 1 then -- if we're already flying, don't do anything; if we're not and mounted, we're on the ground on a flying mount so dismount instead of summoning another mount
		return
	elseif IsMounted() then
		Dismount()
		return
	elseif UnitInVehicle("player") then
		VehicleExit()
		return
	end
	
	if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetSubZoneText()]["mount"]].index)
		return
	elseif LivestockSettings.Zones[GetZoneText()] and LivestockSettings.Zones[GetZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetZoneText()]["mount"]].index)
		return
	end
	
	Livestock.RecycleTable(temp)

	for k in pairs(LivestockSettings.Mounts) do -- go through the flying mounts and add the ones that are selected to the temp table
		if (LivestockSettings.Mounts[k].type == "flying") and LivestockSettings.Mounts[k].show == 1 then
			if LivestockSettings.Mounts[k].spellID == 61451 and tailoringLevel < 300 then
				-- don't try to use the Flying Carpet
			elseif (LivestockSettings.Mounts[k].spellID == 61309 or 
				LivestockSettings.Mounts[k].spellID == 75596) and tailoringLevel < 425 then
				-- don't try to use the Magnificent Flying Carpet or Frosty Flying Carpet
			elseif LivestockSettings.Mounts[k].spellID == 44153 and engineeringLevel < 300 then
				-- don't try to use the Flying Machine
			elseif LivestockSettings.Mounts[k].spellID == 44151 and engineeringLevel < 375 then
				-- don't try to use the Turbo-Charged Flying Machine
			elseif (LivestockSettings.Mounts[k].spellID == 127170 or
				LivestockSettings.Mounts[k].spellID == 123992 or
				LivestockSettings.Mounts[k].spellID == 127156 or
				LivestockSettings.Mounts[k].spellID == 123993 or
				LivestockSettings.Mounts[k].spellID == 127169 or
				LivestockSettings.Mounts[k].spellID == 127161 or
				LivestockSettings.Mounts[k].spellID == 127164 or
				LivestockSettings.Mounts[k].spellID == 127165 or
				LivestockSettings.Mounts[k].spellID == 127158 or
				LivestockSettings.Mounts[k].spellID == 113199 or
				LivestockSettings.Mounts[k].spellID == 127154 or
				LivestockSettings.Mounts[k].spellID == 129918 or
				LivestockSettings.Mounts[k].spellID == 124408 or
				LivestockSettings.Mounts[k].spellID == 132036) and not serpentFlying then
				-- don't try to use the cloud serpent mounts
			else
				tinsert(temp, LivestockSettings.Mounts[k].index)
			end
		end
	end
	
	if #temp == 0 then -- if no mounts are selected, prompt the user to select one (or pick a land mount?)
		Livestock.PickLandMount()
		return
	end
	
	if (debug) then
		local number = temp[random(#temp)]
		local _, creatureName = GetCompanionInfo("MOUNT",number)
		print(format("MOUNT: '%s' is mount-index, flying mount is '%s'", number, creatureName))
		CallCompanion("MOUNT",number) -- call a random mount
	else	
		CallCompanion("MOUNT",temp[random(#temp)]) -- call a random mount
	end
end

function Livestock.PickWaterMount()

	if IsMounted() and ( not IsFlying() or LivestockSettings.safeflying == 0 ) then -- if we're already mounted and NOT flying (no accidents, please!) then dismount and don't pick another mount
		Dismount()
		return
	end
	
	if UnitInVehicle("player") and not IsFlying() then
		VehicleExit()
		return
	end
	
	if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetSubZoneText()]["mount"]].index)
		return
	elseif LivestockSettings.Zones[GetZoneText()] and LivestockSettings.Zones[GetZoneText()]["mount"] then
		CallCompanion("MOUNT", LivestockSettings.Mounts[LivestockSettings.Zones[GetZoneText()]["mount"]].index)
		return
	end

	Livestock.RecycleTable(temp)

	local breath = false
	for count = 1, MIRRORTIMER_NUMTIMERS do
		local timer, _, _, scale = GetMirrorTimerInfo(count)
		if (debug) then
			print(format("Timer = '%s' and value = '%s'", timer, scale))
		end
		if timer == "BREATH" and scale == -1 then
			breath = true
		end
	end

	local spellName = UnitBuff("player", L.LIVESTOCK_SPELL_SEALEGS, nil )

	if (spellName) then
		tinsert(temp, LivestockSettings.Mounts["Abyssal Seahorse"].index)
	elseif (breath == false) then
		if Livestock.LandOrFlying() == "FLYING" then
			Livestock.PickFlyingMount()
		else
			Livestock.PickLandMount()
		end
		return
	else
		for k in pairs(LivestockSettings.Mounts) do -- go through the water mounts and add the ones that are selected to the temp table
			if (LivestockSettings.Mounts[k].type == "water" and LivestockSettings.Mounts[k].show == 1 and k ~= "Abyssal Seahorse") then
				tinsert(temp, LivestockSettings.Mounts[k].index)
			end
		end
	end
	
	if #temp == 0 then -- if no mounts are selected, choose a land mount instead
		Livestock.PickLandMount()
		return
	end
	
	if (debug) then
		local number = temp[random(#temp)]
		local _, creatureName = GetCompanionInfo("MOUNT",number)
		print(format("MOUNT: '%s' is mount-index, land mount is '%s'", number, creatureName))
		CallCompanion("MOUNT",number) -- call a random mount
	else
		CallCompanion("MOUNT",temp[random(#temp)]) -- call a random mount
	end
end

function Livestock.Dismount()

	if UnitIsDeadOrGhost("player") then
		return
	end
	
	if IsFlying() and LivestockSettings.safeflying == 0 then
		Dismount()
		return
	elseif not IsFlying() and IsMounted() then
		Dismount()
		return
	elseif UnitInVehicle("player") and not IsFlying() then
		VehicleExit()
		return
	end
end

function Livestock.MoveSummon() -- idea and code provided by Mikhael of Doomhammer on the WoWInterface forums, modified by Scott Snowman (author).  Checks to see if you have a vanity pet out, and if you don't, it summons one (or your favorite).  Used as a hook on movement functions.
	local numPets, numOwned = C_PetJournal.GetNumPets(true)

	if LivestockSettings.summononmove == 0 or donotsummon or UnitChannelInfo("player") or UnitCastingInfo("player") or IsFalling() or Recompense.CheckBuffsAgainstTable(restrictSummonForTheseBuffs) or Recompense.CheckEquipmentAgainstTable(restrictSummonForThisEquipment) then
		return -- return if the flag to not summon is checked, if you're channeling or casting, or if you have a buff on you that indicates you're in a situation where you shouldn't be summoning.
	else
		if LivestockSettings.restrictautosummon == 1 and UnitIsPVP("player") == 1 then -- if the setting to ignore summoning when flagged is set, then check for PVP status.
			if LivestockSettings.ignorepvprestrictionininstances == 0 then -- if the PVP restriction is absolute, then return from the hook.
				return
			else -- if the option for ignoring in an instance is set, check the instance status to see if we're in a PVE instance.
				local inInstance, instanceType = IsInInstance()
				if not inInstance or instanceType == "arena" or instanceType == "pvp" then
					return
				end
			end
		end
		
		if LivestockSettings.donotsummoninraid == 1 and GetNumGroupMembers() > 0 then
			return
		end
		
		local anyCritterOut
		if ( C_PetJournal.GetSummonedPetGUID() ) then
			anyCritterOut = true
		end

		if anyCritterOut then
			return
		else
			local petID
			if not UnitIsDeadOrGhost("player") and not InCombatLockdown() and not IsMounted() and not IsStealthed() then -- long conditional, only summon if the checkbox is checked (check this first for performance) and not stealthed, mounted, dead, or in combat.
				if (LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()]["critter"]) or (LivestockSettings.Zones[GetZoneText()] and LivestockSettings.Zones[GetZoneText()]["critter"]) then -- check to see if we have pet data for the current zone or subzone
					if LivestockSettings.Zones[GetSubZoneText()] and LivestockSettings.Zones[GetSubZoneText()]["critter"] then
						petID = LivestockSettings.Critters[LivestockSettings.Zones[GetSubZoneText()]["critter"]].petID
					elseif LivestockSettings.Zones[GetZoneText()] and LivestockSettings.Zones[GetZoneText()]["critter"] then
						petID = LivestockSettings.Critters[LivestockSettings.Zones[GetZoneText()]["critter"]].petID
					end
				elseif LivestockSettings.summonfaveonmove == 1 then -- check to see if it's the favorite we want to summon.
					petID = LivestockSettings.Critters[LivestockSettings.favoritepet].petID -- retrieve the petID of the favorite pet
				end
				
				if petID then
					if C_PetJournal.GetSummonedPetGUID() == petID then -- check to see if the favorite / zone pet is summoned already, and summon it if it isn't
						return
					else
						local sound = GetCVar("Sound_EnableSFX")
						SetCVar("Sound_EnableSFX", "0") -- set the sound off after retrieving the sound setting so that error messages don't sound from trying to summon the pet when you can't
						C_PetJournal.SummonPetByGUID(petID) -- summon the favorite
						UIErrorsFrame:Clear() -- clear any error text
						SetCVar("Sound_EnableSFX", sound) -- set the sound setting back to its previous value
					end
				else -- no petID means no favorite or no saved info
					local sound = GetCVar("Sound_EnableSFX")
					SetCVar("Sound_EnableSFX", "0")
					Livestock.PickCritter()
					UIErrorsFrame:Clear()
					SetCVar("Sound_EnableSFX", sound)
				end
			end
		end
	end
end

-- Slash handler

function Livestock.Slash(arg)
	local cmd, args = arg:match("(%S+)%s*(.-)$")
	if cmd == "reset" then -- Clear all the points of the Livestock buttons and set them back to their original locations
		LivestockCrittersButton:ClearAllPoints()
		LivestockCrittersButton:SetPoint("CENTER",-50,-150)
		LivestockLandMountsButton:ClearAllPoints()
		LivestockLandMountsButton:SetPoint("CENTER",0,-150)
		LivestockFlyingMountsButton:ClearAllPoints()
		LivestockFlyingMountsButton:SetPoint("CENTER",50,-150)
		LivestockSmartButton:ClearAllPoints()
		LivestockSmartButton:SetPoint("CENTER",0,-190)
	elseif cmd == "scale" then -- clear all the points of the Livestock buttons, set them back to their original locations, and then set the scale
		LivestockCrittersButton:ClearAllPoints()
		LivestockCrittersButton:SetPoint("CENTER",-50,-150)
		LivestockLandMountsButton:ClearAllPoints()
		LivestockLandMountsButton:SetPoint("CENTER",0,-150)
		LivestockFlyingMountsButton:ClearAllPoints()
		LivestockFlyingMountsButton:SetPoint("CENTER",50,-150)
		LivestockSmartButton:ClearAllPoints()
		LivestockSmartButton:SetPoint("CENTER",0,-190)
		Livestock.ScaleButtons(tonumber(arg:sub(7,13)))
	elseif cmd == "redo" then
		print(L.LIVESTOCK_INTERFACE_RESETSAVEDDATA)
		LivestockSettings.Critters = {}
		LivestockSettings.Mounts = {}
		Livestock.RenumberCompanions()
		Livestock.RebuildMenu("CRITTER")
		Livestock.RebuildMenu("LAND")
		Livestock.RebuildMenu("FLYING")
		Livestock.RebuildMenu("WATER")
	elseif cmd == "zone" or cmd == "subzone" then
		Livestock.AddToZone(cmd, args)
	elseif cmd == "nomount" or cmd == "mount" then
		local i = 1
		while UnitBuff("player", i) do
			local spellName = UnitBuff("player", i)
			if LivestockSettings.Mounts[spellName] then
				if cmd == "nomount" then
					LivestockSettings.Mounts[spellName].show = 0
					print(format(L.LIVESTOCK_INTERFACE_CONFIRMREMOVE, spellName))
				else
					LivestockSettings.Mounts[spellName].show = 1
					print(format(L.LIVESTOCK_INTERFACE_CONFIRMADD, spellName))
				end
				local spellName2 = strconcat(spellName, "-")
				if LivestockSettings.Mounts[spellName2] then
					if cmd == "nomount" then
						LivestockSettings.Mounts[spellName2].show = 0
					else
						LivestockSettings.Mounts[spellName2].show = 1
					end
				end
				return
			end
			i = i + 1
		end
		print(L.LIVESTOCK_INTERFACE_NOMOUNT)
	elseif cmd == "nopet" or cmd == "pet" then
		if C_PetJournal.GetSummonedPetGUID() then
			local _, _, _, _, _, _, _, petName = C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetSummonedPetGUID())
			if cmd == "nopet" then
				LivestockSettings.Critters[petName].show = 0
				print(format(L.LIVESTOCK_INTERFACE_CONFIRMREMOVE, petName))
			else
				LivestockSettings.Critters[petName].show = 1
				print(format(L.LIVESTOCK_INTERFACE_CONFIRMADD, petName))
			end
		else
			print(L.LIVESTOCK_INTERFACE_NOPET)
		end
	elseif cmd == "prefs" then
		InterfaceOptionsFrame:Show() -- bring up the options frame
		InterfaceOptionsFrameTab2:Click() -- click on the Addons tab
		local button = 1
		while _G["InterfaceOptionsFrameAddOnsButton"..button] do
			if _G["InterfaceOptionsFrameAddOnsButton"..button].element.name == "Livestock" then -- search through the buttons, find the one marked Livestock, and click it
				_G["InterfaceOptionsFrameAddOnsButton"..button]:Click()
				break
			end
			button = button + 1
		end
		return
	elseif cmd == "debug" then
		debug = not(debug)
	else -- toggle the Livestock menu frame
		if LivestockMenuFrame:IsVisible() then
			LivestockMenuFrame:Hide()
		else
			LivestockMenuFrame:Show()
		end
	end
end

function Livestock.GetProfSkillLevel(searchname)
	local prof1, prof2 = GetProfessions()
	if prof1 then
		local name, _, rank = GetProfessionInfo(prof1)
		if (name == searchname) then
			return rank
		end
	end

	if prof2 then
		local name, _, rank = GetProfessionInfo(prof2)
		if (name == searchname) then
			return rank
		end
	end
	
	return 0
end

--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a
table.
]]

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end
    -- fetch the next value
    key = nil
    for i = 1,table.getn(t.__orderedIndex) do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

-- Companion Frame declaration and slash handler setup
Livestock.companionFrame = CreateFrame("Frame")
Livestock.companionFrame:RegisterEvent("PLAYER_LOGIN")
Livestock.companionFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
Livestock.companionFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
Livestock.companionFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
Livestock.companionFrame:RegisterEvent("UI_INFO_MESSAGE")
--Livestock.companionFrame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
Livestock.companionFrame:SetScript("OnEvent", Livestock.CompanionEvent)

SLASH_LIVESTOCK1 = LIVESTOCK_INTERFACE_SLASHSTRING
SlashCmdList["LIVESTOCK"] = Livestock.Slash
