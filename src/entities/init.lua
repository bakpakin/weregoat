local path = ... .. '.' -- 3 2 1 go
local ret = {}
local function r(thang)
    ret[thang] = require (path .. thang)
end

r "Goat"
r "Player"
r "NPC"
r "Character"
r "GunShot"
r "LampPost"
r "Lamp"

return ret
