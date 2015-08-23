local DrawSystem = tiny.processingSystem(class "DrawSystem")
DrawSystem.isDrawingSystem = true

function DrawSystem:init(camera, layer)
    self.camera = camera
    self.layer = layer
end

function DrawSystem:filter(e)
    return e.draw and e.layer == self.layer
end

function DrawSystem:preProcess(dt)
    self.camera:push()
end

function DrawSystem:process(e)
    lg.setColor(255, 255, 255, 255)
    e:draw()
end

function DrawSystem:postProcess(dt)
    self.camera:pop()
end

return DrawSystem
