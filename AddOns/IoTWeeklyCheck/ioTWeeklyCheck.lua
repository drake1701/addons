-- Isle of Thunder Weekly Check
-- by Fluffies
-- EU-Well of Eternity
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbicon = ldb and LibStub("LibDBIcon-1.0", true)
local IoTMainframe

local iotwiicon = "Interface\\ICONS\\inv_qiraj_jewelglyphed"
local tx_optionsframe = "Interface\\icons\\Icon_PetFamily_Mechanical"
local tx_chkminimap   = "Interface\\icons\\INV_Misc_Map03"

local keylink -- Key to the Palace of Lei Shen - item
local ritualstone_name
local deng_itemname
local haqin_itemname
local vu_itemname
local rare_name = EXAMPLE_TARGET_MONSTER.." ("..ITEM_QUALITY3_DESC..")"
local s_optionsmain = "Toggle minimap button"

-- string colors
local LIGHT_RED   = "|cffFF2020"
local LIGHT_GREEN = "|cff20FF20"
local LIGHT_BLUE  = "|cff00ddFF"
local ZONE_BLUE   = "|cff00aacc"
local GREY        = "|cff999999"
local COORD_GREY  = "|cffBBBBBB"
local GOLD        = "|cffffcc00"
local WHITE       = "|cffffffff"
local PINK        = "|cffFFaaaa"
local function AddColor(str,color)
 return color..str.."|r"
end

local function completedstring(arg)
 if IsQuestFlaggedCompleted(arg) then
  return AddColor(COMPLETE,LIGHT_GREEN)
 else
  return AddColor(INCOMPLETE,LIGHT_RED)
 end
end

local function getitemname(arg)
 if arg ~= nil then 
  return arg
 else
  return ""
 end
end

local function DrawMainframe(frame, istooltip)
-- title
 frame:ClearLines()
 frame:AddDoubleLine("Isle of Thunder Weekly Check","|T"..iotwiicon..":32|t")
 frame:AddLine(" ")
 frame:AddLine(" ")

 frame:AddDoubleLine(getitemname(keylink), completedstring(32626))
 frame:AddLine(" ")
 frame:AddLine(getitemname(ritualstone_name)..":")
 frame:AddDoubleLine(" - "..AddColor(rare_name,WHITE), completedstring(32610))
 frame:AddDoubleLine(" - "..AddColor(select(8,GetAchievementInfo(8104)),WHITE), completedstring(32609))
 frame:AddLine(" ")
 frame:AddLine(AddColor(select(2,GetAchievementInfo(8110))..":", GOLD))
 frame:AddLine(" - "..getitemname(deng_itemname))
 frame:AddDoubleLine(" - "..getitemname(haqin_itemname), completedstring(32611))
 frame:AddLine(" - "..getitemname(vu_itemname))
 frame:AddLine(" ")
 frame:AddDoubleLine(AddColor(GetAchievementCriteriaInfo(8105,1),WHITE), completedstring(32505))
 if not istooltip then
  frame:AddLine(" ")
  frame:AddLine(" ")
  --frame:AddLine(" ")
 end
end

local iwcchatheader = AddColor("IoT Weekly Check: ",LIGHT_BLUE)
local chatseparator = " - "

local function CreateMainframe(arg)

 if arg == "print" then
  print("--- "..iwcchatheader.."---")
  print(getitemname(keylink)..chatseparator..completedstring(32626))
  print(getitemname(ritualstone_name)..chatseparator..AddColor(rare_name,GREY)..chatseparator..completedstring(32610))
  print(getitemname(ritualstone_name)..chatseparator..AddColor(select(8,GetAchievementInfo(8104)),GREY)..chatseparator..completedstring(32609))
  print(AddColor(select(2,GetAchievementInfo(8110))..":", GREY)..chatseparator..completedstring(32611))
  print(AddColor(GetAchievementCriteriaInfo(8105,1),GREY)..chatseparator..completedstring(32505)) 
  print("---------")
  return
 end

 if IoTMainframe and IoTMainframe:IsVisible() then
  IoTMainframe:Hide()
 else
  if not IoTMainframe then
   IoTMainframe = CreateFrame("GameTooltip", "IoTMainframe", nil, "GameTooltipTemplate")
  end
  
  IoTMainframe:SetOwner(UIParent,"ANCHOR_NONE")
  IoTMainframe:SetPoint("CENTER",UIParent,"CENTER")
  IoTMainframe:SetFrameStrata("HIGH")
  IoTMainframe:EnableMouse(true)
  IoTMainframe:SetMovable()
  IoTMainframe:SetScale(0.9)
  IoTMainframe:RegisterForDrag("LeftButton")
  IoTMainframe:SetScript("OnDragStart", function(self)  
		self:StartMoving()
  end)
  IoTMainframe:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing()
  end)
  
  DrawMainframe(IoTMainframe)

