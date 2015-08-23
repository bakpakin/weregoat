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

W = 1400
H = 600
GROUND_Y = 520
PAUSED = false
WORLD = tiny.world()
SCREEN_TRANSITIONS = flux.group()
SKIP_INTRO = true
PLAYER_WIDTH = 128
PLAYER_HEIGHT = 128
CAMERA_SCALE = 1.35
BLOOM_SHADER = ""
POST_PROCESS = true
POST_PROCESS_CANVAS = ""

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
    BLOOM_SHADER:send("canvas_w", w)
    BLOOM_SHADER:send("canvas_h", h)
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

function love.draw()
    if POST_PROCESS then
        lg.setCanvas(POST_PROCESS_CANVAS)
    else
        lg.setCanvas()
    end
    love.graphics.setShader()
    love.graphics.origin()
    love.graphics.setScissor()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)
    WORLD:update(PAUSED and 0 or love.timer.getDelta(), drawSystems)
    if POST_PROCESS then
        lg.setCanvas()
        lg.origin()
        lg.setShader(BLOOM_SHADER)
        lg.setColor(255, 255, 255, 255)
        lg.draw(POST_PROCESS_CANVAS)
        lg.setShader()
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    -- load assets
    assets = require "src.assets"

    BLOOM_SHADER = love.graphics.newShader([[
    extern number threshold = 1.0;

    extern number canvas_w = 800;
    extern number canvas_h = 600;

    const number offset_1 = 1.5;
    const number offset_2 = 3.5;

    const number alpha_0 = 0.43;
    const number alpha_1 = 0.22;
    const number alpha_2 = 0.04;

    float luminance(vec3 color)
    {
       // numbers make 'true grey' on most monitors, apparently
       return ((0.212671 * color.r) + (0.715160 * color.g) + (0.072169 * color.b));
    }

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
    {
       vec4 texcolor = Texel(texture, texture_coords);

       // Vertical blur
       vec3 tc_v = texcolor.rgb * alpha_0;

       tc_v += Texel(texture, texture_coords + vec2(0.0, offset_1)/canvas_h).rgb * alpha_1;
       tc_v += Texel(texture, texture_coords - vec2(0.0, offset_1)/canvas_h).rgb * alpha_1;

       tc_v += Texel(texture, texture_coords + vec2(0.0, offset_2)/canvas_h).rgb * alpha_2;
       tc_v += Texel(texture, texture_coords - vec2(0.0, offset_2)/canvas_h).rgb * alpha_2;

       // Horizontal blur
       vec3 tc_h = texcolor.rgb * alpha_0;

       tc_h += Texel(texture, texture_coords + vec2(offset_1, 0.0)/canvas_w).rgb * alpha_1;
       tc_h += Texel(texture, texture_coords - vec2(offset_1, 0.0)/canvas_w).rgb * alpha_1;

       tc_h += Texel(texture, texture_coords + vec2(offset_2, 0.0)/canvas_w).rgb * alpha_2;
       tc_h += Texel(texture, texture_coords - vec2(offset_2, 0.0)/canvas_w).rgb * alpha_2;

       // Smooth
       vec3 extract = smoothstep(threshold * 0.7, threshold, luminance(texcolor.rgb)) * texcolor.rgb;
       return vec4(extract + tc_v * 0.8 + tc_h * 0.8, 1.0);
    }
    ]])

    gamestate.registerEvents()
    entities = require "src.entities"
    love.resize(lg.getDimensions())

    local GameState = require "src.states.GameState"
    GameState.resetAll()
    if SKIP_INTRO then
        gamestate.switch(GameState.getScene(2), "left")
    else
        gamestate.switch(require "src.states.IntroState"())
    end
end

function love.keypressed(key, isrepeat)
    beholder.trigger("keypressed", key, isrepeat)
end

beholder.observe("keypressed", "escape", love.event.quit)

beholder.observe("keypressed", "b", function()
    POST_PROCESS = not POST_PROCESS
end)

beholder.observe("keypressed", "\\", function()
    setFullscreen(not IS_FULLSCREEN)
end)
