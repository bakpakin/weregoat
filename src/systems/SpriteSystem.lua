local SpriteSystem = tiny.processingSystem(class "SpriteSystem")
SpriteSystem.isDrawingSystem = true

function SpriteSystem:init(camera, layer)
    self.camera = camera
    self.layer = layer
end

function SpriteSystem:filter(e)
    return e.sprite and e.position and e.layer == self.layer
end

function SpriteSystem:preProcess(dt)
    self.camera:push()
end

local WHITE = {255, 255, 255, 255}

function SpriteSystem:process(e, dt)
    local an = e.animation
    local alpha = e.alpha or 1
    local pos, sprite, scale, offset = e.position, e.sprite, e.scale, e.aabb
    local s, ox, oy = scale or 1, offset and offset.x or 0, offset and offset.y or 0
    love.graphics.setColor(e.color or WHITE)
    local x, y = pos.x, pos.y
    if an then
        an:update(dt)
        an.flippedH = e.direction == "right"
        an:draw(sprite, x, y, 0, s, s, ox, oy)
    else
        love.graphics.draw(sprite, x, y, 0, s, s, ox, oy)
    end
    if DRAW_DEBUG then
        lg.setColor(255, 0, 0)
        local b = e.aabb
        if b then
            lg.rectangle("line", pos.x + b.x, pos.y + b.y, b.w, b.h)
        end
        lg.setColor(0, 255, 0)
        b = e.hitbox
        if b then
            lg.rectangle("line", pos.x + b.x, pos.y + b.y, b.w, b.h)
        end
    end
end

function SpriteSystem:postProcess(dt)
    self.camera:pop()
end

return SpriteSystem
