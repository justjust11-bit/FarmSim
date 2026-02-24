--farming simulator--

--grass animation--
grass_t = 0
grass_frame = 1
victory_coins = {}
winner_mode = false
game_state = "title" -- ......play, winner
show_intro = true
current_music = "none" --bgm--
title_t = 0 ---jiggle for press x


function _init()
	ititle()
	iplr()
	icrops()
	palt(0, false)
	pal(0, 3)
	pal(14, 0)
	iinv()
	imenu()
	spawn_title_veggies()
	music(0)
	-- play title music on channel 0
end
-----------------------------------------------------------
--victory screen coins shower--
function add_coin(x, y)
	add(
		victory_coins, {
			x = x + rnd(40) - 20,
			y = y + rnd(20) - 10,
			dx = rnd(1) - 0.5,
			dy = -rnd(1),
			t = 0
		}
	)
end

function ucoins()
	for c in all(victory_coins) do
		c.t += 1
		c.x += c.dx
		c.y += c.dy
		c.dy += 0.05 -- gravity

		if c.t > 60 then
			del(victory_coins, c)
		end
	end
end

function dcoins()
	for c in all(victory_coins) do
		spr(16, c.x, c.y) -- coin sprite
	end
end

---------------------------------------------------------------

function _update()
	if winner_mode then
		-- exit winner screen
		if btnp(❎) then
			game_state = "title"
			winner_mode = false
			sfx(-1, 1)
			music(0)
			show_intro = true

			ititle()
			iplr()
			icrops()
			imenu()
			spawn_title_veggies()

			victory_coins = {} -- reset coins
		end

		-- spawn coins
		if rnd(1) < 0.2 then
			add_coin(64, 40) -- center of trophy
		end

		ucoins()
		return
	end

	grass_t += 1
	if grass_t > 33 then
		grass_t = 0
		grass_frame = (grass_frame % 3) + 1
	end

	if game_state == "title" then
		utitle()
		return
	end

	if show_intro then
		if btnp(❎) then
			show_intro = false
			sfx(20)
		end
	end

	walk_sfx_timer = max(0, walk_sfx_timer - 1)
	-- resume gameplay music after trophy song ends
-- resume BGM after prize-menu SFX ends
if current_music == "trophy" and stat(22) == -1 then
    music(1)          -- resume pattern 01
    current_music = "game"
end


	--in game--
	uplr()
	ucrops()
	uinv()
end

-----------------------------------------------------------------------

function _draw()
	if game_state == "title" then
		dtitle()
		return
	end

	cls(3)
	dmap_withgrass()
	dplr()
	dinv()
	dmenu()
	dicons()

	if winner_mode then
		cls(9)

		-- trophy
		spr(75, 40, 20, 5, 4)

		-- draw coins on top
		dcoins()

		print("congratulations!", 28, 60, 10)
		print("you won the big trophy!", 18, 70, 7)
		print("you can now farm in real life", 7, 86, 3)
		rectfill(20, 111, 105, 120, 1)
		print("X TO RETURN TO TITLE", 23, 113, 8)
		--brown fade
		spr(136,0,0,4,4)
		spr(140,96,0,4,4)
		spr(165,0,112,2,2)
		spr(133,112,112,2,2)

		spr(9, 32, 97) -- carrot
		spr(19, 56, 97) -- tomato
		spr(39, 80, 97) -- pumpkin

		-- player next to trophy
		spr(128, 25, 36, 2, 2)

		return
	end

	if show_intro then
		rectfill(10, 20, 118, 99, 1) -- background
		rect(10, 20, 118, 100, 2) -- border

		print("welcome to the farm!", 25, 27, 7)
		print("fill a bucket with water,", 16, 40, 12)
		print("plant seeds, sell veggies", 16, 50, 11)
		print("...profit!", 16, 60, 9)
		print("SELECT ITEMS ON YOUR", 25, 73, 7)
		print("HOTBAR TO USE THEM", 27, 80, 7)

		print("CLOSE ❎ ", 47, 90, 6)
	end
end