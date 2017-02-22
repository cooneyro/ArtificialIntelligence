%Defining a-star predicate
a-star(Start,Seed,Target,Found) :- search([[Start, 0]], Seed, Target, Found).

%goal node = multiple of target
goal(N,Target) :- 0 is N mod Target.

%edges between vertices
arc([N,NCost],[M,MCost],Seed) :- M is N*Seed, MCost is NCost+1.
arc([N,NCost],[M,MCost],Seed) :- M is N*Seed + 1, MCost is NCost+2.

%heuristic value of N given target
h(N,Hvalue,Target) :- goal(N,Target), !, Hvalue is 0
;
Hvalue is 1/N.

%find least cost
less-than([Node1,Cost1],[Node2,Cost2],Target) :-
h(Node1,Hvalue1,Target), h(Node2,Hvalue2,Target),
F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
F1 =< F2.

%insert element into a list based on the heuristic value
insert(E, [], [E], _).
insert(E, [H|T], [E,H|T], Target) :- less-than(E, H, Target), !.
insert(E, [H|T], [H|Combined], Target) :- insert(E, T, Combined, Target).

%append 
addtofrontier(FNode, [], FNode, _).
add-to-frontier([],FRest,FRest, _).
add-to-frontier([H|T],FRest, New, Target) :- insert(H, FRest, NewRest, Target), add-to-frontier(T, NewRest, New, Target).

%search function
search([[Node,_]|_], _, Target, Node) :- goal(Node, Target).
search([[Node,Cost]|FRest], Seed, Target, Found) :- setof(X,arc([Node,Cost],X,Seed), FNode),
													add-to-frontier(FNode,FRest,FNew, Target),
													search(FNew, Seed, Target, Found).