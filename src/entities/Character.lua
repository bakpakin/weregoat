local Character = class "Character"
Character.isCharacter = true
Character.isSolid = true
Character.layer = "mg"

local grid1024 = anim8.newGrid(128, 128, 1024, 1024, 0, 0, 0)
local grid896 = anim8.newGrid(128, 128, 896, 896, 0, 0, 0)
local grid768 = anim8.newGrid(128, 128, 768, 768, 0, 0, 0)
local grid640 = anim8.newGrid(128, 128, 640, 640, 0, 0, 0)
local an60 = anim8.newAnimation(grid1024('1-8', '1-7', '1-4', 8), 1/60)
local an60p = anim8.newAnimation(grid1024('1-8', '1-7', '1-4', 8), 1/60, "pauseAtEnd")
local an40 = anim8.newAnimation(grid896('1-7', '1-5', '1-5', 6), 1/60)
local an35 = anim8.newAnimation(grid768('1-6', '1-5', '1-5', 6), 1/60)
local an30 = anim8.newAnimation(grid768('1-6', '1-5'), 1/60)
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
    self.standSprite = args.standSprite or assets.img_npc_standing
    self.standAnimation = args.standAnimation or an60:clone()
    self.walkSprite = args.walkSprite or assets.img_npc_walking
    self.walkAnimation = args.walkAnimation or an60:clone()
    self.deathSprite = args.deathSprite or assets.img_npc_death
    self.deathAnimation = args.deathAnimation or an35:clone()
    self.hostile = args.hostile

    --only for player
    self.crouchSprite = args.crouchSprite or assets.img_player_crouch
    self.crouchAnimation = args.crouchAnimation or an10:clone()
    self.getupSprite = args.getupSprite or assets.img_player_crouch
    self.getupAnimation = args.getupAnimation or an10reverse:clone()
    self.chargeSprite = args.chargeSprite or assets.img_player_charge
    self.chargeAnimation = args.chargeAnimation or an60p:clone()

    self.hitbox = args.hitbox or {x = 32, y = 32, w = 64, h = 96}
    self.dialog = nil

    self.sprite = self.standSprite
    self.animation = self.walkAnimation
end

function Character:getPoint(xlerp, ylerp)
    return self.position.x + self.aabb.x + self.aabb.w * xlerp, self.position.y + self.aabb.y + self.aabb.h * ylerp
end

function Character:onAdd()
    if self.dialog then
        self.world:add(self.dialog)
    end
end

function Character:onRemove()
    if self.dialog then
        self.world:remove(self.dialog)
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
