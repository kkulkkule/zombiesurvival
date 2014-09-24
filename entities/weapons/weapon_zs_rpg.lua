if CLIENT then
  SWEP.PrintName = "RPG"
  SWEP.Description = "좀비 대재앙 이전 대전쟁에서 알라의 요술봉으로 불리던 그 무기의 업그레이드 버전."
  
  SWEP.ViewModelFOV = 60
  SWEP.ViewModelFlip = false
  SWEP.Slot = 3
  
  SWEP.HUD3DBone = "v_weapon.RPG"
  SWEP.HUD3DPos = Vector(0, 0, 0)
  SWEP.HUD3DAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "rpg"

SWEP.ViewModel				= "models/bmsweapons/v_bmg.mdl"
SWEP.WorldModel				= "models/bmsweapons/w_bmrpg.mdl"

SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/rpg/single.wav")
SWEP.Primary.Damage = 350
SWEP.Primary.Delay = 6
SWEP.Primary.Recoil = 2
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "RPG"

SWEP.WalkSpeed = SPEED_SLOWEST

SWEP.ConeMax = 0.02
SWEP.ConeMin = 0.01

SWEP.IronSightsPos = Vector(-10, 0, -12)

function SWEP:PrimaryAttack()
  if !self:CanPrimaryAttack() then
    return
  end
  self:FireRocket()
  self:EmitSound(self.Primary.Sound)
  self:TakePrimaryAmmo(1)
  self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
  self.Owner:SetAnimation( PLAYER_ATTACK1 )
  self.Owner:MuzzleFlash()
  self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:FireRocket()
	local aim = self.Owner:GetAimVector()
	local pos = self.Owner:GetShootPos()

	if SERVER then
	local rocket = ents.Create("projectile_rpg")
	if !rocket:IsValid() then return false end
  rocket.Damage = self.Primary.Damage
	rocket:SetAngles(aim:Angle()+Angle(90,0,0))
	rocket:SetPos(pos)
	rocket:SetOwner(self.Owner)
	rocket:Spawn()
	rocket:Activate()
	util.ScreenShake(self.Owner:GetShootPos(), 1000, 10, 0.3, 500 )
	end
end

if !CLIENT then
  return
end

local matScope = Material("scope/rocketscope")
function SWEP:DrawHUDBackground()
		if self:GetIronsights() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)

			local x = ScrW() / 2.0
			local y = ScrH() / 2.0
			local scope_size = scrh
			
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5 + 30, size, size)

		end
	end

function SWEP:SecondaryAttack()
  if self:GetNextSecondaryFire() <= CurTime() and not self.Owner:IsHolding() then
		self:SetIronsights(true)
    timer.Simple(0.2, function()
      self.ShowViewModel = false
    end)
	end
end

function SWEP:SetIronsights(b)
  if !b then
    self.ShowViewModel = true
  end
	self.BaseClass.SetIronsights(self, b)
end

function SWEP:TranslateFOV(fov)
  if self:GetIronsights() then
    return self.BaseClass.TranslateFOV(self, fov * 0.3)
  else
    return self.BaseClass.TranslateFOV(self, fov)
  end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then return GAMEMODE.FOVLerp * 0.3 end
end

SWEP.LaserSight = Material("sprites/light_glow02_add")
local prevPoint = Vector(0, 0, 0)
function SWEP:PostDrawViewModel(vm)
end