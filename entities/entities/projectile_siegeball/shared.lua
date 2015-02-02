ENT.Type = "anim"

-- function ENT:StartTouch(ent)
	-- if IsValid(ent) and ent:IsPlayer() and ent:Team() == self.Team then
		-- return false
	-- end
-- end
ENT.LifeTime = 5
ENT.Model = "models/weapons/w_bugbait.mdl"
ENT.Team = TEAM_ZOMBIE
ENT.ShootPower = 1000
ENT.ShootTime = -1
ENT.ExplodeRadius = 280
ENT.Damage = 5
ENT.PullPowerMul = 1.3
ENT.MinPullPower = 80