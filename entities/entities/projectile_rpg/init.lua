ENT.Type 			= "anim"  
ENT.PrintName		= "90mm High Explosive"  
ENT.Author			= "Generic Default"  
ENT.Contact			= "AIDS"  
ENT.Purpose			= "SPLODE"  
ENT.Instructions	= "LAUNCH"  
 
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Damage = 250
ENT.BlastRadius = 450

AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()   
    self.flightvector = self.Entity:GetUp() * ((250*52.5)/(1/engine.TickInterval()))
    self.timeleft = CurTime() + 10
    self.Owner = self:GetOwner()
    self.Entity:SetModel( "models/props_junk/garbage_glassbottle001a.mdl" )
    self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
    self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
    self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3           
    self.Entity:SetColor(Color(45,55,40,255))
    self.Entity:EmitSound("ignite_rpg")

    Glow = ents.Create("env_sprite")
    Glow:SetKeyValue("model","orangecore2.vmt")
    Glow:SetKeyValue("rendercolor","255 150 100")
    Glow:SetKeyValue("scale","0.3")
    Glow:SetPos(self.Entity:GetPos())
    Glow:SetParent(self.Entity)
    Glow:Spawn()
    Glow:Activate()
    self.Entity:SetNWBool("smoke", true)
end   

local remove = ENT.Remove
function ENT:Remove()
    self.Entity:StopSound("ignite_rpg")
    return remove(self)
end

function ENT:Think()
    if self.timeleft < CurTime() then
        self.Entity:StopSound("ignite_rpg")
        self.Entity:Remove()				
    end

    Table = {} 			//Table name is table name
    Table[1]	=self.Owner 		//The person holding the gat
    Table[2]	=self.Entity 		//The cap

    local trace = {}
    trace.start = self.Entity:GetPos()
    trace.endpos = self.Entity:GetPos() + self.flightvector
    trace.filter = Table
    local tr = util.TraceLine( trace )


    if tr.HitSky then
        self.Entity:Remove()
        return true
    end

    if tr.Hit then
        if !tr.Entity:IsPlayer() or (tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_ZOMBIE) then
            util.BlastDamageExExceptAttacker(self.Entity, self.Owner, tr.HitPos, self.BlastRadius, self.Damage, DMG_BLAST)
            
            local trace = {}
            trace.filter = {self}
            trace.mins = Vector(-30, -30, -30)
            trace.maxs = Vector(40, 40, 40)
            
            for _, v in pairs(ents.FindInSphere(tr.HitPos, self.BlastRadius)) do
                trace.start = tr.StartPos
                if trace.start.z < v:NearestPoint(trace.start).z then
                    trace.start.z = v:NearestPoint(trace.start).z + 50
                end
                trace.endpos = v:NearestPoint(trace.start)
                
                local tr1 = util.TraceHull(trace)
                if tr1.Hit then
                    if tr1.Entity:IsWorld() then
                        continue
                    end
                    if !tr1.Entity:IsPlayer() then
                        continue
                    end
                    if tr1.Entity:Team() == self.Owner:Team() and tr1.Entity ~= self.Owner then
                        continue
                    end
                    if tr1.Entity == self.Owner then
                        tr1.Entity:ThrowFromPositionSetZ(tr1.StartPos, 250, 0.5, false)
                        table.insert(trace.filter, tr1.Entity)
                    elseif tr1.Entity:IsPlayer() and tr1.Entity:Team() == TEAM_ZOMBIE then
                        tr1.Entity:ThrowFromPositionSetZ(tr1.StartPos, 300, 0.38, false)
                        table.insert(trace.filter, tr1.Entity)
                    else
                        tr1.Entity:ThrowFromPositionSetZ(tr1.StartPos, 800, nil, false)
                    end
                end
            end
            local effectdata = EffectData()
            effectdata:SetOrigin(tr.HitPos)			// Where is hits
            effectdata:SetNormal(tr.HitNormal)		// Direction of particles
            effectdata:SetEntity(self.Entity)		// Who done it?
            effectdata:SetScale(1.8)			// Size of explosion
            effectdata:SetRadius(tr.MatType)		// What texture it hits
            effectdata:SetMagnitude(18)			// Length of explosion trails
            util.Effect( "explosion", effectdata )
            util.ScreenShake(tr.HitPos, 10, 5, 1, 3000 )
            util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
            self.Entity:SetNWBool("smoke", false)
            self.Entity:StopSound("ignite_rpg")
            self.Entity:Remove()
        end
    end
    self.Entity:SetPos(self.Entity:GetPos() + self.flightvector / 15)
    self.flightvector = self.flightvector - (self.flightvector/200) + Vector(math.Rand(-0.1,0.1), math.Rand(-0.1,0.1),math.Rand(-0.05,0.05)) + Vector(0,0,-0.111)
    self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
    self.Entity:NextThink( CurTime() )
    return true
end

sound.Add({
	name = "ignite_rpg",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitchstart = 95,
	pitchend = 110,
	sound = "weapons/rpg/ignite_trail.wav"
})