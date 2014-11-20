local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('Capping') then return end

function AS:Capping(event)
	hooksecurefunc(Capping, "StartBar",	function(self, name)
		local bar = self:GetBar(name, true)
		local Backdrop = bar.backdrop or bar.Backdrop
		if not Backdrop then
			bar:CreateBackdrop()
			bar.iconbackdrop = CreateFrame('Frame', nil, bar)
			bar.iconbackdrop:SetOutside(bar.icon)
			AS:SkinTexture(bar.icon)
		end
	end)
end

AS:RegisterSkin('Capping', AS.Capping)