-- Hide minimap button
   if not IoTMainframe.optionsframe then
    IoTMainframe.optionsframe = CreateFrame("FRAME", nil, IoTMainframe)
    IoTMainframe.optionsframe.texture = IoTMainframe.optionsframe:CreateTexture()
    IoTMainframe.optionsframe:SetPoint("BOTTOMLEFT",IoTMainframe,"BOTTOMLEFT",10,10)
    IoTMainframe.optionsframe:SetWidth(25)
    IoTMainframe.optionsframe:SetHeight(25)
    IoTMainframe.optionsframe.texture:SetPoint("CENTER",IoTMainframe.optionsframe,"CENTER")
    IoTMainframe.optionsframe.texture:SetAllPoints()
    IoTMainframe.optionsframe.texture:SetTexture(tx_chkminimap)
    IoTMainframe.optionsframe:SetScript("OnLeave", function(self)
     GameTooltip:Hide()
    end)
    IoTMainframe.optionsframe:SetScript("OnEnter", function(self)
     GameTooltip:SetOwner(IoTMainframe.optionsframe,"ANCHOR_TOP",0,5)
     GameTooltip:ClearLines()
     GameTooltip:AddLine(s_optionsmain)
     GameTooltip:Show()
    end)

    IoTMainframe.optionsframe:SetScript("OnMouseUp", function(self)
     if not IoTMainframe.optionsframe.open then
      IoTWeeklyItems_Options["minimap_icon"].hide = false
      IoTMainframe.optionsframe.open = true
      IoTMainframe.optionsframe.texture:SetVertexColor(1,1,1,1)
     else
      IoTWeeklyItems_Options["minimap_icon"].hide = true
      IoTMainframe.optionsframe.open = false
      IoTMainframe.optionsframe.texture:SetVertexColor(0.5,0.5,0.5,1)
     end
     ldbicon:Refresh("IoTWeeklyCheck", IoTWeeklyCheck, IoTWeeklyItems_Options["minimap_icon"])
    end)
   end
   IoTMainframe.optionsframe.open = not IoTWeeklyItems_Options["minimap_icon"].hide
   if IoTMainframe.optionsframe.open then
    IoTMainframe.optionsframe.texture:SetVertexColor(1,1,1,1)
   else
    IoTMainframe.optionsframe.texture:SetVertexColor(0.5,0.5,0.5,1)    
   end
--
-- About
  if not IoTMainframe.Rabouttext then
   IoTMainframe.Rabouttext = IoTMainframe:CreateFontString(nil, "OVERLAY", "GameTooltipText")
   IoTMainframe.Rabouttext:SetFont("Fonts\\FRIZQT__.TTF",8)
   IoTMainframe.Rabouttext:SetText(AddColor("                by",GREY)..
                                   AddColor(" Fluffies\n",LIGHT_BLUE)..
                                   AddColor(" EU-Well of Eternity",GREY))
   IoTMainframe.Rabouttext:SetPoint("BOTTOMRIGHT",IoTMainframe,"BOTTOMRIGHT",-5,5)
   IoTMainframe.Rabouttext:Show()
  end
--
-- Close button
  if not IoTMainframe.btnclose then
   IoTMainframe.btnclose = CreateFrame("Button", "iotwiclosebtn", IoTMainframe, "UIPanelButtonTemplate")
   IoTMainframe.btnclose:SetPoint("BOTTOM", IoTMainframe, "BOTTOM",0,10)
   IoTMainframe.btnclose:SetWidth(100)
   IoTMainframe.btnclose:SetText(CLOSE)
   IoTMainframe.btnclose:SetScript("OnClick", function(self)
    IoTMainframe:Hide()
    collectgarbage()
   end)
 end
--
 IoTMainframe:Show()
end
end

local ldbset = false
local eventframe = CreateFrame("FRAME","IoTWIEventFrame")
eventframe:RegisterEvent("VARIABLES_LOADED")
eventframe:RegisterEvent("GET_ITEM_INFO_RECEIVED")
local function eventhandler(self, event, ...)

 if event == "GET_ITEM_INFO_RECEIVED" then
  if keylink == nil then
   _, keylink = GetItemInfo(94222)
  end
  if ritualstone_name == nil then
   _, ritualstone_name = GetItemInfo(94221)
  end
  if deng_itemname == nil then
    _, deng_itemname = GetItemInfo(94233)
  end
  if vu_itemname == nil then
    _, vu_itemname = GetItemInfo(95350)
  end
  if haqin_itemname == nil then
    _, haqin_itemname = GetItemInfo(94130)
  end
 elseif event == "VARIABLES_LOADED" then
  _, keylink = GetItemInfo(94222)
  _, ritualstone_name = GetItemInfo(94221)
  _, deng_itemname = GetItemInfo(94233)
  _, haqin_itemname = GetItemInfo(94130)
  _, vu_itemname = GetItemInfo(95350)
  if IoTWeeklyItems_Options == nil then
   IoTWeeklyItems_Options = {}
  end
  if IoTWeeklyItems_Options["minimap_icon"] == nil then
    IoTWeeklyItems_Options["minimap_icon"] = {
        hide = false,
        minimapPos = 220,
    }
  end

  if ldb and not ldbset then
   local IoTWeeklyCheck = ldb:NewDataObject("IoTWeeklyCheck", {
	type = "data source",
	icon = iotwiicon,
	label = "IoT Weekly Check",
	OnClick = function(self,button)
         CreateMainframe()
	end,
	OnTooltipShow = function(tooltip)
		 DrawMainframe(tooltip,true)
	end,
   })
   if ldbicon then
    ldbicon:Register("IoTWeeklyCheck", IoTWeeklyCheck, IoTWeeklyItems_Options["minimap_icon"])
   end
   ldbset = true
  end -- variables_loaded
 end
end
eventframe:SetScript("OnEvent", eventhandler);

-- slash command
SLASH_IOTWEEKLYCHECK1 = "/iwc"
SlashCmdList["IOTWEEKLYCHECK"] = CreateMainframe