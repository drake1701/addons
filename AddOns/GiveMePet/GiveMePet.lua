--[[
        Give Me Pet:
                Copyright 2009 by MERK, Mileg
				Updated by Grimgrin
                based on code by Mileg and Stephen Blaising

]]        

GMPet_ADDONNAME = "Give Me Pet";
GMPet_MACRONAME = "GMPet";

GMPet_VERSION = "4.4.7";

local hasSnow = false;
local PetRandNum = 0;
PetIcon = 465;

function GMPet_OnLoad()

  SlashCmdList["GMPETCOMMAND"] = GMPet_SlashHandler;
  SLASH_GMPETCOMMAND1 = "/givemepet";
  SLASH_GMPETCOMMAND2 = "/gmpet";
  SLASH_GMPETCOMMAND3 = "/gmp";

end

function GMPet_OnEvent(event)
  if (event == "PLAYER_LOGIN") then
    if (GetMacroIndexByName(GMPet_MACRONAME) == 0 ) then
            CreateMacro(GMPet_MACRONAME,PetIcon,"",nil,nil);
    end
    GMPet_Go();
  end
end

function GMPet_SlashHandler(msg)
  if (msg) then
    msg = string.lower(msg);
  end
  if (msg == "help" or msg == "") then
    GMPet_Print(GMPet_ADDONNAME.." |cff3399CCv"..GMPet_VERSION.." ");
    GMPet_Print("Type /macro to open macro list.");
    GMPet_Print("Drag GMPet macro to your action bar.");
    GMPet_Print("Left click to call random companion.");
    GMPet_Print("Right click to dismiss companion.");
  elseif (msg == "update") then
    GMPet_Go();
  end
end

function GMPet_Print(msg) 
  if ((msg) and (strlen(msg) > 0)) then
    if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
    end
  end
end

function GMPet_Go()
  local PETcnt = GetNumCompanions("CRITTER");
 
  if (PETcnt > 0) then
    local LastPetRandNum = PetRandNum;
    PetRandNum = math.random(1,PETcnt);
    local _, petName = GetCompanionInfo("CRITTER",PetRandNum);
    for bagID = 0, 4, 1 do
      local bagSlotCnt = GetContainerNumSlots(bagID);
      if (bagSlotCnt > 0) then
        for slot = 1, bagSlotCnt, 1 do
          local itemLink = GetContainerItemLink(bagID, slot);
          local itemNumber = GMPet_NumFromLink(itemLink);
          if (itemNumber == "17202") then
            hasSnow = true;
          else
            hasSnow = false;
          end
        end
      end
    end
    if ((not hasSnow) and ((petName == FATHWINT) or (petName == TINYSNOW) or (petName == WINTHELP) or (petName == WINTREIN))) or (LastPetRandNum == PetRandNum) then
      GMPet_Go();
    else
      EditMacro("GMPet","GMPet",PetIcon,"/run DismissCompanion(\"CRITTER\")\n/stopmacro [button:2]\n/run CallCompanion(\"CRITTER\","..PetRandNum..")\n/gmp update ",nil,nil);
    end
  end
end

function GMPet_NumFromLink(itemLink)
  if (not itemLink) then
    return nil;
  end
  local _, _, itemNumber = strfind(itemLink, "item:(%d+):");
  return itemNumber;
end
