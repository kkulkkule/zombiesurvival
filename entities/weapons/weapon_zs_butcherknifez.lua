AddCSLuaFile()

SWEP.Base = "weapon_zs_butcherknife"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 24
SWEP.Primary.Delay = 0.4

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if not hitent:IsPlayer() then
		self.MeleeDamage = 11
	else
		local rand = math.random(1, 100)
		if rand <= 10 then
			self.MeleeDamage = 30
			hitent:AddLegDamage(20)
		end
	end
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	self.MeleeDamage = 24
end
