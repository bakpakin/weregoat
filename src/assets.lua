local assets = {
    img_player_walking = lg.newImage("assets/images/goatwalk.png"),
    img_player_standing = lg.newImage("assets/images/goatstand.png"),
    img_player_death = lg.newImage("assets/images/goatdeath.png"),
    img_player_charge = lg.newImage("assets/images/goatcharge.png"),
    img_player_kick = lg.newImage("assets/images/goatkick.png"),
    img_player_crouch = lg.newImage("assets/images/goatcrouch.png"),
    img_player_feed = lg.newImage("assets/images/goatfeed.png"),
    img_npc_walking = lg.newImage("assets/images/mainwalking.png"),
    img_npc_standing = lg.newImage("assets/images/mainstanding.png"),
    img_npc_death = lg.newImage("assets/images/maindeath.png"),
    img_npc_shoot = lg.newImage("assets/images/mainshoot.png"),
    img_stars = lg.newImage("assets/images/gamebackground.png"),
    img_light = lg.newImage("assets/images/light.png"),
    img_ground = lg.newImage("assets/images/groundstrip.png"),
    img_moon = lg.newImage("assets/images/moon.png"),
    img_shadow = lg.newImage("assets/images/shadow.png"),
    img_buildings1 = lg.newImage("assets/images/buildings002.png"),
    img_buildings2 = lg.newImage("assets/images/buildings001.png"),
    img_buildings3 = lg.newImage("assets/images/buildings003.png"),
    img_lamp = lg.newImage("assets/images/lamp.png"),
    img_lamp2 = lg.newImage("assets/images/lamp2.png"),

    fnt_big = lg.newFont("assets/fonts/Rio Oro.otf", 72),
    fnt_small = lg.newFont("assets/fonts/duality.ttf", 32),
    fnt_tiny = lg.newFont("assets/fonts/duality.ttf", 14),

    snd_gbu = multisource.new(love.audio.newSource("assets/sounds/gbu.ogg", "static")),
    snd_cricket = multisource.new(love.audio.newSource("assets/sounds/cricket.ogg", "static")),
    snd_bloop = multisource.new(love.audio.newSource("assets/sounds/bloop.ogg", "static")),
    snd_walk60 = love.audio.newSource("assets/sounds/walk60.ogg", "static"),
    snd_walk30 = love.audio.newSource("assets/sounds/walk30.ogg", "static"),
    snd_kick = multisource.new(love.audio.newSource("assets/sounds/kick.ogg", "static")),
    snd_charge = multisource.new(love.audio.newSource("assets/sounds/charge.ogg", "static")),
    snd_gun = multisource.new(love.audio.newSource("assets/sounds/gun.ogg", "static")),
    snd_music = love.audio.newSource("assets/sounds/music.ogg", "stream")
}

assets.snd_walk30:setLooping(true)
assets.snd_walk60:setLooping(true)

return assets
