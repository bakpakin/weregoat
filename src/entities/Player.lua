local Character = require "src.entities.Character"
local Player = class ("Player", Character)
Player.layer = "fg"
Player.cameraTrack = true
Player.lightColor = {255, 255, 255}
Player.lightRadius = 200

function Player:init(x)
    Character.init(self, {
        position = { x = x or 400, y = 1000 },
        walkAnimation = Character.an40:clone(),
        walkSprite = assets.img_player_walking,
        standAnimation = Character.an40:clone(),
        standSprite = assets.img_player_standing
    })
    self.walkSpeed = 120
    self.color = {255, 255, 255}
    self.controllable = true
end

function Player:update(dt)
    if self.controllable then
        local w = love.keyboard.isDown("w")
        local a = love.keyboard.isDown("a")
        local s = love.keyboard.isDown("s")
        local d = love.keyboard.isDown("d")

        if d and not a then
            self.action = "walking"; self.direction = "right"
        elseif a and not d then
            self.action = "walking"; self.direction = "left"
        else
            self.action = "standing"
        end

        local p = self.position
        local v = self.velocity
        if p.x < 0 then
            if not gamestate.current():toLeft() then
                p.x = 0
                v.x = 0
            else
                self.controllable = false
                self.action = "walking"
                self.direction = "left"
            end
        end
        if p.x > W - self.aabb.w then
            if not gamestate.current():toRight() then
                p.x = W - self.aabb.w
                v.x = 0
            else
                self.controllable = false
                self.action = "walking"
                self.direction = "right"
            end
        end
    end
end

return Player