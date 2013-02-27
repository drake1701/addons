--[[
        Give Me Mount:
                copyright 2008-2009 by MERK, Mileg
				Updated by Grimgrin
                based on code by Mileg and Stephen Blaising

]]        

GMMount_ADDONNAME = "Give Me Mount";
GMMount_MACRONAME = "GMMount";

GMMount_VERSION = "4.4.7";

GSTWLF = "";
GSTWLF2 = "";
NoGSTWLF = "";
GMMount_ZoneName = "Default";
GMMount_SubZoneName = "Default";
GMMount_Flyable = ""; 
CWFName = "";
FMLName = "";
GMMount_Mounts = {};
creatureName = ""
RidingLevel = 0
debugmode = false;
Action = "/cast ";

local GndRandNum = 0;
local RndNumCnt = 2;
local FlyRandNum = 0;
local FRndNumCnt = 2;
local GROUNDMOUNT = "";
local FLYINGMOUNT = "";
local LastGND = "";
local LastFLY = "";
local DisLastGND = "";
local DisLastFLY = "";

MOUNTEDUP = nil;

function GMMount_OnLoad()

  SlashCmdList["GIVEMEMOUNTCOMMAND"] = GMMount_SlashHandler;
  SLASH_GIVEMEMOUNTCOMMAND1 = "/givememount";
  SLASH_GIVEMEMOUNTCOMMAND2 = "/gmmount";
  SLASH_GIVEMEMOUNTCOMMAND3 = "/gmmt";
  
end

function GMMount_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMMount_MACRONAME) == 0 ) then
      local numGenMacros, numCharMacros = GetNumMacros();
      if (numGenMacros < 36) then
        CreateMacro(GMMount_MACRONAME, 27, "", nil, nil);
      else
        GMMana_Print("You have 36 General Macros. Cannot add "..GMMana_MACRONAME.."!");
      end
    end
    if (GetSpellInfo(GHOSTWLF)) then
      GSTWLF = "[combat,button:1] "..GHOSTWLF.."; [mod:ctrl,button:1] "..GHOSTWLF..";";
      GSTWLF2 = " "..GHOSTWLF;
    else
      GSTWLF = "";
      NoGSTWLF = 27;
      Action = "/use Hearthstone";
    end
    CWFName = GetSpellInfo(GM_CWF);
	FMLName = GetSpellInfo(GM_FML);
    GMMount_MakeArray();
    GMMount_Go();
--  elseif (event == "PLAYER_REGEN_ENABLED") then
--    GMMount_Go();
  end
end

function GMMount_OnUpdate(event)

  if (GMMount_SubZoneName ~= GetSubZoneText()) and (event == "PLAYER_REGEN_ENABLED") and (not IsMounted()) then

-- Took this part out for now
--    for skillIndex = 1, GetNumSkillLines() do
--      array = {GetSkillLineInfo(skillIndex)}
--      if (array[1] == "Riding") then
--	GMMount_Print("Found " ..array[1].. " with skill: " ..array[4])
--	RidingLevel = array[4]
--      end
      
      GMMount_Go();
 --   end
  
  end
  
  if (IsMounted() ~= MOUNTEDUP) then
    if IsMounted() then
      MOUNTEDUP = IsMounted();
      GMMount_Go();
    else
      MOUNTEDUP = IsMounted();
      GMMount_Go();
    end
  end
end

function GMMount_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help" or msg == "") then
    GMMount_Print(GMMount_ADDONNAME.." |cff3399CCv"..GMMount_VERSION.." ");
    GMMount_Print("Type /macro to open macro list.");
    GMMount_Print("Drag GMMount macro to your action bar.");
    GMMount_Print("This macro has multiple purposes and changes based on location.");
    GMMount_Print("Click to summon mount showing on icon.");
    GMMount_Print("Hold SHIFT and click to summon ground mount if flying is showing.");
    GMMount_Print("While mounted right click to dismount (will dismount even if flying).");
    GMMount_Print("Shamans can hold CTRL and click to cast \"Ghost Wolf\".");
    GMMount_Print("During combat Shamans can click to cast \"Ghost Wolf\".");
  elseif (msg == "update") then
    GMMount_Go();
  elseif (msg == "debug=off") then
    GMMount_Print("Debug mode Disabled.");
    debugmode = false;
  elseif (msg == "debug=on") then
    GMMount_Print("Entering Debug mode: Please type [/gmmt debug=off] to end");
    debugmode = true;
  end
end

function GMMount_GetZoneType()
  if (GMMount_ZoneName ~= GetZoneText()) then
    GMMount_ZoneName = GetZoneText();
