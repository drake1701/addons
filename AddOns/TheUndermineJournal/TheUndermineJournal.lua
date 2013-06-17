--[[

TheUndermineJournal addon, v 2.3
http://theunderminejournal.com/

You should be able to query this DB from other addons:

o={}
TUJMarketInfo(52719,o)
print(o['market'])

Prints the market price of Greater Celestial Essence.

There are two versions of this addon:
  the "realm edition" which has data specific to each realm,
  the "general edition" or "GE" which has average data across all US realms.
  
If the user loads both addons:
	If the realm edition has data for its realm:
		the realm edition data gets loaded
		the GE version doesn't load
	else
		the GE version loads as a backup data source

In the realm edition ONLY, you can get:
	o['age'] = num of seconds since import
	o['market'] = most recent market price
	o['quantity'] = most recent num of items on AH
	o['reagentprice'] = most recent market price of reagents
	o['marketaverage'] = average market price over the past 2 weeks
	o['marketstddev'] = market price standard deviation over the past 2 weeks
	o['lastseen'] = date/time string (server time) that the item was last seen in a scan
	o['gemarketmedian'] = median market price over all realms (among most recent market prices)
	o['gemarketaverage'] = average market price over the past 2 weeks over all realms
	o['gemarketstddev'] = market price standard deviation over the past 2 weeks over all realms


In the GE version ONLY, you can get:
	o['age'] = num of seconds since import
	o['marketmedian'] = median market price over all realms (among most recent market prices)
	o['marketaverage'] = average market price over the past 2 weeks over all realms
	o['marketstddev'] = market price standard deviation over the past 2 weeks over all realms


NEW with version 2.2:

You can query and set whether the additional tooltip lines appear from this addon.
This is useful for other addons (Auctioneer, TSM, etc) that have their own fancy tooltips to disable TUJ tooltips and use TUJ simply as a data source.

TUJTooltip() returns a boolean whether TUJ tooltips are enabled
TUJTooltip(true) enables TUJ tooltips
TUJTooltip(false) disables TUJ tooltips

You may need to re-disable tooltips upon reloadui, or any other event that resets runtime variables.
Tooltips are enabled by default and there is no savedvariable that remembers to shut them back off.
See http://tuj.me/TUJTooltip for more information/examples.

]]

local addonName, addonTable = ...
addonTable.region = string.upper(string.sub(GetCVar("realmList"),1,2))
if addonTable.region ~= 'EU' then
	addonTable.region = 'US'
end
addonTable.realmname = addonTable.region..string.upper(string.sub(UnitFactionGroup("player"),1,1)..GetRealmName())
addonTable.tooltipsenabled = true

if (addonName == "TheUndermineJournalGE") and IsAddOnLoaded("TheUndermineJournal") then
	local TUJSpecificMarketInfo = _G['TUJMarketInfo']
	addonTable.skiploading = TUJSpecificMarketInfo(0)
end

--[[
	This chunk from:

	Norganna's Tooltip Helper class
	Version: 1.0

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This source code is specifically designed to work with World of Warcraft's
		interpreted AddOn system.
		You have an implicit licence to use this code with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat

		If you copy this code, please rename it to your own tastes, as this file is
		liable to change without notice and could possibly destroy any code that relies
		on it staying the same.
		We will attempt to avoid this happening where possible (of course).
]]


	local GOLD="ffd100"
	local SILVER="e6e6e6"
	local COPPER="c8602c"

	local GSC_3 = "|cff%s%d|cff000000.|cff%s%02d|cff000000.|cff%s%02d|r"
	local GSC_2 = "|cff%s%d|cff000000.|cff%s%02d|r"
	local GSC_1 = "|cff%s%d|r"

	local iconpath = "Interface\\MoneyFrame\\UI-"
	local goldicon = "%d|T"..iconpath.."GoldIcon:0|t"
	local silvericon = "%s|T"..iconpath.."SilverIcon:0|t"
	local coppericon = "%s|T"..iconpath.."CopperIcon:0|t"


	local function coins(money, graphic)
		money = math.floor(tonumber(money) or 0)
		local g = math.floor(money / 10000)
		local s = math.floor(money % 10000 / 100)
		local c = money % 100

		if not graphic then
			if g > 0 then
				return GSC_3:format(GOLD, g, SILVER, s, COPPER, c)
			elseif s > 0 then
				return GSC_2:format(SILVER, s, COPPER, c)
			else
				return GSC_1:format(COPPER, c)
			end
		else
			if g > 0 then
				return goldicon:format(g)..silvericon:format("%02d"):format(s)..coppericon:format("%02d"):format(c)
			elseif s > 0  then
				return silvericon:format("%d"):format(s)..coppericon:format("%02d"):format(c)
			else
				return coppericon:format("%d"):format(c)
			end
		end
	end

