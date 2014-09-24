AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'애나벨' 소총"
	SWEP.Description = "개조된 사냥용 소총의 탄환은 목표에 단단한 표면에 적중할 경우 폭발한다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0
	
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.75, 1, -5)
	SWEP.HUD3DAng = Angle(180, 0, 0)
	SWEP.HUD3DScale = 0.015
  SWEP.LaserSight = Material("sprites/light_glow02_add")
  local prevPoint = Vector(0, 0, 0)
  function SWEP:PostDrawViewModel(vm)
    local seq = vm:GetSequenceName(vm:GetSequence())
    if self.Owner:GetLaserSight() and !string.find(seq, "draw") and !string.find(seq, "reload") then
      local muzzle = vm:LookupAttachment("muzzle")
      if muzzle == 0 then
        muzzle = vm:LookupAttachment("1")
      end
      local td = util.GetPlayerTrace(self.Owner)
      td.filter = {pl, self, vm}
      table.insert(td.filter, team.GetPlayers(self.Owner:Team()))
      td.mask = MASK_SHOT
      local tr = util.TraceLine(td)
      local hitpos = tr.HitPos
      local eyepos = EyePos()
      if eyepos:Distance(hitpos) > 60 then
        cam.Start3D(eyepos, EyeAngles())
          render.SetMaterial(Material("trails/laser"))
          render.DrawBeam(vm:GetAttachment(muzzle).Pos, hitpos, 2, 0, 12.5, Color(0, 255, 0, 255 * math.Rand(0.9, 1)))
          render.SetMaterial(self.LaserSight)
          local size = math.random() * 2
          render.DrawQuadEasy(hitpos, (eyepos - hitpos):GetNormal(), size, size, Color(0, 255, 0, 255), 0)
        cam.End3D()
      end
    end
  end
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_annabelle.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_Shotgun.Single")
SWEP.Primary.Damage = 90
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = 0.4
SWEP.Primary.Recoil = 3

SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 24

SWEP.ConeMax = 0.08
SWEP.ConeMin = 0.015

SWEP.WalkSpeed = SPEED_SLOW

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.IronSightsPos = Vector(-8.8, 10, 4.32)
SWEP.IronSightsAng = Vector(1.4,0.1,5)

function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:DoReloadEvent()
	end
end

if SERVER then
	function SWEP:Think()
		if self.reloading and self.reloadtimer < CurTime() then
			self.reloadtimer = CurTime() + self.ReloadDelay
			self:SendWeaponAnim(ACT_VM_RELOAD)

			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
			self:SetClip1(self:Clip1() + 1)
			self:EmitSound("Weapon_Shotgun.Reload")

			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.nextreloadfinish = CurTime() + self.ReloadDelay
				self.reloading = false
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			end
		end

		local nextreloadfinish = self.nextreloadfinish
		if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
			self.nextreloadfinish = 0
		end

		if self.IdleAnimation and self.IdleAnimation <= CurTime() then
			self.IdleAnimation = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end

		if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:SetIronsights(false)
		end
	end
end

if CLIENT then
	function SWEP:Think()
		if self.reloading and self.reloadtimer < CurTime() then
			self.reloadtimer = CurTime() + self.ReloadDelay
			self:SendWeaponAnim(ACT_VM_RELOAD)

			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
			self:SetClip1(self:Clip1() + 1)
			self:EmitSound("Weapon_Shotgun.Reload")

			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.nextreloadfinish = CurTime() + self.ReloadDelay
				self.reloading = false
				self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			end
		end

		local nextreloadfinish = self.nextreloadfinish
		if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
			self.nextreloadfinish = 0
		end

		if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:SetIronsights(false)
		end
		self:TacticalLight()
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		if self.Owner.AutoReload then
			self:Reload()
		else
			self:EmitSound("Weapon_Shotgun.Empty")
			self:SetNextPrimaryFire(CurTime() + 0.25)
		end
		return false
	end

	if self.reloading then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		else
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end

local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	attacker.RicochetBullet = true
	attacker:FireBullets({Num = 8, Src = hitpos, Dir = hitnormal, Spread = Vector(0.2, 0.2, 0), Tracer = 1, TracerName = "rico_trace", Force = damage * 0.15, Damage = damage, Callback = GenericBulletCallback})
	attacker.RicochetBullet = nil
end
function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and tr.HitWorld and not tr.HitSky then
		local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() / 5
		timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end
