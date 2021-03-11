note
	description: "Summary description for {PROJECTILE_UPDATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTILE_UPDATE
create
	make_proj_update

feature
	make_proj_update
		do
			make_model
			create projectile_action_output.make_empty
			proj_id := -1
		end

	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end

feature
	proj_id: INTEGER
	model: GAME
	projectile_action_output: STRING

feature
	incr_proj_id
		do
			proj_id := proj_id + 1
		end

	decr_proj_id
		do
			proj_id := proj_id - 1
		end

	update_location(p: PROJECTILE)
			do
				if p.out_of_bounds(model.game_board.num_rows, model.game_board.num_cols) then
					p.set_location("out of board")
					p.set_dont_care(true)
				else
					p.set_location("[" + p.convert_to_letter(p.x_pos) + "," + p.y_pos.out + "]")
				end
			end

	update_location_list(p_list: LINKED_LIST[PROJECTILE])
			do
				across
					p_list is p
				loop
					if p.out_of_bounds(model.game_board.num_rows, model.game_board.num_cols) then
						p.set_location("out of board")
						p.set_dont_care(true)
					else
						p.set_location("[" + p.convert_to_letter(p.x_pos) + "," + p.y_pos.out + "]")
					end
				end
			end

	set_projectile_action(output: STRING)
			do
				make_model
				create projectile_action_output.make_from_string("")
				projectile_action_output.append (output)
			end

feature -- Commands
	get_projectile(identity: INTEGER; projectile_list: LINKED_LIST[PROJECTILE]): PROJECTILE -- Returns a projectile based on its ID
		require
			across
				projectile_list is p
			some
				p.id = identity
			end
		local
			proj: STANDARD_PROJECTILE
		do
			create proj.make (1, 1, 1, 1, 1, 1)
			Result := proj
			across
				projectile_list is p
			loop
				if p.id = identity then
					Result := p
				end
			end
		end
end
