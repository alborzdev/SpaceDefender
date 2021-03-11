note
	description: "Summary description for {LIFEFORM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	LIFEFORM
INHERIT
	ENTITY

feature -- Attributes
	regen_h: INTEGER
	armour: INTEGER
	vision: INTEGER
	symbol: CHARACTER

feature -- Commands
	apply_regen deferred end

	incr_health(amount: INTEGER) -- Increases health by `amount`
		do
			health := health + amount
		end

	decr_health(amount: INTEGER) -- Decreases health by `amount`
		do
			health := health - amount
		end

	set_health(amount: INTEGER)
		do
			health := amount
		end


feature -- Queries
	get_distance(x: INTEGER; y: INTEGER): INTEGER
		do
			Result := (x - x_pos).abs + (y - y_pos).abs
		end

end
