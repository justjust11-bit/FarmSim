--collision and movement --

function move(o)
	--move an object
	local lx = o.x
	--last x pos
	local ly = o.y
	-- last y pos

	local moving = false

	if open_menu != menu_item.none then
		return
	end

	--general movement--
	if btn(⬆️) then
		o.y -= 1
		o.dir = "up"
		moving = true
	end

	if btn(⬇️) then
		o.y += 1
		o.dir = "down"
		moving = true
	end

	if btn(⬅️) then
		o.x -= 1
		o.dir = "left"
		moving = true
	end

	if btn(➡️) then
		o.x += 1
		o.dir = "right"
		moving = true
	end
	--if

	--if it collides, move back--
	if collide(o) then
		o.x = lx
		o.y = ly
	end
	-- if collide--

	if moving then
		o.anim_t += 1
		if o.anim_t > 6 then
			o.anim_t = 0
			o.frame = (o.frame == 1) and 2 or 1
		end
	else
		o.frame = 1
	end
	o.moving = moving

	-- walking sound
	-- walking sound
	if o.moving and walk_sfx_timer == 0 then
		-- detect tile under player
		local tx = (o.x + 3) / 8
		local ty = (o.y + 8) / 8
		local t = mget(tx, ty)

		-- if tile has flag 6 → stone
		if fget(t, 6) then
			sfx(22) -- stone step
		else
			sfx(21) -- normal step
		end

		walk_sfx_timer = 9
	end
end

function collide(o)
	--wall or hard, flag 3--
	local lx1_wall = (o.x + 3) / 8
	local lx2_wall = (o.y + 5) / 8
	local ly_wall = (o.y + 7) / 8

	--plants, flag 0--
	local lx_plant = (o.x + 2) / 8
	local ly_plant = (o.y + 3) / 8

	--walls--
	if fget(mget(lx1_wall, ly_wall), 3) or fget(mget(lx2_wall, ly_wall), 3) then
		return true --go back--
	end

	--plants

	if fget(mget(lx_plant, ly_plant), 0) then
		return true --go back--
	end

	return false
end