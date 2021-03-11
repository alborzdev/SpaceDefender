note
	description: "Summary description for {PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROJECTILE
inherit
	ENTITY

feature -- Attributes

	cost: INTEGER
	damage: INTEGER
	id: INTEGER
	move: INTEGER
	tag: CHARACTER
	type: STRING
feature
	set_cost(amount: INTEGER)
		do
			cost := amount
		end

	set_damage(amount: INTEGER)
		do
			damage := amount
		end

	set_move(amount: INTEGER)
		do
			move := amount
		end

	set_id(amount: INTEGER)
		do
			id := amount
		end

	decr_damage(amount: INTEGER)
		do
			damage := damage - amount
		end
	incr_damage(amount: INTEGER)
		do
			damage := damage + amount
		end

	multiply_move
		do
			move := move*2
		end


	increment deferred end

end
