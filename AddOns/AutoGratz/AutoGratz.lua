------------------------
---		Modules	  ---
------------------------

AutoGratz  = LibStub("AceAddon-3.0"):NewAddon("AutoGratz", "AceConsole-3.0","AceEvent-3.0", "AceTimer-3.0")

----------------------------
--		Localization		--
----------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("AutoGratz")

----------------------------
--		  Options			--
----------------------------

local G = getfenv(0)

local main = {
	name = "Autogratz",
	type = "group",
	handler = AutoGratz,
	args = {
		confgendesc = {
			order = 1,
			type = "description",
			name = GetAddOnMetadata("AutoGratz", "Notes").."\n\n",
			cmdHidden = true
		},
		confinfodesc = {
			name = "",
			type = "group", inline = true,
			args = {
				confversiondesc = {
					order = 1,
					type = "description",
					name = "|cffffd700"..L["Version"]..": "
					..G["GREEN_FONT_COLOR_CODE"]..tostring(GetAddOnMetadata("AutoGratz", "Version")).."\n",
					cmdHidden = true
				},
				confauthordesc = {
					order = 2,
					type = "description",
					name = "|cffffd700"..L["Authors"]..": "
					..G["ORANGE_FONT_COLOR_CODE"]..GetAddOnMetadata("AutoGratz", "Author").."\n",
					cmdHidden = true
				},
				confcreditsdesc = {
					order = 3,
					type = "description",
					name = "|cffffd700"..L["Translators"]..": "
					..G["HIGHLIGHT_FONT_COLOR_CODE"]..GetAddOnMetadata("AutoGratz", "X-Translators").."\n",
					cmdHidden = true
				},
				confcatdesc = {
					order = 4,
					type = "description",
					name = "|cffffd700"..L["Category"]..": "
					..G["HIGHLIGHT_FONT_COLOR_CODE"]..GetAddOnMetadata("AutoGratz", "X-Category").."\n",
					cmdHidden = true
				},
				confwebsitedesc = {
					order = 6,
					type = "description",
					name = "|cffffd700"..L["Website"]..": "
					..G["HIGHLIGHT_FONT_COLOR_CODE"]..GetAddOnMetadata("AutoGratz", "X-Website").."\n",
					cmdHidden = true
				},
				conflicensedesc = {
					order = 7,
					type = "description",
					name = "|cffffd700"..L["License"]..": "
					..G["HIGHLIGHT_FONT_COLOR_CODE"]..GetAddOnMetadata("AutoGratz", "X-License").."\n",
					cmdHidden = true
				},
			}
		}
	},
}

