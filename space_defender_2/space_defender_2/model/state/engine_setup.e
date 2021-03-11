note
	description: "Summary description for {ENGINE_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_SETUP
inherit
	STATE_MAIN
create
	make

feature {SETUP_SUMMARY}
	s: STRING
	engine_type: STRING

feature
	make
		do
			create s.make_empty
			engine_type := "Standard"
			health := 10
			energy := 60
			regen_h := 0
			regen_e := 2
			armour := 1
			vision := 12
			move := 8
			move_cost := 2
			make_model
			power_choice := ""
		end

feature
	display
		do
			s.make_empty
			s.append("1:Standard%N    ")
			s.append("Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2%N  ")
			s.append ("2:Light%N    ")
			s.append ("Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1%N  ")
			s.append ("3:Armoured%N    ")
			s.append ("Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5%N  ")
			s.append ("Engine Selected:" + engine_type)
		end
	read(choice: INTEGER)
		do
			if choice = 1 then
				engine_type := "Standard"
				health := 10
				energy := 60
				regen_h := 0
				regen_e := 2
				armour := 1
				vision := 12
				move := 8
				move_cost := 2
			elseif choice = 2 then
				engine_type := "Light"
				health := 0
				energy := 30
				regen_h := 0
				regen_e := 1
				armour := 0
				vision := 15
				move := 10
				move_cost := 1
			elseif choice = 3 then
				engine_type := "Armoured"
				health := 50
				energy := 100
				regen_h := 0
				regen_e := 3
				armour := 3
				vision := 6
				move := 4
				move_cost := 5

			end
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "engine setup"
		end

	get_type: STRING
		do
			Result := engine_type
		end
end
