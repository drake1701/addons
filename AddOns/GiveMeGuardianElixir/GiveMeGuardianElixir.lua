--[[
        Give Me Guardian Elixir:
                Copyright 2009 by MERK, Mileg
				Updated by Grimgrin
                GMGE v0.1 coded by PcVII
                based on code by MERK, Mileg and Stephen Blaising	
                
]]

GMGuardianElixir_ADDONNAME = "Give Me Guardian Elixir";
GMGuardianElixir_MACRONAME = "GMGuardElixir";

GMGuardianElixir_VERSION = "4.5.1";

WATERW = "";
WATERW2 = "";
NoWATERW = "INV_Misc_QuestionMark";
GEIcon = "Spell_misc_emotionsad";
GMGuardianElixir_Save = {};
local PRIMARYguardianelixer;
local SECONDARYguardianelixer;
local TERTIARYguardianelixer;
local Realm;
local Player;
local GMGuardianElixir_UpdateFrame
local GMGuard_GMGuardianUpdate       = {}
GMGuardianElixir_UpdateFrame = CreateFrame("Frame")

function GMGuardianElixir_OnLoad()

  SlashCmdList["GIVEMEGUARDELIXIRCOMMAND"] = GMGuardianElixir_SlashHandler;
  SLASH_GIVEMEGUARDELIXIRCOMMAND1 = "/givemeguardianelixir";
  SLASH_GIVEMEGUARDELIXIRCOMMAND2 = "/gmguardianelixir";
  SLASH_GIVEMEGUARDELIXIRCOMMAND3 = "/gmge";
  
end

function GMGuardianElixir_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
		if (GetMacroIndexByName(GMGuardianElixir_MACRONAME) == 0) then
			local numGenMacros, numCharMacros = GetNumMacros();
			if (numGenMacros < 36) then
				CreateMacro(GMGuardianElixir_MACRONAME, "Spell_misc_emotionsad", "")
			else
				GMGuardianElixir_Print("You have 36 General Macros. Cannot add "..GMGuardianElixir_MACRONAME.."!");
			end
		end
		GMGuardianElixir_MakeArray();
		GMGuardianElixir_Go();
	elseif (event == "VARIABLES_LOADED") then
		GMGuardianElixir_InitVars();
  end
  if event == "BAG_UPDATE" then
		GMGuardianElixir_UpdateFrame:SetScript("OnUpdate", GMGuardianElixir_UpdateFrame_OnUpdate)
  end
end


function GMGuardianElixir_UpdateFrame_OnUpdate(self, elapsed)
local affectingCombat = UnitAffectingCombat("player");
	for i = 0, 11 do
		if GMGuard_GMGuardianUpdate[i] then
			GMGuard_GMGuardianUpdate[i] = nil
		end
	end
	if GMGuard_GMGuardianUpdate.inv then
		GMGuard_GMGuardianUpdate.inv = nil
	end
		if(affectingCombat ~= 1) then
		  self:SetScript("OnUpdate", nil)
		  GMGuardianElixir_MakeArray();
		  GMGuardianElixir_Go();
		end
end

