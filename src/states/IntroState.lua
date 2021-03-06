local State = require "src.states.State"
local IntroState = class ("IntroState", State)

function IntroState:enter()
    State.enter(self)
    local fade = {alpha = 0}
    local shake = {shake = 0}
    self.world:add(
        Text(0, 250, "[Weregoat](color; shake)", {
            font = assets.fnt_huge,
            align_center = true,
            wrap_width = W,
            color = function(dt, c)
                lg.setColor(255, 255, 255, fade.alpha)
            end,
            shakeInit = function(c)
                c.anchor_x = c.x
                c.anchor_y = c.y
            end,
            shake = function(dt, c)
                c.x = c.anchor_x + math.random(-shake.shake, shake.shake)
                c.y = c.anchor_y + math.random(-shake.shake, shake.shake)
            end,
            layer = "hud"
        }),
        Text(0, 450, "[A game by bakpakin for Ludum Dare 33](color)", {
            font = assets.fnt_medium,
            align_center = true,
            wrap_width = W,
            color = function(dt, c)
                lg.setColor(255, 255, 255, fade.alpha)
            end,
            layer = "hud"
        })
    )
    flux.to(shake, 10, {shake = 16}):ease("quartin")
    flux.to(fade, 2.5, {alpha = 255}):ease("linear"):delay(2)
    :after(fade, 2.4, {alpha = 0}):ease("linear"):delay(2)
    :onstart(function()
        assets.snd_gbu:play()
    end):after(fade, 1, {alpha = 0}):delay(3):oncomplete(function()
        restart()
    end)
end

return IntroState
