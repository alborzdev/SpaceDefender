note
	description: "Summary description for {STATE_MAIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE_MAIN
feature
	model: GAME
	health: INTEGER
	energy: INTEGER
	regen_h: INTEGER
	regen_e: INTEGER
	armour: INTEGER
	vision: INTEGER
	move: INTEGER
	move_cost: INTEGER
	proj_damage: INTEGER
	proj_cost: INTEGER
	end_game_output: BOOLEAN
	power_choice: STRING
	power_cost: INTEGER

feature

	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end

	read(choice: INTEGER) deferred end

	display deferred end

	get_output: STRING deferred end

	get_state: STRING deferred end

	get_type: STRING deferred end

	set_end_game_output(b: BOOLEAN)
		do
			end_game_output := b
		end

	get_power_choice: STRING
		do
			Result := power_choice
		end



end
