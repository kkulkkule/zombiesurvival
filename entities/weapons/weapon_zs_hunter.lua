AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'헌터' 소총"
	SWEP.Description = "특대구경 탄환을 사용한다. 재장전 시간은 길지만 그만큼 강력하다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.awm_parent"
	SWEP.HUD3DPos = Vector(-1.25, -3.5, -16)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.02
end

sound.Add(
{
	name = "Weapon_Hunter.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	pitchstart = 134,
	pitchend = 10,
	sound = "weapons/awp/awp1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AWP.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Hunter.Single")
SWEP.Primary.Damage = 115
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 7
SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 15

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.115
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(-7.415, -8, 3)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.TracerName = "AR2Tracer"

SWEP.MaxCharged = 3

function SWEP:SecondaryAttack()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Charged")
end

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

--[[function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 80)
end]]

function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
	util.Effect("hit_hunter", effectdata)

	GenericBulletCallback(attacker, tr, dmginfo)
end

function SWEP:Reload()
	if self:IsCharging() then
		return
	end
	self:SetCharged(0)
	self:EndCharging()
	return self.BaseClass.Reload(self)
end

function SWEP:CanPrimaryAttack()
	if self:IsCharging() or self:GetCharged() == self.MaxCharged then
		return false
	end
	return self.BaseClass.CanPrimaryAttack(self)
end

SWEP.NextChargeShot = 0
SWEP.ChargeDelay = 30
SWEP.ChargeShotTerm = 0.3
SWEP.ChargeShotNum = 5
function SWEP:Think()
	self.BaseClass.Think(self)
	if CLIENT then
    if self:IsScoped() then
      self.ShowViewModel = false
    else
      self.ShowViewModel = true
    end
		local eagleeye = self.Owner.EagleEye and 0.5 or 1
		if self:GetIronsights() and self.Owner:KeyPressed(IN_SPEED) and IsFirstTimePredicted() then
			if self.Owner:GetPremium() then
				if self.IronsightsMultiplier == 0.25 * eagleeye then
					self.IronsightsMultiplier = 0.125 * eagleeye
				elseif self.IronsightsMultiplier == 0.125 * eagleeye then
					self.IronsightsMultiplier = 0.0625 * eagleeye
				else
					self.IronsightsMultiplier = 0.25 * eagleeye
				end
			else
				if self.IronsightsMultiplier == 0.125 * eagleeye then
					self.IronsightsMultiplier = 0.25 * eagleeye
				else
					self.IronsightsMultiplier = 0.125 * eagleeye
				end
			end
		end
		if !self:GetIronsights() then
			self.IronsightsMultiplier = 0.25 * eagleeye
		end
	end
	
	if !self.Owner:GetHunterCharge() then
		return
	end
	local charged = self:GetCharged()
	if self.Owner:KeyDown(IN_SPEED) then
		if self.Owner:GetAmmoCount(self.Primary.Ammo) + self:Clip1() < self.ChargeShotNum or self.NextChargeShot > CurTime() then
			return
		end
		self.Owner:SetSpeed(50)
		if charged == 0 then
			self:StartCharging()
		end
		if charged == self.MaxCharged then
			self:EndCharging()
		elseif self:IsCharging() then
			self:EmitSound("npc/scanner/scanner_electric" .. math.random(1, 2) .. ".wav")
			self:SetCharged(math.Clamp(charged + FrameTime() * 0.8, 0, self.MaxCharged))
		end
	elseif charged == self.MaxCharged then
		self:SetCharged(0)
		self:EndCharging()
		self:TakeChargedAmmo()
		self.OldRecoil = self.Primary.Recoil
		self.Primary.Recoil = self.OldRecoil * 0.8
		for i = 1, self.ChargeShotNum do
			timer.Simple(self.ChargeShotTerm * i, function()
				self:ShootChargedBullet()
			end)
		end
		timer.Simple(self.ChargeShotTerm * self.ChargeShotNum, function()
			self.Primary.Recoil = self.OldRecoil
			self:Reload()
		end)
		self.NextChargeShot = CurTime() + self.ChargeDelay
	else
		self:SetCharged(0)
		self:EndCharging()
	end
	if charged == self.MaxCharged then
		self.Owner:SetSpeed(50)
	end
	if charged < self.MaxCharged and charged ~= 0 and !self:IsCharging() then
		if charged > 0 then
			self:SetCharged(math.Clamp(charged - FrameTime() * 0.8, 0, self.MaxCharged))
		end
		self.Owner:ResetSpeed()
	end
end

