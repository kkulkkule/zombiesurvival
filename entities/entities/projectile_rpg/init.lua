 ENT.Type 			= "anim"  
 ENT.PrintName			= "90mm High Explosive"  
 ENT.Author			= "Generic Default"  
 ENT.Contact			= "AIDS"  
 ENT.Purpose			= "SPLODE"  
 ENT.Instructions			= "LAUNCH"  
 
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Damage = 250

if SERVER then

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

function ENT:Think()

  if self.timeleft < CurTime() then
    self.Entity:StopSound("ignite_rpg")
    self.Entity:Remove()				
  end

	Table	={} 			//Table name is table name
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
      util.BlastDamageExExceptAttacker(self.Entity, self.Owner, tr.HitPos, 450, self.Damage, DMG_BLAST)
      local trace = {}
      trace.filter = {self}
      trace.mins = Vector(-30, -30, -30)
      trace.maxs = Vector(40, 40, 40)
      for _, v in pairs(ents.FindInSphere(tr.HitPos, 450)) do
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
            tr1.Entity:ThrowFromPositionSetZ(tr1.StartPos, 450, nil, false)
          else
            tr1.Entity:ThrowFromPositionSetZ(tr1.StartPos, 100, nil, false)
          end
          table.insert(trace.filter, tr1.Entity)
        end
      end
      local effectdata = EffectData()
      effectdata:SetOrigin(tr.HitPos)			// Where is hits
      effectdata:SetNormal(tr.HitNormal)		// Direction of particles
      effectdata:SetEntity(self.Entity)		// Who done it?
      effectdata:SetScale(1.8)			// Size of explosion
      effectdata:SetRadius(tr.MatType)		// What texture it hits
      effectdata:SetMagnitude(18)			// Length of explosion trails
      util.Effect( "m9k_gdcw_cinematicboom", effectdata )
      util.ScreenShake(tr.HitPos, 10, 5, 1, 3000 )
      util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
      self.Entity:SetNWBool("smoke", false)
      self.Entity:Remove()	
      self.Entity:StopSound("ignite_rpg")
  end
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector - (self.flightvector/200) + Vector(math.Rand(-0.1,0.1), math.Rand(-0.1,0.1),math.Rand(-0.05,0.05)) + Vector(0,0,-0.111)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
end

if CLIENT then

 function ENT:Draw()              
 self.Entity:DrawModel()       // Draw the model.   
 end
 
   function ENT:Initialize()
	pos = self:GetPos()
	self.emitter = ParticleEmitter( pos )
 end
 
 function ENT:Think()
	if (self.Entity:GetNWBool("smoke")) then
	pos = self:GetPos()
		for i=0, (5) do
			local particle = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + (self:GetUp() * -100 * i))
			if (particle) then
				particle:SetVelocity((self:GetUp() * -2000)+(VectorRand()* 100) )
				particle:SetDieTime( math.Rand( 2, 5 ) )
				particle:SetStartAlpha( math.Rand( 5, 7 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 30, 40 ) )
				particle:SetEndSize( math.Rand( 130, 150 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1, 1) )
				particle:SetColor( 200 , 200 , 200 ) 
 				particle:SetAirResistance( 200 ) 
 				particle:SetGravity( Vector( 100, 0, 0 ) ) 	
			end
		
		end
	end
end

end

sound.Add( {
	name = "ignite_rpg",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitchstart = 95,
	pitchend = 110,
	sound = "weapons/rpg/ignite_trail.wav"
} )