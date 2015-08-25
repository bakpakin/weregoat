local Character = class "Character"
Character.isCharacter = true
Character.isSolid = true
Character.layer = "fg"

local grid1280 = anim8.newGrid(128, 128, 1280, 1280, 0, 0, 0)
local grid1152 = anim8.newGrid(128, 128, 1152, 1152, 0, 0, 0)
local grid1024 = anim8.newGrid(128, 128, 1024, 1024, 0, 0, 0)
local grid896 = anim8.newGrid(128, 128, 896, 896, 0, 0, 0)
local grid768 = anim8.newGrid(128, 128, 768, 768, 0, 0, 0)
local grid640 = anim8.newGrid(128, 128, 640, 640, 0, 0, 0)

local an100 = anim8.newAnimation(grid1280('1-10', '1-10'), 1/60, "pauseAtEnd")
local an100r = anim8.newAnimation(grid1280('10-1', '2-1'), 1/60, "pauseAtEnd")
local an70 = anim8.newAnimation(grid1152('1-9', '1-7', '1-7', 8), 1/60, "pauseAtEnd")
local an60 = anim8.newAnimation(grid1024('1-8', '1-7', '1-4', 8), 1/60)
local an60p = anim8.newAnimation(grid1024('1-8', '1-6'), 1/60, "pauseAtEnd")
local an60p2 = anim8.newAnimation(grid1024('1-8', 7, '1-4', 8), 1/60, "pauseAtEnd")
local an40 = anim8.newAnimation(grid896('1-7', '1-5', '1-5', 6), 1/60)
local an35 = anim8.newAnimation(grid768('1-6', '1-5', '1-5', 6), 1/60)
local an35p = anim8.newAnimation(grid768('1-6', '1-5', '1-5', 6), 1/60, "pauseAtEnd")
local an30 = anim8.newAnimation(grid768('1-6', '1-5'), 1/60)
local an30p = anim8.newAnimation(grid768('1-6', '1-5'), 1/60, "pauseAtEnd")
local an30pr = anim8.newAnimation(grid768('6-1', '5-1'), 1/60, "pauseAtEnd")
local an20 = anim8.newAnimation(grid640('1-5', '1-4'), 1/60)
local an10 = anim8.newAnimation(grid640('1-5', '1-2'), 1/60, "pauseAtEnd")
local an10reverse = anim8.newAnimation(grid640('5-1', '2-1'), 1/60, "pauseAtEnd")

Character.grid1024 = grid1024
Character.grid896 = grid896
Character.grid768 = grid768
Character.grid640 = grid640
Character.an60 = an60
Character.an40 = an40
Character.an35 = an35
Character.an30 = an30
Character.an30p = an30p
Character.an20 = an20
Character.gravity = 2200

function Character:init(args)
    args = args or {}
    self.gravity = args.gravity
    self.action = args.action or "standing"
    self.direction = args.direction or "right"
    self.name = args.name or "Joe Bob"
    self.position = args.position or {x = args.x or 0, y = args.y or 1000}
    self.velocity = args.velocity or {x = 0, y = 0}
    self.aabb = args.aabb or {x = 0, y = 0, w = PLAYER_WIDTH, h = PLAYER_HEIGHT}
    self.feedTime = args.feedTime or 3
    self.feedTimer = args.feedTimer or self.feedTime
    self.standSprite = args.standSprite or assets.img_npc_standing
    self.runAnimation = args.runAnimation or an30:clone()
    self.runSprite = args.runSprite or assets.img_npc_run
    self.standAnimation = args.standAnimation or an60:clone()
    self.walkSprite = args.walkSprite or assets.img_npc_walking
    self.walkAnimation = args.walkAnimation or an60:clone()
    self.deathSprite = args.deathSprite or assets.img_npc_death
    self.deathAnimation = args.deathAnimation or an35p:clone()
    self.shootSprite = args.shootSprite or assets.img_npc_shoot
    self.shootAnimation = args.shootAnimation or an70:clone()
    self.hostile = args.hostile

    --only for player
    self.hideSprite = args.hideSprite or assets.img_player_hide
    self.hideAnimation = args.hideAnimation or an30p:clone()
    self.unhideSprite = args.unhideSprite or assets.img_player_hide
    self.unhideAnimation = args.unhideAnimation or an30pr:clone()
    self.crouchSprite = args.crouchSprite or assets.img_player_crouch
    self.crouchAnimation = args.crouchAnimation or an10:clone()
    self.getupSprite = args.getupSprite or assets.img_player_crouch
    self.getupAnimation = args.getupAnimation or an10reverse:clone()
    self.chargeSprite = args.chargeSprite or assets.img_player_charge
    self.chargeAnimation = args.chargeAnimation or an60p:clone()
    self.chargegetupSprite = args.chargegetupSprite or assets.img_player_charge
    self.chargegetupAnimation = args.chargegetupAnimation or an60p2:clone()
    self.kickSprite = args.kickSprite or assets.img_player_kick
    self.kickAnimation = args.kickAnimation or an35p:clone()
    self.feedSprite = args.feedSprite or assets.img_player_feed
    self.feedAnimation = args.feedAnimation or an100:clone()
    self.feedgetupSprite = args.feedgetupSprite or assets.img_player_feed
    self.feedgetupAnimation = args.feedgetupAnimation or an100r:clone()

    self.hitbox = args.hitbox or {x = 32, y = 32, w = 64, h = 96}
    self.dialog = nil

    self.sprite = self.standSprite
    self.animation = self.walkAnimation
    self.walkSound = args.walkSound or assets.snd_walk60:clone()
    self.chargeSound = args.chargeSound or assets.snd_walk30:clone()
    self.color = args.color or {255, 255, 255, 255}
