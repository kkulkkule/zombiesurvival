hook.Add("InitPostEntityMap", "Adding", function()
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(1094, -651, 128))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-240, -690, 319))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-360, -2713, 303))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(60, -4387, 427))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(1318, -4350, 428))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(181, 161, 137))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-1382, -2050, 488))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-2880, -280, 157))
		ent:Spawn()
	end
	local ent = ents.Create("info_player_zombie")
	if ent:IsValid() then
		ent:SetPos(Vector(-2362, 717, 296))
		ent:Spawn()
	end
end)