local GunShot = class "GunShot"
GunShot.layer = "fg"
GunShot.lightRadius = 90

function GunShot:init(d, x, y)
    self.position = {x = x, y = y}
    self.d = d
    self.alpha = 255
    self.lightColor = {255, 255, 255, 255}
    self.shotMesh = lg.newMesh{
        {0, 0, 0, 0, 128, 128, 128, 255},
        {0, 1, 0, 0, 128, 128, 128, 255},
        {1, 1, 0, 0, 128, 128, 128, 0},
        {1, 0, 0, 0, 128, 128, 128, 0}
    }
end

function GunShot:update(dt)
    if self.alpha == 255 then -- just shot
        if not PLAYER.isHidden and not PLAYER.crouching then
            local px = PLAYER.position.x + PLAYER.hitbox.x
            local px2 = PLAYER.position.x + PLAYER.hitbox.x + PLAYER.hitbox.w
            local x = self.position.x
            if (px - x) * self.d > 0 and math.abs(px - x) < 1000 then
                PLAYER:kill()
            elseif (px2 - x) * self.d > 0 and math.abs(px2 - x) < 1000 then
                PLAYER:kill()
            end
        end
    end
    self.alpha = self.alpha - dt * 500
    self.lightColor[4] = self.alpha
    if self.alpha <= 0 then
        self.world:remove(self)
    end
end

function GunShot:draw()
    lg.setColor(128, 128, 128, self.alpha)
    local x, y = self.position.x, self.position.y
    lg.circle("fill", x, y, 5, 10)
    self.shotMesh:setVertices{
        {0, 0, 0, 0, 128, 128, 128, self.alpha},
        {0, 1, 0, 0, 128, 128, 128, self.alpha},
        {1, 1, 0, 0, 128, 128, 128, 0},
        {1, 0, 0, 0, 128, 128, 128, 0}
    }
    lg.draw(self.shotMesh, x + self.d * 5, y, 0, self.d * 300, 2)
    -- lg.line(x, y, x + self.d * 10, y)
    -- lg.line(x, y, x + self.d * 900, y)

end

return GunShot
