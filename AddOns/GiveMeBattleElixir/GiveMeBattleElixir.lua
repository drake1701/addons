--[[
        Give Me Battle Elixir:
                Copyright 2009 by MERK, Mileg
				Updated by Grimgrin
                GMBE v0.1 coded by PcVII
                based on code by MERK, Mileg and Stephen Blaising		
                
]]

GMBattleElixir_ADDONNAME = "Give Me Battle Elixir";
GMBattleElixir_MACRONAME = "GMBattleElixir";

GMBattleElixir_VERSION = "4.5.1";

EXBALLBS = "";
EXBALLBS2 = "";
NoEXBALLBS = "INV_Misc_QuestionMark";
BEIcon = "Spell_misc_emotionangry";
GMBattleElixir_Save = {};
local PRIMARYbattleelixer;
local SECONDARYbattleelixer;
local TERTIARYbattleelixer;
local Realm;
local Player;
local GMBattleElixir_UpdateFrame
local GMBattleUpdate       = {}
GMBattleElixir_UpdateFrame = CreateFrame("Frame")

function GMBattleElixir_OnLoad()

  SlashCmdList["GIVEMEBATTLEELIXIRCOMMAND"] = GMBattleElixir_SlashHandler;
  SLASH_GIVEMEBATTLEELIXIRCOMMAND1 = "/givemebattleelixir";
  SLASH_GIVEMEBATTLEELIXIRCOMMAND2 = "/gmbattleelixir";
  SLASH_GIVEMEBATTLEELIXIRCOMMAND3 = "/gmbe";
  
end

function GMBattleElixir_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMBattleElixir_MACRONAME) == 0) then
      local numGenMacros, numCharMacros = GetNumMacros();
      if (numGenMacros < 36) then
        CreateMacro(GMBattleElixir_MACRONAME, BEIcon, "", nil, nil)
      else
        GMBattleElixir_Print("You have 36 General Macros. Cannot add "..GMBattleElixir_MACRONAME.."!");
      end
    end
		GMBattleElixir_UpdateFrame:SetScript("OnUpdate", GMBattleElixir_UpdateFrame_OnUpdate)
  elseif (event == "VARIABLES_LOADED") then
  GMBattleElixir_InitVars();
end
  if event == "BAG_UPDATE" then
		GMBattleElixir_UpdateFrame:SetScript("OnUpdate", GMBattleElixir_UpdateFrame_OnUpdate)
  end
end


function GMBattleElixir_UpdateFrame_OnUpdate(self, elapsed)
local affectingCombat = UnitAffectingCombat("player");
	for i = 0, 11 do
		if GMBattleUpdate[i] then
			GMBattleUpdate[i] = nil
		end
	end
	if GMBattleUpdate.inv then
		GMBattleUpdate.inv = nil
	end
	if(affectingCombat ~= 1) then
	self:SetScript("OnUpdate", nil)
	GMBattleElixir_MakeArray();
    GMBattleElixir_Go();
	end
end


