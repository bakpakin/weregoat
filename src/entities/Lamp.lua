local Lamp = class "Lamp"

function Lamp:init(x, foreground)
    local y = GROUND_Y + (foreground and 10 or -5) - 256
    if foreground then
        self.layer = "ffg"
    else
        self.layer = "mg"
    end
    self.position = {x = x, y = y}
    self.sprite = assets.img_lamp2
    self.light = {
        position = {x = x + 20, y = y + 50},
        lightRadius = 550,
        lightColor = {255, 255, 100, 255}
    }
end

function Lamp:onAdd()
    self.world:add(self.light)
end

function Lamp:onRemove()
    self.world:remove(self.light)
end

return Lamp
