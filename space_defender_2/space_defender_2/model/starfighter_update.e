note
	description: "Summary description for {STARFIGHTER_UPDATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER_UPDATE
create
	make

feature
	make
		do
			create starfighter.make (0, 0, 5, 5, 5, 5,5, 0, 0, 0)
			create move_output.make_empty
			create pass_output.make_empty
			create fire_output.make_empty
			create starfighter_action_output.make_empty
			create special_output.make_empty
			make_model
		end
feature
	model: GAME
	hp: INTEGER
	nrg: INTEGER
	regn_h: INTEGER
	regn_e: INTEGER
	armr: INTEGER
	vsn: INTEGER
	mv: INTEGER
	mv_cost: INTEGER
	starfighter: STARFIGHTER
	move_output: STRING
	pass_output: STRING
	fire_output: STRING
	special_output: STRING
	starfighter_action_output: STRING
--	total_hp: INTEGER
--	total_nrg: INTEGER
feature
	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end

	make_starfighter(rows: INTEGER)
		do
			make_model
			hp := model.state_changer.table.states[2].health + model.state_changer.table.states[3].health + model.state_changer.table.states[4].health
			nrg := model.state_changer.table.states[2].energy + model.state_changer.table.states[3].energy + model.state_changer.table.states[4].energy
			regn_h := model.state_changer.table.states[2].regen_h + model.state_changer.table.states[3].regen_h + model.state_changer.table.states[4].regen_h
			regn_e := model.state_changer.table.states[2].regen_e + model.state_changer.table.states[3].regen_e + model.state_changer.table.states[4].regen_e
			armr := model.state_changer.table.states[2].armour + model.state_changer.table.states[3].armour + model.state_changer.table.states[4].armour
			vsn := model.state_changer.table.states[2].vision + model.state_changer.table.states[3].vision + model.state_changer.table.states[4].vision
			mv := model.state_changer.table.states[2].move + model.state_changer.table.states[3].move + model.state_changer.table.states[4].move
			mv_cost := model.state_changer.table.states[2].move_cost + model.state_changer.table.states[3].move_cost + model.state_changer.table.states[4].move_cost

--			total_hp := hp
--			total_nrg := nrg
			starfighter.make ((rows/2).ceiling, 1, hp, nrg, regn_h, regn_e, armr, vsn, mv, mv_cost)
			model.game_board.update_fow
		end

	move_starfighter(row: INTEGER; column: INTEGER)
		local
			old_x: INTEGER
			old_y: INTEGER
			collision_output: STRING
			collision: BOOLEAN
		do
			starfighter.apply_regen
			make_model
			move_output.make_empty
			create collision_output.make_empty
			old_x := starfighter.x_pos
			old_y := starfighter.y_pos

			across
				1 |..| (row - starfighter.x_pos).abs is l_i
			loop
				if not (starfighter.symbol ~ 'X') then
					if row < starfighter.x_pos then
						starfighter.decr_x (1)
					elseif row > starfighter.x_pos then
						starfighter.incr_x (1)
					else
						-- do nothing
					end
					collision_output.append (model.check_collision.check_sf_collision (starfighter))
					if model.check_collision.collided then
						collision_output.append ("%N")
						collision := true
					end
				end
			end

			across
				1 |..| (column - starfighter.y_pos).abs is l_j
			loop
				if not (starfighter.symbol ~ 'X') then
					if column < starfighter.y_pos then
						starfighter.decr_y (1)
					elseif column > starfighter.y_pos then
						starfighter.incr_y (1)
					else
						-- do nothing
					end
					--CHECK A COLLISION
					collision_output.append (model.check_collision.check_sf_collision (starfighter))
					if model.check_collision.collided then
						collision_output.append ("%N")
						collision := true
					end
				end
			end
			-- Move finished
			move_output.append("    The Starfighter(id:0) moves: [")
			move_output.append(starfighter.convert_to_letter (old_x) + "," + old_y.out)
			move_output.append("] -> [" + starfighter.convert_to_letter (starfighter.x_pos) + "," + starfighter.y_pos.out + "]%N")
			if collision then
				move_output.append (collision_output)
			end
			set_starfighter_action(move_output)
			model.game_board.move_starfighter_board (old_x, old_y)

			starfighter.decr_energy (starfighter.get_distance (old_x, old_y) * starfighter.move_cost)
		end

	pass
		do
			pass_output.make_empty
			starfighter.apply_regen
			starfighter.apply_regen
			pass_output.append("    The Starfighter(id:0) passes at location [")
			pass_output.append(starfighter.convert_to_letter (starfighter.x_pos) + "," + starfighter.y_pos.out + "], ")
			pass_output.append("doubling regen rate.%N")
			set_starfighter_action(pass_output)
			-- MORE TO ADD LATER
		end
	special
		local
			old_x: INTEGER
			old_y: INTEGER
			collision_output: STRING
			i: INTEGER

		do
			make_model
			starfighter.apply_regen
			special_output.make_empty
			create collision_output.make_empty
			if model.state_changer.table.states[5].get_power_choice ~ "rec" then
				old_x := starfighter.x_pos
				old_y := starfighter.y_pos
				starfighter.decr_energy (50)
				starfighter.set_coords((model.game_board.num_rows /2).ceiling, 1)
				collision_output.append(model.check_collision.check_sf_collision (starfighter))
				model.game_board.move_starfighter_board (old_x, old_y)
				special_output.append("    The Starfighter(id:0) uses special, teleporting to: [" + starfighter.convert_to_letter (starfighter.x_pos) + ",1]%N")
				if model.check_collision.collided then
					special_output.append (collision_output + "%N")
				end

			elseif model.state_changer.table.states[5].get_power_choice ~ "rep" then
				starfighter.decr_energy (50)
				starfighter.incr_health (50)
				if starfighter.health > starfighter.total_hp then
					starfighter.set_health(starfighter.total_hp)
				end
				special_output.append("    The Starfighter(id:0) uses special, gaining 50 health.%N")

			elseif model.state_changer.table.states[5].get_power_choice ~ "ove" then
				if starfighter.health > 1 then
					from
						i := 0
					until
						starfighter.health = 1 OR i = 50
					loop
						starfighter.decr_health (1)
						i := i + 1
					end
					starfighter.incr_energy (i*2)
					special_output.append ("    The Starfighter(id:0) uses special, gaining " + (i*2).out + " energy at the expense of " + i.out + " health.%N")
				end
			elseif model.state_changer.table.states[5].get_power_choice ~ "dep" then
				special_output.append ("    The Starfighter(id:0) uses special, clearing projectiles with drones.%N")
				across
					model.projectile_access.all_projectiles is p
				loop
					special_output.append ("      A projectile(id:" + p.id.out + ") at location " + p.location_output + " has been neutralized.%N")
					p.set_dont_care(true)
				end
				starfighter.decr_energy(100)
			elseif model.state_changer.table.states[5].get_power_choice ~ "orb" then
				special_output.append ("    The Starfighter(id:0) uses special, unleashing a wave of energy.%N")
				across
					model.enemy_update.enemies is e
				loop
					special_output.append ("      A " + e.type + "(id:" + e.id.out + ") at location " + e.location_output + " takes " + (100 - e.armour).out + " damage.%N")
					e.decr_health(100 - e.armour)
					if e.health <= 0 then
						special_output.append("      The " + e.type + " at location " + e.location_output + " has been destroyed.%N")
					end
				end
				starfighter.decr_energy(100)
			end
			set_starfighter_action(special_output)
		end


	set_fire_action(proj_list: LINKED_LIST[PROJECTILE])
		local
			collision_output: STRING
		do
			make_model
			create collision_output.make_empty
			fire_output.make_empty
			fire_output.append("    The Starfighter(id:0) fires at location [")
			fire_output.append(starfighter.convert_to_letter (starfighter.x_pos) + "," + starfighter.y_pos.out + "].%N")
			across
				proj_list is p
			loop
				fire_output.append("      A friendly projectile(id:" + p.id.out + ") spawns at location ")
				fire_output.append(p.location_output + ".%N")
				collision_output.append (model.check_collision.check_friendly_proj_spawn_collision (p))
				if model.check_collision.collided then
					fire_output.append (collision_output)
					fire_output.append ("%N")
				end
			end
		set_starfighter_action(fire_output)
		end

