note
	description: "Summary description for {NOT_STARTED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOT_STARTED
inherit
	STATE_MAIN
create
	make

feature {NONE}
	s: STRING

feature
	make
		do
			create s.make_empty
			make_model
			end_game_output := false
			create power_choice.make_empty
		end

feature
	display
		do
			make_model
			s.make_empty
			s.append("Welcome to Space Defender Version 2.")
		end
	read(choice: INTEGER)
		do
			-- NO SELECT FOR THIS STATE
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "not started"
		end

	get_type: STRING
		do
			Result := ""	-- nothing yet
		end





end
