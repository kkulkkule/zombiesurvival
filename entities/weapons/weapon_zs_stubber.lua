AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'스터버' 소총"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.scout_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.75, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_Scout.ClipOut")
SWEP.Primary.Sound = Sound("Weapon_Scout.Single")
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 6

SWEP.ReloadDelay = SWEP.Primary.Delay

SWEP.Primary.ClipSize = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.075
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(-6.675, -8, 3)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 100)
end

if CLIENT then

	function SWEP:Think()
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
		self.BaseClass.Think(self)
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
			surface.SetDrawColor( 0, 0, 0, 255 )
         
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