feature
	get_output: STRING
		do
			make_model
			create Result.make_from_string ("")
			Result.append ("Starfighter:%N    ")
			Result.append ("[0,S]->health:" + starfighter.health.out + "/" + starfighter.total_hp.out + ", ")
			Result.append ("energy:" + starfighter.energy.out + "/" + starfighter.total_nrg.out + ", ")
			Result.append ("Regen:" + starfighter.regen_h.out + "/" + starfighter.regen_e.out + ", ")
			Result.append ("Armour:" + starfighter.armour.out + ", ")
			Result.append ("Vision:" + starfighter.vision.out + ", ")
			Result.append ("Move:" + starfighter.move.out + ", ")
			Result.append ("Move Cost:" + starfighter.move_cost.out + ", ")
			Result.append ("location:[" + starfighter.convert_to_letter(starfighter.x_pos) + "," + starfighter.y_pos.out + "]%N      ")
			Result.append ("Projectile Pattern:" + model.state_changer.table.states[2].get_type + ", ")
			Result.append ("Projectile Damage:" + model.state_changer.table.states[2].proj_damage.out + ", ")
			if model.state_changer.table.states[2].get_type ~ "Rocket" then
				Result.append ("Projectile Cost:" + model.state_changer.table.states[2].proj_cost.out + " (health)%N      ")
			else
				Result.append ("Projectile Cost:" + model.state_changer.table.states[2].proj_cost.out + " (energy)%N      ")
			end
			Result.append ("Power:" + model.state_changer.table.states[5].get_type + "%N      ")
			Result.append ("score:" + model.scoring.score.out + "%N  ")
		end

	set_starfighter_action(output: STRING)
		do
			make_model
			create starfighter_action_output.make_from_string("")
			starfighter_action_output.append (output)

		end

--	get_debug_output: STRING
--		do
--			make_model
--			create Result.make_from_string("")
--			Result.append ("Enemy:") -- TO GET FROM ENEMY CLASS
--			Result.append ("Projectile:") -- TO GET FROM PROJECTILE CLASS
--			Result.append ("Friendly Projectile Action:")
--			Result.append ("Enemy Projectile Action:")
--			Result.append ("Starfighter Action:")
--			Result.append ("Enemy Action:")
--			Result.append ("Natural Enemy Spawn:")
--		end
end
