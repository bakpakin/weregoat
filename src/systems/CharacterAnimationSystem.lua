local CharacterAnimationSystem = tiny.processingSystem(class "CharacterAnimationSystem")

CharacterAnimationSystem.filter = tiny.requireAll("isCharacter")

local WALK_SPEED = 60
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
        if e.animation ~= e.standAnimation then
            e.standAnimation:gotoFrame(1)
        end
        e.animation = e.standAnimation
        e.sprite = e.standSprite
    elseif a == "getup" then
        if e.animation ~= e.getupAnimation then
            e.getupAnimation:gotoFrame(1)
            e.getupAnimation:resume()
        end
        e.animation = e.getupAnimation
        e.sprite = e.getupSprite
        if e.animation.status == "paused" then
            e.action = "standing"
        end
    elseif a == "charge" then
        v.x = math.min(ws * 3, math.max(-ws * 3, v.x + d * dt * ac))
        if e.animation ~= e.chargeAnimation then
            e.chargeAnimation:gotoFrame(1)
            e.chargeAnimation:resume()
        end
        e.animation = e.chargeAnimation
        e.sprite = e.chargeSprite
        e.chargeTimer = 4
        if e.animation.status == "paused" then
            e.action = "standing"
        end
    elseif a == "kick" then
        if e.animation ~= e.kickAnimation then
            e.kickAnimation:gotoFrame(1)
            e.kickAnimation:resume()
        end
        e.animation = e.kickAnimation
        e.sprite = e.kickSprite
        e.kickTimer = 1
        if e.animation.status == "paused" then
            e.action = "standing"
        end
    elseif a == "crouch" then
        if v.x > 0 then
            v.x = math.max(0, v.x - dt * fr)
        elseif v.x < 0 then
            v.x = math.min(0, v.x + dt * fr)
        end
        if e.animation ~= e.crouchAnimation then
            e.crouchAnimation:gotoFrame(1)
            e.crouchAnimation:resume()
        end
        e.animation = e.crouchAnimation
        e.sprite = e.crouchSprite
    elseif a == "death" then
        if e.animation ~= e.deathAnimation then
            e.deathAnimation:gotoFrame(1)
            e.deathAnimation:resume()
        end
        e.animation = e.deathAnimation
        e.sprite = e.deathSprite
    end
    if a ~= "kick" then e.kicking = false end
    if a ~= "crouch" then e.crouching = false end
    if not (a == "walking" or a == "charge") then
        if v.x > 0 then
            v.x = math.max(0, v.x - dt * fr)
        elseif v.x < 0 then
            v.x = math.min(0, v.x + dt * fr)
        end
    end
end

return CharacterAnimationSystem
