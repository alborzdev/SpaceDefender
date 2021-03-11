note
	description: "Summary description for {GAME_BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_BOARD
create
	make

feature -- Attributes
	num_rows: INTEGER
	num_cols: INTEGER
	grunt_thresh: INTEGER
	fighter_thresh: INTEGER
	carrier_thresh: INTEGER
	interceptor_thresh: INTEGER
	pylon_thresh: INTEGER
	model: GAME

feature
	make
		do
			create implementation.make_filled('_', 5, 5)
			make_model

		end

	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end

feature -- Commands
	play(row: INTEGER; column: INTEGER; g_threshold: INTEGER; f_threshold: INTEGER; c_threshold: INTEGER; i_threshold: INTEGER; p_threshold: INTEGER)
		do
			make_model
			num_rows := row
			num_cols := column
			grunt_thresh := g_threshold
			fighter_thresh := f_threshold
			carrier_thresh := c_threshold
			interceptor_thresh := i_threshold
			pylon_thresh := p_threshold
			implementation.make_filled ('_', num_rows, num_cols)
			implementation.put ('S', (num_rows/2).ceiling, 1)

		end
	display_fire -- Iterates through the list of newly created projectiles and prints them to the game board
		local
			proj: LINKED_LIST[PROJECTILE]
		do
			make_model
			proj := model.friendly_projectile_update.create_projectile
			across
				proj is p
			loop
				if not p.dont_care then
					implementation.put (p.tag, p.x_pos, p.y_pos)
				end

			end

		end
	display_enemy_fire(p: PROJECTILE) -- Iterates through the list of newly created projectiles and prints them to the game board
		do
			make_model
			if not p.dont_care AND not (implementation.item (p.x_pos, p.y_pos) ~ '?') then -- AND SOMETHING ABOUT NOT BEING THE FOW
				implementation.put (p.tag, p.x_pos, p.y_pos)
			end

		end


	move_proj(old_x: INTEGER; old_y: INTEGER; new_x: INTEGER; new_y: INTEGER; t: CHARACTER) -- Updates the location of all projectiles on the game board
		do
				if not (old_x > num_rows OR old_y > num_cols OR old_x < 1 OR old_y <1 ) then
					if model.starfighter_update.starfighter.get_distance (old_x, old_y) > (model.starfighter_update.starfighter.vision) AND not model.debug_flag then
						implementation.put ('?', old_x, old_y)
					else
						implementation.put ('_', old_x, old_y)
					end
				end
				if not (new_x > num_rows OR new_y > num_cols OR new_x < 1 OR new_y < 1) then
					if model.starfighter_update.starfighter.get_distance (new_x, new_y) > (model.starfighter_update.starfighter.vision) AND not model.debug_flag then
							implementation.put ('?', new_x, new_y)
					else
						implementation.put (t, new_x, new_y)
					end

				end

		end

	update_dont_cares
		do
			make_model
			across
				model.friendly_projectile_update.projectiles is p
			loop
				if p.dont_care AND not p.out_of_bounds(num_rows, num_cols) then
					implementation.put ('_', p.x_pos, p.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

		    across
				model.enemy_projectile_update.projectiles is e_p
			loop
				if e_p.dont_care AND not e_p.out_of_bounds(num_rows, num_cols) then
					implementation.put ('_', e_p.x_pos, e_p.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

			across
				model.enemy_update.enemies is e
			loop
				if e.dont_care AND not e.out_of_bounds(num_rows, num_cols) then
					implementation.put ('_', e.x_pos, e.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

			-- OBLITERARION ENDED

			across
				model.friendly_projectile_update.projectiles is p
			loop
				if not p.dont_care AND not p.out_of_bounds(num_rows, num_cols) then
					implementation.put (p.tag, p.x_pos, p.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

		    across
				model.enemy_projectile_update.projectiles is e_p
			loop
				if not e_p.dont_care AND not e_p.out_of_bounds(num_rows, num_cols) then
					implementation.put (e_p.tag, e_p.x_pos, e_p.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

			across
				model.enemy_update.enemies is e
			loop
				if not e.dont_care AND not e.out_of_bounds(num_rows, num_cols) then
					implementation.put (e.symbol, e.x_pos, e.y_pos)
					if not model.debug_flag then
						update_fow
					end
				end
			end

			if not (model.starfighter_update.starfighter.symbol ~ 'X') OR model.starfighter_update.starfighter.symbol ~ 'X' then
				implementation.put (model.starfighter_update.starfighter.symbol, model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos)
			end
		end

	move_enemy(old_x: INTEGER; old_y: INTEGER; new_x: INTEGER; new_y: INTEGER; e: ENEMY)
		do
			if not (old_x > num_rows OR old_y > num_cols OR old_x < 1 OR old_y <1 ) then
					if model.starfighter_update.starfighter.get_distance (old_x, old_y) > (model.starfighter_update.starfighter.vision) AND not model.debug_flag then
						implementation.put ('?', old_x, old_y)
					else
						implementation.put ('_', old_x, old_y)
					end
				end
				if not (new_x > num_rows OR new_y > num_cols OR new_x < 1 OR new_y < 1) then
					if model.starfighter_update.starfighter.get_distance (new_x, new_y) > (model.starfighter_update.starfighter.vision) AND not model.debug_flag then
							implementation.put ('?', new_x, new_y)
					else
						implementation.put (e.symbol, new_x, new_y)
					end

				end
		end

	move_starfighter_board(old_x: INTEGER; old_y:INTEGER)
		do
			implementation.put ('_', old_x, old_y)
			implementation.put (model.starfighter_update.starfighter.symbol, model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos)
			update_fow
		end

	display_enemy
		local
			enemies: LINKED_LIST[ENEMY]
		do
			make_model
			enemies := model.enemy_update.spawn_enemy
			across
				enemies is e
			loop
				if not e.dont_care AND not (implementation.item (e.x_pos, e.y_pos) ~ '?') then
					implementation.put (e.symbol, e.x_pos, e.y_pos)
				end

			end

		end

	update_fow
		do
			make_model
			across 1 |..| num_rows is h loop
				across 1 |..| num_cols is w loop
					if implementation.item (h, w)  = '?' then
						implementation.put ('_', h, w)
					end
				end

			end -- end of row traversal

			if not model.debug_flag then
				across 1 |..| num_rows is h loop
					across 1 |..| num_cols is w loop
						if model.starfighter_update.starfighter.get_distance (h, w) > (model.starfighter_update.starfighter.vision) then
							implementation.put ('?', h, w)
						end
					end
				end -- end of row traversal
			else
				-- Do nothing
			end

		end

feature
	implementation: ARRAY2[CHARACTER]

feature -- Queries
	get_output: STRING
		local
			alphabet: ARRAY[STRING]
			i: INTEGER
			j: INTEGER
		do
			alphabet := <<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J">>
			create Result.make_from_string ("    ")
			-- Start first row of numbers creation
			across
				1 |..| num_cols is l_i
			loop
				Result.append(l_i.out)
				if l_i < num_cols then
					if l_i < 9 then
						Result.append("  ")
					else
						Result.append(" ")
					end
				end
			end
			Result.append("%N    ")
			-- End first row of number creation				
			across 1 |..| num_rows is h loop
				Result.append (alphabet[h])
				Result.append (" ")

				across 1 |..| num_cols is w loop
					Result.append(implementation[h,w].out)
					-- To ensure no extra whitespace at the end of each row
					if w < num_cols then
						Result.append ("  ")
					end -- end of if
				end -- end of column traversal
				if h < num_rows then
					Result.append("%N    ")
				end

			end -- end of row traversal
		end

end
