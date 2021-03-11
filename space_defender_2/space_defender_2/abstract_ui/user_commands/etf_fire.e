note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state
			if not(model.state_changer.index = 7) then
				model.error.enable_error ("Command can only be used in game.")
			elseif model.state_changer.table.states[2].proj_cost > model.starfighter_update.starfighter.energy + model.starfighter_update.starfighter.regen_e then
				model.error.enable_error ("Not enough resources to fire.")
			else
				model.fire
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
