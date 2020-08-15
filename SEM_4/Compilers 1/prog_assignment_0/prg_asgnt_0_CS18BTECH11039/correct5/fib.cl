--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

class Main {
	io :IO <- new IO;
	--works upto i = 20, not enough heap space in the mips simulator after that
	fib(i:Int) : Int {
		if i < 2 then 1 else 
			fib(i-1) + fib(i-2)
		fi
	};
	main() : Int {
		let num :Int in {
			io.out_string("enter which fib no. is to be found\n");
			io.out_string("fib(0) = fib(1) = 1\n");
			num<-io.in_int();
			io.out_string("the answer is : ");
			io.out_int(fib(num));
			io.out_string("\n");
			12345;
		}
	};
};
			
