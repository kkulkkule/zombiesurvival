AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "ºÎÇ¬ Á»ºñ"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 1.25

SWEP.Primary.Delay = 1.5
SWEP.Secondary.Delay = 8
SWEP.Secondary.Cone = 0.085

SWEP.LastAlert = 0

function SWEP:Reload()
	if self.LastAlert + 3 <= CurTime() then
		self:DoAlert()
		self.LastAlert = CurTime()
	end
end

function SWEP:PlayAlertSound()
	self:PlayAttackSound()
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/ichthyosaur/attack_growl"..math.random(3)..".wav", 70, math.Rand(145, 155))
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() <= CurTime() then
		self.Owner:EmitSound("weapons/bugbait/bugbait_squeeze" .. tostring(math.random(1, 3)) .. ".wav")
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay - (self.Owner:GetPremium() and 0.8 or 0))
		self:ShootSiegeball()
	end
end

function SWEP:ShootSiegeball()
	self.Owner:SetWalkSpeed(5)
	timer.Simple(1, function()
		self.Owner:ResetSpeed()
	end)
	if SERVER then 
		local ent = ents.Create("projectile_siegeball")
		ent:SetOwner(self.Owner)
		ent:SetShootTime(CurTime() + 1)
		ent:Spawn()
		local aimvec = self.Owner:GetAimVector()
		local cone = Vector(math.Rand(self.Secondary.Cone, -self.Secondary.Cone), math.Rand(self.Secondary.Cone, -self.Secondary.Cone), math.Rand(self.Secondary.Cone, -self.Secondary.Cone))
		if self.Owner:GetPremium() then
			cone = cone * 0.7
		end
		ent.Cone = cone
		ent:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 10)
	end
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
