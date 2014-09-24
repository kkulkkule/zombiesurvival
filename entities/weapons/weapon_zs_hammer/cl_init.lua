include("shared.lua")

SWEP.PrintName = "목수의 망치"
SWEP.Description = "간단하지만 생존에 매우 유용한 도구. 바리케이드를 못으로 고정할 수 있게 해준다.\n보조 공격 버튼으로 못 박기. 뒤쪽에 있는 무언가에 고정한다.\n재장전 키로 박힌 못 빼기.\n주 공격 키로 데미지 받은 못 수리.\n못을 수리하면 포인트를 얻지만, 다른 플레이어의 못을 빼면 포인트를 잃는다."

SWEP.ViewModelFOV = 75

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	surface.SetFont("ZSHUDFontSmall")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleTextBlurry(translate.Format("nails_x", nails), "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 3, nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	draw.SimpleTextBlurry(text, "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 2, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
