AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "티클 몬스터"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 22
SWEP.MeleeReach = 160
SWEP.MeleeSize = 5

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:Think()
	local owner = self.Owner
	if owner:GetPremium() then
		local key = owner:KeyDown(IN_WALK)
		if key then
			self.ShowMenu = true
		else
			self.ShowMenu = false
		end
	end
	self.BaseClass.Think(self)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end

function SWEP:DrawHUD()
	if self.ShowMenu and !IsValid(self.Menu) then
		self.Menu = vgui.Create("DFrame")
		self.Menu:SetTitle("프리미엄 티클 몬스터")
		self.Menu:SetSize(400, 120)
		self.Menu:SetPos(ScrW() / 2 - self.Menu:GetWide() / 2, ScrH() / 2 - self.Menu:GetTall() / 2)
		self.Menu:MakePopup()
		self.Menu:SetKeyboardInputEnabled(false)
		self.Menu:SetMouseInputEnabled(true)
		
		local current = vgui.Create("DLabel", self.Menu)
		current:SetText("팔 두께: " .. (self.MeleeSize > 5 and "8" or self.MeleeSize < 5 and "2" or "5"))
		current:SizeToContents()
		current:CenterHorizontal()
		current:AlignTop(30)
		
		local addbutton = vgui.Create("DButton", self.Menu)
		addbutton:SetText("+5")
		addbutton:SizeToContents()
		addbutton:SetPos(200 - addbutton:GetWide() / 2 - 80, 60)
		addbutton.DoClick = function()
			self.MeleeSize = 8
			current:SetText("팔 두께: " .. (self.MeleeSize > 5 and "8" or self.MeleeSize < 5 and "2" or "5"))
			current:SizeToContents()
			current:CenterHorizontal()
			current:AlignTop(30)
		end
		
		local defaultbutton = vgui.Create("DButton", self.Menu)
		defaultbutton:SetText("기본값")
		defaultbutton:SizeToContents()
		defaultbutton:SetPos(200 - defaultbutton:GetWide() / 2, 60)
		defaultbutton.DoClick = function()
			self.MeleeSize = 5
			current:SetText("팔 두께: " .. (self.MeleeSize > 5 and "8" or self.MeleeSize < 5 and "2" or "5"))
			current:SizeToContents()
			current:CenterHorizontal()
			current:AlignTop(30)
		end
		
		local subbutton = vgui.Create("DButton", self.Menu)		
		subbutton:SetText("-5")
		subbutton:SizeToContents()
		subbutton:SetPos(200 + subbutton:GetWide() / 2 + 80, 60)
		subbutton.DoClick = function()
			self.MeleeSize = 2
			current:SetText("팔 두께: " .. (self.MeleeSize > 5 and "8" or self.MeleeSize < 5 and "2" or "5"))
			current:SizeToContents()
			current:CenterHorizontal()
			current:AlignTop(30)
		end
	elseif !self.ShowMenu and IsValid(self.Menu) then 
		self.Menu:Remove()
	end
	self.BaseClass.DrawHUD(self)
end