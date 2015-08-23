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
    local pos, sprite, scale, rot, offset = e.position, e.sprite, e.scale, e.rotation, e.offset
    local s, r, ox, oy = scale or 1, rot or 0, offset and offset.x or 0, offset and offset.y or 0
    love.graphics.setColor(e.color or WHITE)
    if an then
        an:update(dt)
        an.flippedH = e.direction == "right"
        an:draw(sprite, pos.x, pos.y, r, s, s, ox, oy)
    else
        love.graphics.draw(sprite, pos.x, pos.y, r, s, s, ox, oy)
    end
end

function SpriteSystem:postProcess(dt)
    self.camera:pop()
end

return SpriteSystem
