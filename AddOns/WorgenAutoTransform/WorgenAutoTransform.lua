EAutoTransform = LibStub("AceAddon-3.0"):NewAddon("EAutoTransform", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")	

-- Setup everything, check if player is a Worgen
-- No need to transform if we are an Orc or something, eh :-)
local dotransform = 0
function EAutoTransform:OnInitialize()
	local _ , race = UnitRace("player")
	if ( race == "Worgen" ) then
		EAutoTransform.db = LibStub('AceDB-3.0'):New('EAutoTransformDB')
		EAutoTransform.db:RegisterDefaults({ char = {['*']=true, druid={['*']=true}, blacklist={['*']=true}, ["grp"]=false, ["instance"]=false, ["timegeneral"] = 0.5, ["timecombat"] = 0.5} })	
		if ( EAutoTransform.db.char.combat == true ) then EAutoTransform:RegisterEvent("PLAYER_REGEN_ENABLED") else EAutoTransform:UnregisterEvent("PLAYER_REGEN_ENABLED") end 
		EAutoTransform:RegisterEvent("UNIT_AURA")
		_, race = UnitClass("player") -- okay variable name might be confusing, but why introduce a new one? Only do druid checks if we actually are a druid
		if ( race == "DRUID" ) then 		
			EAutoTransform:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cffff2233Worgen Auto Transform v"..GetAddOnMetadata("WorgenAutoTransform", "Version").." loaded.|r")
	end	
end	
	
function EAutoTransform:OnEnable()

end

-- These abilities turn you into a worgen. This is a blacklist which the addon scans for.
-- Icon = duration (permanent aura duration is 0)
local spells={
	["Interface\\Icons\\Ability_Druid_Dash"] = 10, 			-- Finstere Pfade / Darkflight
	["Interface\\Icons\\Ability_Mount_BlackDireWolf"] = 0, 	-- Wilde Hatz / Running Wild
}

-- This is our scheduled transform function
function EAutoTransform:Action()
	if ( (EAutoTransform.db.char.instance == true) and (IsInInstance() == 1) ) then return end
	if ( (EAutoTransform.db.char.grp == true) and ((GetNumRaidMembers() + GetNumPartyMembers()) ~= 0) ) then return end
	if ( CanTransform() == true ) then 
		Transform() 
		dotransform = 0 
	end	
end

--[[
	This is how it basically works:
	Every time your buffs change, scan for abilities which turn you into a Worgen.
	If something is found, set "dotransform" to 1 and exit the function.
	If nothing is found (=you can be human again) and you had a "worgen buff" (means dotransform=1),
	wait 0.5 seconds and transform you back to human again. Set dotransform to 0 and repeat :-)
	This is way more effective than scanning the combat log or something.
--]]

function EAutoTransform:UNIT_AURA(self, arg1)
	if ( arg1 ~= "player" ) then return end
	for i=1,40,1 do
		local name, _, icon, _, _, duration = UnitBuff("player", i)
		if ( icon == nil ) then break end
		if ( (spells[icon] == duration) and (EAutoTransform.db.char.blacklist[icon] == true) ) then			
			dotransform = 1
			return
		end
	end	
	if ( dotransform == 1 ) then 
		EAutoTransform:CancelAllTimers()
		EAutoTransform:ScheduleTimer("Action", EAutoTransform.db.char.timegeneral) 		
	end
end

-- Transform after combat
function EAutoTransform:PLAYER_REGEN_ENABLED()
	EAutoTransform:CancelAllTimers()
	EAutoTransform:ScheduleTimer("Action", EAutoTransform.db.char.timecombat) 
end

-- If a druid is shapeshifted, transform him back afterwards
-- Won't work while in combat because you cannot transorm while being in combat.	  
function EAutoTransform:UPDATE_SHAPESHIFT_FORM()
	if ( EAutoTransform.db.char.druid[GetShapeshiftFormID()] == true ) then
		dotransform = 1
		return
	end	
	EAutoTransform:ScheduleTimer("Action", EAutoTransform.db.char.timegeneral) 
end

-- /wat chat command 
function EAutoTransform:Cmd(arg, arg2)		
	AceConfig:Open("EAutoTransform")	
end

