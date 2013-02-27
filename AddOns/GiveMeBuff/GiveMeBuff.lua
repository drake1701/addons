--[[
        Give Me Buff:
                Copyright 2009 by MERK, Mileg
				Updated by Grimgrin
                based on code by Mileg and Stephen Blaising
                
]]

GMBuff_ADDONNAME = "Give Me Buff";
GMBuff_MACRONAME = "GMBuff";

GMBuff_VERSION = "4.5.1";

CAMPF = "";
CAMPF2 = "";
NoCAMPF = "INV_Misc_QuestionMark";
BFIcon = "Spell_misc_emotionhappy";
GMBuff_Save = {};
local PRIMARYbuff;
local SECONDARYbuff;
local TERTIARYbuff;
local Realm;
local Player;

local GMBuff_UpdateFrame;
local GMBuffUpdate       = {};
GMBuff_UpdateFrame = CreateFrame("Frame")

function GMBuff_OnLoad()

  SlashCmdList["GIVEMEBUFFCOMMAND"] = GMBuff_SlashHandler;
  SLASH_GIVEMEBUFFCOMMAND1 = "/givemebuff";
  SLASH_GIVEMEBUFFCOMMAND2 = "/gmbuff";
  SLASH_GIVEMEBUFFCOMMAND3 = "/gmb";
  
end

function GMBuff_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMBuff_MACRONAME) == 0) then
      local numGenMacros, numCharMacros = GetNumMacros();
      if (numGenMacros < 36) then
        CreateMacro(GMBuff_MACRONAME, BFIcon, "")
      else
        GMBuff_Print("You have 36 General Macros. Cannot add "..GMBuff_MACRONAME.."!");
      end
    end
    if (GetSpellInfo(COOKFIRE)) then
      CAMPF = "[mod:ctrl] "..COOKFIRE..";";
      CAMPF2 = "[] "..COOKFIRE..";";
    else
      CAMPF = "";
      NoCAMPF = BFIcon;
    end
		GMBuff_UpdateFrame:SetScript("OnUpdate", GMBuff_UpdateFrame_OnUpdate)
  elseif (event == "VARIABLES_LOADED") then
    GMBuff_InitVars();
end
  if event == "BAG_UPDATE" then
		GMBuff_UpdateFrame:SetScript("OnUpdate", GMBuff_UpdateFrame_OnUpdate)
  end
end

function GMBuff_UpdateFrame_OnUpdate(self, elapsed)
local affectingCombat = UnitAffectingCombat("player");
	for i = 0, 11 do
		if GMBuffUpdate[i] then
			GMBuffUpdate[i] = nil
		end
	end
	if GMBuffUpdate.inv then
		GMBuffUpdate.inv = nil
	end
	if(affectingCombat ~= 1) then
	self:SetScript("OnUpdate", nil)
	GMBuff_MakeArray();
    GMBuff_Go();
	end
end

