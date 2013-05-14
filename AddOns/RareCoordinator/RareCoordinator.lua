
RCDB = { }

local function onDragStart(self) self:StartMoving() end

local function onDragStop(self)
	self:StopMovingOrSizing()
	RCDB.x = self:GetLeft()
	RCDB.y = self:GetTop()
end

local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end

local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end

local function onResize(self, width, height)
	height = width/3*2
	RCDB.width = width
	RCDB.height = height
	self:SetHeight(height)
	
	local scale = width/300
	
	
	if self.left ~= nil then 
		self.left:SetPoint("TOPLEFT", self, 4*scale, -5*scale)
		self.left:SetHeight(height-9*scale)
		self.left:SetWidth(width/20*12)
		if self.left.text ~= nil then
			local i
			for i=0,table.getn(self.left.text) do
				self.left.text[i]:SetPoint("TOP", "RC.left", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
		if self.left.icon ~= nil then
			local i
			for i=0,table.getn(self.left.icon) do
				if i == 0 then
					self.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", 6*scale, -3*scale)
					self.left.icon[i]:SetWidth(20*scale)
					self.left.icon[i]:SetHeight(20*scale)
				else
					self.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", -3*scale, (-2 + -15.5*i)*scale)
					self.left.icon[i]:SetWidth(10*scale)
					self.left.icon[i]:SetHeight(10*scale)
				end
			end
		end
		
	end
	if self.mid ~= nil then
		self.mid:SetHeight(height-9*scale)
		self.mid:SetWidth(width/20*4-6*scale)
		self.mid:SetPoint("TOPLEFT", self.left, "TOPRIGHT", 2*scale, 0)
		if self.mid.text ~= nil then
			local i
			for i=0,table.getn(self.mid.text) do
				self.mid.text[i]:SetPoint("TOP", "RC.mid", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
		if self.mid.button ~= nil then
			local i
			for i=0,table.getn(self.mid.button) do
				self.mid.button[i]:SetPoint("TOPLEFT", "RC.mid", 0, -2-(15.5*i)*scale)
				self.mid.button[i]:SetHeight(13*scale)
				self.mid.button[i]:SetWidth(self.mid:GetWidth())
				self.mid.button[i].icon:SetWidth(10*scale)
				self.mid.button[i].icon:SetHeight(10*scale)
			end
		end
	end
	if self.right ~= nil then 
		self.right:SetHeight(height-9*scale) 
		self.right:SetWidth(width/20*4-6*scale)
		self.right:SetPoint("TOPLEFT", self.mid, "TOPRIGHT", 2*scale, 0)
		if self.right.text ~= nil then
			local i
			for i=0,table.getn(self.right.text) do
				self.right.text[i]:SetPoint("TOP", "RC.right", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
	end
end

--------------------------------

local locked = true
local RareIDs = {
	50358, -- Haywire Sunreaver Construct
	69664, -- Mumta
	69996, -- Ku'lai Skyclaw
	69997, -- Progenitus
	69998, -- Goda
	69999, -- God-Hulk Ramuk
	70000, -- Al'tabim the All-Seeing
	70001, -- Backbreaker Uru
	70002, -- Lu-Ban
	70003, -- Molthor
	70530, -- Ra'sha
	--69384  -- Luminescent Crawler - FOR TESTING ONLY
}
local RareCoords = {
	"~48/88", -- Haywire Sunreaver Construct
	"35/63 (on top)", -- Mumta
	"~38/83", -- Ku'lai Skyclaw
	"51/71 (on top)", -- Progenitus
	"54/53", -- Goda
	"62/50", -- God-Hulk Ramuk
	"45/30", -- Al'tabim the All-Seeing
	"~48/25 (in the mine)", -- Backbreaker Uru
	"54/36", -- Lu-Ban
	"63/49", -- Molthor
	"39/81", -- Ra'sha
}
local RareCoordsRaw = {
	{x=48.5, y=88.5}, -- Haywire Sunreaver Construct
	{x=35.1, y=62.4}, -- Mumta
	{x=35.9, y=82.1}, -- Ku'lai Skyclaw
	{x=51.2, y=71.3}, -- Progenitus
	{x=53.7, y=53.1}, -- Goda
	{x=61.5, y=49.5}, -- God-Hulk Ramuk
	{x=44.8, y=30.1}, -- Al'tabim the All-Seeing
	{x=40.5, y=27.5}, -- Backbreaker Uru
	{x=54.4, y=35.7}, -- Lu-Ban
	{x=63.4, y=49.3}, -- Molthor
	{x=39.5, y=81.2}, -- Ra'sha
}
local RareNamesLocalized = {};
RareNamesLocalized['enUS'] = {}
RareNamesLocalized['enUS'][50358] = "Haywire Sunreaver Construct"
RareNamesLocalized['enUS'][69664] = "Mumta"
RareNamesLocalized['enUS'][69996] = "Ku'lai the Skyclaw"
RareNamesLocalized['enUS'][69997] = "Progenitus"
RareNamesLocalized['enUS'][69998] = "Goda"
RareNamesLocalized['enUS'][69999] = "God-Hulk Ramuk"
RareNamesLocalized['enUS'][70000] = "Al'tabim the All-Seeing"
RareNamesLocalized['enUS'][70001] = "Backbreaker Uru"
RareNamesLocalized['enUS'][70002] = "Lu-Ban"
RareNamesLocalized['enUS'][70003] = "Molthor"
RareNamesLocalized['enUS'][70530] = "Ra'sha"
--RareNamesLocalized['enUS'][69384] = "Luminescent Crawler"
RareNamesLocalized['deDE'] = {}
RareNamesLocalized['deDE'][50358] = "Konstrukt der Sonnenhäscher"
RareNamesLocalized['deDE'][69664] = "Mumta"
RareNamesLocalized['deDE'][69996] = "Ku'lai die Himmelsklaue"
RareNamesLocalized['deDE'][69997] = "Progenitus"
RareNamesLocalized['deDE'][69998] = "Goda"
RareNamesLocalized['deDE'][69999] = "Gottkoloss Ramuk"
RareNamesLocalized['deDE'][70000] = "Al'tabim der Allsehende"
RareNamesLocalized['deDE'][70001] = "Rückenbrecher Uru"
RareNamesLocalized['deDE'][70002] = "Lu-Ban"
RareNamesLocalized['deDE'][70003] = "Molthor"
RareNamesLocalized['deDE'][70530] = "Ra'sha"
RareNamesLocalized['esES'] = {}
RareNamesLocalized['esES'][50358] = "Atracasol descontrolado"
RareNamesLocalized['esES'][69664] = "Mumta"
RareNamesLocalized['esES'][69996] = "Ku'lai el Garracielo"
RareNamesLocalized['esES'][69997] = "Progenitus"
RareNamesLocalized['esES'][69998] = "Goda"
RareNamesLocalized['esES'][69999] = "Dios mole Ramuk"
RareNamesLocalized['esES'][70000] = "Al'tabim"
RareNamesLocalized['esES'][70001] = "Backbreaker Uru" -- need translation
RareNamesLocalized['esES'][70002] = "Lu-Ban" -- need translation
RareNamesLocalized['esES'][70003] = "Molthor" -- need translation
RareNamesLocalized['esES'][70530] = "Ra'sha" -- need translation
RareNamesLocalized['frFR'] = {}
RareNamesLocalized['frFR'][50358] = "Saccage-soleil détraqué"
RareNamesLocalized['frFR'][69664] = "Mumta"
RareNamesLocalized['frFR'][69996] = "Ku’lai, la Griffe du ciel"
RareNamesLocalized['frFR'][69997] = "Progénitus"
RareNamesLocalized['frFR'][69998] = "Goda"
RareNamesLocalized['frFR'][69999] = "Dieu-mastodonte Ramuk"
RareNamesLocalized['frFR'][70000] = "Al’tabim Qui-Voit-Tout"
RareNamesLocalized['frFR'][70001] = "Backbreaker Uru" -- need translation
RareNamesLocalized['frFR'][70002] = "Lu-Ban" -- need translation
RareNamesLocalized['frFR'][70003] = "Molthor" -- need translation
RareNamesLocalized['frFR'][70530] = "Ra'sha" -- need translation
RareNamesLocalized['zhTW'] = {}
RareNamesLocalized['zhTW'][50358] = "故障的奪日者傀儡"
RareNamesLocalized['zhTW'][69664] = "孟塔"
RareNamesLocalized['zhTW'][69996] = "『天爪』庫賴"
RareNamesLocalized['zhTW'][69997] = "普羅堅尼斯"
RareNamesLocalized['zhTW'][69998] = "戈達"
RareNamesLocalized['zhTW'][69999] = "弒神巨人拉穆克"
RareNamesLocalized['zhTW'][70000] = "『全知者』阿塔比姆"
RareNamesLocalized['zhTW'][70001] = "斷脊者兀魯"
RareNamesLocalized['zhTW'][70002] = "魯班"
RareNamesLocalized['zhTW'][70003] = "莫托爾"
RareNamesLocalized['zhTW'][70530] = "拉沙"
RareNamesLocalized['zhCN'] = {}
RareNamesLocalized['zhCN'][50358] = "错乱的夺日者构造体"
RareNamesLocalized['zhCN'][69664] = "穆塔"
RareNamesLocalized['zhCN'][69996] = "攫天者库莱"
RareNamesLocalized['zhCN'][69997] = "布根尼图斯"
RareNamesLocalized['zhCN'][69998] = "苟达"
RareNamesLocalized['zhCN'][69999] = "巨灵神拉姆克"
RareNamesLocalized['zhCN'][70000] = "全知者阿塔比姆"
RareNamesLocalized['zhCN'][70001] = "碎脊者乌鲁"
RareNamesLocalized['zhCN'][70002] = "路班"
RareNamesLocalized['zhCN'][70003] = "莫托尔"
RareNamesLocalized['zhCN'][70530] = "拉沙"

local RareSeen = {}
local RareKilled = {}
local RareAlive = {}
local RareAliveHP = {}
local RareAnnounced = {}
local LastSent = {}
local RareAv = {}
local SoundPlayed = {}

--local SoundPlayed = 0
local VersionNotify = false
local myChan = false

local txt = ""
local currentWaypointX = false
local currentWaypointY = false
local currentWaypointNPCID = false

local needStatus = false

--------------------------------
local RC = CreateFrame("Frame", "RC", UIParent)
RC.version = "5.2.0-12"


function RC:getLocalRareName(id)
	if RareNamesLocalized[GetLocale()] ~= nil then
		if RareNamesLocalized[GetLocale()][id] ~= nil then
			return RareNamesLocalized[GetLocale()][id]
		end
	end
	if RareNamesLocalized['enUS'][id] ~= nil then
		return RareNamesLocalized['enUS'][id]
	else
		return "Unkown Name"
	end
end

function RC:getTargetPercentHP()
	local currhp = UnitHealth("target")
	local maxhp = UnitHealthMax("target")
	if currhp == 0 and maxhp == 0 then
		return false
	else
		return math.floor(currhp/maxhp * 100) 
	end
end

function RC:getTargetPercentHProunded()
	local per = self:getTargetPercentHP()
	if per then
		return math.floor(per/10)*10
	else
		return false
	end
end

function RC:setWaypoint(id)
	if TomTom ~= nil then
		if currentWaypointX == false and currentWaypointY == false then
			TomTom:AddWaypoint(RareCoordsRaw[id]["x"],RareCoordsRaw[id]["y"],self:getLocalRareName(RareIDs[id]))
			currentWaypointX = RareCoordsRaw[id]["x"]
			currentWaypointY = RareCoordsRaw[id]["y"]
			currentWaypointNPCID = RareIDs[id]
		end
	end
end

local function OnMouseDownAnnounce(id)
	if RareAnnounced[RareIDs[id]] == nil then
		if RareAliveHP[RareIDs[id]] == nil then
			SendChatMessage("{rt1} [RareCoordinator] "..RC:getLocalRareName(RareIDs[id])..": "..RareCoords[id].." {rt1}", "CHANNEL", nil, 1)
		else
			SendChatMessage("{rt1} [RareCoordinator] "..RC:getLocalRareName(RareIDs[id]).."("..RareAliveHP[RareIDs[id]].."%): "..RareCoords[id].." {rt1}", "CHANNEL", nil, 1)
		end
		RareAnnounced[RareIDs[id]] = time()
	end
end


RC:SetWidth(300)
RC:SetHeight(200)
RC:SetFrameStrata("BACKGROUND")
RC:SetPoint("CENTER",0,0)
RC:SetClampedToScreen(true)
RC:SetMinResize(150, 0)
RC:SetMaxResize(500, 0)

RC.texture = RC:CreateTexture(nil,"BACKGROUND")
RC.texture:SetTexture(0,0,0,0.4)
RC.texture:SetAllPoints(RC)


RC.left = CreateFrame("Frame", "RC.left", RC)
RC.left:SetWidth(200)
RC.left:SetHeight(RC:GetHeight()-9)
RC.left:SetPoint("TOPLEFT", RC, 5, -5)
RC.left.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.left.texture:SetTexture(0,0,0,0.2)
RC.left.texture:SetAllPoints(RC.left)

RC.mid = CreateFrame("Frame", "RC.mid", RC)
RC.mid:SetWidth(80)
RC.mid:SetHeight(RC:GetHeight()-9)
RC.mid:SetPoint("TOPLEFT", RC.left, "TOPRIGHT", 2, 0)
RC.mid.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.mid.texture:SetTexture(0,0,0,0.2)
RC.mid.texture:SetAllPoints(RC.mid)

RC.right = CreateFrame("Frame", "RC.right", RC)
RC.right:SetWidth(80)
RC.right:SetHeight(RC:GetHeight()-9)
RC.right:SetPoint("TOPLEFT", RC.mid, "TOPRIGHT", 2, 0)
RC.right.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.right.texture:SetTexture(0,0,0,0.2)
RC.right.texture:SetAllPoints(RC.right)

RC.res = CreateFrame("Frame", "RC.res", RC)
RC.res.frame = RC
RC.res:SetWidth(16)
RC.res:SetHeight(16)
RC.res:SetPoint("BOTTOMRIGHT", RC, -1, 1)
RC.res:EnableMouse(true)
RC.res:SetScript("OnMouseDown", OnDragHandleMouseDown)
RC.res:SetScript("OnMouseUp", OnDragHandleMouseUp)
RC.res:SetAlpha(0.5)

RC.res.texture = RC.res:CreateTexture(nil, "OVERLAY")
RC.res.texture:SetTexture([[Interface\AddOns\RareCoordinator\resize.tga]])
RC.res.texture:SetWidth(16)
RC.res.texture:SetHeight(16)
RC.res.texture:SetBlendMode("ADD")
RC.res.texture:SetPoint("CENTER", RC.res)

RC.res:Hide()


RC.left.text = {}
local i
for i=0, 11 do
	RC.left.text[i] = RC.left:CreateFontString("RC.left.text["..i.."]", nil, "GameFontNormal")
	RC.left.text[i]:SetPoint("TOP", "RC.left", 2, -2 + -14.5*i)
	RC.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.left.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.left.text[i]:SetText("Rare")
		RC.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	else
		RC.left.text[i]:SetText(RC:getLocalRareName(RareIDs[i]))
	end
end
RC.left.icon = {}
local i
for i=0, 11 do
	RC.left.icon[i] = CreateFrame("Frame", "RC.left.icon["..i.."]", RC)

	if i == 0 then
		RC.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", 6, -5)
		RC.left.icon[i]:SetWidth(20)
		RC.left.icon[i]:SetHeight(20)
		RC.left.icon[i].texture = RC.left.icon[i]:CreateTexture(nil, "OVERLAY")
		RC.left.icon[i].texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-TinyShield]])
		RC.left.icon[i].texture:SetAllPoints(RC.left.icon[i])
	else
		RC.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", -3, -3 + -14.8*i)
		RC.left.icon[i]:SetWidth(10)
		RC.left.icon[i]:SetHeight(10)
		RC.left.icon[i].texture = RC.left.icon[i]:CreateTexture(nil, "OVERLAY")
		RC.left.icon[i].texture:SetAllPoints(RC.left.icon[i])
	end
