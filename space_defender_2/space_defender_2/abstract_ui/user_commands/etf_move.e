note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
		local
			num_row: INTEGER
    	do
    		if row = A then
					num_row := 1
				elseif row = B then
					num_row := 2
				elseif row = C then
					num_row := 3
				elseif row = D then
					num_row := 4
				elseif row = E then
					num_row := 5
				elseif row = F then
					num_row := 6
				elseif row = G then
					num_row := 7
				elseif row = H then
					num_row := 8
				elseif row = I then
					num_row := 9
				elseif row = J then
					num_row := 10
				end
			-- perform some update on the model state
			if not(model.state_changer.index = 7) then
				model.error.enable_error ("Command can only be used in game.")

			elseif num_row > model.game_board.num_rows OR column > model.game_board.num_cols then
				model.error.enable_error ("Cannot move outside of board.")

			elseif num_row = model.starfighter_update.starfighter.x_pos AND column = model.starfighter_update.starfighter.y_pos then
				model.error.enable_error ("Already there.")

			elseif model.starfighter_update.starfighter.get_distance (num_row, column) > model.starfighter_update.starfighter.move then
				model.error.enable_error ("Out of movement range.")

			elseif (model.starfighter_update.starfighter.get_distance (num_row, column) * model.starfighter_update.starfighter.move_cost) > model.starfighter_update.starfighter.energy + model.starfighter_update.starfighter.regen_e then
				model.error.enable_error ("Not enough resources to move.")

			else
				model.move(num_row, column)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
