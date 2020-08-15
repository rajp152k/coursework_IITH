# ROLL NO  	: CS18BTECH11039
# NAME		: RAJ DEEPAKNATH PATIL

## POPL2_C ASSIGMENT: LOGIC PROGRAMMING
## Language processing

isA/2:-
	my quering predicate.

isa/2:- 
	my dynamic database.

note the definition of recursion for isA/2:-
	1. it's isa followed by isA and not the other way oround otherwise it leads to a stack limit error:- as the search tree is not finite.


# USAGE:- 

enter 'do().' to begin processing assertions/queries
take note of the way to write the ending punctuation :- there has to be a space in between

# examples:-
```pl
	?- do().
	Enter the assertion/query
	|: 'A is a B .'.

	true.

	?- do().
	Enter the assertion/query
	|: 'B is a C .'.

	true.

	?- do().
	Enter the assertion/query
	|: 'A C is a D .'.

	true .

	?- do().
	Enter the assertion/query
	|: 'Is A a D ?'.

	true .

	?- ^D
```
