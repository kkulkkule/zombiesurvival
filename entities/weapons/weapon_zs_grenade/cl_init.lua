include("shared.lua")

SWEP.PrintName = "수류탄"
SWEP.Description = "고폭 수류탄.\n적절한 위치에서 터진다면, 좀비 무리를 저지할 수도 있다."

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

--[[function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end]]

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
