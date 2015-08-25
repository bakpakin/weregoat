local CollisionSystem = tiny.system(class "CollisionSystem")

CollisionSystem.filter = tiny.requireAll "isSolid"

local function collides(a, b)
    local x1, y1, w1, h1 = a:getBounds()
    local x2, y2, w2, h2 = b:getBounds()
    return
        x1 + w1 >= x2 and
        y1 + h1 >= y2 and
        x2 + w2 >= x1 and
        y2 + h2 >= y1
end

local function sign(x)
    if x < 0 then
        return -1
    elseif x > 0 then
        return 1
    else
        return 0
    end
end

function CollisionSystem:update(dt)
    local es = self.entities
    local a = PLAYER.action
    local px, py = PLAYER:getPoint(0.5, 0.5)
    PLAYER.prey = nil
    if a == "kick" then
        for i, e in ipairs(es) do
            if e ~= PLAYER and not e.isDead and collides(PLAYER, e) then
                local x, y = e:getPoint(0.5, 0.5)
                local dx, dy = px - x, py - y
                if (PLAYER.direction == "right") == (dx > 0) then
                    e:kill(sign(dx) * -220, -300)
                    assets.snd_charge:play()
                end
            end
        end
    elseif a == "charge" then
        for i, e in ipairs(es) do
            if e ~= PLAYER and not e.isDead and collides(PLAYER, e) then
                local x, y = e:getPoint(0.5, 0.5)
                local dx, dy = px - x, py - y
                if (PLAYER.direction == "right") == (dx < 0) then
                    e:kill(sign(dx) * -600, -500)
                    assets.snd_charge:play()
                end
            end
        end
    elseif a == "feed" then
        for i, e in ipairs(es) do
            if e ~= PLAYER and e.isDead and collides(PLAYER, e) then
                local x, y = e:getPoint(0.5, 0.5)
                local dx, dy = px - x, py - y
                if (PLAYER.direction == "right") == (dx < 0) then
                    PLAYER.prey = e
                end
            end
        end
    end
end

return CollisionSystem
