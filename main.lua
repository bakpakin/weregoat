-- global modules
gamestate = require "lib.gamestate"
class = require "lib.30logclean"
tiny = require "lib.tiny"
anim8 = require "lib.anim8"
flux = require "lib.flux"
beholder = require "lib.beholder"
Text = require "lib.Text"
multisource = require "lib.multisource"
gamera = require "lib.gamera"
lg = love.graphics -- lol

W = 2100
H = 900
DRAW_DEBUG = false
GROUND_Y = 830
PAUSED = false
TIMER = 240
DIFFICULTY = 0
REMAINING_PEOPLE = 0
WORLD = tiny.world()
SKIP_INTRO = false
PLAYER_WIDTH = 128
PLAYER_HEIGHT = 128
CAMERA_SCALE = 1.6
CONTROLS = {
    LEFT = "a",
    RIGHT = "d",
    CROUCH = "s",
    CHARGE = "n",
    KICK = "m",
    HIDE = "w",
    FEED = "e"
}

-- hack to implement cron like capabilities with flux
function flux.cron(delay, callback, ...)
    local args, len = {...}, select("#", ...)
    flux.to({time = 0}, delay, {time = delay}):oncomplete(function() return callback(unpack(args, 1, len)) end)
end

local function setFullscreen(fs)
    IS_FULLSCREEN = fs
    local w, h
    if fs then
        w, h = love.window.getDesktopDimensions()
        love.window.setMode(w, h, {fullscreen = true})
    else
        w, h = 1050, 450
        love.window.setMode(w, h, {fullscreen = false})
    end
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function love.resize(w, h)
    REALW = w
    REALH = h
    if REALH * 21 > REALW * 9 then -- letterbox top and bottom
        REALH = (REALW * 9) / 21
    else -- letterbox left and right
        REALW = (REALH * 21) / 9
    end
    local xoff, yoff = (w - REALW) / 2, (h - REALH) / 2
    if CAMERA then
        CAMERA:setWindow(xoff, yoff, REALW, REALH)
        CAMERA:setScale(REALW / W * CAMERA_SCALE)
    end
    if HUD_CAMERA then
        HUD_CAMERA:setWindow(xoff, yoff, REALW, REALH)
        HUD_CAMERA:setScale(REALW / W)
    end
end

local drawSystems = function(_, s) return not not s.isDrawingSystem end
local updateSystems = function(_, s) return not s.isDrawingSystem end

function love.update(dt)
    if not PAUSED then
        TIMER = TIMER - dt
        WORLD:update(dt, updateSystems)
        flux.update(dt)
    end
end

function startMusic()
    assets.snd_music:setLooping(true)
    if not assets.snd_music:isPlaying() then
        assets.snd_music:play()
    end
end

function love.draw()
    lg.setCanvas()
    love.graphics.setShader()
    love.graphics.origin()
    love.graphics.setScissor()
    love.graphics.setColor(255, 255, 255)
    WORLD:update(PAUSED and 0 or love.timer.getDelta(), drawSystems)
    lg.origin()
    HUD_CAMERA:push()
    if PAUSED then
        lg.setColor(0, 0, 0, 80)
        lg.rectangle("fill", 0, 0, W, H)
        lg.setColor(255, 255, 255)
        lg.setFont(assets.fnt_big)
        lg.printf("PAUSED", 0, 200, W, "center")
        lg.setFont(assets.fnt_medium2)
        lg.printf("Controls:\n\nA - Move left\nD - Move Right\nP - Toggle Pause\nW - Hide\nE - Eat dead townsperson\nS - Crouch\nM - Kick\nHold N - Charge forward\nF1 - Toggle Fullscreen", 200, 150, 500, "center")
        lg.printf("Instructions:\n\nKill and eat every townsperson to move on to the next night. Kill a citizen by charging into him or kicking him. Don't get shot.", W - 700, 150, 500, "center")
    end
    HUD_CAMERA:pop()
    lg.origin()
    if DRAW_DEBUG then
        lg.setColor(255, 255, 255)
        local mx, my = love.mouse.getPosition()
        local wx, wy = CAMERA:toWorld(mx, my)
        lg.circle("line", mx, my, 10, 50)
        lg.point(mx, my)
        lg.setFont(assets.fnt_tiny)
        lg.printf(("Screen: (%i, %i)\nWorld: (%i, %i)"):format(mx, my, wx, wy), mx, my + 20, 400, "left")
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    -- load assets
    assets = require "src.assets"

    NIGHT_CLEAR_STATE = require "src.states.NightClearState" ()
    NIGHT_INTRO_STATE = require "src.states.NightIntroState" ()

    gamestate.registerEvents()
    entities = require "src.entities"
    love.resize(lg.getDimensions())

    gamestate.switch{}
    local GameState = require "src.states.GameState"
    function start()
        gamestate.current():transitionTo(NIGHT_INTRO_STATE)
    end
    function restart()
        GameState.resetToDifficulty(0)
        DIFFICULTY = 0
        start()
    end
    function startNoIntro()
        GameState.resetToDifficulty(DIFFICULTY)
        gamestate.current():transitionTo(GameState.getScene(1), "left")
    end
    function gotoIntro()
        gamestate.current():transitionTo(require "src.states.IntroState"())
    end
    if SKIP_INTRO then
        gamestate.switch(NIGHT_INTRO_STATE)
    else
        gamestate.switch(require "src.states.IntroState"())
    end
end

function love.keypressed(key, isrepeat)
    beholder.trigger("keypressed", key, isrepeat)
end

beholder.observe("keypressed", "escape", love.event.quit)

-- beholder.observe("keypressed", "`", function()
--     DRAW_DEBUG = not DRAW_DEBUG
-- end)

beholder.observe("keypressed", "f1", function()
    setFullscreen(not IS_FULLSCREEN)
end)
