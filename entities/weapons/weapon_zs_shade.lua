AddCSLuaFile()

SWEP.Base = "weapon_zs_zombie"

SWEP.ViewModel = Model("models/weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

if CLIENT then
	SWEP.ViewModelFOV = 70
end

SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = false
SWEP.MagneticForce = 1000
SWEP.MagneticForceMax = 1000
SWEP.MagneticForceMin = 700

function SWEP:Initialize()
	self:HideWorldModel()
end

local NextThink = 0
function SWEP:Think()
	local curtime = CurTime()
	if NextThink <= curtime then
		if SERVER then 
			if self.Owner:KeyDown(IN_WALK) then
				self:ChangeMagneticForce()
			end
		else
			self.MagneticForce = self:GetNWInt("MagneticForce") or -1
		end
		self.MagneticForceMax = self.Owner:GetPremium() and 1400 or 1000 
		NextThink = curtime + 0.5
	end
end

function SWEP:ChangeMagneticForce()
	if self.MagneticForce + 100 > self.MagneticForceMax then
		self.MagneticForce = self.MagneticForceMin
	else
		self.MagneticForce = self.MagneticForce + 100
	end
	self:SetNWInt("MagneticForce", self.MagneticForce)
end

function SWEP:PrimaryAttack()
	if CurTime() <= self:GetNextPrimaryFire() then return end
	self:SetNextSecondaryFire(CurTime() + 0.65)

	for _, ent in pairs(ents.FindByClass("env_shadecontrol")) do
		if ent:IsValid() and ent:GetOwner() == self.Owner then
			local obj = ent:GetParent()
			if obj:IsValid() then
				self.Owner:DoAttackEvent()

				if CLIENT then return end

				local filt = team.GetPlayers(TEAM_UNDEAD)
				table.insert(filt, obj)
				local vel = (self.Owner:TraceLine(10240, MASK_SOLID, filt).HitPos - obj:LocalToWorld(obj:OBBCenter())):GetNormalized() * (self.MagneticForce + (self.Owner:GetPremium() and 400 or 0))

				local phys = obj:GetPhysicsObject()
				if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 then
					phys:Wake()
					phys:SetVelocity(vel)
					obj:SetPhysicsAttacker(self.Owner)
					phys:AddGameFlag(FVPHYSICS_WAS_THROWN)

					obj:EmitSound(")weapons/physcannon/superphys_launch"..math.random(4)..".wav")
				end
			end

			ent:Remove()
		end
	end
end

function SWEP:SecondaryAttack()
	if CurTime() <= self:GetNextSecondaryFire() then return end
	self:SetNextPrimaryFire(CurTime() + 0.25)
	self:SetNextSecondaryFire(CurTime() + 0.4)

	if CLIENT then return end

	for _, ent in pairs(ents.FindByClass("env_shadecontrol")) do
		if ent:IsValid() and ent:GetOwner() == self.Owner then
			ent:Remove()
			return
		end
	end

	local premium = self.Owner:GetPremium()
	
	local ent = self:GetOwner():TraceHull(400, MASK_SOLID, 4 - (premium and 3 or 0), player.GetAll()).Entity
	if ent:IsValid() and ent:IsPhysicsModel() then
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() and phys:IsMoveable() and phys:GetMass() <= 300 + (premium and 100 or 0) then
			for _, ent2 in pairs(ents.FindByClass("env_shadecontrol")) do
				if ent2:IsValid() and ent2:GetParent() == ent then
					ent2:Remove()
					return
				end
			end

			local con = ents.Create("env_shadecontrol")
			if con:IsValid() then
				con:Spawn()
				con:SetOwner(self.Owner)
				con:AttachTo(ent)

				ent:EmitSound(")weapons/physcannon/physcannon_claws_close.wav")
			end
		end
	end
end

function SWEP:Reload()
end

function SWEP:OnRemove()
end

function SWEP:Holster()
end

if not CLIENT then return end

function SWEP:PreDrawViewModel(vm)
	local owner = self.Owner
	if owner:IsValid() then
		owner:CallZombieFunction("PreRenderEffects", vm)
	end
end

function SWEP:PostDrawViewModel(vm)
	local owner = self.Owner
	if owner:IsValid() then
		owner:CallZombieFunction("PostRenderEffects", vm)
	end
end

function SWEP:DrawHUD()
	surface.SetFont("DermaLarge")
	local w, h = surface.GetTextSize("Magnetic Force: " .. self.MagneticForce)
	draw.DrawText("Magnetic Force: " .. tostring(self.MagneticForce), "DermaLarge", ScrW() - 150, ScrH() - h, Color(220, 80, 80), TEXT_ALIGN_CENTER)
	self.BaseClass.DrawHUD(self)
end