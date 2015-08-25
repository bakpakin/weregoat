local State = require "src.states.State"
local NightIntroState = class("NightIntroState", State)

local intros = {
    "The small village of Nowhere was a seemingly normal village until one fateful night; John Courage, a citizen of Nowhere, was brutally attacked by a rabid goat. Tonight, the night of a full moon, an insatiable bloodlust fills his head. Unbeknownst to his fellow townspeople, he takes to the streets in a dark and mysterious form.",
    "After the disappearance of several villagers in the night, Sheriff William Roberts suspects that something is amiss. The next evening, he sends out a few men to patrol the streets. John Courage is not so easily stopped, however.",
    "Posse disbanded, Roberts declared the town of Nowhere to be in a State of Emergency. Calling in all able bodied men to fight the demon plaguing the town, Roberts prepared Nowhere to battle Courage for a third night. It is extremely difficult to quell a Weregoat, however, and Roberts will discover it once again.",
}

function NightIntroState:enter(...)
    State.enter(self, ...)
    local introText = intros[DIFFICULTY + 1]
    local titleText
    local myText
    if introText then
        titleText = ("Night %i"):format(DIFFICULTY + 1)
        myText = introText
    else
        titleText = "Fin."
        myText = "Press Space to the start, Escape to quit."
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

function NightIntroState:leave(...)
    State.leave(self, ...)
    self.world:remove(self.titleEntity)
    self.world:remove(self.textEntity)
    self.world:remove(self.continueEntity)
end

function NightIntroState:addBeholders()
    beholder.observe("keypressed", " ", startNoIntro)
end

return NightIntroState
