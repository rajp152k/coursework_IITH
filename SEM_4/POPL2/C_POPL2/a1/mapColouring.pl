/*
Raj Deepaknath Patil
CS18BTECH11039

Map Coloring
*/

map('test0',
	[s1:[s2,s3],s2:[s1],s3:[s1,s4],s4:[s3]]).
map('test1',[s1:[s2],s2:[s1]]).

map('Australia',
	[wa: [nt,sa], nt: [wa,sa,qld], qld:[nt,sa,nsw],
	nsw: [qld,sa,vic], vic: [sa,nsw], tas:[],
	sa: [wa,nt,qld,nsw,vic]]).

map('West Europe',
	[portugal: [spain],
	spain: [portugal, france],
	belgium: [france, holland, luxembrg, germany],
	holland: [belgium, germany],
	luxembrg: [france, belgium, germany],
	switzerld: [france,germany,austria, italy],
	italy: [france,switzerld, austria],
	austria: [germany, switzerld, italy],
	france: [spain,belgium,luxembrg, germany,switzerld, italy],
	germany:[holland,belgium,luxembrg,france,switzerld, austria]]).

colors([red,green,blue,purple]).

getColor(X) :- colors(Y),member(X,Y).

getNeighbors(Map,State,Ns):-
	% returns a list of neighbors of State in Map
	map(Map,StateList),
	member(State:Ns,StateList).

adjacency(Map,S1,S2):-
	% whether S1 and S2 are adacent in Map
	getNeighbors(Map,S1,Ns),
	member(S2,Ns).

% get the States from a State:Neighbor List
getStates([S:_],States):-
	States = [S].
getStates([S:_|Rest],States):-
	getStates(Rest,SBuffer),
	States = [S|SBuffer].

allStates(Map,States):-
	% takes in Map and outputs all States in States
	map(Map,StateList),
	getStates(StateList,States).
	

paint(Map,Coloring):-
	% paints Map with the given Colors(minimum 4 for a valid colouring to exist and outputs them in Coloring
	allStates(Map,States),
	solve_dfs(Map,States,[],Path),
	Path  = [Coloring|_].


solved(_,States,Coloring):-
	/* due to the way the Coloring is being constructed,
	don't need to check the main criterion in the end*/
	length(Coloring,L),
	length(States,L).

validMove(_,[],_).
validMove(Map,[S1:C1|Coloring],NextState:Color):-
	(adjacency(Map,S1,NextState) -> (Color \= C1);true),
	validMove(Map,Coloring,NextState:Color).	

	
colorOneMore(Map,States,Coloring,[NextState:Color|Coloring]):-
	length(Coloring,L),
	nth0(L,States,NextState),	
	getColor(Color),
	assert(color(Map,NextState,Color,[NextState:Color|Coloring])),
	(validMove(Map,Coloring,NextState:Color)->
		(true);
		(retract(color(Map,NextState,Color,[NextState:Color|Coloring]))
			,fail)
	).

% generic dfs code
solve_dfs(Map,States,Coloring,Path):-
	dfs(Map,States,Coloring,RevPath),
	reverse(RevPath,Path).

dfs(Map,States,Coloring,[]):-
	solved(Map,States,Coloring).

dfs(Map,States,Coloring,[NextColoring|Path]):-
	colorOneMore(Map,States,Coloring,NextColoring),
	dfs(Map,States,NextColoring,Path).
