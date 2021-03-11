note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_SELECT
inherit
	ETF_SETUP_SELECT_INTERFACE
create
	make
feature -- command
	setup_select(value: INTEGER_32)
		require else
			setup_select_precond(value)
    	do
			-- perform some update on the model state
			if model.state_changer.index = 1 OR model.state_changer.index = 7 OR model.state_changer.index = 6 then
				model.error.enable_error ("Command can only be used in setup mode (excluding summary in setup).")
			elseif model.state_changer.index = 2 AND (value < 1 OR value > 5) then
				model.error.enable_error ("Menu option selected out of range.")
			elseif model.state_changer.index = 3 AND (value < 1 OR value > 4) then
				model.error.enable_error ("Menu option selected out of range.")
			elseif model.state_changer.index = 4 AND (value < 1 OR value > 3) then
				model.error.enable_error ("Menu option selected out of range.")
			elseif model.state_changer.index = 5 AND (value < 1 OR value > 5) then
				model.error.enable_error ("Menu option selected out of range.")
			else
				model.setup_select(value)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
