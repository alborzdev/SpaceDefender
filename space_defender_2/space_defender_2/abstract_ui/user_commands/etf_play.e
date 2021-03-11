note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		require else
			play_precond(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
    	do
			-- perform some update on the model state
			if model.state_changer.index > 1 AND model.state_changer.index < 7 then
				model.error.enable_error ("Already in setup mode.")
			elseif model.state_changer.index = 7 then
				model.error.enable_error ("Already in a game. Please abort to start a new one.")
			elseif not (g_threshold <= f_threshold AND f_threshold <= c_threshold AND c_threshold <= i_threshold AND i_threshold <= p_threshold) then
				model.error.enable_error ("Threshold values are not non-decreasing.")
			else
				model.play(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
