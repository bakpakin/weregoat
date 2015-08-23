local CameraTrackSystem = tiny.processingSystem(class "CameraTrackSystem")

CameraTrackSystem.filter = tiny.requireAll("position", "cameraTrack")

function CameraTrackSystem:init(camera)
    self.camera = camera
end

function CameraTrackSystem:preProcess(dt)
    self.x, self.y = 0, 0
end

function CameraTrackSystem:process(e, dt)
    local p = e.position
    local dx, dy = 0, 0
    if e.aabb then
        dx, dy= e.aabb.w / 2, e.aabb.h / 2
    end
    self.x, self.y = self.x + p.x + dx, self.y + p.y + dy
end

local function lerp(x, a, b)
    return x * b + (1 - x) * a
end

function CameraTrackSystem:postProcess(dt)
    if #self.entities > 0 then
        local cw, ch = W / CAMERA_SCALE, H / CAMERA_SCALE
        local x, y = self.x / #self.entities / W, self.y / #self.entities / H
        local maxx, maxy = W - cw, H - ch
        self.camera:setPosition(lerp(x, 0, maxx) + cw / 2, lerp(y, 0, maxy) + ch / 2)
    end
end

return CameraTrackSystem
