%Uninformed Search
%
%input M, N
%1- Initial State:
%D, #, P, #, O
%#, O, #, #, P
%#, #, O, P, #
%P, O, #, #, #
%#, #, #, O, #
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


%1- getState(Open, [CurrentState, Parent], _)
%2- CurrentState = Goal
%
%
%
InitialState = ["D", "-", "P", "P", "P",
                "P", "-", "P", "P", "P",
                "P", "P", "P", "P", "P",
                "P", "P", "P", "P", "P",
                "P", "P", "P", "P", "-"].

GoalState = [*, *, *, "P", "P",
             "P", "-", "P", "P", "P",
             "P", "P", "P", "P", "P",
             "P", "P", "P", "P", "P",
             "P", "P", "P", "P", "-"].


search(Open, Closed, Goal, Counter):-
getState(Open, [CurrentState,Parent], _), % Step 1
CurrentState = Goal, !, % Step 2
write("Search is complete!"), nl,
write(Counter), nl,
printSolution([CurrentState,Parent], Closed).


search(Open, Closed, Goal, Counter):-
getState(Open, CurrentNode, TmpOpen),
getAllValidChildren(CurrentNode,TmpOpen,Closed,Children, Counter, NewCounter), % Step3
addChildren(Children, TmpOpen, NewOpen), % Step 4
append(Closed, [CurrentNode], NewClosed), % Step 5.1
search(NewOpen, NewClosed, Goal, NewCounter). % Step 5.2


% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children, Counter, NewCounter):-
findall(Next, getNextState(Node, Open, Closed, Next, Counter, NewCounter), Children).


getNextState([State,_], Open, Closed, [Next,State], Counter, NewCounter):-
move(State, Next),
not(member([Next,_], Open)),
not(member([Next,_], Closed)),
((Next is "P", NewCounter is Counter + 1); NewCounter is Counter).


% Implementation of getState and addChildren determine the search
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

(   left(State, Next); right(State, Next);
up(State, Next); down(State, Next)),
not(Next = "O").



left(State, Next):-
nth0(DroneTileIndex, State, "D"),
not(0 is DroneTileIndex mod 5), %M = 5
NewIndex is DroneTileIndex - 1,
nth0(NewIndex, State, Element),
% Swap
substitute("D", State, *, TmpList1),
substitute(Element, TmpList1, "D", Next).

right(State, Next):-
nth0(DroneTileIndex, State, "D"),
not(4 is DroneTileIndex mod 5), %M = 5
NewIndex is DroneTileIndex + 1,
nth0(NewIndex, State, Element),
% Swap
substitute("D", State, *, TmpList1),
substitute(Element, TmpList1, "D", Next).

up(State, Next):-
nth0(DroneTileIndex, State, "D"),
DroneTileIndex > 4, %N = 5
NewIndex is DroneTileIndex - 5, %M = 5
nth0(NewIndex, State, Element),
% Swap
substitute("D", State, *, TmpList1),
substitute(Element, TmpList1, "D", Next).

down(State, Next):-
nth0(DroneTileIndex, State, "D"),
DroneTileIndex < 20, %N = 5
NewIndex is DroneTileIndex + 5, %M = 5
nth0(NewIndex, State, Element),
% Swap
substitute("D", State, *, TmpList1),
substitute(Element, TmpList1, "D", Next).



substitute(Element, [Element|T], NewElement, [NewElement|T]):- !.

substitute(Element, [H|T], NewElement, [H|NewT]):-
substitute(Element, T, NewElement, NewT).
