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
WORLD = tiny.world()
SCREEN_TRANSITIONS = flux.group()
SKIP_INTRO = true
PLAYER_WIDTH = 128
PLAYER_HEIGHT = 128
CAMERA_SCALE = 1.6
SHADER = ""
POST_PROCESS = true
POST_PROCESS_CANVAS = ""
CONTROLS = {
    LEFT = "a",
    RIGHT = "d",
    CROUCH = "s",
    CHARGE = "n",
    KICK = "m",
    FEED = "e"
}

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
    POST_PROCESS_CANVAS = lg.newCanvas(w, h)
    SHADER:send("canvas_w", w)
    SHADER:send("canvas_h", h)
end

local drawSystems = function(_, s) return not not s.isDrawingSystem end
local updateSystems = function(_, s) return not s.isDrawingSystem end

function love.update(dt)
    if not PAUSED then
        WORLD:update(dt, updateSystems)
        flux.update(dt)
    end
    SCREEN_TRANSITIONS:update(dt)
end

function startMusic()
    assets.snd_music:setLooping(true)
    if not assets.snd_music:isPlaying() then
        assets.snd_music:play()
    end
end

function love.draw()
    if POST_PROCESS then
        lg.setCanvas(POST_PROCESS_CANVAS)
        POST_PROCESS_CANVAS:clear()
    else
        lg.setCanvas()
    end
    love.graphics.setShader()
    love.graphics.origin()
    love.graphics.setScissor()
    love.graphics.setColor(255, 255, 255)
    WORLD:update(PAUSED and 0 or love.timer.getDelta(), drawSystems)
    if POST_PROCESS then
        lg.setCanvas()
        lg.origin()
        lg.setShader(SHADER)
        lg.setColor(255, 255, 255, 255)
        lg.draw(POST_PROCESS_CANVAS)
        lg.setShader()
    end
    lg.origin()
    if PAUSED then
        lg.setColor(0, 0, 0, 80)
        local sw, sh = lg.getDimensions()
        lg.rectangle("fill", 0, 0, sw, sh)
        lg.setColor(255, 255, 255)
        lg.setFont(assets.fnt_big)
        lg.printf("PAUSED", sw / 2 - 200, sh / 2 - 200, 400, "center")
        lg.setFont(assets.fnt_small)
        lg.printf("Controls:\nA - Move left\nD - Move Right\nP - Toggle Pause\nS - Crouch\nM - Kick\nHold N - Charge forward.", sw / 2 - 200, sh / 2 - 100, 400, "center")
    end
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

    SHADER = love.graphics.newShader([[
    extern number canvas_w = 800;
    extern number canvas_h = 600;

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
       vec4 texcolor = Texel(texture, texture_coords);
       return texcolor * color;
    }
    ]])

    gamestate.registerEvents()
    entities = require "src.entities"
    love.resize(lg.getDimensions())

    local GameState = require "src.states.GameState"
    GameState.resetAll()
    if SKIP_INTRO then
        gamestate.switch(GameState.getScene(1), "left")
    else
        gamestate.switch(require "src.states.IntroState"())
    end
end

function love.keypressed(key, isrepeat)
    beholder.trigger("keypressed", key, isrepeat)
end

beholder.observe("keypressed", "escape", love.event.quit)

-- beholder.observe("keypressed", "b", function()
--     POST_PROCESS = not POST_PROCESS
-- end)

beholder.observe("keypressed", "p", function()
    PAUSED = not PAUSED
end)

beholder.observe("keypressed", "`", function()
    DRAW_DEBUG = not DRAW_DEBUG
end)

beholder.observe("keypressed", "\\", function()
    setFullscreen(not IS_FULLSCREEN)
end)
