local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('Scrap') then return end

function AS:Scrap(event, addon)
	local AddOnCount = 0
	if addon == 'Scrap_Merchant' or IsAddOnLoaded('Scrap_Merchant') then
		if Scrap and Scrap:IsObjectType('Button') then
			Scrap:StyleButton(false)
			Scrap:SetTemplate('Default', true)
			ScrapBorder:SetTexture(nil)
			ScrapIcon:SetTexture('Interface\\Addons\\Scrap\\Art\\Enabled Icon')
			ScrapIcon:SetInside()
			local numTabs = MerchantFrame.numTabs
			for i = numTabs, 1, -1 do
				tab = _G[('MerchantFrameTab%d'):format(i)]
				if tab then
					if tab:GetText() == 'Scrap' then
						AS:SkinTab(tab)
						break
					end
				else
					break
				end
			end
			AddOnCount = AddOnCount + 1
		end
	end
	
	if addon == 'Scrap_Visualizer' or IsAddOnLoaded('Scrap_Visualizer')then
		ScrapVisualizer:StripTextures(true)
		ScrapVisualizer:CreateBackdrop('Default')
		ScrapVisualizerInset:StripTextures()
		ScrapVisualizerScroll:StripTextures()
		AS:SkinScrollBar(ScrapVisualizerScrollBar)
		AS:SkinCloseButton(ScrapVisualizerCloseButton)
		AS:SkinTab(ScrapVisualizerTab1)
		AS:SkinTab(ScrapVisualizerTab2)
		AS:SkinButton(ScrapVisualizerButton, true)
		ScrapVisualizer:Width(MerchantFrame:GetWidth()-6)
		AddOnCount = AddOnCount + 1
	end

	if AddOnCount == 2 then
		AS:UnregisterEvent('Scrap', 'ADDON_LOADED')
	end
end

AS:RegisterSkin('Scrap', AS.Scrap, 'ADDON_LOADED')