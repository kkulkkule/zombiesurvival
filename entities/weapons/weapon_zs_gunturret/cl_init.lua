include("shared.lua")

SWEP.PrintName = "적외선 터렛"
SWEP.Description = "이 적외선 자동 터렛은 계속해서 유지보수하여야 쓸모가 있다.\n주 공격 버튼으로 설치.\n보조 공격 버튼과 재장전 키로 회전.\nSMG 탄약이 있는 상태에서 사용 키를 눌러 탄약 충전.\n주인이 없는 터렛(파란 불)에 사용 키를 눌러 제어."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
