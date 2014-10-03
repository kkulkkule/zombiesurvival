ENT.Type 			= "anim"  
ENT.PrintName			= "90mm High Explosive"  
ENT.Author			= "Generic Default"  
ENT.Contact			= "AIDS"  
ENT.Purpose			= "SPLODE"  
ENT.Instructions			= "LAUNCH"  
 
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

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
        particle:SetDieTime( math.Rand( 2, 3 ) )
        particle:SetStartAlpha( math.Rand( 5, 7 ) )
        particle:SetEndAlpha( 0 )
        particle:SetStartSize( math.Rand( 5, 10 ) )
        particle:SetEndSize( math.Rand( 25, 40 ) )
        particle:SetRoll( math.Rand(0, 360) )
        particle:SetRollDelta( math.Rand(-1, 1) )
        particle:SetColor( 200 , 200 , 200 ) 
        particle:SetAirResistance( 200 ) 
        particle:SetGravity( Vector( 100, 0, 0 ) ) 	
      end
    end
  end
end