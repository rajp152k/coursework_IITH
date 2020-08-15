--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

-- possible mistakes from section 10.1

class Main inherits IO{
	-- just something that doesn't make sense to show that self is a special identifier
	-- alphanumerics with first character as letter can work as identifiers
	main():Int{
		{
			let a_9:Int,self:Int <-0  in 
			{
				out_string("this program can't be understood\n");
				self <- 1;
			};
			let ABc:Int in 
				0;
		}
	};
};


-- self is a special identifier, can't be used this way and also can't change its type from Main to Int 
-- also objects can't start with a capilalized letter (ABc is an invalid identifier in this case)