function GMBuff_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help") then
    GMBuff_Print(GMBuff_ADDONNAME.." |cff3399CCv"..GMBuff_VERSION.." ");
    GMBuff_Print("Type /macro to open macro list.");
    GMBuff_Print("Drag GMBuff macro to your action bar.");
    GMBuff_Print("Click to eat best buff food.");
    GMBuff_Print("Hold SHIFT and click to eat second best buff food.");
    GMBuff_Print("Hold CTRL and click to create \"Basic Campfire\".");
    GMBuff_Print("/gmb will display the current buff order.");
    GMBuff_Print("/gmb b1=[BUFFTYPE] will update the first buff used in sorting the GMBuff macro.");
    GMBuff_Print("/gmb b2=[BUFFTYPE] will update the second buff used in sorting the GMBuff macro.");
    GMBuff_Print("/gmb b3=[BUFFTYPE] will update the third buff used in sorting the GMBuff macro.");
    GMBuff_Print("Replace [BUFFTYPE] with the following:");
    GMBuff_Print("    agi for Agility");
    GMBuff_Print("    atk for Attack Power");
    GMBuff_Print("    crt for Critical Strike Rating");
    GMBuff_Print("    dod for Dodge");
    GMBuff_Print("    exp for Expertise");
    GMBuff_Print("    has for Haste");
    GMBuff_Print("    hp5 for Health Per 5");
    GMBuff_Print("    hit for Hit Rating");
    GMBuff_Print("    int for Intellect");
    GMBuff_Print("    mas for Mastery");
    GMBuff_Print("    mp5 for Mana Per 5");
    GMBuff_Print("    oth for Other (miscellaneous)");
    GMBuff_Print("    res for Resistance");
    GMBuff_Print("    spl for Spell Power");
    GMBuff_Print("    spi for Spirit");
    GMBuff_Print("    sta for Stamina");
    GMBuff_Print("    str for Strength");
    GMBuff_Print("    use for Useful");
  elseif (msg == "") then
    GMBuff_Print("Buff Food Order");
    GMBuff_Print("First Choice: "..PRIMARYbuff);
    GMBuff_Print("Second Choice: "..SECONDARYbuff);
    GMBuff_Print("Third Choice: "..TERTIARYbuff);
  elseif (msg == "b1=use") then
    PRIMARYbuff = "Useful";
    GMBuff_Print("Primary Buff set to Useful");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=use") then
    SECONDARYbuff = "Useful";
    GMBuff_Print("Secondary Buff set to Useful");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=use") then
    TERTIARYbuff = "Useful";
    GMBuff_Print("Tertiary Buff set to Useful");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=agi") then
    PRIMARYbuff = "Agility";
    GMBuff_Print("Primary Buff set to Agility");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=agi") then
    SECONDARYbuff = "Agility";
    GMBuff_Print("Secondary Buff set to Agility");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=agi") then
    TERTIARYbuff = "Agility";
    GMBuff_Print("Tertiary Buff set to Agility");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
	elseif (msg == "b1=dod") then
    PRIMARYbuff = "Dodge";
    GMBuff_Print("Primary Buff set to Dodge");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=dod") then
    SECONDARYbuff = "Dodge";
    GMBuff_Print("Secondary Buff set to Dodge");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=dod") then
    TERTIARYbuff = "Dodge";
    GMBuff_Print("Tertiary Buff set to Dodge");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=atk") then
    PRIMARYbuff = "Attack Power";
    GMBuff_Print("Primary Buff set to Attack Power");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=atk") then
    SECONDARYbuff = "Attack Power";
    GMBuff_Print("Secondary Buff set to Attack Power");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=atk") then
    TERTIARYbuff = "Attack Power";
    GMBuff_Print("Tertiary Buff set to Attack Power");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=crt") then
    PRIMARYbuff = "Critical Strike Rating";
    GMBuff_Print("Primary Buff set to Critical Strike");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=crt") then
    SECONDARYbuff = "Critical Strike Rating";
    GMBuff_Print("Secondary Buff set to Critical Strike");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=crt") then
    TERTIARYbuff = "Critical Strike Rating";
    GMBuff_Print("Tertiary Buff set to Critical Strike");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=exp") then
    PRIMARYbuff = "Expertise";
    GMBuff_Print("Primary Buff set to Expertise");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=exp") then
    SECONDARYbuff = "Expertise";
    GMBuff_Print("Secondary Buff set to Expertise");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=exp") then
    TERTIARYbuff = "Expertise";
    GMBuff_Print("Tertiary Buff set to Expertise");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=has") then
    PRIMARYbuff = "Haste";
    GMBuff_Print("Primary Buff set to Haste");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=has") then
    SECONDARYbuff = "Haste";
    GMBuff_Print("Secondary Buff set to Haste");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=has") then
    TERTIARYbuff = "Haste";
    GMBuff_Print("Tertiary Buff set to Haste");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=hp5") then
    PRIMARYbuff = "Health Per 5";
    GMBuff_Print("Primary Buff set to Health per 5");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=hp5") then
    SECONDARYbuff = "Health Per 5";
    GMBuff_Print("Secondary Buff set to Health per 5");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=hp5") then
    TERTIARYbuff = "Health Per 5";
    GMBuff_Print("Tertiary Buff set to Health per 5");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=hit") then
    PRIMARYbuff = "Hit Rating";
    GMBuff_Print("Primary Buff set to Hit Rating");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=hit") then
    SECONDARYbuff = "Hit Rating";
    GMBuff_Print("Secondary Buff set to Hit Rating");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=hit") then
    TERTIARYbuff = "Hit Rating";
    GMBuff_Print("Tertiary Buff set to Hit Rating");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=int") then
    PRIMARYbuff = "Intellect";
    GMBuff_Print("Primary Buff set to Intellect");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=int") then
    SECONDARYbuff = "Intellect";
    GMBuff_Print("Secondary Buff set to Intellect");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=int") then
    TERTIARYbuff = "Intellect";
    GMBuff_Print("Tertiary Buff set to Intellect");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=mas") then
    PRIMARYbuff = "Mastery";
    GMBuff_Print("Primary Buff set to Mastery");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=mas") then
    SECONDARYbuff = "Mastery";
    GMBuff_Print("Secondary Buff set to Mastery");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=mas") then
    TERTIARYbuff = "Mastery";
    GMBuff_Print("Tertiary Buff set to Mastery");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=mp5") then
    PRIMARYbuff = "Mana Per 5";
    GMBuff_Print("Primary Buff set to Mana per 5");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=mp5") then
    SECONDARYbuff = "Mana Per 5";
    GMBuff_Print("Secondary Buff set to Mana per 5");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=mp5") then
    TERTIARYbuff = "Mana Per 5";
    GMBuff_Print("Tertiary Buff set to Mana per 5");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=oth") then
    PRIMARYbuff = "Other";
    GMBuff_Print("Primary Buff set to Other");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=oth") then
    SECONDARYbuff = "Other";
    GMBuff_Print("Secondary Buff set to Other");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=oth") then
    TERTIARYbuff = "Other";
    GMBuff_Print("Tertiary Buff set to Other");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=res") then
    PRIMARYbuff = "Resistance";
    GMBuff_Print("Primary Buff set to Resistance");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=res") then
    SECONDARYbuff = "Resistance";
    GMBuff_Print("Secondary Buff set to Resistance");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=res") then
    TERTIARYbuff = "Resistance";
    GMBuff_Print("Tertiary Buff set to Resistance");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=spl") then
    PRIMARYbuff = "Spell Power";
    GMBuff_Print("Primary Buff set to Spell Power");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=spl") then
    SECONDARYbuff = "Spell Power";
    GMBuff_Print("Secondary Buff set to Spell Power");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=spl") then
    TERTIARYbuff = "Spell Power";
    GMBuff_Print("Tertiary Buff set to Spell Power");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=spi") then
    PRIMARYbuff = "Spirit";
    GMBuff_Print("Primary Buff set to Spirit");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=spi") then
    SECONDARYbuff = "Spirit";
    GMBuff_Print("Secondary Buff set to Spirit");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=spi") then
    TERTIARYbuff = "Spirit";
    GMBuff_Print("Tertiary Buff set to Spirit");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=sta") then
    PRIMARYbuff = "Stamina";
    GMBuff_Print("Primary Buff set to Stamina");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=sta") then
    SECONDARYbuff = "Stamina";
    GMBuff_Print("Secondary Buff set to Stamina");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=sta") then
    TERTIARYbuff = "Stamina";
    GMBuff_Print("Tertiary Buff set to Stamina");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  elseif (msg == "b1=str") then
    PRIMARYbuff = "Strength";
    GMBuff_Print("Primary Buff set to Strength");
    GMBuff_Save[Realm][Player].PRIMARYbuff = PRIMARYbuff;
    GMBuff_Go();
  elseif (msg == "b2=str") then
    SECONDARYbuff = "Strength";
    GMBuff_Print("Secondary Buff set to Strength");
    GMBuff_Save[Realm][Player].SECONDARYbuff = SECONDARYbuff;
    GMBuff_Go();
  elseif (msg == "b3=str") then
    TERTIARYbuff = "Strength";
    GMBuff_Print("Tertiary Buff set to Strength");
    GMBuff_Save[Realm][Player].TERTIARYbuff = TERTIARYbuff;
    GMBuff_Go();
  end
end

