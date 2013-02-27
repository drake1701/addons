Recompense = Recompense or {}

function Recompense.RecycleTable(table) -- empty a table by setting its keys to nil
	for k in pairs(table) do
		table[k] = nil
	end
end

function Recompense.ShowTableContents(table) -- debug function to dump a table, not very sophisticated and doesn't handle nested tables well
	for k, v in pairs(table) do
		if type(v) ~= "table" then
			print(format("Key '%s' has value '%s'.", k, v))
		else
			print(format("Key '%s' has a table value.", k))
			--[[for subKey, subValue in pairs(v) do
				print(format("Table in '%s':  Key '%s' has value '%s'.", k, subKey, tostring(subValue)))
			end]]
		end
	end
end

function Recompense.CheckBuffsAgainstTable(table) -- given a table of buff names, returns the name of a buff if it is present on the player.  If none of the buffs on the table are present on the player, it returns nil.
	local buffs, name, buffMatched = 0
	repeat
		buffs = buffs + 1
		name = UnitBuff("player", buffs)
		for _, v in pairs(table) do
			if name == v then
				buffMatched = name
				break
			end
		end
		if buffMatched then
			break
		end
	until not name
	return buffMatched
end

function Recompense.CheckEquipmentAgainstTable(table) -- given a table of item names, returns the name of the first item in the table that is currently equipped.
	local equippedItem
	for _, v in pairs(table) do
		if IsEquippedItem(v) then
			equippedItem = v
			break
		end
	end
	return equippedItem
end

function Recompense.CheckStringAgainstTable(inputString, table) -- given a string and a table, check to see if the provided string is contained in the table of strings
	local matchedString
	for _, v in pairs(table) do
		if inputString == v then
			matchedString = inputString
			break
		end
	return matchedString
	end
end

function Recompense.CreateButtonAndText(buttonName, parent, xOffset, yOffset, stringName)
	local button = CreateFrame("CheckButton", buttonName, parent, "UICheckButtonTemplate")
	button:SetHeight(20)
	button:SetWidth(20)
	button:SetPoint("TOPLEFT", xOffset, yOffset)
	
	if _G[buttonName.."Text"] then
		_G[buttonName.."Text"] = nil
	end
	
	local text = parent:CreateFontString(stringName, "OVERLAY", "ChatFontSmall")
	text:SetPoint("TOPLEFT", ( xOffset + 24 ), ( yOffset - 2 ) )
	
	button.text = text
	
	return button, text
end

function Recompense.TransitionFromInterfaceOptionsToFrame(frame)
	InterfaceOptionsFrameOkay_OnClick()
	HideUIPanel(GameMenuFrame)
	frame:Show()
end