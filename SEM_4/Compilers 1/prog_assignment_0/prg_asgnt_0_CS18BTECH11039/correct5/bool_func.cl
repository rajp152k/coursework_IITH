--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

class BoolFunc { --implementing basic boolean functionality
	logicalAnd (b1 : Bool, b2 : Bool) : Bool{
		if b1 = true then 
			if b2 = true then true else false fi
			else false
		fi
		};
	logicalOR (b1 : Bool, b2 : Bool) : Bool{
		if b1 = false then 
			if b2 = true then true else false fi
			else true
		fi
		};
};

class Main{
	main() : String {
		-- does nothing, just here to avoid individual compiling errors(missing main)
		-- returning a string in this case to check storage format in the mips simulator : see report for more info
	 	"12345"	
		};
};
	