function GMBuff_Print(msg)
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMBuff_InitVars()
  
  Player=UnitName("player");
  Realm=GetCVar("realmName");

  if GMBuff_Save[Realm] == nil then
    GMBuff_Save[Realm] = {}
  end

  if GMBuff_Save[Realm][Player] == nil then
    GMBuff_Save[Realm][Player] = {}
  end

  if (GMBuff_Save[Realm][Player].PRIMARYbuff == nil) then
    GMBuff_Save[Realm][Player].PRIMARYbuff = "Useful";
    PRIMARYbuff = "Useful";
  else
    PRIMARYbuff = GMBuff_Save[Realm][Player].PRIMARYbuff;
  end

  if (GMBuff_Save[Realm][Player].SECONDARYbuff == nil) then
    GMBuff_Save[Realm][Player].SECONDARYbuff = "Stamina";
    SECONDARYbuff = "Stamina";
  else
    SECONDARYbuff = GMBuff_Save[Realm][Player].SECONDARYbuff;
  end

  if (GMBuff_Save[Realm][Player].TERTIARYbuff == nil) then
    GMBuff_Save[Realm][Player].TERTIARYbuff = "Critical Strike Rating";
    TERTIARYbuff = "Critical Strike Rating";
  else
    TERTIARYbuff = GMBuff_Save[Realm][Player].TERTIARYbuff;
  end
end

