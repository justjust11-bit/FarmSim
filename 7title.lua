--title and dialogue--

function ititle()
end

function utitle()
    if game_state == "title" then
        title_t += 0.05

        if btnp(❎) then
            music(-1)
            game_state = "play"
            sfx(17)
            --reset inventory
            iinv()
            coins.amt = coins.default
            --reset growth data--
            patches = {}

            -- turn all wet dirt (36) back into dry dirt (4)
            for x = 0, 127 do
                for y = 0, 31 do
                    local t = mget(x, y)
                    if t == 36 then
                        mset(x, y, 4)
                    end
                end
            end
            --start bgm--
            music(1)
        end
    end
end

function spawn_title_veggies()
    title_veggies = {}

    -- top tomatoes
    for x = 12, 15 + 16 * 6, 16 do
        add(
            title_veggies, {
                spr = 19,
                x = x,
                y = 0
            }
        )
    end

    -- bottom tomatoes
    for x = 13, 120, 16 do
        add(
            title_veggies, {
                spr = 19,
                x = x,
                y = 120
            }
        )
    end

    -- left carrots
    for y = 3, 120, 16 do
        add(
            title_veggies, {
                spr = 9,
                x = 0,
                y = y
            }
        )
    end

    -- right pumpkins
    for y = 3, 120, 16 do
        add(
            title_veggies, {
                spr = 39,
                x = 120,
                y = y
            }
        )
    end
end

function dtitle()
    cls(3)
    palt(0, false)

    for v in all(title_veggies) do
        spr(v.spr, v.x, v.y)
    end

    print("MINI FARMING SIMULATOR", 22, 40, 1)
    spr(131, 53, 55, 2, 2)
    local jiggle = sin(title_t) * 2
    print("press x to start", 30, 80 + jiggle, 7)
    print("BY justine cormier", 28, 100, 1)
end

function dmap_withgrass()
    palt(0, true)
    --enable transparency

    for x = 0, 127 do
        for y = 0, 31 do
            local t = mget(x, y)

            -- grass tiles: 1, 37, 38
            if t == 1 or t == 37 or t == 38 then
                -- random offset based on tile position
                local offset = (x * 13 + y * 7) % 3 + 1

                -- pick frame with offset

                local frame = ((grass_frame + flr((x + y) / 4) + offset - 1) % 3) + 1
                -- convert frame to tile
                local tile = 1
                if frame == 2 then
                    tile = 37
                end
                if frame == 3 then
                    tile = 38
                end

                spr(tile, x * 8, y * 8)
            else
                if t != 0 then
                    spr(t, x * 8, y * 8)
                end
            end
        end
    end
    palt()
end