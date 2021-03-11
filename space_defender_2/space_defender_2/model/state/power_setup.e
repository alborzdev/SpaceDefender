note
	description: "Summary description for {POWER_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POWER_SETUP
inherit
	STATE_MAIN
create
	make

feature {SETUP_SUMMARY}
	s: STRING
	power_type: STRING
	

feature
	make
		do
			create s.make_empty
			power_type := "Recall (50 energy): Teleport back to spawn."
			power_choice := "rec"
			power_cost := 50
			make_model
		end

feature
	display
		do
			s.make_empty
			s.append("1:Recall (50 energy): Teleport back to spawn.%N  ")
			s.append ("2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.%N  ")
			s.append ("3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.%N  ")
			s.append ("4:Deploy Drones (100 energy): Clear all projectiles.%N  ")
			s.append ("5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.%N  ")
			s.append ("Power Selected:" + power_type)
		end

	read(choice: INTEGER)
		do
			if choice = 1 then
				power_type := "Recall (50 energy): Teleport back to spawn."
				power_choice := "rec"
				power_cost := 50
			elseif choice = 2 then
				power_type := "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap."
				power_choice := "rep"
				power_cost := 50
			elseif choice = 3 then
				power_type := "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap."
				power_choice := "ove"
				power_cost := 50 -- HEALTH
			elseif choice = 4 then
				power_type := "Deploy Drones (100 energy): Clear all projectiles."
				power_choice := "dep"
				power_cost := 100
			elseif choice = 5 then
				power_type := "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour."
				power_choice := "orb"
				power_cost := 100
			end
		end

	get_output: STRING
		do
			Result := s
		end

	get_state: STRING
		do
			Result := "power setup"
		end

	get_type: STRING
		do
			Result := power_type
		end
end
