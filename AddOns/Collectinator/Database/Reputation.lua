--[[
************************************************************************
Reputation.lua
************************************************************************
File date: 2012-10-21T02:07:15Z
File hash: bdc6ec5
Project hash: b336f20
Project version: 2.0.0beta3
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
]]--

-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

local pairs = _G.pairs

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub

local addon	= LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L		= LibStub("AceLocale-3.0"):GetLocale(private.addon_name)

private.reputation_list	= {}

function addon:InitReputation()
	local function AddReputation(rep_id, name)
		private:AddListEntry(private.reputation_list, rep_id, _G.GetFactionInfoByID(rep_id))
	end

	for name, id in pairs(private.FACTION_IDS) do
		AddReputation(id, private.LOCALIZED_FACTION_STRINGS[name])
	end
	self.InitReputation = nil
end
