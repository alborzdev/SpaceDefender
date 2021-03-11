note
	description: "Summary description for {PROJECTILES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTILES
create
	make

feature
	make
		do
			create all_projectiles.make
			create all_output.make_empty
			create projectile_action.make_empty
		end

feature
	all_projectiles: LINKED_LIST[PROJECTILE]
	all_output: STRING
	projectile_action: STRING

feature
	add_projectile(p: PROJECTILE)
		do
			all_projectiles.extend (p)
		end

	make_output
		do
			all_output.make_empty
			across
				all_projectiles is p
			loop
				if not p.dont_care then
					if p.type ~ "Sniper" then
						all_output.append ("    [" + p.id.out + "," + p.tag.out + "]->damage:" + p.damage.out)
						all_output.append (", move:8, location:" + p.location_output + "%N")
						set_projectiles_action(all_output)
					else
						all_output.append ("    [" + p.id.out + "," + p.tag.out + "]->damage:" + p.damage.out)
						all_output.append (", move:" + p.move.out + ", location:" + p.location_output + "%N")
						set_projectiles_action(all_output)
					end
				end
			end
		end

feature
	set_projectiles_action(output: STRING)
		do

		end
end
