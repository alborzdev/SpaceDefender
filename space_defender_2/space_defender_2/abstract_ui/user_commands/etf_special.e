note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SPECIAL
inherit
	ETF_SPECIAL_INTERFACE
create
	make
feature -- command
	special
    	do
			-- perform some update on the model state
			if not(model.state_changer.index = 7) then
				model.error.enable_error ("Command can only be used in game.")
			elseif model.state_changer.table.states[5].power_cost > model.starfighter_update.starfighter.energy + model.starfighter_update.starfighter.regen_e AND not (model.state_changer.table.states[5].power_choice ~ "ove") then
				model.error.enable_error ("Not enough resources to use special.")
			else
				model.special
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
