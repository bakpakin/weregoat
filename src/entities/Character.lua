local Character = class "Character"
Character.isCharacter = true
Character.isSolid = true
Character.layer = "mg"

local grid1024 = anim8.newGrid(128, 128, 1024, 1024, 0, 0, 0)
local grid896 = anim8.newGrid(128, 128, 896, 896, 0, 0, 0)
local grid768 = anim8.newGrid(128, 128, 768, 768, 0, 0, 0)
local an60 = anim8.newAnimation(grid1024('1-8', '1-7', '1-4', 8), 1/60)
local an40 = anim8.newAnimation(grid896('1-7', '1-5', '1-5', 6), 1/60)
local an35 = anim8.newAnimation(grid768('1-6', '1-5', '1-5', 6), 1/60)
local an30 = anim8.newAnimation(grid768('1-6', '1-5'), 1/60)

Character.grid1024 = grid1024
Character.grid896 = grid896
Character.grid768 = grid768
Character.an60 = an60
Character.an40 = an40
Character.an35 = an35
Character.an30 = an30

function Character:init(args)
    args = args or {}
    self.gravity = args.gravity or 2200
    self.action = args.action or "standing"
    self.direction = args.direction or "right"
    self.name = args.name or "Joe Bob"
    self.position = args.position or {x = args.x or 0, y = args.y or 1000}
    self.velocity = args.velocity or {x = 0, y = 0}
    self.aabb = args.aabb or {x = 0, y = 0, w = PLAYER_WIDTH, h = PLAYER_HEIGHT}
    self.standSprite = args.standSprite or assets.img_npc_standing
    self.standAnimation = args.standAnimation or an60:clone()
    self.walkSprite = args.walkSprite or assets.img_npc_walking
    self.walkAnimation = args.walkAnimation or an60:clone()
    self.deathSprite = args.deathSprite or assets.img_npc_death
    self.deathAnimation = args.deathAnimation or an35:clone()

    self.sprite = self.standSprite
    self.animation = self.walkAnimation
end

return Character
