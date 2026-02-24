--player sprite actions--
local dirt_tile = 4

function iplr()
    --walking sound timer--
    walk_sfx_timer = 0

    plr = {
        x = 40,
        y = 74,
        dir = "down",
        frame = 1,
        anim_t = 0,
        insidemenu = false
    }
end

function uplr()
    if plr.insidemenu then
        umenu()
    else
        move(plr)

        --  keep player inside screen--
        plr.x = mid(0, plr.x, 120)
        plr.y = mid(0, plr.y, 120)

        local ptx = (plr.x + 3) / 8
        local pty = (plr.y + 8) / 8
        tile = mget(ptx, pty)

        if btnp(❎) then
            local item = inv[sel]

            --plants seeds on dirt
            if item.name == "seeds" and item.amt > 0 then
                if tile == 4 or tile == 36 then
                    sfx(19)
                    plant_seed(ptx, pty)
                end
            end
            --water seeds (fertilized OR normal, dry OR wet, flickering OR not)
            if item.name == "bucket" and item.amt > 0 then
                for p in all(patches) do
                    if p.px == flr(ptx) and p.py == flr(pty) then
                        -- this IS a seed patch, so water it
                        if item.water > 0 then
                            sfx(09)
                            p.watered = true
                            item.water -= 1

                            -- fertilized → wet-fertilized tiles
                            if p.fertilized then
                                if p.seed_type == "carrotseeds" then
                                    mset(p.px, p.py, 55)
                                elseif p.seed_type == "tomatoseeds" then
                                    mset(p.px, p.py, 56)
                                elseif p.seed_type == "pumpkinseeds" then
                                    mset(p.px, p.py, 57)
                                end

                                -- normal → wet tiles
                            else
                                if p.seed_type == "carrotseeds" then
                                    mset(p.px, p.py, 27)
                                elseif p.seed_type == "tomatoseeds" then
                                    mset(p.px, p.py, 50)
                                elseif p.seed_type == "pumpkinseeds" then
                                    mset(p.px, p.py, 51)
                                end
                            end
                        end

                        break
                    end
                end
            end

            --water the dirt--
            if tile == 4 and (item.name == "bucket" and item.amt > 0) then
                if item.water > 0 then
                    --bucket full, so water--
                    sfx(09)
                    mset(ptx, pty, 36)

                    for p in all(patches) do
                        if p.px == flr(ptx) and p.py == flr(pty) then
                            p.watered = true
                        end
                    end
                    item.water -= 1
                end
            end

            --apply fertilizer (dry OR wet seeds)
            if item.name == "fertilizer" and item.amt > 0 then
                local is_dry_seed = tile == 23
                        -- carrot dry
                        or tile == 5
                        -- tomato dry
                        or tile == 24 -- pumpkin dry

                local is_wet_seed = tile == 27
                        -- carrot wet
                        or tile == 50
                        -- tomato wet
                        or tile == 51 -- pumpkin wet

                if is_dry_seed or is_wet_seed then
                    sfx(20)

                    for p in all(patches) do
                        if p.px == flr(ptx) and p.py == flr(pty) then
                            p.fertilized = true

                            -- if wet, immediately show wet-fertilized sprite
                            if is_wet_seed then
                                if p.seed_type == "carrotseeds" then
                                    mset(p.px, p.py, 55)
                                elseif p.seed_type == "tomatoseeds" then
                                    mset(p.px, p.py, 56)
                                elseif p.seed_type == "pumpkinseeds" then
                                    mset(p.px, p.py, 57)
                                end
                            end

                            break
                        end
                    end

                    item.amt -= 1
                end
            end

            --refill bucket at well--
            if fget(tile, 5) and (item.name == "bucket" and item.amt > 0) then
                item.water = 10
                sfx(01)
            end

            if fget(tile, 2) then
                -- remember which crop this was before clearing it
                local t = tile

                -- clear the tile
                mset(ptx, pty, 4)
                sfx(03)

                -- give the right crop based on tile id
                if t == 8 then
                    get_item("carrots").amt += 1
                elseif t == 18 then
                    get_item("tomatoes").amt += 1
                elseif t == 3 then
                    get_item("pumpkins").amt += 1
                end

                -- clean up the patch entry if it exists
                for p in all(patches) do
                    if p.px == flr(ptx) and p.py == flr(pty) then
                        del(patches, p)
                        break
                    end
                end
            end

            --stand--
            if fget(tile, 4) then
                --if on floor tiles--
                plr.insidemenu = true
                open_menu = menu_item.main
                sfx(08)
                return
            end
        end
    end
end
--closes btnp ❎--
-- uplr

function dplr()
    //to prevent green from surrounding character
    palt(14, true)
    palt(0, true)

    local face = 12
    --default face down

    if plr.dir == "down" then
        if plr.moving then
            face = (plr.frame == 1) and 41 or 40
        else
            --idle down--
            face = 12
        end
    elseif plr.dir == "up" then
        if plr.moving then
            face = (plr.frame == 1) and 42 or 43
        else
            --idle up--
            face = 11
        end
    elseif plr.dir == "right" then
        face = (plr.frame == 1) and 28 or 44
    elseif plr.dir == "left" then
        face = (plr.frame == 1) and 28 or 44

        --flip horizontally walking--
        spr(face, plr.x, plr.y, 1, 1, true)

        palt()

        return
    end

    spr(face, plr.x, plr.y)
    palt()
end