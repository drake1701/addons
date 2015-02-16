local L = LibStub("AceLocale-3.0"):GetLocale("WorldBossStatus")
WorldBossStatus = LibStub("AceAddon-3.0"):NewAddon("WorldBossStatus", "AceConsole-3.0", "AceEvent-3.0" );

local trackableCurrencies = {	
	{ id = 392, legacy = false },
	{ id = 823, legacy = false },
	{ id = 824, legacy = false },
	{ id = 994, legacy = false },
	{ id = 697, legacy = true },
	{ id = 777, legacy = true },
	{ id = 752, legacy = true },
	{ id = 738, legacy = true },
	{ id = 776, legacy = true }}




--Honor Points = 392
--Apexis Crystal = 823
--Garison Resouces = 824
--Seal of Tempered Fate = 994

for key,value in pairs(trackableCurrencies) do
	value.name, _, value.texture = GetCurrencyInfo(value.id)
end

local textures = {}

textures.worldBossStatus = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8.png"
textures.alliance = "|TInterface\\FriendsFrame\\PlusManz-Alliance:18|t"
textures.horde = "|TInterface\\FriendsFrame\\PlusManz-Horde:18|t"
textures.bossDefeated = "|TInterface\\WorldMap\\Skull_64Red:18|t"
textures.bossAvailable = "|TInterface\\WorldMap\\Skull_64Grey:18|t"
textures.quest = "|TInterface\\Minimap\\OBJECTICONS:20:20:0:0:256:192:32:64:20:48|t"

local addonName = "WordBossStatus";
local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)
local LibQTip = LibStub('LibQTip-1.0')

local red = { r = 1.0, g = 0.2, b = 0.2 }
local blue = { r = 0.4, g = 0.4, b = 1.0 }
local green = { r = 0.2, g = 1.0, b = 0.2 }
local yellow = { r = 1.0, g = 1.0, b = 0.2 }
local gray = { r = 0.5, g = 0.5, b = 0.5 }
local black = { r = 0.0, g = 0.0, b = 0.0 }
local white = { r = 1.0, g = 1.0, b = 1.0 }
local frame

local WOD_WORLD_BOSSES = { { creatureIndex = 1, encounterIndex = 1262, questId = 37464, legacy = false },
                           { creatureIndex = 1, encounterIndex = 1211, questId = 37462, legacy = false },
			               { creatureIndex = 1, encounterIndex = 1291, questId = 37462, legacy = false }, --37460
						   { legacy = true, creatureIndex = 1, encounterIndex = 861 },
						   { legacy = true, name = L["The Celestials"] },								
						   { legacy = true, creatureIndex = 1, encounterIndex = 826 },
						   { legacy = true, creatureIndex = 1, encounterIndex = 814 },
						   { legacy = true, creatureIndex = 1, encounterIndex = 725 },
						   { legacy = true, creatureIndex = 1, encounterIndex = 691 } }
						   
for _, boss in pairs(WOD_WORLD_BOSSES) do
	if not boss.name then
		_, boss.name = EJ_GetCreatureInfo(boss.creatureIndex, boss.encounterIndex)
	end
end						   
						 						   
local HOLIDAY_BOSS = nil

local WorldBossStatusLauncher = LDB:NewDataObject(addonName, {
		type = "data source",
		text = L["World Boss Status"],
		label = "WorldBossStatus",
		tocname = "WorldBossStatus",
			--"launcher",
		icon = textures.worldBossStatus,
		OnClick = function(clickedframe, button)
			WorldBossStatus:ShowOptions() 
		end,
		OnEnter = function(self)
			frame = self
			WorldBossStatus:ShowToolTip()
		end,
	})
	
local defaults = {
	realm = {
		characters = {
			},
	},
	global = {
		realms = {
			},
		MinimapButton = {
			hide = false,
		}, 
		displayOptions = {
			showHintLine = true,
			showLegend = true,
			showMinimapButton = true,
		},
		characterOptions = {
			levelRestriction = true,
			minimumLevel = 100,
			removeInactive = true,
			inactivityThreshold = 28,
			include = 3,
		},
		bossOptions = {
			hideBoss = {
			},	
			trackLegacyBosses = false,
			disableHoldidayBossTracking = false,
		},
		bonusRollOptions = {		
			trackWeeklyQuests = true,
			trackedCurrencies = { 
				[994] = true,
			},
			trackLegacyCurrencies = false,
		},
	},
};

