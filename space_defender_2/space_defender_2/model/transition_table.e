note
	description: "Summary description for {TRANSITION_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRANSITION_TABLE
create
	make
feature
	transition: ARRAY2[INTEGER]
	states: ARRAY[STATE_MAIN]

feature
	initial: INTEGER
	number_of_states: INTEGER -- 7 states
	number_of_choices: INTEGER --9 possible choices
	make(n, m: INTEGER)
		do
			number_of_states := n
			number_of_choices := m
			create transition.make_filled(0, n, m)
			create states.make_empty
		end

feature
	put_state(s: STATE_MAIN; index: INTEGER)
		do states.force (s, index) end
	choose_initial(index: INTEGER)
		do initial := index end
	put_transition(tar, src, choice: INTEGER)
		do
			transition.put (tar, src, choice)
		end


invariant
	transition.height = number_of_states
	transition.width = number_of_choices


end