function GMBattleElixir_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help") then
    GMBattleElixir_Print(GMBattleElixir_ADDONNAME.." |cff3399CCv"..GMBattleElixir_VERSION.." ");
    GMBattleElixir_Print("Type /macro to open macro list.");
    GMBattleElixir_Print("Drag GMBattleElixir macro to your action bar.");
    GMBattleElixir_Print("Click to eat best Battle Elixir.");
    GMBattleElixir_Print("Hold SHIFT and click to drink second best Battle Elixir.");
    GMBattleElixir_Print("Hold CTRL and click to drink a \"All base stats\" Elixir (if you have one).");
    GMBattleElixir_Print("/gmbe will display the current battle elixer order.");
    GMBattleElixir_Print("/gmbe b1=[BATTLEELIXIRTYPE] will update the first battle elixer used in sorting the GMBattleElixir macro.");
    GMBattleElixir_Print("/gmbe b2=[BATTLEELIXIRTYPE] will update the second battle elixer used in sorting the GMBattleElixir macro.");
    GMBattleElixir_Print("/gmbe b3=[BATTLEELIXIRTYPE] will update the third battle elixer used in sorting the GMBattleElixir macro.");
    GMBattleElixir_Print("Replace [BATTLEELIXIRTYPE] with the following:");
    GMBattleElixir_Print("    all for All Base Stats");
    GMBattleElixir_Print("    agi for Agility");
     GMBattleElixir_Print("   atk for Attack Power");
    GMBattleElixir_Print("    crt for Critical Strike Rating");
    GMBattleElixir_Print("    exp for Expertise");
    GMBattleElixir_Print("    has for Haste");
    --GMBattleElixir_Print("    hp5 for Health Per 5");
    GMBattleElixir_Print("    hit for Hit Rating");
    GMBattleElixir_Print("    int for Intellect");
    GMBattleElixir_Print("    mas for Mastery");
    --GMBattleElixir_Print("    mp5 for Mana Per 5");
    GMBattleElixir_Print("    oth for Other (miscellaneous)");
    GMBattleElixir_Print("    res for Resistance");
    GMBattleElixir_Print("    spl for Spell Power");
    GMBattleElixir_Print("    spi for Spirit");
    GMBattleElixir_Print("    sta for Stamina");
    GMBattleElixir_Print("    str for Strength");

  elseif (msg == "") then
    GMBattleElixir_Print("Battle Elixir Order");
    GMBattleElixir_Print("First Choice: "..PRIMARYbattleelixer);
    GMBattleElixir_Print("Second Choice: "..SECONDARYbattleelixer);
    GMBattleElixir_Print("Third Choice: "..TERTIARYbattleelixer);
  elseif (msg == "b1=all") then
    PRIMARYbattleelixer = "All Base Stats";
    GMBattleElixir_Print("Primary Battle Elixir set to All Base Stats");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=all") then
    SECONDARYbattleelixer = "All Base Stats";
    GMBattleElixir_Print("Secondary Battle Elixir set to All Base Stats");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=all") then
    TERTIARYbattleelixer = "All Base Stats";
    GMBattleElixir_Print("Tertiary Battle Elixir set to All Base Stats");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=agi") then
    PRIMARYbattleelixer = "Agility";
    GMBattleElixir_Print("Primary Battle Elixir set to Agility");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=agi") then
    SECONDARYbattleelixer = "Agility";
    GMBattleElixir_Print("Secondary Battle Elixir set to Agility");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=agi") then
    TERTIARYbattleelixer = "Agility";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Agility");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=atk") then
    PRIMARYbattleelixer = "Attack Power";
    GMBattleElixir_Print("Primary Battle Elixir set to Attack Power");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=atk") then
    SECONDARYbattleelixer = "Attack Power";
    GMBattleElixir_Print("Secondary Battle Elixir set to Attack Power");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=atk") then
    TERTIARYbattleelixer = "Attack Power";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Attack Power");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=crt") then
    PRIMARYbattleelixer = "Critical Strike Rating";
    GMBattleElixir_Print("Primary Battle Elixir set to Critical Strike");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=crt") then
    SECONDARYbattleelixer = "Critical Strike Rating";
    GMBattleElixir_Print("Secondary Battle Elixir set to Critical Strike");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=crt") then
    TERTIARYbattleelixer = "Critical Strike Rating";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Critical Strike");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=exp") then
    PRIMARYbattleelixer = "Expertise";
    GMBattleElixir_Print("Primary Battle Elixir set to Expertise");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=exp") then
    SECONDARYbattleelixer = "Expertise";
    GMBattleElixir_Print("Secondary Battle Elixir set to Expertise");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=exp") then
    TERTIARYbattleelixer = "Expertise";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Expertise");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=has") then
    PRIMARYbattleelixer = "Haste";
    GMBattleElixir_Print("Primary Battle Elixir set to Haste");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=has") then
    SECONDARYbattleelixer = "Haste";
    GMBattleElixir_Print("Secondary Battle Elixir set to Haste");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=has") then
    TERTIARYbattleelixer = "Haste";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Haste");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=hp5") then
    PRIMARYbattleelixer = "Health Per 5";
    GMBattleElixir_Print("Primary Battle Elixir set to Health per 5");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=hp5") then
    SECONDARYbattleelixer = "Health Per 5";
    GMBattleElixir_Print("Secondary Battle Elixir set to Health per 5");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=hp5") then
    TERTIARYbattleelixer = "Health Per 5";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Health per 5");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=hit") then
    PRIMARYbattleelixer = "Hit Rating";
    GMBattleElixir_Print("Primary Battle Elixir set to Hit Rating");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=hit") then
    SECONDARYbattleelixer = "Hit Rating";
    GMBattleElixir_Print("Secondary Battle Elixir set to Hit Rating");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=hit") then
    TERTIARYbattleelixer = "Hit Rating";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Hit Rating");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=int") then
    PRIMARYbattleelixer = "Intellect";
    GMBattleElixir_Print("Primary Battle Elixir set to Intellect");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=int") then
    SECONDARYbattleelixer = "Intellect";
    GMBattleElixir_Print("Secondary Battle Elixir set to Intellect");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=int") then
    TERTIARYbattleelixer = "Intellect";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Intellect");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=mas") then
    PRIMARYbattleelixer = "Mastery";
    GMBattleElixir_Print("Primary Battle Elixir set to Mastery");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=mas") then
    SECONDARYbattleelixer = "Mastery";
    GMBattleElixir_Print("Secondary Battle Elixir set to Mastery");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=mas") then
    TERTIARYbattleelixer = "Mastery";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Mastery");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
	elseif (msg == "b1=mp5") then
    PRIMARYbattleelixer = "Mana Per 5";
    GMBattleElixir_Print("Primary Battle Elixir set to Mana per 5");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=mp5") then
    SECONDARYbattleelixer = "Mana Per 5";
    GMBattleElixir_Print("Secondary Battle Elixir set to Mana per 5");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=mp5") then
    TERTIARYbattleelixer = "Mana Per 5";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Mana per 5");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=oth") then
    PRIMARYbattleelixer = "Other";
    GMBattleElixir_Print("Primary Battle Elixir set to Other");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=oth") then
    SECONDARYbattleelixer = "Other";
    GMBattleElixir_Print("Secondary Battle Elixir set to Other");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=oth") then
    TERTIARYbattleelixer = "Other";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Other");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=res") then
    PRIMARYbattleelixer = "Resistance";
    GMBattleElixir_Print("Primary Battle Elixir set to Resistance");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=res") then
    SECONDARYbattleelixer = "Resistance";
    GMBattleElixir_Print("Secondary Battle Elixir set to Resistance");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=res") then
    TERTIARYbattleelixer = "Resistance";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Resistance");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=spl") then
    PRIMARYbattleelixer = "Spell Power";
    GMBattleElixir_Print("Primary Battle Elixir set to Spell Power");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=spl") then
    SECONDARYbattleelixer = "Spell Power";
    GMBattleElixir_Print("Secondary Battle Elixir set to Spell Power");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=spl") then
    TERTIARYbattleelixer = "Spell Power";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Spell Power");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=spi") then
    PRIMARYbattleelixer = "Spirit";
    GMBattleElixir_Print("Primary Battle Elixir set to Spirit");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=spi") then
    SECONDARYbattleelixer = "Spirit";
    GMBattleElixir_Print("Secondary Battle Elixir set to Spirit");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=spi") then
    TERTIARYbattleelixer = "Spirit";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Spirit");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=sta") then
    PRIMARYbattleelixer = "Stamina";
    GMBattleElixir_Print("Primary Battle Elixir set to Stamina");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=sta") then
    SECONDARYbattleelixer = "Stamina";
    GMBattleElixir_Print("Secondary Battle Elixir set to Stamina");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=sta") then
    TERTIARYbattleelixer = "Stamina";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Stamina");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b1=str") then
    PRIMARYbattleelixer = "Strength";
    GMBattleElixir_Print("Primary Battle Elixir set to Strength");
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = PRIMARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b2=str") then
    SECONDARYbattleelixer = "Strength";
    GMBattleElixir_Print("Secondary Battle Elixir set to Strength");
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = SECONDARYbattleelixer;
    GMBattleElixir_Go();
  elseif (msg == "b3=str") then
    TERTIARYbattleelixer = "Strength";
    GMBattleElixir_Print("Tertiary Battle Elixir set to Strength");
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = TERTIARYbattleelixer;
    GMBattleElixir_Go();
  end
