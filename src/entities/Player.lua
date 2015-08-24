local Character = require "src.entities.Character"
local Player = class ("Player", Character)
Player.layer = "fg"
Player.cameraTrack = true
Player.lightRadius = 250

function Player:init(x)
    Character.init(self, {
        position = { x = x or 400, y = 1000 },
        walkAnimation = Character.an40:clone(),
        walkSprite = assets.img_player_walking,
        standAnimation = Character.an40:clone(),
        standSprite = assets.img_player_standing,
        deathSprite = assets.img_player_death,
        deathAnimation = Character.an30p
    })
    self.walkSpeed = 135
    self.color = {255, 255, 255}
    self.controllable = true

end

function Player:update(dt)
    Character.update(self, dt)
    if self.controllable and not self.isDead then
        local n = love.keyboard.isDown("n")
        local m = love.keyboard.isDown("m")
        local a = love.keyboard.isDown("a")
        local s = love.keyboard.isDown("s")
        local d = love.keyboard.isDown("d")
        local w = love.keyboard.isDown("w")
        local e = love.keyboard.isDown("e")

        self.chargeTimer = math.max(0, (self.chargeTimer or 0) - dt)
        self.kickTimer = math.max(0, (self.kickTimer or 0) - dt)
        if m and (self.kickTimer == 0 or self.action == "kick") then
            self.action = "kick"
            self.kicking = true
        elseif n and (self.chargeTimer == 0 or self.action == "charge") then
            self.action = "charge"
            self.charging = true
        elseif w then
            self.action = "death"
            self.isDead = true
        elseif s then
            self.action = "crouch"
            self.crouching = true
        elseif d and not a then
            self.action = "walking"; self.direction = "right"
        elseif a and not d then
            self.action = "walking"; self.direction = "left"
        elseif e then
            self.action = "feed"
            self.feeding = true
        else
            if self.crouching then
                self.action = "getup"
            elseif self.feeding then
                self.action = "feedgetup"
            elseif self.charging then
                self.action = "chargegetup"
            elseif self.action ~= "getup" and self.action ~= "feedgetup" and self.action ~= "chargegetup" and not self.kicking then
                self.action = "standing"
            end
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
