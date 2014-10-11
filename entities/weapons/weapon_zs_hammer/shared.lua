AddCSLuaFile("shared.lua")

SWEP.Base = "weapon_zs_basemelee"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_hammer/v_hammer.mdl"
SWEP.WorldModel = "models/weapons/w_hammer.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 16

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.MeleeDamage = 35
SWEP.MeleeRange = 51
SWEP.MeleeSize = 0.875

SWEP.UseMelee1 = true

SWEP.NoPropThrowing = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"

SWEP.HealStrength = 1

SWEP.NoHolsterOnCarry = true

function SWEP:Think()
  self.BaseClass.Think(self)
  local stored = weapons.GetStored(self:GetClass())
  if !IsValid(stored) then
    return
  end
  if self.Owner:GetCNanoHammer() then
    self.SwingTime = stored.SwingTime * 0.85
    self.Primary.Delay = stored.Primary.Delay * 0.85
    -- self.SwingTime = stored.SwingTime * 0
    -- self.Primary.Delay = stored.Primary.Delay * 0
  else
    self.SwingTime = stored.SwingTime
    self.Primary.Delay = stored.Primary.Delay
  end	
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(110, 115))
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end