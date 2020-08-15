AUTHOR: RAJ PATIL
ROLL NO: CS18BTECH11039

matmul.c contains the code submitted to the autograder and is coded according to the LINUX kernel style.

matmul_test.c contains the code used for testing: executing procedures for Nruns and reporting average time.
DO NOT GRADE ACCORDING TO matmul_test.c, ONLY CONSIDER matmul.c
no GNOME standards enforced for matmul_test.c

how to compile:
 - compile using gcc :
	- flags to use
		1. -lpthread
		2. -lrt 
		3. -O2 (compiler optimization) to check correctness for optimized code 

usage instructions :
mandatory named arguments:
--ar 
--ac
--br 
--bc 
optional arguments:
--interactive

usage sample:

$ ./a.out --ar 100 --ac 100 --br 100 --bc 100
Time taken for single threaded: 1343 us
Time taken for multi process: 632 us
Time taken for multi threaded: 39 us
Speedup for multi process : 2.12 x
Speedup for multi threaded : 34.44 x


$ ./a.out --ar 2 --ac 2 --br 2 --bc 2 --interactive
Enter A:
1 0
0 1
Enter B:
1 2
3 4
Result:
1 2
3 4
Enter A:
1 2
3 4
Enter B:
1 0
0 1
Result:
1 2
3 4
Enter A:
1 0
0 1
Enter B:
9 8
2 4
Result:
9 8
2 4
Time taken for single threaded: 1 us
Time taken for multi process: 309 us
Time taken for multi threaded: 70 us
Speedup for multi process : 0.00 x
Speedup for multi threaded : 0.01 x



