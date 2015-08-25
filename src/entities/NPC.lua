local Character = require "src.entities.Character"
local NPC = class ("NPC", Character)
NPC.isAi = true

function NPC:init(...)
    Character.init(self, ...)
    if self.hostile then
        self.walkSprite = assets.img_red_walking
        self.standSprite = assets.img_red_standing
        self.shootSprite = assets.img_red_shoot
        self.deathSprite = assets.img_red_death
    end
end

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
