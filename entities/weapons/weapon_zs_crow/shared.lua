SWEP.ZombieOnly = true
SWEP.IsMelee = true
SWEP.IsCrow = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.CrowExplodeRadius = CreateConVar("zs_crow_explode_radius", 500, FCVAR_SERVER_CAN_EXECUTE, "Set radius of phoenix exploding."):GetInt()
SWEP.ExplodeDamage = 3
SWEP.MaxPhoenixCount = 1

function SWEP:Initialize()
	self:HideViewAndWorldModel()
end

function SWEP:OnRemove()
	local owner = self.Owner
	if owner and owner:IsValid() then
		if owner.Flapping then
			owner:StopSound("NPC_Crow.Flap")
		end
		owner.Flapping = nil
	end
end
SWEP.Holster = SWEP.OnRemove

function SWEP:SetPeckEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetPeckEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsPecking()
	return CurTime() < self:GetPeckEndTime()
end

function SWEP:Explode()
	local ed = EffectData()
	ed:SetOrigin(self:GetPos())
	ed:SetMagnitude(10)
	util.Effect("explosion", ed)
end