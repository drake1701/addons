--[[
        Give Me Bandage:
                Copyright 2009 by MERK, Mileg
                based on code by Mileg and Stephen Blaising
                
]]

GMBandage_ADDONNAME = "Give Me Bandage";
GMBandage_MACRONAME = "GMBandage";

GMBandage_VERSION = "4.5.1";

FIRSTA = "";
FIRSTA2 = ""
NoFIRSTA = "INV_Misc_QuestionMark";
FAIcon = "Inv_misc_surgeonglove_01";
local GMBandage_ZoneName = "Default";
local GMBandage_ZoneType = "Default";
local GMBandage_UpdateFrame
local GMBandageUpdate       = {}
GMBandage_UpdateFrame = CreateFrame("Frame")


function GMBandage_OnLoad(event)
  SlashCmdList["GIVEMEBANDAGECOMMAND"] = GMBandage_SlashHandler;
  SLASH_GIVEMEBANDAGECOMMAND1 = "/givemebandage";
  SLASH_GIVEMEBANDAGECOMMAND2 = "/gmbandage";
  SLASH_GIVEMEBANDAGECOMMAND3 = "/gmband";
  
end

function GMBandage_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMBandage_MACRONAME) == 0) then
      local numGenMacros, numCharMacros = GetNumMacros();
      if (numGenMacros < 36) then
        CreateMacro(GMBandage_MACRONAME, FAIcon, "", nil, nil)
      else
        GMBandage_Print("You have 36 General Macros. Cannot add "..GMBandage_MACRONAME.."!");
      end
    end
    if (GetSpellInfo(FAID)) then
      FIRSTA = "[mod:ctrl] "..FAID..";";
      FIRSTA2 = "[] "..FAID..";";
    else
      FIRSTA = "";
      NoFIRSTA = FAIcon;
    end
		GMBandage_UpdateFrame:SetScript("OnUpdate", GMBandage_UpdateFrame_OnUpdate)
  end
  if event == "BAG_UPDATE" then
		GMBandage_UpdateFrame:SetScript("OnUpdate", GMBandage_UpdateFrame_OnUpdate)
  end
end

function GMBandage_UpdateFrame_OnUpdate(self, elapsed)
local affectingCombat = UnitAffectingCombat("player");
	for i = 0, 11 do
		if GMBandageUpdate[i] then
			GMBandageUpdate[i] = nil
		end
	end
	if GMBandageUpdate.inv then
		GMBandageUpdate.inv = nil
	end
		if(affectingCombat ~= 1) then
			self:SetScript("OnUpdate", nil)
			GMBandage_MakeArray();
			GMBandage_Go();
  end

end

function GMBandage_OnUpdate(event)
  if (GMBandage_ZoneName ~= GetRealZoneText()) then
    GMBandage_UpdateFrame:SetScript("OnUpdate", GMBandage_UpdateFrame_OnUpdate)
  end
end

function GMBandage_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help" or msg == "") then
    GMBandage_Print(GMBandage_ADDONNAME.." |cff3399CCv"..GMBandage_VERSION.." ");
    GMBandage_Print("Type /macro to open macro list.");
    GMBandage_Print("Drag GMBandage macro to your action bar.");
    GMBandage_Print("Click to use best bandage.");
    GMBandage_Print("Hold ALT and click to use best bandage on self.");
    GMBandage_Print("Hold SHIFT and click to use second best bandage.");
    GMBandage_Print("Hold SHIFT+ALT and click to use second best bandage on self.");
    GMBandage_Print("Hold CTRL and click to open \"First Aid\" tradeskill frame.");
  end
end

function GMBandage_GetZoneType()
  if (GMBandage_ZoneName ~= GetRealZoneText()) then
    GMBandage_ZoneName = GetRealZoneText();
    if ((GMBandage_ZoneName == WSG) or (GMBandage_ZoneName == AV) or (GMBandage_ZoneName == AB) or (GMBandage_ZoneName == EOTS) or (GMBandage_ZoneName == SOTA)) then
      GMBandage_ZoneType = "BG";
	elseif ((GMBandage_ZoneName == TB) or (GMBandage_ZoneName == TBP)) then
      GMBandage_ZoneType = "TB";
    elseif ((GMBandage_ZoneName == BOT) or (GMBandage_ZoneName == EYE) or (GMBandage_ZoneName == MECH) or (GMBandage_ZoneName == ARCA)) then
      GMBandage_ZoneType = "TK";
    elseif ((GMBandage_ZoneName == SSC) or (GMBandage_ZoneName == UB) or (GMBandage_ZoneName == SV) or (GMBandage_ZoneName == SP)) then
      GMBandage_ZoneType = "CFR";
    elseif ((GMBandage_ZoneName == BEM) or (GMBandage_ZoneName == GL)) then
      GMBandage_ZoneType = "BE";
    elseif ((GMBandage_ZoneName == ARENA_BE) or (GMBandage_ZoneName == ARENA_D) or (GMBandage_ZoneName == ARENA_N) or (GMBandage_ZoneName == ARENA_ROL) or (GMBandage_ZoneName == ARENA_ROV)) then
      GMBandage_ZoneType = "ARENA";
    else
      GMBandage_ZoneType = "ALL";
    end
  end
