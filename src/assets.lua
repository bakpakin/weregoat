return {
    img_player_walking = lg.newImage("assets/images/goatwalk.png"),
    img_player_standing = lg.newImage("assets/images/goatstand.png"),
    img_player_death = lg.newImage("assets/images/goatdeath.png"),
    img_player_charge = lg.newImage("assets/images/goatcharge.png"),
    img_player_crouch = lg.newImage("assets/images/goatcrouch.png"),
    img_npc_walking = lg.newImage("assets/images/mainwalking.png"),
    img_npc_standing = lg.newImage("assets/images/mainstanding.png"),
    img_npc_death = lg.newImage("assets/images/maindeath.png"),
    img_stars = lg.newImage("assets/images/gamebackground1.png"),
    img_light = lg.newImage("assets/images/light.png"),
    img_ground = lg.newImage("assets/images/groundstrip.png"),
    img_moon = lg.newImage("assets/images/moon.png"),
    img_shadow = lg.newImage("assets/images/shadow.png"),
    img_buildings1 = lg.newImage("assets/images/buildings001.png"),

    fnt_big = lg.newFont("assets/fonts/Rio Oro.otf", 72),
    fnt_small = lg.newFont("assets/fonts/duality.ttf", 32),

    snd_gbu = multisource.new(love.audio.newSource("assets/sounds/gbu.wav", "static")),
    snd_cricket = multisource.new(love.audio.newSource("assets/sounds/cricket.wav", "static")),
    snd_bloop = multisource.new(love.audio.newSource("assets/sounds/bloop.wav", "static")),
}
