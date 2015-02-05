AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetColor(Color(0, 255, 0))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.DeathTime = CurTime() + self.LifeTime
	self.Cone = Vector(math.Rand(-0.01, 0.01), math.Rand(-0.01, 0.01), math.Rand(-0.01, 0.01))
	-- self:SetTrigger(true)
end

function ENT:SetOwner(owner)
	self.Owner = owner
	self.Team = owner:Team()
end

function ENT:GetOwner()
	return self.Owner
end

function ENT:SetShootTime(time)
	self.ShootTime = time
end

function ENT:GetShootTime()
	return self.ShootTime or -1
end

function ENT:Shoot(dir, cone)	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(1)
		phys:SetBuoyancyRatio(2)
		phys:EnableMotion(true)
		phys:Wake()
	end
	local dir = dir
	if !dir then
		dir = self.Owner:GetAimVector() + (cone and cone or Vector(0, 0, 0))
	end
	-- local phys = self:GetPhysicsObject()
	-- phys:SetVelocity(dir * self.ShootPower)
	phys:SetVelocity(dir * self.ShootPower)
	self.Shooted = true
end

function ENT:PhysicsCollide(colData, collider)
	self:Explode()
end

function ENT:ShouldNotCollide(ent)
	return (ent:IsPlayer() and ent:Team() == self.Team) or ent == self
end

function ENT:Think()
	local curtime = CurTime()
	
	if self.DeathTime <= curtime then
		self:Explode()
	end
	
	local shoottime = self:GetShootTime()
	if shoottime <= curtime and shoottime != -1 then
		self:Shoot(dir, self.Cone)
		self:SetShootTime(-1)
	elseif !self.Shooted then
		self:SetPos(self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * 10)
	end
end

function ENT:Explode()
	local owner = self:GetOwner()
	local filter = {self, owner}
	local pos = self:GetPos()
	local radius = self.ExplodeRadius
	for _, ent in pairs(ents.FindInSphere(pos, radius)) do
		if ent and ent:IsValid() then
			local nearest = ent:NearestPoint(pos)
			if TrueVisibleFilters(pos, nearest, self, ent) then
				if IsValid(ent) and ent:IsPlayer() and ent:Team() != self.Team then
					ent:TakeDamage(5, owner, self)
					local vel = ent:GetVelocity()
					vel.z = 0
					ent:SetGroundEntity(NULL)
					ent:SetVelocity((pos - ent:GetPos()):GetNormal() * math.Max(self.MinPullPower, vel:Length()) * self.PullPowerMul)
				end
			end
		end
	end
	
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale(500)
	effectdata:SetMagnitude(200)
	effectdata:SetNormal(self:GetOwner():GetAimVector())
	util.Effect( "siegeball", effectdata )
	self:Remove()
end