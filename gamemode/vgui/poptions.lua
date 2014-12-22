function MakepOptions()
	PlayMenuOpenSound()

	if pOptions then
		pOptions:SetAlpha(0)
		pOptions:AlphaTo(255, 0.5, 0)
		pOptions:SetVisible(true)
		pOptions:MakePopup()
		return
	end

	local Window = vgui.Create("DFrame")
	local wide = math.min(ScrW(), 500)
	local tall = math.min(ScrH(), 580)
	Window:SetSize(wide, tall)
	Window:Center()
	Window:SetTitle(" ")
	Window:SetDeleteOnClose(false)
	pOptions = Window

	local y = 8

	local label = EasyLabel(Window, "옵션", "ZSHUDFont", color_white)
	label:SetPos(wide * 0.5 - label:GetWide() * 0.5, y)
	y = y + label:GetTall() + 8

	local list = vgui.Create("DPanelList", pOptions)
	list:EnableVerticalScrollbar()
	list:EnableHorizontal(false)
	list:SetSize(wide - 24, tall - y - 12)
	list:SetPos(12, y)
	list:SetPadding(8)
	list:SetSpacing(4)

	gamemode.Call("AddExtraOptions", list, Window)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("얻은 포인트 표시 안 함")
	check:SetConVar("zs_nofloatingscore")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("정조준시 크로스헤어 표시")
	check:SetConVar("zs_ironsightscrosshair")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("필름 모드(대부분의 HUD 비활성화)")
	check:SetConVar("zs_filmmode")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("효과음 켜기")
	check:SetConVar("zs_beats")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("최후의 생존자 음악 켜기")
	check:SetConVar("zs_playmusic")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("후처리 켜기")
	check:SetConVar("zs_postprocessing")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("필름 효과 켜기")
	check:SetConVar("zs_filmgrain")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("컬러 모드 켜기")
	check:SetConVar("zs_colormod")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("데미지 이펙트 켜기")
	check:SetConVar("zs_drawpainflash")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("크로스헤어 회전 비활성화")
	check:SetConVar("zs_nocrosshairrotate")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("인간 체력 오오라 표시")
	check:SetConVar("zs_auras")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("데미지 표시 켜기")
	check:SetConVar("zs_damagefloaters")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("걸을 때 화면 흔들림 켜기")
	check:SetConVar("zs_movementviewroll")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("항상 못 내구도 표시")
	check:SetConVar("zs_alwaysshownails")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("자동 성불 끄기(다음 라운드부터 적용)")
	check:SetConVar("zs_noredeem")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("항상 좀비 지원자 되기(다음 라운드부터 적용)")
	check:SetConVar("zs_alwaysvolunteer")
	check:SizeToContents()
	list:AddItem(check)

	local check = vgui.Create("DCheckBoxLabel", Window)
	check:SetText("클래스 변경시 자동으로 자살하기")
	check:SetConVar("zs_suicideonchange")
	check:SizeToContents()
	list:AddItem(check)

	list:AddItem(EasyLabel(Window, "무기 HUD 표시 스타일", "DefaultFontSmall", color_white))
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)

	dropdown:AddChoice("2D")
	dropdown:AddChoice("2D + 3D")
	dropdown:AddChoice("없음")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_weaponhudmode", value == "없음" and 3 or value == "2D + 3D" and 2 or value == "2D" and 1 or 1)
	end
	dropdown:SetText(GAMEMODE.WeaponHUDMode == 3 and "없음" or GAMEMODE.WeaponHUDMode == 2 and "둘 다" or GAMEMODE.WeaponHUDMode == 1 and "2D" or "2D")
	list:AddItem(dropdown)
	list:AddItem(EasyLabel(Window, "인간 효과음", "DefaultFontSmall", color_white))
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetHumanDefualt then
			dropdown:AddChoice(setname)
		end
	end
	dropdown:AddChoice("none")
	dropdown:AddChoice("default")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_human", value)
	end
	dropdown:SetText(GAMEMODE.BeatSetHuman == GAMEMODE.BeatSetHumanDefault and "default" or GAMEMODE.BeatSetHuman)
	list:AddItem(dropdown)

	list:AddItem(EasyLabel(Window, "좀비 효과음", "DefaultFontSmall", color_white))
	local dropdown = vgui.Create("DComboBox", Window)
	dropdown:SetMouseInputEnabled(true)
	for setname in pairs(GAMEMODE.Beats) do
		if setname ~= GAMEMODE.BeatSetZombieDefualt then
			dropdown:AddChoice(setname)
		end
	end
	dropdown:AddChoice("none")
	dropdown:AddChoice("default")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_beatset_zombie", value)
	end
	dropdown:SetText(GAMEMODE.BeatSetZombie == GAMEMODE.BeatSetZombieDefault and "default" or GAMEMODE.BeatSetZombie)
	list:AddItem(dropdown)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 100)
	slider:SetConVar("zs_beatsvolume")
	slider:SetText("음악 볼륨")
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 512)
	slider:SetConVar("zs_transparencyradius")
	slider:SetText("근처의 인간 투명 범위")
	slider:SizeToContents()
	list:AddItem(slider)

	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_filmgrainopacity")
	slider:SetText("필름 효과")
	slider:SizeToContents()
	list:AddItem(slider)

	list:AddItem(EasyLabel(Window, "크로스헤어 주 색깔"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr")
	colpicker:SetConVarG("zs_crosshair_colg")
	colpicker:SetConVarB("zs_crosshair_colb")
	colpicker:SetTall(72)
	list:AddItem(colpicker)
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_crosshairalpha1")
	slider:SetText("크로스헤어 주 투명도")
	slider:SizeToContents()
	list:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_crosshairalpha2")
	slider:SetText("크로스헤어 보조 투명도")
	slider:SizeToContents()
	list:AddItem(slider)
	list:AddItem(EasyLabel(Window, "크로스헤어 보조 색깔"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr2")
	colpicker:SetConVarG("zs_crosshair_colg2")
	colpicker:SetConVarB("zs_crosshair_colb2")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, "체력 오오라 색깔 - 건강할 때"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_full_r")
	colpicker:SetConVarG("zs_auracolor_full_g")
	colpicker:SetConVarB("zs_auracolor_full_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)

	list:AddItem(EasyLabel(Window, "체력 오오라 색깔 - 빈사일 때"))
	local colpicker = vgui.Create("DColorMixer", Window)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_empty_r")
	colpicker:SetConVarG("zs_auracolor_empty_g")
	colpicker:SetConVarB("zs_auracolor_empty_b")
	colpicker:SetTall(72)
	list:AddItem(colpicker)
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(10, 2048)
	slider:SetConVar("zs_max_projectiles")
	slider:SetText("화면에 보이는 최대 입자 개수")
	slider:SizeToContents()
	list:AddItem(slider)
	
	local slider = vgui.Create("DNumSlider", Window)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 2048)
	slider:SetConVar("r_decals")
  function slider:OnMousePressed()
    RunConsoleCommand("r_cleardecals")
  end
	slider:SetText("화면에 보이는 최대 흔적 개수")
	slider:SizeToContents()
	list:AddItem(slider)
  
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.5, 0)
	Window:MakePopup()
end