end

function Character:getPoint(xlerp, ylerp)
    return self.position.x + self.aabb.x + self.aabb.w * xlerp, self.position.y + self.aabb.y + self.aabb.h * ylerp
end

function Character:onLeave()
    self.chargeSound:stop()
    self.walkSound:stop()
end

function Character:onAdd()
    if self.dialog then
        self.world:add(self.dialog)
    end
end

function Character:getBounds()
    return self.position.x + self.hitbox.x, self.position.y + self.hitbox.y, self.hitbox.w, self.hitbox.h
end

function Character:onRemove()
    self.chargeSound:stop()
    self.walkSound:stop()
    if self.dialog then
        self.world:remove(self.dialog)
    end
end

function Character:kill(x, y)
    if self.isDead then return end
    local e = self
    e.action = "death"
    e.velocity.x = x or 0
    e.velocity.y = y or 0
    e.isDead = true
    if e.velocity.x > 20 then
        e.direction = "left"
    elseif e.velocity.x < -20 then
        e.direction = "right"
    end
end

function Character:fadeAndDisappear()
    if self.isFading then return end
    self.isFading = true
    flux.to(self.color, 1.5, {[4] = 0}):oncomplete(function()
        self.world:remove(self)
        REMAINING_PEOPLE = REMAINING_PEOPLE - 1
        if REMAINING_PEOPLE == 0 then
            gamestate.current():transitionTo(NIGHT_CLEAR_STATE)
        end
    end)
end

local WALK_SPEED = 60
local ACCELERATION = 3000
local FRICTION = 2600
local JUMP = 730