local options = {
    handler = WorldBossStatus,
    type = "group",
    args = {
		features = {
			handler = WorldBossStatus,
			type = 'group',
			name = L["General Options"],
			desc = "",
			order = 10,
			args = {			
				displayOptions = {
					type = 'group',
					inline = true,
					name = L["Display Options"],
					desc = "",
					order = 1,
					args = {	
						showMiniMapButton = {
							type = "toggle",
							name = L["Minimap Button"],
							desc = L["Toggles the display of the minimap button."],
							get = "IsShowMinimapButton",
							set = "ToggleMinimapButton",
							order=1,
						},
						showHintLine = {
							type = "toggle",
							name = L["Hint Line"],
							desc = L["Toggles the display of the hint line."],
							get = function(info)
									return WorldBossStatus.db.global.displayOptions.showHintLine
								  end,
							set = function(info, value)
									WorldBossStatus.db.global.displayOptions.showHintLine = value
								  end,
							order = 2,
						},
					},
				},
				
			},
		},
		characterOptions = {
			handler = WorldBossStatus,
			type = 'group',
			name = L["Character Options"],
			desc = "",
			order = 20,
			args = {	
				inlcudeCharactersOptions = {
					type = 'group',
					inline = true,
					name = L["Show Characters"],
					desc = "",
					order = 1,
					args = {					
						realmOption = {
							type = "toggle",
							name = L["On this realm"],
							desc = L["Show characters on this realm."],
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.include == 2
							end,
							set = function(info, value)
								if value then 
									WorldBossStatus.db.global.characterOptions.include = 2
								else
									WorldBossStatus.db.global.characterOptions.include = 1
								end
							end,
							order=1,
						},
						accountOption = {
							type = "toggle",
							name = L["On this account"],
							desc = L["Show characters on this WoW account."],
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.include == 3
							end,
							set = function(info, value)
								if value then 
									WorldBossStatus.db.global.characterOptions.include = 3
								else
									WorldBossStatus.db.global.characterOptions.include = 1
								end
							end,
							order=2,
						},
					},
				},
				characterLevelOptions = {
					type= "group",
					inline = true,
					name = L["Level Restriction"],
					desc = "",
					order=5,
					args = {
						enableLevelRestriction = {
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable level restriction."],
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.levelRestriction
							end,
							set = function(info, value)
								WorldBossStatus.db.global.characterOptions.levelRestriction = value
							end,
							order=1,
						},
						minimumLevelOption = {
							type = "range",
							name = L["Minimum Level"],
							desc = L["Show characters this level and higher."],
							step = 1, min = 1, max = 100,
							order = 2,
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.minimumLevel
							end,
							set = function(info, value)
								WorldBossStatus.db.global.characterOptions.minimumLevel = value
							end,
							disabled = function()
								return not WorldBossStatus.db.global.characterOptions.levelRestriction
							end,
						},
					},
 				},
				hideInactiveOptions = {
					type= "group",
					inline = true,
					name = L["Hide Inactive Characters"],
					desc = "",
					order=6,
					args = {
						purgeInactiveCharacters = {
							type = "toggle",
							name = L["Enable"],
							desc = L["Enable hiding inactive characters."],
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.removeInactive
							end,
							set = function(info, value)
								WorldBossStatus.db.global.characterOptions.removeInactive = value
							end,
							order=1,
						},
						inactivityThresholdOption = {
							type = "range",
							name = L["Inactivity Threshold (days)"],
							desc = L["Hide characters that have been inactive for this many days."],
							step = 1, min = 14, max = 42,
							order = 2,
							get = function(info)
								return WorldBossStatus.db.global.characterOptions.inactivityThreshold
							end,
							set = function(info, value)
								WorldBossStatus.db.global.characterOptions.inactivityThreshold = value
							end,
							disabled = function()
								return not WorldBossStatus.db.global.characterOptions.removeInactive
							end,
						},
					},
				},
				trackedCharactersOption = {
					type = "group",
					inline = true,
					name = L["Remove Tracked Characters"],
					desc = "",
					order = 7,
					args = {
						realmSelect = {
							type = "select",
							name = L["Realm"],
							desc = L["Select a realm to remove a tracked character from."],
							order = 1,
							values = function()
										local realmList = {}

										for realm in pairs(WorldBossStatus.db.global.realms) do
											realmList[realm] = realm
										end

										return realmList
									 end,
							get = function(info)
									return selectedRealm
								  end,
							set = function(info, value)
									selectedRealm = value
									selectedCharacter = nil
								  end,
						},
						characterSelect = {
							type = "select",
							name = L["Character"],
							desc = L["Select the tracked character to remove."],
							order = 2,
							disabled = function()
										  return selectedRealm == nil
									   end,
							values = function()
										local list = {}
										local realmInfo = WorldBossStatus.db.global.realms[selectedRealm]
										if realmInfo then
											local characters = realmInfo.characters
	
											for key,value in pairs(characters) do
												list[key] = key
											end
										end
										return list
									 end,
							get = function(info)
									return selectedCharacter
								  end,
							set = function(info, value)
									selectedCharacter = value
								  end,
						},
						removeAction = {
							type = "execute",							
							name = L["Remove"],
							desc = L["Click to remove the selected tracked character."],
							order = 3,
							disabled = function()
										  return selectedRealm == nil or selectedCharacter == nil
									   end,
							func = function()

								local realmInfo = WorldBossStatus.db.global.realms[selectedRealm]
								local characterInfo = realmInfo.characters[selectedCharacter]
								local count = 0

								if not realmInfo then
									return
								end

								if characterInfo then 
									realmInfo.characters[selectedCharacter] = nil								
								end
								
								for key,value in pairs(realmInfo.characters) do 
									count = count + 1
								end
								
								if count == 0 then 
									WorldBossStatus.db.global.realms[selectedRealm] = nil
								end
							end,
						},
					},
				},
			}		
		},
		bossTracking = {
			type = "group",
			name = L["Boss Options"],
			handler = WorldBossStatus,
			desc = "",
			order = 30,
			args = {
				trackHoldidayBosses = {
					type = "toggle",
					name = L["Track holiday bosses"],
					desc = L["Automatically track holiday bosses during world events."],
					get = function(info)
						return not WorldBossStatus.db.global.bossOptions.disableHoldidayBossTracking
					end,
					set = function(info, value)
						WorldBossStatus.db.global.bossOptions.disableHoldidayBossTracking = not value
					end,
					order=1,
				},
				trackedBosses = {
					type = "multiselect",
					name = L["Tracked Bosses"],
					desc = L["Select the world bosses you would like to track."],
					width = "full",
					values = "GetWorldBossOptions",
					get = function(info, key)
							return not WorldBossStatus.db.global.bossOptions.hideBoss[WOD_WORLD_BOSSES[key].name]
						end,
					set = function(info, key, value)
							WorldBossStatus.db.global.bossOptions.hideBoss[WOD_WORLD_BOSSES[key].name] = not value
					end,
					order=2
				},
				trackLegacyBosses = {
					type = "toggle",
					name = L["Track legacy bosses"],
					desc = L["Enable tracking of older legacy world bosses."],
					get = function(info)
						return WorldBossStatus.db.global.bossOptions.trackLegacyBosses
					end,
					set = function(info, value)
						WorldBossStatus.db.global.bossOptions.trackLegacyBosses = value
					end,
					order=3,
				},
				trackedLegacyBosses = {
					type = "multiselect",
					name = L["Tracked Legacy Bosses"],
					desc = L["Select the legacy world bosses you would like to track."],
					width = "full",
					values = "GetLegacyWorldBossOptions",
					get = function(info, key)
							return not WorldBossStatus.db.global.bossOptions.hideBoss[WOD_WORLD_BOSSES[key].name]
						end,
					set = function(info, key, value)
							WorldBossStatus.db.global.bossOptions.hideBoss[WOD_WORLD_BOSSES[key].name] = not value
					end,
					disabled = function()
						return not WorldBossStatus.db.global.bossOptions.trackLegacyBosses
					end,
					order=4
				},
			}
		},
		bonusRollTracking = {
			type = "group",
			--inline = true,
			handler = WorldBossStatus,
			name = L["Bonus Roll Options"],
			desc = "",
			order = 40,
			args = {
				trackQuests = {
					type = "toggle",
					name = L["Track weekly quests"],
					desc = L["Enable tracking the weekly 'Sealing Fate' quests."],
					width = "full",
					get = function(info)
							return WorldBossStatus.db.global.bonusRollOptions.trackWeeklyQuests
						end,
					set = function(info, value)
							WorldBossStatus.db.global.bonusRollOptions.trackWeeklyQuests = value
						end,
					order=1,
				},
				trackedCurrencies = {
					type = "multiselect",
					name = L["Tracked Currencies"],
					desc = L["Select the currencies you would like to track."],
					width = "full",
					values = "GetCurrencyOptions",
					get = function(info, key)
							return WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[trackableCurrencies[key].id]
						end,
					set = function(info, key, value)
							WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[trackableCurrencies[key].id] = value
					end,
					order=2,
				},

				trackLegacyCurrency = {
					type = "toggle",
					name = L["Track legacy currencies"],
					desc = L["Enable tracking of older legacy bonus roll currencies."],
					get = function(info)
						return WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies
					end,
					set = function(info, value)
						WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies = value
					end,
					order=3,
				},
				trackedLegacyCurrencies = {
					type = "multiselect",
					name = L["Tracked Legacy Currencies"],
					desc = L["Select the legacy currencies you would like to track."],
					width = "full",
					values = "GetLegacyCurrencyOptions",
					get = function(info, key)
							return WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[trackableCurrencies[key].id]
						end,
					set = function(info, key, value)
							WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[trackableCurrencies[key].id] = value
					end,
					disabled = function()
						return not WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies
					end,
					order=4,
				},
			}			
		}
	}
}

