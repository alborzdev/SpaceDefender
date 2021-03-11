note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GAME_ACCESS

feature
	m: GAME
		once
			create Result.make
		end

invariant
	m = m
end




