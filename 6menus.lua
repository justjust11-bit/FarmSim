--menus--
--[]--
local menu_item = {
    none = 0,
    main = 1,
    buy = 2,
    sell = 3,
    prize = 4
}

function imenu()
    open_menu = menu_item.none

    menutable = { "buy", "sell", "prize", "back" }
    menusel = 1
    -- menutoggle = false

    --buying--
    buy_items = { "bucket", "seeds", "fertilizer", "back" }
    buy_sel = 1
    --buy_menutoggle = false

    --selling--
    sell_items = {}
    sell_sel = 1
    --sell_menutoggle = false

    --prize--
    --prize menu--
    prize_items = { "reward", "back" }  
    prize_sel = 1

end

-------main menu!!!!!!!----------
function umenu()
    print(open_menu, 63, 63)

    --only run if menu open--
    if open_menu == menu_item.none then
        return
    end
    -- sfx(08) how do implement sound

    if open_menu == menu_item.main then
        --selecting items--
        if btnp(⬇️) then
            sfx(04)
            if menusel < #menutable then
                menusel += 1
            else
                menusel = 1
            end
        elseif btnp(⬆️) then
            sfx(04)
            if menusel > 1 then
                menusel -= 1
            else
                menusel = #menutable
            end
        end

        --clicking on items--

        if btnp(❎) then
            
            local choice = menutable[menusel]

            local coins = get_item("coins")
            local seeds = get_item("seeds")
            local carrots = get_item("carrots")
            local fertilizer = get_item("fertilizer")

            if choice == "buy" then
                sfx(5)
                -- buy_menutoggle = true --submenu
                -- menutoggle = false
                open_menu = menu_item.buy
                buy_sel = 1
                -- return --stop main menu--
            elseif choice == "sell" then
                sfx(5)
                -- build dynamic sell list
                sell_items = {}
                for item in all(inv) do
                    if item.name != "coins" 
                    and item.name!= "bucket"
                    and item.amt > 0 then
                        add(sell_items, item.name)
                    end
                end

                -- empty slots--
                local count = #sell_items

                if count == 0 then
                    add(sell_items, "empty")
                    add(sell_items, "empty")
                    add(sell_items, "empty")
                elseif count == 1 then
                    add(sell_items, "empty")
                    add(sell_items, "empty")
                elseif count == 2 then
                    add(sell_items, "empty")
                end

                add(sell_items, "back")

                sell_sel = 1
                open_menu = menu_item.sell
                -- return
            elseif choice == "prize" then
                music(-1)
                current_music = "trophy"
                sfx(15,2)
                open_menu = menu_item.prize
                prize_sel = 1

                
            elseif choice == "back" then
                sfx(7)
                -- go back--
                plr.insidemenu = false
                open_menu = menu_item.none
            end
        end
    elseif open_menu == menu_item.buy then
        ubuy()
    elseif open_menu == menu_item.sell then
        usell()
    elseif open_menu == menu_item.prize then
        uprize()
    end
end