function WorldBossStatus:GetCurrencyOptions()
    local itemsList = {}
	
    for key,value in pairs(trackableCurrencies) do
		if not value.legacy then
			 itemsList[key] = "|T"..value.texture..":14:14:0:0:64:64:4:60:4:60|t "..value.name
		end
    end

    return itemsList
end

function WorldBossStatus:GetLegacyCurrencyOptions()
    local itemsList = {}
	
    for key,value in pairs(trackableCurrencies) do
		if (value.legacy) then
			itemsList[key] = "|T"..value.texture..":14:14:0:0:64:64:4:60:4:60|t "..value.name
		end
    end

    return itemsList
end

function WorldBossStatus:GetWorldBossOptions()
	local itemsList = {}
	
    for key,value in pairs(WOD_WORLD_BOSSES) do
		if not value.legacy then
			itemsList[key] = value.name
		end
    end

    return itemsList
end

function WorldBossStatus:GetLegacyWorldBossOptions()
	local itemsList = {}
	
    for key,value in pairs(WOD_WORLD_BOSSES) do
		if value.legacy then
			itemsList[key] = value.name
		end
    end

    return itemsList

end

local function CleanupCharacters()
	local threshold = WorldBossStatus.db.global.characterOptions.inactivityThreshold * (24 * 60 * 60)	
	
	if not WorldBossStatus.db.global.characterOptions.removeInactive or threshold == 0 then
		return
	 end
	

	for realm in pairs(WorldBossStatus.db.global.realms) do
		local realmInfo = self.db.global.realms[realm]
		local characters = nil
		
		if realmInfo then
			local characters = realmInfo.characters
	
			for key,value in pairs(characters) do
				if value.lastUpdate and value.lastUpdate < time() - threshold then
					value = nil
				end
			end
			
		end
	end
	
