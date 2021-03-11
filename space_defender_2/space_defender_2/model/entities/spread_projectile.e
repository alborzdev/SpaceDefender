note
	description: "Summary description for {SPREAD_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPREAD_PROJECTILE
inherit
	PROJECTILE
create
	make

feature -- make
	make(x: INTEGER; y: INTEGER; cst: INTEGER; mv: INTEGER; dmg: INTEGER; identity: INTEGER; tp: STRING)
		do
			x_pos := x
			y_pos := y
			cost := cst
			move := mv
			damage := dmg
			id := identity
			type := tp
			create location_output.make_empty
			tag := '*'
		
		end

feature
	increment
		do
			if type ~ "top" then
				x_pos := x_pos - 1
				y_pos := y_pos + 1
			elseif type ~ "mid" then
				y_pos := y_pos + 1
			elseif type ~ "bottom" then
				x_pos := x_pos + 1
				y_pos := y_pos + 1
			end
		end
end
