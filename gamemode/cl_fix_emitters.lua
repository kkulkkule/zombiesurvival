local meta = FindMetaTable("CLuaEmitter")

if !meta then return end

GM.MaxProjectiles = GM.MaxProjectiles or 2048
GM.Projectiles = GM.Projectiles or 0

meta.OldAdd = meta.OldAdd or meta.Add
FindMetaTable("CLuaParticle").OldDieTime = FindMetaTable("CLuaParticle").OldDieTime or FindMetaTable("CLuaParticle").SetDieTime
function meta:Add(mat, pos)
  local particle = self.OldAdd(self, mat, pos)
  if GAMEMODE.Projectiles >= tonumber(GAMEMODE.MaxProjectiles) then
    getmetatable(particle).SetDieTime = function(self, time)
      GAMEMODE.Projectiles = math.max(GAMEMODE.Projectiles - 1, 0)
      return getmetatable(particle).OldDieTime(self, 0)
    end
  else
    getmetatable(particle).SetDieTime = function(self, time)
      timer.Simple(time, function()
        GAMEMODE.Projectiles = math.max(GAMEMODE.Projectiles - 1, 0)
      end)
      return getmetatable(particle).OldDieTime(self, time)
    end
  end
  
  GAMEMODE.Projectiles = (GAMEMODE.Projectiles or 0) + 1
  return particle
end

meta.OldFinish = meta.OldFinish or meta.Finish
function meta:Finish()
  meta.OldFinish(self)
end