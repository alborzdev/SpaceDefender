note
	description: "Summary description for {WEAPON_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SETUP
inherit
	STATE_MAIN
create
	make

feature {SETUP_SUMMARY}
	s: STRING
	weapon_type: STRING

feature
	make
		do
			create s.make_empty
			weapon_type := "Standard"
			health := 10
			energy := 10
			regen_h := 0
			regen_e := 1
			armour := 0
			vision := 1
			move := 1
			move_cost := 1
			proj_damage := 70
			proj_cost := 5
			make_model
			power_choice := ""
		end

feature
	display
		do
			s.make_empty
			s.append ("1:Standard (A single projectile is fired in front)%N    ")
			s.append ("Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,%N    ")
			s.append ("Projectile Damage:70, Projectile Cost:5 (energy)%N  ")
			s.append ("2:Spread (Three projectiles are fired in front, two going diagonal)%N    ")
			s.append ("Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,%N    ")
			s.append ("Projectile Damage:50, Projectile Cost:10 (energy)%N  ")
			s.append ("3:Snipe (Fast and high damage projectile, but only travels via teleporting)%N    ")
			s.append ("Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,%N    ")
			s.append ("Projectile Damage:1000, Projectile Cost:20 (energy)%N  ")
			s.append ("4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)%N    ")
			s.append ("Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,%N    ")
			s.append ("Projectile Damage:100, Projectile Cost:10 (health)%N  ")
			s.append ("5:Splitter (A single mine projectile is placed in front of the Starfighter)%N    ")
			s.append ("Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,%N    ")
			s.append ("Projectile Damage:150, Projectile Cost:70 (energy)%N  ")
			s.append ("Weapon Selected:" + weapon_type)
		end
	read(choice: INTEGER)
		do
			if choice = 1 then
				weapon_type := "Standard"
				health := 10
				energy := 10
				regen_h := 0
				regen_e := 1
				armour := 0
				vision := 1
				move := 1
				move_cost := 1
				proj_damage := 70
				proj_cost := 5
			elseif choice = 2 then
				weapon_type := "Spread"
				health := 0
				energy := 60
				regen_h := 0
				regen_e := 2
				armour := 1
				vision := 0
				move := 0
				move_cost := 2
				proj_damage := 50
				proj_cost := 10
			elseif choice = 3 then
				weapon_type := "Snipe"
				health := 0
				energy := 100
				regen_h := 0
				regen_e := 5
				armour := 0
				vision := 10
				move := 3
				move_cost := 0
				proj_damage := 1000
				proj_cost := 20
			elseif choice = 4 then
				weapon_type := "Rocket"
				health := 10
				energy := 0
				regen_h := 10
				regen_e := 0
				armour := 2
				vision := 2
				move := 0
				move_cost := 3
				proj_damage := 100
				proj_cost := 10
			elseif choice = 5 then
				weapon_type := "Splitter"
				health := 0
				energy := 100
				regen_h := 0
				regen_e := 10
				armour := 0
				vision := 0
				move := 0
				move_cost := 5
				proj_damage := 150
				proj_cost := 70
			end
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "weapon setup"
		end

	get_type: STRING
		do
			Result := weapon_type
		end
end