function SWEP:ShootChargedBullet()
	local owner = self.Owner
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	local cone = 0.001
	local dmg = self.Primary.Damage * 1.1
	self:StartBulletKnockback()
	owner:FireBullets({Num = 1, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback})
	self:DoBulletKnockback(self.Primary.KnockbackScale * 0.05)
	self:EndBulletKnockback()
	
	if CLIENT then
		local eyeang = owner:EyeAngles()
		local punchang = owner:GetViewPunchAngles()
		local recoil = self.Primary.Recoil or cone
		if self.Owner:Crouching() then
			recoil = recoil * 0.7
		end
		if self:GetIronsights() then
			recoil = recoil * 0.8
		end
		if self.Owner.Recoil then
			recoil = recoil * 0.75
		end
		recoil = recoil * 0.4
		eyeang.pitch = eyeang.pitch - recoil
		eyeang.yaw = eyeang.yaw + math.Rand(-recoil * 0.6, recoil * 0.6)
		owner:SetEyeAngles(eyeang)
	end
	self:EmitFireSound()
end

function SWEP:TakeChargedAmmo()
	local clip = self:Clip1()
	self:SetClip1(0)
	self.Owner:SetAmmo(self.Owner:GetAmmoCount(self.Primary.Ammo) - (5 - clip), self.Primary.Ammo)
end

function SWEP:StartCharging()
	self.Charging = true
	self.Owner:SetSpeed(0.01)
end

function SWEP:EndCharging()
	self.Charging = false
end

function SWEP:IsCharging()
	return self.Charging
end

if CLIENT then

	function SWEP:AdjustMouseSensitivity()
		if self:IsCharging() or self:GetCharged() == self.MaxCharged then
			return 0.3
		end
		return self.BaseClass.AdjustMouseSensitivity(self)
	end
	function SWEP:DrawHUD()
		if self.Owner:GetHunterCharge() then
			local scrw = ScrW()
			local scrh = ScrH()
			local curtime = CurTime()
			if self.NextChargeShot > curtime then
				local ratio = (self.NextChargeShot - curtime) / self.ChargeDelay
				surface.SetDrawColor(255 * ratio, 255 - 255 * ratio, 255 - 255 * ratio, 220)
				surface.SetAlphaMultiplier(0.5)
				surface.DrawRect(scrw - 200, scrh - 30, 200 - 200 * ratio, 10)
			end
			
			if self.NextChargeShot <= curtime then
				surface.SetFont("ChatFont")
				surface.SetTextColor(0, 255, 255, 120)
				surface.SetTextPos(scrw - 200, scrh - 50)
				surface.DrawText("차지 샷 사용 가능(달리기 키)")
			else
				surface.SetFont("ChatFont")
				surface.SetTextColor(255, 0, 0, 120)
				surface.SetTextPos(scrw - 200, scrh - 50)
				surface.DrawText("충전중...")
			end
			
			
			local charged = self:GetCharged()
			if charged == self.MaxCharged then
				-- for i = 1, 10 do
					-- surface.DrawCircle(ScrW() / 2, ScrH() / 2, 10 + i * 0.7, Color(0 + i * 25.5, 255, 0, 220))
					surface.DrawCircle(scrw / 2, scrh / 2, 10, Color(0, 255, 0, 220))
					surface.DrawCircle(scrw / 2, scrh / 2, 11, Color(0, 255, 120, 220))
					surface.DrawCircle(scrw / 2, scrh / 2, 12, Color(0, 255, 240, 220))
				-- end
			elseif charged > 0 then
				local ratio = charged / self.MaxCharged
				-- for i = 1, 10 do
					-- surface.DrawCircle(scrw / 2, scrh / 2, math.Clamp(100 - 100 * ratio, 10, 100) + i * 0.7, Color(255 - 255 * ratio + i * 25.5, 255 * ratio, 0, 220 * ratio))
					surface.DrawCircle(scrw / 2, scrh / 2, math.Clamp(100 - 100 * ratio, 10, 100), Color(255 - 255 * ratio, 255 * ratio, 0, 220 * ratio))
				-- end
			end
		end
		self.BaseClass.DrawHUD(self)
	end

	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
						-- crosshair
			local x = ScrW() / 2.0
			local y = ScrH() / 2.0
			local scope_size = ScrH()
			
			-- crosshair
			local gap = 80
			local length = scope_size
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )

			gap = 0
			length = 50
			surface.DrawLine( x - length, y, x - gap, y )
			surface.DrawLine( x + length, y, x + gap, y )
			surface.DrawLine( x, y - length, x, y - gap )
			surface.DrawLine( x, y + length, x, y + gap )
			
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end
