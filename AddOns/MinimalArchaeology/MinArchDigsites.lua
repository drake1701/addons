MinArchScrollDS = {}
MinArchDigsitesDB = {}

MinArchDigsitesDB["continent"] = {
	[1] = {		--Kalimdor
		--["name"] = {
		--	["status"] = true/false;
		--	["raceid"] = #,
		--	["x"] = #,
		--	["y"] = #
	},	
	[2] = {		--Eastern Kingdoms
	},
	[3] = {		--Outlands
	},	
	[4] = {		--Northrend
	},	
	[5] = {		-- The Maelstrom (no dig sites)
	},
	[6] = {		-- Pandaria
	},
}



function MinArch:UpdateActiveDigSites()
	local tempmap = GetCurrentMapAreaID();
	
	for i = 1, 6 do

		if MinArchDigsitesDB["continent"][i] == nil then
			MinArchDigsitesDB["continent"][i] = {}
		end

		for name,digsite in pairs(MinArchDigsitesDB["continent"][i]) do
			digsite["status"] = false;
		end
	
		SetMapZoom(i);
		
		for a=1, GetNumMapLandmarks() do
			local name, desc, tex, x, y = GetMapLandmarkInfo(a);
			if (tex == 177) then
				MinArchDigsitesDB["continent"][i][tostring(name)] = MinArchDigsitesDB["continent"][i][tostring(name)] or {};
				MinArchDigsitesDB["continent"][i][tostring(name)]["status"] = true;
				MinArchDigsitesDB["continent"][i][tostring(name)]["x"] = tostring(x*100);
				MinArchDigsitesDB["continent"][i][tostring(name)]["y"] = tostring(y*100);
				MinArchDigsitesDB["continent"][i][tostring(name)]["race"] = MinArchDigsitesDB["continent"][i][tostring(name)]["race"] or "Unknown";
				MinArchDigsitesDB["continent"][i][tostring(name)]["zone"] = MinArchDigsitesDB["continent"][i][tostring(name)]["zone"] or "Unknown";
				MinArchDigsitesDB["continent"][i][tostring(name)]["subzone"] = MinArchDigsitesDB["continent"][i][tostring(name)]["subzone"] or "Unknown";
			end
		end
	end
	
	SetMapByID(tempmap);
end

function MinArch:CreateDigSitesList(ContID)

	if (ContID < 1 or ContID > 6 ) then
		ContID = GetCurrentMapContinent();
		if (ContID < 1 or ContID > 6 ) then
			ContID = 1;
		end
	end
	
	if (ContID == 1) then
		MinArchDigsites.kalimdorButton:SetAlpha(1.0);
	elseif (ContID == 2) then
		MinArchDigsites.easternButton:SetAlpha(1.0);
	elseif (ContID == 3) then
		MinArchDigsites.outlandsButton:SetAlpha(1.0);
	elseif (ContID == 4) then
		MinArchDigsites.northrendButton:SetAlpha(1.0);
	elseif (ContID == 6) then
		MinArchDigsites.pandariaButton:SetAlpha(1.0);
	end
	
	local scrollf = MinArchDSScrollFrame or CreateFrame("ScrollFrame", "MinArchDSScrollFrame", MinArchDigsites);

	for i = 1, 6 do
		if (MinArchScrollDS[i]) then
			MinArchScrollDS[i]:Hide();
		end
	end
	
	MinArchScrollDS[ContID] = MinArchScrollDS[ContID] or CreateFrame("Frame", "MinArchScrollDS");
	local scrollc = MinArchScrollDS[ContID];
	
	MinArchScrollDS[ContID]:Show();
	
	local scrollb = MinArchScrollDSBar or CreateFrame("Slider", "MinArchScrollDSBar", scrollf);
	
	if (not scrollb.bg) then
		scrollb.bg = scrollb:CreateTexture(nil, "BACKGROUND");
		scrollb.bg:SetAllPoints(true);
		scrollb.bg:SetTexture(0, 0, 0, 0.80);
	end
	
	if (not scrollf.bg) then
		scrollf.bg = scrollf:CreateTexture(nil, "BACKGROUND");
		scrollf.bg:SetAllPoints(true);
		scrollf.bg:SetTexture(0, 0, 0, 0.60);
	end
	
	if (not scrollb.thumb) then
		scrollb.thumb = scrollb:CreateTexture(nil, "OVERLAY");
		scrollb.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
		scrollb.thumb:SetSize(25, 25);
		scrollb:SetThumbTexture(scrollb.thumb);
	end
	
	scrollc.digsites = scrollc.digsites or {};
	scrollc.mouseover = scrollc.mouseover or {};
	
	local PADDING = 5;
	
	local height = 0;
	local width = 261;
	
	local count = 1;
	
	for i=0,1 do
		for name,digsite in pairs(MinArchDigsitesDB["continent"][ContID]) do
			if ((digsite["status"] and i == 0) or (digsite["status"] == false and i == 1)) then
				if not scrollc.digsites[count] then
					scrollc.digsites[count] = scrollc:CreateFontString("Digsite" .. count, "OVERLAY")
				end
				
				local currentDigSite = scrollc.digsites[count];
				currentDigSite:SetFontObject("ChatFontSmall");
				currentDigSite:SetWordWrap(true);
				currentDigSite:SetText(" "..name);
				if (digsite["status"] == true) then
					currentDigSite:SetTextColor(1.0, 1.0, 1.0, 1.0);
				else
					currentDigSite:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
				end
				
				local cwidth = currentDigSite:GetStringWidth()
				local cheight = currentDigSite:GetStringHeight()
				currentDigSite:SetSize(cwidth+5, cheight)
				
				if count == 1 then
				  currentDigSite:SetPoint("TOPLEFT",scrollc, "TOPLEFT", 0, 0)
				  height = height + cheight
				else
				  currentDigSite:SetPoint("TOPLEFT", scrollc.digsites[count - 2], "BOTTOMLEFT", 0, - PADDING)
				  height = height + cheight + PADDING
				end
				
				count = count+1;
				
				-- RACE
				
				if not scrollc.digsites[count] then
					scrollc.digsites[count] = scrollc:CreateFontString("Digsite" .. count, "OVERLAY")
				end
				
				currentDigSite = scrollc.digsites[count];
				currentDigSite:SetFontObject("ChatFontSmall");
				currentDigSite:SetWordWrap(true);
				
				currentDigSite:SetText(digsite["zone"]);
				
				if (digsite["status"] == true) then
					currentDigSite:SetTextColor(1.0, 1.0, 1.0, 1.0);
				else
					currentDigSite:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
				end
				
				cwidth = currentDigSite:GetStringWidth()
				cheight = currentDigSite:GetStringHeight()
				currentDigSite:SetSize(cwidth+5, cheight)
				
				if count == 2 then
				  currentDigSite:SetPoint("TOPRIGHT",scrollc, "TOPRIGHT", 0, 0)
				else
				  currentDigSite:SetPoint("TOPRIGHT", scrollc.digsites[count - 2], "BOTTOMRIGHT", 0, - PADDING);
				end
				
				-- Moueover Frames Go Here
				
				if not scrollc.mouseover[count] then
					scrollc.mouseover[count] = CreateFrame("Frame", "MouseFrame");
				end
				
				local currentMO = scrollc.mouseover[count];
				currentMO:SetSize(261, cheight);
				currentMO:SetParent(scrollc);
				currentMO:SetPoint("BOTTOMRIGHT", currentDigSite, "BOTTOMRIGHT", 0, 0);
				
				currentMO:SetScript("OnEnter", function(self)
											MinArch:DigsiteTooltip(self, name, digsite);
										end)
				currentMO:SetScript("OnLeave", function()
											MinArchTooltipIcon:Hide();
											GameTooltip:Hide()
										end)
				
				count = count+1
			end
		end
	end
	
	-- Set the size of the scroll child
	scrollc:SetSize(261, height-2)
	 
	-- Size and place the parent frame, and set the scrollchild to be the
	-- frame of font strings we've created
	scrollf:SetSize(261, 253)
	scrollf:SetPoint("BOTTOMLEFT", MinArchDigsites, "BOTTOMLEFT", 12, 10)
	scrollf:SetScrollChild(scrollc)
	scrollf:Show()
	 
	scrollc:SetSize(261, height-2)
	 
	-- Set up the scrollbar to work properly
	local scrollMax = 0
	if height > 253 then
		scrollMax = height - 253
	end
	
	if (scrollMax == 0) then
		scrollb.thumb:Hide();
	else
		scrollb.thumb:Show();
	end
	
	scrollb:SetOrientation("VERTICAL");
	scrollb:SetSize(16, 253)
	scrollb:SetPoint("TOPLEFT", scrollf, "TOPRIGHT", 0, 0)
	scrollb:SetMinMaxValues(0, scrollMax)
	scrollb:SetValue(0)
	scrollb:SetScript("OnValueChanged", function(self)
		  scrollf:SetVerticalScroll(self:GetValue())
	end)
	 
	-- Enable mousewheel scrolling
	scrollf:EnableMouseWheel(true)
	scrollf:SetScript("OnMouseWheel", function(self, delta)
		  local current = scrollb:GetValue()
		   
		  if IsShiftKeyDown() and (delta > 0) then
			 scrollb:SetValue(0)
		  elseif IsShiftKeyDown() and (delta < 0) then
			 scrollb:SetValue(scrollMax)
		  elseif (delta < 0) and (current < scrollMax) then
			 scrollb:SetValue(current + 20)
		  elseif (delta > 0) and (current > 1) then
			 scrollb:SetValue(current - 20)
		  end
	end)
	
end

function MinArch:DimADIButtons()
	MinArchDigsites.kalimdorButton:SetAlpha(0.5);
	MinArchDigsites.easternButton:SetAlpha(0.5);
	MinArchDigsites.outlandsButton:SetAlpha(0.5);
	MinArchDigsites.northrendButton:SetAlpha(0.5);
	MinArchDigsites.pandariaButton:SetAlpha(0.5);
end

function MinArch:ADIButtonTooltip(ContID)
	local continentNames, contid, contname = { GetMapContinents() } ;

	GameTooltip:SetOwner(MinArchDigsites, "ANCHOR_TOPLEFT");
	
	for contid, contname in pairs(continentNames) do
		if (contid == ContID) then
			GameTooltip:AddLine(contname, 1.0, 1.0, 1.0, 1.0);
		end
	end

	GameTooltip:Show();
end

function MinArch:UpdateActiveDigSitesRace(Race)
	local ax = 0;
	local ay = 0;
	local tempmap = GetCurrentMapAreaID();

	SetMapZoom(GetCurrentMapContinent());
	ax, ay = GetPlayerMapPosition("player");
	
	ax = ax *100;
	ay = ay *100;

	local nearestDistance = nil;
	local nearestDigSite = nil;
	
	for name,digsite in pairs(MinArchDigsitesDB["continent"][GetCurrentMapContinent()]) do
			local xd = math.abs(ax - tonumber(digsite["x"]));
			local yd = math.abs(ay - tonumber(digsite["y"]));
			local d = math.sqrt((xd*xd)+(yd*yd));
			
			if (nearestDigSite == nil) then
				nearestDigSite = name;
				nearestDistance = d;
				
			elseif (d < nearestDistance) then
				nearestDigSite = name;
				nearestDistance = d;
				
			end			
	end
	
	if (MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["race"] == "Unknown") then
		MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["race"] = Race;
	end
	
	SetMapToCurrentZone();
	
	if (MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["zone"] == "Unknown") then
		MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["zone"] = GetZoneText();
	end
	
	if (MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["subzone"] == "Unknown") then
		MinArchDigsitesDB["continent"][tonumber(GetCurrentMapContinent())][nearestDigSite]["subzone"] = GetSubZoneText();
	end
	
	SetMapByID(tempmap);
	MinArch:ShowRaceIconsOnMap();
end

function MinArch:ShowRaceIconsOnMap()
	MinArchMapFrame1:Hide();
	MinArchMapFrame2:Hide();
	MinArchMapFrame3:Hide();
	MinArchMapFrame4:Hide();
	MinArchMapFrame6:Hide();
	local count = 0;
	if (WorldMapDetailFrame:IsVisible()) then
		for a=1, GetNumMapLandmarks() do
			local name, desc, tex, x, y = GetMapLandmarkInfo(a);
			local contID;
			
			if (tex == 177) then
				count = count + 1;
				for i = 1, 6 do
					for dname,digsite in pairs(MinArchDigsitesDB["continent"][i]) do
						if (dname == name) then
							contID = i;
						end
					end
				end
		
				if (count == 1) then
					MinArch:SetIcon(MinArchMapFrame1, x, y, tostring(name), MinArchDigsitesDB["continent"][contID][tostring(name)])
				elseif (count == 2) then
					MinArch:SetIcon(MinArchMapFrame2, x, y, tostring(name), MinArchDigsitesDB["continent"][contID][tostring(name)])
				elseif (count == 3) then
					MinArch:SetIcon(MinArchMapFrame3, x, y, tostring(name), MinArchDigsitesDB["continent"][contID][tostring(name)])
				elseif (count == 4) then
					MinArch:SetIcon(MinArchMapFrame4, x, y, tostring(name), MinArchDigsitesDB["continent"][contID][tostring(name)])
				elseif (count == 6) then
					MinArch:SetIcon(MinArchMapFrame6, x, y, tostring(name), MinArchDigsitesDB["continent"][contID][tostring(name)])
				end
			end
		end
	end
end

function MinArch:SetIcon(FRAME, X, Y, NAME, DETAILS)
	
	FRAME:SetScript("OnEnter", function()
											MinArch:DigsiteMapTooltip(FRAME, NAME, DETAILS);
										end);
	FRAME:SetScript("OnLeave", function()
								MinArchTooltipIcon:Hide();
								MinArchTooltipIcon:SetParent(GameTooltip);								
								MinArchTooltipIcon:SetPoint("TOPRIGHT", GameTooltip, "TOPLEFT");
								WorldMapTooltip:Hide();
							end);
	
	local RACE = tostring(DETAILS["race"]);
	
	if (RACE == "Unknown") then
		RACE = "Other"
	end
	
	for i=1,12 do
		if (RACE == MinArch['artifacts'][i]['race']) then
			RACE = MinArch['artifacts'][i]['raceicon'];
		end
	end
	
	FRAME:SetPoint("TOPLEFT", X*(WorldMapDetailFrame:GetWidth())-15, (Y*(WorldMapDetailFrame:GetHeight())*(-1))+5);
	FRAME.icon:SetTexture(RACE);
	FRAME.icon:SetTexCoord(0.0234375, 0.5625, 0.078125, 0.625);
	
	
	
	FRAME:Show();
end


function MinArch:DigsiteTooltip(self, name, digsite)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	local progress = 0;
	local plural = "";
	
	local RACE = tostring(digsite["race"]);
	
	if (RACE == "Unknown") then
		RACE = "Other"
	end
		
	for i=1,12 do	
		if (RACE == MinArch['artifacts'][i]['race']) then
			MinArchTooltipIcon.icon:SetTexture(MinArch['artifacts'][i]['raceicon']);
			progress = MinArch['artifacts'][i]['progress'];
			if (progress ~= 1) then
				plural = "s";
			end
		end
	end
	
	GameTooltip:AddLine(name, 1.0, 1.0, 1.0, 1.0);
	
	if (digsite['subzone'] ~= "Unknown") then
		GameTooltip:AddDoubleLine(digsite['subzone'], digsite['zone'], GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	if (digsite['race'] ~= "Unknown") then
		GameTooltip:AddDoubleLine("Race: |cffffffff"..digsite['race'], "|cffffffff"..progress.." fragment"..plural, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	
	MinArchTooltipIcon:Show();
	GameTooltip:Show();
end

function MinArch:DigsiteMapTooltip(self, name, digsite)
	
	MinArchTooltipIcon:SetParent(WorldMapTooltip);
	MinArchTooltipIcon:SetPoint("TOPRIGHT", WorldMapTooltip, "TOPLEFT");
	WorldMapTooltip:SetOwner(self, "ANCHOR_BOTTOM");	
	
	local progress = 0;
	local plural = "";
	
	local RACE = tostring(digsite["race"]);
	
	if (RACE == "Unknown") then
		RACE = "Other"
	end
	
	for i=1,12 do	
		if (RACE == MinArch['artifacts'][i]['race']) then
			MinArchTooltipIcon.icon:SetTexture(MinArch['artifacts'][i]['raceicon']);
			progress = MinArch['artifacts'][i]['progress'];
			if (progress ~= 1) then
				plural = "s";
			end
		end
	end
	
	WorldMapTooltip:AddLine(name, 1.0, 1.0, 1.0, 1.0);
	
	if (digsite['subzone'] ~= "Unknown") then
		WorldMapTooltip:AddDoubleLine(digsite['subzone'], digsite['zone'], GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	if (digsite['race'] ~= "Unknown") then
		WorldMapTooltip:AddDoubleLine("Race: |cffffffff"..digsite['race'], "|cffffffff"..progress.." fragment"..plural, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	
	MinArchTooltipIcon:Show();
	WorldMapTooltip:Show();
end














