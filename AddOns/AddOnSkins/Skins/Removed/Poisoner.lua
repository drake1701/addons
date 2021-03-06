local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('Poisoner') then return end

function AS:Poisoner()
	AS:SkinFrame(PoisonerOptions_SettingsFrame)
	AS:SkinButton(PoisonerOptions_MenuSortingButton)
	AS:SkinButton(PoisonerOptions_SettingsSave)
	AS:SkinButton(PoisonerOptions_SettingsClose)
	AS:SkinButton(PoisonerOptions_ResetFBPosition)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_Enable)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MBShow)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_FBShow)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_FBLock)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_PoisonWeaponChatOuput)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_ShowOnMouseover)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_AutoHide_inCombat)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MenuParentOwn)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MenuParentMinimap)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPTopLeft)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPTop)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPTopRight)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPLeft)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPRight)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPBottomLeft)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPBottom)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_MPBottomRight)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_ToolTipFull)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_ToolTipName)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_OverwritePreset)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_ShowTimer)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_IgnoreWhileFishing)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_OnlyInstanced)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_MainHand)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_OffHand)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_ThrowWeapon)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_Audio)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_Chat)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_Aura)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_ErrorFrame)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_TimerOutput_Aura_Lock)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_AutoBuy)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_AutoBuy_Prompt)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_AutoBuy_Check)
	AS:SkinCheckBox(PoisonerOptions_ChkBox_QuickButton_Lock)

	PoisonerOptions_SettingsFrameTab1:Point('TOPLEFT', PoisonerOptions_SettingsFrame, 'BOTTOMLEFT', 0, 2)

	for i = 1, 5 do
		AS:SkinTab(_G['PoisonerOptions_SettingsFrameTab'..i])
	end
end

AS:RegisterSkin('Poisoner', AS.Poisoner)