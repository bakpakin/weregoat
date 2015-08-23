local MovementSystem = tiny.processingSystem(class "MovementSystem")
MovementSystem.filter = tiny.requireAll("position", "velocity", "aabb")

function MovementSystem:process(e, dt)
    local p = e.position
    local v = e.velocity
    local h = e.aabb.h
    p.x = p.x + v.x * dt
    p.y = p.y + v.y * dt
    if e.gravity then
        v.y = v.y + e.gravity * dt
    end
    if e.isSolid then
        if p.y + h >= GROUND_Y then
            p.y = GROUND_Y - h
            v.y = 0
            e.grounded = true
        else
            e.grounded = false
        end
    end
end

return MovementSystem