-----buy_submenu---------------------
function ubuy()
    if open_menu != menu_item.buy then
        return
    end

    --moving--
    if btnp(⬇️) then
        sfx(04)
        buy_sel += 1
        if buy_sel > #buy_items then
            buy_sel = 1
        end
    elseif btnp(⬆️) then
        sfx(04)
        buy_sel -= 1
        if buy_sel < 1 then
            buy_sel = #buy_items
        end
    end

    --choosing--
    if btnp(❎) then
        local choice = buy_items[buy_sel]

        if choice == "back" then
            sfx(07)
            open_menu = menu_item.main
            return
        end


        local item = get_item(choice)
        -- not enough money
        if coins.amt < item.price then
            sfx(06)   -- error sound
            return
        end

        -- one bucket only 
        if choice == "bucket" and item.amt >= 1 
            then sfx(06) -- error sound 
                return 
        end

        sfx(02)

        if coins.amt >= item.price then
            coins.amt -= item.price

            if choice == "seeds" then
                -- pick a random seed type from seed_types
                local rname = seed_types[flr(rnd(#seed_types)) + 1]
                seed_counts[rname] += 1
                item.amt += 1
            else
                -- normal items (bucket, etc.)
                item.amt += 1
                
            end
        -- remove bucket from buy list after purchase 
            if choice == "bucket" then 
                deli(buy_items, 1) 
            end
        end
    end    
end

-----usell submenu---------------

function usell()
    if open_menu != menu_item.sell then
        return
    end

    -- movement--
    if btnp(⬇️) then
        sfx(04)
        sell_sel += 1
        if sell_sel > #sell_items then
            sell_sel = 1
        end
    elseif btnp(⬆️) then
        sfx(04)
        sell_sel -= 1
        if sell_sel < 1 then
            sell_sel = #sell_items
        end
    end

    -- choosing--
    if btnp(❎) then
        local choice = sell_items[sell_sel]

        if choice == "back" then
            sfx(07)
            open_menu = menu_item.main
            -- sell_menutoggle = false
            -- menutoggle = true
            return
        end

        if choice == "empty" then
            sfx(06)
            return
        end

        local item = get_item(choice)

        -- sell price (customisable)
        local sell_price = item.price
                or 1

        if item.amt > 0 then
            item.amt -= 1
            coins.amt += sell_price
            sfx(18)
        end
    end
end

-------prize submenu--------
function uprize()
    if open_menu != menu_item.prize then
        return
    end

    -- movement
    if btnp(⬇️) then
        sfx(04)
        prize_sel += 1
        if prize_sel > #prize_items then
            prize_sel = 1
        end
    elseif btnp(⬆️) then
        sfx(04)
        prize_sel -= 1
        if prize_sel < 1 then
            prize_sel = #prize_items
        end
    end

    -- choosing
    if btnp(❎) then
        local choice = prize_items[prize_sel]

        if choice == "back" then
            sfx(07)
            open_menu = menu_item.main
            return
        end

        if choice == "reward" then
            if coins.amt >= 150 then
                coins.amt -= 150
                sfx(02)
                winner_mode = true
                music(-1)
                sfx(11,1)
                sfx(-1,2)
                plr.insidemenu = false
                open_menu = menu_item.none
            else
                sfx(06) -- not enough coins
            end
        end
    end
end





---------main menu draw-------------
function dmenu()

    if open_menu == menu_item.main then
        rectfill(55, 6, 79, 7 * #menutable + 7, 1)

        rectfill(56, 0 + 7 * menusel, 77, 6 + 7 * menusel, 12)
        for i = 1, #menutable do
            print(menutable[i], 57, 1 + 7 * i, 7)
        end

    elseif open_menu == menu_item.buy then
        dbuy()
        
    elseif open_menu == menu_item.sell then
        dsell()

     elseif open_menu == menu_item.prize then
        dprize()
    end
end

-----buy submenu draw------------
function dbuy()

    --width--
    local w = 0
    for i = 1, #buy_items do
        local name = buy_items[i]

        if name == "back" then
            --no price--
            w = max(w, print("back", 0, -100))
        else
            local it = get_item(name)
            local label = name .. "(" .. it.price .. ")"

            w = max(w, print(label, 0, -100))
        end
    end

    --boxes of menu--
    rectfill(55, 6, 55 + w + 11, 7 * #buy_items + 7, 1)
    --highlighted items--
    rectfill(56, 0 + 7 * buy_sel, 56 + w + 8, 6 + 7 * buy_sel, 12)

    --print names and price--
    for i = 1, #buy_items do
        local name = buy_items[i]
        local y = 1 + 7 * i

        if name == "back" then
            print("back", 57, y, 7)
        else
            local it = get_item(name)

            --name--
            print(name, 57, y, 7)

            --coin sprite--
            spr(16, 57 + 44, y - 2)

            --price next to coin--
            print(it.price, 57 + 54, y, 10)
        end
    end
end

-----sell submenu draw----------

function dsell()
    --if not sell_menutoggle then
    -- return
    -- end

    local w = 0
    for i = 1, #sell_items do
        local name = sell_items[i]

        if name == "back" then
            w = max(w, print("back", 0, -100))
        elseif name != "empty" then
            local it = get_item(name)
            local label = name .. "(" .. it.price .. ")"
            w = max(w, print(label, 0, -100))
        end
    end

    rectfill(55, 6, 55 + w + 40, 7 * #sell_items + 7, 1)
    rectfill(56, 0 + 7 * sell_sel, 56 + w + 37, 6 + 7 * sell_sel, 12)

    for i = 1, #sell_items do
        local name = sell_items[i]
        local y = 1 + 7 * i

        if name == "back" then
            print("back", 57, y, 7)
        elseif name == "empty" then
            --empty--
            print("(empty)", 57, y, 5)
        else
            local it = get_item(name)
            print(name, 57, y, 7)

            -- amount you own--
            print("("..it.amt..")", 57 + 40, y, 7)

            --coin amt + icon--
            spr(16, 56 + 54, y - 2) --coin sprite slightly higher))
            print(it.price, 57 + 62, y, 10)
        end
    end
end


function dprize()
    local w = 0
    for i = 1, #prize_items do
        local name = prize_items[i]
        if name == "back" then
            w = max(w, print("back", 0, -100))
        else
            w = max(w, print("trophy(100)", 0, -100))
        end
    end

    rectfill(55, 6, 55 + w + 22, 7 * #prize_items + 7, 9)
    rectfill(56, 0 + 7 * prize_sel, 56 + w + 20, 6 + 7 * prize_sel, 8)

    for i = 1, #prize_items do
        local name = prize_items[i]
        local y = 1 + 7 * i

        if name == "back" then
            print("back", 57, y, 7)
        else
            print("reward", 57, y, 7)

            --coins, and price--
            spr(16, 56 + 53, y - 2) --coin sprite slightly higher))
            print("150", 30 + 65, y, 10)
        end
    end
end

