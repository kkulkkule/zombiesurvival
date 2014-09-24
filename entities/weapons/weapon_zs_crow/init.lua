AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Deploy()
	self.Owner.SkipCrow = true
	return true
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() then
		owner:StopSound("NPC_Crow.Flap")
		owner:SetAllowFullRotation(false)
	end
end
SWEP.OnRemove = SWEP.Holster

function SWEP:Think()
	local owner = self.Owner
	local premium = owner:GetPremium()
	owner.m_PhoenixCount = owner.m_PhoenixCount or 0
	if owner:KeyPressed(IN_ZOOM) and owner.m_PhoenixCount < self.MaxPhoenixCount then
		local td = {
			start = self:GetPos(),
			filter = {self.Owner, self},
			mask = MASK_SHOT
		}
		
		local ent = ents.FindInSphere(self:GetPos(), self.CrowExplodeRadius)
		local pl = {}
		for i, e in pairs(ent) do
			if e:IsWorld() then
				continue
			end
			if e:GetClass() == "prop_physics" and !e:IsBarricadeProp() and !e:IsNailed() then
				table.insert(td.filter, e)
				continue
			end
			if e:IsNailed() then
				table.insert(pl, e)
			end
			if e:IsPlayer() and e:Team() == TEAM_HUMAN then
				table.insert(pl, e)
			end
		end
		
		local tr = {}
		local dmginfo = DamageInfo()
		
		for i, p in pairs(pl) do
			td.endpos = p:LocalToWorld(p:OBBCenter())
			tr = util.TraceLine(td)
			local hitent = tr.Entity
			if !IsValid(hitent) then
				continue
			end
			
			if tr.Hit and hitent == p then
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(self.ExplodeDamage + (premium and 1 or 0))
				dmginfo:SetDamagePosition(td.endpos)
				p:TakeDamageInfo(dmginfo)
				table.insert(td.filter, hitent)
			end
		end
		owner.m_PhoenixCount = owner.m_PhoenixCount + 1
		self:Explode()
		owner:Kill()
	end

	if owner:KeyDown(IN_WALK) then
		owner:TrySpawnAsGoreChild()
		return
	end

	local fullrot = not owner:OnGround()
	if owner:GetAllowFullRotation() ~= fullrot then
		owner:SetAllowFullRotation(fullrot)
	end

	if owner:IsOnGround() or not owner:KeyDown(IN_JUMP) or not owner:KeyDown(IN_FORWARD) then
		if self.PlayFlap then
			owner:StopSound("NPC_Crow.Flap")
			self.PlayFlap = nil
		end
	else
		if not self.PlayFlap then
			owner:EmitSound("NPC_Crow.Flap")
			self.PlayFlap = true
		end
	end

	local peckend = self:GetPeckEndTime()
	if peckend == 0 or CurTime() < peckend then return end
	self:SetPeckEndTime(0)

	local trace = owner:TraceLine(14, MASK_SOLID)
	local ent = NULL
	if trace.Entity then
		ent = trace.Entity
	end

	owner:ResetSpeed()

	if ent:IsValid() then
		local phys = ent:GetPhysicsObject()
		if ent:IsPlayer() and (ent:Team() ~= TEAM_UNDEAD or ent:GetZombieClassTable().Name ~= "Crow") then
			return
		end

		ent:TakeSpecialDamage(2 + (premium and 1 or 0), DMG_SLASH, owner, self)
	end
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() or not self.Owner:IsOnGround() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end

	self.Owner:EmitSound("NPC_Crow.Squawk")
	self.Owner.EatAnim = CurTime() + 2

	self:SetPeckEndTime(CurTime() + 1)

	self.Owner:SetSpeed(1)
end

function SWEP:SecondaryAttack()
	if CurTime() < self:GetNextSecondaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 1.6)

	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end

	self.Owner:EmitSound("NPC_Crow.Alert")
end

function SWEP:Reload()
	self:SecondaryAttack()
	return false
end
