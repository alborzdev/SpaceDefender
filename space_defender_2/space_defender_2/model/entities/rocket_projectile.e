note
	description: "Summary description for {ROCKET_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROCKET_PROJECTILE
inherit
	PROJECTILE
create
	make

feature

feature -- make
	make(x: INTEGER; y: INTEGER; cst: INTEGER; mv: INTEGER; dmg: INTEGER; identity: INTEGER)
		do
			x_pos := x
			y_pos := y
			cost := cst
			move := mv
			damage := dmg
			id := identity
			create location_output.make_empty
			tag := '*'
			type := "Rocket"
		end

feature
	increment
		do
			y_pos := y_pos + 1

		end

end