--[[
	End of chunk from 
	
	Norganna's Tooltip Helper class
	Version: 1.0
]]

local timeoffset = 0

local function parseupdatetime()
	if not addonTable.updatetimestring then return end
	if not addonTable.updatetime then
		local ts = addonTable.updatetimestring
		local y,m,d = strsplit('-',strsub(ts,1,10))
		local h,mi,s = strsplit(':',strsub(ts,12,19))
		addonTable.updatetime = time({['year']=y,['month']=m,['day']=d,['hour']=h,['min']=mi,['sec']=s,['isdst']=nil})
	end
end

local function GetIDFromLink(SpellLink)
	local _, l = GetItemInfo(SpellLink)
	if not l then return end
	return tonumber(string.match(l, "^|c%x%x%x%x%x%x%x%x|H%w+:(%d+)"))
end

local _tooltipcallback, lasttooltip

local function ClearLastTip(...)
	lasttooltip = nil
end

local function GetCallback()
	_tooltipcallback = _tooltipcallback or function(tooltip,...)
		if not addonTable.marketdata then return end
		if not addonTable.tooltipsenabled then return end
		if lasttooltip == tooltip then return end
		lasttooltip = tooltip

		local iid
		local spellName, spellRank, spellID = GameTooltip:GetSpell()
		if spellID then
			iid = addonTable.spelltoitem[spellID]
		else
			local name, item = tooltip:GetItem()
			if (not name) or (not item) then return end
			iid = GetIDFromLink(item)
		end

		if iid and addonTable.marketdata[iid] then
			local r,g,b = .9,.8,.5
			local dta = addonTable.marketdata[iid]
			local age = 0

			tooltip:AddLine(" ")

			parseupdatetime()
			if addonTable.updatetime then
				age = time() - (addonTable.updatetime+timeoffset)
				if (age > 0) then
					tooltip:AddLine("As of "..SecondsToTime(age,age>60).." Ago:",r,g,b)
				end
			end

			if dta['market'] then
				tooltip:AddDoubleLine("Market Latest",coins(dta['market'],false),r,g,b)
			end
			if dta['marketmedian'] then
				tooltip:AddDoubleLine("Market Median",coins(dta['marketmedian'],false),r,g,b)
			end
			if dta['marketaverage'] then
				tooltip:AddDoubleLine("Market Mean",coins(dta['marketaverage'],false),r,g,b)
			end
			if dta['marketstddev'] then
				tooltip:AddDoubleLine("Market Std Dev",coins(dta['marketstddev'],false),r,g,b)
			end
			if dta['reagentprice'] then
				tooltip:AddDoubleLine("Reagents Latest",coins(dta['reagentprice'],false),r,g,b)
			end
			if dta['quantity'] then
				tooltip:AddDoubleLine("Qty Available",dta['quantity'],r,g,b,r,g,b)
			end
			if dta['auctioncount'] then
				tooltip:AddDoubleLine("Auction Count",dta['auctioncount'],r,g,b,r,g,b)
			end
			if dta['gemarketmedian'] then
				tooltip:AddDoubleLine("Global Market Median",coins(dta['gemarketmedian'],false),r,g,b)
			end
			if dta['gemarketaverage'] then
				tooltip:AddDoubleLine("Global Market Mean",coins(dta['gemarketaverage'],false),r,g,b)
			end
			if dta['gemarketstddev'] then
				tooltip:AddDoubleLine("Global Market Std Dev",coins(dta['gemarketstddev'],false),r,g,b)
			end
			
			if addonTable.updatetime and dta['lastseen'] then
				local ts = dta['lastseen']
				local y,m,d = strsplit('-',strsub(ts,1,10))
				local h,mi,s = strsplit(':',strsub(ts,12,19))
				local lastseen = time({['year']=y,['month']=m,['day']=d,['hour']=h,['min']=mi,['sec']=s,['isdst']=nil})
				if ((addonTable.updatetime - lastseen) > 129600) then
					lastseen = time() - (lastseen + timeoffset)
					tooltip:AddLine("Last seen "..SecondsToTime(lastseen,lastseen>60).." ago!",r,g,b)
				end
			end
		end
	end
	return _tooltipcallback
