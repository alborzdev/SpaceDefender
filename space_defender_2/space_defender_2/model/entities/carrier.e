note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER
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
			symbol := 'C'
			type := "Carrier"
			create location_output.make_empty
		end

feature -- Attributes


feature -- Commands
	preemptive_action(s: STARFIGHTER): STRING -- Take in current starfighter as an argument
		do
			create Result.make_empty
--			if s.get_current_action ~ "special" then
--				incr_regen(10)
--			elseif s.get_current_action ~ "pass" then
--				across 1 |..| 2 is i loop
--					decr_y(1)
--					-- Check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					spawn_enemy(interceptor) -- ONLY SPAWN IF NO ONE IS TAKING ITS SPOT, above carrier
--					spawn_enemy(interceptor) -- ONLY SPAWN IF NO ONE IS TAKING ITS SPOT, below carrier
--				end
--			end
--			--END THE TURN
		end

	enemy_action
		do
--			if not can_see_sf then
--				across 1 |..| 2 is i loop
--					decr_y(1)
--					-- Check collision
--				end -- end movement
--			else
--				across 1 |..| 1 is i loop
--					decr_y(1)
--					-- check collision
--				end -- end movement
--				if not collision AND not dont_care then
--					spawn_enemy(interceptor) -- directly to left of carrer
--				end
--			end
		end


end