function GMGuardianElixir_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help") then
    GMGuardianElixir_Print(GMGuardianElixir_ADDONNAME.." |cff3399CCv"..GMGuardianElixir_VERSION.." ");
    GMGuardianElixir_Print("Type /macro to open macro list.");
    GMGuardianElixir_Print("Drag GMGuardianElixir macro to your action bar.");
    GMGuardianElixir_Print("Click to eat best Guardian Elixir.");
    GMGuardianElixir_Print("Hold SHIFT and click to drink second best Guardian Elixir.");
    GMGuardianElixir_Print("Hold CTRL and click to drink Elixir of Water Walking (if you have one).");
    GMGuardianElixir_Print("/gmb will display the current guardian elixer order.");
    GMGuardianElixir_Print("/gmb b1=[GUARDELIXIRTYPE] will update the first guardian elixer used in sorting the GMGuardianElixir macro.");
    GMGuardianElixir_Print("/gmb b2=[GUARDELIXIRTYPE] will update the second guardian elixer used in sorting the GMGuardianElixir macro.");
    GMGuardianElixir_Print("/gmb b3=[GUARDELIXIRTYPE] will update the third guardian elixer used in sorting the GMGuardianElixir macro.");
    GMGuardianElixir_Print("Replace [GUARDELIXIRTYPE] with the following:");
    GMGuardianElixir_Print("    all for All Base Stats");
    GMGuardianElixir_Print("    agi for Agility");
    GMGuardianElixir_Print("    atk for Attack Power");
    GMGuardianElixir_Print("    crt for Critical Strike Rating");
    GMGuardianElixir_Print("    exp for Expertise");
    GMGuardianElixir_Print("    has for Haste");
    GMGuardianElixir_Print("    hp for Health");
    GMGuardianElixir_Print("    hp5 for Health Per 5");
    GMGuardianElixir_Print("    hit for Hit Rating");
    GMGuardianElixir_Print("    int for Intellect");
    GMGuardianElixir_Print("    man for extra mana");
    GMGuardianElixir_Print("    mp5 for Mana Per 5");
    GMGuardianElixir_Print("    oth for Other (miscellaneous)");
    GMGuardianElixir_Print("    pvp for Resilience Rating");
    GMGuardianElixir_Print("    res for Resistance");
    GMGuardianElixir_Print("    spl for Spell Power");
    GMGuardianElixir_Print("    splpen for Spell Penetration");
    GMGuardianElixir_Print("    spi for Spirit");
    GMGuardianElixir_Print("    sta for Stamina");
    GMGuardianElixir_Print("    str for Strength");
  elseif (msg == "") then
    GMGuardianElixir_Print("Guardian Elixir Order");
    GMGuardianElixir_Print("First Choice: "..PRIMARYguardianelixer);
    GMGuardianElixir_Print("Second Choice: "..SECONDARYguardianelixer);
    GMGuardianElixir_Print("Third Choice: "..TERTIARYguardianelixer);
  elseif (msg == "b1=all") then
    PRIMARYguardianelixer = "All Base Stats";
    GMGuardianElixir_Print("Primary Guardian Elixir set to All Base Stats");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=all") then
    SECONDARYguardianelixer = "All Base Stats";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to All Base Stats");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=all") then
    TERTIARYguardianelixer = "All Base Stats";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to All Base Stats");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=agi") then
    PRIMARYguardianelixer = "Agility";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Agility");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=agi") then
    SECONDARYguardianelixer = "Agility";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Agility");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=agi") then
    TERTIARYguardianelixer = "Agility";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Agility");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=man") then
    PRIMARYguardianelixer = "Mana";
    GMGuardianElixir_Print("Primary Guardian Elixir set to extra mana");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=man") then
    SECONDARYguardianelixer = "Mana";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to extra mana");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=man") then
    TERTIARYguardianelixer = "Mana";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to extra mana");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=amr") then
    PRIMARYguardianelixer = "Armor";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Armor");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=amr") then
    SECONDARYguardianelixer = "Armor";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Armor");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=amr") then
    TERTIARYguardianelixer = "Armor";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Armor");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=atk") then
    PRIMARYguardianelixer = "Attack Power";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Attack Power");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=atk") then
    SECONDARYguardianelixer = "Attack Power";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Attack Power");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=atk") then
    TERTIARYguardianelixer = "Attack Power";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Attack Power");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=crt") then
    PRIMARYguardianelixer = "Critical Strike Rating";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Critical Strike");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=crt") then
    SECONDARYguardianelixer = "Critical Strike Rating";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Critical Strike");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=crt") then
    TERTIARYguardianelixer = "Critical Strike Rating";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Critical Strike");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=exp") then
    PRIMARYguardianelixer = "Expertise";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Expertise");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=exp") then
    SECONDARYguardianelixer = "Expertise";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Expertise");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=exp") then
    TERTIARYguardianelixer = "Expertise";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Expertise");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=has") then
    PRIMARYguardianelixer = "Haste";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Haste");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=has") then
    SECONDARYguardianelixer = "Haste";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Haste");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=has") then
    TERTIARYguardianelixer = "Haste";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Haste");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=hp") then
    PRIMARYguardianelixer = "Health";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Health");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=hp") then
    SECONDARYguardianelixer = "Health";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Health");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=hp") then
    TERTIARYguardianelixer = "Health";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Health");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=hp5") then
    PRIMARYguardianelixer = "Health Per 5";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Health per 5");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=hp5") then
    SECONDARYguardianelixer = "Health Per 5";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Health per 5");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=hp5") then
    TERTIARYguardianelixer = "Health Per 5";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Health per 5");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=hit") then
    PRIMARYguardianelixer = "Hit Rating";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Hit Rating");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=hit") then
    SECONDARYguardianelixer = "Hit Rating";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Hit Rating");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=hit") then
    TERTIARYguardianelixer = "Hit Rating";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Hit Rating");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=int") then
    PRIMARYguardianelixer = "Intellect";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Intellect");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=int") then
    SECONDARYguardianelixer = "Intellect";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Intellect");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=int") then
    TERTIARYguardianelixer = "Intellect";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Intellect");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=mp5") then
    PRIMARYguardianelixer = "Mana Per 5";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Mana per 5");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=mp5") then
    SECONDARYguardianelixer = "Mana Per 5";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Mana per 5");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=mp5") then
    TERTIARYguardianelixer = "Mana Per 5";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Mana per 5");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=oth") then
    PRIMARYguardianelixer = "Other";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Other");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=oth") then
    SECONDARYguardianelixer = "Other";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Other");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=oth") then
    TERTIARYguardianelixer = "Other";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Other");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=pvp") then
    PRIMARYguardianelixer = "Resilience Rating";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Resilience Rating");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=pvp") then
    SECONDARYguardianelixer = "Resilience Rating";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Resilience Rating");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=pvp") then
    TERTIARYguardianelixer = "Resilience Rating";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Resilience Rating");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=res") then
    PRIMARYguardianelixer = "Resistance";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Resistance");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=res") then
    SECONDARYguardianelixer = "Resistance";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Resistance");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=res") then
    TERTIARYguardianelixer = "Resistance";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Resistance");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=spl") then
    PRIMARYguardianelixer = "Spell Power";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Spell Power");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=spl") then
    SECONDARYguardianelixer = "Spell Power";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Spell Power");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=spl") then
    TERTIARYguardianelixer = "Spell Power";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Spell Power");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
   elseif (msg == "b1=splpen") then
    PRIMARYguardianelixer = "Spell Penetration";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Spell Penetration");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=splpen") then
    SECONDARYguardianelixer = "Spell Penetration";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Spell Penetration");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=splpen") then
    TERTIARYguardianelixer = "Spell Penetration";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Spell Penetration");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=spi") then
    PRIMARYguardianelixer = "Spirit";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Spirit");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=spi") then
    SECONDARYguardianelixer = "Spirit";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Spirit");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=spi") then
    TERTIARYguardianelixer = "Spirit";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Spirit");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=sta") then
    PRIMARYguardianelixer = "Stamina";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Stamina");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=sta") then
    SECONDARYguardianelixer = "Stamina";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Stamina");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=sta") then
    TERTIARYguardianelixer = "Stamina";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Stamina");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b1=str") then
    PRIMARYguardianelixer = "Strength";
    GMGuardianElixir_Print("Primary Guardian Elixir set to Strength");
    GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = PRIMARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b2=str") then
    SECONDARYguardianelixer = "Strength";
    GMGuardianElixir_Print("Secondary Guardian Elixir set to Strength");
    GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = SECONDARYguardianelixer;
    GMGuardianElixir_Go();
  elseif (msg == "b3=str") then
    TERTIARYguardianelixer = "Strength";
    GMGuardianElixir_Print("Tertiary Guardian Elixir set to Strength");
    GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = TERTIARYguardianelixer;
    GMGuardianElixir_Go();
  end