end

if not addonTable.skiploading then
	--[[
		pass a table as the second argument to wipe and reuse that table
		otherwise a new table will be created and returned
	]]
	function TUJMarketInfo(iid,...)
		if iid == 0 then
			if addonTable.marketdata then
				return true
			else
				return false
			end
		end

		local numargs = select('#', ...)
		local tr
		
		if (numargs > 0) and (type(select(1,...)) == 'table') then
			tr = select(1,...)
			wipe(tr)
		end
		
		if not iid then return tr end
		if not addonTable.marketdata then return tr end
		if not addonTable.marketdata[iid] then return tr end
		
		if not tr then tr = {} end
		
		tr['itemid'] = iid
		parseupdatetime()
		if addonTable.updatetime then 
			tr['age'] = time() - (addonTable.updatetime+timeoffset)
		end
		
		for k,v in pairs(addonTable.marketdata[iid]) do
			tr[k] = v
			if ((not addonTable.gotthisrealm) and (string.sub(k,1,2) == "ge")) then tr[string.sub(k,3)] = v end
		end
		
		
		return tr
	end
	
	--[[
		enable/disable/query whether the TUJ tooltip additions are enabled
	]]
	function TUJTooltip(...)
		if select('#', ...) >= 1 then
			addonTable.tooltipsenabled = not not select(1,...) --coerce into boolean
		end
		return addonTable.tooltipsenabled
	end
	
end

local eventframe = CreateFrame("FRAME",addonName.."Events");

local function onEvent(self,event,arg)
	if event == "PLAYER_LOGIN" then
		local _,mon,day,yr = CalendarGetDate()
		local hr,min = GetGameTime()
		local servertime = time({['year']=yr,['month']=mon,['day']=day,['hour']=hr,['min']=min,['sec']=time()%60,['isdst']=nil})
		timeoffset = time()-servertime;
	end
	if event == "PLAYER_ENTERING_WORLD" then
		eventframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if addonTable.region ~= string.upper(string.sub(GetCVar("realmList"),1,2)) then
			print("The Undermine Journal - Warning: Unknown region from realmlist.wtf: '"..string.upper(string.sub(GetCVar("realmList"),1,2)).."', assuming '"..addonTable.region.."'")
		end
		if addonTable.marketdata then
			for _,frame in pairs{GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2} do
				frame:HookScript("OnTooltipSetItem", GetCallback())
				frame:HookScript("OnTooltipSetSpell", GetCallback())
				frame:HookScript("OnTooltipCleared", ClearLastTip)
			end
		else
			if (addonName == "TheUndermineJournal") and (not IsAddOnLoaded("TheUndermineJournalGE")) then
				print("The Undermine Journal - Warning: No data for "..addonTable.region.." "..GetRealmName().." "..UnitFactionGroup("player"))
			end
		end
	end
end

if not addonTable.skiploading then
	eventframe:RegisterEvent("PLAYER_LOGIN")
	eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventframe:SetScript("OnEvent", onEvent)
end

