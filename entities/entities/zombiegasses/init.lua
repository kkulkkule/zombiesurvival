AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Heal = self.Heal or 25
	self:DrawShadow(false)
	self:Fire("attack", "", 1.5)

	if self:GetRadius() == 0 then self:SetRadius(400) end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "radius" then
		self:SetRadius(tonumber(value))
	elseif key == "heal" then
		self.Heal = tonumber(value) or self.Heal
	end
end

local function TrueVisible(posa, posb)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, ents.FindByClass("npc_*"))
	filt = table.Add(filt, ents.FindByClass("prop_*"))
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function ENT:AcceptInput(name, activator, caller, arg)
	if name ~= "attack" then return end
	self:Fire("attack", "", 1.5)

	if GAMEMODE:GetWave() <= 0 or GAMEMODE.ZombieEscape then return end

	local curtime = CurTime()
	local vPos = self:GetPos()
	for _, ent in pairs(ents.FindInSphere(vPos, self:GetRadius())) do
		if ent:IsPlayer() and ent:Alive() and WorldVisible(vPos, ent:NearestPoint(vPos)) then
			if ent:Team() == TEAM_UNDEAD then
				if ent:Health() < ent:GetMaxHealth() and not ent:GetZombieClassTable().Boss then
					ent:SetHealth(math.min(ent:GetMaxZombieHealth(), ent:Health() + self.Heal))
					ent.m_LastGasHeal = curtime
				end
				local classname = ent:GetZombieClassTable().Name
				if ent:GetPremium() then 
					GAMEMODE:PlayerBoost(ent, 120, 5)
				end
			elseif 1 < ent:Health() then
				ent:PoisonDamage(math.min(10, ent:Health() - 1), self, self)
			end
		end
	end

	return true
end
