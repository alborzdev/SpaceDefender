note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_NEXT
inherit
	ETF_SETUP_NEXT_INTERFACE
create
	make
feature -- command
	setup_next(state: INTEGER_32)
		require else
			setup_next_precond(state)
    	do
			-- perform some update on the model state
			if model.state_changer.index < 2 OR model.state_changer.index > 6  then
				model.error.enable_error ("Command can only be used in setup mode.")
			else
				model.setup_next(state)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