end

function GMBattleElixir_Print(msg)
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMBattleElixir_InitVars()
  
  Player=UnitName("player");
  Realm=GetCVar("realmName");

  if GMBattleElixir_Save[Realm] == nil then
    GMBattleElixir_Save[Realm] = {}
  end

  if GMBattleElixir_Save[Realm][Player] == nil then
    GMBattleElixir_Save[Realm][Player] = {}
  end

  if (GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer == nil) then
    GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer = "Stamina";
    PRIMARYbattleelixer = "Stamina";
  else
    PRIMARYbattleelixer = GMBattleElixir_Save[Realm][Player].PRIMARYbattleelixer;
  end

  if (GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer == nil) then
    GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer = "Spirit";
    SECONDARYbattleelixer = "Spirit";
  else
    SECONDARYbattleelixer = GMBattleElixir_Save[Realm][Player].SECONDARYbattleelixer;
  end

  if (GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer == nil) then
    GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer = "Critical Strike Rating";
    TERTIARYbattleelixer = "Critical Strike Rating";
  else
    TERTIARYbattleelixer = GMBattleElixir_Save[Realm][Player].TERTIARYbattleelixer;
  end
end

function GMBattleElixir_MakeArray()
  GMBattleElixirItem = {
	--ALL Base Stats
	-- [INDEX] = {[1] = ITEMID, [2] = ITEMLEVEL, [3] BUFFTYPE_1, [4] BUFFTYPE_2, [5] BUFFAMT_1, [6] BUFFAMT_2},
[80] = {  [1] = EX_B_ALLBS_15,			[2] = 50,		[3] = ALLBS,	[4] = NON,	[5] = 15,	[6] = 0},
[79] = {  [1] = EX_B_ALLBS_20,			[2] = 70,		[3] = ALLBS,	[4] = NON,	[5] = 20,	[6] = 0},
[78] = {  [1] = EX_B_STR_18_STA_18,	[2] = 45,		[3] = STR,		[4] = STA,	[5] = 18,	[6] = 18 },
[77] = {  [1] = EX_B_SPL_24_SPI_24,			[2] = 50,		[3] = SPL,		[4] = SPI,	[5] = 24,	[6] = 24 },
[76] = {  [1] = EX_B_SPL_24_CRT_24,		[2] = 50,		[3] = SPL,		[4] = CRT,	[5] = 24,	[6] = 24 },
[75] = {  [1] = EX_B_AGI_30_CRT_12,			[2] = 55,		[3] = AGI,		[4] = CRT,	[5] = 30,	[6] = 12 },
[74] = {  [1] = EX_B_AGI_25_CRT_10,			[2] = 46,		[3] = AGI,		[4] = CRT,	[5] = 25,	[6] = 10 },
[73] = {  [1] = SC_AGI_100,				[2] = 80,		[3] = AGI,		[4] = NON,	[5] =100,	[6] = 0 },
[72] = {  [1] = SC_AGI_30,				[2] = 80,		[3] = AGI,		[4] = NON,	[5] = 30,	[6] = 0 },
[71] = {  [1] = SC_AGI_25,				[2] = 70,		[3] = AGI,		[4] = NON,	[5] = 25,	[6] = 0 },
[70] = {  [1] = SC_AGI_20,				[2] = 60,		[3] = AGI,		[4] = NON,	[5] = 20,	[6] = 0 },
[69] = {  [1] = SC_AGI_15,				[2] = 50,		[3] = AGI,		[4] = NON,	[5] = 15,	[6] = 0 },
[68] = {  [1] = SC_AGI_10,				[2] = 40,		[3] = AGI,		[4] = NON,	[5] = 10,	[6] = 0 },
[67] = {  [1] = SC_AGI_8,					[2] = 30,		[3] = AGI,		[4] = NON,	[5] =  8,	[6] = 0 },
[66] = {  [1] = SC_AGI_5,					[2] = 15,		[3] = AGI,		[4] = NON,	[5] =  5,	[6] = 0 },
[65] = {  [1] = SC_AGI_3,					[2] = 1,		[3] = AGI,		[4] = NON,	[5] =  3,	[6] = 0 },
[64] = {  [1] = EX_B_AGI_45,				[2] = 70,		[3] = AGI,		[4] = NON,	[5] = 45,	[6] = 0 },
[63] = {  [1] = EX_B_AGI_25,				[2] = 38,		[3] = AGI,		[4] = NON,	[5] = 25,	[6] = 0 },
[62] = {  [1] = EX_B_AGI_25_2,			[2] = 1,		[3] = AGI,		[4] = NON,	[5] = 26,	[6] = 0 },
[61] = {  [1] = EX_B_AGI_15,				[2] = 27,		[3] = AGI,		[4] = NON,	[5] = 15,	[6] = 0 },
[60] = {  [1] = EX_B_AGI_8,				[2] = 18,		[3] = AGI,		[4] = NON,	[5] = 8,	[6] = 0 },
[59] = {  [1] = EX_B_AGI_4,				[2] = 2,		[3] = AGI,		[4] = NON,	[5] = 4,	[6] = 0 },
[58] = {  [1] = EX_B_AGI_25_CRT_25,		[2] = 70,		[3] = AGI,		[4] = CRI,	[5] = 25,	[6] = 25},
[57] = {  [1] = EX_B_ATK_90,				[2] = 70,		[3] = ATK,		[4] = NON,	[5] = 90,	[6] = 0 },
[56] = {  [1] = EX_B_ATK_90_STA_minus10,	[2] = 60,		[3] = ATK,		[4] = NON,	[5] = 89,	[6] = 0 },
[55] = {  [1] = EX_B_ATK_50,				[2] = 50,		[3] = ATK,		[4] = NON,	[5] = 50,	[6] = 0 },
[54] = {  [1] = EX_B_ATK_35,				[2] = 45,		[3] = ATK,		[4] = NON,	[5] = 35,	[6] = 0 },
[53] = {  [1] = EX_B_CRT_45,				[2] = 70,		[3] = CRT,		[4] = NON,	[5] = 45,	[6] = 0 },
[52] = {  [1] = EX_B_CRT_225,				[2] = 80,		[3] = CRT,		[4] = NON,	[5] = 225,	[6] = 0 },
[51] = {  [1] = EX_B_EXP_45,				[2] = 70,		[3] = EXP,		[4] = NON,	[5] = 45,	[6] = 0 },
[50] = {  [1] = EX_B_HAS_45,				[2] = 70,		[3] = HAS,		[4] = NON,	[5] = 45,	[6] = 0 },
[49] = {  [1] = EX_B_HAS_225,				[2] = 80,		[3] = HAS,		[4] = NON,	[5] = 225,	[6] = 0 },
[48] = {  [1] = EX_B_HIT_45,				[2] = 70,		[3] = HIT,		[4] = NON,	[5] = 45,	[6] = 0 },
[47] = {  [1] = EX_B_HIT_225,				[2] = 80,		[3] = HIT,		[4] = NON,	[5] = 225,	[6] = 0 }, 
[46] = {  [1] = SC_INT_100,					[2] = 80,		[3] = INT,		[4] = NON,	[5] =100,	[6] = 0 },
[45] = {  [1] = SC_INT_30,					[2] = 80,		[3] = INT,		[4] = NON,	[5] = 30,	[6] = 0 },
[44] = {  [1] = SC_INT_25,					[2] = 70,		[3] = INT,		[4] = NON,	[5] = 25,	[6] = 0 },
[43] = {  [1] = SC_INT_20,					[2] = 60,		[3] = INT,		[4] = NON,	[5] = 20,	[6] = 0 },
[42] = {  [1] = SC_INT_15,					[2] = 50,		[3] = INT,		[4] = NON,	[5] = 15,	[6] = 0 },
[41] = {  [1] = SC_INT_10,					[2] = 40,		[3] = INT,		[4] = NON,	[5] = 10,	[6] = 0 },
[40] = {  [1] = SC_INT_8,						[2] = 30,		[3] = INT,		[4] = NON,	[5] =  8,	[6] = 0 },
[39] = {  [1] = SC_INT_5,						[2] = 15,		[3] = INT,		[4] = NON,	[5] =  5,	[6] = 0 },
[38] = {  [1] = SC_INT_3,						[2] = 1,		[3] = INT,		[4] = NON,	[5] =  3,	[6] = 0 },
[37] = {  [1] = EX_B_SPL_58,				[2] = 70,		[3] = SPL,		[4] = NON,	[5] = 58,	[6] = 0 },
[36] = {  [1] = EX_B_SPL_40,				[2] = 40,		[3] = SPL,		[4] = NON,	[5] = 40,	[6] = 0 },
[35] = {  [1] = EX_B_SPL_35,				[2] = 47,		[3] = SPL,		[4] = NON,	[5] = 35,	[6] = 0 },
[34] = {  [1] = EX_B_SPL_20,				[2] = 37,		[3] = SPL,		[4] = NON,	[5] = 20,	[6] = 0 },
[33] = {  [1] = SC_SPI_100,					[2] = 80,		[3] = SPI,		[4] = NON,	[5] =100,	[6] = 0 },
[32] = {  [1] = SC_SPI_30,					[2] = 80,		[3] = SPI,		[4] = NON,	[5] = 30,	[6] = 0 },
[31] = {  [1] = SC_SPI_25,					[2] = 70,		[3] = SPI,		[4] = NON,	[5] = 25,	[6] = 0 },
[30] = {  [1] = SC_SPI_20,					[2] = 60,		[3] = SPI,		[4] = NON,	[5] = 20,	[6] = 0 },
[29] = {  [1] = SC_SPI_15,					[2] = 50,		[3] = SPI,		[4] = NON,	[5] = 15,	[6] = 0 },
[28] = {  [1] = SC_SPI_10,					[2] = 40,		[3] = SPI,		[4] = NON,	[5] = 10,	[6] = 0 },
[27] = {  [1] = SC_SPI_8,						[2] = 30,		[3] = SPI,		[4] = NON,	[5] =  8,	[6] = 0 },
[26] = {  [1] = SC_SPI_5,						[2] = 15,		[3] = SPI,		[4] = NON,	[5] =  5,	[6] = 0 },
[25] = {  [1] = SC_SPI_3,						[2] = 1,		[3] = SPI,		[4] = NON,	[5] =  3,	[6] = 0 },
[24] = {  [1] = SC_STR_100,					[2] = 80,		[3] = STR,		[4] = NON,	[5] =100,	[6] = 0 },
[23] = {  [1] = SC_STR_30,					[2] = 80,		[3] = STR,		[4] = NON,	[5] = 30,	[6] = 0 },
[22] = {  [1] = SC_STR_25,					[2] = 70,		[3] = STR,		[4] = NON,	[5] = 25,	[6] = 0 },
[21] = {  [1] = SC_STR_20,					[2] = 60,		[3] = STR,		[4] = NON,	[5] = 20,	[6] = 0 },
[20] = {  [1] = SC_STR_15,					[2] = 50,		[3] = STR,		[4] = NON,	[5] = 15,	[6] = 0 },
[19] = {  [1] = SC_STR_10,					[2] = 40,		[3] = STR,		[4] = NON,	[5] = 10,	[6] = 0 },
[18] = {  [1] = SC_STR_8,						[2] = 30,		[3] = STR,		[4] = NON,	[5] =  8,	[6] = 0 },
[17] = {  [1] = SC_STR_5,						[2] = 15,		[3] = STR,		[4] = NON,	[5] =  5,	[6] = 0 },
[16] = {  [1] = SC_STR_3,						[2] = 1,		[3] = STR,		[4] = NON,	[5] =  3,	[6] = 0 },
[15] = {  [1] = EX_B_STR_50,				[2] = 70,		[3] = STR,		[4] = NON,	[5] = 50,	[6] = 0 },
[14] = {  [1] = EX_B_STR_35,				[2] = 50,		[3] = STR,		[4] = NON,	[5] = 35,	[6] = 0 },
[13] = {  [1] = EX_B_STR_25,				[2] = 38,		[3] = STR,		[4] = NON,	[5] = 25,	[6] = 0 },
[12] = {  [1] = EX_B_STR_25_2,			[2] = 1,		[3] = STR,		[4] = NON,	[5] = 26,	[6] = 0 },
[11] = {  [1] = EX_B_STR_8,				[2] = 8,		[3] = STR,		[4] = NON,	[5] = 9,	[6] = 0 },
[10] = {  [1] = EX_B_STR_8_2,				[2] = 20,		[3] = STR,		[4] = NON,	[5] = 8,	[6] = 0 },
[9] = {  [1] = EX_B_STR_4,				[2] = 1,		[3] = STR,		[4] = NON,	[5] = 4,	[6] = 0 },
[8] = {  [1] = MIX_B_G_ATK_180,			[2] = 1,		[3] = ATK,		[4] = NON,	[5] = 181,	[6] = 0 },
[7] = {  [1] = FLASK_B_G_ATK_180,		[2] = 75,		[3] = ATK,		[4] = NON,	[5] = 180,	[6] = 0 },
[6] = {  [1] = FLASK_B_G_ATK_120,		[2] = 65,		[3] = ATK,		[4] = NON,	[5] = 120,	[6] = 0 },
[5] = {  [1] = MIX_B_G_SPL_125,			[2] = 1,		[3] = SPL,		[4] = NON,	[5] = 126,	[6] = 0 },
[4] = {  [1] = FLASK_B_G_SPL_125,		[2] = 75,		[3] = SPL,		[4] = NON,	[5] = 125,	[6] = 0 },
[3] = {  [1] = FLASK_B_G_SPL_70,			[2] = 65,		[3] = SPL,		[4] = NON,	[5] = 70,	[6] = 0 },
[2] = {  [1] = EX_B_MAS_225,				[2] = 80,		[3] = MAS,		[4] = NON,	[5] = 225,	[6] = 0 },
[1] = {  [1] = EX_B_SPI_225,				[2] = 80,		[3] = SPI,		[4] = NON,	[5] = 225,	[6] = 0 },
	}
