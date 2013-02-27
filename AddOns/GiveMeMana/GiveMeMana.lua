--[[
        Give Me Mana:
                Copyright 2009 by MERK, Mileg
				Updated by Grimgrin
                based on code by Mileg and Stephen Blaising
                
]]

GMMana_ADDONNAME = "Give Me Mana";
GMMana_MACRONAME = "GMMana";

GMMana_VERSION = "4.5.1";

ALCHEM = "";
ALCHEM2 = "";
NoALCHEM = "INV_Misc_QuestionMark";
WIcon = "Inv_holiday_brewfestbuff_01";
--331
CONJWATER = "";
CharMP = 0;
DP = 0;
TP = 0;
QP = 0;
SP = 0;
GMMana_ZoneName = "Default";
GMMana_ZoneType = "Default";

local GMMana_UpdateFrame;
local GMManaUpdate       = {};
GMMana_UpdateFrame = CreateFrame("Frame")

function GMMana_OnLoad()

  SlashCmdList["GIVEMEMANACOMMAND"] = GMMana_SlashHandler;
  SLASH_GIVEMEMANACOMMAND1 = "/givememana";
  SLASH_GIVEMEMANACOMMAND2 = "/gmmana";
  SLASH_GIVEMEMANACOMMAND3 = "/gmm";
  
end

function GMMana_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMMana_MACRONAME) == 0) then
      local numGenMacros, numCharMacros = GetNumMacros();
      if (numGenMacros < 36) then
        CreateMacro(GMMana_MACRONAME, WIcon, "", nil, nil)
      else
        GMMana_Print("You have 36 General Macros. Cannot add "..GMMana_MACRONAME.."!");
      end
    end
    if (GetSpellInfo(ALCH)) then
      ALCHEM = "[mod:ctrl,nocombat] "..ALCH..";";
      ALCHEM2 = "[] "..ALCH..";";
    else
      ALCHEM = "";
      NoALCHEM = WIcon;
    end
    if (GetSpellInfo(CONJR)) then
      CONJWATER = "[button:2] "..CONJR..";";
    elseif (GetSpellInfo(CONJW)) then
      CONJWATER = "[button:2] "..CONJW..";";
    else
      CONJWATER = "";
    end
    GMMana_UpdateFrame:SetScript("OnUpdate", GMMana_UpdateFrame_OnUpdate)
end
  if event == "BAG_UPDATE" then
		GMMana_UpdateFrame:SetScript("OnUpdate", GMMana_UpdateFrame_OnUpdate)
  end
end

function GMMana_UpdateFrame_OnUpdate(self, elapsed)
local affectingCombat = UnitAffectingCombat("player");
	for i = 0, 11 do
		if GMManaUpdate[i] then
			GMManaUpdate[i] = nil
		end
	end
	if GMManaUpdate.inv then
		GMManaUpdate.inv = nil
	end
		if(affectingCombat ~= 1) then
		  self:SetScript("OnUpdate", nil)
		  CharMP = UnitManaMax("player");
		  DP = CharMP * .02;
		  TP = CharMP * .03;
		  QP = CharMP * .04;
		  SP = CharMP * .05;
		  GMMana_MakeArray();
		  GMMana_Go();
		end
end

function GMMana_OnUpdate(event)
  if (GMMana_ZoneName ~= GetRealZoneText()) then
    GMMana_Go();
  end
end

function GMMana_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help" or msg == "") then
    GMMana_Print(GMMana_ADDONNAME.." |cff3399CCv"..GMMana_VERSION.." ");
    GMMana_Print("Type /macro to open macro list.");
    GMMana_Print("Drag GMMana macro to your action bar.");
    GMMana_Print("This macro has two purposes.");
    GMMana_Print("During combat click to use best mana potion.");
    GMMana_Print("Otherwise click to drink best water.");
    GMMana_Print("Hold SHIFT and click to use/drink second best mana potion/water.");
    GMMana_Print("Hold ALT and click to use best mana potion out of combat.");
    GMMana_Print("Hold SHIFT+ALT and click to use second best mana potion out of combat.");
    GMMana_Print("Hold CTRL and click to open \"Alchemy\" tradeskill window.");
    GMMana_Print("Mages can right click to \"Conjure Water\".");
  end
end

