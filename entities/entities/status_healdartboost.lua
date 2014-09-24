AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "status__base"

ENT.Adder = 0

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Adder")
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	hook.Add("Move", self, self.Move)
end

function ENT:Move(pl, move)
	if pl ~= self:GetOwner() then return end

	move:SetMaxSpeed(move:GetMaxSpeed() + 50 + self:GetAdder())
	move:SetMaxClientSpeed(move:GetMaxSpeed())
end
