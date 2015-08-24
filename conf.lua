function love.conf(t)
    t.version = "0.9.2"
    t.identity = "weregoat"
    t.title = "Weregoat"
    t.window.title = t.title
    t.window.width = 1050
    t.window.height = 450

    t.game_version = "0.0.0"
    t.icon = nil

    t.author = "bakpakin"
    t.email = "calsrose@gmail.com"
    t.url = "http://bakpakin.github.io/weregoat/web/"
    t.description = "A LOVEly game for Ludum Dare 33."

    t.os = {
        "love",
        windows = {
            x32       = true,
            x64       = false,
            installer = false,
            appid     = "4E593227-83A1-41D5-BC89-9CAC4C9DE5B1",
        },
        "osx",
    }
end
