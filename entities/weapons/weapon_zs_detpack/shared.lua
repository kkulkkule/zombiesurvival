SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = Model("models/weapons/w_c4_planted.mdl")

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "sniperpenetratedround"
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOW

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	self:SetDeploySpeed(1.1)
	self:HideViewAndWorldModel()
end

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(0, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(0)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	if !self:CanPrimaryAttack() then
		return
	end
	
	local owner = self.Owner
	if SERVER then
		local ent = ents.Create("prop_detpack")
		if ent:IsValid() then
			ent:SetPos(owner:GetPos())
			ent:SetAngles(owner:EyeAngles())
			ent:Spawn()
			if entity and entity:IsValid() then
				ent:SetParent(entity)
			end

			ent:EmitSound("weapons/c4/c4_plant.wav")

			self:TakePrimaryAmmo(1)

			ent:SetOwner(owner)
			ent:SetParent(owner)
			ent:SetExplodeTime(CurTime() + 2)
			self:Remove()
			owner.HumanSpeedAdder = -150
			timer.Simple(2, function()
				owner:ResetSpeed()
			end)
		end
	end
	self:EmitSound("mysounds/weapons/c4/yolololololololo.mp3")
end

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:Holster()
	return true
end
