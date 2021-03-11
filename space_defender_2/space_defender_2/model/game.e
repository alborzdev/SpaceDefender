note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ANY
		redefine
			out
		end

create {GAME_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			end_game := false
			create s.make_empty
			i := 0
			create state_changer.make
			in_state := true
			state_changer.start_game
			mode := "normal"
			create error.make
			output := state_changer.get_output
			create game_board.make
			create starfighter_update.make
			create friendly_projectile_update.make
			create projectile_access.make
			create enemy_update.make
			create proj_update.make_proj_update
			create enemy_projectile_update.make
			create check_collision.make
			create scoring.make

		end

feature -- model attributes
	s : STRING
	i : INTEGER
	end_game: BOOLEAN
	num_error: INTEGER
	state_changer: STATE_CHANGER
	game_board: GAME_BOARD
	friendly_projectile_update: FRIENDLY_PROJECTILE_UPDATE
	enemy_projectile_update: ENEMY_PROJECTILE_UPDATE
	starfighter_update: STARFIGHTER_UPDATE
	in_state: BOOLEAN
	debug_flag: BOOLEAN
	mode: STRING
	error: ERROR
	output: STRING
	projectile_access: PROJECTILES
	enemy_update: ENEMY_UPDATE
	random: RANDOM_GENERATOR_ACCESS
	proj_update: PROJECTILE_UPDATE
	check_collision: COLLISION
	scoring: SCORING

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	play(row: INTEGER; column: INTEGER; g_threshold: INTEGER; f_threshold: INTEGER; c_threshold: INTEGER; i_threshold: INTEGER; p_threshold: INTEGER)
		do
			i := i + 1
			s := "play"
			setup_next(1)
			game_board.play(row,column,g_threshold,f_threshold,c_threshold,i_threshold,p_threshold)
		end

	setup_select(value: INTEGER) -- Used in setup mode to select menu options
		do
			i := i + 1
			s := "setup_select"
			state_changer.state_choice (value)
		end

  	setup_next(state: INTEGER) -- Go forward setup mode by state states
  		do
  			i := i + 1
			s := "setup_next"
			state_changer.go_forward (state)
			output := state_changer.get_output
  		end

  	setup_back(state: INTEGER)  -- Go back setup mode by state states
  		do
  			i := i + 1
			s := "setup_back"
			state_changer.go_backward (state)
			output := state_changer.get_output
  		end

  	toggle_debug_mode
	   -- Toggles a flag.
	   -- If flag is true, display additional information such as all the
	   -- entities on the board (including projectiles).
	   -- You would normally only know about your ship.
	   -- Flag being true also turns off fog of war.
	   do
	   		i := i + 1
			s := "debug"
			if debug_flag then
				debug_flag := false
				output := "Not in debug mode."
				mode := "normal"
			else
				debug_flag := true
				output := "In debug mode."
				mode := "debug"
			end
			incr_num_error
			game_board.update_fow

	   end

	abort
	   -- Ends the game prematurely. Only valid when game is
	   -- in progress.
	   do
	   		i := i + 1
			s := "abort"
			if state_changer.index > 1 AND state_changer.index < 7 then
				state_changer.go_backward (state_changer.index - 1)
				output := "Exited from setup mode."
			elseif state_changer.index = 7 AND not end_game then
				state_changer.go_backward (state_changer.index - 1)
				output := "Exited from game."
			elseif state_changer.index = 7 AND end_game then
				state_changer.go_backward (state_changer.index - 1)
			end

	   end

	move (row: INTEGER; column: INTEGER)
	   -- Moves the Starfighter to location assuming movement is feasible.
	   -- Note that this command will cause a turn to pass/occur.
	   do
	   		starfighter_update.starfighter.set_current_action("move")
			if not friendly_projectile_update.projectiles.is_empty then -- MOVING FRIENDLY PROJ's
				friendly_projectile_update.move_proj
			end
			if end_game then
				end_game_command
			else
				if not enemy_projectile_update.projectiles.is_empty then
				enemy_projectile_update.move_enemy_proj
				end
				if end_game then
					end_game_command
				else
					starfighter_update.move_starfighter(row, column) -- STARFIGHTER ACT
					if end_game then
						end_game_command
					else
						enemy_update.update_vision-- UPDATE ENEMY VISION (update the seen by starfighter and can see starfighter since starfighter has moved)
						enemy_update.preemptive_act -- ENEMYS ACT (preemptive first, might end the turn it might not
						if end_game then
							end_game_command
						else
							enemy_update.enemy_act -- ENEMYS ACT (preemptive first, might end the turn it might not
							if end_game then
								end_game_command
							else
								enemy_update.update_vision-- UPDATE ENEMY VISION AGAIN (after every enemy has acted)
								game_board.display_enemy -- ENEMY SPAWN (if spawns in enemy location, dont spawn and DONT create ID)
								if end_game then
									end_game_command
								else
									game_board.update_dont_cares
									state_changer.display_current
								end
							end
						end
					end
				end
			end



	   end

	pass
	   -- Starfighter passes a turn.
	   -- Note that this command will cause a turn to pass/occur.
	   do
	   		starfighter_update.starfighter.set_current_action("pass")
	   		if not friendly_projectile_update.projectiles.is_empty then -- MOVING FRIENDLY PROJ's
				friendly_projectile_update.move_proj
			end
			if end_game then
				end_game_command
			else
				if not enemy_projectile_update.projectiles.is_empty then
				enemy_projectile_update.move_enemy_proj
				end
				if end_game then
					end_game_command
				else
					starfighter_update.pass -- STARFIGHTER ACT
					if end_game then
						end_game_command
					else
						enemy_update.update_vision-- UPDATE ENEMY VISION (update the seen by starfighter and can see starfighter since starfighter has moved)
						enemy_update.preemptive_act -- ENEMYS ACT (preemptive first, might end the turn it might not
						if end_game then
							end_game_command
						else
							enemy_update.enemy_act -- ENEMYS ACT (preemptive first, might end the turn it might not
							if end_game then
								end_game_command
							else
								enemy_update.update_vision-- UPDATE ENEMY VISION AGAIN (after every enemy has acted)
								game_board.display_enemy -- ENEMY SPAWN (if spawns in enemy location, dont spawn and DONT create ID)
								if end_game then
									end_game_command
								else
									game_board.update_dont_cares
									state_changer.display_current
								end
							end
						end
					end
				end
			end
	   		i := i + 1
			s := "pass"
	   end

	fire
	   -- Starfighter fires a projectile.
	   -- Note that this command will cause a turn to pass/occur.
	   do
	   		starfighter_update.starfighter.set_current_action("fire")
	   		if not friendly_projectile_update.projectiles.is_empty then -- MOVING FRIENDLY PROJ's
				friendly_projectile_update.move_proj
			end
			if end_game then
				end_game_command
			else
				if not enemy_projectile_update.projectiles.is_empty then
				enemy_projectile_update.move_enemy_proj
				end
				if end_game then
					end_game_command
				else
					game_board.display_fire -- STARFIGHTER ACT
					if end_game then
						end_game_command
					else
						enemy_update.update_vision-- UPDATE ENEMY VISION (update the seen by starfighter and can see starfighter since starfighter has moved)
						enemy_update.preemptive_act -- ENEMYS ACT (preemptive first, might end the turn it might not
						if end_game then
							end_game_command
						else
							enemy_update.enemy_act -- ENEMYS ACT (preemptive first, might end the turn it might not
							if end_game then
								end_game_command
							else
								enemy_update.update_vision-- UPDATE ENEMY VISION AGAIN (after every enemy has acted)
								game_board.display_enemy -- ENEMY SPAWN (if spawns in enemy location, dont spawn and DONT create ID)
								if end_game then
									end_game_command
								else
									game_board.update_dont_cares
									state_changer.display_current
								end
							end
						end
					end
				end
			end

	   end

	special
	   -- Starfighter uses a special ability.
	   -- Note that this command will cause a turn to pass/occur.
	   do
	   		starfighter_update.starfighter.set_current_action("special")
	   		if not friendly_projectile_update.projectiles.is_empty then -- MOVING FRIENDLY PROJ's
				friendly_projectile_update.move_proj
			end
			if end_game then
				end_game_command
			else
				if not enemy_projectile_update.projectiles.is_empty then
				enemy_projectile_update.move_enemy_proj
				end
				if end_game then
					end_game_command
				else
					starfighter_update.special -- STARFIGHTER ACT
					if end_game then
						end_game_command
					else
						enemy_update.update_vision-- UPDATE ENEMY VISION (update the seen by starfighter and can see starfighter since starfighter has moved)
						enemy_update.preemptive_act -- ENEMYS ACT (preemptive first, might end the turn it might not
						if end_game then
							end_game_command
						else
							enemy_update.enemy_act -- ENEMYS ACT (preemptive first, might end the turn it might not
							if end_game then
								end_game_command
							else
								enemy_update.update_vision-- UPDATE ENEMY VISION AGAIN (after every enemy has acted)
								game_board.display_enemy -- ENEMY SPAWN (if spawns in enemy location, dont spawn and DONT create ID)
								if end_game then
									end_game_command
								else
									game_board.update_dont_cares
									state_changer.display_current
								end
							end
						end
					end
				end
			end
	   end

	reset
			-- Reset model state.
		do
			make
		end

	set_num_error(amount: INTEGER)
		do
			num_error := amount
		end

	incr_num_error
		do
			num_error := num_error + 1
		end

	set_end_game(b: BOOLEAN)
		do
			end_game := b
		end
	end_game_command
		do
			projectile_access.make_output
			enemy_update.enemies_output
			game_board.update_dont_cares
			state_changer.display_current
			abort
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("state:")
			Result.append(state_changer.get_state)
			if state_changer.get_state ~ "in game" then
				Result.append("(" + state_changer.table.states[7].get_type + "." + num_error.out + ")")
			end
			Result.append (", " + mode + ", " + error.error_state + "%N  ")
			if error.has_error then
				Result.append(error.error_message)
			else
				Result.append (output)
			end

			error.disable_error
			output := state_changer.get_output

		end

end