--    --GMMount_Print("|cff3399CCUpdated Zone");
  elseif (GMMount_SubZoneName ~= GetSubZoneText()) then
    GMMount_SubZoneName = GetSubZoneText();
--    --GMMount_Print("|cff3399CCUpdated Zone");
  end
  local inCWFZone = GMMount_inArray(GMMount_CWF, GMMount_ZoneName)
  local inFMLZone = GMMount_inArray(GMmount_FML, GMMount_ZoneName)
  local notHaveCWF = CWFName ~= GM_CWF
  local notHaveFML = FMLName ~= GM_FML
  
  if (debugmode) then
    GMMount_Print("Full Zone Name: "..GMMount_ZoneName);
  end
  
  if (GMMount_ZoneName == TOAQ) then
    GMMount_Flyable = "AQ";
  elseif ((inCWFZone and notHaveCWF) or (inFMLZone and notHaveFML)) then
    --GMMount_Print("Missing flight skill to fly here.");
    GMMount_Flyable = "NO";
  elseif (IsFlyableArea()) then
   --GMMount_Print("Flyable and has Permission.");
    GMMount_Flyable = "YES";
  else
	--GMMount_Print("Not Flyable zone.");
    GMMount_Flyable = "NO";
  end
end

function GMMount_Print(msg) 
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMMount_MakeArray()
  GMMount_Mounts ={
	 [260] = { [1] =  V_C_Mount1,   [2] = "SWIM"},
	 [259] = { [1] =  G_C_Mount1,   [2] = "NO"},
	 [258] = { [1] =  G_C_Mount2,   [2] = "NO"},
	 [257] = { [1] =  G_C_Mount3,   [2] = "NO"},
	 [256] = { [1] =  G_C_Mount4,   [2] = "NO"},
	 [255] = { [1] =  G_C_Mount5,   [2] = "NO"},
	 [254] = { [1] =  G_C_Mount6,   [2] = "NO"},
	 [253] = { [1] =  G_C_Mount7,   [2] = "NO"},
	 [252] = { [1] =  G_C_Mount8,   [2] = "NO"},
	 [251] = { [1] =  G_C_Mount9,   [2] = "NO"},
	 [250] = { [1] =  G_C_Mount10,   [2] = "NO"},
	 [249] = { [1] =  G_C_Mount11,   [2] = "NO"},
	 [248] = { [1] =  G_C_Mount12,   [2] = "NO"},
	 [247] = { [1] =  G_C_Mount13,   [2] = "NO"},
	 [246] = { [1] =  G_C_Mount14,   [2] = "NO"},
	 [245] = { [1] =  G_C_Mount15,   [2] = "NO"},
	 [244] = { [1] =  F_C_Mount1,   [2] = "YES"},
	 [243] = { [1] =  F_C_Mount2,   [2] = "YES"},
	 [242] = { [1] =  F_C_Mount3,   [2] = "YES"},
	 [241] = { [1] =  F_C_Mount4,   [2] = "YES"},
	 [240] = { [1] =  F_C_Mount5,   [2] = "YES"},
	 [239] = { [1] =  F_C_Mount6,   [2] = "YES"},
	 [238] = { [1] =  F_C_Mount7,   [2] = "YES"},
	 [237] = { [1] =  F_C_Mount8,   [2] = "YES"},
	 [236] = { [1] =  F_C_Mount9,   [2] = "YES"},
	 [235] = { [1] =  F_C_Mount10,  [2] = "YES"},
	 [234] = { [1] =  F_C_Mount11,  [2] = "YES"},
	 [233] = { [1] =  ANY_MOUNT4,   [2] = "ANY"},
     [232] = { [1] =  ANY_MOUNT3,   [2] = "ANY"},
     [231] = { [1] = G_F_MOUNT116,  [2] = "NO"},
     [230] = { [1] = G_F_MOUNT115,  [2] = "NO"},
     [229] = { [1] = G_F_MOUNT114,  [2] = "NO"},
     [228] = { [1] = G_F_MOUNT113,  [2] = "NO"},
     [227] = { [1] = G_NA_MOUNT1,   [2] = "NA"},
     [226] = { [1] = W_M_MOUNT1,    [2] = "SWIM"},
     [225] = { [1] = F_F_MOUNT48,   [2] = "YES"},
     [224] = { [1] = G_F_MOUNT112,   [2] = "NO"},
     [223] = { [1] = G_F_MOUNT111,   [2] = "NO"},
     [222] = { [1] = G_F_MOUNT110,   [2] = "NO"},
     [221] = { [1] = G_F_MOUNT109,   [2] = "NO"},
     [220] = { [1] = G_F_MOUNT108,   [2] = "NO"},
     [219] = { [1] = G_F_MOUNT107,   [2] = "NO"},
     [218] = { [1] = G_F_MOUNT106,   [2] = "NO"},
     [217] = { [1] = G_F_MOUNT105,   [2] = "NO"},
     [216] = { [1] = F_F_MOUNT47,   [2] = "YES"},
     [215] = { [1] = F_F_MOUNT46,   [2] = "YES"},
     [214] = { [1] = F_F_MOUNT45,   [2] = "YES"},
     [213] = { [1] = G_F_MOUNT104,   [2] = "NO"},
     [212] = { [1] = G_F_MOUNT103,   [2] = "NO"},
     [211] = { [1] = G_F_MOUNT102,   [2] = "NO"},
     [210] = { [1] = G_F_MOUNT101,   [2] = "NO"},
     [209] = { [1] = G_F_MOUNT100,   [2] = "NO"},
     [208] = { [1] = G_F_MOUNT99,   [2] = "NO"},
     [207] = { [1] = G_F_MOUNT98,   [2] = "NO"},
     [206] = { [1] = AQ_MOUNT5,   [2] = "AQ"},
     [205] = { [1] = AQ_MOUNT4,   [2] = "AQ"},
     [204] = { [1] = AQ_MOUNT3,   [2] = "AQ"},
     [203] = { [1] = AQ_MOUNT2,   [2] = "AQ"},
     [202] = { [1] = AQ_MOUNT1,   [2] = "AQ"},
     [201] = { [1] = X_MOUNT8,    [2] = "YES"},
     [200] = { [1] = X_MOUNT7,    [2] = "YES"},
     [199] = { [1] = X_MOUNT6,    [2] = "YES"},
     [198] = { [1] = X_MOUNT5,    [2] = "YES"},
     [197] = { [1] = X_MOUNT4,    [2] = "YES"},
     [196] = { [1] = X_MOUNT3,    [2] = "YES"},
     [195] = { [1] = X_MOUNT2,    [2] = "YES"},
     [194] = { [1] = X_MOUNT1,    [2] = "YES"},
     [193] = { [1] = ANY_MOUNT2,  [2] = "YES" },
     [192] = { [1] = ANY_MOUNT1,  [2] = "ANY" },
     [191] = { [1] = F_F_MOUNT44, [2] = "YES"},
     [190] = { [1] = F_F_MOUNT43, [2] = "YES"},
     [189] = { [1] = F_F_MOUNT42, [2] = "YES"},
     [188] = { [1] = F_F_MOUNT41, [2] = "YES"},
     [187] = { [1] = F_F_MOUNT40, [2] = "YES"},
     [186] = { [1] = F_F_MOUNT39, [2] = "YES"},
     [185] = { [1] = F_F_MOUNT38, [2] = "YES"},
     [184] = { [1] = F_F_MOUNT37, [2] = "YES"},
     [183] = { [1] = F_F_MOUNT36, [2] = "YES"},
     [182] = { [1] = F_F_MOUNT35, [2] = "YES"},
     [181] = { [1] = F_F_MOUNT34, [2] = "YES"},
     [180] = { [1] = F_F_MOUNT33, [2] = "YES"},
     [179] = { [1] = F_F_MOUNT32, [2] = "YES"},
     [178] = { [1] = F_F_MOUNT31, [2] = "YES"},
     [177] = { [1] = F_F_MOUNT30, [2] = "YES"},
     [176] = { [1] = F_F_MOUNT29, [2] = "YES"},
     [175] = { [1] = F_F_MOUNT28, [2] = "YES"},
     [174] = { [1] = F_F_MOUNT27, [2] = "YES"},
     [173] = { [1] = F_F_MOUNT26, [2] = "YES"},
     [172] = { [1] = F_F_MOUNT25, [2] = "YES"},
     [171] = { [1] = F_F_MOUNT24, [2] = "YES"},
     [170] = { [1] = F_F_MOUNT23, [2] = "YES"},
     [169] = { [1] = F_F_MOUNT22, [2] = "YES"},
     [168] = { [1] = F_F_MOUNT21, [2] = "YES"},
     [167] = { [1] = F_F_MOUNT20, [2] = "YES"},
     [166] = { [1] = F_F_MOUNT19, [2] = "YES"},
     [165] = { [1] = F_F_MOUNT18, [2] = "YES"},
     [164] = { [1] = F_F_MOUNT17, [2] = "YES"},
     [163] = { [1] = F_F_MOUNT16, [2] = "YES"},
     [162] = { [1] = F_F_MOUNT15, [2] = "YES"},
     [161] = { [1] = F_F_MOUNT14, [2] = "YES"},
     [160] = { [1] = F_F_MOUNT13, [2] = "YES"},
     [159] = { [1] = F_F_MOUNT12, [2] = "YES"},
     [158] = { [1] = F_F_MOUNT11, [2] = "YES"},
     [157] = { [1] = F_F_MOUNT10, [2] = "YES"},
     [156] = { [1] = F_F_MOUNT9,  [2] = "YES"},
     [155] = { [1] = F_F_MOUNT8,  [2] = "YES"},
     [154] = { [1] = F_F_MOUNT7,  [2] = "YES"},
     [153] = { [1] = F_F_MOUNT6,  [2] = "YES"},
     [152] = { [1] = F_F_MOUNT5,  [2] = "YES"},
     [151] = { [1] = F_F_MOUNT4,  [2] = "YES"},
     [150] = { [1] = F_F_MOUNT3,  [2] = "YES"},
     [149] = { [1] = F_F_MOUNT2,  [2] = "YES"},
     [148] = { [1] = F_F_MOUNT1,  [2] = "YES"},
     [147] = { [1] = F_S_MOUNT11, [2] = "YES"},
     [146] = { [1] = F_S_MOUNT10, [2] = "YES"},
     [145] = { [1] = F_S_MOUNT9,  [2] = "YES"},
     [144] = { [1] = F_S_MOUNT8,  [2] = "YES"},
     [143] = { [1] = F_S_MOUNT7,  [2] = "YES"},
     [142] = { [1] = F_S_MOUNT6,  [2] = "YES"},
     [141] = { [1] = F_S_MOUNT5,  [2] = "YES"},
     [140] = { [1] = F_S_MOUNT4,  [2] = "YES"},
     [139] = { [1] = F_S_MOUNT3,  [2] = "YES"},
     [138] = { [1] = F_S_MOUNT2,  [2] = "YES"},
     [137] = { [1] = F_S_MOUNT1,  [2] = "YES"},
     [136] = { [1] = G_F_MOUNT97, [2] =  "NO"},
     [135] = { [1] = G_F_MOUNT96, [2] =  "NO"},
     [134] = { [1] = G_F_MOUNT95, [2] =  "NO"},
     [133] = { [1] = G_F_MOUNT94, [2] =  "NO"},
     [132] = { [1] = G_F_MOUNT93, [2] =  "NO"},
     [131] = { [1] = G_F_MOUNT92, [2] =  "NO"},
     [130] = { [1] = G_F_MOUNT91, [2] =  "NO"},
     [129] = { [1] = G_F_MOUNT90, [2] =  "NO"},
     [128] = { [1] = G_F_MOUNT89, [2] =  "NO"},
     [127] = { [1] = G_F_MOUNT88, [2] =  "NO"},
     [126] = { [1] = G_F_MOUNT87, [2] =  "NO"},
     [125] = { [1] = G_F_MOUNT86, [2] =  "NO"},
     [124] = { [1] = G_F_MOUNT85, [2] =  "NO"},
     [123] = { [1] = G_F_MOUNT84, [2] =  "NO"},
     [122] = { [1] = G_F_MOUNT83, [2] =  "NO"},
     [121] = { [1] = G_F_MOUNT82, [2] =  "NO"},
     [120] = { [1] = G_F_MOUNT81, [2] =  "NO"},
     [119] = { [1] = G_F_MOUNT80, [2] =  "NO"},
     [118] = { [1] = G_F_MOUNT79, [2] =  "NO"},
     [117] = { [1] = G_F_MOUNT78, [2] =  "NO"},
     [116] = { [1] = G_F_MOUNT77, [2] =  "NO"},
     [115] = { [1] = G_F_MOUNT76, [2] =  "NO"},
     [114] = { [1] = G_F_MOUNT75, [2] =  "NO"},
     [113] = { [1] = G_F_MOUNT74, [2] =  "NO"},
     [112] = { [1] = G_F_MOUNT73, [2] =  "NO"},
     [111] = { [1] = G_F_MOUNT72, [2] =  "NO"},
     [110] = { [1] = G_F_MOUNT71, [2] =  "NO"},
     [109] = { [1] = G_F_MOUNT70, [2] =  "NO"},
     [108] = { [1] = G_F_MOUNT69, [2] =  "NO"},
     [107] = { [1] = G_F_MOUNT68, [2] =  "NO"},
     [106] = { [1] = G_F_MOUNT67, [2] =  "NO"},
     [105] = { [1] = G_F_MOUNT66, [2] =  "NO"},
     [104] = { [1] = G_F_MOUNT65, [2] =  "NO"},
     [103] = { [1] = G_F_MOUNT64, [2] =  "NO"},
     [102] = { [1] = G_F_MOUNT63, [2] =  "NO"},
     [101] = { [1] = G_F_MOUNT62, [2] =  "NO"},
     [100] = { [1] = G_F_MOUNT61, [2] =  "NO"},
      [99] = { [1] = G_F_MOUNT60, [2] =  "NO"},
      [98] = { [1] = G_F_MOUNT59, [2] =  "NO"},
      [97] = { [1] = G_F_MOUNT58, [2] =  "NO"},
      [96] = { [1] = G_F_MOUNT57, [2] =  "NO"},
      [95] = { [1] = G_F_MOUNT56, [2] =  "NO"},
      [94] = { [1] = G_F_MOUNT55, [2] =  "NO"},
      [93] = { [1] = G_F_MOUNT54, [2] =  "NO"},
      [92] = { [1] = G_F_MOUNT53, [2] =  "NO"},
      [91] = { [1] = G_F_MOUNT52, [2] =  "NO"},
      [90] = { [1] = G_F_MOUNT51, [2] =  "NO"},
      [89] = { [1] = G_F_MOUNT50, [2] =  "NO"},
      [88] = { [1] = G_F_MOUNT49, [2] =  "NO"},
      [87] = { [1] = G_F_MOUNT48, [2] =  "NO"},
      [86] = { [1] = G_F_MOUNT47, [2] =  "NO"},
      [85] = { [1] = G_F_MOUNT46, [2] =  "NO"},
      [84] = { [1] = G_F_MOUNT45, [2] =  "NO"},
      [83] = { [1] = G_F_MOUNT44, [2] =  "NO"},
      [82] = { [1] = G_F_MOUNT43, [2] =  "NO"},
      [81] = { [1] = G_F_MOUNT42, [2] =  "NO"},
      [80] = { [1] = G_F_MOUNT41, [2] =  "NO"},
      [79] = { [1] = G_F_MOUNT40, [2] =  "NO"},
      [78] = { [1] = G_F_MOUNT39, [2] =  "NO"},
      [77] = { [1] = G_F_MOUNT38, [2] =  "NO"},
      [76] = { [1] = G_F_MOUNT37, [2] =  "NO"},
      [75] = { [1] = G_F_MOUNT36, [2] =  "NO"},
      [74] = { [1] = G_F_MOUNT35, [2] =  "NO"},
      [73] = { [1] = G_F_MOUNT34, [2] =  "NO"},
      [72] = { [1] = G_F_MOUNT33, [2] =  "NO"},
      [71] = { [1] = G_F_MOUNT32, [2] =  "NO"},
      [70] = { [1] = G_F_MOUNT31, [2] =  "NO"},
      [69] = { [1] = G_F_MOUNT30, [2] =  "NO"},
      [68] = { [1] = G_F_MOUNT29, [2] =  "NO"},
      [67] = { [1] = G_F_MOUNT28, [2] =  "NO"},
      [66] = { [1] = G_F_MOUNT27, [2] =  "NO"},
      [65] = { [1] = G_F_MOUNT26, [2] =  "NO"},
      [64] = { [1] = G_F_MOUNT25, [2] =  "NO"},
      [63] = { [1] = G_F_MOUNT24, [2] =  "NO"},
      [62] = { [1] = G_F_MOUNT23, [2] =  "NO"},
      [61] = { [1] = G_F_MOUNT22, [2] =  "NO"},
      [60] = { [1] = G_F_MOUNT21, [2] =  "NO"},
      [59] = { [1] = G_F_MOUNT20, [2] =  "NO"},
      [58] = { [1] = G_F_MOUNT19, [2] =  "NO"},
      [57] = { [1] = G_F_MOUNT18, [2] =  "NO"},
      [56] = { [1] = G_F_MOUNT17, [2] =  "NO"},
      [55] = { [1] = G_F_MOUNT16, [2] =  "NO"},
      [54] = { [1] = G_F_MOUNT15, [2] =  "NO"},
      [53] = { [1] = G_F_MOUNT14, [2] =  "NO"},
      [52] = { [1] = G_F_MOUNT13, [2] =  "NO"},
      [51] = { [1] = G_F_MOUNT12, [2] =  "NO"},
      [50] = { [1] = G_F_MOUNT11, [2] =  "NO"},
      [49] = { [1] = G_F_MOUNT10, [2] =  "NO"},
      [48] = { [1] = G_F_MOUNT9,  [2] =  "NO"},
      [47] = { [1] = G_F_MOUNT8,  [2] =  "NO"},
      [46] = { [1] = G_F_MOUNT7,  [2] =  "NO"},
      [45] = { [1] = G_F_MOUNT6,  [2] =  "NO"},
      [44] = { [1] = G_F_MOUNT5,  [2] =  "NO"},
      [43] = { [1] = G_F_MOUNT4,  [2] =  "NO"},
      [42] = { [1] = G_F_MOUNT3,  [2] =  "NO"},
      [41] = { [1] = G_F_MOUNT2,  [2] =  "NO"},
      [40] = { [1] = G_F_MOUNT1,  [2] =  "NO"},
      [39] = { [1] = G_S_MOUNT39, [2] =  "NO"},
      [38] = { [1] = G_S_MOUNT38, [2] =  "NO"},
      [37] = { [1] = G_S_MOUNT37, [2] =  "NO"},
      [36] = { [1] = G_S_MOUNT36, [2] =  "NO"},
      [35] = { [1] = G_S_MOUNT35, [2] =  "NO"},
      [34] = { [1] = G_S_MOUNT34, [2] =  "NO"},
      [33] = { [1] = G_S_MOUNT33, [2] =  "NO"},
      [32] = { [1] = G_S_MOUNT32, [2] =  "NO"},
      [31] = { [1] = G_S_MOUNT31, [2] =  "NO"},
      [30] = { [1] = G_S_MOUNT30, [2] =  "NO"},
      [29] = { [1] = G_S_MOUNT29, [2] =  "NO"},
      [28] = { [1] = G_S_MOUNT28, [2] =  "NO"},
      [27] = { [1] = G_S_MOUNT27, [2] =  "NO"},
      [26] = { [1] = G_S_MOUNT26, [2] =  "NO"},
      [25] = { [1] = G_S_MOUNT25, [2] =  "NO"},
      [24] = { [1] = G_S_MOUNT24, [2] =  "NO"},
      [23] = { [1] = G_S_MOUNT23, [2] =  "NO"},
      [22] = { [1] = G_S_MOUNT22, [2] =  "NO"},
      [21] = { [1] = G_S_MOUNT21, [2] =  "NO"},
      [20] = { [1] = G_S_MOUNT20, [2] =  "NO"},
      [19] = { [1] = G_S_MOUNT19, [2] =  "NO"},
      [18] = { [1] = G_S_MOUNT18, [2] =  "NO"},
      [17] = { [1] = G_S_MOUNT17, [2] =  "NO"},
      [16] = { [1] = G_S_MOUNT16, [2] =  "NO"},
      [15] = { [1] = G_S_MOUNT15, [2] =  "NO"},
      [14] = { [1] = G_S_MOUNT14, [2] =  "NO"},
      [13] = { [1] = G_S_MOUNT13, [2] =  "NO"},
      [12] = { [1] = G_S_MOUNT12, [2] =  "NO"},
      [11] = { [1] = G_S_MOUNT11, [2] =  "NO"},
      [10] = { [1] = G_S_MOUNT10, [2] =  "NO"},
       [9] = { [1] = G_S_MOUNT9,  [2] =  "NO"},
       [8] = { [1] = G_S_MOUNT8,  [2] =  "NO"},
       [7] = { [1] = G_S_MOUNT7,  [2] =  "NO"},
       [6] = { [1] = G_S_MOUNT6,  [2] =  "NO"},
       [5] = { [1] = G_S_MOUNT5,  [2] =  "NO"},
       [4] = { [1] = G_S_MOUNT4,  [2] =  "NO"},
       [3] = { [1] = G_S_MOUNT3,  [2] =  "NO"},
       [2] = { [1] = G_S_MOUNT2,  [2] =  "NO"},
       [1] = { [1] = G_S_MOUNT1,  [2] =  "NO"},
  };
  GMMount_CWF = {
		[1] = CWNR1,
		[2] = CWNR2,
		[3] = CWNR3,
		[4] = CWNR4,
		[5] = CWNR5,
		[6] = CWNR6,
		[7] = CWNR7,
		[8] = CWNR8,
		[9] = CWNR9,
		[10] = CWNR10,
		[11] = CWNR11,
  };
  GMmount_FML = {
		[1] = FM1,
		[2] = FM2,
		[3] = FM3,
		[4] = FM4,
		[5] = FM5,
		[6] = FM6,
		[7] = FM7,
		[8] = FM8,
		[9] = FM9,
		[10] = FM10,
		[11] = FM11,
		[12] = FM12,
		[13] = FM13,
		[14] = FM14,
		[15] = FM15,
		[16] = FM16,
		[17] = FM17,
		[18] = FM18,
		[19] = FM19,
		[20] = FM20,
		[21] = FM21,
		[22] = FM22,
		[23] = FM23,
		[24] = FM24,
		[25] = FM25,
		[26] = FM26,
		[27] = FM27,
		[28] = FM28,
		[29] = FM29,
		[30] = FM30,
		[31] = FM31,
		[32] = FM32,
		[33] = FM33,
		[34] = FM34,
		[35] = FM35,
		[36] = FM36,
		[37] = FM37,
		[38] = FM38,
		[39] = FM39,
		[40] = FM40,
		[41] = FM41,
		[42] = FM42,
		[43] = FM43,
		[44] = FM44,
		[45] = FM45,
		[46] = FM46,
		[47] = FM47,
		[48] = FM48,
		[49] = FM49,
		[50] = FM50,
		[51] = FM51,
		[52] = FM52,
		[53] = FM53,
		[54] = FM54,
		[55] = FM55,
		[56] = FM56,
		[57] = FM57,
		[58] = FM58,
		[59] = FM59,
		[60] = FM60,
		[61] = FM61,
		[62] = FM62,
		[63] = FM63,
		[64] = FM64,
		[65] = FM65,
		[66] = FM66,
		[67] = FM67,
		[68] = FM68,
		[69] = FM69,
  };
