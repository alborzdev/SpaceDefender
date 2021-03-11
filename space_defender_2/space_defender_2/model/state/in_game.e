note
	description: "Summary description for {IN_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IN_GAME
inherit
	STATE_MAIN
create
	make

feature {SETUP_SUMMARY}
	s: STRING
	num_state: INTEGER
	num_error: INTEGER
	first: BOOLEAN

feature
	make
		do
			create s.make_empty
			make_model
			first := true
			num_state := -1
			create power_choice.make_empty
		end

feature
	display
		do
			s.make_empty
			make_model
			model.set_num_error(0)
			num_state := num_state + 1
			if first then
				model.starfighter_update.make_starfighter(model.game_board.num_rows)
			end
			first := false
			s.append (model.starfighter_update.get_output)
			if model.debug_flag then
				s.append ("Enemy:%N")
				s.append (model.enemy_update.all_enemies_output)

				s.append ("  Projectile:%N")
				s.append (model.projectile_access.all_output)

				s.append ("  Friendly Projectile Action:%N")
				s.append (model.friendly_projectile_update.projectile_action_output)

				s.append ("  Enemy Projectile Action:%N")
				s.append (model.enemy_projectile_update.projectile_action_output)

				s.append ("  Starfighter Action:%N")
				s.append (model.starfighter_update.starfighter_action_output)

				s.append ("  Enemy Action:%N")
				s.append (model.enemy_update.enemy_action_output)
				model.enemy_update.set_enemy_action_empty

				s.append ("  Natural Enemy Spawn:%N  ")
				s.append (model.enemy_update.spawn_output)


			end
			model.enemy_update.set_enemy_action_empty
			s.append (model.game_board.get_output)
			if model.end_game then
				s.append ("%N  The game is over. Better luck next time!")
			end


		end

	read(choice: INTEGER)
		do
			print("reading choice")
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "in game"
		end

	get_type: STRING
		do
			Result := num_state.out
		end
	incr_error
		do
			num_error := num_error + 1
		end
end
