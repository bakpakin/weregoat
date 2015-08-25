local State = require "src.states.State"
local GameState = class("GameState", State)
local CollisionSystem = require "src.systems.CollisionSystem"

local lg = love.graphics

local function makeHud()
    local hud = {}
    hud.layer = "hud"
    hud.draw = function(self)
        lg.setColor(128, 40, 40, 128)
        lg.rectangle("fill", 15, 15, 310 * (1 - (PLAYER.chargeTimer or 0) / 2), 40)
        lg.setColor(40, 40, 128, 128)
        lg.rectangle("fill", 15, 70, 310 * (1 - (PLAYER.kickTimer or 0) / 1), 40)
        lg.setColor(255, 255, 255, 128)
        lg.setFont(assets.fnt_small)
        lg.printf("Charge", 15, 15, 310, "center")
        lg.printf("Kick", 15, 70, 310, "center")
        lg.setColor(255, 255, 255, 255)
        lg.setFont(assets.fnt_medium)
        lg.printf(("Remaining Townspeople: %i"):format(REMAINING_PEOPLE), 15, 15, W - 30, "right")
        lg.printf(("Night %i"):format(DIFFICULTY + 1), 15, 15, W - 30, "center")
        if PLAYER.feeding and PLAYER.prey then
            lg.setColor(255, 0, 0, 128)
            local x, y = PLAYER.position.x + PLAYER.aabb.x, PLAYER.position.y + PLAYER.aabb.y
            lg.rectangle("fill", x, y - 45, PLAYER.aabb.w * PLAYER.prey.feedTimer / PLAYER.prey.feedTime, 15)
        end
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
            parallaxAnchor = {x = W / 2, y = H / 6},
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

function GameState:init(difficulty, ...)
    State.init(self, ...)
    self.difficulty = difficulty or 0
    self.world:add(CollisionSystem())
    addBackStuff(self)
    self.world:add(makeHud())
end

function GameState.clearAllDifficulties()
    GameState.startSceneGroups = {}
end

function GameState.clearDifficulty(difficulty)
    GameState.startSceneGroups[difficulty] = nil
end

local function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

function GameState.resetToDifficulty(difficulty)
    difficulty = difficulty or 0
    GameState.difficulty = difficulty
    local ss = GameState.startSceneGroups[difficulty]
    if not ss then -- generate it
        ss = {}
        GameState.startSceneGroups[difficulty] = ss
        for i, scene in ipairs(GameState.scenes) do
            ss[i] = GameState(difficulty, unpack(scene))
            ss[i].sceneIndex = i
        end
        local friendlyCount = 3 + math.floor(1.5 * difficulty)
        for i = 1, friendlyCount do
            local scene = math.random(1, 3)
            ss[scene].world:addEntity(entities.NPC{
                x = math.random(scene == 1 and 500 or 50, 2000)
            })
        end
        local hostileCount = 2 * math.floor(difficulty)
        for i = 1, hostileCount do
            local scene = math.random(1, 3)
            ss[scene].world:addEntity(entities.NPC{
                x = math.random(scene == 1 and 500 or 50, 2000),
                hostile = true
            })
        end
        ss.friendlyCount = friendlyCount
        ss.hostileCount = hostileCount
    end
    GameState.states = copy(ss)
    REMAINING_PEOPLE = ss.friendlyCount + ss.hostileCount
end

function GameState.getScene(index)
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

function GameState:addBeholders()
    beholder.observe("keypressed", "p", function()
        PAUSED = not PAUSED
    end)
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

GameState.startSceneGroups = {}

GameState.scenes = {
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings1,
            layer = "bg",
        },
        entities.Lamp(600),
        entities.Lamp(1400)
        },
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings2,
            layer = "bg",
        },
        entities.LampPost(70),
        entities.LampPost(535),
        entities.LampPost(1400),
        entities.LampPost(2000),
    },
    {
        {
            position = {x = 0, y = -75},
            sprite = assets.img_buildings3,
            layer = "bg",
        },
        entities.Lamp(200),
        entities.Lamp(835),
        entities.Lamp(1950),
    }
}

return GameState