local options1 = {
	name = L["Gratz Settings"],
	type = "group",
	handler = AutoGratz,
	get = function(item) return AutoGratz.db.profile[item[#item]] end,
	set = function(item, value) AutoGratz.db.profile[item[#item]] = value end,
	args = {
		AchieveMessage = {
			type = "input",
			name = L["Achieve Message Label"],
			desc = L["Achieve Message Desc"],
			usage = L["Achieve Message Usage"],
			order = 1,
			width = "full",
			get = "GetAchieveMessage",
			set = "SetAchieveMessage",
		},
		MultiAchieveMessage = {
			type = "input",
			name = L["MultiAchieve Message Label"],
			desc = L["MultiAchieve Message Desc"],
			usage = L["MultiAchieve Message Usage"],
			order = 2,
			width = "full",
			get = "GetMultiAchieveMessage",
			set = "SetMultiAchieveMessage",
		},
		Delay = {
			type = "range",
			name = L["Delay"],
			desc = L["Delay Desc"],
			order = 3,
			min = 1,
			max = 30,
			step = 1,
			set = "SetDelay",
		},
		Delay2 = {
			type = "range",
			name = L["Delay2"],
			desc = L["Delay2 Desc"],
			order = 3,
			min = 1,
			max = 30,
			step = 1,
			set = "SetDelay2",
		},
		spacer1 = {
			order = 4,
			type = "description",
			name = "\n",
		},
		RunOnAchieve = {
			type = "multiselect",
			name = L["Run On Achievement"],
			desc = L["Run On Achievement Desc"],
			values = {L["Guild"], L["Party"], L["Nearby"]},
			order = 5,
			width = "half",
			get = "GetRunOnAchieve",
			set = "SetRunOnAchieve",
		},
	},
}

local options2 = {
	name = L["Ding Settings"],
	type = "group",
	handler = AutoGratz,
	get = function(item) return AutoGratz.db.profile[item[#item]] end,
	set = function(item, value) AutoGratz.db.profile[item[#item]] = value end,
	args = {
		DingMessage = {
			type = "input",
			name = L["Ding Message Label"],
			desc = L["Ding Message Desc"],
			usage = L["Ding Message Usage"],
			order = 1,
			width = "full",
			get = "GetDingMessage",
			set = "SetDingMessage",
		},
		Delay3 = {
			type = "range",
			name = L["Delay"],
			desc = L["Delay Desc"],
			order = 2,
			min = 1,
			max = 30,
			step = 1,
		},
		SpamDelay = {
			type = "range",
			name = L["Spam Delay"],
			desc = L["Spam Delay Desc"],
			order = 2,
			min = 5,
			max = 120,
			step = 1,
		},
		spacer1 = {
			order	= 3,
			type	= "description",
			name	= "\n",
		},
		RunOnDing = {
			type = "multiselect",
			name = L["Run On Ding"],
			desc = L["Run On Ding Desc"],
			values = {L["Guild"], L["Party"], L["Whisper"], L["Raid"]},
			order = 4,
			width = "half",
			get = "GetRunOnDing",
			set = "SetRunOnDing",
		},
	},
}

local options3 = {
	name = L["Further Settings"],
	type = "group",
	handler = AutoGratz,
	get = function(item) return AutoGratz.db.profile[item[#item]] end,
	set = function(item, value) AutoGratz.db.profile[item[#item]] = value end,
	args = {
		Afk = {
			type = "toggle",
			name = L["Afk"],
			desc = L["Afk Desc"],
			order = 6,
			width = "normal",
		},
	},
}

local Defaults = {
	profile =  {
		Delay = 5,
		Delay2 = 8,
		Delay3 = 5,
		SpamDelay = 60,
		AchieveMessage = {L["Achieve Message"]},
		MultiAchieveMessage = {L["MultiAchieve Message"]},
		DingMessage = {L["Ding Message"]},
		RunOnAchieveTable = {Guild = false, Party = false, Nearby = false},
		RunOnDingTable = {Guild = false, Party = false, Whisper = false, Raid = false},
		Afk = false,
		LastDing = {}
	},
}

----------------------
---	 Commands	 ---
----------------------

local SlashOptions = {
	type = "group",
	handler = AutoGratz,
	args = {
		about = {
			type = "execute",
			name = L["about"],
			desc = L["about_desc"],
			func = function() InterfaceOptionsFrame_OpenToCategory(AutoGratz.optionFrames.main) end,
		},
		gratz = {
			type = "execute",
			name = L["gratz"],
			desc = L["gratz_desc"],
			func = function() InterfaceOptionsFrame_OpenToCategory(AutoGratz.optionFrames.options1) end,
		},
		ding = {
			type = "execute",
			name = L["ding"],
			desc = L["ding_desc"],
			func = function() InterfaceOptionsFrame_OpenToCategory(AutoGratz.optionFrames.options2) end,
		},
		other = {
			type = "execute",
			name = L["further"],
			desc = L["further_desc"],
			func = function() InterfaceOptionsFrame_OpenToCategory(AutoGratz.optionFrames.options3) end,
		},
		profiles = {
			type = "execute",
			name = L["profiles"],
			desc = L["profiles_desc"],
			func = function() InterfaceOptionsFrame_OpenToCategory(AutoGratz.optionFrames.profiles) end,
		},
	},
}

local SlashCmds = {
	"ag",
	"AutoGratz",
}

----------------------
---		Init		---
----------------------

function AutoGratz:OnInitialize()
	-- Load our database.
	self.db = LibStub("AceDB-3.0"):New("AutoGratz4DB", Defaults, "Default")
	
	if not self.db then
		self:Print("Error: Database not loaded correctly. Please exit out of WoW and delete the AG database file (AutoGratz.lua) found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\")
		return
	end
	
	-- Set up our config options.
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
	local config = LibStub("AceConfig-3.0")
	config:RegisterOptionsTable("AutoGratz", SlashOptions, SlashCmds)
	
	local registry = LibStub("AceConfigRegistry-3.0")
	registry:RegisterOptionsTable(L["about"], main)
	registry:RegisterOptionsTable(L["gratz"], options1)
	registry:RegisterOptionsTable(L["ding"], options2)
	registry:RegisterOptionsTable(L["further"], options3)
	registry:RegisterOptionsTable(L["profiles"], profiles)
	
	local dialog = LibStub("AceConfigDialog-3.0")
	self.optionFrames = {
		main = dialog:AddToBlizOptions(L["about"], "AutoGratz"),
		options1 = dialog:AddToBlizOptions(L["gratz"], L["gratz"], "AutoGratz"),
		options2 = dialog:AddToBlizOptions(L["ding"], L["ding"], "AutoGratz"),
		options3 = dialog:AddToBlizOptions(L["further"], L["further"], "AutoGratz"),
		profiles = dialog:AddToBlizOptions(L["profiles"], L["profiles"], "AutoGratz")
	}
	
	print(L["Loaded"])
end

function AutoGratz:OnEnable()
	-- Achievement-Events
	self:RegisterEvent("CHAT_MSG_ACHIEVEMENT", "HandleAchievement")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", "HandleAchievement")
	-- Ding-Events
	self:RegisterEvent("CHAT_MSG_WHISPER", "HandleDing")
	self:RegisterEvent("CHAT_MSG_GUILD", "HandleDing")
	self:RegisterEvent("CHAT_MSG_PARTY", "HandleDing")
end

--------------------------------
---		Event Handlers		---
--------------------------------

function AutoGratz:HandleAchievement(eventType, msg, sender)
	-- Declare what we'll be using as local, so it doesn't mess
	-- with another addon's global variables
	
	-- Whyever this is needed... It should do, what it should
	if self.db.profile.Delay == nil or self.db.profile.Delay == "" then self.db.profile.Delay = 5 end
	if self.db.profile.Delay2 == nil or self.db.profile.Delay2 == "" then self.db.profile.Delay2 = 5 end
	--
	
	local SendDelay = random(self.db.profile.Delay, self.db.profile.Delay2)
	--
	
	if sender ~= UnitName("player") and (self.db.profile.Afk or UnitIsAFK("player") == nil) then
		if eventType == "CHAT_MSG_ACHIEVEMENT" then
			-- Nearby
			if self.db.profile.RunOnAchieveTable[3] and UnitInParty(sender) == nil and UnitInRaid(sender) == nil then
				if self:CancelTimer(self.NearbyAchieveHandle, true) == true and AchieveNearbyLastName ~= sender then
					self.NearbyAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 2, "SAY"})
				else
					self.NearbyHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 1, "SAY"})
				end
				AchieveNearbyLastName = sender
			-- Party
			elseif self.db.profile.RunOnAchieveTable[2] and UnitInRaid(sender) == nil and UnitInParty(sender) == 1 then
				if self:CancelTimer(self.PartyAchieveHandle, true) == true and AchievePartyLastName ~= sender then
					self.PartyAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 2, "PARTY"})
				else
					self.PartyAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 1, "PARTY"})
				end
				AchievePartyLastName = sender
			-- Raid
			elseif self.db.profile.RunOnAchieveTable[2] and UnitInRaid(sender) == 1 then
				if self:CancelTimer(self.RaidAchieveHandle, true) == true and AchieveRaidLastName ~= sender then
					self.RaidAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 2, "RAID"})
				else
					self.RaidAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 1, "RAID"})
				end
				AchieveRaidLastName = sender
			end
		elseif eventType == "CHAT_MSG_GUILD_ACHIEVEMENT" then
			-- Guild
			if self.db.profile.RunOnAchieveTable[1] then
				if self:CancelTimer(self.GuildAchieveHandle, true) == true and AchieveGuildLastName ~= sender then
					self.GuildAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 2, "GUILD"})
				else
					self.GuildAchieveHandle = self:ScheduleTimer("SendAchieve", SendDelay, {sender, 1, "GUILD"})
				end
				AchieveGuildLastName = sender
			end
		else
			return
		end
	end
