note
	description: "Summary description for {ENEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMY

inherit
	LIFEFORM
feature -- Attributes
	seen_by_sf: BOOLEAN
	can_see_sf: BOOLEAN
	total_hp: INTEGER
	id: INTEGER
	type: STRING
	upwards_move: BOOLEAN
	end_turn: BOOLEAN

feature -- Commands
	preemptive_action(s: STARFIGHTER): STRING deferred end

	enemy_action deferred end

	sf_seen(s: STARFIGHTER)
		do
			if get_distance(s.x_pos, s.y_pos) > vision then
				can_see_sf := false
			else
				can_see_sf := true
			end


			if get_distance(s.x_pos, s.y_pos) > s.vision then
				seen_by_sf := false
			else
				seen_by_sf := true
			end
		end

	apply_regen
		do
			if health < total_hp then
				incr_health(regen_h)
				if health > total_hp then
					set_health(total_hp)
				end
			end
		end

	incr_armour(amount: INTEGER)
		do
			armour := armour + amount
		end

	incr_regen(amount: INTEGER)
		do
			regen_h := regen_h + amount
		end


	incr_total_hp(amount: INTEGER)
		do
			total_hp := total_hp + amount
		end


end
