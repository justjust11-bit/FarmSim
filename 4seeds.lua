--seeds and icons--

function icrops()
    patches = {}
end

function ucrops()
    for p in all(patches) do
        local mid = p.fertilized and 150 or 400
        local final = p.fertilized and 300 or 800

        -- only grow when watered
        if p.watered then
            p.tig += 1
        end

        -- FLICKER dry fertilized seeds (before watering)
        if p.fertilized and not p.watered then
            local flicker = ((time() + p.flicker_offset) % 1.0) < 0.3

            local dry_sprite = 0
            local fert_sprite = 0

            if p.seed_type == "carrotseeds" then
                dry_sprite = 23
                fert_sprite = 53
            elseif p.seed_type == "tomatoseeds" then
                dry_sprite = 5
                fert_sprite = 48
            elseif p.seed_type == "pumpkinseeds" then
                dry_sprite = 24
                fert_sprite = 49
            end

            if flicker then
                mset(p.px, p.py, fert_sprite)
            else
                mset(p.px, p.py, dry_sprite)
            end
        end

        -- FLICKER wet fertilized seeds (after watering, before mid growth)
        if p.fertilized and p.watered and p.tig < mid then
            local flicker = ((time() + p.flicker_offset) % 1.0) < 0.3

            local wet_sprite = 0
            local wet_fert_sprite = 0

            if p.seed_type == "carrotseeds" then
                wet_sprite = 27
                wet_fert_sprite = 55
            elseif p.seed_type == "tomatoseeds" then
                wet_sprite = 50
                wet_fert_sprite = 56
            elseif p.seed_type == "pumpkinseeds" then
                wet_sprite = 51
                wet_fert_sprite = 57
            end

            if flicker then
                mset(p.px, p.py, wet_fert_sprite)
            else
                mset(p.px, p.py, wet_sprite)
            end
        end

        -- MID GROWTH (INSIDE LOOP)
        if p.tig == mid then
            if p.seed_type == "carrotseeds" then
                mset(p.px, p.py, 22)
            elseif p.seed_type == "tomatoseeds" then
                mset(p.px, p.py, 7)
            elseif p.seed_type == "pumpkinseeds" then
                mset(p.px, p.py, 6)
            end
        end

        -- FINAL GROWTH (INSIDE LOOP)
        if p.tig > final then
            if p.seed_type == "carrotseeds" then
                mset(p.px, p.py, 8)
            elseif p.seed_type == "tomatoseeds" then
                mset(p.px, p.py, 18)
            elseif p.seed_type == "pumpkinseeds" then
                mset(p.px, p.py, 3)
            end
        end
    end
end


--items top corner--
function dicons()
    local carrots = get_item("carrots")
    local tomatoes = get_item("tomatoes")
    local pumpkins = get_item("pumpkins")
    local seeds = get_item("seeds")
    local fertilizer = get_item("fertilizer")

    --coins, always there--
    spr(coins.sp, 2, 2)
    print(coins.amt, 12, 3, 7)

    -- starting y position
    local y = 12

    --carrots--
    if carrots.amt > 0 then
        spr(9, 2, y)
        print(carrots.amt, 12, y + 1, 7)
        y += 10
    end

    --tomatoes--
    if tomatoes.amt > 0 then
        spr(19, 2, y)
        print(tomatoes.amt, 12, y + 1, 7)
        y += 10
    end

    --pumpkins--
    if pumpkins.amt > 0 then
        spr(39, 2, y)
        print(pumpkins.amt, 12, y + 1, 7)
        y += 10
    end

    --seeds--
    if seeds.amt > 0 then
        spr(17, 2, y)
        print(seeds.amt, 12, y + 1, 7)
        y += 10
    end

    if fertilizer.amt > 0 then
        spr(52, 2, y)
        print(fertilizer.amt, 12, y + 1, 7)
        y += 10
    end
end