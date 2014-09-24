include("shared.lua")

SWEP.PrintName = "'이지스' 바리케이드 키트"
SWEP.Description = "모든 것이 통합되어 있는 바리케이드 키트.\n대부분의 표면에 자동으로 바리케이드를 설친한다.\n주 공격 버튼으로 설치.\n보조 공격 버튼과 재장전 키로 회전.\n윤곽선의 색깔로 설치 가능 여부를 판단한다."
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

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

function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:PrimaryAttack()
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
local kityaw = CreateClientConVar("zs_barricadekityaw", 90, false, true)
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("zs_barricadekityaw", math.NormalizeAngle(kityaw:GetFloat() + amount))
end
