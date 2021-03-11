note
	description: "Summary description for {COLLISION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLLISION
create
	make

feature
	make
		do
			make_model
			create collision_output.make_empty
		end

feature
	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end


feature -- Attribitues
	model: GAME
	collision_output: STRING
	collided: BOOLEAN



feature -- Commmands
	check_friendly_proj_collision(p: PROJECTILE): STRING
		local
			output: STRING
		do
			collided := false
			make_model
			create Result.make_empty
			create output.make_empty
			across -- COLLISION WITH ENEMY PROJ
				model.enemy_projectile_update.projectiles is e_p
			loop
				if p.x_pos = e_p.x_pos AND p.y_pos = e_p.y_pos AND not e_p.dont_care then -- COLLISION WITH ENEMY PROJ
					output.append("      The projectile collides with enemy projectile(id:" + e_p.id.out + ") at location " + e_p.location_output + ", negating damage.")
					if e_p.damage > p.damage then
						p.set_dont_care (true)
						e_p.decr_damage(p.damage)
					elseif p.damage > e_p.damage then -- p will continue its route
						e_p.set_dont_care(true)
						p.decr_damage(e_p.damage)
					else
						p.set_dont_care (true)
						e_p.set_dont_care(true)
					end
					collided := true
				end
			end

			across -- COLLISION WITH FRIENDLY PROJ
				model.friendly_projectile_update.projectiles is f_p
			loop
				if p.x_pos = f_p.x_pos AND p.y_pos = f_p.y_pos AND not f_p.dont_care AND not (f_p.id = p.id) then
					output.append("      The projectile collides with friendly projectile(id:" + f_p.id.out + ") at location " + f_p.location_output + ", combining damage.")
					f_p.set_dont_care(true)
					p.incr_damage (f_p.damage)
					collided := true
				end -- p will continue its route
			end


			across
				model.enemy_update.enemies is e
			loop
				if p.x_pos = e.x_pos AND p.y_pos = e.y_pos AND not e.dont_care then
					output.append("      The projectile collides with " + e.type + "(id:" + e.id.out + ") at location " + e.location_output + ", dealing " + max(p.damage - e.armour, 0).out + " damage.")
					p.set_dont_care (true)
					e.decr_health(max(p.damage - e.armour, 0))
					if e.health <= 0 then
						output.append ("%N      The " + e.type + " at location " + e.location_output + " has been destroyed.")
						e.set_dont_care(true) -- DESTROY AND REMOVE FROM BOARD
						model.scoring.incr_score(2)
					end
					collided := true
				end
			end

			if p.x_pos = model.starfighter_update.starfighter.x_pos AND p.y_pos = model.starfighter_update.starfighter.y_pos then
				output.append("      The projectile collides with Starfighter(id:0) at location " + model.starfighter_update.starfighter.location_output + ", dealing " + max(p.damage - model.starfighter_update.starfighter.armour, 0).out + " damage.")
				p.set_dont_care (true)
				model.starfighter_update.starfighter.decr_health(max(p.damage - model.starfighter_update.starfighter.armour, 0))
				if model.starfighter_update.starfighter.health <= 0 then
					output.append ("%N      The Starfighter at location " + model.starfighter_update.starfighter.location_output + " has been destroyed.")
					model.starfighter_update.starfighter.set_health (0)
					model.starfighter_update.starfighter.set_symbol ('X')
					model.set_end_game (true)
				end
				collided := true
			end
			Result.append (output)
		end

	check_enemy_proj_collision(p: PROJECTILE): STRING
		local
			output: STRING
		do
			collided := false
			make_model
			create output.make_empty
			create Result.make_empty
			across -- COLLISION WITH FRIENDLY PROJ
				model.friendly_projectile_update.projectiles is f_p
			loop
				if p.x_pos = f_p.x_pos AND p.y_pos = f_p.y_pos AND not f_p.dont_care then -- COLLISION WITH ENEMY PROJ
					output.append("      The projectile collides with friendly projectile(id:" + f_p.id.out + ") at location " + f_p.location_output + ", negating damage.")
					if f_p.damage > p.damage then
						p.set_dont_care (true)
						f_p.decr_damage(p.damage)
					elseif p.damage > f_p.damage then -- p will continue its route
						f_p.set_dont_care(true)
						p.decr_damage(f_p.damage)
					else
						p.set_dont_care (true)
						f_p.set_dont_care(true)
					end
					collided := true
				end
			end

			across -- COLLISION WITH ENEMY PROJ
				model.enemy_projectile_update.projectiles is e_p
			loop
				if p.x_pos = e_p.x_pos AND p.y_pos = e_p.y_pos AND not e_p.dont_care AND not (e_p.id = p.id) then
					output.append("      The projectile collides with enemy projectile(id:" + e_p.id.out + ") at location " + e_p.location_output + ", combining damage.")
					e_p.set_dont_care(true)
					p.incr_damage (e_p.damage)
					collided := true
				end -- p will continue its route
			end


			across
				model.enemy_update.enemies is e
			loop
				if p.x_pos = e.x_pos AND p.y_pos = e.y_pos AND not e.dont_care then
					output.append("      The projectile collides with " + e.type + "(id:" + e.id.out + ") at location " + e.location_output + ", healing " + p.damage.out + " damage.")
					p.set_dont_care (true)
					e.incr_health(p.damage)
					if e.health > e.total_hp then
						e.set_health(e.total_hp)
					end
					collided := true
				end
			end

			if p.x_pos = model.starfighter_update.starfighter.x_pos AND p.y_pos = model.starfighter_update.starfighter.y_pos then
				output.append("      The projectile collides with Starfighter(id:0) at location " + model.starfighter_update.starfighter.location_output + ", dealing " + max(p.damage - model.starfighter_update.starfighter.armour, 0).out + "damage.")
				p.set_dont_care (true)
				model.starfighter_update.starfighter.decr_health(max(p.damage - model.starfighter_update.starfighter.armour, 0))
				if model.starfighter_update.starfighter.health <= 0 then
					output.append ("%N      The Starfighter at location " + model.starfighter_update.starfighter.location_output + " has been destroyed.")
					model.starfighter_update.starfighter.set_health (0)
					model.starfighter_update.starfighter.set_symbol ('X')
					model.set_end_game (true)
				end
				collided := true
			end
			Result := output
		end

	check_sf_collision(s: STARFIGHTER): STRING
		local
			output: STRING
		do
			collided := false
			make_model
			create output.make_empty
			create Result.make_empty
			across -- COLLISION WITH FRIENDLY PROJ
				model.friendly_projectile_update.projectiles is p
			loop
				if s.x_pos = p.x_pos AND s.y_pos = p.y_pos AND not p.dont_care then
					output.append ("      The Starfighter collides with friendly projectile(id:" + p.id.out + ") at location " + p.location_output + ", taking " + max(p.damage - s.armour, 0).out + " damage.")
					p.set_dont_care(true)
					s.decr_health(max(p.damage - s.armour, 0))
					if s.health <= 0 then
						output.append ("%N      The Starfighter at location " + p.location_output + " has been destroyed.")
						model.starfighter_update.starfighter.set_health (0)
						model.starfighter_update.starfighter.set_symbol ('X')
						model.set_end_game (true)
					end
					collided := true
				end
			end

			across -- COLLISION WITH ENEMY PROJ
				model.enemy_projectile_update.projectiles is e_p
			loop
				if s.x_pos = e_p.x_pos AND s.y_pos = e_p.y_pos AND not e_p.dont_care then
					output.append ("      The Starfighter collides with enemy projectile(id:" + e_p.id.out + ") at location " + e_p.location_output + ", taking " + max(e_p.damage - s.armour, 0).out + " damage.")
					e_p.set_dont_care(true)
					s.decr_health(max(e_p.damage - s.armour, 0))
					if s.health <= 0 then
						output.append ("%N      The Starfighter at location " + e_p.location_output + " has been destroyed.")
						model.starfighter_update.starfighter.set_health (0)
						model.starfighter_update.starfighter.set_symbol ('X')
						model.set_end_game (true)
					end
					collided := true
				end
			end

			across
				model.enemy_update.enemies is e
			loop
				if s.x_pos = e.x_pos AND s.y_pos = e.y_pos AND not e.dont_care then
					output.append ("      The Starfighter collides with " + e.type + "(id:" + e.id.out + ") at location " + e.location_output + ", trading " + e.health.out + " damage.")
					e.set_dont_care(true)
					output.append ("%N      The " + e.type + " at location " + e.location_output + " has been destroyed.")
					model.scoring.incr_score(2)
					s.decr_health (e.health)
					if s.health <= 0 then
						output.append ("%N      The Starfighter at location " + e.location_output + " has been destroyed.")
						model.starfighter_update.starfighter.set_health (0)
						model.starfighter_update.starfighter.set_symbol ('X')
						model.set_end_game (true)
					end
					collided := true
				end

				Result := output
			end



		end

	check_friendly_proj_spawn_collision(p: PROJECTILE): STRING
		local
			output: STRING
		do
			collided := false
			create Result.make_empty
			make_model
			create output.make_empty
			across
				model.enemy_projectile_update.projectiles is e_p
			loop
				if p.x_pos = e_p.x_pos AND p.y_pos = e_p.y_pos AND not e_p.dont_care then -- COLLISION WITH ENEMY PROJ
					output.append("      The projectile collides with enemy projectile(id:" + e_p.id.out + ") at location " + p.location_output + ", negating damage.")
					if e_p.damage > p.damage then -- STILL ASSIGN PROJECTILE AN ID THOUGH
						p.set_dont_care (true)
						e_p.decr_damage(p.damage)
					elseif p.damage > e_p.damage then -- p will continue its route
						e_p.set_dont_care(true)
						p.decr_damage(e_p.damage)
					else
						p.set_dont_care (true)
						e_p.set_dont_care(true)
					end
					collided := true
				end
			end

			across -- COLLISION WITH FRIENDLY PROJ
				model.friendly_projectile_update.projectiles is f_p
			loop
				if p.x_pos = f_p.x_pos AND p.y_pos = f_p.y_pos AND not f_p.dont_care AND not (f_p.id = p.id) then
					output.append("      The projectile collides with friendly projectile(id:" + f_p.id.out + ") at location " + p.location_output + ", combining damage.")
					f_p.set_dont_care(true)
					p.incr_damage (f_p.damage)
					collided := true
				end -- p will continue its route
			end

			across
				model.enemy_update.enemies is e
			loop
				if p.x_pos = e.x_pos AND p.y_pos = e.y_pos AND not e.dont_care then -- STILL GIVE PROJ AN ID
					output.append("      The projectile collides with " + e.type + "(id:" + e.id.out + ") at location " + p.location_output + ", dealing " + max(p.damage - e.armour, 0).out + "damage.")
					p.set_dont_care (true)
					e.decr_health(max(p.damage - e.armour, 0))
					if e.health <= 0 then
						e.set_dont_care(true) -- DESTROY AND REMOVE FROM BOARD
						output.append ("%N      The " + e.type + " at location " + p.location_output + " has been destroyed.")
						model.scoring.incr_score(2)
					end
					collided := true
				end
			end
			Result.append (output)
		end


	check_enemy_spawn_collision(e: ENEMY)
		local
			output: STRING
		do
			collided := false
			make_model
			create output.make_empty
			across
				model.friendly_projectile_update.projectiles is f_p
			loop
				if e.x_pos = f_p.x_pos AND e.y_pos = f_p.y_pos AND not f_p.dont_care then
					output.append("The " + e.type + " collides with friendly projectile (id:" + f_p.id.out + ") at location " + f_p.location_output + ", taking " + max(f_p.damage - e.armour, 0).out + " damage.")
					f_p.set_dont_care (true)
					e.decr_health(max(f_p.damage - e.armour, 0))
					if e.health <= 0 then
						e.set_dont_care(true) -- DESTROY AND REMOVE FROM BOARD
						output.append ("%N      The " + e.type + " at location " + f_p.location_output + " has been destroyed.")
						model.scoring.incr_score(2)
					end
					collided := true
				end
			end

			across
				model.enemy_projectile_update.projectiles is e_p
			loop
				if e_p.x_pos = e.x_pos AND e_p.y_pos = e.y_pos AND not e_p.dont_care then
					output.append("The " + e.type + " collides with enemy projectile (id:" + e_p.id.out + ") at location " + e_p.location_output + ", healing " + e_p.damage.out + " damage.")
					e_p.set_dont_care (true)
					e.incr_health(e_p.damage)
					if e.health > e.total_hp then
						e.set_health(e.total_hp)
					end
					collided := true
				end
			end

			if e.x_pos = model.starfighter_update.starfighter.x_pos AND e.y_pos = model.starfighter_update.starfighter.y_pos then
				output.append("The " + e.type + " collides with Starfighter(id:0) at location " + e.location_output + ", trading " + e.health.out + "damage.")
				e.set_dont_care (true)
				model.scoring.incr_score(2)
				model.starfighter_update.starfighter.decr_health(e.health)
				if model.starfighter_update.starfighter.health <= 0 then
					output.append ("%N      The Starfighter at location " + model.starfighter_update.starfighter.location_output + " has been destroyed.")
					model.starfighter_update.starfighter.set_health (0)
					model.starfighter_update.starfighter.set_symbol ('X')
					model.set_end_game (true)
				end
				collided := true
			end
		end

	check_enemy_collision(e: ENEMY): STRING
		local
			output: STRING
		do
			collided := false
			make_model
			create output.make_empty
			create Result.make_empty

			across
				model.friendly_projectile_update.projectiles is f_p
			loop
				if e.x_pos = f_p.x_pos AND e.y_pos = f_p.y_pos AND not f_p.dont_care then
					output.append("      The " + e.type + " collides with friendly projectile(id:" + f_p.id.out + ") at location " + f_p.location_output + ", taking " + max(f_p.damage - e.armour, 0).out + " damage.")
					f_p.set_dont_care (true)
					e.decr_health(max(f_p.damage - e.armour, 0))
					if e.health <= 0 then
						e.set_dont_care(true) -- DESTROY AND REMOVE FROM BOARD
						output.append ("%N      The " + e.type + " at location " + f_p.location_output + " has been destroyed.")
						model.scoring.incr_score(2)
					end
					collided := true
				end
			end

			across
				model.enemy_projectile_update.projectiles is e_p
			loop
				if e_p.x_pos = e.x_pos AND e_p.y_pos = e.y_pos AND not e_p.dont_care then
					output.append("      The " + e.type + " collides with enemy projectile(id:" + e_p.id.out + ") at location " + e_p.location_output + ", healing " + e_p.damage.out + " damage.")
					e_p.set_dont_care (true)
					e.incr_health(e_p.damage)
					if e.health > e.total_hp then
						e.set_health(e.total_hp)
					end
					collided := true
				end
			end

			if e.x_pos = model.starfighter_update.starfighter.x_pos AND e.y_pos = model.starfighter_update.starfighter.y_pos then
				output.append("      The " + e.type + " collides with Starfighter(id:0) at location " +  model.starfighter_update.starfighter.location_output + ", trading " + e.health.out + "damage.")
				e.set_dont_care (true)
				model.starfighter_update.starfighter.decr_health(e.health)
				if e.health <= 0 then
					e.set_dont_care(true) -- DESTROY AND REMOVE FROM BOARD
					output.append ("%N      The " + e.type + " at location " + model.starfighter_update.starfighter.location_output + " has been destroyed.")
					model.scoring.incr_score(2)
				end
				if model.starfighter_update.starfighter.health <= 0 then
					output.append ("%N      The Starfighter at location " + model.starfighter_update.starfighter.location_output + " has been destroyed.")
					model.starfighter_update.starfighter.set_health (0)
					model.starfighter_update.starfighter.set_symbol ('X')
					model.set_end_game (true)

				end
				collided := true
			end
			Result.append(output)
		end

	set_collision_output(output: STRING)
		do
			make_model
			collision_output.make_empty
			collision_output.append(output)
		end

	check_enemy_in_front(e: ENEMY): BOOLEAN
		do
			make_model
			across
				model.enemy_update.enemies is e_e
			loop
				if e.x_pos = e_e.x_pos AND (e.y_pos - 1) = e_e.y_pos then
					Result := true
				else
					Result := false
				end
			end
		end
	check_enemy_above(e: ENEMY): BOOLEAN
		do
			make_model
			across
				model.enemy_update.enemies is e_e
			loop
				if (e.x_pos - 1) = e_e.x_pos AND e.y_pos = e_e.y_pos then
					Result := true
				else
					Result := false
				end
			end
		end

	check_enemy_below(e: ENEMY): BOOLEAN
		do
			make_model
			across
				model.enemy_update.enemies is e_e
			loop
				if (e.x_pos + 1) = e_e.x_pos AND e.y_pos = e_e.y_pos then
					Result := true
				else
					Result := false
				end
			end
		end







feature -- Queries
	max(i: INTEGER; j: INTEGER): INTEGER
		do
			if i > j then
				Result := i
			else
				Result := j
			end
		end
end
