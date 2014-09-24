local function pointslabelThink(self)
	local points = MySelf:GetPoints()
	if self.m_LastPoints ~= points then
		self.m_LastPoints = points

		self:SetText("남은 포인트: "..points)
		self:SizeToContents()
	end
end

hook.Add("Think", "PointsShopThink", function()
	local pan = GAMEMODE.m_PointsShop
	if pan and pan:Valid() and pan:IsVisible() then
		local newstate = not GAMEMODE:GetWaveActive()
		if newstate ~= pan.m_LastNearArsenalCrate then
			pan.m_LastNearArsenalCrate = newstate

			if newstate then
				pan.m_DiscountLabel:SetText("웨이브 쉬는 시간엔 " .. GAMEMODE.ArsenalCrateDiscountPercentage.."% 할인!")
				pan.m_DiscountLabel:SetTextColor(COLOR_GREEN)
			else
				pan.m_DiscountLabel:SetText("청약철회 불가!")
				pan.m_DiscountLabel:SetTextColor(COLOR_GRAY)
			end

			pan.m_DiscountLabel:SizeToContents()
			pan.m_DiscountLabel:AlignRight(8)
		end

		local mx, my = gui.MousePos()
		local x, y = pan:GetPos()
		if mx < x - 16 or my < y - 16 or mx > x + pan:GetWide() + 16 or my > y + pan:GetTall() + 16 then
			pan:SetVisible(false)
			surface.PlaySound("npc/dog/dog_idle3.wav")
		end
	end
end)

local function PointsShopCenterMouse(self)
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	gui.SetMousePos(x + w * 0.5, y + h * 0.5)
end

local ammonames = {
	["pistol"] = "pistolammo",
	["buckshot"] = "shotgunammo",
	["smg1"] = "smgammo",
	["ar2"] = "assaultrifleammo",
	["357"] = "rifleammo",
	["XBowBolt"] = "crossbowammo"
}

local warnedaboutammo = CreateClientConVar("_zs_warnedaboutammo", "0", true, false)
local function PurchaseDoClick(self)
	if not warnedaboutammo:GetBool() then
		local itemtab = FindItem(self.ID)
		if itemtab and itemtab.SWEP then
			local weptab = weapons.GetStored(itemtab.SWEP)
			if weptab and weptab.Primary and weptab.Primary.Ammo and ammonames[weptab.Primary.Ammo] then
				RunConsoleCommand("_zs_warnedaboutammo", "1")
				Derma_Message("Be sure to buy extra ammo. Weapons purchased do not contain any extra ammo!", "Warning")
			end
		end
	end
	
	if self.Callback then
		self.Callback(LocalPlayer())
	end

	RunConsoleCommand("zs_pointsshopbuy", self.ID)
end

local function BuyAmmoDoClick(self)
	RunConsoleCommand("zs_pointsshopbuy", "ps_"..self.AmmoType)
end

local function worthmenuDoClick()
	MakepWorth()
	GAMEMODE.m_PointsShop:Close()
end

local function ItemPanelThink(self)
	local itemtab = FindItem(self.ID)
	local premium = LocalPlayer():GetPremium() or false
	if itemtab then
		local newstate = MySelf:GetPoints() >= math.ceil(itemtab.Worth * ((premium and itemtab.Category ~= ITEMCAT_RETURNS) and 0.85 or 1) * (GAMEMODE.m_PointsShop.m_LastNearArsenalCrate and GAMEMODE.ArsenalCrateMultiplier or 1)) and not (itemtab.NoClassicMode and GAMEMODE:IsClassicMode())
		if newstate ~= self.m_LastAbleToBuy then
			self.m_LastAbleToBuy = newstate
			if newstate then
				self:AlphaTo(255, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_WHITE)
				self.m_BuyButton:SetImage("icon16/accept.png")
			else
				self:AlphaTo(90, 0.75, 0)
				self.m_NameLabel:SetTextColor(COLOR_RED)
				self.m_BuyButton:SetImage("icon16/exclamation.png")
			end

			self.m_BuyButton:SizeToContents()
		end
	end
