note
	description: "Summary description for {ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR
create
	make

feature
	make
		do
			create error_message.make_empty
			error_state := "ok"
			make_model
		end

feature -- Attributes
	has_error: BOOLEAN
	error_state: STRING
	error_message: STRING
	model: GAME

feature
	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end
feature -- Commands

	enable_error (message: STRING)
		do
			make_model
			has_error := true
			error_message := message
			error_state := "error"
			model.incr_num_error
		end

	disable_error
		do
			has_error := false
			error_state := "ok"
		end


end
