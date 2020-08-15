# ROLL NO  	: CS18BTECH11039
# NAME		: RAJ DEEPAKNATH PATIL

## POPL2_C ASSIGMENT: LOGIC PROGRAMMING
## Eight Queen Problem

### common predicates

- validIndex/1:-
	returns a viable index (from 1 to 8)

- validPos/2:-
	checks if a given position for the new queen is safe given the previously placed queens

- placeNextQueen/2:-
	move between 2 nodes(explained later) on the search tree

- solved/1:-
	to verify if goal Node has been reached

#### storeSols/0 ; printList/1 ; solwriter/1 ; findSol/1:- are interface and usage functions :- clear when showing usage 


### general approach:-
	1. Every search problem has a search tree and associated with it :- Nodes and moves
	2. A Node in this case is the configuration of a certain number of queens and a move is placing one more queen
	3. the goal Node is reached when we have placed 8 queens

### DFS 
	1. In DFS, we need to only store one Path at a time.
	2. A move would be to simple place one more queen and we're done.

### BFS
	1. In BFS, we need to store a collection of Paths at a time :- consumes more runtime memory
	2. So, a general idea of a move would be to pick out the head node and append all possible safe configurations with one more queen at the end of the current record of safe configurations:- Hence we need an extra argument of expandbfs... as compared to dfs
	3. also note that we are storing a list of paths in this case rather than just one path in the case of dfs
	
### general note:-
It is important to notice that:- owing to the design of the approach to the problem, we don't need to maintain a list of visited nodes as with every move, the list only grows towards new nodes.
Also this is not a completely naive approch :- we are using a bit of heuristics:- by placing only one queen in one row by design of approach, the foolish way about this would be to use validIndex(X) instead X is (1+L) in the placeOneMoreQueen predicate which would be wasteful as the number of useless checks increases as we near to the end of the solution.


### usage:dfs
	- to get solutions in an interactive way : use findsol(X) and keep on pressing ;
	- to get all the solutbons at once.. use storesols(). :- the list of solutions will be printed in dfs_solutions.

### usage:bfs
	- to get solutions in an interactive way : use findsol(X) and keep on pressing ;
	- to get all the solutions at once.. use storesols(). :- the list of solutions will be printed in bfs_solutions.

	    ===================THE INTERFACE IS THE SAME FOR BOTH======================
```pl 
	Welcome to SWI-Prolog (threaded, 64 bits, version 8.0.3)
	SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
	Please run ?- license. for legal details.

	For online help and background, visit http://www.swi-prolog.org
	For built-in help, use ?- help(Topic). or ?- apropos(Word).

	?- findSol(X).
	X = [8/4, 7/2, 6/7, 5/3, 4/6, 3/8, 2/5, 1/1] ;
	X = [8/5, 7/2, 6/4, 5/7, 4/3, 3/8, 2/6, 1/1] ;
	X = [8/3, 7/5, 6/2, 5/8, 4/6, 3/4, 2/7, 1/1] .

	?- storeSols().
	true ;
	false.

	?- ^D
```


To verify if the number of solutions are correct :- 
	use 
	```bash 
	cat bfs_solutions|wc -l # or dfs_solutions
	```

as expected, an answer of 92 is printed