end

function GMBandage_Print(msg)
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMBandage_MakeArray()
  GMBandage_Bandages = {

	[38] = { [1] = BAN_123120,    	[2] = 85, [3] = 123120, [4] = "ALL", [5] = "ALL" },
	[37] = { [1] = BAN_123120_2,    [2] = 85, [3] = 123120, [4] = "ALL", [5] = "ALL" },
	[36] = { [1] = BAN_54720,    	[2] = 85, [3] = 54720,  [4] = "ALL", [5] = "ALL" },
	[35] = { [1] = BAN_54720_2,    	[2] = 85, [3] = 54720,  [4] = "ALL", [5] = "ALL" },
	[34] = { [1] = BAN_35000_TB_A,	[2] =  0, [3] = 4375, [4] = "TB",  [5] = "ALL" },
	[33] = { [1] = BAN_35000_TB_H,	[2] =  0, [3] = 4375, [4] = "TB",  [5] = "ALL" },
	[32] = { [1] = BAN_2000_WSG, 	[2] = 45, [3] =  250, [4] = WSG,   [5] = "ALL" },
    [31] = { [1] = BAN_1104_WSG, 	[2] = 35, [3] =  138, [4] = WSG,   [5] = "ALL" },
    [30] = { [1] = BAN_640_WSG,  	[2] = 25, [3] =   80, [4] = WSG,   [5] = "ALL" },
    [29] = { [1] = BAN_2000_AB3, 	[2] = 45, [3] =  250, [4] =  AB,   [5] = "ALL" },
    [28] = { [1] = BAN_2000_AB2, 	[2] = 45, [3] =  250, [4] =  AB,   [5] = "ALL" },
    [27] = { [1] = BAN_2000_AB,  	[2] = 45, [3] =  250, [4] =  AB,   [5] = "ALL" },
    [26] = { [1] = BAN_1104_AB3, 	[2] = 35, [3] =  138, [4] =  AB,   [5] = "ALL" },
    [25] = { [1] = BAN_1104_AB2, 	[2] = 35, [3] =  138, [4] =  AB,   [5] = "ALL" },
    [24] = { [1] = BAN_1104_AB,  	[2] = 35, [3] =  138, [4] =  AB,   [5] = "ALL" },
    [23] = { [1] = BAN_640_AB3,  	[2] = 25, [3] =   80, [4] =  AB,   [5] = "ALL" },
    [22] = { [1] = BAN_640_AB2,  	[2] = 25, [3] =   80, [4] =  AB,   [5] = "ALL" },
    [21] = { [1] = BAN_640_AB,   	[2] = 25, [3] =   80, [4] =  AB,   [5] = "ALL" },
    [20] = { [1] = BAN_2000_AV,  	[2] =  0, [3] =  250, [4] =  AV,   [5] = "ALL" },
    [19] = { [1] = BAN_35000,    	[2] =  0, [3] = 4375, [4] = "ALL", [5] = "ALL" },
    [18] = { [1] = BAN_26000,    	[2] =  0, [3] = 3250, [4] = "ALL", [5] = "ALL" },
    [17] = { [1] = BAN_17400,    	[2] =  0, [3] = 2175, [4] = "ALL", [5] = "ALL" },
    [16] = { [1] = BAN_4100,     	[2] =  0, [3] = 1025, [4] = "ALL", [5] = "ALL" },
    [15] = { [1] = BAN_3400_2,   	[2] =  0, [3] =  850, [4] = "ALL", [5] = "ALL" },
    [14] = { [1] = BAN_5800,     	[2] =  0, [3] =  725, [4] = "ALL", [5] = "ALL" },
    [13] = { [1] = BAN_4800,     	[2] =  0, [3] =  600, [4] = "ALL", [5] = "ALL" },
    [12] = { [1] = BAN_3400,     	[2] =  0, [3] =  425, [4] = "ALL", [5] = "ALL" },
    [11] = { [1] = BAN_2800,     	[2] =  0, [3] =  350, [4] = "ALL", [5] = "ALL" },
    [10] = { [1] = BAN_2000,     	[2] =  0, [3] =  250, [4] = "ALL", [5] = "ALL" },
    [ 9] = { [1] = BAN_1360,     	[2] =  0, [3] =  170, [4] = "ALL", [5] = "ALL" },
    [ 8] = { [1] = BAN_1104,     	[2] =  0, [3] =  138, [4] = "ALL", [5] = "ALL" },
    [ 7] = { [1] = BAN_800,      	[2] =  0, [3] =  100, [4] = "ALL", [5] = "ALL" },
    [ 6] = { [1] = BAN_640,      	[2] =  0, [3] =   80, [4] = "ALL", [5] = "ALL" },
    [ 5] = { [1] = BAN_400,      	[2] =  0, [3] =   50, [4] = "ALL", [5] = "ALL" },
    [ 4] = { [1] = BAN_301,      	[2] =  0, [3] =   43, [4] = "ALL", [5] = "ALL" },
    [ 3] = { [1] = BAN_161,      	[2] =  0, [3] =   23, [4] = "ALL", [5] = "ALL" },
    [ 2] = { [1] = BAN_114,      	[2] =  0, [3] =   19, [4] = "ALL", [5] = "ALL" },
    [ 1] = { [1] = BAN_66,       	[2] =  0, [3] =   11, [4] = "ALL", [5] = "ALL" },
  }
