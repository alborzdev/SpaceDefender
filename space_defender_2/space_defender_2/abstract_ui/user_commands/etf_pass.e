note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PASS
inherit
	ETF_PASS_INTERFACE
create
	make
feature -- command
	pass
    	do
			-- perform some update on the model state
			if not(model.state_changer.index = 7) then
				model.error.enable_error ("Command can only be used in game.")
			else
				model.pass
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
