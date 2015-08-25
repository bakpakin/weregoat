local Character = require "src.entities.Character"
local DeathState = require "src.states.DeathState"
local Player = class ("Player", Character)
Player.layer = "mg"
Player.cameraTrack = true

local NORMAL_COLOR = {255, 255, 255}
local HIDE_COLOR = {128, 128, 128}

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
    self.color = NORMAL_COLOR
    self.feedSound = assets.snd_eat:clone()
    self.feedSound:setLooping(true)
end

function Player:kill(...)
    if self.isDead then return end
    Character.kill(self, ...)
    flux.cron(2.1, function()
        gamestate.current():transitionTo(DeathState())
    end)
end

function Player:onLeave()
    self.world:remove(self)
end

function Player:update(dt)
    Character.update(self, dt)
    if self.controllable and not self.isDead then
        local n = love.keyboard.isDown(CONTROLS.CHARGE)
        local w = love.keyboard.isDown(CONTROLS.HIDE)
        local m = love.keyboard.isDown(CONTROLS.KICK)
        local a = love.keyboard.isDown(CONTROLS.LEFT)
        local s = love.keyboard.isDown(CONTROLS.CROUCH)
        local d = love.keyboard.isDown(CONTROLS.RIGHT)
        local e = love.keyboard.isDown(CONTROLS.FEED)

        self.chargeTimer = math.max(0, (self.chargeTimer or 0) - dt)
        self.kickTimer = math.max(0, (self.kickTimer or 0) - dt)

        if s then
            self.action = "crouch"
            self.crouching = true
        elseif w then
            self.action = "hide"
            self.hiding = true
        elseif m and (self.kickTimer == 0 or self.action == "kick") then
            self.action = "kick"
            self.kicking = true
        elseif n and (self.chargeTimer == 0 or self.action == "charge") then
            self.action = "charge"
            self.charging = true
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
            elseif self.hiding then
                self.action = "unhide"
            elseif
                self.action ~= "getup" and
                self.action ~= "feedgetup" and
                self.action ~= "chargegetup" and
                self.action ~= "unhide" and
                not self.kicking then

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

        if self.prey then
            self.prey.feedTimer = math.max(0, self.prey.feedTimer - dt)
            if self.prey.feedTimer <= 0 then
                self.prey:fadeAndDisappear()
                self.prey = nil
            end
            self.feedSound:play()
        end
    end
    if self.action ~= "feed" or not self.prey then
        self.feedSound:stop()
    end
    self.color = self.hiding and HIDE_COLOR or NORMAL_COLOR
end

return Player
