note
	description: "Summary description for {SPLITTER_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPLITTER_PROJECTILE
inherit
	PROJECTILE
create
	make

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
			type := "Splitter"
		end

feature
	increment
		do
			y_pos := y_pos + 0
		end
end