end

function AutoGratz:HandleDing(eventType, msg, sender)
	-- Declare what we'll be using as local, so it doesn't mess
	-- with another addon's global variables
	local DingAnswer = time()-self.db.profile.SpamDelay
	
	-- Whyever this is needed... It should do, what it should
	if self.db.profile.Delay3 == nil or self.db.profile.Delay3 == "" then self.db.profile.Delay3 = 60 end	
	--
	
	if sender ~= UnitName("player") and (self.db.profile.Afk or UnitIsAFK("player") == nil) then
		if string.find(string.lower(msg),"%f[%a]ding%f[%A]") ~= nil then
			if self.db.profile.LastDing[sender] == nil or self.db.profile.LastDing[sender] <= DingAnswer then
				-- Guild
				if eventType == "CHAT_MSG_GUILD" and self.db.profile.RunOnDingTable[1] then
					if DingGuildLastName ~= sender then
						self:ScheduleTimer("SendDing", self.db.profile.Delay3, {sender, "GUILD"})
					end
					DingGuildLastName = sender
				-- Party
				elseif eventType == "CHAT_MSG_PARTY" and self.db.profile.RunOnDingTable[2] and UnitInRaid(sender) == nil and UnitInParty(sender) == 1 then
					if DingPartyLastName ~= sender then
						self:ScheduleTimer("SendDing", self.db.profile.Delay3, {sender, "PARTY"})
					end
					DingPartyLastName = sender
				-- Whisper
				elseif eventType == "CHAT_MSG_WHISPER" and self.db.profile.RunOnDingTable[3] then
					if DingWhisperLastname ~= sender then
						self:ScheduleTimer("SendDing", self.db.profile.Delay3, {sender, "WHISPER"})
					end
					DingWhisperLastname = sender
				-- Raid
				elseif eventType == "CHAT_MSG_RAID" and self.db.profile.RunOnDingTable[4] and UnitInRaid(sender) == 1 then
					if DingRaidLastName ~= sender then
						self:ScheduleTimer("SendDing", self.db.profile.Delay3, {sender, "RAID"})
					end
					DingRaidLastName = sender
				else
					return
				end
			end
			self.db.profile.LastDing[sender] = time()
		end
	end
