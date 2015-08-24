local State = require "src.states.State"
local BeforeLevelState = class ("BeforeLevelState", State)

function BeforeLevelState:init(...)
    BeforeLevelState.init(self, ...)
end

function BeforeLevelState:enter()
    State.enter(self)
end

return BeforeLevelState
