note
	description: "Summary description for {SETUP_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETUP_SUMMARY
inherit
	STATE_MAIN
create
	make

feature
	s: STRING

feature
	make
		do
			create s.make_empty
			make_model
			power_choice := ""
		end

feature
	display
		do
			make_model
			s.make_empty
			s.append ("Weapon Selected:" + model.state_changer.table.states[2].get_type)
			s.append ("%N  Armour Selected:" + model.state_changer.table.states[3].get_type)
			s.append ("%N  Engine Selected:" + model.state_changer.table.states[4].get_type)
			s.append ("%N  Power Selected:" + model.state_changer.table.states[5].get_type)
		end

	read(choice: INTEGER)
		do
			-- NO CHOICE FOR THIS CLASS
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "setup summary"
		end

	get_type: STRING
		do
			Result := "" -- nothing yet
		end
end
