AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'좀비 드릴' 데저트 이글"
	SWEP.Description = "이 권총의 강력한 탄환은 다른 종류보다 강력한 넉백을 준다." --SWEP.Description = "This high-powered handgun has the ability to pierce through multiple zombies. The bullet's power decreases by half which each zombie it hits."
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55

	SWEP.HUD3DBone = "v_weapon.Deagle_Slide"
	SWEP.HUD3DPos = Vector(-1, 0, 1)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015

	SWEP.IronSightsPos = Vector(-6.35, 5, 1.7)
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")
SWEP.Primary.Damage = 47
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.32
SWEP.Primary.KnockbackScale = 2
SWEP.Primary.Recoil = 0.8

SWEP.Primary.ClipSize = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.04
SWEP.ConeMin = 0.02