/*
Raj Deepaknath Patil
CS18BTECH11039

Eight Queen problem: dfs
*/
validIndex(X):-
	% ensuring chosen index is within bounds
	member(X,[1,2,3,4,5,6,7,8]).

validPos(_,[]). % base case

validPos(X/Y,[X1/Y1|Rest_pos]):-
	% recursively checking for a safe position
	X =\= X1, % horizontally safe
	Y =\= Y1, % vertically safe
	X - X1 =\= Y - Y1, % diagonal safety
	X - X1 =\= Y1 - Y, % diagonal safety
	validPos(X/Y,Rest_pos). % ensuring safety with remaining queens

placeNextQueen(Config,[X/Y|Config]):-
	length(Config,L),
	X is (1+L), % placing queens from the left collumn one by one
	validIndex(Y), % ensuring Y is not out of bounds
	validPos(X/Y,Config). % checking safety of position

solved(Config):-
	/*stop when have place 8 queens ;
	* no need to reverify safety;
	* assured due to the way of construction itself
	*/
	length(Config,L),
	L is 8.


% code to print the solutions 
storeSols():-
	open(dfs_solutions,write,SOL),
	solwriter(SOL),
	close(SOL).


% code to print the solutions in a presentable manner
printList(_,[]).
printList(Stream,[Top|Rest]):-
	write(Stream,Top),nl(Stream),
	printList(Stream,Rest).

% the actual stream writer
solwriter(Stream):-
	findall(X,solve_dfs([],[X|_]),Y),
	printList(Stream,Y).



findSol(X):-
	solve_dfs([],[X|_]);
	fail.

% generic code regarding traversal of the search tree

solve_dfs(Node,Path):-
	dfs(Node,RevPath),
	reverse(RevPath,Path).

dfs(Node,[]):-
	solved(Node).
	
dfs(Node,[NextNode|Path]):-
	placeNextQueen(Node,NextNode),
	dfs(NextNode,Path).
