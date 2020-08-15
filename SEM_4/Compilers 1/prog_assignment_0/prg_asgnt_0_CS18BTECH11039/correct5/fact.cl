--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

class Main {
	io : IO <- new IO;
	fact (n:Int) : Int{
		let ans : Int <- 1 in {
			while 0 < n   loop {
				ans <- ans*n;
				n <- n-1;
			}
			pool;
			ans;
		}	
	};
	main() : Int {
		{
			io.out_string("enter the number of which the factorial is to be computed");
			let x : Int <- io.in_int() in {
			io.out_string("The answer is: ");
			io.out_int(fact(x));
			io.out_string("\n");
			0;
			};	
		}
	};
};
