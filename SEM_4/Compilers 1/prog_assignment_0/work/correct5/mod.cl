--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

-- implementing modulus functionility for integers
-- only positive integers addressed here, rest is convention dependent
class Main {
	io : IO <- new IO;
	ans : Int;
	mod(x:Int,y:Int):Int{{
		while y<=x loop
			x <- x - y
		pool;
		x;
		}
	};
	main():Int {{
		ans <- 	
		(let x:Int, y:Int in 
		{io.out_string("enter first number\n");
		x<- io.in_int();	
		io.out_string("enter second number\n");
		y<- io.in_int();
		mod(x,y);
		});
		io.out_string("the ans is : ");
		io.out_int(ans);
		io.out_string("\n");
		0;
		}
	};
};
