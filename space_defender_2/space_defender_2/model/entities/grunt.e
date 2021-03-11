note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT
inherit
	ENEMY

create
	make

feature
	make(x: INTEGER; y: INTEGER; hp: INTEGER; regn_h: INTEGER; armr: INTEGER; vsn: INTEGER; identity: INTEGER)
		do
			x_pos := x
			y_pos := y
			health := hp
			regen_h := regn_h
			armour := armr
			vision := vsn
			total_hp := hp
			id := identity
			symbol := 'G'
			type := "Grunt"
			create location_output.make_empty
			make_model
		end

feature
	make_model
		local
			ga: GAME_ACCESS
		do
			model := ga.m
		end

feature -- Attributes
	model: GAME

feature -- Commands
	preemptive_action(s: STARFIGHTER): STRING -- Take in current starfighter as an argument
		do
			create Result.make_empty
			if s.current_action ~ "pass" AND not dont_care then
				incr_health(10)
				incr_total_hp(10)
				Result.append ("    A " + Current.type + "(id:" + Current.id.out + ") gains 10 total health.%N")
			elseif s.current_action ~ "special" AND not dont_care then
				incr_health(20)
				incr_total_hp(20)
				Result.append("    A " + Current.type + "(id:" + Current.id.out + ") gains 20 total health.%N")
			end
		end

	enemy_action
		do
			make_model
			apply_regen
			if not can_see_sf then
				model.enemy_update.move_enemy(2, Current)
					-- Check collision (maybe not here tho)
				if not collision AND not dont_care then
					model.enemy_projectile_update.spawn_projectile(Current, 4, 15) -- fire grunt type projectile with special properties
				end
			else
				model.enemy_update.move_enemy(4, Current)
					-- Check collision
				if not collision AND not dont_care then
					model.enemy_projectile_update.spawn_projectile(Current, 4, 15) -- fire grunt type proj with special properties
				end
			end
		end


end
