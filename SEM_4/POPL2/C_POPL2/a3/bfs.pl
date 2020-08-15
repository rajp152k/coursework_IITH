/*
Raj Deepaknath Patil
CS18BTECH11039

Eight Queen problem: bfs
*/
debug1().
debug2().% spying purposes

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
	validPos(X/Y,Config), % checking safety of position
	((X is 8, Y is 8) -> debug1();true).

solved(Config):-
	/*stop when have place 8 queens ;
	* no need to re-verify safety;
	* assured due to the way of construction itself
	*/
	length(Config,L),
	%L is 8.
	((L is 8)->debug2();false).


% code to print the solutions 
storeSols():-
	open(bfs_solutions,write,SOL),
	solwriter(SOL),
	close(SOL).


% code to print the solutions in a presentable manner
printList(_,[]).
printList(Stream,[Top|Rest]):-
	write(Stream,Top),nl(Stream),
	printList(Stream,Rest).

% the actual stream writer
solwriter(Stream):-
	findall(X,solve_bfs([],[X|_]),Y),
	printList(Stream,Y).



findSol(X):-
	solve_bfs([],[X|_]);
	fail.

% generic code regarding traversal of the search tree

solve_bfs(Node,Path):-
	bfs([[Node]],Path).

bfs([[Node|Path]|_],[Node|Path]):-
	solved(Node).

bfs([Path|Paths],SolPath):-
	expand_bfs(Path,ExpPaths),
	append(Paths,ExpPaths,NewPaths),
	bfs(NewPaths,SolPath).

expand_bfs([Node|Path],ExpPaths):-
	findall([NewNode,Node|Path],
	placeNextQueen(Node,NewNode),
	ExpPaths).