end

function GMBandage_Go()
  
  local bandageRank = 0;
  local BbandageRank = 0;
  local bandageItemNum = 0;
  local BbandageItemNum = 0;
  local oldBandageItemLink = "Nothing";
  local BoldBandageItemLink = "Nothing";
  
  local Boverride = false
  
  GMBandage_GetZoneType();
  for bagID = 0, 4, 1 do
    local bagSlotCnt = GetContainerNumSlots(bagID);
    if (bagSlotCnt > 0) then
      for slot = 1, bagSlotCnt, 1 do
        local itemLink = GetContainerItemLink(bagID, slot);
        local itemNumber = GMBandage_NumFromLink(itemLink);
        if (itemNumber) then
          for index = 1, #(GMBandage_Bandages), 1 do
            if (GMBandage_Bandages[index][1] == itemNumber) then
              if (GMBandage_Bandages[index][2] <= UnitLevel("player")) then
                if ((GMBandage_Bandages[index][4] == GMBandage_ZoneType) or (GMBandage_Bandages[index][4] == GMBandage_ZoneName) or (GMBandage_Bandages[index][4] == "ALL")) then  
                  if (GMBandage_Bandages[index][4] ~= "ALL") then
                    Boverride = true
                    BoldBandageItemLink = oldBandageItemLink;
                    oldBandageItemLink = itemLink;
                    BbandageRank = bandageRank;
                    bandageRank = GMBandage_Bandages[index][3];
                    BbandageItemNum = bandageItemNum;
                    bandageItemNum = itemNumber;
                  end
                  if ((GMBandage_Bandages[index][3] > bandageRank) and (not Boverride)) then
                    BoldBandageItemLink = oldBandageItemLink;
                    oldBandageItemLink = itemLink;
                    BbandageRank = bandageRank;
                    bandageRank = GMBandage_Bandages[index][3];
                    BbandageItemNum = bandageItemNum;
                    bandageItemNum = itemNumber;
                  elseif ((GMBandage_Bandages[index][3] == bandageRank) and (itemLink ~= oldBandageItemLink) and (not Boverride)) then
                    local oldItemCnt = GetItemCount(oldBandageItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      oldBandageItemLink = itemLink;
                      bandageRank = GMBandage_Bandages[index][3];
                      bandageItemNum = itemNumber;
                    end
                  elseif ((GMBandage_Bandages[index][3] < bandageRank) and (GMBandage_Bandages[index][3] > BbandageRank)) then
                    BoldBandageItemLink = itemLink;
                    BbandageRank = GMBandage_Bandages[index][3];
                    BbandageItemNum = itemNumber;
                  elseif ((GMBandage_Bandages[index][3] == BbandageRank) and (itemLink ~= BoldBandageItemLink)) then
                    local oldItemCnt = GetItemCount(BoldBandageItemLink);
                    local newItemCnt = GetItemCount(itemLink);
                    if (newItemCnt <= oldItemCnt) then
                      BoldBandageItemLink = itemLink;
                      BbandageRank = GMBandage_Bandages[index][3];
                      BbandageItemNum = itemNumber;
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
 			if ((bandageRank > 0) and (BbandageRank > 0)) then
			EditMacro(GMBandage_MACRONAME, GMBandage_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..FIRSTA.." [mod:alt,mod:shift,target=player] item:"..BbandageItemNum.."; [mod:alt,target=player] item:"..bandageItemNum.."; [mod:shift] item:"..BbandageItemNum.."; [] item:"..bandageItemNum, nil, nil);
			elseif ((bandageRank > 0) and (BbandageRank == 0)) then
			EditMacro(GMBandage_MACRONAME, GMBandage_MACRONAME, "INV_Misc_QuestionMark", "#showtooltip\n/use "..FIRSTA.." [mod:alt,target=player] item:"..bandageItemNum.."; [] item:"..bandageItemNum, nil, nil);
			elseif (bandageRank == 0) then
			EditMacro(GMBandage_MACRONAME, GMBandage_MACRONAME, NoFIRSTA, "#showtooltip\n/use "..FIRSTA2, nil, nil);
			end
  
end

function GMBandage_NumFromLink(itemLink)
  if (not itemLink) then
    return nil;
  end
  local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
  return itemNumber;
end