end

function GMGuardianElixir_Print(msg)
	if ((msg) and (strlen(msg) > 0)) then
		if (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
		end
	end
end

function GMGuardianElixir_InitVars()
	Player=UnitName("player");
	Realm=GetCVar("realmName");

	if GMGuardianElixir_Save[Realm] == nil then
		GMGuardianElixir_Save[Realm] = {}
	end

	if GMGuardianElixir_Save[Realm][Player] == nil then
		GMGuardianElixir_Save[Realm][Player] = {}
	end

	if (GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer == nil) then
		GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer = "Stamina";
		PRIMARYguardianelixer = "Stamina";
	else
		PRIMARYguardianelixer = GMGuardianElixir_Save[Realm][Player].PRIMARYguardianelixer;
	end

	if (GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer == nil) then
		GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer = "Spirit";
		SECONDARYguardianelixer = "Spirit";
	else
		SECONDARYguardianelixer = GMGuardianElixir_Save[Realm][Player].SECONDARYguardianelixer;
	end

	if (GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer == nil) then
		GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer = "Critical Strike Rating";
		TERTIARYguardianelixer = "Critical Strike Rating";
	else
		TERTIARYguardianelixer = GMGuardianElixir_Save[Realm][Player].TERTIARYguardianelixer;
	end
end

function GMGuardianElixir_MakeArray()
	GMGuardianElixirItem = {
	--**Guardian Elixirs **		
		--** Resistance **
		[69]   = { [1] = FLASK_B_G_RES_90,				[2] = 80,   [3] = RES, [4] = NON,	[5] = 90,	[6] = 0 },
		--** Expertice **
		[68]   = { [1] = EX_G_EXP_225,					[2] = 80,	[3] = EXP,	[4] = NON,	[5] = 225,	[6] = 0 },
		--** Armor **
		[67]   = { [1] = EX_G_AMR_900,					[2] = 80,	[3] = AMR,	[4] = NON,	[5] = 900,	[6] = 0 },
		[66]   = { [1] = EX_G_AMR_180,					[2] = 70,	[3] = AMR,	[4] = NON,	[5] = 180,	[6] = 0 },
		--** Health, Health Per 5 **
		[65]   = { [1] = EX_G_H_P_350_HP5_20,			[2] = 70,	[3] = H_P,	[4] = HP5,	[5] = 350,	[6] = 20 },
		[64]   = { [1] = EX_G_H_P_250_HP5_10,			[2] = 50,	[3] = H_P,	[4] = HP5,	[5] = 250,	[6] = 10 },
		--** Health **
		[63]   = { [1] = MIX_B_G_H_P_1300,				[2] = 1,	[3] = H_P,	[4] = NON,	[5] = 1301,	[6] = 0 },
		[62]   = { [1] = FLASK_B_G_H_P_1300,			[2] = 75,	[3] = H_P,	[4] = NON,	[5] = 1300,	[6] = 0 },
		[61]   = { [1] = FLASK_B_G_H_P_400,				[2] = 50,	[3] = H_P,	[4] = NON,	[5] = 400,	[6] = 0 },
		[60]   = { [1] = EX_G_H_P_120,					[2] = 25,	[3] = H_P,	[4] = NON,	[5] = 120,	[6] = 0 },
		[59]   = { [1] = EX_G_H_P_27,					[2] = 2,	[3] = H_P,	[4] = NON,	[5] = 27,	[6] = 0 },
		--** Health, Dodge **
		[58]   = { [1] = FLASK_B_G_H_P_500_DOD_10,		[2] = 68,	[3] = H_P,	[4] = OTH,	[5] = 500,	[6] = 10 },
		--** Health Per 5 **
		[57]   = { [1] = EX_G_HP5_20,					[2] = 53,	[3] = HP5,	[4] = NON,	[5] = 20,	[6] = 0 },
		[56]   = { [1] = EX_G_HP5_12,					[2] = 26,	[3] = HP5,	[4] = NON,	[5] = 12,	[6] = 0 },
		[55]   = { [1] = EX_G_HP5_6,					[2] = 15,	[3] = HP5,	[4] = NON,	[5] = 6,	[6] = 0 },
		[54]   = { [1] = EX_G_HP5_2,					[2] = 1,	[3] = HP5,	[4] = NON,	[5] = 2,	[6] = 0 },
		--** Mana Per 5 **
		[53]   = { [1] = MIX_B_G_MP5_38,				[2] = 1,	[3] = MP5,	[4] = NON,	[5] = 39,	[6] = 0 },
		[52]   = { [1] = FLASK_B_G_MP5_38,				[2] = 75,	[3] = MP5,	[4] = NON,	[5] = 38,	[6] = 0 },
		[51]   = { [1] = FLASK_B_G_MP5_25,				[2] = 65,	[3] = MP5,	[4] = NON,	[5] = 25,	[6] = 0 },
		[50]   = { [1] = EX_G_MP5_24,					[2] = 70,	[3] = MP5,	[4] = NON,	[5] = 24,	[6] = 0 },
		[49]   = { [1] = EX_G_MP5_16,					[2] = 60,	[3] = MP5,	[4] = NON,	[5] = 16,	[6] = 0 },
		[48]   = { [1] = EX_G_MP5_12,					[2] = 40,	[3] = MP5,	[4] = NON,	[5] = 12,	[6] = 0 },
		--** Extra mana **
		[47]   = { [1] = EX_G_MAN_45,					[2] = 70,	[3] = MAN,	[4] = NON,	[5] = 450,	[6] = 0 },
		[46]   = { [1] = EX_G_MAN_25,					[2] = 37,	[3] = MAN,	[4] = NON,	[5] = 250,	[6] = 0 },
		[45]   = { [1] = EX_G_MAN_6,					[2] = 10,	[3] = MAN,	[4] = NON,	[5] = 60,	[6] = 0 },
		--** Intellect **
		[44]   = { [1] = FLASK_B_G_INT_65,				[2] = 50,	[3] = INT,	[4] = NON,	[5] = 65,	[6] = 0 },
		[43]   = { [1] = EX_G_INT_25_2,					[2] = 1,	[3] = INT,	[4] = NON,	[5] = 25,	[6] = 0 },
		--** Armor **
		[42]   = { [1] = SC_AMR_400,					[2] = 80,	[3] = AMR,	[4] = NON,	[5] = 400,	[6] = 0 },
		[41]   = { [1] = SC_AMR_120,					[2] = 80,	[3] = AMR,	[4] = NON,	[5] = 120,	[6] = 0 },
		[40]   = { [1] = SC_AMR_100,					[2] = 70,	[3] = AMR,	[4] = NON,	[5] = 100,	[6] = 0 },
		[39]   = { [1] = SC_AMR_80,						[2] = 60,	[3] = AMR,	[4] = NON,	[5] =  80,	[6] = 0 },
		[38]   = { [1] = SC_AMR_60,						[2] = 50,	[3] = AMR,	[4] = NON,	[5] =  60,	[6] = 0 },
		[37]   = { [1] = SC_AMR_40,						[2] = 40,	[3] = AMR,	[4] = NON,	[5] =  40,	[6] = 0 },
		[36]   = { [1] = SC_AMR_32,						[2] = 30,	[3] = AMR,	[4] = NON,	[5] =  32,	[6] = 0 },
		[35]   = { [1] = SC_AMR_20,						[2] = 15,	[3] = AMR,	[4] = NON,	[5] =  20,	[6] = 0 },
		[34]   = { [1] = SC_AMR_12,						[2] =  1,	[3] = AMR,	[4] = NON,	[5] =  12,	[6] = 0 },
		[33]   = { [1] = EX_G_AMR_220,					[2] = 70,	[3] = AMR,	[4] = NON,	[5] = 220,	[6] = 0 },
		[32]   = { [1] = EX_G_AMR_140,					[2] = 55,	[3] = AMR,	[4] = NON,	[5] = 140,	[6] = 0 },
		[31]   = { [1] = EX_G_AMR_120,					[2] = 43,	[3] = AMR,	[4] = NON,	[5] = 120,	[6] = 0 },
		[30]   = { [1] = EX_G_AMR_100,					[2] = 29,	[3] = AMR,	[4] = NON,	[5] = 100,	[6] = 0 },
		[29]   = { [1] = EX_G_AMR_40,					[2] = 16,	[3] = AMR,	[4] = NON,	[5] = 40,	[6] = 0 },
		[28]   = { [1] = EX_G_AMR_25,					[2] = 1,	[3] = AMR,	[4] = NON,	[5] = 25,	[6] = 0 },
		--** Spirit **
		[27]   = { [1] = EX_G_SPI_50,					[2] = 70,	[3] = SPI,	[4] = NON,	[5] = 50,	[6] = 0 },
		[26]   = { [1] = EX_G_SPI_25,					[2] = 1,	[3] = SPI,	[4] = NON,	[5] = 25,	[6] = 0 },
		--** Intellect, Spirit **
		[25]   = { [1] = EX_G_INT_30_SPI_30,			[2] = 50,	[3] = INT,	[4] = SPI,	[5] = 30,	[6] = 30 },
		[24]   = { [1] = EX_G_INT_18_SPI_18,			[2] = 44,	[3] = INT,	[4] = SPI,	[5] = 18,	[6] = 18 },
		--** Spell Penetration **
		[23]   = { [1] = EX_G_SPLPEN_30,				[2] = 60,  [3] = SPLPEN, [4] = NON,	[5] = 30,	[6] = 0 },
		--** Stamina, Spirit **
		[22]   = { [1] = EX_G_STA_25_SPI_25,			[2] = 55,  [3] = STA, [4] = SPI,	[5] = 25,	[6] = 25 },
		--** Stamina **
		[21]   = { [1] = SC_STA_150,					[2] = 80,	[3] = STA,	[4] = NON,	[5] = 150,	[6] = 0 },
		[20]   = { [1] = SC_STA_30,						[2] = 80,	[3] = STA,	[4] = NON,	[5] = 30,	[6] = 0 },
		[19]   = { [1] = SC_STA_25,						[2] = 70,	[3] = STA,	[4] = NON,	[5] = 25,	[6] = 0 },
		[18]   = { [1] = SC_STA_20,						[2] = 60,	[3] = STA,	[4] = NON,	[5] =  20,	[6] = 0 },
		[17]   = { [1] = SC_STA_15,						[2] = 50,	[3] = STA,	[4] = NON,	[5] =  15,	[6] = 0 },
		[16]   = { [1] = SC_STA_10,						[2] = 40,	[3] = STA,	[4] = NON,	[5] =  10,	[6] = 0 },
		[15]   = { [1] = SC_STA_8,						[2] = 30,	[3] = STA,	[4] = NON,	[5] =  8,	[6] = 0 },
		[14]   = { [1] = SC_STA_5,						[2] = 15,	[3] = STA,	[4] = NON,	[5] =  5,	[6] = 0 },
		[13]   = { [1] = SC_STA_3,						[2] =  1,	[3] = STA,	[4] = NON,	[5] =  3,	[6] = 0 },

		[12]   = { [1] = EX_G_STA_25,					[2] = 1,   [3] = STA, [4] = NON,	[5] = 25,	[6] = 0 },
		--** Resistance **
		[11]   = { [1] = FLASK_B_G_RES_50,				[2] = 70,   [3] = RES, [4] = NON,	[5] = 50,	[6] = 0 },
		[10]   = { [1] = FLASK_B_G_RES_35_ALLBS_18,		[2] = 65,   [3] = RES, [4] = ALLBS,	[5] = 35,	[6] = 18 },
		[9]   = { [1] = FLASK_B_G_RES_25,				[2] = 50,   [3] = RES, [4] = NON,	[5] = 25,	[6] = 0 },
		--** Resilience **
		[8]   = { [1] = FLASK_B_G_PVP_50,				[2] = 70,   [3] = PVP, [4] = NON,	[5] = 50,	[6] = 0 },
		[7]   = { [1] = EX_G_PVP_30,					[2] = 55,   [3] = PVP, [4] = NON,	[5] = 30,	[6] = 0 },
		--** Other **
		[6]   = { [1] = EX_G_OTH_SPLREF_3percent,		[2] = 55,   [3] = OTH, [4] = NON,	[5] = 3,	[6] = 0 },
		[5]   = { [1] = EX_G_OTH_RUNSPEED_20precent,	[2] = 55,   [3] = OTH, [4] = NON,	[5] = 20,	[6] = 0 },
		[4]   = { [1] = EX_G_OTH_DAMAGEREDUCTION_20,	[2] = 50,   [3] = OTH, [4] = NON,	[5] = 20,	[6] = 0 },
		[3]   = { [1] = EX_G_OTH_SHADOWRES_10_CURSE,	[2] = 38,   [3] = OTH, [4] = NON,	[5] = 10,	[6] = 8 },
		[2]   = { [1] = EX_G_OTH_WATERWALK,				[2] = 35,   [3] = OTH, [4] = NON,	[5] = 0,	[6] = 0 },
		[1]   = { [1] = FLASK_B_G_OTH_STONE,			[2] = 50,   [3] = OTH, [4] = NON,	[5] = 8,	[6] = 0 },
	}
end

function GMGuardianElixir_Go()
  
	local GuardianElixirItemRank = 0;
	local BGuardianElixirItemRank = 0;
	local GuardianElixirItemNum = 0;
	local BGuardianElixirItemNum = 0;
	local oldGuardianElixirItemLink = "Nothing";
	local BoldGuardianElixirItemLink = "Nothing";
	local exact = "no";
	local SECexact = "no";
	local TERexact = "no";
	local primary = "no";
	local secondary = "no";
	local tertiary = "no";
	
	WATERW = "";
	NoWATERW = GEIcon;
	for bagID = 0, 4, 1 do
		local bagSlotCnt = GetContainerNumSlots(bagID);
		if (bagSlotCnt > 0) then
			for slot = 1, bagSlotCnt, 1 do
				local itemLink = GetContainerItemLink(bagID, slot);
				local itemNumber = GMGuardianElixir_NumFromLink(itemLink);
				if (itemNumber) then
					for index = 1, #(GMGuardianElixirItem), 1 do
						if (itemNumber == EX_G_OTH_WATERWALK) then
							WATERW = "[mod:ctrl] item:"..EX_G_OTH_WATERWALK..";";
							WATERW2 = "[] item:"..EX_G_OTH_WATERWALK..";";
						elseif (GMGuardianElixirItem[index][1] == itemNumber) then
							if (GMGuardianElixirItem[index][2] <= UnitLevel("player")) then
								if		(GMGuardianElixirItem[index][3] == PRIMARYguardianelixer) then
									if (GMGuardianElixirItem[index][5] > GuardianElixirItemRank) or 
										(primary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][5];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										primary = "yes";
									elseif (GMGuardianElixirItem[index][5] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][5] < GuardianElixirItemRank) or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][5] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][5];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								elseif	(GMGuardianElixirItem[index][4] == PRIMARYguardianelixer) then
									if (GMGuardianElixirItem[index][6] > GuardianElixirItemRank) or 
										(primary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][6];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										primary = "yes";
									elseif (GMGuardianElixirItem[index][6] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][6] < GuardianElixirItemRank) or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][6] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][6];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								elseif	(GMGuardianElixirItem[index][3] == SECONDARYguardianelixer) then
									if (GMGuardianElixirItem[index][5] > GuardianElixirItemRank) and 
										(primary == "no") or 
										(primary == "no") and (secondary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][5];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										secondary = "yes";
									elseif (GMGuardianElixirItem[index][5] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][5] < GuardianElixirItemRank) and (primary == "no") or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][5] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][5];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								elseif	(GMGuardianElixirItem[index][4] == SECONDARYguardianelixer) then
									if (GMGuardianElixirItem[index][6] > GuardianElixirItemRank) and 
										(primary == "no") or 
										(primary == "no") and (secondary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][6];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										secondary = "yes";
									elseif (GMGuardianElixirItem[index][6] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][6] < GuardianElixirItemRank) and (primary == "no") or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][6] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][6];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								elseif	(GMGuardianElixirItem[index][3] == TERTIARYguardianelixer) then
									if (GMGuardianElixirItem[index][5] > GuardianElixirItemRank) and
										(primary == "no") and (secondary == "no") or 
										(primary == "no") and (secondary == "no") and (tertiary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][5];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										tertiary = "yes";
									elseif (GMGuardianElixirItem[index][5] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][5] < GuardianElixirItemRank) and 
										(primary == "no") and (secondary == "no") or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][5] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][5];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								elseif	(GMGuardianElixirItem[index][4] == TERTIARYguardianelixer) then
									if (GMGuardianElixirItem[index][6] > GuardianElixirItemRank) and
										(primary == "no") and (secondary == "no") or 
										(primary == "no") and (secondary == "no") and (tertiary == "no") then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = GMGuardianElixirItem[index][6];
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
										tertiary = "yes";
									elseif (GMGuardianElixirItem[index][6] > BGuardianElixirItemRank) and 
										(GMGuardianElixirItem[index][6] < GuardianElixirItemRank) and 
										(primary == "no") and (secondary == "no") or 
										(BGuardianElixirItemNum == 0) then
										if (GMGuardianElixirItem[index][6] ~= GuardianElixirItemRank) then
											BGuardianElixirItemRank = GMGuardianElixirItem[index][6];
											BGuardianElixirItemNum = itemNumber;
										end
									end
								end
							end
						end
					end
				end
			end
			if (GuardianElixirItemNum == 0) then
				for slot = 1, bagSlotCnt, 1 do
					local itemLink = GetContainerItemLink(bagID, slot);
					local itemNumber = GMGuardianElixir_NumFromLink(itemLink);
					if (itemNumber) then
						for index = 1, #(GMGuardianElixirItem), 1 do
							if (GMGuardianElixirItem[index][1] == itemNumber) and (itemNumber ~= EX_G_OTH_WATERWALK) then
								if (GMGuardianElixirItem[index][2] <= UnitLevel("player")) then
									if (index > GuardianElixirItemRank) then
										BGuardianElixirItemRank = GuardianElixirItemRank;
										GuardianElixirItemRank = index;
										BGuardianElixirItemNum = GuardianElixirItemNum;
										GuardianElixirItemNum = itemNumber;
									elseif ((index > BGuardianElixirItemRank) and (index < GuardianElixirItemRank)) then
										BGuardianElixirItemRank = index;
										BGuardianElixirItemNum = itemNumber;
									end
								end
							end
						end
					end
				end
			end
		end
	end
  
	if ((GuardianElixirItemRank > 0) and (BGuardianElixirItemRank > 0)) then
		EditMacro(GMGuardianElixir_MACRONAME, GMGuardianElixir_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..WATERW.." [mod:shift] item:"..BGuardianElixirItemNum.."; [] item:"..GuardianElixirItemNum);
	elseif ((GuardianElixirItemRank > 0) and (BGuardianElixirItemRank == 0)) then
		EditMacro(GMGuardianElixir_MACRONAME, GMGuardianElixir_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..WATERW.." [] item:"..GuardianElixirItemNum);
	elseif (GuardianElixirItemRank == 0) then
		EditMacro(GMGuardianElixir_MACRONAME, GMGuardianElixir_MACRONAME, NoWATERW, "#showtooltip\n/use "..WATERW2);
	end
end

function GMGuardianElixir_NumFromLink(itemLink)
	if (not itemLink) then
		return nil;
	end
	local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
	return itemNumber;
end