end

function WorldBossStatus:DisplayCharacterInTooltip(characterName, characterInfo)
	local tooltip = WorldBossStatus.tooltip
	local line = tooltip:AddLine()
	local factionIcon = ""
	local coins = 0
	local seals = 0

	if characterInfo.faction and characterInfo.faction == "Alliance" then
		factionIcon = textures.alliance
	elseif characterInfo.faction and characterInfo.faction == "Horde" then
		factionIcon = textures.horde
	end

	tooltip:SetCell(line, 2, factionIcon.." "..characterName)

	if (characterInfo.bonusRolls) then
		coins = characterInfo.bonusRolls.questCurrency		
		seals = characterInfo.bonusRolls.rolls
	end

	column = 2

	for key,currency in pairs(trackableCurrencies) do
		if (not currency.legacy or WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies) and WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[currency.id] then
			column = column + 1
			if (characterInfo.bonusRolls and characterInfo.bonusRolls.currency and characterInfo.bonusRolls.currency[currency.id]) then
				tooltip:SetCell(line, column, characterInfo.bonusRolls.currency[currency.id], nil, "RIGHT")
			end
		end
	end

	
	if (WorldBossStatus.db.global.bonusRollOptions.trackWeeklyQuests) then
		local seals = nil
		column = column +1
			
		if characterInfo.bonusRolls.sealsCollected then
			if time() < characterInfo.bonusRolls.questsReset then
				seals = characterInfo.bonusRolls.sealsCollected.."/3"
			else 
				seals = "0/3"
			end			
		end
		
		if seals then
			tooltip:SetCell(line, column, seals)
		end
	end

	column = column + 1

	if HOLIDAY_BOSS and not WorldBossStatus.db.global.bossOptions.disableHoldidayBossTracking then
		local boss = HOLIDAY_BOSS
		local defeated = (characterInfo.holidayBossKills and characterInfo.holidayBossKills[boss] and characterInfo.holidayBossKills[boss] > time())

			if defeated then 
				tooltip:SetCell(line, column, textures.bossDefeated)
			else
				tooltip:SetCell(line, column, textures.bossAvailable )
			end

			if characterInfo.class then
				local color = RAID_CLASS_COLORS[characterInfo.class]
				tooltip:SetCellTextColor(line, 2, color.r, color.g, color.b)
			end

			column = column+1
	end

	for _, boss in pairs(WOD_WORLD_BOSSES) do
		if (not boss.legacy or WorldBossStatus.db.global.bossOptions.trackLegacyBosses) and not WorldBossStatus.db.global.bossOptions.hideBoss[boss.name] then
			local defeated = (characterInfo.bossKills[boss.name] and characterInfo.bossKills[boss.name] > time())

			if defeated then 
				tooltip:SetCell(line, column, textures.bossDefeated)
			else
				tooltip:SetCell(line, column, textures.bossAvailable )
			end

			column = column+1			
		end
	end

	if characterInfo.class then
		local color = RAID_CLASS_COLORS[characterInfo.class]
		tooltip:SetCellTextColor(line, 2, color.r, color.g, color.b)
	end	

