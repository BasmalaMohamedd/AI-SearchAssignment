%Uninformed Search
%1- Initial State:
%D, #, P, #, O
%#, O, #, #, P
%#, #, O, P, #
%P, O, #, #, #
%#, #, #, O, #
%
%[D, #, P, #, O, #, O, #, #, P, #, #, O, P, #, P, O, #, #, #, #, #, #, #, O, #]
%
%
%
%2- Goal State:
%
%example Path
%*, *, *, D, O   counter = 1
%#, O, #, #, P
%#, #, O, P, #
%P, O, #, #, #
%#, #, #, O, #
%
%O is left to D
%O is right to D
%O is up to D
%O is down to D
%
%
%3- Actions:
%move
%move and collect P   counter++
%
%
%4- Trasition Model:
%moveUp
%moveDown
%moveRight
%moveLeft
%
%
%
%5- Cost of path:
%numberOfMoves
%




search(Open, Closed, Goal):-
getState(Open, [CurrentState,Parent], _), % Step 1
CurrentState = Goal, !, % Step 2
write("Search is complete!"), nl,
printSolution([CurrentState,Parent], Closed).
search(Open, Closed, Goal):-
getState(Open, CurrentNode, TmpOpen),
getAllValidChildren(CurrentNode,TmpOpen,Closed,Children), % Step3
addChildren(Children, TmpOpen, NewOpen), % Step 4
append(Closed, [CurrentNode], NewClosed), % Step 5.1
search(NewOpen, NewClosed, Goal). % Step 5.2
% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children):-
findall(Next, getNextState(Node, Open, Closed, Next), Children).
getNextState([State,_], Open, Closed, [Next,State]):-
move(State, Next),
not(member([Next,_], Open)),
not(member([Next,_], Closed)).
% Implementation of getState and addChildren determine the search
alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).
addChildren(Children, Open, NewOpen):-
append(Open, Children, NewOpen).
% Implementation of printSolution to print the actual solution path
printSolution([State, null],_):-
write(State), nl.
printSolution([State, Parent], Closed):-
member([Parent, GrandParent], Closed),
printSolution([Parent, GrandParent], Closed),
write(State), nl.
move(State, Next):-
left(State, Next); right(State, Next);
up(State, Next); down(State, Next).
left(State, Next):-
nth0(EmptyTileIndex, State, #),
not(0 is EmptyTileIndex mod 3),
NewIndex is EmptyTileIndex - 1,
nth0(NewIndex, State, Element),
% Swap
substitute(#, State, x, TmpList1),
substitute(Element, TmpList1, #, TmpList2),
substitute(x, TmpList2, Element, Next).
right(State, Next):-
nth0(EmptyTileIndex, State, #),
not(2 is EmptyTileIndex mod 3),
NewIndex is EmptyTileIndex + 1,
nth0(NewIndex, State, Element),
% Swap
substitute(#, State, x, TmpList1),
substitute(Element, TmpList1, #, TmpList2),
substitute(x, TmpList2, Element, Next).
up(State, Next):-
nth0(EmptyTileIndex, State, #),
EmptyTileIndex > 2,
NewIndex is EmptyTileIndex - 3,
nth0(NewIndex, State, Element),
% Swap
substitute(#, State, x, TmpList1),
substitute(Element, TmpList1, #, TmpList2),
substitute(x, TmpList2, Element, Next).
down(State, Next):-
nth0(EmptyTileIndex, State, #),
EmptyTileIndex < 6,
NewIndex is EmptyTileIndex + 3,
nth0(NewIndex, State, Element),
% Swap
substitute(#, State, x, TmpList1),
substitute(Element, TmpList1, #, TmpList2),
substitute(x, TmpList2, Element, Next).
substitute(Element, [Element|T], NewElement, [NewElement|T]):- !.
substitute(Element, [H|T], NewElement, [H|NewT]):-
substitute(Element, T, NewElement, NewT).
