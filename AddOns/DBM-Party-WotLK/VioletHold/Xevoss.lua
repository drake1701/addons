local mod	= DBM:NewMod("Xevoss", "DBM-Party-WotLK", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 7 $"):sub(12, -3))
mod:SetCreatureID(29266)
mod:SetModelID(27486)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
)