function GMMana_GetZoneType()
  if (GMMana_ZoneName ~= GetRealZoneText()) then
    GMMana_ZoneName = GetRealZoneText();
    if ((GMMana_ZoneName == WSG) or (GMMana_ZoneName == AV) or (GMMana_ZoneName == AB) or (GMMana_ZoneName == EOTS) or (GMMana_ZoneName == SOTA)) then
      GMMana_ZoneType = "BG";
	elseif ((GMMana_ZoneName == TB) or (GMMana_ZoneName == TBP)) then
      GMMana_ZoneType = "TB";
    elseif ((GMMana_ZoneName == BOT) or (GMMana_ZoneName == EYE) or (GMMana_ZoneName == MECH) or (GMMana_ZoneName == ARCA)) then
      GMMana_ZoneType = "TK";
    elseif ((GMMana_ZoneName == SSC) or (GMMana_ZoneName == UB) or (GMMana_ZoneName == SV) or (GMMana_ZoneName == SP)) then
      GMMana_ZoneType = "CFR";
    elseif ((GMMana_ZoneName == BEM) or (GMMana_ZoneName == GL)) then
      GMMana_ZoneType = "BE";
    elseif ((GMMana_ZoneName == ARENA_BE) or (GMMana_ZoneName == ARENA_D) or (GMMana_ZoneName == ARENA_N) or (GMMana_ZoneName == ARENA_ROL) or (GMMana_ZoneName == ARENA_ROV)) then
      GMMana_ZoneType = "ARENA";
    else
      GMMana_ZoneType = "ALL";
    end
  end
end

