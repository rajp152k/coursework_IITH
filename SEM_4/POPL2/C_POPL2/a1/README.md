# ROLL NO  	: CS18BTECH11039
# NAME		: RAJ DEEPAKNATH PATIL

## POPL2_C ASSIGMENT: LOGIC PROGRAMMING
## Map Coloring 

# Functor descriptions

- colors/1 :- 
	a list of colors fed in by the user

- getColor/1 :-
 	returns a valid color

- getNeighbors/3 :-
	returns the list of neighbors given the Map and a State in the last argument.

- adjacency/3 :-
    	states whether two states are adjacent in a given Map

- notValid/2 :-
	given two states,a Map, and a Coloring, verifies if the there are no conflicts

- color/4 :- 
	the way to color a State in a map with Color with the encoding being Coloring

- allStates/2 :- 
 	returns the list of States in a Map using the getStates/2 functor

- paint/2 :-
	paints the Map  with the encoding being stored in Coloring

- solved/2 :- 
	goal condition checker for the dfs

- validMove/3:-
	given a Map and present coloring, outputs whether a proposed coloring is valid

- colorOneMore/4 :-
	does just what it says
	- uses assert and retract to manipulate the color database to allow to test if one of the chosen ones is valid

### generic predicates : also used in question 3

- solve_dfs/4 :-
	traverses search tree given a Coloring( Node ) and storing the sequence of traversal in Paths.

- the move of the dfs is represented by colorOneMore/4 predicate 
	it traverses between 2 nodes(colorings).

- the goal of the search is to succesfully color all states


### USAGE

provide Map and the color list in the format stated at the top of the source code.

then Call paint(Map,Colors,Coloring), to get a valid coloring in Coloring.

using test1 to check correctness for the number of solutions :- should be 12 (4*3)
keep on pressing ; for all solutions and . to stop 

```pl
	Welcome to SWI-Prolog (threaded, 64 bits, version 8.0.3)
	SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
	Please run ?- license. for legal details.

	For online help and background, visit http://www.swi-prolog.org
	For built-in help, use ?- help(Topic). or ?- apropos(Word).

	?- paint('test0',C).
	C = [s4:red, s3:green, s2:green, s1:red] .

	?- paint('test1',C).
	C = [s2:green, s1:red] ;
	C = [s2:blue, s1:red] ;
	C = [s2:purple, s1:red] ;
	C = [s2:red, s1:green] ;
	C = [s2:blue, s1:green] ;
	C = [s2:purple, s1:green] ;
	C = [s2:red, s1:blue] ;
	C = [s2:green, s1:blue] ;
	C = [s2:purple, s1:blue] ;
	C = [s2:red, s1:purple] ;
	C = [s2:green, s1:purple] ;
	C = [s2:blue, s1:purple] ;
	false.

	?- paint('Australia',C).
	C = [sa:blue, tas:red, vic:red, nsw:green, qld:red, nt:green, wa:red] .

	?- paint('West Europe',C).
	C = [germany:purple, france:blue, austria:blue, italy:green, switzerld:red, luxembrg:green, holland:green, belgium:red, ... : ...|...] ;
	C = [germany:blue, france:purple, austria:purple, italy:green, switzerld:red, luxembrg:green, holland:green, belgium:red, ... : ...|...] 
	C = [germany:blue, france:purple, austria:purple, italy:green, switzerld:red, luxembrg:green, holland:green, belgium:red, spain:green, portugal:red] 
	?- ^D
```
