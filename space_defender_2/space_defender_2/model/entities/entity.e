note
	description: "Summary description for {ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

feature -- Attributes
	health: INTEGER
	x_pos: INTEGER
	y_pos: INTEGER
	dont_care: BOOLEAN
	collision: BOOLEAN
	location_output: STRING
feature
	incr_x(amount: INTEGER)
		do
			x_pos := x_pos + amount
		end
	decr_x(amount: INTEGER)
		do
			x_pos := x_pos - amount
		end

	set_coords(x: INTEGER; y: INTEGER)
		require
			--must be in board coords
		do
			x_pos := x
			y_pos := y
		end
	incr_y(amount: INTEGER)
		do
			y_pos := y_pos + amount
		end

	decr_y(amount: INTEGER)
		do
			y_pos := y_pos - amount
		end

	set_location(loc: STRING)
		do
			location_output := loc
		end

	set_dont_care(bool: BOOLEAN)
		do
			dont_care := bool
		end

feature -- Queries
	convert_to_letter(i: INTEGER): STRING
		do
			if i = 1 then
				Result := "A"
			elseif i = 2 then
				Result := "B"
			elseif i = 3 then
				Result := "C"
			elseif i = 4 then
				Result := "D"
			elseif i = 5 then
				Result := "E"
			elseif i = 6 then
				Result := "F"
			elseif i = 7 then
				Result := "G"
			elseif i = 8 then
				Result := "H"
			elseif i = 9 then
				Result := "I"
			else
				Result := "J"
			end
		end

	bool_to_string(b: BOOLEAN): STRING
		do
			if b then
				Result := "T"
			else
				Result := "F"
			end
		end

	out_of_bounds(rows:INTEGER; cols: INTEGER): BOOLEAN
		do
			if Current.x_pos < 1 OR Current.x_pos > rows OR Current.y_pos < 1 OR Current.y_pos > cols then
				Result := true
			else
				Result := false
			end
		end

end
