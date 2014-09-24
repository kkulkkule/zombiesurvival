include("shared.lua")

SWEP.PrintName = "C4"
SWEP.Description = "강력한 폭발력을 자랑하는 C4의 전략용 마이너체인지 버전.\n주 공격 버튼으로 설치.\n다시 한 번 주 공격 버튼으로 폭파.\n달리기 키로 회수."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
