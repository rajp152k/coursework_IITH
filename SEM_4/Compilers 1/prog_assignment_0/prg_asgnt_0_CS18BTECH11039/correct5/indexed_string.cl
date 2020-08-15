--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

class Main{
	io : IO <- new IO;
	index : Int;
	str : String;
	extract_char(i : Int,s : String) : String {
		s.substr(i,1)
	};
	main() : Int {
		{
			io.out_string("enter the string to be examined\n");
			str <- io.in_string();	
			io.out_string("enter which character of the string you want to extract \n");
			index <- io.in_int();
			io.out_string("the corresponding character is : ");
			io.out_string(extract_char(index,str).concat("\n"));
			0;
		}	
	};
};
		
