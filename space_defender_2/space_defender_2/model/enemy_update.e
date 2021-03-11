note
	description: "Summary description for {ENEMY_UPDATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_UPDATE
create
	make

feature
	make
		do
			create {LINKED_LIST[ENEMY]} enemies.make
			enemy_id := 1
			create move_output.make_empty
			create enemy_action_output.make_empty
			create all_enemies_output.make_empty
			create spawn_output.make_empty
			create preemptive_output.make_empty
			make_model
		end

feature -- attributes
	enemies: LIST[ENEMY]
	enemy_id: INTEGER
	model: GAME
	move_output: STRING
	enemy_action_output: STRING
	all_enemies_output: STRING
	spawn_output: STRING
	preemptive_output: STRING

feature
	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end
feature
	spawn_enemy: LINKED_LIST[ENEMY]
		local
			x_loc: INTEGER
			num_type: INTEGER
			random: RANDOM_GENERATOR_ACCESS
			dont_spawn: BOOLEAN
		do
			make_model
			spawn_output.make_empty
			create Result.make
			x_loc := random.rchoose (1, model.game_board.num_rows)
			num_type := random.rchoose (1, 100)

			dont_spawn := across
							enemies is l_enemy
						some
							x_loc = l_enemy.x_pos AND model.game_board.num_cols = l_enemy.y_pos
						end
			if num_type >= model.game_board.pylon_thresh AND num_type < 101 then
				dont_spawn := true
			end

			if not dont_spawn then
				if num_type >= 1 AND num_type < model.game_board.grunt_thresh then
					enemies.extend (create {GRUNT}.make (x_loc, model.game_board.num_cols, 100, 1, 1, 5, enemy_id))

				elseif num_type >= model.game_board.grunt_thresh AND num_type < model.game_board.fighter_thresh then
					enemies.extend (create {FIGHTER}.make (x_loc, model.game_board.num_cols, 150, 5, 10, 10, enemy_id))

				elseif num_type >= model.game_board.fighter_thresh AND num_type < model.game_board.carrier_thresh then
					enemies.extend (create {CARRIER}.make (x_loc, model.game_board.num_cols, 200, 10, 15, 15, enemy_id))

				elseif num_type >= model.game_board.carrier_thresh AND num_type < model.game_board.interceptor_thresh then
					enemies.extend (create {INTERCEPTOR}.make (x_loc, model.game_board.num_cols, 50, 0, 0, 5, enemy_id))

				elseif num_type >= model.game_board.interceptor_thresh AND num_type < model.game_board.pylon_thresh then
					enemies.extend (create {PYLON}.make (x_loc, model.game_board.num_cols, 300, 0, 0, 5, enemy_id))
				end
				Result.extend(get_enemy(enemy_id)) -- Returns the enemy that was just created
				across
					Result is e
				loop
					update_location(e)
				end
				update_single_vision(get_enemy(enemy_id))
				enemy_id := enemy_id + 1
				enemies_output

				across
					Result is e
				loop
					spawn_output.append ("  A " + e.type + "(id:" + e.id.out + ") spawns at location " + e.location_output + ".%N")
				end
				spawn_output.append ("  ")
			end
		end

	move_enemy(spaces: INTEGER; e: ENEMY) -- Moves all existing enemies in the current linked list
		local
			old_x: INTEGER
			old_y: INTEGER
			collision_output: STRING
			collision: BOOLEAN
		do
			make_model
			create collision_output.make_empty
			old_x := e.x_pos
			old_y := e.y_pos
			across
				1 |..| spaces is l_i
			loop
				if not model.check_collision.check_enemy_in_front(e) AND not e.dont_care then
					e.decr_y(1)
					collision_output.append (model.check_collision.check_enemy_collision (e))
					if model.check_collision.collided then
						collision_output.append ("%N")
						collision := true
					end
				end

			end -- End of an enemies movement

			if not e.dont_care then
				-- Now append move output for this current projectile if the move was sucessful
				model.game_board.move_enemy(old_x, old_y, e.x_pos, e.y_pos, e)
				update_location(e)
				move_output.append("    A " + e.type + "(id:" + e.id.out + ") moves: [")
				move_output.append(e.convert_to_letter(old_x) + "," + old_y.out + "] -> ")
				move_output.append(e.location_output + "%N")
				if collision then
					move_output.append (collision_output)
				end
			end
			model.projectile_access.make_output
			set_enemy_action(move_output)
			enemies_output
		end

	move_interceptor(spaces: INTEGER; e: ENEMY): STRING -- Moves all existing enemies in the current linked list
		local
			old_x: INTEGER
			old_y: INTEGER
			collision_output: STRING
			collision: BOOLEAN
		do
			make_model
			create collision_output.make_empty
			create Result.make_empty
			old_x := e.x_pos
			old_y := e.y_pos
			across
				1 |..| spaces is l_i
			loop
				if e.upwards_move AND not e.dont_care AND not model.check_collision.check_enemy_above(e) then
					e.decr_x (1)
					collision_output.append (model.check_collision.check_enemy_collision (e))
					if model.check_collision.collided then
						collision_output.append ("%N")
						collision := true
					end
				elseif not e.upwards_move AND not e.dont_care AND not model.check_collision.check_enemy_below(e) then
					e.incr_x (1)
					collision_output.append (model.check_collision.check_enemy_collision (e))
					if model.check_collision.collided then
						collision_output.append ("%N")
						collision := true
					end

				end
			end

			if not e.dont_care then
				-- Now append move output for this current projectile if the move was sucessful
				model.game_board.move_enemy(old_x, old_y, e.x_pos, e.y_pos, e)
				update_location(e)
				Result.append("    A " + e.type + "(id:" + e.id.out + ") moves: [")
				Result.append(e.convert_to_letter(old_x) + "," + old_y.out + "] -> ")
				Result.append(e.location_output + "%N")
				if collision then
					Result.append (collision_output)
				end
			end
			model.projectile_access.make_output
			enemies_output
		
		end

	update_vision
		do
			make_model
			across
				enemies is e
			loop
				e.sf_seen(model.starfighter_update.starfighter)
			end
			enemies_output
		end

	update_single_vision(e: ENEMY)
		do
			make_model
			e.sf_seen(model.starfighter_update.starfighter)
		end

	preemptive_act
		do
			make_model
			preemptive_output.make_empty
			across
				enemies is e
			loop
				preemptive_output := e.preemptive_action(model.starfighter_update.starfighter)
				set_enemy_action(preemptive_output)
			end
		end

	enemy_act
		do
			make_model
			move_output.make_empty
			model.enemy_projectile_update.proj_spawn_output.make_empty
			across
				enemies is e
			loop
				if not e.end_turn then
					e.enemy_action
					move_output.make_empty
					model.enemy_projectile_update.proj_spawn_output.make_empty
				end
			end
		end

	update_location(e: ENEMY)
			do
				if e.out_of_bounds(model.game_board.num_rows, model.game_board.num_cols) then
					e.set_location("out of board")
					e.set_dont_care(true)
				else
					e.set_location("[" + e.convert_to_letter(e.x_pos) + "," + e.y_pos.out + "]")
				end
			end

	set_enemy_action(output: STRING)
			do
				make_model
				enemy_action_output.append (output)
			end

	enemies_output
		do
			all_enemies_output.make_empty
			across
				enemies is e
			loop
				if not e.dont_care then
					all_enemies_output.append ("    [" + e.id.out + "," + e.symbol.out + "]->health:" + e.health.out + "/" + e.total_hp.out)
					all_enemies_output.append (", Regen:" + e.regen_h.out + ", Armour:" + e.armour.out)
					all_enemies_output.append (", Vision:" + e.vision.out + ", seen_by_Starfighter:" + e.bool_to_string(e.seen_by_sf))
					all_enemies_output.append (", can_see_Starfighter:" + e.bool_to_string(e.can_see_sf) + ", location:" + e.location_output + "%N")
				end

			end
		end

	set_enemy_action_empty
		do
			enemy_action_output.make_empty
		end

feature -- queries
	get_enemy(identity: INTEGER): ENEMY
		require
			across
				enemies is e
			some
				e.id = identity
			end
		local
			enemy: GRUNT
		do
			create enemy.make(1,1,1,1,1,1,1)
			Result := enemy
			across
				enemies is e
			loop
				if e.id = identity then
					Result := e
				end
			end
		end
end
