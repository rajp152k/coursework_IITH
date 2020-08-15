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
-- explicitly including bool_func.cl to allow for easier checking 
-- checking if the given string is a palindrome
class Main inherits IO {
	bf : BoolFunc <- new BoolFunc;
	flag :Bool <- true;
	str : String;
	echr(i : Int,s : String) : String {--extract the character at that index
		s.substr(i,1)
	};
	main() : Int {
		{
			out_string("enter the string to be examined\n");
			str <- in_string();	
			let i:Int <- 0, s:Int <- str.length() in 
				(while bf.logicalAnd(flag,i<s/2) 
				loop
				{
				if not (echr(i,str) = echr(s-i-1,str)) then 
					flag <- false
				else i<- i+1
				fi;
				}
				pool);
			if flag
			then 
				out_string("it's a palindrome\n")
			else 
				out_string("it's not a palindrome\n")
			fi;
			0;
		}	
	};
};
