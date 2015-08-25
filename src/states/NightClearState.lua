local State = require "src.states.State"
local NightClearState = class("NightClearState", State)

local outros = {
    "Three unlucky citizens were wandering about Nowhere when a large, dark, and shadowy creature killed and devoured each in turn. John Courage had begun his campaign of terror on the town.",
    "Sheriff Robert's posse was no match for the bloodthirsty Courage, who dodged bullets with the nimble speed of a goat to rip out their throats. Victory was Courage's, once again.",
    "Sheriff William Joseph Robertson was left speechless. All of his men had vanished in the night, and the only people left in the village were unwilling to leave their homes after dark. The only thing he could think of was to put a curfew in place, so that no more would be lost to the beast that stalked his people in the night."
}

function NightClearState:enter(...)
    State.enter(self, ...)
    local introText = outros[DIFFICULTY + 1]
    local titleText
    local myText
    if introText then
        titleText = ("Night %i: Complete"):format(DIFFICULTY + 1)
        myText = introText
    else
        titleText = "Fin."
        myText = "You have devoured the entire town. The monster, John Courage, has finally won."
    end
    self.titleEntity = self.world:add(
        Text(300, 90, titleText, {
            font = assets.fnt_huge,
            align_center = true,
            wrap_width = W - 600,
            layer = "hud"
        })
    )
    self.textEntity = self.world:add(
        Text(300, 280, myText, {
            font = assets.fnt_medium,
            align_center = true,
            wrap_width = W - 600,
            layer = "hud"
        })
    )
    self.continueEntity = self.world:add(
        Text(0, 800, "@(Space to Continue@)", {
            font = assets.fnt_small,
            align_center = true,
            wrap_width = W,
            layer = "hud"
        })
    )
end

function NightClearState:leave(...)
    State.leave(self, ...)
    self.world:remove(self.textEntity)
    self.world:remove(self.titleEntity)
    self.world:remove(self.continueEntity)
end

function NightClearState:addBeholders()
    beholder.observe("keypressed", " ", function()
        DIFFICULTY = DIFFICULTY + 1
        if outros[DIFFICULTY] then
            self:transitionTo(NIGHT_INTRO_STATE)
        else
            gotoIntro()
        end
    end)
end

return NightClearState