function GMBuff_MakeArray()
  GMBuff_BuffFood = {

[228] = { [1] = BUFF_STA_450_74656, 							[2] = 90, [3] = STA, [4] = NON },
[227] = { [1] = BUFF_SPI_300_74653, 							[2] = 90, [3] = SPI, [4] = NON },
[226] = { [1] = BUFF_AGI_300_74648, 							[2] = 90, [3] = AGI, [4] = NON },
[225] = { [1] = BUFF_STR_300_74646, 							[2] = 90, [3] = STR, [4] = NON },
[224] = { [1] = BUFF_EXP_300_86074, 							[2] = 90, [3] = EXP, [4] = NON },
[223] = { [1] = BUFF_HIT_300_86073, 							[2] = 90, [3] = HIT, [4] = NON },
[222] = { [1] = BUFF_MAS_200_81414,								[2] = 90, [3] = MAS, [4] = NON },
[221] = { [1] = BUFF_HIT_200_81413,								[2] = 90, [3] = HIT, [4] = NON },
[220] = { [1] = BUFF_DOD_200_81412,								[2] = 90, [3] = DOD, [4] = NON },
[219] = { [1] = BUFF_PAR_200_81411, 							[2] = 90, [3] = PAR, [4] = NON },
[218] = { [1] = BUFF_CRI_200_81410, 							[2] = 90, [3] = CRI, [4] = NON },
[217] = { [1] = BUFF_HAS_200_81409,								[2] = 90, [3] = HAS, [4] = NON },
[216] = { [1] = BUFF_EXP_200_81408,							 	[2] = 90, [3] = EXP, [4] = NON },
[215] = { [1] = BUFF_STA_90_79320, 								[2] = 90, [3] = STA, [4] = NON },
[214] = { [1] = BUFF_STA_415_74655, 							[2] = 87, [3] = STA, [4] = NON },
[213] = { [1] = BUFF_SPI_275_74652, 							[2] = 87, [3] = SPI, [4] = NON },
[212] = { [1] = BUFF_AGI_275_74647, 							[2] = 87, [3] = AGI, [4] = NON },
[211] = { [1] = BUFF_STR_275_74645, 							[2] = 87, [3] = STR, [4] = NON },
[210] = { [1] = BUFF_HIT_275_86070, 							[2] = 87, [3] = HIT, [4] = NON },
[209] = { [1] = BUFF_EXP_275_86069, 							[2] = 87, [3] = EXP, [4] = NON },
[208] = { [1] = BUFF_STA_375_74654, 							[2] = 85, [3] = STA, [4] = NON },
[207] = { [1] = BUFF_USE_275_88586, 							[2] = 85, [3] = USE, [4] = NON },
[206] = { [1] = BUFF_USE_275_88388, 							[2] = 85, [3] = USE, [4] = NON },
[205] = { [1] = BUFF_SPI_250_74651,			 					[2] = 85, [3] = SPI, [4] = NON },
[204] = { [1] = BUFF_AGI_250_74643, 							[2] = 85, [3] = AGI, [4] = NON },
[203] = { [1] = BUFF_STR_250_74642, 							[2] = 85, [3] = STR, [4] = NON },
[202] = { [1] = BUFF_ATT_100_81403, 							[2] = 85, [3] = ATT, [4] = NON },
[201] = { [1] = BUFF_MAS_100_81406, 							[2] = 85, [3] = MAS, [4] = NON },
[200] = { [1] = BUFF_HIT_100_81405, 							[2] = 85, [3] = HIT, [4] = NON },
[199] = { [1] = BUFF_DOD_100_81404, 							[2] = 85, [3] = DOD, [4] = NON },
[198] = { [1] = BUFF_ATT_100_81402, 							[2] = 85, [3] = ATT, [4] = NON },
[197] = { [1] = BUFF_HAS_100_81401, 							[2] = 85, [3] = HAS, [4] = NON },
[196] = { [1] = BUFF_EXP_100_81400, 							[2] = 85, [3] = EXP, [4] = NON },
[195] = { [1] = BUFF_STR_2_77273,							   [2] = 1, [3] = STR, [4] = NON },
[194] = { [1] = BUFF_AGI_2_77272, 							   [2] = 1, [3] = AGI, [4] = NON },
[193] = { [1] = BUFF_MASK_AGI_69187,					       [2] = 85, [3] = AGI, [4] = NON },
[192] = { [1] = BUFF_MASK_AGI_69188,					       [2] = 85, [3] = AGI, [4] = NON },
[191] = { [1] = BUFF_MASK_INT_69189,					       [2] = 85, [3] = INT, [4] = NON }, 
[190] = { [1] = BUFF_MASK_INT_69190,					       [2] = 85, [3] = INT, [4] = NON }, 
[189] = { [1] = BUFF_MASK_STA_69192,					       [2] = 85, [3] = STA, [4] = NON }, 
[188] = { [1] = BUFF_MASK_STA_69193,					       [2] = 85, [3] = STA, [4] = NON }, 
[187] = { [1] = BUFF_MASK_STR_69194,					       [2] = 85, [3] = STR, [4] = NON }, 
[186] = { [1] = BUFF_MASK_STR_69195,					       [2] = 85, [3] = STR, [4] = NON }, 
[185] = { [1] = BUFF_STA_90_INT_90_70924,				       [2] = 85, [3] = STA, [4] = INT },
[184] = { [1] = BUFF_STA_90_AGI_90_70925,				       [2] = 85, [3] = STA, [4] = AGI },
[183] = { [1] = BUFF_STA_90_SPI_90_70926,				       [2] = 85, [3] = STA, [4] = SPI },
[182] = { [1] = BUFF_STA_90_STR_90_70927,				       [2] = 85, [3] = STA, [4] = STR },
[181] = { [1] = BUFF_STA_90_OTH_90_62649,				       [2] = 85, [3] = STA, [4] = OTH },
[180] = { [1] = BUFF_STA_90_MAS_90_62663,                      [2] = 1, [3] = STA, [4] = MAS },
[179] = { [1] = BUFF_STA_60_MAS_60_62653,                      [2] = 1, [3] = STA, [4] = MAS },
[178] = { [1] = BUFF_STA_555_HIT_555_44837,                    [2] = 1, [3] = STA, [4] = HIT },
[177] = { [1] = BUFF_STA_555_ATK_555_44838,                    [2] = 1, [3] = STA, [4] = ATK },
[176] = { [1] = BUFF_STA_555_HAS_555_44839,                    [2] = 1, [3] = STA, [4] = HAS },
[175] = { [1] = BUFF_STA_110_STA_110_62679,                    [2] = 75, [3] = STA, [4] = STA },
[174] = { [1] = BUFF_STA_90_CRT_90_62661,                      [2] = 80, [3] = STA, [4] = CRT },
[173] = { [1] = BUFF_STA_90_HIT_90_62662,                      [2] = 80, [3] = STA, [4] = HIT },
[172] = { [1] = BUFF_STA_90_STA_90_62663,                      [2] = 80, [3] = STA, [4] = STA },
[171] = { [1] = BUFF_STA_90_EXP_90_62664,                      [2] = 80, [3] = STA, [4] = EXP },
[170] = { [1] = BUFF_STA_90_HAS_90_62665,                      [2] = 80, [3] = STA, [4] = HAS },
[169] = { [1] = BUFF_STA_90_SPI_90_62666,                      [2] = 80, [3] = STA, [4] = SPI },
[168] = { [1] = BUFF_STA_90_DOD_90_62667,                      [2] = 80, [3] = STA, [4] = DOD },
[167] = { [1] = BUFF_STA_90_STA_90_62668,                      [2] = 80, [3] = STA, [4] = STA },
[166] = { [1] = BUFF_STA_90_AGI_90_62669,                      [2] = 80, [3] = STA, [4] = AGI },
[165] = { [1] = BUFF_STA_90_STR_90_62670,                      [2] = 80, [3] = STA, [4] = STR },
[164] = { [1] = BUFF_STA_90_INT_90_62671,                      [2] = 80, [3] = STA, [4] = INT },
[163] = { [1] = BUFF_STR_75_STR_75_62678,                      [2] = 75, [3] = STR, [4] = STR },
[162] = { [1] = BUFF_STA_60_CRT_60_62651,                      [2] = 80, [3] = STA, [4] = CRT },
[161] = { [1] = BUFF_STA_60_HIT_60_62652,                      [2] = 80, [3] = STA, [4] = HIT },
[160] = { [1] = BUFF_STA_60_STA_60_62653,                      [2] = 80, [3] = STA, [4] = STA },
[159] = { [1] = BUFF_STA_60_EXP_60_62654,                      [2] = 80, [3] = STA, [4] = EXP },
[158] = { [1] = BUFF_STA_60_HAS_60_62655,                      [2] = 80, [3] = STA, [4] = HAS },
[157] = { [1] = BUFF_STA_60_SPI_60_62656,                      [2] = 80, [3] = STA, [4] = SPI },
[156] = { [1] = BUFF_STA_60_DOD_60_62657,                      [2] = 80, [3] = STA, [4] = DOD },
[155] = { [1] = BUFF_STA_60_AGI_60_62658,                      [2] = 80, [3] = STA, [4] = AGI },
[154] = { [1] = BUFF_STA_60_STR_60_62659,                      [2] = 80, [3] = STA, [4] = STR },
[153] = { [1] = BUFF_STA_60_INT_60_62660,                      [2] = 80, [3] = STA, [4] = INT },
[152] = { [1] = BUFF_STA_40_ATK_80_34754,                      [2] = 70, [3] = STA, [4] = ATK },
[151] = { [1] = BUFF_STA_40_ATK_80_34766,                      [2] = 70, [3] = STA, [4] = ATK },
[150] = { [1] = BUFF_STA_40_ATK_60_34762,                      [2] = 70, [3] = STA, [4] = ATK },
[149] = { [1] = BUFF_STA_40_SPL_46_34755,                      [2] = 70, [3] = STA, [4] = SPL },
[148] = { [1] = BUFF_STA_40_SPL_46_34767,                      [2] = 70, [3] = STA, [4] = SPL },
[147] = { [1] = BUFF_STA_40_CRT_40_34756,                      [2] = 70, [3] = STA, [4] = CRT },
[146] = { [1] = BUFF_STA_40_HAS_40_34757,                      [2] = 70, [3] = STA, [4] = HAS },
[145] = { [1] = BUFF_STA_40_SPI_40_34758,                      [2] = 70, [3] = STA, [4] = SPI },
[144] = { [1] = BUFF_STA_40_CRT_40_34768,                      [2] = 70, [3] = STA, [4] = CRT },
[143] = { [1] = BUFF_STA_40_HAS_40_34769,                      [2] = 70, [3] = STA, [4] = HAS },
[142] = { [1] = BUFF_STA_40_SPI_40_42993,                      [2] = 70, [3] = STA, [4] = SPI },
[141] = { [1] = BUFF_STA_40_EXP_40_42994,                      [2] = 70, [3] = STA, [4] = EXP },
[140] = { [1] = BUFF_STA_40_CRT_40_42995,                      [2] = 70, [3] = STA, [4] = CRT },
[139] = { [1] = BUFF_STA_40_HIT_40_42996,                      [2] = 70, [3] = STA, [4] = HIT },
[138] = { [1] = BUFF_STA_40_SPI_40_42998,                      [2] = 70, [3] = STA, [4] = SPI },
[137] = { [1] = BUFF_STA_40_AGI_40_42999,                      [2] = 70, [3] = STA, [4] = AGI },
[136] = { [1] = BUFF_STA_40_STR_40_43000,                      [2] = 70, [3] = STA, [4] = STR },
[135] = { [1] = BUFF_STA_40_HIT_40_44953,                      [2] = 70, [3] = STA, [4] = HIT },
[134] = { [1] = BUFF_STA_40_SPL_35_34763,                      [2] = 70, [3] = STA, [4] = SPL },
[133] = { [1] = BUFF_STA_40_CRT_30_34764,                      [2] = 70, [3] = STA, [4] = CRT },
[132] = { [1] = BUFF_STA_40_SPI_30_34765,                      [2] = 70, [3] = STA, [4] = SPI },
[131] = { [1] = BUFF_STA_40_HAS_30_42942,                      [2] = 70, [3] = STA, [4] = HAS },
[130] = { [1] = BUFF_STA_30_ATK_60_34748,                      [2] = 70, [3] = STA, [4] = ATK },
[129] = { [1] = BUFF_STA_30_SPL_35_34749,                      [2] = 70, [3] = STA, [4] = SPL },
[128] = { [1] = BUFF_STA_30_SPL_35_43268,                      [2] = 70, [3] = STA, [4] = SPL },
[127] = { [1] = BUFF_STA_30_HAS_30_34125,                      [2] = 70, [3] = STA, [4] = HAS },
[126] = { [1] = BUFF_STA_30_CRT_30_34750,                      [2] = 70, [3] = STA, [4] = CRT },
[125] = { [1] = BUFF_STA_30_HAS_30_34751,                      [2] = 70, [3] = STA, [4] = HAS },
[124] = { [1] = BUFF_STA_30_SPI_30_34752,                      [2] = 70, [3] = STA, [4] = SPI },
[123] = { [1] = BUFF_STA_30_CRT_30_39691,                      [2] = 70, [3] = STA, [4] = CRT },
[122] = { [1] = BUFF_DOD_30_DOD_30_43652,                      [2] = 70, [3] = DOD, [4] = DOD },
[121] = { [1] = BUFF_STA_30_SPI_20_27667,                      [2] = 55, [3] = STA, [4] = SPI },
[120] = { [1] = BUFF_STA_30_SPI_20_33052,                      [2] = 65, [3] = STA, [4] = SPI },
[119] = { [1] = BUFF_STA_25_STA_25_21023,                      [2] = 55, [3] = STA, [4] = STA },
[118] = { [1] = BUFF_STA_25_SPI_25_42779,                      [2] = 75, [3] = STA, [4] = SPI },
[117] = { [1] = BUFF_ATK_24_ATK_24_35563,                      [2] = 45, [3] = ATK, [4] = ATK },
[116] = { [1] = BUFF_ATK_24_SPL_14_33004,                      [2] = 35, [3] = ATK, [4] = SPL },
[115] = { [1] = BUFF_SPI_20_SPL_44_27666,                      [2] = 55, [3] = SPI, [4] = SPL },
[114] = { [1] = BUFF_SPI_20_SPL_44_30357,                      [2] = 65, [3] = SPI, [4] = SPL },
[113] = { [1] = BUFF_SPI_20_ATK_40_27655,                      [2] = 55, [3] = SPI, [4] = ATK },
[112] = { [1] = BUFF_SPI_20_SPL_23_27657,                      [2] = 55, [3] = SPI, [4] = SPL },
[111] = { [1] = BUFF_SPI_20_SPL_23_27665,                      [2] = 55, [3] = SPI, [4] = SPL },
[110] = { [1] = BUFF_SPI_20_SPL_23_30361,                      [2] = 65, [3] = SPI, [4] = SPL },
[109] = { [1] = BUFF_SPI_20_SPL_23_31673,                      [2] = 55, [3] = SPI, [4] = SPL },
[108] = { [1] = BUFF_STR_20_STR_20_20452,                      [2] = 45, [3] = STR, [4] = STR },
[107] = { [1] = BUFF_STA_20_SPI_20_20516,                      [2] = 1, [3] = STA, [4] = SPI },
[106] = { [1] = BUFF_STA_20_SPI_20_21254,                      [2] = 1, [3] = STA, [4] = SPI },
[105] = { [1] = BUFF_STA_20_SPI_20_27651,                      [2] = 55, [3] = STA, [4] = SPI },
[104] = { [1] = BUFF_SPI_20_STR_20_27658,                      [2] = 55, [3] = SPI, [4] = STR },
[103] = { [1] = BUFF_SPI_20_AGI_20_27659,                      [2] = 55, [3] = SPI, [4] = AGI },
[102] = { [1] = BUFF_STA_20_SPI_20_27660,                      [2] = 55, [3] = STA, [4] = SPI },
[101] = { [1] = BUFF_STA_20_SPI_20_27662,                      [2] = 55, [3] = STA, [4] = SPI },
[100] = { [1] = BUFF_SPI_20_AGI_20_27664,                      [2] = 55, [3] = SPI, [4] = AGI },
[99] = { [1] = BUFF_STR_20_STR_20_29292,                      [2] = 55, [3] = STR, [4] = STR },
[98] = { [1] = BUFF_STA_20_SPI_20_30155,                      [2] = 55, [3] = STA, [4] = SPI },
[97] = { [1] = BUFF_SPI_20_AGI_20_30358,                      [2] = 65, [3] = SPI, [4] = AGI },
[96] = { [1] = BUFF_SPI_20_STR_20_30359,                      [2] = 65, [3] = SPI, [4] = STR },
[95] = { [1] = BUFF_STA_20_SPI_20_31672,                      [2] = 55, [3] = STA, [4] = SPI },
[94] = { [1] = BUFF_SPI_20_CRT_20_33825,                      [2] = 65, [3] = SPI, [4] = CRT },
[93] = { [1] = BUFF_STA_20_SPI_20_33867,                      [2] = 55, [3] = STA, [4] = SPI },
[92] = { [1] = BUFF_SPI_20_HIT_20_33872,                      [2] = 65, [3] = SPI, [4] = HIT },
[91] = { [1] = BUFF_STA_20_SPI_20_34410,                      [2] = 65, [3] = STA, [4] = SPI },
[90] = { [1] = BUFF_SPI_20_SPI_20_34411,                      [2] = 65, [3] = SPI, [4] = SPI },
[89] = { [1] = BUFF_STA_20_SPI_15_32721,                      [2] = 55, [3] = STA, [4] = SPI },
[88] = { [1] = BUFF_STA_20_MP5_10_27663,                      [2] = 55, [3] = STA, [4] = MP5 },
[87] = { [1] = BUFF_STA_14_SPI_14_24540,                      [2] = 1, [3] = STA, [4] = SPI },
[86] = { [1] = BUFF_SPL_14_SPL_14_35565,                      [2] = 45, [3] = SPL, [4] = SPL },
[85] = { [1] = BUFF_STA_12_SPI_12_12215,                      [2] = 35, [3] = STA, [4] = SPI },
[84] = { [1] = BUFF_STA_12_SPI_12_12216,                      [2] = 40, [3] = STA, [4] = SPI },
[83] = { [1] = BUFF_STA_12_SPI_12_12218,                      [2] = 40, [3] = STA, [4] = SPI },
[82] = { [1] = BUFF_STA_12_SPI_12_16971,                      [2] = 40, [3] = STA, [4] = SPI },
[81] = { [1] = BUFF_STA_12_SPI_12_17222,                      [2] = 35, [3] = STA, [4] = SPI },
[80] = { [1] = BUFF_STA_12_SPI_12_18045,                      [2] = 40, [3] = STA, [4] = SPI },
[79] = { [1] = BUFF_STA_10_STA_10_11950,                      [2] = 45, [3] = STA, [4] = STA },
[78] = { [1] = BUFF_STR_10_STR_10_13810,                      [2] = 45, [3] = STR, [4] = STR },
[77] = { [1] = BUFF_STA_10_STA_10_13927,                      [2] = 35, [3] = STA, [4] = STA },
[76] = { [1] = BUFF_AGI_10_AGI_10_13928,                      [2] = 35, [3] = AGI, [4] = AGI },
[75] = { [1] = BUFF_SPI_10_SPI_10_13929,                      [2] = 35, [3] = SPI, [4] = SPI },
[74] = { [1] = BUFF_MP5_10_MP5_10_13931,                      [2] = 35, [3] = MP5, [4] = MP5 },
[73] = { [1] = BUFF_STA_10_STA_10_13934,                      [2] = 45, [3] = STA, [4] = STA },
[72] = { [1] = BUFF_INT_10_INT_10_18254,                      [2] = 45, [3] = INT, [4] = INT },
[71] = { [1] = BUFF_STA_10_STA_10_24008,                      [2] = 55, [3] = STA, [4] = STA },
[70] = { [1] = BUFF_STA_10_STA_10_24009,                      [2] = 55, [3] = STA, [4] = STA },
[69] = { [1] = BUFF_SPI_10_SPI_10_24539,                      [2] = 55, [3] = SPI, [4] = SPI },
[68] = { [1] = BUFF_STA_10_STA_10_28501,                      [2] = 55, [3] = STA, [4] = STA },
[67] = { [1] = BUFF_STA_8_SPI_8_3728,                      [2] = 20, [3] = STA, [4] = SPI },
[66] = { [1] = BUFF_STA_8_SPI_8_3729,                      [2] = 25, [3] = STA, [4] = SPI },
[65] = { [1] = BUFF_STA_8_SPI_8_4457,                      [2] = 25, [3] = STA, [4] = SPI },
[64] = { [1] = BUFF_STA_8_SPI_8_6038,                      [2] = 25, [3] = STA, [4] = SPI },
[63] = { [1] = BUFF_STA_8_SPI_8_12210,                      [2] = 25, [3] = STA, [4] = SPI },
[62] = { [1] = BUFF_STA_8_SPI_8_12212,                      [2] = 25, [3] = STA, [4] = SPI },
[61] = { [1] = BUFF_STA_8_SPI_8_12213,                      [2] = 25, [3] = STA, [4] = SPI },
[60] = { [1] = BUFF_STA_8_SPI_8_12214,                      [2] = 25, [3] = STA, [4] = SPI },
[59] = { [1] = BUFF_STA_8_SPI_8_13851,                      [2] = 25, [3] = STA, [4] = SPI },
[58] = { [1] = BUFF_STA_8_SPI_8_20074,                      [2] = 20, [3] = STA, [4] = SPI },
[57] = { [1] = BUFF_STA_8_SPI_8_64641,                      [2] = 20, [3] = STA, [4] = SPI },
[56] = { [1] = BUFF_STA_6_SPI_6_1017,                      [2] = 15, [3] = STA, [4] = SPI },
[55] = { [1] = BUFF_STA_6_SPI_6_1082,                      [2] = 10, [3] = STA, [4] = SPI },
[54] = { [1] = BUFF_STA_6_SPI_6_3663,                      [2] = 15, [3] = STA, [4] = SPI },
[53] = { [1] = BUFF_STA_6_SPI_6_3664,                      [2] = 15, [3] = STA, [4] = SPI },
[52] = { [1] = BUFF_STA_6_SPI_6_3665,                      [2] = 15, [3] = STA, [4] = SPI },
[51] = { [1] = BUFF_STA_6_SPI_6_3666,                      [2] = 15, [3] = STA, [4] = SPI },
[50] = { [1] = BUFF_STA_6_SPI_6_3726,                      [2] = 15, [3] = STA, [4] = SPI },
[49] = { [1] = BUFF_STA_6_SPI_6_3727,                      [2] = 15, [3] = STA, [4] = SPI },
[48] = { [1] = BUFF_STA_6_SPI_6_5479,                      [2] = 12, [3] = STA, [4] = SPI },
[47] = { [1] = BUFF_STA_6_SPI_6_5480,                      [2] = 15, [3] = STA, [4] = SPI },
[46] = { [1] = BUFF_STA_6_SPI_6_5527,                      [2] = 15, [3] = STA, [4] = SPI },
[45] = { [1] = BUFF_STA_6_SPI_6_12209,                      [2] = 15, [3] = STA, [4] = SPI },
[44] = { [1] = BUFF_HP5_6_HP5_6_13932,                      [2] = 35, [3] = HP5, [4] = HP5 },
[43] = { [1] = BUFF_MP5_6_MP5_6_21217,                      [2] = 30, [3] = MP5, [4] = MP5 },
[42] = { [1] = BUFF_STA_6_SPI_6_46392,                      [2] = 15, [3] = STA, [4] = SPI },
[41] = { [1] = BUFF_INT_5_INT_5_5342,                      [2] = 1, [3] = INT, [4] = INT },
[40] = { [1] = BUFF_STA_4_SPI_4_724,                      [2] = 5, [3] = STA, [4] = SPI },
[39] = { [1] = BUFF_STA_4_SPI_4_2683,                      [2] = 5, [3] = STA, [4] = SPI },
[38] = { [1] = BUFF_STA_4_SPI_4_2684,                      [2] = 5, [3] = STA, [4] = SPI },
[37] = { [1] = BUFF_STA_4_SPI_4_2687,                      [2] = 5, [3] = STA, [4] = SPI },
[36] = { [1] = BUFF_STA_4_SPI_4_3220,                      [2] = 5, [3] = STA, [4] = SPI },
[35] = { [1] = BUFF_STA_4_SPI_4_3662,                      [2] = 5, [3] = STA, [4] = SPI },
[34] = { [1] = BUFF_STA_4_SPI_4_5476,                      [2] = 5, [3] = STA, [4] = SPI },
[33] = { [1] = BUFF_STA_4_SPI_4_5477,                      [2] = 5, [3] = STA, [4] = SPI },
[32] = { [1] = BUFF_STA_4_SPI_4_5525,                      [2] = 5, [3] = STA, [4] = SPI },
[31] = { [1] = BUFF_STA_4_SPI_4_22645,                      [2] = 5, [3] = STA, [4] = SPI },
[30] = { [1] = BUFF_STA_4_SPI_4_27636,                      [2] = 5, [3] = STA, [4] = SPI },
[29] = { [1] = BUFF_MP5_3_MP5_3_21072,                      [2] = 10, [3] = MP5, [4] = MP5 },
[28] = { [1] = BUFF_STA_2_SPI_2_2680,                      [2] = 1, [3] = STA, [4] = SPI },
[27] = { [1] = BUFF_STA_2_SPI_2_2888,                      [2] = 1, [3] = STA, [4] = SPI },
[26] = { [1] = BUFF_STA_2_SPI_2_5472,                      [2] = 1, [3] = STA, [4] = SPI },
[25] = { [1] = BUFF_STA_2_SPI_2_5474,                      [2] = 1, [3] = STA, [4] = SPI },
[24] = { [1] = BUFF_STA_2_SPI_2_6888,                      [2] = 1, [3] = STA, [4] = SPI },
[23] = { [1] = BUFF_SPI_2_SPI_2_7806,                      [2] = 1, [3] = SPI, [4] = SPI },
[22] = { [1] = BUFF_SPI_2_SPI_2_7807,                      [2] = 1, [3] = SPI, [4] = SPI },
[21] = { [1] = BUFF_SPI_2_SPI_2_7808,                      [2] = 1, [3] = SPI, [4] = SPI },
[20] = { [1] = BUFF_STA_2_SPI_2_11584,                      [2] = 1, [3] = STA, [4] = SPI },
[19] = { [1] = BUFF_STA_2_SPI_2_12224,                      [2] = 1, [3] = STA, [4] = SPI },
[18] = { [1] = BUFF_STA_2_SPI_2_17197,                      [2] = 1, [3] = STA, [4] = SPI },
[17] = { [1] = BUFF_STA_2_SPI_2_17198,                      [2] = 1, [3] = STA, [4] = SPI },
[16] = { [1] = BUFF_STA_2_SPI_2_23756,                      [2] = 1, [3] = STA, [4] = SPI },
[15] = { [1] = BUFF_STA_2_SPI_2_24105,                      [2] = 1, [3] = STA, [4] = SPI },
[14] = { [1] = BUFF_STA_2_SPI_2_27635,                      [2] = 1, [3] = STA, [4] = SPI },
[13] = { [1] = BUFF_STA_2_SPI_2_57519,                      [2] = 1, [3] = STA, [4] = SPI },
[12] = { [1] = BUFF_OTH_1_OTH_1_6657,                      [2] = 1, [3] = OTH, [4] = OTH },
[11] = { [1] = BUFF_OTH_1_OTH_1_12217,                      [2] = 1, [3] = OTH, [4] = OTH },
[10] = { [1] = BUFF_OTH_1_OTH_1_33866,                      [2] = 55, [3] = OTH, [4] = OTH },
[9] = { [1] = BUFF_OTH_1_OTH_1_33924,                      [2] = 1, [3] = OTH, [4] = OTH },
[8] = { [1] = BUFF_OTH_1_OTH_1_37452,                      [2] = 65, [3] = OTH, [4] = OTH },
[7] = { [1] = BUFF_OTH_1_OTH_1_42997,                      [2] = 70, [3] = OTH, [4] = OTH },
[6] = { [1] = BUFF_OTH_1_OTH_1_43001,                      [2] = 70, [3] = OTH, [4] = OTH },
[5] = { [1] = BUFF_OTH_1_OTH_1_43488,                      [2] = 1, [3] = OTH, [4] = OTH },
[4] = { [1] = BUFF_OTH_1_OTH_1_43490,                      [2] = 1, [3] = OTH, [4] = OTH },
[3] = { [1] = BUFF_OTH_1_OTH_1_43491,                      [2] = 1, [3] = OTH, [4] = OTH },
[2] = { [1] = BUFF_OTH_1_OTH_1_43492,                      [2] = 1, [3] = OTH, [4] = OTH },
[1] = { [1] = BUFF_OTH_1_OTH_1_43572,                      [2] = 70, [3] = OTH, [4] = OTH },

  }
