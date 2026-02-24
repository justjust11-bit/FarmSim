--inventory--

--[]--

--seeds 17/carrots 9/gold 16--
coins = {
    amt = 10,
    default = 10,
    sp = 16,
    price = 0
}

-- all seeds, to be randomized... more = more common--
seed_types = {
    "carrotseeds", "carrotseeds", "carrotseeds", "carrotseeds", "carrotseeds",
    "tomatoseeds", "tomatoseeds", "tomatoseeds",
    "pumpkinseeds"
}
seed_counts = {
    carrotseeds = 0,
    tomatoseeds = 0,
    pumpkinseeds = 0
}

function iinv()
    sel = 1
    --select 1st item inv--
    inv = {}

    add(
        inv, {
            name = "seeds",
            amt = 0,
            sp = 17,
            price = 1,
            hotbar = true
        }
    )

    add(
        inv, {
            name = "bucket",
            amt = 0, --you own 0 bucket
            water = 0,
            sp_empty = 33,
            sp_full = 32,
            price = 5,
            hotbar = true
        }
    )

    add(
        inv, {
            name = "fertilizer", ---turn this into goo dluck charm?--
            amt = 0,
            sp = 52,
            price = 2,
            hotbar = true
        }
    )

    add(
        inv, {
            name = "carrots",
            amt = 0,
            sp = 9,
            price = 2,
            hotbar = false
        }
    )

    add(
        inv, {
            name = "tomatoes",
            amt = 0,
            sp = 19,
            price = 5,
            hotbar = false
        }
    )

    add(
        inv, {
            name = "pumpkins",
            amt = 0,
            sp = 39,
            price = 15,
            hotbar = false
        }
    )
end

function get_item(name)
    for i in all(inv) do
        if i.name == name then
            return i
        end
    end
end

function uinv()
    item = inv[sel]
    if btnp(🅾️) then
        sfx(00)
        repeat
            sel += 1
            if sel > #inv then
                sel = 1
            end
        until inv[sel].hotbar
    end
end

--endbtnp

function dinv()
    local slot = 1
    local x_offset = 13

    --draw hotbar 
    rectfill(41, 112, 78, 123, 4)
    rect(40, 111, 79, 124, 2)

    --draw separation bars
    for i = 0, 2 do
        rect(i * x_offset + 53, 111, i * x_offset + 53, 124, 2)
    end

    --choosing i label for future
    --inventories--

    --draw items 
    for i = 1, #inv do
        local item = inv[i]
        if item.hotbar then
            local sprite = item.sp or item.sp_empty
            if item.name == "bucket" then
                sprite = (item.water > 0) and item.sp_full or item.sp_empty
            end

            if item.amt>0 then
            spr(sprite, 30 + x_offset * slot, 114)
            end
            slot += 1
            
        end
    end

    --selection box 
    rect(28 + sel * x_offset, 112, 39 + sel * x_offset, 123, 7)

    --amt means amount--

    --selected item
    local item = inv[sel]

    --empty bucket
    local label = item.name
    if item.name == "bucket" and item.water == 0 then
        label = "bucket (empty)"
    end

    --calculate width like menu logic (print returns text width)
    local w = print(label, 0, -100)
    local nw = print(item.amt, 0, -100)

    --background box that expands to the RIGHT
    rectfill(28, 102, 29 + w + 1, 110, 1)

    --item name (fixed position)
    print(label, 30, 104, 7)

    --amount box (expands to the left
    rect(31-nw,111,39,121,12)
    rectfill(32-nw, 112, 38, 120, 1)

    --amount
    print(item.amt, 36-nw, 114, 7)
end




function plant_seed(ptx, pty)
    local item = inv[sel]

    if item.name == "seeds" and item.amt > 0 then
        item.amt -= 1

        -- pick a seed type you actually have
        local chosen = nil
        repeat
            local rname = seed_types[flr(rnd(#seed_types)) + 1]
            if seed_counts[rname] > 0 then
                chosen = rname
                seed_counts[rname] -= 1
            end
        until chosen

        local dry = (mget(ptx, pty) == 4)
        local wet = (mget(ptx, pty) == 36)

        local seed_sprite = 0
        if chosen == "carrotseeds" then
            seed_sprite = dry and 23 or 27
        elseif chosen == "tomatoseeds" then
            seed_sprite = dry and 5 or 50
        elseif chosen == "pumpkinseeds" then
            seed_sprite = dry and 24 or 51
        end

        mset(ptx, pty, seed_sprite)

        add(
            patches, {
                px = flr(ptx),
                py = flr(pty),
                watered = wet,
                tig = 0,
                seed_type = chosen,
                fertilized = false,
                flicker_offset = rnd(1)

            }
        )
    end
end