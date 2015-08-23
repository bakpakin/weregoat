local CharacterAnimationSystem = tiny.processingSystem(class "CharacterAnimationSystem")

CharacterAnimationSystem.filter = tiny.requireAll("isCharacter")

local WALK_SPEED = 65
local ACCELERATION = 3000
local FRICTION = 2600
local JUMP = 730

function CharacterAnimationSystem:process(e, dt)
    local p = e.position
    local v = e.velocity
    local a = e.action
    local d = e.direction == "left" and -1 or 1
    local ws = e.walkSpeed or WALK_SPEED
    local ac = e.accekeration or ACCELERATION
    local fr = e.friction or FRICTION
    if a == "walking" then
        v.x = math.min(ws, math.max(-ws, v.x + d * dt * ac))
        if e.animation ~= e.walkAnimation then
            e.walkAnimation:gotoFrame(13)
        end
        e.animation = e.walkAnimation
        e.sprite = e.walkSprite
    elseif a == "standing" then
        if v.x > 0 then
            v.x = math.max(0, v.x - dt * fr)
        elseif v.x < 0 then
            v.x = math.min(0, v.x + dt * fr)
        end
        if e.animation ~= e.standAnimation then
            e.standAnimation:gotoFrame(1)
        end
        e.animation = e.standAnimation
        e.sprite = e.standSprite
    elseif a == "death" then
        if e.animation ~= e.deathAnimation then
            e.deathAnimation:gotoFrame(1)
        end
        e.animation = e.deathAnimation
        e.sprite = e.deathSprite
    end
end

return CharacterAnimationSystem