end
RC.mid.button = {}
for i=0, 11 do
	RC.mid.button[i] = CreateFrame("Frame", "RC.mid.button["..i.."]", RC)
	RC.mid.button[i]:SetPoint("TOPLEFT", "RC.mid", 0, -2 + -14.5*i)
	RC.mid.button[i]:SetHeight(13)
	RC.mid.button[i]:SetWidth(RC.mid:GetWidth())
	RC.mid.button[i].texture = RC.mid.button[i]:CreateTexture(nil,"BACKGROUND", nil, 2)
	RC.mid.button[i].texture:SetTexture(0,0.5,0,0.4)
	RC.mid.button[i].texture:SetAllPoints(RC.mid.button[i])
	
	RC.mid.button[i].icon = CreateFrame("Frame", "RC.mid.icon["..i.."].icon", RC.mid.button[i])
	RC.mid.button[i].icon:SetPoint("RIGHT", "RC.mid.button["..i.."]", 2, 0)
	RC.mid.button[i].icon:SetWidth(10)
	RC.mid.button[i].icon:SetHeight(10)
	RC.mid.button[i].icon.texture = RC.mid.button[i].icon:CreateTexture(nil, "OVERLAY")
	RC.mid.button[i].icon.texture:SetTexture([[Interface\AddOns\RareCoordinator\announce.tga]])
	RC.mid.button[i].icon.texture:SetAllPoints(RC.mid.button[i].icon)
	if i ~= 0 then
		RC.mid.button[i]:SetScript("OnMouseDown", function (self) OnMouseDownAnnounce(i) end)
	end
	RC.mid.button[i]:Hide()
