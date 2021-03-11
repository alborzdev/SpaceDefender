note
	description: "Summary description for {FIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIGHTER
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
			symbol := 'F'
			type := "Fighter"
			create location_output.make_empty
		end

feature -- Attributes



feature -- Commands
	preemptive_action(s: STARFIGHTER): STRING -- Take in current starfighter as an argument
		do
			create Result.make_empty
--			if s.current_action ~ "fire" AND not dont_care then
--				incr_armour(1)
--			elseif s.current_action ~ "pass" AND not dont_care then
--				model.enemy_update.move_enemy(6, Current)
--				if not dont_care AND not collision then
--					model.enemy_projectile_update.spawn_projectile(Current, 10, 100)
--				end
--			end
			--END THE TURN
		end

	enemy_action
		do
--			if not can_see_sf then
--				across 1 |..| 3 is i loop
--					decr_y(1)
--					-- Check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					fire_proj -- fire fighter type projectile (3 spaces per tuen, damage of 20)
--				end
--			else
--				across 1 |..| 1 is i loop
--					decr_y(1)
--					-- check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					fire_proj -- fire fighter type projectile (6 spaces per tuen, damage of 50)
--				end
--			end
		end


end