end

function GMBattleElixir_Go()
  
  local BattleElixirItemRank = 0;
  local BBattleElixirItemRank = 0;
  local BattleElixirItemNum = 0;
  local BBattleElixirItemNum = 0;
  local oldBFoodItemLink = "Nothing";
  local BoldBFoodItemLink = "Nothing";
  local exact = "no";
  local SECexact = "no";
  local TERexact = "no";
  local primary = "no";
  local secondary = "no";
  local tertiary = "no";

EXBALLBS = "";
EXBALLBS2 = "";
NoEXBALLBS = BEIcon;
  for bagID = 0, 4, 1 do
    local bagSlotCnt = GetContainerNumSlots(bagID);
    if (bagSlotCnt > 0) then
      for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMBattleElixir_NumFromLink(itemLink);
        if (itemNumber) then
          for index = 1, #(GMBattleElixirItem), 1 do
            if (GMBattleElixirItem[index][1] == itemNumber) then
              if (GMBattleElixirItem[index][2] <= UnitLevel("player")) then
              
				if (index <= 2) then
					EXBALLBS = "[mod:ctrl] item:"..GMBattleElixirItem[index][1]..";";
					EXBALLBS2 = "[] item:"..GMBattleElixirItem[index][1]..";";
                elseif	(GMBattleElixirItem[index][3] == PRIMARYbattleelixer) then
					if (GMBattleElixirItem[index][5] > BattleElixirItemRank) or 
						(primary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][5];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						primary = "yes";
					elseif (GMBattleElixirItem[index][5] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][5] < BattleElixirItemRank) or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][5] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][5];
							BBattleElixirItemNum = itemNumber;
						end
					end
                elseif	(GMBattleElixirItem[index][4] == PRIMARYbattleelixer) then
					if (GMBattleElixirItem[index][6] > BattleElixirItemRank) or 
						(primary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][6];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						primary = "yes";
					elseif (GMBattleElixirItem[index][6] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][6] < BattleElixirItemRank) or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][6] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][6];
							BBattleElixirItemNum = itemNumber;
						end
					end
                elseif	(GMBattleElixirItem[index][3] == SECONDARYbattleelixer) then
					if (GMBattleElixirItem[index][5] > BattleElixirItemRank) and 
						(primary == "no") or 
						(primary == "no") and (secondary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][5];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						secondary = "yes";
					elseif (GMBattleElixirItem[index][5] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][5] < BattleElixirItemRank) and (primary == "no") or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][5] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][5];
							BBattleElixirItemNum = itemNumber;
						end
					end
                elseif	(GMBattleElixirItem[index][4] == SECONDARYbattleelixer) then
					if (GMBattleElixirItem[index][6] > BattleElixirItemRank) and 
						(primary == "no") or 
						(primary == "no") and (secondary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][6];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						secondary = "yes";
					elseif (GMBattleElixirItem[index][6] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][6] < BattleElixirItemRank) and (primary == "no") or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][6] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][6];
							BBattleElixirItemNum = itemNumber;
						end
					end
                elseif	(GMBattleElixirItem[index][3] == TERTIARYbattleelixer) then
					if (GMBattleElixirItem[index][5] > BattleElixirItemRank) and
						(primary == "no") and (secondary == "no") or 
						(primary == "no") and (secondary == "no") and (tertiary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][5];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						tertiary = "yes";
					elseif (GMBattleElixirItem[index][5] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][5] < BattleElixirItemRank) and 
						(primary == "no") and (secondary == "no") or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][5] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][5];
							BBattleElixirItemNum = itemNumber;
						end
					end
                elseif	(GMBattleElixirItem[index][4] == TERTIARYbattleelixer) then
					if (GMBattleElixirItem[index][6] > BattleElixirItemRank) and
						(primary == "no") and (secondary == "no") or 
						(primary == "no") and (secondary == "no") and (tertiary == "no") then
						BBattleElixirItemRank = BattleElixirItemRank;
						BattleElixirItemRank = GMBattleElixirItem[index][6];
						BBattleElixirItemNum = BattleElixirItemNum;
						BattleElixirItemNum = itemNumber;
						tertiary = "yes";
					elseif (GMBattleElixirItem[index][6] > BBattleElixirItemRank) and 
						(GMBattleElixirItem[index][6] < BattleElixirItemRank) and 
						(primary == "no") and (secondary == "no") or 
						(BBattleElixirItemNum == 0) then
						if (GMBattleElixirItem[index][6] ~= BattleElixirItemRank) then
							BBattleElixirItemRank = GMBattleElixirItem[index][6];
							BBattleElixirItemNum = itemNumber;
						end
					end
                end
              end
            end
          end
        end
      end
      if (BattleElixirItemNum == 0) then
        for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMBattleElixir_NumFromLink(itemLink);
          if (itemNumber) then
            for index = 3, #(GMBattleElixirItem), 1 do
              if (GMBattleElixirItem[index][1] == itemNumber) then
                if (GMBattleElixirItem[index][2] <= UnitLevel("player")) then
                  if (GMBattleElixirItem[index][5] + GMBattleElixirItem[index][6] > BattleElixirItemRank) then
                    BBattleElixirItemRank = BattleElixirItemRank;
                    BattleElixirItemRank = GMBattleElixirItem[index][5] + GMBattleElixirItem[index][6];
                    BBattleElixirItemNum = BattleElixirItemNum;
                    BattleElixirItemNum = itemNumber;
                  elseif ((GMBattleElixirItem[index][5] + GMBattleElixirItem[index][6] > BBattleElixirItemRank) and 
					(GMBattleElixirItem[index][5] + GMBattleElixirItem[index][6] < BattleElixirItemRank)) then
                    BBattleElixirItemRank = GMBattleElixirItem[index][5] + GMBattleElixirItem[index][6];
                    BBattleElixirItemNum = itemNumber;
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  if ((BattleElixirItemRank > 0) and (BBattleElixirItemRank > 0)) then
    EditMacro(GMBattleElixir_MACRONAME, GMBattleElixir_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..EXBALLBS.." [mod:shift] item:"..BBattleElixirItemNum.."; [] item:"..BattleElixirItemNum, nil, nil);
  elseif ((BattleElixirItemRank > 0) and (BBattleElixirItemRank == 0)) then
    EditMacro(GMBattleElixir_MACRONAME, GMBattleElixir_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..EXBALLBS.." [] item:"..BattleElixirItemNum, nil, nil);
  elseif (BattleElixirItemRank == 0) then
    EditMacro(GMBattleElixir_MACRONAME, GMBattleElixir_MACRONAME, NoEXBALLBS, "#showtooltip\n/use "..EXBALLBS2, nil, nil);
  end
end

function GMBattleElixir_NumFromLink(itemLink)
  if (not itemLink) then
    return nil;
  end
  local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
  return itemNumber;
end
