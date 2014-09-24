AddCSLuaFile()

SWEP.Base = "weapon_zs_headcrab"

if CLIENT then
	SWEP.PrintName = "패스트 헤드크랩"
end

SWEP.PounceDamage = 6

SWEP.NoHitRecovery = 0.6
SWEP.HitRecovery = 0.75

function SWEP:EmitBiteSound()
	self.Owner:EmitSound("NPC_FastHeadcrab.Bite")
end

function SWEP:EmitIdleSound()
	self.Owner:EmitSound("NPC_FastHeadcrab.Idle")
end

function SWEP:EmitAttackSound()
	self.Owner:EmitSound("NPC_FastHeadcrab.Attack")
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	local owner = self.Owner
	if self:GetPouncing() or CurTime() < self:GetNextPrimaryFire() or not owner:IsOnGround() or self:IsBurrowing() then return end

	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel:Normalize()

	owner:SetGroundEntity(NULL)
	owner:SetLocalVelocity(vel * 450 * (owner:GetPremium() and 1.1 or 1))
	owner:DoAnimationEvent(ACT_RANGE_ATTACK1)

	if SERVER then
		self:EmitAttackSound()
	end

	self.m_ViewAngles = owner:EyeAngles()

	self:SetPouncing(true)
end