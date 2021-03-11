note
	description: "Summary description for {ARMOUR_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_SETUP
inherit
	STATE_MAIN
create
	make

feature {SETUP_SUMMARY}
	s: STRING
	armour_type: STRING

feature
	make
		do
			create s.make_empty
			armour_type := "None"
			health := 50
			energy := 0
			regen_h := 1
			regen_e := 0
			armour := 0
			vision := 0
			move := 1
			move_cost := 0
			make_model
			power_choice := ""
		end

feature
	display
		do
			s.make_empty
			s.append("1:None%N    ")
			s.append("Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0%N  ")
			s.append("2:Light%N    ")
			s.append("Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1%N  ")
			s.append("3:Medium%N    ")
			s.append("Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3%N  ")
			s.append("4:Heavy%N    ")
			s.append("Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5%N  ")
			s.append("Armour Selected:" + armour_type)
		end

	read(choice: INTEGER)
		do
			if choice = 1 then
				armour_type := "None"
				health := 50
				energy := 0
				regen_h := 1
				regen_e := 0
				armour := 0
				vision := 0
				move := 1
				move_cost := 0
			elseif choice = 2 then
				armour_type := "Light"
				health := 75
				energy := 0
				regen_h := 2
				regen_e := 0
				armour := 3
				vision := 0
				move := 0
				move_cost := 1
			elseif choice = 3 then
				armour_type := "Medium"
				health := 100
				energy := 0
				regen_h := 3
				regen_e := 0
				armour := 5
				vision := 0
				move := 0
				move_cost := 3
			elseif choice = 4 then
				armour_type := "Heavy"
				health := 200
				energy := 0
				regen_h := 4
				regen_e := 0
				armour := 10
				vision := 0
				move := -1
				move_cost := 5

			end
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "armour setup"
		end

	get_type: STRING
		do
			Result := armour_type
		end
end
