note
	description: "Summary description for {PYLON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYLON
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
			symbol := 'P'
			type := "Pylon"
			create location_output.make_empty
		end

feature -- Attributes


feature -- Commands
	preemptive_action(s: STARFIGHTER): STRING -- Take in current starfighter as an argument
		do
			create Result.make_empty
			-- NOTHING
		end

	enemy_action
		do
--			if not can_see_sf then
--				across 1 |..| 2 is i loop
--					decr_y(1)
--					-- Check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					across
--						enemies is e
--					loop
--						if get_distance(e.x_pos, e.y_pos) <= vision then
--							e.incr_health(10)
--						end
--					end -- end loop
--					incr_health(10)
--				end
--			else
--				across 1 |..| 1 is i loop
--					decr_y(1)
--					-- check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					fire_proj -- fire fighter type projectile (2 spaces per tuen, damage of 70)
--				end
--			end
		end


end