end


function WorldBossStatus:IsShowMinimapButton(info)
	return not self.db.global.MinimapButton.hide
end

function WorldBossStatus:ToggleMinimapButton(info, value)
	self.db.global.MinimapButton.hide = not value

	if self.db.global.MinimapButton.hide then
		LDBIcon:Hide(addonName)
	else
		LDBIcon:Show(addonName)
	end

	LDBIcon:Refresh(addonName)
	LDBIcon:Refresh(addonName)
end

function WorldBossStatus:ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

function WorldBossStatus:OnInitialize()	
	self.db = LibStub("AceDB-3.0"):New("WorldBossStatusDB", defaults, true)

	LDBIcon:Register(addonName, WorldBossStatusLauncher, self.db.global.MinimapButton)

	local wbscfg = LibStub("AceConfig-3.0")
	wbscfg:RegisterOptionsTable("World Boss Status", options)
	wbscfg:RegisterOptionsTable("World Boss Status Features", options.args.features)
	wbscfg:RegisterOptionsTable("World Boss Status Characters", options.args.characterOptions)
	wbscfg:RegisterOptionsTable("World Boss Status Bosses", options.args.bossTracking)
	wbscfg:RegisterOptionsTable("World Boss Status Bonus Rolls", options.args.bonusRollTracking)


	local wbsdia = LibStub("AceConfigDialog-3.0")

	self.optionsFrame =  wbsdia:AddToBlizOptions("World Boss Status Features", L["World Boss Status"])
	wbsdia:AddToBlizOptions("World Boss Status Characters", L["Characters"], L["World Boss Status"])
	wbsdia:AddToBlizOptions("World Boss Status Bosses", L["Bosses"], L["World Boss Status"])
	wbsdia:AddToBlizOptions("World Boss Status Bonus Rolls", L["Bonus Rolls"], L["World Boss Status"])

	RequestRaidInfo()
end

local function ShowHeader(tooltip, marker, headerName)
	line = tooltip:AddHeader()

	if (marker) then
		tooltip:SetCell(line, 1, marker)
	end
	
	tooltip:SetCell(line, 2, headerName, nil, nil, nil, nil, nil, 50)
	tooltip:SetCellTextColor(line, 2, yellow.r, yellow.g, yellow.b)

	column = 2

	for key,currency in pairs(trackableCurrencies) do
		if (not currency.legacy or WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies) and WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[currency.id] then
			column = column + 1
			tooltip:SetCell(line, column, "|T"..currency.texture..":0|t", nil, "RIGHT")
		end
	end

	if (WorldBossStatus.db.global.bonusRollOptions.trackWeeklyQuests) then
		column = column + 1
		tooltip:SetCell(line, column, textures.quest, nil, "CENTER")
	end

	column = column + 1

	if HOLIDAY_BOSS and not WorldBossStatus.db.global.bossOptions.disableHoldidayBossTracking then
		tooltip:SetCell(line, column, HOLIDAY_BOSS, "CENTER")
		tooltip:SetCellTextColor(line, column, yellow.r, yellow.g, yellow.b)
		column = column+1
	end

	for _, boss in pairs(WOD_WORLD_BOSSES) do
		if (not boss.legacy or WorldBossStatus.db.global.bossOptions.trackLegacyBosses) and not WorldBossStatus.db.global.bossOptions.hideBoss[boss.name] then
			tooltip:SetCell(line, column, boss.name, "CENTER")
			tooltip:SetCellTextColor(line, column, yellow.r, yellow.g, yellow.b)
			column = column+1		
		end
	end

	return line
end 

