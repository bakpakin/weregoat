local Character = require "src.entities.Character"
local NPC = class ("NPC", Character)
NPC.isAi = true

--NPC.lightColor = {255, 255, 255, 50}
--NPC.lightRadius = 150

function NPC:update(dt)
    Character.update(self, dt)
    local p = self.position
    local v = self.velocity
    if p.x < 0 then
        p.x = 0
        v.x = 0
    end
    if p.x > W - self.aabb.w then
        p.x = W - self.aabb.w
        v.x = 0
    end
end

return NPC