function GMMana_Print(msg)
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMMana_MakeArray()
  GMMana_Potions = {


	[45] = { [1] = PF_45000,  		[2] = 85, [3] =45000, [4] = "ALL",   [5] = "ALL" },
	[45] = { [1] = MANA_30000,  	[2] = 85, [3] =30000, [4] = "ALL",   [5] = "ALL" },	
	[45] = { [1] = RJ_30000,  		[2] = 85, [3] =30000, [4] = "ALL",   [5] = "ALL" },
	[45] = { [1] = PC_22000,  		[2] = 80, [3] =22000, [4] = "ALL",   [5] = "ALL" },
	[44] = { [1] = MANA_10750_P,    [2] = 78, [3] =10750, [4] = "TB",    [5] = "ALL" },	
	[43] = { [1] = MANA_TB_H_9000,  [2] =  0, [3] =  600, [4] = "TB", 	 [5] = "ALL" },
	[42] = { [1] = MANA_TB_A_9000,  [2] =  0, [3] =  600, [4] = "TB",    [5] = "ALL" },
	[41] = { [1] = MP_7500,			[2] = 80, [3] = 7500, [4] = "ALL", 	 [5] = "ALL" },
	[40] = { [1] = RJ_8000,  		[2] = 80, [3] = 8000, [4] = "ALL", 	 [5] = "ALL" },
	[39] = { [1] = MANA_10000,  	[2] = 80, [3] =10000, [4] = "ALL", 	 [5] = "ALL" },
	[38] = { [1] = MANA_ARENA_600,  [2] =  0, [3] =  600, [4] = "ARENA", [5] = "ALL" },
    [37] = { [1] = MANA_TK_3000,    [2] = 55, [3] = 3000, [4] = "TK",    [5] = "ALL" },
    [36] = { [1] = MANA_BEP_3000_2, [2] = 70, [3] = 3000, [4] = "BE",    [5] = "ALL" },
    [35] = { [1] = MANA_BEP_3000,   [2] = 70, [3] = 3000, [4] = "BE",    [5] = "ALL" },
    [34] = { [1] = MANA_CFR_3000,   [2] = 55, [3] = 3000, [4] = "CFR",   [5] = "ALL" },
    [33] = { [1] = MANA_1260_P,     [2] = 45, [3] = 1260, [4] = "BG",    [5] = "ALL" },
    [32] = { [1] = MANA_720_P,      [2] = 35, [3] =  720, [4] = "BG",    [5] = "ALL" },
    [31] = { [1] = MANA_4400_I,     [2] = 70, [3] = 4402, [4] = "ALL",   [5] = "ALL" },
    [30] = { [1] = MANA_4400,       [2] = 65, [3] = 4401, [4] = "ALL",   [5] = "ALL" },
    [29] = { [1] = CA_3500h_4400m,  [2] = 70, [3] = 4400, [4] = "ALL",   [5] = "ALL" },
    [28] = { [1] = RJ_4125,         [2] = 75, [3] = 4125, [4] = "ALL",   [5] = "ALL" },
    [27] = { [1] = MANA_3000_5,     [2] = 55, [3] = 3000, [4] = "ALL",   [5] = "ALL" },
    [26] = { [1] = MANA_3000_4,     [2] = 60, [3] = 3000, [4] = "ALL",   [5] = "ALL" },
    [25] = { [1] = MANA_3000_3,     [2] = 55, [3] = 3000, [4] = "ALL",   [5] = "ALL" },
    [24] = { [1] = MANA_3000_2,     [2] = 55, [3] = 3000, [4] = "ALL",   [5] = "ALL" },
    [23] = { [1] = MANA_3000,       [2] = 55, [3] = 3000, [4] = "ALL",   [5] = "ALL" },
    [22] = { [1] = RJ_2750,         [2] = 65, [3] = 2751, [4] = "ALL",   [5] = "ALL" },
    [21] = { [1] = MA_2750,         [2] = 60, [3] = 2750, [4] = "ALL",   [5] = "ALL" },
    [20] = { [1] = MANA_2750,       [2] = 60, [3] = 2750, [4] = "ALL",   [5] = "ALL" },
    [19] = { [1] = MANA_2500_I2,    [2] = 55, [3] = 2500, [4] = "ALL",   [5] = "ALL" },
    [18] = { [1] = MANA_2500_I,     [2] = 55, [3] = 2500, [4] = "ALL",   [5] = "ALL" },
    [17] = { [1] = MANA_2250_P4,    [2] = 61, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [16] = { [1] = MANA_2250_P3,    [2] = 61, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [15] = { [1] = MANA_2250_P2,    [2] = 61, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [14] = { [1] = MANA_2250_P,     [2] = 61, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [13] = { [1] = MANA_2250_2,     [2] = 55, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [12] = { [1] = MANA_2250,       [2] = 49, [3] = 2250, [4] = "ALL",   [5] = "ALL" },
    [11] = { [1] = RJ_1760,         [2] = 50, [3] = 1760, [4] = "ALL",   [5] = "ALL" },
    [10] = { [1] = RJ_1500,         [2] = 35, [3] = 1500, [4] = "ALL",   [5] = "ALL" },
    [ 9] = { [1] = MANA_1500_P,     [2] = 41, [3] = 1500, [4] = "ALL",   [5] = "ALL" },
    [ 8] = { [1] = MANA_1500,       [2] = 41, [3] = 1500, [4] = "ALL",   [5] = "ALL" },
    [ 7] = { [1] = MANA_900,        [2] = 31, [3] =  900, [4] = "ALL",   [5] = "ALL" },
    [ 6] = { [1] = MANA_ARENA_600,  [2] =  0, [3] =  600, [4] = "ALL",   [5] = "ALL" },
    [ 5] = { [1] = MANA_585,        [2] = 22, [3] =  585, [4] = "ALL",   [5] = "ALL" },
    [ 4] = { [1] = MANA_360,        [2] = 14, [3] =  360, [4] = "ALL",   [5] = "ALL" },
    [ 3] = { [1] = MANA_180_2,      [2] =  5, [3] =  180, [4] = "ALL",   [5] = "ALL" },
    [ 2] = { [1] = MANA_180,        [2] =  0, [3] =  180, [4] = "ALL",   [5] = "ALL" },
    [ 1] = { [1] = RJ_150,          [2] =  5, [3] =  150, [4] = "ALL",   [5] = "ALL" },
  }

  GMMana_Water = {

[142] = {  [1] = VEND_WAT_ARENA_12960,   [2] = 75, [3] = 432, [4] = "ARENA", [5] = "ALL" },
[141] = {  [1] = VEND_WAT_ARENA_7200,    [2] = 65, [3] = 240, [4] = "ARENA", [5] = "ALL" },
[140] = {  [1] = VEND_WAT_ARENA_4200,    [2] = 55, [3] = 140, [4] = "ARENA", [5] = "ALL" },
[139] = {  [1] = VEND_BIS_2148_4410_WSG, [2] = 45, [3] = 147, [4] = WSG,     [5] = "ALL" },
[138] = {  [1] = VEND_BIS_1608_3306_WSG, [2] = 35, [3] = 110, [4] = WSG,     [5] = "ALL" },
[137] = {  [1] = VEND_BIS_1074_2202_WSG, [2] = 25, [3] =  73, [4] = WSG,     [5] = "ALL" },
[136] = {  [1] = VEND_BIS_2148_4410_AB3, [2] = 45, [3] = 147, [4] = AB,      [5] = "ALL" },
[135] = {  [1] = VEND_BIS_2148_4410_AB2, [2] = 45, [3] = 147, [4] = AB,      [5] = "ALL" },
[134] = {  [1] = VEND_BIS_2148_4410_AB,  [2] = 45, [3] = 147, [4] = AB,      [5] = "ALL" },
[133] = {  [1] = VEND_BIS_1608_3306_AB3, [2] = 35, [3] = 110, [4] = AB,      [5] = "ALL" },
[132] = {  [1] = VEND_BIS_1608_3306_AB2, [2] = 35, [3] = 110, [4] = AB,      [5] = "ALL" },
[131] = {  [1] = VEND_BIS_1608_3306_AB,  [2] = 35, [3] = 110, [4] = AB,      [5] = "ALL" },
[130] = {  [1] = VEND_BIS_1074_2202_AB3, [2] = 25, [3] =  73, [4] = AB,      [5] = "ALL" },
[129] = {  [1] = VEND_BIS_1074_2202_AB2, [2] = 25, [3] =  73, [4] = AB,      [5] = "ALL" },
[128] = {  [1] = VEND_BIS_1074_2202_AB,  [2] = 25, [3] =  73, [4] = AB,      [5] = "ALL" },
[127] = {  [1] = B_80618_CONJ, 			 [2] = 90, [3] = 150000, [4] = "ALL", [5] = "ALL" },
[126] = {  [1] = B_80610_CONJ, 		 	 [2] = 90, [3] = 150000, [4] = "ALL", [5] = "ALL" },
[125] = {  [1] = conj_BIS_115200_22500_65499,  [2] = 85, [3] = 115200, [4] = "ALL", [5] = "ALL" },
[124] = {  [1] = conj_BIS_19200_15000_43523,  [2] = 80, [3] = 19200, [4] = "ALL", [5] = "ALL" },
[123] = {  [1] = conj_BIS_12840_13200_43518,  [2] = 74, [3] = 12840, [4] = "ALL", [5] = "ALL" },
[122] = {  [1] = conj_DRINK_7200_22018,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[121] = {  [1] = conj_BIS_7200_7500_34062,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[120] = {  [1] = conj_DRINK_5100_30703,  [2] = 60, [3] = 5100, [4] = "ALL", [5] = "ALL" },
[119] = {  [1] = conj_BIS_4200_4320_65517,  [2] = 64, [3] = 4200, [4] = "ALL", [5] = "ALL" },
[118] = {  [1] = conj_DRINK_4200_8079,  [2] = 55, [3] = 4200, [4] = "ALL", [5] = "ALL" },
[117] = {  [1] = conj_BIS_2934_2148_65516,  [2] = 54, [3] = 2934, [4] = "ALL", [5] = "ALL" },
[116] = {  [1] = conj_DRINK_2934_8078,  [2] = 45, [3] = 2934, [4] = "ALL", [5] = "ALL" },
[115] = {  [1] = conj_BIS_1992_1392_65515,  [2] = 44, [3] = 1992, [4] = "ALL", [5] = "ALL" },
[114] = {  [1] = conj_DRINK_1992_8077,  [2] = 35, [3] = 1992, [4] = "ALL", [5] = "ALL" },
[113] = {  [1] = conj_BIS_1494_972_65500,  [2] = 34, [3] = 1494, [4] = "ALL", [5] = "ALL" },
[112] = {  [1] = conj_DRINK_1344_3772,  [2] = 25, [3] = 1344, [4] = "ALL", [5] = "ALL" },
[111] = {  [1] = conj_DRINK_835_2136,  [2] = 15, [3] = 835, [4] = "ALL", [5] = "ALL" },
[110] = {  [1] = conj_DRINK_436_2288,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[109] = {  [1] = conj_DRINK_151_5350,  [2] = 1, [3] = 151, [4] = "ALL", [5] = "ALL" },
[108] = { [1] = B_74650_DROP, [2] = 90, [3] = 300000, [4] = "ALL", [5] = "ALL" },
[107] = { [1] = B_75038_DROP, [2] = 90, [3] = 300000, [4] = "ALL", [5] = "ALL" },
[106] = { [1] = B_87226_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[105] = { [1] = B_87228_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[104] = { [1] = B_87230_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[103] = { [1] = B_87232_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[102] = { [1] = B_87234_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[101] = { [1] = B_87236_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[100] = { [1] = B_87238_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[99] = { [1] = B_87240_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[98] = { [1] = B_87242_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[97] = { [1] = B_87244_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[96] = { [1] = B_87246_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[95] = { [1] = B_87248_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[94] = { [1] = B_87253_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[93] = { [1] = B_74919_COOK, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[92] = { [1] = B_75016_COOK, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[91] = { [1] = B_74649_DROP, [2] = 87, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[90] = { [1] = B_88388_DROP, [2] = 86, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[89] = { [1] = D_81923_DROP, [2] = 90, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[88] = { [1] = D_88586_DROP, [2] = 88, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[87] = { [1] = D_75037_DROP, [2] = 87, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[86] = { [1] = D_88578_DROP, [2] = 87, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[85] = { [1] = D_88532_DROP, [2] = 85, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[84] = { [1] = D_74636_COOK, [2] = 85, [3] = 200000, [4] = "ALL", [5] = "ALL" },
[83] = { [1] = B_74644_DROP, [2] = 85, [3] = 100000, [4] = "ALL", [5] = "ALL" },
[82] = { [1] = B_75026_DROP, [2] = 85, [3] = 100000, [4] = "ALL", [5] = "ALL" },
[81] = { [1] = B_86026_COOK, [2] = 85, [3] = 100000, [4] = "ALL", [5] = "ALL" },
[80] = { [1] = D_81924_DROP, [2] = 85, [3] = 100000, [4] = "ALL", [5] = "ALL" },
[79] = { [1] = D_85501_COOK, [2] = 85, [3] = 100000, [4] = "ALL", [5] = "ALL" },
[78] = { [1] = drop_BIS_96100_100_21215,  [2] = 40, [3] = 96100, [4] = "ALL", [5] = "ALL" },
[77] = { [1] = drop_DRINK_96100_21537,  [2] = 1, [3] = 96100, [4] = "ALL", [5] = "ALL" },
[76] = { [1] = drop_DRINK_96075_20388,  [2] = 1, [3] = 96075, [4] = "ALL", [5] = "ALL" },
[75] = { [1] = drop_DRINK_96075_20389,  [2] = 1, [3] = 96075, [4] = "ALL", [5] = "ALL" },
[74] = { [1] = drop_DRINK_96075_20390,  [2] = 1, [3] = 96075, [4] = "ALL", [5] = "ALL" },
[73] = { [1] = drop_DRINK_96060_19997,  [2] = 1, [3] = 96060, [4] = "ALL", [5] = "ALL" },
[72] = { [1] = drop_DRINK_96000_68140,  [2] = 85, [3] = 96000, [4] = "ALL", [5] = "ALL" },
[71] = { [1] = cook_DRINK_96000_62672,  [2] = 80, [3] = 96000, [4] = "ALL", [5] = "ALL" },
[70] = { [1] = cook_DRINK_96000_62675,  [2] = 80, [3] = 96000, [4] = "ALL", [5] = "ALL" },
[69] = { [1] = vend_DRINK_96000_58257,  [2] = 85, [3] = 96000, [4] = "ALL", [5] = "ALL" },
[68] = { [1] = vend_DRINK_96000_63251,  [2] = 85, [3] = 96000, [4] = "ALL", [5] = "ALL" },
[67] = { [1] = drop_DRINK_45000_59230,  [2] = 80, [3] = 45000, [4] = "ALL", [5] = "ALL" },
[66] = { [1] = cook_BIS_45000_67500_68687,  [2] = 80, [3] = 45000, [4] = "ALL", [5] = "ALL" },
[65] = { [1] = vend_DRINK_45000_58256,  [2] = 80, [3] = 45000, [4] = "ALL", [5] = "ALL" },
[64] = { [1] = vend_DRINK_45000_59029,  [2] = 80, [3] = 45000, [4] = "ALL", [5] = "ALL" },
[63] = { [1] = drop_DRINK_19200_56164,  [2] = 75, [3] = 19200, [4] = "ALL", [5] = "ALL" },
[62] = { [1] = drop_DRINK_19200_59229,  [2] = 75, [3] = 19200, [4] = "ALL", [5] = "ALL" },
[61] = { [1] = vend_DRINK_19200_58274,  [2] = 75, [3] = 19200, [4] = "ALL", [5] = "ALL" },
[60] = { [1] = cook_BIS_15000_18000_45932,  [2] = 75, [3] = 15000, [4] = "ALL", [5] = "ALL" },
[59] = { [1] = cook_DRINK_12960_39520,  [2] = 75, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[58] = { [1] = cook_BIS_12960_15000_34759,  [2] = 70, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[57] = { [1] = cook_BIS_12960_15000_34760,  [2] = 70, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[56] = { [1] = cook_BIS_12960_15000_34761,  [2] = 70, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[55] = { [1] = vend_DRINK_12960_33445,  [2] = 75, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[54] = { [1] = vend_DRINK_12960_41731,  [2] = 75, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[53] = { [1] = vend_DRINK_12960_42777,  [2] = 75, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[52] = { [1] = vend_DRINK_12960_43236,  [2] = 75, [3] = 12960, [4] = "ALL", [5] = "ALL" },
[51] = { [1] = vend_DRINK_12840_44941,  [2] = 70, [3] = 12840, [4] = "ALL", [5] = "ALL" },
[50] = { [1] = vend_DRINK_9180_33444,  [2] = 70, [3] = 9180, [4] = "ALL", [5] = "ALL" },
[49] = { [1] = vend_DRINK_9180_38698,  [2] = 70, [3] = 9180, [4] = "ALL", [5] = "ALL" },
[48] = { [1] = vend_DRINK_9180_43086,  [2] = 70, [3] = 9180, [4] = "ALL", [5] = "ALL" },
[47] = { [1] = drop_DRINK_7200_30457,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[46] = { [1] = drop_DRINK_7200_44750,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[45] = { [1] = cook_BIS_7200_7500_33053,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[44] = { [1] = vend_DRINK_7200_27860,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[43] = { [1] = vend_DRINK_7200_29395,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[42] = { [1] = vend_DRINK_7200_29401,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[41] = { [1] = vend_DRINK_7200_32453,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[40] = { [1] = vend_DRINK_7200_32668,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[39] = { [1] = vend_DRINK_7200_33042,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[38] = { [1] = vend_BIS_7200_7500_34780,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[37] = { [1] = vend_DRINK_7200_35954,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[36] = { [1] = vend_DRINK_7200_37253,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[35] = { [1] = vend_DRINK_7200_38431,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[34] = { [1] = vend_DRINK_7200_40357,  [2] = 65, [3] = 7200, [4] = "ALL", [5] = "ALL" },
[33] = { [1] = vend_DRINK_5100_28399,  [2] = 60, [3] = 5100, [4] = "ALL", [5] = "ALL" },
[32] = { [1] = vend_DRINK_5100_29454,  [2] = 60, [3] = 5100, [4] = "ALL", [5] = "ALL" },
[31] = { [1] = vend_DRINK_5100_38430,  [2] = 60, [3] = 5100, [4] = "ALL", [5] = "ALL" },
[30] = { [1] = drop_BIS_4410_2550_20031,  [2] = 55, [3] = 4410, [4] = "ALL", [5] = "ALL" },
[29] = { [1] = drop_BIS_4410_4410_28112,  [2] = 1, [3] = 4410, [4] = "ALL", [5] = "ALL" },
[28] = { [1] = vend_BIS_4410_4320_32722,  [2] = 65, [3] = 4410, [4] = "ALL", [5] = "ALL" },
[27] = { [1] = vend_BIS_4410_4410_19301,  [2] = 51, [3] = 4410, [4] = "ALL", [5] = "ALL" },
[26] = { [1] = vend_BIS_4410_2148_13724,  [2] = 45, [3] = 4410, [4] = "ALL", [5] = "ALL" },
[25] = { [1] = drop_DRINK_4200_18300,  [2] = 55, [3] = 4200, [4] = "ALL", [5] = "ALL" },
[24] = { [1] = vend_DRINK_4200_32455,  [2] = 55, [3] = 4200, [4] = "ALL", [5] = "ALL" },
[23] = { [1] = vend_DRINK_2934_8766,  [2] = 45, [3] = 2934, [4] = "ALL", [5] = "ALL" },
[22] = { [1] = vend_DRINK_2934_38429,  [2] = 45, [3] = 2934, [4] = "ALL", [5] = "ALL" },
[21] = { [1] = drop_DRINK_1992_63023,  [2] = 35, [3] = 1992, [4] = "ALL", [5] = "ALL" },
[20] = { [1] = vend_DRINK_1992_1645,  [2] = 35, [3] = 1992, [4] = "ALL", [5] = "ALL" },
[19] = { [1] = vend_DRINK_1992_19300,  [2] = 35, [3] = 1992, [4] = "ALL", [5] = "ALL" },
[18] = { [1] = drop_DRINK_1344_4791,  [2] = 25, [3] = 1344, [4] = "ALL", [5] = "ALL" },
[17] = { [1] = drop_DRINK_1344_61382,  [2] = 1, [3] = 1344, [4] = "ALL", [5] = "ALL" },
[16] = { [1] = cook_DRINK_1344_10841,  [2] = 25, [3] = 1344, [4] = "ALL", [5] = "ALL" },
[15] = { [1] = vend_DRINK_1344_1708,  [2] = 25, [3] = 1344, [4] = "ALL", [5] = "ALL" },
[14] = { [1] = drop_DRINK_835_9451,  [2] = 15, [3] = 835, [4] = "ALL", [5] = "ALL" },
[13] = { [1] = vend_DRINK_835_1205,  [2] = 15, [3] = 835, [4] = "ALL", [5] = "ALL" },
[12] = { [1] = vend_DRINK_835_19299,  [2] = 15, [3] = 835, [4] = "ALL", [5] = "ALL" },
[11] = { [1] = drop_DRINK_436_49365,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[10] = { [1] = drop_DRINK_436_63530,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[9] = { [1] = vend_DRINK_436_1179,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[8] = { [1] = vend_DRINK_436_17404,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[7] = { [1] = vend_DRINK_436_49601,  [2] = 5, [3] = 436, [4] = "ALL", [5] = "ALL" },
[6] = { [1] = drop_BIS_294_294_3448,  [2] = 1, [3] = 294, [4] = "ALL", [5] = "ALL" },
[5] = { [1] = cook_BIS_294_294_2682,  [2] = 5, [3] = 294, [4] = "ALL", [5] = "ALL" },
[4] = { [1] = vend_DRINK_151_159,  [2] = 1, [3] = 151, [4] = "ALL", [5] = "ALL" },
[3] = { [1] = vend_DRINK_151_49254,  [2] = 1, [3] = 151, [4] = "ALL", [5] = "ALL" },
[2] = { [1] = vend_DRINK_151_60269,  [2] = 1, [3] = 151, [4] = "ALL", [5] = "ALL" },
[1] = { [1] = drop_DRINK_60_1401,  [2] = 4, [3] = 60, [4] = "ALL", [5] = "ALL" },


  }
end

function GMMana_Go()
  
  local manaPotionRank = 0;
  local BmanaPotionRank = 0;
  local manaPotionItemNum = 0;
  local BmanaPotionItemNum = 0;
  local oldPotionItemLink = "Nothing";
  local BoldPotionItemLink = "Nothing";
  local manaWaterRank = 0;
  local BmanaWaterRank = 0;
  local manaWaterItemNum = 0;
  local BmanaWaterItemNum = 0;
  local oldWaterItemLink = "Nothing";
  local BoldWaterItemLink = "Nothing";
  
  local Poverride = false
  local Woverride = false
  
  GMMana_GetZoneType();
  
  if (GMMana_ZoneName == nil) then
    GMMana_ZoneName = "Default";
  end
  
  for bagID = 0, 4, 1 do
    local bagSlotCnt = GetContainerNumSlots(bagID);
    if (bagSlotCnt > 0) then
      for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMMana_NumFromLink(itemLink);
        if (itemNumber) then
          for index = 1, #(GMMana_Potions), 1 do
            if (GMMana_Potions[index][1] == itemNumber) then
              if (GMMana_Potions[index][2] <= UnitLevel("player")) then
                if ((GMMana_Potions[index][4] == GMMana_ZoneType) or (GMMana_Potions[index][4] == GMMana_ZoneName) or (GMMana_Potions[index][4] == "ALL")) then  
                  if (GMMana_Potions[index][4] ~= "ALL") then
                    Poverride = true
                    BoldPotionItemLink = oldPotionItemLink;
                    oldPotionItemLink = itemLink;
                    BmanaPotionRank = manaPotionRank;
                    manaPotionRank = GMMana_Potions[index][3];
                    BmanaPotionItemNum = manaPotionItemNum;
                    manaPotionItemNum = itemNumber;
                  end
                  if ((GMMana_Potions[index][3] > manaPotionRank) and (not Poverride)) then
                    BoldPotionItemLink = oldPotionItemLink;
                    oldPotionItemLink = itemLink;
                    BmanaPotionRank = manaPotionRank;
                    manaPotionRank = GMMana_Potions[index][3];
                    BmanaPotionItemNum = manaPotionItemNum;
                    manaPotionItemNum = itemNumber;
                  elseif ((GMMana_Potions[index][3] == manaPotionRank) and (itemLink ~= oldPotionItemLink) and (not Poverride)) then
                    local oldItemCnt = GetItemCount(oldPotionItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      oldPotionItemLink = itemLink;
                      manaPotionRank = GMMana_Potions[index][3];
                      manaPotionItemNum = itemNumber;
                    end
                  elseif ((GMMana_Potions[index][3] < manaPotionRank) and (GMMana_Potions[index][3] > BmanaPotionRank)) then
                    BoldPotionItemLink = itemLink;
                    BmanaPotionRank = GMMana_Potions[index][3];
                    BmanaPotionItemNum = itemNumber;
                  elseif ((GMMana_Potions[index][3] == BmanaPotionRank) and (itemLink ~= BoldPotionItemLink)) then
                    local oldItemCnt = GetItemCount(BoldPotionItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      BoldPotionItemLink = itemLink;
                      BmanaPotionRank = GMMana_Potions[index][3];
                      BmanaPotionItemNum = itemNumber;
                    end
                  end
                end
              end  
            end
          end
          for index = 1, #(GMMana_Water), 1 do
            if (GMMana_Water[index][1] == itemNumber) then
              if (GMMana_Water[index][2] <= UnitLevel("player")) then
                if ((GMMana_Water[index][4] == GMMana_ZoneType) or (GMMana_Water[index][4] == GMMana_ZoneName) or (GMMana_Water[index][4] == "ALL")) then  
                  if (GMMana_Water[index][4] ~= "ALL") then
                    Woverride = true
                    BoldWaterItemLink = oldWaterItemLink;
                    oldWaterItemLink = itemLink;
                    BmanaWaterRank = manaWaterRank;
                    manaWaterRank = GMMana_Water[index][3];
                    BmanaWaterItemNum = manaWaterItemNum;
                    manaWaterItemNum = itemNumber;
                  end
                  if ((GMMana_Water[index][3] > manaWaterRank) and (not Woverride)) then
                    BoldWaterItemLink = oldWaterItemLink;
                    oldWaterItemLink = itemLink;
                    BmanaWaterRank = manaWaterRank;
                    manaWaterRank = GMMana_Water[index][3];
                    BmanaWaterItemNum = manaWaterItemNum;
                    manaWaterItemNum = itemNumber;
                  elseif ((GMMana_Water[index][3] == manaWaterRank) and (itemLink ~= oldWaterItemLink) and (not Woverride)) then
                    local oldItemCnt = GetItemCount(oldWaterItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      oldWaterItemLink = itemLink;
                      manaWaterRank = GMMana_Water[index][3];
                      manaWaterItemNum = itemNumber;
                    end
                  elseif ((GMMana_Water[index][3] < manaWaterRank) and (GMMana_Water[index][3] > BmanaWaterRank)) then
                    BoldWaterItemLink = itemLink;
                    BmanaWaterRank = GMMana_Water[index][3];
                    BmanaWaterItemNum = itemNumber;
                  elseif ((GMMana_Water[index][3] == BmanaWaterRank) and (itemLink ~= BoldWaterItemLink)) then
                    local oldItemCnt = GetItemCount(BoldWaterItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      BoldWaterItemLink = itemLink;
                      BmanaWaterRank = GMMana_Water[index][3];
                      BmanaWaterItemNum = itemNumber;
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  if ((manaPotionRank > 0) and (manaWaterRank > 0) and (BmanaPotionRank > 0) and (BmanaWaterRank > 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." [mod:shift, combat] item:"..BmanaPotionItemNum.."; [combat] item:"..manaPotionItemNum.."; [mod:alt,mod:shift] item:"..BmanaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum.."; [mod:shift] item:"..BmanaWaterItemNum.."; [] item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank > 0) and (manaWaterRank > 0) and (BmanaPotionRank > 0) and (BmanaWaterRank == 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." [mod:shift, combat] item:"..BmanaPotionItemNum.."; [combat] item:"..manaPotionItemNum.."; [mod:alt,mod:shift] item:"..BmanaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum.."; [] item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank > 0) and (manaWaterRank > 0) and (BmanaPotionRank == 0) and (BmanaWaterRank > 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." [combat] item:"..manaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum.."; [mod:shift] item:"..BmanaWaterItemNum.."; [] item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank > 0) and (manaWaterRank == 0) and (BmanaPotionRank > 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip "..ALCHEM.." [mod:shift] item:"..BmanaPotionItemNum.."; item:"..manaPotionItemNum.."\n/use "..CONJWATER..""..ALCHEM.." [mod:shift, combat] item:"..BmanaPotionItemNum.."; [combat] item:"..manaPotionItemNum.."; [mod:alt, mod:shift] item:"..BmanaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum, nil, nil);
  elseif ((manaPotionRank == 0) and (manaWaterRank > 0) and (BmanaWaterRank > 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." [mod:shift] item:"..BmanaWaterItemNum.."; [] item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank > 0) and (manaWaterRank > 0) and (BmanaPotionRank == 0) and (BmanaWaterRank == 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." [combat] item:"..manaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum.."; [] item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank > 0) and (manaWaterRank == 0) and (BmanaPotionRank == 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip "..ALCHEM.." item:"..manaPotionItemNum.."\n/use "..CONJWATER..""..ALCHEM.." [combat] item:"..manaPotionItemNum.."; [mod:alt] item:"..manaPotionItemNum, nil, nil);
  elseif ((manaPotionRank == 0) and (manaWaterRank > 0) and (BmanaWaterRank == 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..CONJWATER..""..ALCHEM.." item:"..manaWaterItemNum, nil, nil);
  elseif ((manaPotionRank == 0) and (manaWaterRank == 0)) then
    EditMacro(GMMana_MACRONAME, GMMana_MACRONAME, NoALCHEM, "#showtooltip\n/use "..CONJWATER..""..ALCHEM2, nil, nil);
  end
end

function GMMana_NumFromLink(itemLink)
  if (not itemLink) then
    return nil;
  end
  local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
  return itemNumber;
end