end

function GMMount_inArray(array, value)
   local found = false
   
   for _,v in pairs(array) do
     if v == value then
	   found = true
	   end
	end
	return found;

end

function GMMount_isFlyer(array)
     return array[2] == "YES" or array [2] == "ANY"
end

function GMMount_isLand(array)
     return array[2] == "NO" or array [2] == "ANY"
end

function GMMount_isAQ(array)
     return array[2] == "AQ"
end

function GMMount_isSwimmer(array)
     return array[2] == "SWIM"
end

function GMMount_Go()
        
--[[  if IsMounted() == 1 then
    --GMMount_Print("Mounted");
  else
    --GMMount_Print("Not Mounted");
  end
]]
  
  local grndMnt = {};
  local flyMnt = {};
  local aqMnt = {};
  local swimMnt = {};
  
  local mNum = 0;
  local aq = "no";
  local extreme = "no";
  local fast = "no";
  local RndNumCnt = 0;
  local FRndNumCnt = 0;
  
  GMMount_GetZoneType();
  
--  mName = "No Mount";
  local cnt = GetNumCompanions("MOUNT");
  
  if (MOUNTEDUP == nil) then

	flycnt = 1;
	landcnt = 1;
	aqcnt = 1;
	swimcnt = 1;
	newMount = "inDB";
	
      if (cnt > 0) then
        local Counter = 0;
        for Mslot = 1,cnt,1 do
          _, creatureName = GetCompanionInfo("MOUNT", Mslot);
          if (creatureName) then
	  --GMMount_Print("Looking at "..creatureName);
	  if (creatureName ~= ANY_MOUNT1) then
		creatureName = string.gsub(creatureName, " Mount", "");
	  end
	  newMount = creatureName;
            Counter = (Counter + 1);
            for index = 1,table.getn(GMMount_Mounts),1 do
              if (GMMount_Mounts[index][1] == creatureName) then
				  isFlyer = GMMount_isFlyer(GMMount_Mounts[index])
				  isLand = GMMount_isLand(GMMount_Mounts[index])
				  isAQ = GMMount_isAQ(GMMount_Mounts[index])
				  isSwimmer = GMMount_isSwimmer(GMMount_Mounts[index])
				  
				  if (isFlyer) then
					-- add to flying array Bump up coutner (if there is one)
					--GMMount_Print("Adding "..creatureName.." to Flying Mounts");
					flyMnt[flycnt] = creatureName
					flycnt = flycnt + 1;
				  end
				  if (isLand) then
					-- add to Land array Bump up coutner (if there is one)
					--GMMount_Print("Adding "..creatureName.." to Land Mounts");
					grndMnt[landcnt] = creatureName
					landcnt = landcnt + 1;
				  end
				  if (isAQ) then
					-- add to gorund mounts since its' AQ
					grndMnt[landcnt] = creatureName
					landcnt = landcnt + 1;
				  end
				  if (isSwimmer) then
					-- add to Swimming array Bump up coutner (if there is one)
					swimMnt[swimcnt] = creatureName
					swimcnt = swimcnt + 1;
				  end
				end
			end
	
	  if (newMount ~= "inDB" and debugmode) then
	    	GMMount_Print("You have a mount that is unknown to GMMount! Please infom the Author of: \""..newMount.."\"");
		GMMount_Print("at WoWUI.IncGamers.com Or Curse.com (Please post on the GMX page). Make sure you include everything in quotes.");
		GMMount_Print("To disable this message, type: /gmmt debug=off");
	  end
      end
    end
    end
    end
  
    MountLevel = 0
    SLOWLAND = "";
    SLOWFLYING = "";
   
  if ( # grndMnt > 0) then
   MountLevel = 1
    FlyRandNum = math.random(1, #grndMnt);
    --GMMount_Print("F RndNumCnt = "..FRndNumCnt);
    --GMMount_Print("SLOWLAND = "..slowland[FlyRandNum]);
    SLOWLAND    = grndMnt[FlyRandNum];
  end
  if ( # flyMnt > 0) then
   MountLevel = 3
    FlyRandNum = math.random(1, #flyMnt);
    --GMMount_Print("F RndNumCnt = "..FRndNumCnt);
    --GMMount_Print("SLOWFLYING = "..slowfly[FlyRandNum]);
    SLOWFLYING    = flyMnt[FlyRandNum];
  end
  
  --GMMount_Print("FASTLAND: "..FASTLAND);
  --GMMount_Print("SLOWLAND: "..SLOWLAND);
  

if (SLOWLAND == "Thalassian Charger" or SLOWLAND == "Charger") then
      --GMMount_Print("CHANGING TO CHARGER");
      SLOWLAND = "Summon Charger";
  end
 if (SLOWLAND == "Thalassian Warhorse" or SLOWLAND == "Warhorse") then
      --GMMount_Print("CHANGING TO Warhorse");
      SLOWLAND = "Summon Warhorse";
  end
  if (SLOWLAND == "Sunwalker Kodo") then
      --GMMount_Print("CHANGING TO Kodo");
      SLOWLAND = "Summon Sunwalker Kodo";
  end
  if (SLOWLAND == "Great Sunwalker Kodo") then
      --GMMount_Print("CHANGING TO Kodo");
      SLOWLAND = "Summon Great Sunwalker Kodo";
  end
  if (SLOWLAND == "Great Exarch's Elekk" or SLOWLAND == "Exarch's Elekk") then
      --GMMount_Print("CHANGING TO Elekk");
      SLOWLAND = "Summon Exarch's Elekk";
  end

  
  
  if (MOUNTEDUP == nil) then
    if (MountLevel == 4 and GMMount_Flyable == "YES") then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.."[button:1,mod] "..SLOWFLYING.."; [button:1] "..SLOWFLYING.."\n/dismount [button:2 mounted]", nil, nil);
    elseif (MountLevel == 3 and GMMount_Flyable == "YES") and (MOUNTEDUP == nil) then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.."[button:1,mod]"..SLOWLAND..";[button:1] "..SLOWFLYING.."\n/dismount [button:2 mounted]", nil, nil);
    
    elseif (MountLevel == 4 or (MountLevel > 2 and GMMount_Flyable ~= "YES")) and (MOUNTEDUP == nil) then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.." [button:1, mod]"..SLOWFLYING.."; [button:1] "..SLOWLAND.."\n/dismount [button:2mounted]", nil, nil);
    elseif (MountLevel == 3 or (MountLevel > 2 and GMMount_Flyable ~= "YES")) and (MOUNTEDUP == nil) then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.." [button:1, mod]"..SLOWFLYING.."; [button:1] "..SLOWLAND.."\n/dismount [button:2mounted]", nil, nil);
    
    elseif (MountLevel == 2 or (MountLevel > 2 and GMMount_Flyable ~= "YES")) and (MOUNTEDUP == nil) then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.."[button:1,mod] "..SLOWLAND.."; [button:1] "..SLOWLAND.."\n/dismount [button:2mounted]", nil, nil);
    elseif (MountLevel == 1 or (MountLevel > 2 and GMMount_Flyable ~= "YES")) and (MOUNTEDUP == nil) then
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n/cast "..GSTWLF.."[button:1] "..SLOWLAND.."\n/dismount [button:2mounted]", nil, nil);
    else
       EditMacro(GMMount_MACRONAME,GMMount_MACRONAME, 1,"#showtooltip\n/use [button:2,nomounted] hearthstone\n"..Action..GSTWLF, nil, nil);
    end
  end


end
