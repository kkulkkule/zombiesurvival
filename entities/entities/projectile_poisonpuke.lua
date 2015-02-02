AddCSLuaFile()

ENT.Base = "projectile_poisonflesh"
ENT.Type = "anim"

ENT.Moved = 0
ENT.MaxMove = 1000

function ENT:Initialize()
	self.BeforePos = self:GetPos()
	self.BaseClass.Initialize(self)
end


function ENT:Think()
		
	local pos = self:GetPos()
	local owner = self:GetOwner()
	
	self.Moved = self.Moved + self.BeforePos:Distance(pos)
	self.BeforePos = pos
	
	if !IsValid(owner) then
		return
	end
	local ownerpos = owner:GetPos()
	local td = {
		start = pos,
		endpos = pos,
		filter = self,
		mask = MASK_SHOT
	}
	
		
	local phys = self:GetPhysicsObject()
	
	if !IsValid(phys) or CLIENT then	
		return
	end
	if !self.Disabled then
			
		if self.ManhackDetect then
			phys:EnableGravity(false)
		else
			phys:EnableGravity(true)
		end
		
		if self.Moved > self.MaxMove then
				self.NoVel = true
		end
		
		if !self.NoVel then
			local detected = false
			for _, v in pairs(ents.FindByClass("prop_manhack")) do
				local eobb = v:LocalToWorld(v:OBBCenter())
				local dist = pos:Distance(eobb)
				local moved = self.Moved
				local vel = phys:GetVelocity()
				local speed = 200 + 300 * (1 - self.Moved / self.MaxMove)
				if dist <= 110 and self.Moved <= self.MaxMove then
					detected = true
					self.Dir = (eobb - pos):GetNormal()
					-- PrintMessage(HUD_PRINTTALK, tostring(self.Dir:Angle():Up()))
					self.Tracing = true
					phys:SetVelocityInstantaneous(self.Dir * speed)
				elseif dist > 170 and self.Tracing then
					detected = false
				end
			end
			for _, v in pairs(ents.FindByClass("prop_manhack_saw")) do
				local eobb = v:LocalToWorld(v:OBBCenter())
				local dist = pos:Distance(eobb)
				local moved = self.Moved
				local vel = phys:GetVelocity()
				local speed = 400 + 550 * (1 - self.Moved / self.MaxMove)
				if dist <= 110 and self.Moved <= self.MaxMove then
					detected = true
					self.Dir = (eobb - pos):GetNormal()
					-- PrintMessage(HUD_PRINTTALK, tostring(self.Dir:Angle():Up()))
					self.Tracing = true
					phys:SetVelocityInstantaneous(self.Dir * speed)
				elseif dist > 340 and self.Tracing then
					detected = false
				end
			end
		else
			phys:SetVelocityInstantaneous(VectorRand() * 1000)
			self.Disabled = true
		end
		self.ManhackDetect = detected
	end
	self.BaseClass.Think(self)
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	
	if IsValid(ent) and ent:GetClass() == "prop_manhack" then
		ent:TakeDamage(3, self:GetOwner(), self)
		self:Remove()
	end
	
	if IsValid(ent) and ent:GetClass() == "prop_manhack_saw" then
		ent:TakeDamage(8, self:GetOwner(), self)
		self:Remove()
	end
	
	if not self:HitFence(data, phys) then
		self.PhysicsData = data
	end

	self:NextThink(CurTime())
end