end
RC.mid.text = {}
local i
for i=0, 11 do
	RC.mid.text[i] = RC.mid:CreateFontString("RC.mid.text["..i.."]", nil, "GameFontNormal")
	RC.mid.text[i]:SetPoint("TOP", "RC.mid", 2, -2 + -14.5*i)
	RC.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.mid.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.mid.text[i]:SetText("Seen")
		RC.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	end
end
RC.right.text = {}
local i
for i=0, 11 do
	RC.right.text[i] = RC.right:CreateFontString("RC.right.text["..i.."]", nil, "GameFontNormal")
	RC.right.text[i]:SetPoint("TOP", "RC.right", 2, -2 + -14.5*i)
	RC.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.right.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.right.text[i]:SetText("Killed")
		RC.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	end
end

local total = 0
local function updateText(self,elapsed)
	if elapsed == nil then elapsed = 0 end
    total = total + elapsed
    if total >= 10 then
		for i=1,GetAchievementNumCriteria(8103) do
			_, _, completed, _, _, _, _, assetID, _, _ = GetAchievementCriteriaInfo(8103,i)
			if completed then
				RareAv[assetID] = true
			else
				RareAv[assetID] = false
			end		
		end
		for k,v in pairs(RareSeen) do
			if tonumber(v)+2*60*60 < time() then
				RareSeen[k] = nil
			end
		end
		for k,v in pairs(RareKilled) do
			if tonumber(v)+2*60*60 < time() then
				RareKilled[k] = nil
			end
		end
		for k,v in pairs(RareAlive) do
			if tonumber(v)+10*60 < time() then
				RareAlive[k] = nil
				RareAliveHP[k] = nil
			end
		end
		if RC.left ~= nil then
			if RC.left.icon ~= nil then
				local i
				for i=1,table.getn(RC.left.icon) do
					if RareAv[RareIDs[i]] ~= nil then
						if RareAv[RareIDs[i]] then
							RC.left.icon[i].texture:SetTexture([[Interface\AddOns\RareCoordinator\green.tga]])
						else
							RC.left.icon[i].texture:SetTexture([[Interface\AddOns\RareCoordinator\red.tga]])
						end
					end
				end
			end
		end
		if RC.mid ~= nil then
			if RC.mid.text ~= nil then
				local i
				for i=1,table.getn(RC.mid.text) do
					if RareAlive[RareIDs[i]] ~= nil then
						if SoundPlayed[RareIDs[i]] == nil then
							PlaySoundFile("sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg", "MASTER")
							SoundPlayed[RareIDs[i]] = time()
						elseif time() > SoundPlayed[RareIDs[i]] + 600 then
							PlaySoundFile("sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg", "MASTER")
							SoundPlayed[RareIDs[i]] = time()
						end
						RC.mid.button[i]:Show()
						RC.mid.text[i]:SetText("|cff00ff00alive|r")
						RC:setWaypoint(i)
					elseif RareSeen[RareIDs[i]] ~= nil then
						RC.mid.button[i]:Hide()
						RC.mid.text[i]:SetText(math.floor((time()-RareSeen[RareIDs[i]])/60).."m ago")
					else
						RC.mid.button[i]:Hide()
						RC.mid.text[i]:SetText("never")
					end
				end
			end
		end
		if RC.right ~= nil then
			if RC.right.text ~= nil then
				local i
				for i=1,table.getn(RC.right.text) do
					if RareAliveHP[RareIDs[i]] ~= nil and RareAlive[RareIDs[i]] then
						RC.right.text[i]:SetText("|cff00ff00"..RareAliveHP[RareIDs[i]].."%|r")
					elseif RareKilled[RareIDs[i]] ~= nil then
						RC.right.text[i]:SetText(math.floor((time()-RareKilled[RareIDs[i]])/60).."m ago")
					else
						RC.right.text[i]:SetText("never")
					end
				end
			end
		end
        total = 0
    end
