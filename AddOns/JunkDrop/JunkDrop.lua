﻿-- JunkDrop.lua
-- by: desertdwarf
-- Version: v0.8
-- Released: 2012-09-11T03:27:01Z

function JunkDrop(SlashArg)
  local EmergencyBreak = 9999 -- Prevent run-away train situation.
  local ItemLinkLowest
  local ItemLinkLowestBag
  local ItemLinkLowestSlot
  local ItemCountLowest
  local ItemLink
  local ItemLinkBag
  local ItemLinkSlot
  local ItemCount
  local CommandLine = {}
  local SlashArgValue
  local DebugOn = false
  local DropAll = false
  local CountToDrop
  local index
  local argument
  local bag
  local slot

  if SlashArg then

  for SlashArgValue in string.gmatch(SlashArg, "[^ ]+") do
    tinsert(CommandLine, SlashArgValue)
  end

--    ChatFrame1:AddMessage("JunkDrop: SlashArg - " .. SlashArg, .69, .49, 1.0)
    for index,argument in pairs(CommandLine) do
--      ChatFrame1:AddMessage("JunkDrop: SlashArg Loop @ " .. index .. ": " .. argument, .69, .49, 1.0)
      if argument == "debug" then
        DebugOn = true
      elseif argument == "all" then
        DropAll = true
      elseif string.len(argument) then
        CountToDrop = tonumber(argument)
        if CountToDrop ~= nil then
          ChatFrame1:AddMessage("JunkDrop: When this option works, I'll throw away " .. CountToDrop .. " items.", .69, .49, 1.0)
        else
          if string.len(argument) > 0 then
            ChatFrame1:AddMessage("JunkDrop: Command usage is /junkdrop [all] [debug] [#] -- where # is how many items to drop (not yet implemented). Found '" .. argument .. "'.", .69, .49, 1.0)
          end
        end
      end
    end
  end

  if DebugOn and DropAll then
    ChatFrame1:AddMessage("JunkDrop: Dropping all junk items!", .69, .49, 1.0)
  end

  for bag = 0,4 do -- for bags loop
    for slot = 1,GetContainerNumSlots(bag) do -- for slots loop
      ItemLink = GetContainerItemLink(bag, slot)
      if ItemLink and select(3, GetItemInfo(ItemLink)) == 0 then -- is grey?
        if DropAll then -- if all?
          if DebugOn then -- if debug?
            ChatFrame1:AddMessage("JunkDrop: Dropping " .. ItemLink .. ".", .69, .49, 1.0)
          end -- if debug?
          PickupContainerItem(bag, slot)
          DeleteCursorItem()
        else -- if all?
          ItemCount = select(2, GetContainerItemInfo(bag, slot))
          if ItemLinkLowest then -- if lowest price item exists?
            if (select(11, GetItemInfo(ItemLink)) * ItemCount) < (select(11, GetItemInfo(ItemLinkLowest)) * ItemCountLowest) then -- if new item is lower price?
              if DebugOn then -- if debug?
                ChatFrame1:AddMessage("JunkDrop: " .. ItemLinkLowest .. " x " .. ItemCountLowest .. " @ " .. select(11, GetItemInfo(ItemLinkLowest)) * ItemCountLowest .. " > " .. ItemLink .. " x " .. ItemCount .. " @ " .. select(11, GetItemInfo(ItemLink)) * ItemCount .. ".", .69, .49, 1.0)
              end -- if debug?
              ItemLinkLowest = ItemLink
              ItemLinkLowestBag = bag
              ItemLinkLowestSlot = slot
              ItemCountLowest = ItemCount
            end -- if new item is lower?
          else -- if lowest price item exists?
              if DebugOn then -- if debug?
                ChatFrame1:AddMessage("JunkDrop: ---", .69, .49, 1.0)
                ChatFrame1:AddMessage("JunkDrop: We found our first junk item: " .. ItemLink .. " x " .. ItemCount .. " @ " .. select(11, GetItemInfo(ItemLink)) * ItemCount .. ".", .69, .49, 1.0)
              end -- if debug?
              ItemLinkLowest = ItemLink
              ItemLinkLowestBag = bag
              ItemLinkLowestSlot = slot
              ItemCountLowest = ItemCount
          end -- if lowest price item exists?
        end -- if all?
        EmergencyBreak = EmergencyBreak - 1
        if EmergencyBreak == 0 then -- if emergencybreak for slots loop
          ChatFrame1:AddMessage("JunkDrop: Emergency break applied. (Pun intended.) Report this to DesertDwarf on CurseForge.com on the JunkDrop addon page.", .69, .49, 1.0)
          break
        end -- if emergencybreak for slots loop
      end -- if grey
    end -- for slots loop
    if EmergencyBreak == 0 then -- if emergencybreak for bags loop
      ChatFrame1:AddMessage("JunkDrop: Emergency break applied. (Pun intended.) Report this to DesertDwarf on CurseForge.com on the JunkDrop addon page.", .69, .49, 1.0)
      break
    end -- if emergencybreak for bags loop
  end -- for bags loop
  
  if ItemLinkLowest and not DropAll then
    if DebugOn then
      ChatFrame1:AddMessage("JunkDrop: Dropping " .. ItemLinkLowest .. " x " .. ItemCountLowest .. " @ " .. select(11, GetItemInfo(ItemLinkLowest)) * ItemCountLowest .. ".", .69, .49, 1.0)
    end
    PickupContainerItem(ItemLinkLowestBag, ItemLinkLowestSlot)
    DeleteCursorItem()
  else
    if DebugOn then
      if DropAll then
        ChatFrame1:AddMessage("JunkDrop: Done!", .69, .49, 1.0)
      else
        ChatFrame1:AddMessage("JunkDrop: We didn't find any junk.", .69, .49, 1.0)
      end
    end
  end
end

SLASH_JUNKDROP1, SLASH_JUNKDROP2 = '/junkdrop', '/jd';
SlashCmdList["JUNKDROP"] = JunkDrop;
