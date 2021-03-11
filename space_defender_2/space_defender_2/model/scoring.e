note
	description: "Summary description for {SCORING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCORING
create
	make

feature
	make
		do
			score := 0
		end

feature -- attributes
	score: INTEGER

feature 
	incr_score(amount: INTEGER)
		do
			score := score + amount
		end
end
