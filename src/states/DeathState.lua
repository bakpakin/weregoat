local State = require "src.states.State"
local DeathState = class("DeathState", State)

local outros = {
    "As the sun rose, the light revealed the body of a goat-like creature laying in the dust. The villagers breathed a collective sigh of relief, convinced that the beast’s death would mean the return of peace to the village. No one knew where old John Courage had gone, but some suspected that he had been the goat’s final victim, or had fled out of fear for his life.",
    "Sheriff Roberts' redoubled efforts successfully brought down the monsterous Weregoat. John Courage was assumed to be among the fallen that night, and no one ever knew that he was the accursed terror of Nowhere.",
    "And the Weregoat was no more..."
}

function DeathState:enter(...)
    State.enter(self, ...)
    local introText = outros[DIFFICULTY + 1]
    local titleText
    local myText
    if introText then
        titleText = ("Night %i: Complete"):format(DIFFICULTY + 1)
        myText = introText
    else
        titleText = "You have been exterminated."
        myText = ""
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

function DeathState:leave(...)
    State.leave(self, ...)
    self.world:remove(self.titleEntity)
    self.world:remove(self.textEntity)
    self.world:remove(self.continueEntity)
end

function DeathState:addBeholders()
    beholder.observe("keypressed", " ", restart)
end

return DeathState
