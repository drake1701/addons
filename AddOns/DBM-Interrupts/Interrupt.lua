local mod = DBM:NewMod("Interrupt Cooldowns", "DBM-Interrupts")
mod:SetRevision("Revision 3.2.0")

mod:RegisterEvents("SPELL_CAST_SUCCESS")

local options = {
name = "DBM-Interrupts",
type = "group",
childGroups = "tab",
args = {
	title = {
		order = 10,
		type = "description",
		name = "On / Off for DBM-Interrupts",
		},
	raidchangemark = {
		order = 10,
		name = "On / Off",
		type = "toggle",
		desc = "Turns DBM Interrupts On/Off",
		get = function()
				return DBMInterruptsOn end,
		set = function(info, value)
				DBMInterruptsOn = value end,
		},
	}
}

local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

config:RegisterOptionsTable("DBMInterrupt-Bliz", options)
dialog:AddToBlizOptions("DBMInterrupt-Bliz", "DBM-Interrupts")

function mod:SPELL_CAST_SUCCESS(args)
	local _,_Instance = IsInInstance()
	if (_Instance == true) then
	if (SkullMe_Slash1 == nil) then
		DBMInterruptsOn=true
		print("There is a on/off for DBM-Interrupts in the Interface options, inside the addon tab.")
		end
	if (DBMInterrupts == false) then
		return
		end
	if args.spellId == 6552 then  --Warrior Pummel
		DBM:CreatePizzaTimer(10,args.sourceName.." Pum")
		end
	if args.spellId == 47528 then --DK Mind Freeze
		DBM:CreatePizzaTimer(10,args.sourceName.." MF")
	    end
	if args.spellId == 49802 then --Druid Maim
		DBM:CreatePizzaTimer(10,args.sourceName.." Maim")
	    end
	if args.spellId == 22570 then --Druid Maim(Old Rank1)
		DBM:CreatePizzaTimer(10,args.sourceName.." Maim")
	    end
	if args.spellId == 8983 then  --Druid Bash
		DBM:CreatePizzaTimer(60,args.sourceName.." Bash")
	    end
	if args.spellId == 5211 then  --Druid Bash(Old Rank1)
		DBM:CreatePizzaTimer(60,args.sourceName.." Bash")
	    end
	if args.spellId == 6798 then  --Druid Bash(Old Rank2)
		DBM:CreatePizzaTimer(60,args.sourceName.." Bash")
	    end
	if args.spellId == 57994 then -- Shaman Wind Shear
		DBM:CreatePizzaTimer(6,args.sourceName.." Shear")
		end
	if args.spellId == 1766 then  --Rogue Kick
		DBM:CreatePizzaTimer(10,args.sourceName.." Kick")
	    end
	if args.spellId == 2139 then  --Mage Counterspell
		DBM:CreatePizzaTimer(10,args.sourceName.." Counter")
	    end
	end
	end