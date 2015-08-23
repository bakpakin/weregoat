local LightSystem = tiny.processingSystem(class "LightSystem")
LightSystem.isDrawingSystem = true

LightSystem.filter = tiny.requireAll("position", "lightRadius")

local LightInitSystem = tiny.system(class "LightInitSystem")
LightInitSystem.isDrawingSystem = true

function LightInitSystem:init()
    self:resize(lg.getDimensions())
end

function LightInitSystem:resize(w, h)
    self.canvas = lg.newCanvas(w, h)
    self.canvasW = w
    self.canvasH = h
end

function LightInitSystem:update(dt)
    self._tmpcanvas = lg.getCanvas()
    lg.push()
    lg.origin()
    self.canvas:clear()
    lg.setCanvas(self.canvas)
    lg.pop()
end

function LightSystem:init(camera, ambient)
    self.camera = camera
    self.ambient = ambient or {40, 40, 40, 255}
    self.lights = {}

    -- Add this system to the scene before the LightSystem to prevent previous
    -- drawwing systems before it from being affected by the lights.
    self.lightInitSystem = LightInitSystem()
    self:resize(lg.getDimensions())
end

function LightSystem:resize(w, h)
    self.backCanvas = lg.newCanvas(w, h)
    self.canvasW = w
    self.canvasH = h
    self.lightInitSystem:resize(w, h)
end

function LightSystem:preProcess(dt)
    lg.push()
    lg.origin()
    self._tmpcanvas = lg.getCanvas()
    lg.setCanvas(self.backCanvas)
    lg.setColor(self.ambient)
    lg.rectangle("fill", 0, 0, self.canvasW, self.canvasH)
    lg.pop()
    lg.setBlendMode("additive")
    self.camera:push()
end

local WHITE = {255, 255, 255}

function LightSystem:process(e, dt)
    local x, y, r, c = e.position.x, e.position.y, e.lightRadius, e.lightColor or WHITE
    if e.aabb then
        x, y = x + e.aabb.x + e.aabb.w / 2, y + e.aabb.y + e.aabb.h / 2
    end
    local scale = r / 256
    lg.setColor(c)
    lg.draw(assets.img_light, x - r, y - r, 0, scale, scale)
end

function LightSystem:postProcess(dt)
    self.camera:pop()
    lg.setColor(255, 255, 255, 255)
    lg.setCanvas(self._tmpcanvas)
    lg.setBlendMode("multiplicative")
    lg.draw(self.backCanvas)
    lg.setBlendMode("alpha")
    if self.lightInitSystem.world == self.world then
        lg.setCanvas(self.lightInitSystem._tmpcanvas)
        lg.setBlendMode("alpha")
        lg.draw(self._tmpcanvas)
    end
end

return LightSystem