end

function GMBuff_Go()
  
  local BuffBFoodRank = 0;
  local BBuffBFoodRank = 0;
  local BuffBFoodItemNum = 0;
  local BBuffBFoodItemNum = 0;
  local oldBFoodItemLink = "Nothing";
  local BoldBFoodItemLink = "Nothing";
  local exact = "no";
  local SECexact = "no";
  local TERexact = "no";
  local primary = "no";
  local secondary = "no";
  local tertiary = "no";

  for bagID = 0, 4, 1 do
    local bagSlotCnt = GetContainerNumSlots(bagID);
    if (bagSlotCnt > 0) then
      for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMBuff_NumFromLink(itemLink);
        if (itemNumber) then
          for index = 1, table.getn(GMBuff_BuffFood), 1 do
            if (GMBuff_BuffFood[index][1] == itemNumber) then
              if (GMBuff_BuffFood[index][2] <= UnitLevel("player")) then
                if (((GMBuff_BuffFood[index][3] == PRIMARYbuff) and (GMBuff_BuffFood[index][4] == SECONDARYbuff)) or ((GMBuff_BuffFood[index][3] == SECONDARYbuff) and (GMBuff_BuffFood[index][4] == PRIMARYbuff))) then
                  if ((index > BuffBFoodRank) or (exact == "no")) then
                    BoldBFoodItemLink = oldBFoodItemLink;
                    oldBFoodItemLink = itemLink;
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    exact = "yes";
                  elseif (((index > BBuffBFoodRank) and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                      BoldBFoodItemLink = itemLink;
                      BBuffBFoodRank = index;
                      BBuffBFoodItemNum = itemNumber;
                    end
                  end
                elseif (((GMBuff_BuffFood[index][3] == PRIMARYbuff) and (GMBuff_BuffFood[index][4] == TERTIARYbuff)) or ((GMBuff_BuffFood[index][3] == TERTIARYbuff) and (GMBuff_BuffFood[index][4] == PRIMARYbuff))) then
                  if (((exact == "no") and (index > BuffBFoodRank)) or ((exact == "no") and (SECexact == "no"))) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    SECexact = "yes";
                  elseif (((exact == "no") and (index > BBuffBFoodRank)  and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                      BBuffBFoodRank = index;
                      BBuffBFoodItemNum = itemNumber;
                    end
                  end
                elseif (((GMBuff_BuffFood[index][3] == SECONDARYbuff) and (GMBuff_BuffFood[index][4] == TERTIARYbuff)) or ((GMBuff_BuffFood[index][3] == TERTIARYbuff) and (GMBuff_BuffFood[index][4] == SECONDARYbuff))) then
                  if (((exact == "no") and (SECexact == "no") and (index > BuffBFoodRank)) or ((exact == "no") and (SECexact == "no") and (TERexact == "no"))) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    TERexact = "yes";
                  elseif (((exact == "no") and (SECexact == "no") and (index > BBuffBFoodRank) and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                      BBuffBFoodRank = index;
                      BBuffBFoodItemNum = itemNumber;
                    end
                  end
                elseif (((GMBuff_BuffFood[index][3] == PRIMARYbuff) or (GMBuff_BuffFood[index][4] == PRIMARYbuff))) then
                  if (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (index > BuffBFoodRank)) or ((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no"))) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    primary = "yes";
                  elseif (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (index > BBuffBFoodRank) and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                    BBuffBFoodRank = index;
                    BBuffBFoodItemNum = itemNumber;
                    end
                  end
                elseif (((GMBuff_BuffFood[index][3] == SECONDARYbuff) or (GMBuff_BuffFood[index][4] == SECONDARYbuff))) then
                  if (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (index > BuffBFoodRank)) or ((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (secondary == "no"))) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    secondary = "yes";
                  elseif (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (index > BBuffBFoodRank) and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                      BBuffBFoodRank = index;
                      BBuffBFoodItemNum = itemNumber;
                    end
                  end
                elseif (((GMBuff_BuffFood[index][3] == TERTIARYbuff) or (GMBuff_BuffFood[index][4] == TERTIARYbuff))) then
                  if (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (secondary == "no") and (index > BuffBFoodRank)) or ((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (secondary == "no") and (tertiary == "no"))) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                    tertiary = "yes";
                  elseif (((exact == "no") and (SECexact == "no") and (TERexact == "no") and (primary == "no") and (secondary == "no") and (index > BBuffBFoodRank) and (index < BuffBFoodRank)) or (BBuffBFoodItemNum == 0)) then
                    if (index ~= BuffBFoodRank) then
                      BBuffBFoodRank = index;
                      BBuffBFoodItemNum = itemNumber;
                    end
                  end
                end
              end
            end
          end
        end
      end
      if (BuffBFoodItemNum == 0) then
        for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMBuff_NumFromLink(itemLink);
          if (itemNumber) then
            for index = 1, table.getn(GMBuff_BuffFood), 1 do
              if (GMBuff_BuffFood[index][1] == itemNumber) then
                if (GMBuff_BuffFood[index][2] <= UnitLevel("player")) then
                  if (index > BuffBFoodRank) then
                    BBuffBFoodRank = BuffBFoodRank;
                    BuffBFoodRank = index;
                    BBuffBFoodItemNum = BuffBFoodItemNum;
                    BuffBFoodItemNum = itemNumber;
                  elseif ((index > BBuffBFoodRank) and (index < BuffBFoodRank)) then
                    BBuffBFoodRank = index;
                    BBuffBFoodItemNum = itemNumber;
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  if ((BuffBFoodRank > 0) and (BBuffBFoodRank > 0)) then
    EditMacro(GMBuff_MACRONAME, GMBuff_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CAMPF.." [mod:shift] item:"..BBuffBFoodItemNum.."; [] item:"..BuffBFoodItemNum);
  elseif ((BuffBFoodRank > 0) and (BBuffBFoodRank == 0)) then
    EditMacro(GMBuff_MACRONAME, GMBuff_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CAMPF.." [] item:"..BuffBFoodItemNum);
  elseif (BuffBFoodRank == 0) then
    EditMacro(GMBuff_MACRONAME, GMBuff_MACRONAME, NoCAMPF, "#showtooltip\n/use "..CAMPF2);
  end
end

function GMBuff_NumFromLink(itemLink)
  if (not itemLink) then
    return nil;
  end
  local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
  return itemNumber;
end
