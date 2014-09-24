AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'블래스터' 샷건"
	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false

	SWEP.HUD3DPos = Vector(0, 0, 0)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.02
	SWEP.HUD3DBone = "SS.Grip.Dummy"
  
  function SWEP:PostDrawViewModel(vm)
    local seq = vm:GetSequenceName(vm:GetSequence())
    -- print(seq)
    if self.Owner:GetLaserSight() then
      local pos, ang = vm:GetBonePosition(vm:LookupBone("SS.Handle.Bone"))
      local hitpos = self.Owner:GetEyeTrace().HitPos
      local eyepos = EyePos()
      if eyepos:Distance(hitpos) > 30 then
        cam.Start3D(eyepos, EyeAngles())
          render.SetMaterial(Material("trails/laser"))
          render.DrawBeam(pos, hitpos, 2, 0, 12.5, Color(0, 255, 0, 255 * math.Rand(0.9, 1)))
          render.SetMaterial(self.LaserSight)
          local size = math.random() * 2
          render.DrawQuadEasy(hitpos, (eyepos - hitpos):GetNormal(), size, size, Color(0, 255, 0, 255), 0)
        cam.End3D()
      end
    end
    prevPoint = hitpos
    if self.ShowViewModel == false then
      render.SetBlend(1)
    end

    if not self.HUD3DPos or GAMEMODE.WeaponHUDMode == 1 then return end

    local pos, ang = self:GetHUD3DPos(vm)
    if pos then
      self:Draw3DHUD(vm, pos, ang)
    end
  end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/v_supershorty/v_supershorty.mdl"
SWEP.WorldModel = "models/weapons/w_supershorty.mdl"

SWEP.IronSightsPos = Vector(-2, 2, 2)
SWEP.IronSightsAng = Vector(0, 2, 0)

SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 7
SWEP.Primary.Delay = 0.8
SWEP.Primary.Recoil = 6

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMin = 0.08
SWEP.ConeMax = 0.12

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then return end
	local curtime = CurTime()
	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(curtime + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = curtime + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

function SWEP:Think()
	local curtime = CurTime()
	if self.reloading and self.reloadtimer < curtime then
		self.reloadtimer = curtime + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = curtime + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(curtime + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < curtime then
		self:EmitSound("Weapon_M3.Pump")
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self.nextreloadfinish = 0
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	self:TacticalLight()
end

function SWEP:CanPrimaryAttack()
	local curtime = CurTime()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		if self.Owner.AutoReload then
			self:Reload()
		else
			self:EmitSound("Weapon_Shotgun.Empty")
			self:SetNextPrimaryFire(curtime + 0.25)
		end
		return false
	end

	if self.reloading then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self.reloading = false
		self:SetNextPrimaryFire(curtime + 0.25)
		return false
	end

	return true
end
-- function SWEP:SecondaryAttack()
	-- self.BaseClass.SecondaryAttack(self)
-- end
