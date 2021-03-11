note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR
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
			symbol := 'I'
			type := "Interceptor"
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
			upwards_move := false
			create Result.make_empty
			if s.current_action ~ "fire" AND not dont_care then
				-- ATTEMPT MOVE INTERCEPTOR OF CURRENT STARFIGHTER
				if not (y_pos = s.y_pos) then -- interceptor and starfighter are in different coloumn
					if s.x_pos > x_pos then -- if starfighter is below Current
						upwards_move := false
					elseif s.x_pos < x_pos then -- if starfighter is above current
						upwards_move := true
					end

					Result := model.enemy_update.move_interceptor ((s.x_pos - x_pos).abs, Current)

				elseif y_pos = s.y_pos then
					 -- interceptor and starfighter are in same coloumns

					if s.x_pos > x_pos then -- if starfighter is below Current and there is no enemy occupying the next space to move to
						upwards_move := false
					elseif s.x_pos < x_pos then -- if starfighter is above current there is no enemy occupying the next space to move to
						upwards_move := true
					end
					-- Check collision, could be projectile, will NOT be an enemy collision, could also be a starfighter collision
					Result := model.enemy_update.move_interceptor ((s.x_pos - x_pos).abs, Current)
				end
				end_turn := true
			end
		end

	enemy_action
		do
			make_model
			apply_regen
			if not can_see_sf then
				model.enemy_update.move_enemy(3, Current)
					-- Check collision (maybe not here tho)
			else
				model.enemy_update.move_enemy(3, Current)
					-- Check collision
			end
		end


end


