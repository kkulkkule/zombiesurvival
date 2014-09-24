include("shared.lua")

SWEP.PrintName = "판자 더미"
SWEP.Description = "테이프로 묶인 나부 판자 더미.\n주변에 마땅한 프롭이 없을 경우 대신하여 쓸 수 있다.\n바리케이드로 고정시키려면 망치와 못이 필요하다."
SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:DrawWorldModel()
	local owner = self.Owner
	if owner:IsValid() and self:GetReplicatedAmmo() > 0 then
		local id = owner:LookupAttachment("anim_attachment_RH")
		if id and id > 0 then
			local attch = owner:GetAttachment(id)
			if attch then
				cam.Start3D(EyePos() + (owner:GetPos() - attch.Pos + Vector(0, 0, 24)), EyeAngles())
					self:DrawModel()
				cam.End3D()
			end
		end
	end
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
