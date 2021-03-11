note
	description: "Summary description for {ENEMY_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE
inherit
	PROJECTILE
create
	make
feature
	make(x: INTEGER; y: INTEGER; mv: INTEGER; dmg: INTEGER; identity: INTEGER)
		do
			x_pos := x
			y_pos := y
			move := mv
			damage := dmg
			id := identity
			create location_output.make_empty
			tag := '<'
			type := "Enemy"
		end

feature
	increment
		do
			y_pos := y_pos - 1
		end

end