function WorldBossStatus:DisplayRealmInToolip(realmName)
	local realmInfo = self.db.global.realms[realmName]
	local characters = nil
	local collapsed = false
	local epoch = time() - (WorldBossStatus.db.global.characterOptions.inactivityThreshold * 24 * 60 * 60)

	if realmInfo then
		characters = realmInfo.characters
		collapsed = realmInfo.collapsed
	end

	local characterNames = {}
	local currentCharacterName = UnitName("player")
	local currentRealmName = GetRealmName()
	local tooltip = WorldBossStatus.tooltip
	local levelRestriction = WorldBossStatus.db.global.characterOptions.levelRestruction or false;
	local minimumLevel = 1

	if WorldBossStatus.db.global.characterOptions.levelRestriction then
		minimumLevel = WorldBossStatus.db.global.characterOptions.minimumLevel		
		if not minimumLevel then minimumLevel = 90 end
	end	
		
	if not characters then
		return 
	end

	for k,v in pairs(characters) do
		local inlcude = true
		if (realmName ~= currentRealmName or k ~= currentCharacterName) and 
		   (not WorldBossStatus.db.global.characterOptions.removeInactive or v.lastUpdate > epoch)  and
   		   (v.level >= minimumLevel) then
				table.insert(characterNames, k);
		end
	end

	if (table.getn(characterNames) == 0) then
		return
	end
			   
	table.sort(characterNames)

	tooltip:AddSeparator(2,0,0,0,0)

	if not collapsed then
		line = ShowHeader(tooltip, "|TInterface\\Buttons\\UI-MinusButton-Up:16|t", realmName)

		tooltip:AddSeparator(3,0,0,0,0)

		for k,v in pairs(characterNames) do
			WorldBossStatus:DisplayCharacterInTooltip(v, characters[v])
		end

		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	else
		line = ShowHeader(tooltip, "|TInterface\\Buttons\\UI-PlusButton-Up:16|t", realmName)
	end

	tooltip:SetCellTextColor(line, 2, yellow.r, yellow.g, yellow.b)	
	tooltip:SetCellScript(line, 1, "OnMouseUp", RealmOnClick, realmName)
end

function RealmOnClick(cell, realmName)
	WorldBossStatus.db.global.realms[realmName].collapsed = not WorldBossStatus.db.global.realms[realmName].collapsed
	WorldBossStatus:ShowToolTip()
end

