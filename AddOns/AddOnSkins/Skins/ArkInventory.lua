local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('ArkInventory') then return end

function AS:ArkInventory()
	hooksecurefunc(ArkInventory, 'Frame_Main_Paint', function(frame)
		if not ArkInventory.ValidFrame(frame, true) then return	end
		for i = 1, select('#', frame:GetChildren()) do
			local subframe = select(i, frame:GetChildren())
			if subframe.IsSkinned then return end
			local name = subframe:GetName()
			if name then
				if _G[name..'ArkBorder'] then _G[name..'ArkBorder']:Kill() end
				if _G[name..'Background'] then _G[name..'Background']:Kill() end
			end
			AS:SkinFrame(subframe)
			subframe.IsSkinned = true
		end
	end)

	hooksecurefunc(ArkInventory, 'Frame_Main_Anchor_Set', function(loc_id)
		local frame = ArkInventory.Frame_Main_Get(loc_id):GetName()
		AS:SkinEditBox(_G[frame..ArkInventory.Const.Frame.Search.Name..'Filter'])

		-- local title = _G[frame..ArkInventory.Const.Frame.Title.Name]
		-- local search = _G[frame..ArkInventory.Const.Frame.Search.Name]
		-- local container = _G[frame..ArkInventory.Const.Frame.Container.Name]
		-- local changer = _G[frame..ArkInventory.Const.Frame.Changer.Name]
		-- local status = _G[frame..ArkInventory.Const.Frame.Status.Name]
		-- local a, b, c, d, e

		-- a, b, c, d, e = title:GetPoint()
		-- title:SetPoint(a, b, c, d, e - 2)

		-- a, b, c, d, e = search:GetPoint()
		-- search:SetPoint(a, b, c, d, e - 2)

		-- container:ClearAllPoints()
		-- container:SetPoint('TOPLEFT', search, 'BOTTOMLEFT', 0, -2)
		-- container:SetPoint('TOPRIGHT', search, 'BOTTOMRIGHT', 0, -2)
		-- changer:ClearAllPoints()
		-- changer:SetPoint('TOPLEFT', container, 'BOTTOMLEFT', 0, -2)
		-- changer:SetPoint('TOPRIGHT', container, 'BOTTOMRIGHT', 0, -2)
		-- status:ClearAllPoints()
		-- status:SetPoint('TOPLEFT', changer, 'BOTTOMLEFT', 0, -2)
		-- status:SetPoint('TOPRIGHT', changer, 'BOTTOMRIGHT', 0, -2)

		-- ARKINV_Frame4ChangerWindowPurchaseInfo:ClearAllPoints()
		-- ARKINV_Frame4ChangerWindowPurchaseInfo:SetPoint('TOP', ARKINV_Frame4ChangerWindowGoldAvailable, 'BOTTOM', 0, -12)
		-- _G[status:GetName()..'EmptyText']:SetPoint('LEFT', 2, 0)
		-- _G[status:GetName()..'EmptyText']:SetFont(AS.Font, 12)
		-- _G[status:GetName()..'GoldCopperButton']:SetPoint('RIGHT', -1, 0)
		-- _G[status:GetName()..'GoldCopperButtonText']:SetFont(AS.Font, 12)
		-- _G[status:GetName()..'GoldSilverButton']:SetPoint('RIGHT', _G[status:GetName()..'GoldCopperButtonText'], 'LEFT', -1,0)
		-- _G[status:GetName()..'GoldSilverButtonText']:SetFont(AS.Font, 12)
		-- _G[status:GetName()..'GoldGoldButton']:SetPoint('RIGHT', _G[status:GetName()..'GoldSilverButtonText'], 'LEFT', -1, 0)
		-- _G[status:GetName()..'GoldGoldButtonText']:SetFont(AS.Font, 12)
	end)

	hooksecurefunc(ArkInventory, 'Frame_Bar_Paint', function(bar)
		local loc_id = bar.ARK_Data.loc_id
		ArkInventory.LocationOptionSet(loc_id, 'bar', 'name', 'height', 18)

		if not bar.IsSkinned then
			local name = bar:GetName()
			if _G[name..'ArkBorder'] then _G[name..'ArkBorder']:Kill() end
			if _G[name..'Background'] then _G[name..'Background']:Kill() end
			bar:SetTemplate(AS:CheckOption('SkinTemplate'))
			bar.IsSkinned = true
		end

		if ArkInventory.Global.Mode.Edit then
			bar:SetBackdropBorderColor(1, 0, 0, 1)
			bar:SetBackdropColor(1, 0, 0, .1)
		else
			bar:SetBackdropBorderColor(unpack(AS.BorderColor))
			bar:SetBackdropColor(unpack(AS.BackdropColor))
		end
	end)

	hooksecurefunc(ArkInventory, 'SetItemButtonTexture', function(frame, texture, r, g, b)
		if not (frame and frame.icon) then
			return
		end

		AS:SkinTexture(frame.icon)
		frame.icon:SetInside()
	end)

	hooksecurefunc(ArkInventory, 'Frame_Item_Update_Border', function(frame)
		if not ArkInventory.ValidFrame(frame, true) then return end
		local obj = _G[frame:GetName()..'ArkBorder']
		if not obj then return end
		obj:Kill()

		AS:SetTemplate(frame)
		frame:SetBackdropBorderColor(obj:GetBackdropBorderColor())
		AS:SkinTexture(frame.icon)
		frame:SetNormalTexture(nil)
		if _G[frame:GetName()] == ARKINV_Frame1ChangerWindowBag1 then
			ARKINV_Frame1ChangerWindowBag1IconTexture:SetTexture('interface\\icons\\inv_misc_bag_07_green')
			AS:SkinTexture(ARKINV_Frame1ChangerWindowBag1IconTexture)
			ARKINV_Frame1ChangerWindowBag1IconTexture:SetInside()
		end
	end)

	hooksecurefunc(ArkInventory, 'Frame_Border_Paint', function(border, slot, file, size, offset, scale, r, g, b, a)
		local parent = border:GetParent()
		parent:SetBackdropBorderColor(r, g, b, a)
	end)
end

AS:RegisterSkin('ArkInventory', AS.ArkInventory)