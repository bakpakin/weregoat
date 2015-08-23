local UpdateSystem = require "src.systems.UpdateSystem"
local DrawSystem = require "src.systems.DrawSystem"
local SpriteSystem = require "src.systems.SpriteSystem"
local MovementSystem = require "src.systems.MovementSystem"
local DialogSystem = require "src.systems.DialogSystem"
local CharacterAnimationSystem = require "src.systems.CharacterAnimationSystem"
local CameraTrackSystem = require "src.systems.CameraTrackSystem"

local State = class "State"

function State:init(...)
    self.camera = gamera.new(0, 0, W, H)
    self.hudCamera = gamera.new(0, 0, W, H)
    CAMERA = self.camera
    HUD_CAMERA = self.hudCamera
    self.world = tiny.world(
        UpdateSystem(),
        MovementSystem(),
        CharacterAnimationSystem(),
        CameraTrackSystem(CAMERA),

        DrawSystem(CAMERA, "bbg"),
        SpriteSystem(CAMERA, "bbg"),
        DrawSystem(CAMERA, "bg"),
        SpriteSystem(CAMERA, "bg"),
        DrawSystem(CAMERA, "mg"),
        SpriteSystem(CAMERA, "mg"),
        DrawSystem(CAMERA, "fg"),
        SpriteSystem(CAMERA, "fg"),
        DrawSystem(CAMERA, "ffg"),
        SpriteSystem(CAMERA, "ffg"),
        DrawSystem(HUD_CAMERA, "hud"),
        SpriteSystem(HUD_CAMERA, "hud"),

        DialogSystem(),
        ...
    )
end

function State:enter()
    WORLD = self.world
    CAMERA = self.camera
    HUD_CAMERA = self.hudCamera
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
    if self.screenShade then WORLD:remove(self.screenShade) end
    self.transitioning = true
    self.screenShade = WORLD:add{
        position = {x=0,y=0},
        layer="hud",
        alpha=255,
        draw = function(self)
            lg.setColor(0, 0, 0, self.alpha)
            lg.rectangle("fill", 0, 0, W, H)
        end
    }
    SCREEN_TRANSITIONS:to(self.screenShade, 0.5, {alpha=0}):ease("quadout")
    :oncomplete(function()
        self.transitioning = false
        if self.player then
            self.player.controllable = true
        end
    end)
end

function State:transitionTo(next, ...)
    if not self.trasitioning then
        self.trasitioning = true
        self.screenShade.alpha = 0
        local args, len = {...}, select("#", ...)
        SCREEN_TRANSITIONS:to(self.screenShade, 0.5, {alpha=255}):ease("quadin")
        :oncomplete(function()
            self.trasitioning = false
            gamestate.switch(next, unpack(args, 1, len))
        end)
    end
end

return State
