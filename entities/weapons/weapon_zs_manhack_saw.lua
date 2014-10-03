AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "톱날 맨핵"
	SWEP.Description = "A modified manhack with a saw blade attachment.\nDoes significantly more damage and is more durable. Slightly less easy to control."
end

SWEP.Base = "weapon_zs_manhack"

SWEP.DeployClass = "prop_manhack_saw"
SWEP.ControlWeapon = "weapon_zs_manhackcontrol_saw"

SWEP.Primary.Ammo = "manhack_saw"
