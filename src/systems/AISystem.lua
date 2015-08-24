local AISystem = tiny.processingSystem(class "AISystem")

AISystem.filter = tiny.requireAll("isAi")

local function sign(x)
    if x < 0 then
        return -1
    elseif x > 0 then
        return 1
    else
        return 0
    end
end

function AISystem:process(e, dt)
    if e.isDead then return end

    local px, py = PLAYER:getPoint(0.5, 0.5)
    local x, y = e:getPoint(0.5, 0.5)
    local d = e.direction == "left" and -1 or 1
    local dx, dy = px - x, py - y
    if math.abs(dx) < 300 then
        if dx * d > 0 then
            if not e.targeting then
                e:say(1,"!")
            end
            e.targeting = true
        end
    else
        e.targeting = false
    end
    if PLAYER.isHidden then
        e.targeting = false
    end
    if e.targeting then
        if e.hostile then
            d = sign(dx)
            e.action = "shoot"
        else
            d = -sign(dx)
            e.action = "walking"
        end
        e.direction = d == 1 and "right" or "left"
    else
        e.shuffleTimer = (e.shuffleTimer or 0) - dt
        if e.shuffleTimer < 0 then
            if e.action == "standing" then
                if math.random() > 0.5 then
                    e.action = "walking"
                    e.shuffleTimer = 0.2 + math.random() * 2
                else
                    e.direction = e.direction == "left" and "right" or "left"
                    e.shuffleTimer = 0.4 + math.random() * 2
                end
            elseif e.action ~= "death" then
                e.action = "standing"
                e.shuffleTimer = 1.2 + math.random() * 2
            end
        end
    end
end

return AISystem
