GM.ZombieEscapeWeapons = {
	"weapon_zs_zedeagle",
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm"
}

-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zscarts.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_OTHER = 5
ITEMCAT_TRAITS = 6
ITEMCAT_RETURNS = 7
ITEMCAT_UPGRADES = 8

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "총기",
	[ITEMCAT_AMMO] = "탄약",
	[ITEMCAT_MELEE] = "근접 무기",
	[ITEMCAT_TOOLS] = "도구",
	[ITEMCAT_OTHER] = "기타",
	[ITEMCAT_TRAITS] = "특성",
	[ITEMCAT_RETURNS] = "리턴",
	[ITEMCAT_UPGRADES] = "개조"
}

--[[
Humans select what weapons (or other things) they want to start with and can even save favorites. Each object has a number of 'Worth' points.
Signature is a unique signature to give in case the item is renamed or reordered. Don't use a number or a string number!
A human can only use 100 points (default) when they join. Redeeming or joining late starts you out with a random loadout from above.
SWEP is a swep given when the player spawns with that perk chosen.
Callback is a function called. Model is a display model. If model isn't defined then the SWEP model will try to be used.
swep, callback, and model can all be nil or empty
]]
GM.Items = {}
function GM:AddItem(signature, name, desc, category, worth, swep, callback, model, worthshop, pointshop)
	local tab = {Signature = signature, Name = name, Description = desc, Category = category, Worth = worth or 0, SWEP = swep, Callback = callback, Model = model, WorthShop = worthshop, PointShop = pointshop}
	self.Items[#self.Items + 1] = tab

	return tab
end

function GM:AddStartingItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem(signature, name, desc, category, points, worth, callback, model, true, false)
end

function GM:AddPointShopItem(signature, name, desc, category, points, worth, callback, model)
	return self:AddItem("ps_"..signature, name, desc, category, points, worth, callback, model, false, true)
end

-- Weapons are registered after the gamemode.
timer.Simple(0, function()
	for _, tab in pairs(GAMEMODE.Items) do
		if not tab.Description and tab.SWEP then
			local sweptab = weapons.GetStored(tab.SWEP)
			if sweptab then
				tab.Description = sweptab.Description
			end
		end
	end
end)

-- How much ammo is considered one 'clip' of ammo? For use with setting up weapon defaults. Works directly with zs_survivalclips
GM.AmmoCache = {}
GM.AmmoCache["ar2"] = 30 -- Assault rifles.
GM.AmmoCache["alyxgun"] = 24 -- Not used.
GM.AmmoCache["pistol"] = 12 -- Pistols.
GM.AmmoCache["smg1"] = 30 -- SMG's and some rifles.
GM.AmmoCache["357"] = 7 -- Rifles, especially of the sniper variety.
GM.AmmoCache["xbowbolt"] = 5 -- Crossbows
GM.AmmoCache["buckshot"] = 8 -- Shotguns
GM.AmmoCache["ar2altfire"] = 1 -- Not used.
GM.AmmoCache["slam"] = 1 -- Force Field Emitters.
GM.AmmoCache["rpg_round"] = 1 -- Not used. Rockets?
GM.AmmoCache["smg1_grenade"] = 1 -- Not used.
GM.AmmoCache["sniperround"] = 1 -- Barricade Kit
GM.AmmoCache["sniperpenetratedround"] = 1 -- Remote Det pack.
GM.AmmoCache["grenade"] = 1 -- Grenades.
GM.AmmoCache["thumper"] = 1 -- Gun turret.
GM.AmmoCache["gravity"] = 1 -- Unused.
GM.AmmoCache["battery"] = 30 -- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"] = 1 -- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"] = 1 -- Not used.
GM.AmmoCache["airboatgun"] = 1 -- Arsenal crates.
GM.AmmoCache["striderminigun"] = 1 -- Message beacons.
GM.AmmoCache["helicoptergun"] = 1 --Resupply boxes.
GM.AmmoCache["spotlamp"] = 1
GM.AmmoCache["manhack"] = 1
GM.AmmoCache["pulse"] = 30
GM.AmmoCache["m249"] = 200
GM.AmmoCache["rpg"] = 1

-- These ammo types are available at ammunition boxes.
-- The amount is the ammo to give them.
-- If the player isn't holding a weapon that uses one of these then they will get smg1 ammo.
GM.AmmoResupply = {}
GM.AmmoResupply["ar2"] = 30
GM.AmmoResupply["alyxgun"] = GM.AmmoCache["alyxgun"]
GM.AmmoResupply["pistol"] = GM.AmmoCache["pistol"]
GM.AmmoResupply["smg1"] = 40
GM.AmmoResupply["357"] = GM.AmmoCache["357"]
GM.AmmoResupply["xbowbolt"] = GM.AmmoCache["xbowbolt"]
GM.AmmoResupply["buckshot"] = GM.AmmoCache["buckshot"]
GM.AmmoResupply["battery"] = 25
GM.AmmoResupply["pulse"] = GM.AmmoCache["pulse"]
GM.AmmoResupply["m249"] = 120
GM.AmmoResupply["rpg"] = 1





