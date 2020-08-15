--Name 	: Raj Deepaknath Patil
--Roll no : CS18BTECH11039 
--Programming assignment 0 : toy cool programs

class Node inherits IO {
	val : Int;
	getval():Int{val};
	setval(i:Int):Int{val<-i};

	next : Node; -- void by defualt 
	getnext():Node{next};
	setnext(n:Node):Node{next<-n};

	printNode(i:Int):Int{
		{
			out_string("Node no:");
			out_int(i);
			out_string("\n");
			out_string("value stored:");
			out_int(val);
			out_string("\n");
			if isvoid next then
				out_string("this is the last node\n")
			else 0
			fi;
			0;
		}
	};
};
class Main inherits IO{
	size : Int;
	head : Node; 
	main():Int{
		{
			out_string("enter the size of the linked list\n");
			out_string("these many NEW nodes will be created\n"); size<-in_int(); head <- new Node;
			head.setval(0);
			let i:Int <- 0, current:Node <- head, buffer:Node in
				while i<size loop
				{
					buffer <- new Node;
					buffer.setval(i+1);
					current.setnext(buffer);
					current<-buffer;
					i<-i+1;
				}
				pool;
			-- built a list
			-- traversing a list now
			-- no manual deallocation possible, the garbage collector'll kick in when an object is inaccessible
			let buffer:Node <- head,i:Int <- 0 in 
				while not isvoid buffer loop {
				buffer.printNode(i+1);
				i<- i+1;
				buffer <- buffer.getnext();
				}
				pool;

			-- pointing head to void for making all the nodes as inaccessible so that the garbage collector can do its job 
			head <- new Node;
			0;
		}
	};
};