function WorldBossStatus:ShowToolTip()
	local tooltip = WorldBossStatus.tooltip
	local characterName = UnitName("player")
	local bossKills = WorldBossStatus:GetWorldBossKills()
	local holidayBossKills = WorldBossStatus:GetHolidayBossKills()
	local characters = WorldBossStatus.db.realm.characters
	local class, className = UnitClass("player")
	local includeCharacters = WorldBossStatus.db.global.characterOptions.include or 3
	local showHint = WorldBossStatus.db.global.displayOptions.showHintLine

	if LibQTip:IsAcquired("WorldBossStatusTooltip") and tooltip then
		tooltip:Clear()
	else
		local columnCount = 3

		RequestLFDPlayerLockInfo()
		WorldBossStatus:UpdateWorldBossKills();

		if HOLIDAY_BOSS and not WorldBossStatus.db.global.bossOptions.disableHoldidayBossTracking then
			columnCount = columnCount + 1
		end
		
		for _, boss in pairs(WOD_WORLD_BOSSES) do
			if (not boss.legacy or WorldBossStatus.db.global.bossOptions.trackLegacyBosses) and not WorldBossStatus.db.global.bossOptions.hideBoss[boss.name] then
				columnCount = columnCount + 1
			end
		end

		for key,currency in pairs(trackableCurrencies) do
			if (not currency.legacy or WorldBossStatus.db.global.bonusRollOptions.trackLegacyCurrencies) and WorldBossStatus.db.global.bonusRollOptions.trackedCurrencies[currency.id] then
				columnCount = columnCount + 1
			end
		end

		if WorldBossStatus.db.global.bonusRollOptions.trackWeeklyQuests then
			columnCount = columnCount + 1
		end

		tooltip = LibQTip:Acquire("WorldBossStatusTooltip", columnCount, "CENTER", "LEFT", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
		WorldBossStatus.tooltip = tooltip 
	end

	line = tooltip:AddHeader(" ")
	tooltip:SetCell(1, 1, "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8:16|t "..L["World Boss Status"], nil, "LEFT", tooltip:GetColumnCount())
	tooltip:AddSeparator(6,0,0,0,0)
	ShowHeader(tooltip, nil, L["Character"])
	tooltip:AddSeparator(6,0,0,0,0)
			
	local info = WorldBossStatus:GetCharacterInfo()
	WorldBossStatus:DisplayCharacterInTooltip(characterName, info)
	tooltip:AddSeparator(6,0,0,0,0)
	tooltip:AddSeparator(1, 1, 1, 1, 1.0)

	if includeCharacters > 1 then
		WorldBossStatus:DisplayRealmInToolip(GetRealmName())
	end
			
	if includeCharacters == 3 then
		realmNames = {}
				
		for k,v in pairs(WorldBossStatus.db.global.realms) do
			if (k ~= GetRealmName()) then
				table.insert(realmNames, k);
			end
		end
				
		for k,v in pairs(realmNames) do
			WorldBossStatus:DisplayRealmInToolip(v)
		end
	end

	if showHint then
		local HIGHLIGHT_START = "\124cffffff00\124h"
		local HIGHLIGHT_END = "\124h\124r"
		line = tooltip:AddLine(" ")		
		local hint = string.format(L["%s and %s share the same loot lockout."], 
			HIGHLIGHT_START..WOD_WORLD_BOSSES[2].name..HIGHLIGHT_END, 
			HIGHLIGHT_START..WOD_WORLD_BOSSES[3].name..HIGHLIGHT_END)
		tooltip:SetCell(tooltip:GetLineCount(), 1, hint, nil, "LEFT", tooltip:GetColumnCount())
	else 
		line = tooltip:AddLine(" ")
		tooltip:SetCell(tooltip:GetLineCount(), 1, L["Click to open the options menu"], nil, "LEFT", tooltip:GetColumnCount())
	end

	if (frame) then
		tooltip:SetAutoHideDelay(0.01, frame)
		tooltip:SmartAnchorTo(frame)
	end 

	tooltip:UpdateScrolling()
	tooltip:Show()
end

function WorldBossStatus:SaveCharacterInfo()
	local characterName = UnitName("player")
	local realmName = GetRealmName()
	
	if not self.db.global.realms then
		self.db.global.realms = {}
	end

	local realmInfo = self.db.global.realms[realmName]

	if not realmInfo then
		realmInfo = {}
		realmInfo.characters = {}
	end
	
	realmInfo.characters[characterName]  = WorldBossStatus:GetCharacterInfo()


	self.db.global.realms[realmName] = realmInfo
end

function WorldBossStatus:GetCharacterInfo()
	local characterInfo = {}
	local class, className = UnitClass("player")
	local level = UnitLevel("player")
	local englishFaction, localizedFaction = UnitFactionGroup("player")

	characterInfo.bossKills = WorldBossStatus:GetWorldBossKills()
	characterInfo.holidayBossKills = WorldBossStatus:GetHolidayBossKills()
	characterInfo.lastUpdate = time()
	characterInfo.class = className
	characterInfo.level = level
	characterInfo.faction = englishFaction
	characterInfo.bonusRolls = WorldBossStatus:GetBonusRollsStatus()

	return characterInfo
end

function WorldBossStatus:GetHolidayBossKills()
	local holidayBossStatus = {}
	local num = GetNumRandomDungeons()
	HOLIDAY_BOSS = nil

	--RequestLFDPlayerLockInfo()

	for i=1, num do 
		local dungeonID, name = GetLFGRandomDungeonInfo(i);
		local _, _, _, _, _, _, _, _, _, _, _, _, _,desc, isHoliday = GetLFGDungeonInfo(dungeonID)

		if isHoliday and dungeonID ~= 828 then		
			local doneToday = GetLFGDungeonRewards(dungeonID)

			HOLIDAY_BOSS = name

			if doneToday then			
				local expires = time() + GetQuestResetTime()
				holidayBossStatus[name] = expires	
			end
		end 
	end

	return holidayBossStatus
end

function WorldBossStatus:GetBonusRollsStatus()
	local bonusRolls = {}
	
	bonusRolls.currency = {}
	
	for key,value in pairs(trackableCurrencies) do
		_, balance = GetCurrencyInfo(value.id)
		bonusRolls.currency[value.id] = balance	
	end

	--37455 = Immense Fortune of Gold
	--37457 = Tremendous Garrison Resources
	--37459 = Monumental Honor
	--37453 = Mountain of Apexis Crystals
	--37454 = Piles of Gold
	--37456 = Stockpiled Garrison Resources
	--37458 = Extended Honor
	--37452 = Heap of Apexis Crystals
	--36054 = Sealing Fate: Gold
	--36056 = Garrison Resources
	--36057 = Sealing Fate: Honor
	--36055 = Sealing Fate: Apexis Crystals
	--36058 = Seal of Tempered Fate: Armory

	bonusRolls.sealsCollected = 0

	--Stage 1 Quests
	if IsQuestFlaggedCompleted(36054) then 
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(36056) then 
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end

	if IsQuestFlaggedCompleted(36057) then 
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end

	if IsQuestFlaggedCompleted(36055) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end


	--Stage 2 Quests
	if IsQuestFlaggedCompleted(37454) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(37456) then 
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(37458) then 
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end

	if IsQuestFlaggedCompleted(37452) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end


	--Stage 3 Quests
	if IsQuestFlaggedCompleted(37455) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(37457) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(37459) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end
	
	if IsQuestFlaggedCompleted(37453) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end

	--Armory Quest (Dwarven Bunker / War Mill)
	if IsQuestFlaggedCompleted(36058) then
		bonusRolls.sealsCollected = bonusRolls.sealsCollected + 1
	end		

	bonusRolls.questsReset = WorldBossStatus:GetWeeklyQuestResetTime()

	return bonusRolls
end

function WorldBossStatus:GetWeeklyQuestResetTime()
	local TUESDAY = 2
	local WEDNESDAY = 3
	local THURSDAY = 4
	local regionResets = {["US"] = TUESDAY, ["EU"] = WEDNESDAY, ["CN"] = THURSDAY, ["KR"] = THURSDAY, ["TW"] = THURSDAY};

	--local region = GetCVar("realmList"):match("^(%a+)%."):upper()
	local region = GetCVar("portal"):upper()
	local resetWeekDay = regionResets[region]
	local offset = WorldBossStatus:GetRealmOffset()

	--WorldBossStatus:Print("Realm offset is: "..offset)

	local nextReset = time() + GetQuestResetTime()

	--WorldBossStatus:Print("Daily reset for "..region.. " in "..nextReset - time() .." seconds")

	if not resetWeekDay then
		return nil
	end

	while tonumber(date("%w", nextReset + offset)) ~= resetWeekDay do
		nextReset = nextReset + (24 * 60 *60)
	end

	--WorldBossStatus:Print("Weekly reset for "..region.. " in "..nextReset - time() .." seconds")

	return nextReset
end
 
function WorldBossStatus:GetRealmOffset()
       local localDate = date("*t", time())
	   local realmDate = date("*t", time())

	   realmDate.wday, realmDate.month, realmDate.day, realmDate.year = CalendarGetDate();
	   realmDate.hour, realmDate.min = GetGameTime()

	   local localTime = time{year=localDate.year, month=localDate.month, day=localDate.day, hour=localDate.hour}
	   local realmTime = time{year=realmDate.year, month=realmDate.month, day=realmDate.day, hour=realmDate.hour}
	   local offset = realmTime - localTime

       return offset
end

function WorldBossStatus:GetWorldBossKills()
	local bossKills = {}
	local num = GetNumSavedWorldBosses()

	for _, v in pairs(WOD_WORLD_BOSSES) do 
		local expires = WorldBossStatus:GetWeeklyQuestResetTime()
		if v.questId and IsQuestFlaggedCompleted(v.questId) then
			bossKills[v.name] = expires
		end
	end

	for i = 1, num do
		local name, worldBossID, reset = GetSavedWorldBossInfo(i)
		local expires = time() + reset

		bossKills[name] = expires		
	end

	return bossKills
end

function WorldBossStatus:UPDATE_INSTANCE_INFO()
	WorldBossStatus:SaveCharacterInfo()
	if LibQTip:IsAcquired("WorldBossStatusTooltip") and WorldBossStatus.tooltip then
		WorldBossStatus:ShowToolTip()
	end
end

function WorldBossStatus:LFG_UPDATE_RANDOM_INFO()
	WorldBossStatus:SaveCharacterInfo()
	if LibQTip:IsAcquired("WorldBossStatusTooltip") and WorldBossStatus.tooltip then
		WorldBossStatus:ShowToolTip()
	end
end

function WorldBossStatus:LFG_COMPLETION_REWARD()
	RequestLFDPlayerLockInfo()
end

oldLogout = Logout;
oldQuit = Quit;

function WorldBossStatus:UpdateWorldBossKills()
	RequestRaidInfo();		
end


function Quit()
	WorldBossStatus:UpdateWorldBossKills()
	oldQuit();
end

function Logout()
	WorldBossStatus:UpdateWorldBossKills()
	oldLogout();
end

function WorldBossStatus:OnEnable()
	self:RegisterEvent("UPDATE_INSTANCE_INFO");
	self:RegisterEvent("LFG_UPDATE_RANDOM_INFO");
	self:RegisterEvent("LFG_COMPLETION_REWARD");	
end

function WorldBossStatus:OnDisable()
	Self:UnregisterEvent("UPDATE_INSTANCE_INFO");
	Self:UnregisterEvent("LFG_UPDATE_RANDOM_INFO");
	Self:UnregisterEvent("LFG_COMPLETION_REWARD");
end