local State = require "src.states.State"
local GameState = class("GameState", State)

local lg = love.graphics

local function makeHud()
    local hud = {}
    hud.layer = "hud"
    hud.draw = function(self)
        lg.setColor(128, 40, 40, 128)
        lg.rectangle("fill", 15, 15, 310 * (1 - (PLAYER.chargeTimer or 0) / 4), 40)
        lg.setColor(40, 40, 128, 128)
        lg.rectangle("fill", 15, 70, 310 * (1 - (PLAYER.kickTimer or 0) / 1), 40)
        lg.setColor(255, 255, 255, 128)
        lg.setFont(assets.fnt_small)
        lg.printf("Charge", 15, 15, 310, "center")
        lg.printf("Kick", 15, 70, 310, "center")
    end
    return hud
end

local function addBackStuff(self)
    local starscale = 0.8
    self.world:add(
        {
            position = {x = 0, y = 0},
            parallaxAnchor = {x = W / 2, y = H / 2},
            parallax = 0.25,
            aabb = {x = 0, y = 0, w = starscale * 2800, h = starscale * 1200},
            layer = "bbbg",
            color = {188, 188, 188, 255},
            sprite = assets.img_stars,
            scale = starscale
        },
        {
            position = {x = 0, y = 0},
            parallaxAnchor = {x = W / 2, y = H / 2},
            parallax = 0.25,
            sprite = assets.img_moon,
            color = {190, 190, 170, 255},
            layer = "bbbg",
            aabb = {x = 0, y = 0, w = 256, h = 256}
        },
        {
            position = {x = 0, y = GROUND_Y - 10},
            sprite = assets.img_ground,
            layer = "bg"
        }
    )
end

function GameState:init(...)
    State.init(self, ...)
    addBackStuff(self)
    self.world:add(makeHud())
end

function GameState.generate()

end

function GameState.resetAll()
    local states = {}
    GameState.states = states
    for i, scene in ipairs(GameState.scenes) do
        states[i] = GameState(unpack(scene))
        states[i].sceneIndex = i
    end
end

function GameState.getScene(index)
    if not GameState.states then
        GameState.resetAll()
    end
    return GameState.states[index]
end

function GameState:enter(from, fromside)
    startMusic()
    State.enter(self, from, scene, fromside)
    GameState.currentSceneIndex = self.sceneIndex
    local p
    if fromside == "left" then
        p = self.world:addEntity(entities.Player(-50))
    else
        p = self.world:addEntity(entities.Player(W - PLAYER_WIDTH + 50))
    end
    p.controllable = false
    p.action = "walking"
    self.player = p
    PLAYER = p
    p.direction = fromside == "left" and "right" or "left"
    self.world:refresh()
end

function GameState:leave()
    for e in pairs(self.world.entities) do
        if e.leave then e:leave() end
    end
    self.world:remove(self.player)
    self.world:refresh()
end

function GameState:toLeft()
    local cs = GameState.currentSceneIndex
    if cs > 1 then
        self:transitionTo(GameState.getScene(cs - 1), "right")
        return true
    end
    return false
end

function GameState:toRight()
    local cs = GameState.currentSceneIndex
    if cs < #GameState.scenes then
        self:transitionTo(GameState.getScene(cs + 1), "left")
        return true
    end
    return false
end

local function light(x, y)
    return {
        position = {x = x, y = y},
        sprite = assets.img_lamp,
        lightColor = {255, 255, 190, 150},
        lightRadius = 350
    }
end

GameState.scenes = {
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings1,
            layer = "bg",
        },
        --entities.NPC{x = 800},
        light(890, 650),
        light(1080, 650),
        light(300, 650),
        light(100, 650),
        light(1600, 650),
        light(2000, 650),
    },
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings2,
            layer = "bg",
        }
    },
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings3,
            layer = "bg",
        }
    }
}

return GameState
