local LightSystem = tiny.processingSystem(class "LightSystem")
LightSystem.isDrawingSystem = true

LightSystem.filter = tiny.requireAll("position", "lightColor", "lightRadius")

function LightSystem:init(camera, ambient)
    self.camera = camera
    self.ambient = ambient or {40, 40, 40, 255}
    self.lights = {}
    self.backCanvas = lg.newCanvas(W, H)
end

function LightSystem:preProcess(dt)
    self._tmpcanvas = lg.getCanvas()
    lg.setCanvas(self.backCanvas)
    lg.setColor(self.ambient)
    lg.rectangle("fill", 0, 0, W, H)
    lg.setBlendMode("additive")
end

function LightSystem:process(e, dt)
    local x, y, r, c = e.position.x, e.position.y, e.lightRadius, e.lightColor
    if e.aabb then
        x, y = x + e.aabb.w / 2, y + e.aabb.h / 2
    end
    local scale = r / 256
    lg.setColor(c)
    lg.draw(assets.img_light, x - r, y - r, 0, scale, scale)
end

function LightSystem:postProcess(dt)
    self.camera:push()
    lg.setCanvas(self._tmpcanvas)
    lg.setBlendMode("multiplicative")
    lg.draw(self.backCanvas)
    lg.setBlendMode("alpha")
    self.camera:pop()
end

return LightSystem