end

---------------------------
---		Functions		---
---------------------------

function AutoGratz:SendAchieve(Table)
	-- Cross-Server
	-- Remove Realm, if exists
	sender = { strsplit("-", Table[1]) }
	self.sender = sender[1]
	--
	
	self.message = string.gsub(self.db.profile.AchieveMessage[random(1,#(self.db.profile.AchieveMessage))], "#n", self.sender)
	self.message2 = self.db.profile.MultiAchieveMessage[random(1,#(self.db.profile.MultiAchieveMessage))]
	
	if Table[2] == 1 then
		SendChatMessage(self.message, Table[3], nil)
	else
		SendChatMessage(self.message2, Table[3], nil)
	end
end

function AutoGratz:SendDing(Table)
	-- Cross-Server
	-- Remove Realm, if exists
	sender = { strsplit("-", Table[1]) }
	self.sender = sender[1]
	--

	self.message = string.gsub(self.db.profile.DingMessage[random(1,#(self.db.profile.DingMessage))], "#n", self.sender)
	
	if Table[2] == "WHISPER" then
		SendChatMessage(self.message, Table[2], nil, Table[1])
	else
		SendChatMessage(self.message, Table[2], nil)
	end
end

---------------------------
---	  Subfunctions	 ---
---------------------------

-- Delay & Sending functions
function AutoGratz:SetDelay(info, newValue)
	if newValue > self.db.profile.Delay2 then
		self.db.profile.Delay2 = self.db.profile.Delay
	end
	self.db.profile.Delay = newValue
end

function AutoGratz:SetDelay2(info, newValue)
	if newValue < self.db.profile.Delay then
		self.db.profile.Delay2 = self.db.profile.Delay
	else
		self.db.profile.Delay2 = newValue
	end
end

function AutoGratz:SetRunOnAchieve(info, Key, newValue)
	self.db.profile.RunOnAchieveTable[Key] = newValue
end

function AutoGratz:GetRunOnAchieve(info, Key)
	return self.db.profile.RunOnAchieveTable[Key]
end

function AutoGratz:SetRunOnDing(info, Key, newValue)
	self.db.profile.RunOnDingTable[Key] = newValue
end

function AutoGratz:GetRunOnDing(info, Key)
	return self.db.profile.RunOnDingTable[Key]
end

-- AchieveMessage functions
function AutoGratz:GetAchieveMessage(info)
	self.string = ""
	for index,value in ipairs(self.db.profile.AchieveMessage) do
		self.string = self.string..value..";"
	end
	return self.string
end

function AutoGratz:SetAchieveMessage(info, newValue)
	self.db.profile.AchieveMessage = { strsplit(";", newValue) }
end

-- MultiAchieveMessage functions
function AutoGratz:GetMultiAchieveMessage(info)
	self.string = ""
	for index,value in ipairs(self.db.profile.MultiAchieveMessage) do
		self.string = self.string..value..";"
	end
	return self.string
end

function AutoGratz:SetMultiAchieveMessage(info, newValue)
	self.db.profile.MultiAchieveMessage = { strsplit(";", newValue) }
end

-- DingMessage functions
function AutoGratz:GetDingMessage(info)
	self.string = ""
	for index,value in ipairs(self.db.profile.DingMessage) do
		self.string = self.string..value..";"
	end
	return self.string
end

function AutoGratz:SetDingMessage(info, newValue)
	self.db.profile.DingMessage = { strsplit(";", newValue) }
end