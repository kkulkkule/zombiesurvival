AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'이레이져' 전략 권총"
	SWEP.Description = "현재 탄창에 남은 탄환이 줄어들 수록 데미지가 강해진다.\n마지막 탄환은 세 배의 데미지를 가한다."

	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false

	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "v_weapon.FIVESEVEN_PARENT"
	SWEP.HUD3DPos = Vector(-1, -2.5, -1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Damage = 21
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Recoil = 0.35

SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.04
SWEP.ConeMin = 0.02	

SWEP.IronSightsPos = Vector(-5.95, 0, 2.5)

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, 70 + (1 - (self:Clip1() / self.Primary.ClipSize)) * 90)
end

function SWEP:ShootBullets(dmg, numbul, cone)
	if self:Clip1() == 1 then
		dmg = dmg * 3
	else
		dmg = dmg + dmg * (1 - self:Clip1() / self.Primary.ClipSize)
	end

	self.BaseClass.ShootBullets(self, dmg, numbul, cone)
end