-- Options menu
AceConfig = LibStub("AceConfigDialog-3.0")
EAutoTransform.options = { 
	type = "group", 
	name = "Worgen Auto Transform", 
	args = { 
			desc = {
				type = 'description',
				name = '\n  Written by Endeavour EU Arthas. Rawr!',
				image = 'Interface\\Icons\\Ability_Mount_BlackDireWolf',
				imageWidth = 32,
				imageHeight = 32,
				order = 0,
			},		
			general = {
				name = "Timer options:",
				type = "group",
				inline = true,
				order = 3,
				args = {
					desc = {
						name = "Attention! Values smaller than 0.5 might break the addon's functionality but will try to transform earlier. Some say even a value of 0 works fine, others don't.",				
						type = "description",
						order = 0,
					},
					combat = {
						name = "Combat",
						descStyle  = "inline",
						desc = "Wait x seconds after combat before transformation.",
						type = 'range',
						min = 0.0,
						max = 10.0,
						softMax = 5.0,
						step = 0.1,
						set = function(info,val) EAutoTransform.db.char.timecombat = val end,
						get = function(info) return EAutoTransform.db.char.timecombat end											
					},
					general = {
						name = "General",
						descStyle  = "inline",
						desc = "Wait x seconds before transformation.",
						type = 'range',
						min = 0.0,
						max = 10.0,
						softMax = 5.0,
						step = 0.1,
						set = function(info,val) EAutoTransform.db.char.timegeneral = val end,
						get = function(info) return EAutoTransform.db.char.timegeneral end											
					},
				},
			},						
			doafter = {
				name = "Auto transform after:",
				type = "group",
				inline = true,
				order = 1,
				args = {
					enable = {
						name = "Darkflight",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.blacklist["Interface\\Icons\\Ability_Druid_Dash"] = val end,
						get = function(info) return EAutoTransform.db.char.blacklist["Interface\\Icons\\Ability_Druid_Dash"] end
					},	
					runwild = {
						name = "Running Wild",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.blacklist["Interface\\Icons\\Ability_Mount_BlackDireWolf"] = val end,
						get = function(info) return EAutoTransform.db.char.blacklist["Interface\\Icons\\Ability_Mount_BlackDireWolf"] end
					},	
					combat = {
						name = "Combat",				
						type = "toggle",
						set = function(info,val) 
							EAutoTransform.db.char.combat = val
							if ( val == true ) then 
								EAutoTransform:RegisterEvent("PLAYER_REGEN_ENABLED") 
							else 
								EAutoTransform:UnregisterEvent("PLAYER_REGEN_ENABLED") 
							end 
						end,
						get = function(info) return EAutoTransform.db.char.combat end
					},						
				}
			},
			donot = {
				name = "Do NOT transform while being in:",
				type = "group",
				inline = true,
				order = 2,
				args = {						
					instance = {
						name = "Instance",
						desc = "Do not transform if inside of an instance, arena or battleground",
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.instance = val end,
						get = function(info) return EAutoTransform.db.char.instance end
					},	
					group = {
						name = "Party / Raid",	
						desc = "Do not transform if you are in a party or raid group",
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.grp = val end,
						get = function(info) return EAutoTransform.db.char.grp end
					},						
				}
			},	
			druidstuff = {
				name = "(Druids only) Transform after coming out as:",
				type = "group",
				inline = true,
				order = -1,
				args = {
					cat = {
						name = "Cat",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[1] = val end,
						get = function(info) return EAutoTransform.db.char.druid[1] end
					},	
					tree = {
						name = "Tree Of Life",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[2] = val end,
						get = function(info) return EAutoTransform.db.char.druid[2] end
					},	
					travel = {
						name = "Travel Form",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[3] = val end,
						get = function(info) return EAutoTransform.db.char.druid[3] end
					},	
					aqua = {
						name = "Aquatic",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[4] = val end,
						get = function(info) return EAutoTransform.db.char.druid[4] end
					},	
					bear = {
						name = "Bear",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[5] = val end,
						get = function(info) return EAutoTransform.db.char.druid[5] end
					},	
					flight = {
						name = "Flight Form",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[27] = val end,
						get = function(info) return EAutoTransform.db.char.druid[27] end
					},	
					moonkin = {
						name = "Moonkin",				
						type = "toggle",
						set = function(info,val) EAutoTransform.db.char.druid[31] = val end,
						get = function(info) return EAutoTransform.db.char.druid[31] end
					},						
				}
			},				
	},
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("EAutoTransform", EAutoTransform.options, nil)
AceConfig:SetDefaultSize("EAutoTransform", 450, 400)
AceConfig:AddToBlizOptions("EAutoTransform", "Worgen Auto Transform")

SLASH_WORGENAUTOTRANSFORM1 = "/wat"
SlashCmdList["WORGENAUTOTRANSFORM"] = EAutoTransform.Cmd	