function Character:update(dt)
    local e = self
    local p = e.position
    local v = e.velocity
    local a = e.action
    local d = e.direction == "left" and -1 or 1
    local ws = e.walkSpeed or WALK_SPEED
    local ac = e.accekeration or ACCELERATION
    local fr = e.friction or FRICTION
    local sf = e.slideFriction or SLIDE_FRICTION
    if e.resetAnimation then
        e.resetAnimation:gotoFrame(e.resetFrame or 1)
        e.resetAnimation:resume()
        e.resetAnimation = nil
        e.resetFrame = nil
    end
    if a == "walking" then
        v.x = math.min(ws, math.max(-ws, v.x + d * dt * ac))
        if e.animation ~= e.walkAnimation then
            e.walkAnimation:gotoFrame(13)
        end
        e.animation = e.walkAnimation
        e.sprite = e.walkSprite
    elseif a == "running" then
        v.x = math.min(ws * 3.5, math.max(-ws * 3.5, v.x + d * dt * ac))
        if e.animation ~= e.runAnimation then
            e.runAnimation:gotoFrame(13)
        end
        e.animation = e.runAnimation
        e.sprite = e.runSprite
    elseif a == "standing" then
        if e.animation ~= e.standAnimation then
            e.standAnimation:gotoFrame(1)
        end
        e.animation = e.standAnimation
        e.sprite = e.standSprite
    elseif a == "getup" then
        e.animation = e.getupAnimation
        e.sprite = e.getupSprite
        if e.animation.status == "paused" then
            e.action = "standing"
            e.resetAnimation = e.getupAnimation
        end
    elseif a == "charge" then
        v.x = math.min(ws * 3, math.max(-ws * 3, v.x + d * dt * ac))
        if e.animation ~= e.chargeAnimation then
            e.chargeAnimation:gotoFrame(1)
            e.chargeAnimation:resume()
        end
        e.animation = e.chargeAnimation
        e.sprite = e.chargeSprite
        e.chargeTimer = 2
        if e.animation.status == "paused" then
            e.action = "chargegetup"
        end
    elseif a == "chargegetup" then
        if e.animation ~= e.chargegetupAnimation then
            e.chargegetupAnimation:gotoFrame(1)
            e.chargegetupAnimation:resume()
        end
        e.animation = e.chargegetupAnimation
        e.sprite = e.chargegetupSprite
        if e.animation.status == "paused" then
            e.action = "standing"
        end
    elseif a == "kick" then
        if e.animation ~= e.kickAnimation then
            e.kickAnimation:gotoFrame(1)
            e.kickAnimation:resume()
        end
        e.animation = e.kickAnimation
        e.sprite = e.kickSprite
        e.kickTimer = 1
        if e.animation.status == "paused" then
            e.action = "standing"
        end
    elseif a == "feed" then
        if e.animation ~= e.feedAnimation then
            e.feedAnimation:gotoFrame(1)
            e.feedAnimation:resume()
        end
        e.animation = e.feedAnimation
        e.sprite = e.feedSprite
        if e.animation.status == "paused" then
            e.resetFrame = 21
            e.resetAnimation = e.feedAnimation
        end
    elseif a == "feedgetup" then
        e.animation = e.feedgetupAnimation
        e.sprite = e.feedgetupSprite
        if e.animation.status == "paused" then
            e.action = "standing"
            e.resetAnimation = e.animation
        end
    elseif a == "shoot" then
        e.animation = e.shootAnimation
        e.sprite = e.shootSprite
        if e.animation.status == "paused" then
            e.action = "standing"
            e.animation:gotoFrame(1)
        end
    elseif a == "crouch" then
        if e.animation ~= e.crouchAnimation then
            e.crouchAnimation:gotoFrame(1)
        end
        e.animation = e.crouchAnimation
        e.sprite = e.crouchSprite
    elseif a == "hide" then
        if e.animation ~= e.hideAnimation then
            e.hideAnimation:gotoFrame(1)
        end
        e.animation = e.hideAnimation
        e.sprite = e.hideSprite
    elseif a == "unhide" then
        e.animation = e.unhideAnimation
        e.sprite = e.unhideSprite
        if e.animation.status == "paused" then
            e.action = "standing"
            e.resetAnimation = e.animation
        end
    elseif a == "death" then
        if e.animation ~= e.deathAnimation then
            e.deathAnimation:gotoFrame(1)
        end
        e.animation = e.deathAnimation
        e.sprite = e.deathSprite
    end
    e.animation:resume()
    if a ~= "kick" then e.kicking = false end
    if a ~= "crouch" then e.crouching = false end
    if a ~= "feed" then e.feeding = false end
    if a ~= "charge" then e.charging = false end
    if a ~= "hide" then e.hiding = false end
    if e.grounded and not (a == "walking" or a == "charge" or a == "running") then
        if v.x > 0 then
            v.x = math.max(0, v.x - dt * fr)
        elseif v.x < 0 then
            v.x = math.min(0, v.x + dt * fr)
        end
    end
    if a == "walking" then
        self.chargeSound:stop()
        if not self.walkSound:isPlaying() then
            self.walkSound:play()
        end
    elseif a == "charge" or a == "running" then
        self.walkSound:stop()
        if not self.chargeSound:isPlaying() then
            self.chargeSound:play()
        end
    else
        self.chargeSound:stop()
        self.walkSound:stop()
    end
end

function Character:say(time, text)
    self:sayPlain(("[%s](follow; textbox; shake; color: 255, 0, 0; fade:%f)"):format(text, time))
end

function Character:sayPlain(text)
    if not self.world then return end
    local x, y = self:getPoint(0.5, 0)
    if self.dialog then
        self.world:remove(self.dialog)
    end
    assets.snd_bloop:play()
    self.dialog = Text(x - 200, y - 30, text, {
        font = assets.fnt_small,
        color = function(dt, c, r, g, b)
            local _, _, _, a = lg.getColor()
            lg.setColor(r, g, b, a)
        end,
        followInit = function(c)
            c.xoff = c.x - self.position.x
            c.yoff = c.y - self.position.y
        end,
        follow = function(dt, c)
            c.anchor_x = self.position.x + c.xoff
            c.anchor_y = self.position.y + c.yoff
            c.x = c.anchor_x
            c.y = c.anchor_y
        end,
        textboxInit = function(c)
            c.t = 0
        end,
        textbox = function(dt, c)
            c.t = c.t + dt
            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(r, g, b, 0)
            if c.t > c.position*0.05 then
                love.graphics.setColor(r, g, b, 255)
            end
        end,
        shakeInit = function(c)
            c.anchor_x = c.x
            c.anchor_y = c.y
        end,
        shake = function(dt, c)
            c.x = c.anchor_x + math.random(-1, 1)
            c.y = c.anchor_y + math.random(-1, 1)
        end,
        fadeInit = function(c, time)
            c.fadefactor = 255
            c.dFade = 255 / time
        end,
        fade = function(dt, c)
            c.fadefactor = math.max(0, c.fadefactor - dt * c.dFade)
            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(r, g, b, c.fadefactor)
        end,
        wrap_width = 400,
        align_center = true,
        layer = "ffg"
    })
    self.world:add(self.dialog)
end

function Character:draw()
    local x = self.position.x + self.aabb.x + self.aabb.w/2
    local y = self.position.y + self.aabb.y + self.aabb.h
    lg.setColor(255, 255, 255)
    lg.draw(assets.img_shadow, x - 64, y - 16)
end

return Character
