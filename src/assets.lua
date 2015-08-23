return {
    img_player_walking = lg.newImage("assets/images/goatwalk.png"),
    img_player_standing = lg.newImage("assets/images/goatstand.png"),
    img_player_death = lg.newImage("assets/images/goatdeath.png"),
    img_npc_walking = lg.newImage("assets/images/mainwalking.png"),
    img_npc_standing = lg.newImage("assets/images/mainstanding.png"),
    img_npc_death = lg.newImage("assets/images/maindeath.png"),
    img_stars = lg.newImage("assets/images/gamebackground.png"),
    img_light = lg.newImage("assets/images/light.png"),
    img_ground = lg.newImage("assets/images/groundstrip.png"),
    img_moon = lg.newImage("assets/images/moon.png"),

    fnt_big = lg.newFont("assets/fonts/Rio Oro.otf", 72),
    fnt_small = lg.newFont("assets/fonts/duality.ttf", 32),

    snd_gbu = multisource.new(love.audio.newSource("assets/sounds/gbu.wav", "static")),
}
