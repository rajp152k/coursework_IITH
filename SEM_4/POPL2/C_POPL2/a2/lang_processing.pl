/*
Raj Deepaknath Patil
CS18BTECH11039

Language Processing
*/

isA(X,Y):- isa(X,Y).
isA(X,Y):-
	isa(X,Z),
	isA(Z,Y).

do():-
	write('Enter the assertion/query'),nl,
	read(X),
	atomic_list_concat(L,' ',X),
	(
		((L = ['Is',S1,'a',S2,'?']) ->
				(isA(S1,S2));false);
		((L = ['A',S1,'is','a',S2,'.']) ->
				(assert(isa(S1,S2)));false);
		((L = [S1,'is','a',S2,'.'])->
			assert(isa(S1,S2));false)
	).

