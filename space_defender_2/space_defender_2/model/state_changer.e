note
	description: "Summary description for {STATE_CHANGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_CHANGER
create
	make

feature
	make
		do
			create table.make(7,9)
		end
feature
	table: TRANSITION_TABLE
	index: INTEGER
feature
	start_game
		do

			table.put_state (create {NOT_STARTED}.make, 1)
			table.put_state (create {WEAPON_SETUP}.make, 2)
			table.put_state (create {ARMOUR_SETUP}.make, 3)
			table.put_state (create {ENGINE_SETUP}.make, 4)
			table.put_state (create {POWER_SETUP}.make, 5)
			table.put_state (create {SETUP_SUMMARY}.make, 6)
			table.put_state (create {IN_GAME}.make, 7)

			table.choose_initial (1)
			table.put_transition (2, 1, 2) -- INVOKING PLAY FROM NOT_STARTED, TO WEAPONS

			table.put_transition (1, 2, 1) -- FROM WEAPONS TO NOT_STARTED
			table.put_transition (3, 2, 3) -- FROM WEAPONS TO ARMOUR
			table.put_transition (4, 2, 4) -- FROM WEAPONS TO ENGINE
			table.put_transition (5, 2, 5) -- FROM WEAPONS TO POWER
			table.put_transition (6, 2, 6) -- FROM WEAPONS TO SUMMARY
			table.put_transition (7, 2, 7) -- FROM WEAPONS TO INGAME

			table.put_transition (1, 3, 1) -- FROM ARMOUR TO NOT_STARTED
			table.put_transition (2, 3, 2) -- FROM ARMOUR TO WEAPONS
			table.put_transition (4, 3, 4) -- FROM ARMOUR TO ENGINE
			table.put_transition (5, 3, 5) -- FROM ARMOUR TO POWER
			table.put_transition (6, 3, 6) -- FROM ARMOUR TO SUMMARY
			table.put_transition (7, 3, 7) -- FROM ARMOUR TO INGAME

			table.put_transition (1, 4, 1) -- FROM ENGINE TO NOT_STARTED
			table.put_transition (2, 4, 2) -- FROM ENGINE TO WEAPONS
			table.put_transition (3, 4, 3) -- FROM ENGINE TO ARMOUR
			table.put_transition (5, 4, 5) -- FROM ENGINE TO POWER
			table.put_transition (6, 4, 6) -- FROM ENGINE TO SUMMARY
			table.put_transition (7, 4, 7) -- FROM ENGINE TO INGAME

			table.put_transition (1, 5, 1) -- FROM POWER TO NOT_STARTED
			table.put_transition (2, 5, 2) -- FROM POWER TO WEAPONS
			table.put_transition (3, 5, 3) -- FROM POWER TO ARMOUR
			table.put_transition (4, 5, 4) -- FROM POWER TO ENGINE
			table.put_transition (6, 5, 6) -- FROM POWER TO SUMMARY
			table.put_transition (7, 5, 7) -- FROM POWER TO INGAME

			table.put_transition (1, 6, 1) -- FROM SUMMARY TO NOT_STARTED
			table.put_transition (2, 6, 2) -- FROM SUMMARY TO WEAPONS
			table.put_transition (3, 6, 3) -- FROM SUMMARY TO ARMOUR
			table.put_transition (4, 6, 4) -- FROM SUMMARY TO ENGINE
			table.put_transition (5, 6, 5) -- FROM SUMMARY TO POWER
			table.put_transition (7, 6, 7) -- FROM SUMMARY TO INGAME

			table.put_transition (1, 7, 1) -- INVOKING ABORT FROM INGAME, SLIGHTLY DIFFERENT THAN STATE NOT_STARTED, FROM INGAME TO NOT_STARTED (DIFFERENT DISPLAY)



			index := table.initial
			table.states [index].display
		end
	go_forward(m: INTEGER)
		local
			choice: INTEGER
		do
			if (index + m) >= 7 then -- If you go to far forward when calling setup_next, enter IN_GAME
				choice := 7
			else
				choice := index + m
			end
			index := table.transition.item (index, choice)
			table.states [index].display

		end

	go_backward(m: INTEGER)
		local
			choice: INTEGER
		do
			if (index - m) <= 1 then -- If you go too far back when calling setup_back, enter not_started
				choice := 1
			else
				choice := index - m
			end
			index := table.transition.item (index, choice)
			table.states [index].display


		end

	state_choice(c: INTEGER)
		do
			table.states [index].read (c)
			table.states [index].display
		end

	get_output: STRING
		do
			Result := table.states [index].get_output
		end

	display_current
		do
			table.states[index].display
		end

	get_state: STRING
		do
			Result := table.states [index].get_state
		end

end