-----------
-- Worth --
-----------

GM:AddStartingItem("pshtr", "'피슈터' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_peashooter")
GM:AddStartingItem("btlax", "'배틀액스' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_battleaxe")
GM:AddStartingItem("owens", "'오웬' 권총", nil, ITEMCAT_GUNS, 40, "weapon_zs_owens")
GM:AddStartingItem("blstr", "'블래스터' 샷건", nil, ITEMCAT_GUNS, 55, "weapon_zs_blaster")
GM:AddStartingItem("tossr", "'토져' SMG", nil, ITEMCAT_GUNS, 50, "weapon_zs_tosser")
GM:AddStartingItem("stbbr", "'스터버' 소총", nil, ITEMCAT_GUNS, 55, "weapon_zs_stubber")
GM:AddStartingItem("crklr", "'크래클러' 돌격소총", nil, ITEMCAT_GUNS, 50, "weapon_zs_crackler")
GM:AddStartingItem("z9000", "'Z9000' 펄스 권총", nil, ITEMCAT_GUNS, 60, "weapon_zs_z9000")

GM:AddStartingItem("2pcp", "2 권총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 2 , "pistol", true) end end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("2sgcp", "2 샷건 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 2, "buckshot", true) end end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("2smgcp", "2 SMG 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 2, "smg1", true) end end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("2arcp", "2 돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 2, "ar2", true) end end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("2rcp", "2 소총 탄약 박스", nil, ITEMCAT_AMMO, 15, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 2, "357", true) end end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("2pls", "3 펄스 라이플 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddStartingItem("3pcp", "3 권총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["pistol"] or 12) * 3, "pistol", true) end end, "models/Items/BoxSRounds.mdl")
GM:AddStartingItem("3sgcp", "3 샷건 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["buckshot"] or 8) * 3, "buckshot", true) end end, "models/Items/BoxBuckshot.mdl")
GM:AddStartingItem("3smgcp", "3 SMG 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["smg1"] or 30) * 3, "smg1", true) end end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("3arcp", "3 돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["ar2"] or 30) * 3, "ar2", true) end end, "models/Items/357ammobox.mdl")
GM:AddStartingItem("3rcp", "3 소총 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) if SERVER then pl:GiveAmmo((GAMEMODE.AmmoCache["357"] or 6) * 3, "357", true) end end, "models/Items/BoxSniperRounds.mdl")
GM:AddStartingItem("3pls", "3 펄스 라이플 탄약 박스", nil, ITEMCAT_AMMO, 20, nil, function(pl) pl:GiveAmmo((GAMEMODE.AmmoCache["pulse"] or 30) * 3, "pulse", true) end, "models/Items/combine_rifle_ammo01.mdl")

GM:AddStartingItem("zpaxe", "도끼", nil, ITEMCAT_MELEE, 30, "weapon_zs_axe")
GM:AddStartingItem("crwbar", "지렛대", nil, ITEMCAT_MELEE, 30, "weapon_zs_crowbar")
GM:AddStartingItem("stnbtn", "전기 충격기", nil, ITEMCAT_MELEE, 45, "weapon_zs_stunbaton")
GM:AddStartingItem("csknf", "칼", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddStartingItem("zpplnk", "판자", nil, ITEMCAT_MELEE, 10, "weapon_zs_plank")
GM:AddStartingItem("zpfryp", "프라이팬", nil, ITEMCAT_MELEE, 20, "weapon_zs_fryingpan")
GM:AddStartingItem("zpcpot", "냄비", nil, ITEMCAT_MELEE, 20, "weapon_zs_pot")
GM:AddStartingItem("pipe", "파이프", nil, ITEMCAT_MELEE, 45, "weapon_zs_pipe")
GM:AddStartingItem("hook", "갈고리", nil, ITEMCAT_MELEE, 30, "weapon_zs_hook")

GM:AddStartingItem("medkit", "메디컬 키트", nil, ITEMCAT_TOOLS, 50, "weapon_zs_medicalkit")
GM:AddStartingItem("medgun", "메딕 건", nil, ITEMCAT_TOOLS, 45, "weapon_zs_medicgun")
GM:AddStartingItem("150mkit", "150 메디컬 키트 에너지", "메디컬 키트 에너지를 150 회복한다.", ITEMCAT_TOOLS, 30, nil, function(pl) if SERVER then pl:GiveAmmo(150, "Battery", true) end end, "models/healthvial.mdl")
GM:AddStartingItem("arscrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddStartingItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 70, "weapon_zs_resupplybox").Countables = "prop_resupplybox"
local item = GM:AddStartingItem("infturret", "적외선 터렛", nil, ITEMCAT_TOOLS, 75, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.Countables = {"weapon_zs_gunturret", "prop_gunturret"}
item.NoClassicMode = true
GM:AddStartingItem("wrench", "메카닉 렌치", nil, ITEMCAT_TOOLS, 15, "weapon_zs_wrench").NoClassicMode = true
GM:AddStartingItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 45, "weapon_zs_hammer").NoClassicMode = true
GM:AddStartingItem("6nails", "못", "바리케이드 건설에 필요한 못 열두 개.", ITEMCAT_TOOLS, 20, nil, function(pl) if SERVER then pl:GiveAmmo(12, "GaussEnergy", true) end end, "models/Items/BoxMRounds.mdl")
GM:AddStartingItem("junkpack", "판자 더미", nil, ITEMCAT_TOOLS, 40, "weapon_zs_boardpack")
GM:AddStartingItem("spotlamp", "스팟 램프", nil, ITEMCAT_TOOLS, 25, "weapon_zs_spotlamp").Countables = "prop_spotlamp"
GM:AddStartingItem("msgbeacon", "메세지 비콘", nil, ITEMCAT_TOOLS, 10, "weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
local item = GM:AddStartingItem("manhack", "맨핵", nil, ITEMCAT_TOOLS, 60, "weapon_zs_manhack")
item.Countables = "prop_manhack"

--GM:AddStartingItem("ffemitter", "Force Field Emitter", nil, ITEMCAT_TOOLS, 60, "weapon_zs_ffemitter").Countables = "prop_ffemitter"

GM:AddStartingItem("stone", "돌맹이", nil, ITEMCAT_OTHER, 5, "weapon_zs_stone")
GM:AddStartingItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 30, "weapon_zs_grenade")
GM:AddStartingItem("detpck", "C4", nil, ITEMCAT_OTHER, 35, "weapon_zs_detpack").Countables = "prop_detpack"
GM:AddStartingItem("oxtank", "산소 탱크", "물 속에 더 오래 잠수할 수 있게 해준다.", ITEMCAT_OTHER, 15, "weapon_zs_oxygentank")
GM:AddStartingItem("tacticallight", "소형 스포트라이트", "무기에 소형 스포트라이트를 장착해 먼 곳의 어두운 장소에 있는 적을 볼 수 있다.", ITEMCAT_UPGRADES, 5, nil, function(pl) pl:SetTacticalLight(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddStartingItem("lasersight", "레이저사이트", "무기에 레이저 사이트를 장착한다.", ITEMCAT_UPGRADES, 5, nil, function(pl) pl:SetLaserSight(true) end, "models/healthvial.mdl").NoClassicMode = true

GM:AddStartingItem("10hp", "맷집", "체력을 10 증가시킨다.", ITEMCAT_TRAITS, 10, nil, function(pl) if SERVER then pl:SetMaxHealth(pl:GetMaxHealth() + 10) pl:SetHealth(pl:GetMaxHealth()) end end, "models/healthvial.mdl")
GM:AddStartingItem("25hp", "트레이너", "체력을 25 증가시킨다.", ITEMCAT_TRAITS, 20, nil, function(pl) if SERVER then pl:SetMaxHealth(pl:GetMaxHealth() + 25) pl:SetHealth(pl:GetMaxHealth()) end end, "models/items/healthkit.mdl")
local item = GM:AddStartingItem("5spd", "경보", "이동 속도를 약간 증가시킨다.", ITEMCAT_TRAITS, 10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 7 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
local item = GM:AddStartingItem("10spd", "육상선수", "이동 속도를 증가시킨다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) + 14 pl:ResetSpeed() end, "models/props_lab/jar01a.mdl")
item.NoClassicMode = true
item.NoZombieEscape = true
GM:AddStartingItem("bfhandy", "공돌이", "수리 회복량을 25% 증가시킨다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanRepairMultiplier = (pl.HumanRepairMultiplier or 1) + 0.25 end, "models/props_c17/tools_wrench01a.mdl")
GM:AddStartingItem("bfsurgeon", "의무병", "자신이 사용하는 메디컬 키트의 모든 회복량을 30% 증가시킨다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.HumanHealMultiplier = (pl.HumanHealMultiplier or 1) + 0.3 end, "models/healthvial.mdl")
GM:AddStartingItem("bfresist", "항체", "독 데미지가 더욱 빨리 회복된다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.BuffResistant = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfregen", "리제네레이터", "체력이 4초에 1씩 회복된다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffRegenerative = true end, "models/healthvial.mdl")
GM:AddStartingItem("bfmusc", "근육돼지", "무거운 물체도 들어 나를 수 있다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.BuffMuscular = true if SERVER then pl:DoMuscularBones() end end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("blueprint", "설계도", "설치물의 회수 속도가 50% 빨라진다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.Blueprint = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("sob", "균형 감각", "뒤로 걸을 때 더 빨리 걸을 수 있다.", ITEMCAT_TRAITS, 20, nil, function(pl) pl.SoB = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("willpower", "정신력", "출혈이 심해도 심각하게 느려지지 않는다.", ITEMCAT_TRAITS, 25, nil, function(pl) pl.Willpower = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("autoreload", "자동 장전", "총알이 다 떨어졌을 경우 자동으로 장전한다.", ITEMCAT_TRAITS, 5, nil, function(pl) pl.AutoReload = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("fastsight", "빠른 조준", "조준을 하고 푸는 시간이 75% 줄어든다.", ITEMCAT_TRAITS, 5, nil, function(pl) pl.FastSight = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("commando", "특공대", "조준을 하고 있는 중에 좀 더 빠르게 움직일 수 있다.", ITEMCAT_TRAITS, 15, nil, function(pl) pl.Commando = true end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("recoil", "충격 흡수", "반동을 좀 더 수월히 제어할 수 있다.", ITEMCAT_TRAITS, 30, nil, function(pl) pl:SetRecoil(true) end, "models/props_wasteland/kitchen_shelf001a.mdl")
GM:AddStartingItem("scout", "정찰병", "좀비를 마킹해 아군을 도울 수 있다.\n마킹당한 좀비는 10초동안 아군의 시야에 나타난다.\n사용 키(기본: E)를 눌러 사용한다.\n재사용 대기시간 20초", ITEMCAT_TRAITS, 5, nil, function(pl) pl.scout = true end, "models/props_wasteland/kitchen_shelf001a.mdl")

GM:AddStartingItem("dbfweak", "약골", "최대 체력이 30 줄어든다.", ITEMCAT_RETURNS, -15, nil, function(pl) if SERVER then pl:SetMaxHealth(math.max(1, pl:GetMaxHealth() - 30)) pl:SetHealth(pl:GetMaxHealth()) end pl.IsWeak = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfslow", "느림보", "최대 속도가 줄어든다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.HumanSpeedAdder = (pl.HumanSpeedAdder or 0) - 20 pl:ResetSpeed() pl.IsSlow = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfpalsy", "수전증", "정확히 조준할 수 없게 된다.", ITEMCAT_RETURNS, -5, nil, function(pl) if SERVER then pl:SetPalsy(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfhemo", "헤모필리아", "체력을 회복할 수 없다.", ITEMCAT_RETURNS, -15, nil, function(pl) if SERVER then pl:SetHemophilia(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfunluc", "거지", "상점 상자에서 아무것도 구매할 수 없다.", ITEMCAT_RETURNS, -25, nil, function(pl) if SERVER then pl:SetUnlucky(true) end end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfclumsy", "골다공증", "매우 쉽게 넉다운된다.", ITEMCAT_RETURNS, -25, nil, function(pl) pl.Clumsy = true end, "models/gibs/HGIBS.mdl")
GM:AddStartingItem("dbfnoghosting", "뚱땡이", "바리케이드를 통과해 지나갈 수 없다.", ITEMCAT_RETURNS, -20, nil, function(pl) pl.NoGhosting = true end, "models/gibs/HGIBS.mdl").NoClassicMode = true
GM:AddStartingItem("dbfnopickup", "팔 장애", "물체를 회수할 수 없다.", ITEMCAT_RETURNS, -10, nil, function(pl) pl.NoObjectPickup = true if SERVER then pl:DoNoodleArmBones() end end, "models/gibs/HGIBS.mdl")

------------
-- Points --
------------

GM:AddPointShopItem("deagle", "'좀비 드릴' 데저트 이글", nil, ITEMCAT_GUNS, 30, "weapon_zs_deagle")
GM:AddPointShopItem("glock3", "'크로스파이어' 글록 3", nil, ITEMCAT_GUNS, 30, "weapon_zs_glock3")
GM:AddPointShopItem("magnum", "'리코셰' 매그넘", nil, ITEMCAT_GUNS, 35, "weapon_zs_magnum")
GM:AddPointShopItem("eraser", "'이레이저' 전략 권총", nil, ITEMCAT_GUNS, 35, "weapon_zs_eraser")

GM:AddPointShopItem("uzi", "'스프레이어' Uzi 9mm", nil, ITEMCAT_GUNS, 70, "weapon_zs_uzi")
GM:AddPointShopItem("shredder", "'슈레더' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_smg")
GM:AddPointShopItem("bulletstorm", "'불릿 스톰' SMG", nil, ITEMCAT_GUNS, 70, "weapon_zs_bulletstorm")
GM:AddPointShopItem("silencer", "'사일렌서' SMG", nil, ITEMCAT_GUNS, 80, "weapon_zs_silencer")
GM:AddPointShopItem("hunter", "'헌터' 소총", nil, ITEMCAT_GUNS, 70, "weapon_zs_hunter")

GM:AddPointShopItem("reaper", "'리퍼' UMP", nil, ITEMCAT_GUNS, 80, "weapon_zs_reaper")
GM:AddPointShopItem("ender", "'엔더' 자동 샷건", nil, ITEMCAT_GUNS, 75, "weapon_zs_ender")
GM:AddPointShopItem("akbar", "'아크바' 돌격소총", nil, ITEMCAT_GUNS, 80, "weapon_zs_akbar")

GM:AddPointShopItem("stalker", "'스토커' 돌격소총", nil, ITEMCAT_GUNS, 125, "weapon_zs_m4")
GM:AddPointShopItem("inferno", "'인페르노' 돌격소총", nil, ITEMCAT_GUNS, 125, "weapon_zs_inferno")
GM:AddPointShopItem("annabelle", "'애나벨' 소총", nil, ITEMCAT_GUNS, 100, "weapon_zs_annabelle")
GM:AddPointShopItem("crossbow", "'임팰러' 크로스보우", nil, ITEMCAT_GUNS, 175, "weapon_zs_crossbow")


GM:AddPointShopItem("sweeper", "'스위퍼' 샷건", nil, ITEMCAT_GUNS, 200, "weapon_zs_sweepershotgun")
GM:AddPointShopItem("m249", "'전기톱' M249", nil, ITEMCAT_GUNS, 200, "weapon_zs_m249")
GM:AddPointShopItem("boomstick", "붐스틱", nil, ITEMCAT_GUNS, 200, "weapon_zs_boomstick")
GM:AddPointShopItem("slugrifle", "'티니' 슬러그 라이플", nil, ITEMCAT_GUNS, 200, "weapon_zs_slugrifle")
GM:AddPointShopItem("pulserifle", "'아도니스' 펄스 라이플", nil, ITEMCAT_GUNS, 225, "weapon_zs_pulserifle")
GM:AddPointShopItem("rpg", "'알라봉' RPG-7", nil, ITEMCAT_GUNS, 200, "weapon_zs_rpg")

GM:AddPointShopItem("pistolammo", "권총 탄약 박스", nil, ITEMCAT_AMMO, 6, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["pistol"] or 12, "pistol", true) end end, "models/Items/BoxSRounds.mdl")
GM:AddPointShopItem("shotgunammo", "샷건 탄약 박스", nil, ITEMCAT_AMMO, 7, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["buckshot"] or 8, "buckshot", true) end end, "models/Items/BoxBuckshot.mdl")
GM:AddPointShopItem("smgammo", "SMG 탄약 박스", nil, ITEMCAT_AMMO, 7, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["smg1"] or 30, "smg1", true) end end, "models/Items/BoxMRounds.mdl")
GM:AddPointShopItem("assaultrifleammo", "돌격소총 탄약 박스", nil, ITEMCAT_AMMO, 7, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["ar2"] or 30, "ar2", true) end end, "models/Items/357ammobox.mdl")
GM:AddPointShopItem("rifleammo", "소총 탄약 박스", nil, ITEMCAT_AMMO, 7, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["357"] or 6, "357", true) end end, "models/Items/BoxSniperRounds.mdl")
GM:AddPointShopItem("crossbowammo", "크로스보우 화살", nil, ITEMCAT_AMMO, 5, nil, function(pl) if SERVER then pl:GiveAmmo(1, "XBowBolt", true) end end, "models/Items/CrossbowRounds.mdl")
GM:AddPointShopItem("pulseammo", "펄스 에너지", nil, ITEMCAT_AMMO, 7, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["pulse"] or 30, "pulse", true) end end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddPointShopItem("m249ammo", "M249 탄약 박스", nil, ITEMCAT_AMMO, 11, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["m249"] or 30, "m249", true) end end, "models/Items/combine_rifle_ammo01.mdl")
GM:AddPointShopItem("rpgammo", "80mm HEAT (RPG) 1개", nil, ITEMCAT_AMMO, 16, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["rpg"] or 1, "rpg", true) end end, "models/props_junk/garbage_glassbottle001a.mdl")
GM:AddPointShopItem("axe", "도끼", nil, ITEMCAT_MELEE, 20, "weapon_zs_axe")
GM:AddPointShopItem("crowbar", "크로우바", nil, ITEMCAT_MELEE, 20, "weapon_zs_crowbar")
GM:AddPointShopItem("stunbaton", "전기 충격기", nil, ITEMCAT_MELEE, 25, "weapon_zs_stunbaton")
GM:AddPointShopItem("knife", "칼", nil, ITEMCAT_MELEE, 5, "weapon_zs_swissarmyknife")
GM:AddPointShopItem("shovel", "삽", nil, ITEMCAT_MELEE, 30, "weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer", "슬렛지 해머", nil, ITEMCAT_MELEE, 30, "weapon_zs_sledgehammer")



GM:AddPointShopItem("crphmr", "목수의 망치", nil, ITEMCAT_TOOLS, 50, "weapon_zs_hammer").NoClassicMode = true
GM:AddPointShopItem("board", "판자", nil, ITEMCAT_AMMO, 8, nil, function(pl) if SERVER then pl:GiveAmmo(GAMEMODE.AmmoCache["SniperRound"] or 1, "SniperRound", true) end end, "models/props_debris/wood_board06a.mdl").NoClassicMode = true
GM:AddPointShopItem("wrench", "메카닉 렌치", nil, ITEMCAT_TOOLS, 25, "weapon_zs_wrench").NoClassicMode = true
GM:AddPointShopItem("arsenalcrate", "상점 상자", nil, ITEMCAT_TOOLS, 50, "weapon_zs_arsenalcrate")
GM:AddPointShopItem("resupplybox", "보급 상자", nil, ITEMCAT_TOOLS, 150, "weapon_zs_resupplybox")
local item = GM:AddPointShopItem("infturret", "적외선 터렛", nil, ITEMCAT_TOOLS, 50, nil, function(pl)
	pl:GiveEmptyWeapon("weapon_zs_gunturret")
	pl:GiveAmmo(1, "thumper")
	pl:GiveAmmo(250, "smg1")
end)
item.NoClassicMode = true
GM:AddPointShopItem("barricadekit", "'이지스' 바리케이드 키트", nil, ITEMCAT_TOOLS, 125, "weapon_zs_barricadekit")
GM:AddPointShopItem("nail", "못", "못 한 개.", ITEMCAT_TOOLS, 3, nil, function(pl) if SERVER then pl:GiveAmmo(1, "GaussEnergy", true) end end, "models/crossbow_bolt.mdl").NoClassicMode = true
GM:AddPointShopItem("50mkit", "50 메디컬 키트 에너지", "메디컬 키트 에너지를 50 충전한다. 메디컬 키트가 있어야 사용할 수 있다.", ITEMCAT_TOOLS, 30, nil, function(pl) if SERVER then pl:GiveAmmo(50, "Battery", true) end end, "models/healthvial.mdl")
GM:AddPointShopItem("serge", "방탄복", "데미지의 25%를 최대 100까지 흡수한다.\n내구도가 다 닳기 전에 재구매하면 내구도가 수리된다.", ITEMCAT_TOOLS, 50, nil, function(pl) pl:SetSerge(100) end, "models/healthvial.mdl").NoClassicMode = true

GM:AddPointShopItem("desc", "총기 업그레이드::", "총기를 업그레이드합니다.", ITEMCAT_UPGRADES, 35, nil, function(pl) pl:SetCNanoHammer(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("tacticallight", "소형 스포트라이트", "무기에 소형 스포트라이트를 장착해 먼 곳의 어두운 장소에 있는 적을 볼 수 있다.", ITEMCAT_UPGRADES, 15, nil, function(pl) pl:SetTacticalLight(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("lasersight", "레이저사이트", "무기에 레이저 사이트를 장착한다.", ITEMCAT_UPGRADES, 15, nil, function(pl) pl:SetLaserSight(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("huntercharge", "헌터 소총 차져", "헌터 소총에 차지 기능을 장착한다.", ITEMCAT_UPGRADES, 30, nil, function(pl) pl:SetHunterCharge(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("compensator", "컴펜세이터", "모든 총기의 반동을 15% 줄여준다.", ITEMCAT_UPGRADES, 75, nil, function(pl) pl:SetCompensator(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("heavybarrel", "헤비배럴", "정조준시 명중률 10% 증가, 반동 8% 증가\n이동시 명중률 5% 증가.\n" .. 
                                    "명중률 증가 수치는 충격 흡수 특성보다 먼저 적용됩니다.\n" .. 
                                    "반동 증가 수치는 컴펜세이터 다음에 적용됩니다.", ITEMCAT_UPGRADES, 35, nil, function(pl) pl:SetHeavyBarrel(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("pistolgrip", "인체공학적 권총 그립", "권총의 명중률을 10% 올려줍니다.", ITEMCAT_UPGRADES, 45, nil, function(pl) pl:SetPistolGrip(true) end, "models/healthvial.mdl").NoClassicMode = true

GM:AddPointShopItem("desc", "도구 업그레이드::", "도구를 업그레이드합니다.", ITEMCAT_UPGRADES, 35, nil, function(pl) pl:SetCNanoHammer(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("cnanohammer", "신소재 망치", "목수의 망치 밎 해당 종류의 재사용 대기시간이 15% 감소합니다.", ITEMCAT_UPGRADES, 35, nil, function(pl) pl:SetCNanoHammer(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("elabohandle", "정교한 노루발", "목수의 망치 및 해당 종류로 바리케이드를 수리할 경우 일정 확률로 포인트를 얻는다.\n" ..
                                   "0.5%: 5 포인트\n" .. 
                                   "0.8%: 4 포인트\n" .. 
                                   "2%: 3 포인트\n" .. 
                                   "4%: 2 포인트\n"..
                                   "10%: 1 포인트\n", ITEMCAT_UPGRADES, 40, nil, function(pl) pl.elabohandle = true end, "models/healthvial.mdl").NoClassicMode = true
                                   
GM:AddPointShopItem("desc", "특성 업그레이드::", "특성을 업그레이드합니다.", ITEMCAT_UPGRADES, 35, nil, function(pl) pl:SetCNanoHammer(true) end, "models/healthvial.mdl").NoClassicMode = true
GM:AddPointShopItem("markupgrade", "정찰병 키트", "마킹한 좀비는 더 많은 피해를 입는다.\n일반 좀비: 15%, 보스 좀비: 8%", ITEMCAT_UPGRADES, 35, nil, function(pl) pl.markUpgraded = true end, "models/healthvial.mdl").NoClassicMode = true

GM:AddPointShopItem("grenade", "수류탄", nil, ITEMCAT_OTHER, 60, "weapon_zs_grenade")
GM:AddPointShopItem("detpck", "C4", nil, ITEMCAT_OTHER, 70, "weapon_zs_detpack")
-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "좀비 학살자", String = "%s님께서 %d마리의 좀비를 학살하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "깡패", String = "%s님께서 좀비에게 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "평화주의자", String = "%s님께서 살아있는 동안 단 한 마리의 좀비도 죽이지 않으셨습니다!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "조력자", String = "%s님께서 좀비 %d마리의 사살을 도우셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "최후의 생존자", String = "%s님께서 인간 최후의 생존자셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "외지인", String = "%s님이 좀비 스폰 지역에서 %d피트 떨어진 곳에서 사망하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "의무병", String = "%s님께서 동료의 체력을 %d만큼 회복시키셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "슈퍼 공돌이", String = "%s님께서 바리케이드를 %d만큼 수리하셨습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "까마귀 학살자", String = "%s님께서 %d마리의 불쌍한 까마귀를 학살하셨습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "잔혹한 학살자", String = "%s님께서 %d명의 뇌를 먹어치웠습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "네임드", String = "%s님께서 인간에게 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "종족 말살", String = "%s님께서 최후의 인간을 죽이셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "무쓸모", String = "%s님께서 %d번 학살당했습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "어리버리", String = "%s님은 좀비 스폰 지역에서 단지 %d피트 떨어진 곳에서 사망하셨습니다.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "판매원", String = "인간이 %s님의 상점상자에 %d포인트를 지불했습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "보급창고", String = "%s님의 보급 상자가 %d회 사용되었습니다.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SPAWNPOINT] = {Name = "소환사", String = "%s님께 %d마리의 좀비가 스폰되었습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_CROWFIGHTER] = {Name = "까마귀 파이터", String = "%s님께서 %d마리의 까마귀를 전멸시키셨습니다.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_CROWBARRICADEDAMAGE] = {Name = "영리한 까마귀", String = "%s님께서 까마귀가 되어 바리케이드에 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "바리케이드 디스트로이어", String = "%s님께서 바리케이드에 %d 데미지를 입히셨습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "둥지 파괴자", String = "%s님께서 %d개의 둥지를 파괴했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "둥지 마스터", String = "%d마리의 좀비가 %s님의 둥지를 통해 스폰했습니다.", Callback = genericcallback, Color = COLOR_LIMEGREEN}

-- Don't let humans use these models because they look like undead models. Must be lower case.
GM.RestrictedModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombine.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/corpse1.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl"
}

-- If a person has no player model then use one of these (auto-generated).
GM.RandomPlayerModels = {}
for name, mdl in pairs(player_manager.AllValidModels()) do
	if not table.HasValue(GM.RestrictedModels, string.lower(mdl)) then
		table.insert(GM.RandomPlayerModels, name)
	end
end

-- Utility function to setup a weapon's DefaultClip.
function GM:SetupDefaultClip(tab)
	tab.DefaultClip = math.ceil(tab.ClipSize * self.SurvivalClips * (tab.ClipMultiplier or 1))
end

GM.MaxSigils = CreateConVar("zs_maxsigils", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many sigils to spawn. 0 for none."):GetInt()
cvars.AddChangeCallback("zs_maxsigils", function(cvar, oldvalue, newvalue)
	GAMEMODE.MaxSigils = math.Clamp(tonumber(newvalue) or 0, 0, 10)
end)

GM.DefaultRedeem = CreateConVar("zs_redeem", "4", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The amount of kills a zombie needs to do in order to redeem. Set to 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_redeem", function(cvar, oldvalue, newvalue)
	GAMEMODE.DefaultRedeem = math.max(0, tonumber(newvalue) or 0)
end)

GM.WaveOneZombies = math.ceil(100 * CreateConVar("zs_waveonezombies", "0.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The percentage of players that will start as zombies when the game begins."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_waveonezombies", function(cvar, oldvalue, newvalue)
	GAMEMODE.WaveOneZombies = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.NumberOfWaves = CreateConVar("zs_numberofwaves", "6", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Number of waves in a game."):GetInt()
cvars.AddChangeCallback("zs_numberofwaves", function(cvar, oldvalue, newvalue)
	GAMEMODE.NumberOfWaves = tonumber(newvalue) or 1
end)

-- Game feeling too easy? Just change these values!
GM.ZombieSpeedMultiplier = math.ceil(100 * CreateConVar("zs_zombiespeedmultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.ceil(100 * CreateConVar("zs_zombiedamagemultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat()) * 0.01
cvars.AddChangeCallback("zs_zombiedamagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.TimeLimit = CreateConVar("zs_timelimit", "15", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
cvars.AddChangeCallback("zs_timelimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.TimeLimit = tonumber(newvalue) or 15
	if GAMEMODE.TimeLimit ~= -1 then
		GAMEMODE.TimeLimit = GAMEMODE.TimeLimit * 60
	end
end)

GM.RoundLimit = CreateConVar("zs_roundlimit", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many times the game can be played on the same map. -1 means infinite or only use time limit. 0 means once."):GetInt()
cvars.AddChangeCallback("zs_roundlimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.RoundLimit = tonumber(newvalue) or 3
end)

-- Static values that don't need convars...

-- Initial length for wave 1.
GM.WaveOneLength = 220

-- For Classic Mode
GM.WaveOneLengthClassic = 120

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15

-- For Classic Mode
GM.TimeAddedPerWaveClassic = 10

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 2

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = 1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 120

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 90

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20

-- Time in seconds between end round and next map.
GM.EndGameTime = 30

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 2

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/lasthuman.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/Prototype2Resurrection.mp3")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/BlackMesaBlastPit3.mp3")
WAVESTARTMUSICS = {}
for _, v in pairs(file.Find("sound/zombiesurvival/wavemusic/*", "GAME")) do
	-- resource.AddFile("sound/zombiesurvival/wavemusic/" .. v)
	table.insert(WAVESTARTMUSICS, v)
end
WAVESTARTMUSICD = {
	["ChildishGambinoHeartbeat.mp3"] = 256,
	["CSGOGOGOGO.mp3"] = 141,
	["CSGOLockNLoad.mp3"] = 137,
	["CSGOStormTheFront.mp3"] = 133,
	["GTA5ABitOfAnAwkwardSituation.mp3"] = 282,
	["GTA5ALegitimateBusinessMan.mp3"] = 180,
	["GTA5FreshMeat.mp3"] = 246,
	["GTA5MinorTurbulence.mp3"] = 273,
	["GTA5NorthYanktonMemories.mp3"] = 242,
	["GTA5SoundsKindOfFruity.mp3"] = 288,
	["GTA5TheAgencyHeist.mp3"] = 202,
	["GTA5WelcomeToLosSantos.mp3"] = 150,
	["GTA5WeWereSetUp.mp3"] = 210,
	["HotlineMiamiKnock.mp3"] = 245,
	["MDFinale.mp3"] = 203,
	["MDTechnicolor.mp3"] = 387,
	["MtEdenDubstepEscape.mp3"] = 185,
	["PD3TimeWindow.mp3"] = 159,
	["PD4BlackYelloMoebius.mp3"] = 221,
	["PD6FullForceForward.mp3"] = 251,
	["PD7TickTock.mp3"] = 167,
	["PD8FuseBox.mp3"] = 208,
	["PD9Razormind.mp3"] = 274,
	["PD10CallingAllUnits.mp3"] = 162,
	["PD16ArmedToTheDeath.mp3"] = 360,
	["PD17SirensInTheDistance.mp3"] = 247,
	["PD18WantedDeadOrAlive.mp3"] = 220,
	["PD19DeathWish.mp3"] = 191,
	["PD20ShadowsandTrickery.mp3"] = 283,
	["PD23OdeToGreedInst.mp3"] = 193,
	["PD28Supersledge.mp3"] = 272,
	["PD29EvilEye.mp3"] = 204,
	["PD30HotPursuit.mp3"] = 192,
	["PD31TheGauntlet.mp3"] = 223,
	["PD32SomethingWickedThisWayComes.mp3"] = 267,
	["Terran01.mp3"] = 250,
	["Terran02.mp3"] = 259,
	["Terran03.mp3"] = 285,
	["Terran04.mp3"] = 228,
	["Terran05.mp3"] = 191
}
WAVESTARTMUSICNEXT = 0
LASTHUMANMUSICNEXT = 0
-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("music/stingers/HL1_stinger_song28.mp3")
