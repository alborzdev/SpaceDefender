note
	description: "Summary description for {FRIENDLY_PROJECTILE_UPDATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_UPDATE
inherit
	PROJECTILE_UPDATE
create
	make

feature
	make
		do
			create projectiles.make
			create move_output.make_empty
			create projectile_action_output.make_empty
			make_model
		end

feature
	projectiles: LINKED_LIST[PROJECTILE]
	move_output: STRING
feature
	create_projectile: LINKED_LIST[PROJECTILE]
		do
			make_model
			create Result.make
			model.starfighter_update.starfighter.apply_regen
			if model.state_changer.table.states[2].get_type ~ "Standard" then
				projectiles.extend (create {STANDARD_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos + 1, 5, 5, 70, model.proj_update.proj_id))
				model.starfighter_update.starfighter.decr_energy (5)

			elseif model.state_changer.table.states[2].get_type ~ "Spread" then
				projectiles.extend (create {SPREAD_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos - 1, model.starfighter_update.starfighter.y_pos + 1, 10, 1, 50, model.proj_update.proj_id, "top"))
				Result.extend (get_projectile(model.proj_update.proj_id, projectiles))
				model.projectile_access.add_projectile (get_projectile(model.proj_update.proj_id, projectiles)) -- ADD THE PORJECTILE TO THE TOTAL PROJECTILE LIST
				model.proj_update.decr_proj_id

				projectiles.extend (create {SPREAD_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos + 1, 10, 1, 70, model.proj_update.proj_id, "mid"))
				Result.extend (get_projectile(model.proj_update.proj_id, projectiles))
				model.projectile_access.add_projectile (get_projectile(model.proj_update.proj_id, projectiles)) -- ADD THE PORJECTILE TO THE TOTAL PROJECTILE LIST
				model.proj_update.decr_proj_id

				projectiles.extend (create {SPREAD_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos + 1, model.starfighter_update.starfighter.y_pos + 1, 10, 1, 70, model.proj_update.proj_id, "bottom"))
				model.starfighter_update.starfighter.decr_energy (10)

			elseif model.state_changer.table.states[2].get_type ~ "Snipe" then
				projectiles.extend (create {SNIPE_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos + 1, 20, 1, 1000, model.proj_update.proj_id))
				model.starfighter_update.starfighter.decr_energy (20)

			elseif model.state_changer.table.states[2].get_type ~ "Rocket" then
				projectiles.extend (create {ROCKET_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos -1, model.starfighter_update.starfighter.y_pos - 1, 10, 1, 100, model.proj_update.proj_id))
				Result.extend (get_projectile(model.proj_update.proj_id, projectiles))
				model.projectile_access.add_projectile (get_projectile(model.proj_update.proj_id, projectiles)) -- ADD THE PORJECTILE TO THE TOTAL PROJECTILE LIST
				model.proj_update.decr_proj_id

				projectiles.extend (create {ROCKET_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos + 1, model.starfighter_update.starfighter.y_pos - 1, 10, 1, 100, model.proj_update.proj_id))
				model.starfighter_update.starfighter.decr_health (10)

			elseif model.state_changer.table.states[2].get_type ~ "Splitter" then
				projectiles.extend (create {SPLITTER_PROJECTILE}.make (model.starfighter_update.starfighter.x_pos, model.starfighter_update.starfighter.y_pos + 1, 70, 0, 150, model.proj_update.proj_id))
				model.starfighter_update.starfighter.decr_energy (70)
			end
			Result.extend (get_projectile(model.proj_update.proj_id, projectiles)) -- Add the newly made projectile to the result

			update_location_list(Result)

			model.projectile_access.add_projectile (get_projectile(model.proj_update.proj_id, projectiles)) -- ADD THE PROJECTILE TO THE TOTAL PROJECTILE LIST
			model.starfighter_update.set_fire_action (Result)
			model.projectile_access.make_output
			model.proj_update.decr_proj_id
		end

	move_proj -- Moves all existing prrojectiles in the current linked list
		local
			old_x: INTEGER
			old_y: INTEGER
			collision_output: STRING
			collision: BOOLEAN
		do
			make_model
			move_output.make_empty
			create collision_output.make_empty
			across
				projectiles is p
			loop
				collision := false
				old_x := p.x_pos
				old_y := p.y_pos
				across
					1 |..| p.move is l_i
				loop
					if not p.dont_care then
						p.increment

						collision_output.append (model.check_collision.check_friendly_proj_collision (p))
						if model.check_collision.collided then
							collision_output.append ("%N")
							collision := true
						end
					end
					if p.type ~ "Rocket" AND l_i = p.move then
						p.multiply_move
					end
				end -- End of a projectiles movement

				if not p.dont_care OR collision then -- AND NO COLIISION
					-- Now append move output for this current projectile if the move was sucessful
					model.game_board.move_proj(old_x, old_y, p.x_pos, p.y_pos, p.tag)
					update_location(p)
					if old_x = p.x_pos AND old_y = p.y_pos then
						move_output.append("    A friendly projectile(id:" + p.id.out + ") stays at: [")
						move_output.append(p.convert_to_letter(old_x) + "," + old_y.out + "]%N")
						if collision then
							move_output.append (collision_output)
						end
					else
						move_output.append("    A friendly projectile(id:" + p.id.out + ") moves: [")
						move_output.append(p.convert_to_letter(old_x) + "," + old_y.out + "] -> ")
						move_output.append(p.location_output + "%N")
						if collision then
							move_output.append (collision_output)
						end
					end
				end

			end
			model.projectile_access.make_output
			set_projectile_action(move_output)
		end
end
