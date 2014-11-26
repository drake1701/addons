--[[--------------------------------------------------------------------
Auc-Stat-TUJ-Global - The Undermine Journal global price statistics module
Copyright (c) 2014, Jesse Dunn

CODE MODIFIED FROM ORIGINAL "Auc-Stat-TheUndermineJournal" :
	
		Auc-Stat-TheUndermineJournal - The Undermine Journal price statistics module
		Copyright (c) 2011, 2012 Johnny C. Lam
		All rights reserved.

		Redistribution and use in source and binary forms, with or without
		modification, are permitted provided that the following conditions
		are met:

		1. Redistributions of source code must retain the above copyright
		   notice, this list of conditions and the following disclaimer.
		2. Redistributions in binary form must reproduce the above copyright
		   notice, this list of conditions and the following disclaimer in the
		   documentation and/or other materials provided with the distribution.

		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
		"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
		TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
		PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
		BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
		CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
		SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
		INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
		CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
		ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
		POSSIBILITY OF SUCH DAMAGE.
--]]--------------------------------------------------------------------

if not AucAdvanced then return end

local libType, libName = "Stat", "TUJ Global Median"
local lib, parent, private = AucAdvanced.NewModule(libType, libName)
if not lib then return end

local aucPrint, decode, _, _, replicate, empty, get, set, default, debugPrint, fill, _TRANS = AucAdvanced.GetModuleLocals()
local GetFaction = AucAdvanced.GetFaction
local wipe = wipe

-- TUJ data table for market data from most-recently requested item.
local tujData = { }

lib.Processors = {
	config = function(callbackType, ...)
			private.SetupConfigGui(...)
		end,
	load = function(callbackType, addon)
			if private.OnLoad then
				private.OnLoad(addon)
			end
		end,
	tooltip = function(callbackType, ...)
			private.ProcessTooltip(...)
		end,
}

-- lib.GetPrice()
--     (optional) Returns estimated price for item link.
function lib.GetPrice(hyperlink, serverKey)
	if not get("stat.underminejournal.enable") then return end
	if not private.GetInfo(hyperlink, serverKey) then return end
	return tujData.market, tujData.reagentprice, tujData.marketaverage, tujData.marketstddev, tujData.quantity,
		tujData.gemarketmedian, tujData.gemarketmean, tujData.gemarketstddev
end

-- lib.GetPriceColumns()
--     (optional) Returns the column names for GetPrice.
function lib.GetPriceColumns()
	return "Market Latest", "Reagents Latest", "Market Mean", "Market Std Dev", "Qty Available",
		"Global Market Median", "Global Market Mean", "Global Market Std Dev"
end

-- lib.GetPriceArray()
--     Returns pricing and other statistical info in an array.
local priceArray = {}
function lib.GetPriceArray(hyperlink, serverKey)
	if not get("stat.underminejournal.enable") then return end
	if not private.GetInfo(hyperlink, serverKey) then return end

	wipe(priceArray)

	-- Required entries for GetMarketPrice().
	priceArray.price = tujData.globalMedian
	-- (Poorly) approximate "seen" with the current AH quantity.
	priceArray.seen = tujData.quantity

	priceArray.market = tujData.market
	priceArray.quantity = tujData.quantity
	priceArray.reagentprice = 0
	priceArray.marketaverage = tujData.globalMean
	priceArray.marketstddev = tujData.stddev
	priceArray.gemarketmedian = tujData.globalMedian
	priceArray.gemarketaverage = tujData.globalMean
	priceArray.gemarketstddev = tujData.globalStdDev

	return priceArray
end

-- lib.GetItemPDF()
--     Returns Probability Density Function for item link.
local bellCurve = AucAdvanced.API.GenerateBellCurve()
function lib.GetItemPDF(hyperlink, serverKey)
	if not get("stat.underminejournal.enable") then return end
	if not private.GetInfo(hyperlink, serverKey) then return end

	local mean, stddev = tujData.marketaverage, tujData.marketstddev
	if not mean or not stddev or stddev == 0 then
		-- No available data.
		return
	end

	-- Calculate the lower and upper bounds as +/- 3 standard deviations.
	local lower, upper = (mean - 3 * stddev), (mean + 3 * stddev)

	bellCurve:SetParameters(mean, stddev)
	return bellCurve, lower, upper
end

function private.OnLoad(addon)
	if addon ~= "Auc-Stat-TUJ-Global" then return end

	default("stat.underminejournal.enable", false)
	default("stat.underminejournal.tooltip", false)
	default("stat.underminejournal.reagents", false)
	default("stat.underminejournal.mean", false)
	default("stat.underminejournal.stddev", false)
	default("stat.underminejournal.gemedian", true)
	default("stat.underminejournal.gemean", true)
	default("stat.underminejournal.gestddev", true)
	default("stat.underminejournal.quantmul", true)

	-- Only run this function once.
	private.OnLoad = nil
end

-- private.GetInfo(hyperlink, serverKey)
--     Returns the market info for the requested item in the tujData table.
function private.GetInfo(hyperlink, serverKey)
	local linkType, itemId, suffix, factor = decode(hyperlink)
	if linkType ~= "item" then return nil end

	wipe(tujData)
	if TUJMarketInfo then
		TUJMarketInfo(itemId, tujData)
	end
	if not tujData.itemid then
		return nil
	end
	tujData.quantity = tujData.quantity or 0

	-- If there are zero quantity and market data is missing, then fallback to using the GE (all realms) data.
	if tujData.quantity == 0 and not tujData.marketaverage then
		tujData.marketaverage = tujData.gemarketaverage
		tujData.marketstddev = tujData.gemarketstddev
	end

	return itemId
end

function private.SetupConfigGui(gui)
	local id = gui:AddTab(lib.libName, lib.libType.." Modules")

	gui:AddHelp(id, "what undermine journal",
		_TRANS('TUJ_Help_UndermineJournal'),
		_TRANS('TUJ_Help_UndermineJournalAnswer')
	)

	-- All options in here will be duplicated in the tooltip frame
	function private.addTooltipControls(id)
		gui:AddControl(id, "Header",     0,    _TRANS('TUJ_Interface_UndermineJournalOptions'))
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Checkbox",   0, 1, "stat.underminejournal.enable", _TRANS('TUJ_Interface_EnableUndermineJournal'))
		gui:AddTip(id, _TRANS('TUJ_HelpTooltip_EnableUndermineJournal'))
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
		gui:AddControl(id, "Note",       0, 1, nil, nil, " ")
	end

	local tooltipID = AucAdvanced.Settings.Gui.tooltipID

	private.addTooltipControls(id)
	if tooltipID then private.addTooltipControls(tooltipID) end
end

function private.ProcessTooltip(tooltip, name, hyperlink, quality, quantity, cost, ...)
	-- If the Auctioneer TUJ tooltip is enabled, then disable TUJ's tooltip, and vice versa.
	if not get("stat.underminejournal.tooltip") then
		if TUJTooltip then TUJTooltip(true) end
		return
	else
		if TUJTooltip then TUJTooltip(false) end
	end
	local serverKey = GetFaction()
	if not private.GetInfo(hyperlink, serverKey) then return end

	if not quantity or quantity < 1 then quantity = 1 end
	if not get("stat.underminejournal.quantmul") then quantity = 1 end
end