end




function RC:OnEvent(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:CombatLog(...)
	end
	if event == "PLAYER_TARGET_CHANGED" then
		self:Target(...)
	end
	if event == "CHAT_MSG_CHANNEL" then
		self:Chat(...)
	end
	if event == "ADDON_LOADED" then
		self:OnLoad(...)
	end
	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		self:ShowOrHide(...)
	end
	if event == "CHAT_MSG_ADDON" then
		self:AddonMsg(...)
	end
	if event == "CHANNEL_ROSTER_UPDATE" then
		self:ChanRosterUpdate(...)
	end
	if event == "UNIT_HEALTH" then
		self:UnitHealth(...)
	end
end

function RC:OnLoad(...)
	if select(1, ...) == "RareCoordinator" then
		print("RareCoordinator loaded - type /rc or /rare for options");
		if RCDB.x == nil or RCDB.y == nil then
			self:SetPoint("CENTER",0,0)
		else
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", RCDB.x, RCDB.y)
		end
	end
end

function RC:UnitHealth(unit)
	if unit ~= "target" then return end
	if UnitGUID("target") ~= nil then
		id = tonumber(UnitGUID("target"):sub(6, 10), 16)
		for _,v in pairs(RareIDs) do
			if v == id then
				local per = self:getTargetPercentHProunded()
				if per and per >= 0 then
					if RareAliveHP[id] ~= nil then
						if RareAliveHP[id] > per then
							SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive"..per.."_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
							RareAliveHP[id] = per
							updateText(self, 100)
						end
					else
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive"..per.."_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
						RareAliveHP[id] = per
						updateText(self, 100)
					end
				end
			end
		end
	end
end


function RC:ShowOrHide(...)
	local zone = GetZoneText()
	if GetCurrentMapAreaID() == 928 then
		RareAlive = {}
		self:Show()
		myChan = false
		self:SetScript("OnUpdate", RC.join)
		self:RegisterEvent("UNIT_HEALTH")
	else
		self:Hide()
		LeaveChannelByName("RCELVA")
		self:UnregisterEvent("UNIT_HEALTH")
	end
end


function RC:Chat(message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
	if channelName == "RCELVA" then
		if string.find(message, "[RCELVA]") then
			count = 0
			for match in string.gmatch(message, "_") do count = count + 1 end
			if count == 4 then
				message = string.sub(message, 9)
				local eventVersion,eventRareID,eventType,eventTime
				
				firstSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventVersion = string.sub(message, 0, firstSeperator-1)
					message = string.sub(message, firstSeperator+1)
				end
				
				secondSeperator,_ = string.find(message, "_")
				if secondSeperator ~= nil then
					eventRareID = tonumber(string.sub(message, 0, secondSeperator-1))
					message = string.sub(message, secondSeperator+1)
				end
				
				thirdSeperator,_ = string.find(message, "_")
				if thirdSeperator ~= nil then
					eventType = string.sub(message, 0, thirdSeperator-1)
					message = string.sub(message, thirdSeperator+1)
				end
				
				fourthSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventTime = string.sub(message, 0, fourthSeperator-1)
					message = string.sub(message, fourthSeperator+1)
				end
				
				for _,v in pairs(RareIDs) do
					if v == eventRareID and eventType ~= nil and eventTime ~= nil then
						if eventType == "alive" then
							RareAlive[v] = eventTime
						elseif string.sub(eventType,0,5) == "alive" then
							RareAlive[v] = eventTime
							RareAliveHP[v] = tonumber(string.sub(eventType,6))
						elseif eventType == "dead" then
							RareAlive[v] = nil
							RareAliveHP[v] = nil
							if currentWaypointNPCID ~= nil then
								if currentWaypointNPCID == v then
									currentWaypointX = false
									currentWaypointY = false
								end
							end
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
							RareAlive[v] = nil
							RareAliveHP[v] = nil
							if currentWaypointNPCID ~= nil then
								if currentWaypointNPCID == v then
									currentWaypointX = false
									currentWaypointY = false
								end
							end
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						updateText(self, 100)
						self:CompareVersion(eventVersion)
						break
					end
				end
			end
		end
	end
end

function RC:AddonMsg(prefix, message, channel, sender)
	if prefix == "RCELVA" then
		if channel == "WHISPER" and message == "GetStatus" then
			for id,timestamp in pairs(RareSeen) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_seen_"..timestamp.."_", "WHISPER", sender)
			end
			for id,timestamp in pairs(RareKilled) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_killed_"..timestamp.."_", "WHISPER", sender)
			end
			for id,timestamp in pairs(RareAlive) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_alive_"..timestamp.."_", "WHISPER", sender)
			end
		end
		if channel == "WHISPER" then
			count = 0
			for match in string.gmatch(message, "_") do count = count + 1 end
			if count == 4 then
				firstSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventVersion = string.sub(message, 0, firstSeperator-1)
					message = string.sub(message, firstSeperator+1)
				end
				
				secondSeperator,_ = string.find(message, "_")
				if secondSeperator ~= nil then
					eventRareID = tonumber(string.sub(message, 0, secondSeperator-1))
					message = string.sub(message, secondSeperator+1)
				end
				
				thirdSeperator,_ = string.find(message, "_")
				if thirdSeperator ~= nil then
					eventType = string.sub(message, 0, thirdSeperator-1)
					message = string.sub(message, thirdSeperator+1)
				end
				
				fourthSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventTime = string.sub(message, 0, fourthSeperator-1)
					message = string.sub(message, fourthSeperator+1)
				end
				
				for _,v in pairs(RareIDs) do
					if v == eventRareID and eventType ~= nil and eventTime ~= nil then
						if eventType == "alive" then
							RareAlive[v] = eventTime
						elseif eventType == "dead" then
							RareAlive[v] = nil
							RareAliveHP[v] = nil
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
							RareAlive[v] = nil
							RareAliveHP[v] = nil
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						updateText(self, 100)
						self:CompareVersion(eventVersion)
						break
					end
				end
				needStatus = false
			end
		end
	end
end

function RC:CompareVersion(v)
	local i=0
	local newVersion=false
	local expan1, cpatch1, mpatch1, revision1, expan2, cpatch2, mpatch2, revision2
	for n in string.gmatch(self.version, "%d+") do
		if     i == 0 then expan1 = tonumber(n)
		elseif i == 1 then cpatch1 = tonumber(n)
		elseif i == 2 then mpatch1 = tonumber(n)
		elseif i == 3 then revision1 = tonumber(n)
		end
		i = i + 1
	end
	i=0
	for n in string.gmatch(v, "%d+") do
		if     i == 0 then expan2 = tonumber(n)
		elseif i == 1 then cpatch2 = tonumber(n)
		elseif i == 2 then mpatch2 = tonumber(n)
		elseif i == 3 then revision2 = tonumber(n)
		end
		i = i + 1
	end
	if expan2 > expan1 then
		newVersion = true
	elseif cpatch2 > cpatch1 then
		newVersion = true
	elseif mpatch2 > mpatch1 then
		newVersion = true
	elseif revision2 > revision1 then
		newVersion = true
	end
	if newVersion and VersionNotify == false then
		print("RareCoordinator - New Version available: |cff00ff00"..v.."|r (You are using |cffff0000"..RC.version.."|r)")
		VersionNotify = true
	end
end

--3/8 18:03:12.537 UNIT_DIED,0x0000000000000000,nil,        0x80000000,  0x80000000,0xF13108BC0004C67E,"Creeping Moor Beast",0x10a48,0x0
function RC:CombatLog(timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if event == "UNIT_DIED" then
		for _,v in pairs(RareIDs) do
			local npcID = tonumber(destGUID:sub(6, 10), 16)
			if v == npcID then
					msg = time() .. " Rare Mob killed: " .. v
					RareKilled[v] = time()
					--self:DebugMsg(msg)
					SendChatMessage("[RCELVA]"..self.version.."_"..npcID.."_killed_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					RareAlive[v] = nil
					RareAliveHP[v] = nil
					SendChatMessage("[RCELVA]"..self.version.."_"..npcID.."_dead_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					if RareAnnounced[v] then
						SendChatMessage("{rt8} [RareCoordinator] "..RC:getLocalRareName(npcID).." is now dead {rt8}", "CHANNEL", nil, 1)
						RareAnnounced[v] = nil
					end
					if currentWaypointNPCID ~= nil then
						if currentWaypointNPCID == npcID then
							currentWaypointX = false
							currentWaypointY = false
						end
					end
					updateText(self, 100)
				break
			end
		end
	end
end

function RC:ChanRosterUpdate(id)
	if needStatus == true then
		--print ("roster update: ".. id)
		--print (GetChannelDisplayInfo(id))
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(id)
		if name == "RCELVA" then
			self:SetScript("OnUpdate", nil)
			--print("Got displayId of "..name..": "..id)
			
			local count = select(5, GetChannelDisplayInfo(id))
			--print("count"..count)
			for i=1,count do
				local name = select(1, GetChannelRosterInfo(id, i))
				local owner = select(2, GetChannelRosterInfo(id, i))
				if owner then
					--print(name .." is the owner right now")
					SendAddonMessage("RCELVA", "GetStatus", "WHISPER", name)
					updateText(self, 100)
				end
			end
		end
	end
end

function RC:getChanID(...)
	if myChan ~= false then
		return myChan
	end
	local gotID = false
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if name == "RCELVA" then
			gotID = true
			myChan = id
			return id
		end
	end
	if gotID == false then
		return false
	end
end

function RC:getChanDisplayID()
	local channels = GetNumDisplayChannels()
	local i = 1 
	
	while i <= channels do
		SetSelectedDisplayChannel(i)
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == "RCELVA" then
			--print("Got displayId of "..name..": "..i)
			return i
		end
		i = i + 1
	end
end

function RC:getChanOwner()
	local id = self:getChanDisplayID()
	if id ~= nil then
		SetSelectedDisplayChannel(id)
		local count = select(5, GetChannelDisplayInfo(id))
		--print("count"..count)
		for i=1,count do
			local name = select(1, GetChannelRosterInfo(id, i))
			local owner = select(2, GetChannelRosterInfo(id, i))
			if owner then
				return name
			end
		end
	end
end

function RC:Target(...)
--/run print(("NPC ID of %s: %d"):format(UnitName("target"), tonumber(UnitGUID("target"):sub(6, 10), 16)))
	if UnitGUID("target") ~= nil then
		id = tonumber(UnitGUID("target"):sub(6, 10), 16)
		for _,v in pairs(RareIDs) do
			if v == id then
					msg = time() .. " Rare Mob targeted: " .. id
					if UnitHealth("target") > 0 then
						RareAlive[v] = time()
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					else
						RareAlive[v] = nil
						RareAliveHP[v] = nil
						if currentWaypointNPCID ~= nil then
							if currentWaypointNPCID == id then
								currentWaypointX = false
								currentWaypointY = false
							end
						end
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_dead_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					end
					RareSeen[v] = time()
					if LastSent[v] == nil then
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_seen_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
						LastSent[v] = time()
					else
						if (LastSent[v] + 30) < time() then
							SendChatMessage("[RCELVA]"..self.version.."_"..id.."_seen_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
							LastSent[v] = time()
						end
					end
					--self:DebugMsg(msg)
					updateText(self, 100)
				break
			end
		end
	end
end

local waittime = 0
local chanchecked = 0
function RC.join(self, elapsed)
  waittime = waittime + elapsed
  if waittime > 1 then
	local id = self:getChanID(GetChannelList())
	if ( id == false ) then 
		--print("no id, joining")
		JoinChannelByName("RCELVA")
		if RegisterAddonMessagePrefix("RCELVA") ~= true then
			print("RareCoordinator: Couldn't register AddonPrefix")
		end
		chanchecked = 0
		needStatus = true
		--print("getting status from" .. owner)
		--SendAddonMessage("RCELVA", "GetStatus", "WHISPER", owner)
	else
		--self:SetScript("OnUpdate", nil)
		local channels = GetNumDisplayChannels()
		if channels > chanchecked then
			SetSelectedDisplayChannel(channels - chanchecked)
			
		end
		chanchecked = chanchecked + 1 

	end	
	waittime = 0
  end
end



function RC:DebugMsg(msg)
	print(msg)
		
end

SLASH_RARECOORDINATOR1 = "/rare"
SLASH_RARECOORDINATOR2 = "/rarecoordinator"
SLASH_RARECOORDINATOR3 = "/rc"
local function SlashHandler(msg, editbox)
	--print("Usage")
	if locked then
		print("RareCoordinator is now unlocked. - Type /rc or /rare to lock it")
		
		RC:EnableMouse(true)
		RC:SetMovable(true)
		RC:SetResizable(true)
		RC:SetScript("OnSizeChanged", onResize)
		RC:SetScript("OnDragStart", onDragStart)
		RC:SetScript("OnDragStop", onDragStop)
		RC:RegisterForDrag("LeftButton")
		RC:Show()
		RC.res:Show()
		
		locked = false
	else
		print("RareCoordinator is now locked. - Type /rc or /rare to unlock it")	
		
		RC:SetMovable(false)
		RC:EnableMouse(false)
		RC:SetResizable(false)
		RC:RegisterForDrag()
		RC:SetScript("OnDragStart", nil)
		RC:SetScript("OnDragStop", nil)
		RC:SetScript("OnHide", nil)
		RC:ShowOrHide()
		RC.res:Hide()
		
		locked = true
	end
end
SlashCmdList["RARECOORDINATOR"] = SlashHandler;

RC.updater = CreateFrame("Frame", "RC.updater", RC)
RC.updater:SetScript("OnUpdate", updateText)

RC:SetScript("OnEvent", RC.OnEvent)


--ONLY FOR TESTING
--		RC:SetScript("OnUpdate", RC.join)
		
		
RC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
RC:RegisterEvent("ADDON_LOADED")
RC:RegisterEvent("PLAYER_TARGET_CHANGED")
RC:RegisterEvent("CHAT_MSG_CHANNEL")
RC:RegisterEvent("CHAT_MSG_ADDON")
RC:RegisterEvent("PLAYER_ENTERING_WORLD")
RC:RegisterEvent("ZONE_CHANGED_NEW_AREA")
RC:RegisterEvent("CHANNEL_ROSTER_UPDATE")


updateText(RC, 100)
onResize(RC, RC:GetWidth(), 0)
RC:Show()