end

local function PointsShopThink(self)
	if GAMEMODE:GetWave() ~= self.m_LastWaveWarning and not GAMEMODE:GetWaveActive() and CurTime() >= GAMEMODE:GetWaveStart() - 10 and CurTime() > (self.m_LastWaveWarningTime or 0) + 11 then
		self.m_LastWaveWarning = GAMEMODE:GetWave()
		self.m_LastWaveWarningTime = CurTime()

		surface.PlaySound("ambient/alarms/klaxon1.wav")
		timer.Simple(0.6, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(1.2, function() surface.PlaySound("ambient/alarms/klaxon1.wav") end)
		timer.Simple(2, function() surface.PlaySound("vo/npc/Barney/ba_hurryup.wav") end)
	end
end

function GM:OpenPointsShop()
	if self.m_PointsShop and self.m_PointsShop:Valid() then
		self.m_PointsShop:SetVisible(true)
		self.m_PointsShop:CenterMouse()
		return
	end

	local wid, hei = 480, math.max(ScrH() * 0.5, 400)

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:Center()
	frame:SetDeleteOnClose(false)
	frame:SetTitle(" ")
	frame:SetDraggable(false)
	if frame.btnClose and frame.btnClose:Valid() then frame.btnClose:SetVisible(false) end
	if frame.btnMinim and frame.btnMinim:Valid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:Valid() then frame.btnMaxim:SetVisible(false) end
	frame.CenterMouse = PointsShopCenterMouse
	frame.Think = PointsShopThink
	self.m_PointsShop = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, "포인트 상점", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()
	local subtitle = EasyLabel(topspace, "좀비 대재앙에서 생존하기 위한 모든 것!", "ZSHUDFontTiny", COLOR_WHITE)
	subtitle:CenterHorizontal()
	subtitle:MoveBelow(title, 4)

	local _, y = subtitle:GetPos()
	topspace:SetTall(y + subtitle:GetTall() + 4)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local tt = vgui.Create("DImage", topspace)
	tt:SetImage("gui/info")
	tt:SizeToContents()
	tt:SetPos(8, 8)
	tt:SetMouseInputEnabled(true)
	tt:SetTooltip("This shop is armed with the QUIK - Anti-zombie backstab device.\nMove your mouse outside of the shop to quickly close it!")

	local wsb = EasyButton(topspace, "자본 메뉴", 8, 4)
	wsb:AlignRight(8)
	wsb:AlignTop(8)
	wsb.DoClick = worthmenuDoClick


	local bottomspace = vgui.Create("DPanel", frame)
	bottomspace:SetWide(topspace:GetWide())

	local pointslabel = EasyLabel(bottomspace, "Points to spend: 0", "ZSHUDFontTiny", COLOR_GREEN)
	pointslabel:AlignTop(4)
	pointslabel:AlignLeft(8)
	pointslabel.Think = pointslabelThink

	local lab = EasyLabel(bottomspace, " ", "ZSHUDFontTiny")
	lab:AlignTop(4)
	lab:AlignRight(4)
	frame.m_DiscountLabel = lab

	local _, y = lab:GetPos()
	bottomspace:SetTall(y + lab:GetTall() + 4)
	bottomspace:AlignBottom(8)
	bottomspace:CenterHorizontal()

	local topx, topy = topspace:GetPos()
	local botx, boty = bottomspace:GetPos()

	local propertysheet = vgui.Create("DPropertySheet", frame)
	propertysheet:SetSize(wid - 8, boty - topy - 8 - topspace:GetTall())
	propertysheet:MoveBelow(topspace, 4)
	propertysheet:CenterHorizontal()

	local isclassic = GAMEMODE:IsClassicMode()

	for catid, catname in ipairs(GAMEMODE.ItemCategories) do
		local hasitems = false
		for i, tab in ipairs(GAMEMODE.Items) do
			if tab.Category == catid and tab.PointShop then
				hasitems = true
				break
			end
		end

		if hasitems then
			local list = vgui.Create("DPanelList", propertysheet)
			list:SetPaintBackground(false)
			propertysheet:AddSheet(catname, list, GAMEMODE.ItemCategoryIcons[catid], false, false)
			list:EnableVerticalScrollbar(true)
			list:SetWide(propertysheet:GetWide() - 16)
			list:SetSpacing(2)
			list:SetPadding(2)
			local premium = LocalPlayer():GetNetworkedVar("hspremium") or false
			
			for i, tab in ipairs(GAMEMODE.Items) do
				if tab.Category == catid and tab.PointShop then
					local itempan = vgui.Create("DPanel")
					itempan:SetSize(list:GetWide(), 40)
					itempan.ID = tab.Signature or i
					itempan.Think = ItemPanelThink
					list:AddItem(itempan)

					local mdlframe = vgui.Create("DPanel", itempan)
					mdlframe:SetSize(32, 32)
					mdlframe:SetPos(4, 4)

					local weptab = weapons.GetStored(tab.SWEP) or tab
					local mdl = tab.Model or weptab.WorldModel
					if mdl then
						local mdlpanel = vgui.Create("DModelPanel", mdlframe)
						mdlpanel:SetSize(mdlframe:GetSize())
						mdlpanel:SetModel(mdl)
						local mins, maxs = mdlpanel.Entity:GetRenderBounds()
						mdlpanel:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5))
						mdlpanel:SetLookAt((mins + maxs) / 2)
					end

					if tab.SWEP or tab.Countables then
						local counter = vgui.Create("ItemAmountCounter", itempan)
						counter:SetItemID(i)
					end

					local name = tab.Name or ""
					local namelab = EasyLabel(itempan, name, "ZSHUDFontSmall", COLOR_WHITE)
					namelab:SetPos(42, itempan:GetTall() * 0.5 - namelab:GetTall() * 0.5)
					itempan.m_NameLabel = namelab

					local pricelab = EasyLabel(itempan, tostring(math.ceil(tab.Worth * ((premium and tab.Category ~= ITEMCAT_RETURNS) and 0.85 or 1))).." 포인트", "ZSHUDFontTiny")
					pricelab:SetPos(itempan:GetWide() - 20 - pricelab:GetWide(), 4)
					itempan.m_PriceLabel = pricelab

					local button = vgui.Create("DImageButton", itempan)
					button:SetImage("icon16/lorry_add.png")
					button:SizeToContents()
					button:SetPos(itempan:GetWide() - 20 - button:GetWide(), itempan:GetTall() - 20)
					button:SetTooltip("Purchase "..name)
					button.ID = itempan.ID
					button.Callback = tab.Callback
					button.DoClick = PurchaseDoClick
					itempan.m_BuyButton = button

					if weptab and weptab.Primary then
						local ammotype = weptab.Primary.Ammo
						if ammonames[ammotype] then
							local ammobutton = vgui.Create("DImageButton", itempan)
							ammobutton:SetImage("icon16/add.png")
							ammobutton:SizeToContents()
							ammobutton:CopyPos(button)
							ammobutton:MoveLeftOf(button, 2)
							ammobutton:SetTooltip("탄약 구매")
							ammobutton.AmmoType = ammonames[ammotype]
							ammobutton.DoClick = BuyAmmoDoClick
						end
					end

					if tab.Description then
						itempan:SetTooltip(tab.Description)
					end

					if tab.NoClassicMode and isclassic or tab.NoZombieEscape and GAMEMODE.ZombieEscape then
						itempan:SetAlpha(120)
					end
				end
			end
		end
	end

	frame:MakePopup()
	frame:CenterMouse()
end
GM.OpenPointShop = GM.OpenPointsShop
