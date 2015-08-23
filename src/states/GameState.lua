local State = require "src.states.State"
local GameState = class("GameState", State)
local LightSystem = require "src.systems.LightSystem"

local lg = love.graphics

local function addBackStuff(self)
    self.world:add(
        {
            position = {x = 0, y = GROUND_Y},
            sprite = assets.img_ground,
            layer = "bg"
        },
        {
            position = {x = W / 2 - 128, y = H / 2 - 128},
            velocity = {x = 0, y = 7},
            sprite = assets.img_moon,
            layer = "bbg",
            aabb = {x = 0, y = 0, w = 256, h = 256},
            lightColor = {255, 255, 255, 128},
            lightRadius = 200
        }
    )
end

function GameState:init(...)
    State.init(self, ...)
    local ls = self.world:add(LightSystem(self.camera))
    self.lightSystem = ls
    self.world:refresh()
    self.world:setSystemIndex(ls, -5)
    addBackStuff(self)
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
end

function GameState:leave()
    self.world:remove(self.player)
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

GameState.scenes = {
    {
        {
            position = {x = 0, y = 0},
            layer = "bbg",
            sprite = assets.img_stars,
            scale = 0.5
        },
        entities.NPC{x = 800, direction = "left"},
        entities.NPC{x = 200, direction = "left"},
        entities.NPC{x = 350, direction = "right"},
        entities.NPC{x = 1200, direction = "left"}
    },
    {
        {
            position = {x = 0, y = 0},
            layer = "bbg",
            sprite = assets.img_stars,
            scale = 0.5
        }
    },
    {
        {
            position = {x = 0, y = 0},
            layer = "bbg",
            sprite = assets.img_stars,
            scale = 0.5
        },
        entities.NPC{x = 500, direction = "left"}
    }
}

return GameState
