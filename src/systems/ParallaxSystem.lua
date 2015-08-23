local ParallaxSystem = tiny.processingSystem(class "ParallaxSystem")

ParallaxSystem.filter = tiny.requireAll("parallax", "parallaxAnchor", "position")

function ParallaxSystem:init(camera)
    self.camera = camera
end

function ParallaxSystem:process(e, dt)
    local plx = e.parallax
    local a = e.parallaxAnchor
    local ax, ay = a.x, a.y
    local pos = e.position
    local c = self.camera
    if e.aabb then
        ax = ax + e.aabb.x + e.aabb.w/2
        ay = ay + e.aabb.y + e.aabb.h/2
    end
    pos.x = c.x - (c.x - a.x) * plx
    pos.y = c.y - (c.y - a.y) * plx
    if e.aabb then
        pos.x = (pos.x - e.aabb.x) - e.aabb.w/2
        pos.y = (pos.y - e.aabb.y) - e.aabb.h/2
    end
end

return ParallaxSystem
