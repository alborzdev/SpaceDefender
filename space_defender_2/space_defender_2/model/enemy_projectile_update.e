note
	description: "Summary description for {ENEMY_PROJECTILE_UPDATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_UPDATE
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
			create proj_spawn_output.make_empty
			make_model
		end

feature
	projectiles: LINKED_LIST[PROJECTILE]
	move_output: STRING
	proj_spawn_output: STRING


feature
	spawn_projectile(e: ENEMY; mv: INTEGER; dmg: INTEGER)
		local
			collision_output: STRING
		do
			make_model
			create collision_output.make_empty
			projectiles.extend (create {ENEMY_PROJECTILE}.make (e.x_pos, e.y_pos - 1, mv, dmg, model.proj_update.proj_id))
			model.game_board.display_enemy_fire(get_projectile(model.proj_update.proj_id, projectiles))
			update_location(get_projectile(model.proj_update.proj_id, projectiles))
			model.projectile_access.add_projectile (get_projectile(model.proj_update.proj_id, projectiles))
			model.projectile_access.make_output

			proj_spawn_output.append("      A enemy projectile(id:" + get_projectile(model.proj_update.proj_id, projectiles).id.out + ") spawns at location ")
			proj_spawn_output.append(get_projectile(model.proj_update.proj_id, projectiles).location_output + ".%N")
			collision_output := model.check_collision.check_enemy_proj_collision (get_projectile(model.proj_update.proj_id, projectiles))
			if model.check_collision.collided then
				proj_spawn_output.append (collision_output + "%N")
			end

			model.enemy_update.set_enemy_action(proj_spawn_output)
			model.projectile_access.make_output
			model.proj_update.decr_proj_id

		end

	move_enemy_proj -- Moves all existing prrojectiles in the current linked list
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
						collision_output.append (model.check_collision.check_enemy_proj_collision (p))
						if model.check_collision.collided then
							collision_output.append ("%N")
							collision := true
						end
					end

				end -- End of a projectiles movement

				if not p.dont_care OR collision then -- AND NO COLIISION
					-- Now append move output for this current projectile if the move was sucessful
					model.game_board.move_proj(old_x, old_y, p.x_pos, p.y_pos, p.tag)
					update_location(p)
					move_output.append("    A enemy projectile(id:" + p.id.out + ") moves: [")
					move_output.append(p.convert_to_letter(old_x) + "," + old_y.out + "] -> ")
					move_output.append(p.location_output + "%N")
					if collision then
						move_output.append (collision_output)
					end
				end

			end
			model.projectile_access.make_output
			set_projectile_action(move_output)
		end

end
