note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER
inherit
	LIFEFORM
create
	make

feature
	make(x: INTEGER; y: INTEGER; hp: INTEGER; nrg: INTEGER; regn_h: INTEGER; regn_e: INTEGER; armr: INTEGER; vsn: INTEGER; mv: INTEGER; mv_cost: INTEGER)
		do
			x_pos := x
			y_pos := y
			health := hp
			energy := nrg
			regen_h := regn_h
			regen_e := regn_e
			armour := armr
			vision := vsn
			move := mv
			move_cost := mv_cost
			total_hp := hp
			total_nrg := nrg
			symbol := 'S'
			create current_action.make_empty
			create location_output.make_empty
		end

feature
	energy: INTEGER
	regen_e: INTEGER
	move: INTEGER
	move_cost: INTEGER
	total_nrg: INTEGER
	current_action: STRING
	total_hp: INTEGER

feature
	incr_energy(amount: INTEGER)
		do
			energy := energy + amount
		end
	decr_energy(amount: INTEGER)
		do
			energy := energy - amount
		end

	set_energy(amount: INTEGER)
		do
			energy := amount
		end

	apply_regen
		do
			if health < total_hp then
				incr_health(regen_h)
				if health > total_hp then
					set_health(total_hp)
				end
			end

			if energy < total_nrg then
				incr_energy(regen_e)
				if energy > total_nrg then
					set_energy(total_nrg)
				end
			end
		end

	set_current_action(s: STRING)
		do
			current_action := s
		end

	set_symbol(c: CHARACTER)
		do
			symbol := c
		end


end
