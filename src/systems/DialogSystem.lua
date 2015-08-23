local DialogSystem = tiny.processingSystem(class "DialogSystem")
DialogSystem.isDrawingSystem = true

DialogSystem.filter = tiny.requireAll("x", "y", "text", "draw", "update")

function DialogSystem:preProcess(dt)
    HUD_CAMERA:push()
end

function DialogSystem:process(e, dt)
    e:update(dt)
    lg.setColor(255, 255, 255, 255)
    e:draw()
end

function DialogSystem:postProcess(dt)
    HUD_CAMERA:pop()
end

return DialogSystem
