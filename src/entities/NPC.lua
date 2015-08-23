local Character = require "src.entities.Character"
local NPC = class ("NPC", Character)
NPC.isAi = true

NPC.lightColor = {255, 255, 255, 50}
NPC.lightRadius = 150

return NPC
