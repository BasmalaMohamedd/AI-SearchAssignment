
testPrintGrid:-
    List = [d, -, p, -, o, -, 0, -, -, p, -, -, o, p, -, p, o, -, -, -, -, -, p, o, -],
    printGrid(List, 0, 5).


solve:-
    InitialState = [d, -, p, -, o, -, 0, -, -, p, -, -, o, p, -, p, o, -, -, -, -, -, p, o, -],
    GoalState = [*, *, *, -, o, -, 0, *, *, *, -, -, o, *, *, p, o, *, *, -, -, -, d, o, -],

    search([[InitialState,null]], [],GoalState , 5, 5).
search(Open, Closed, Goal, M, N):-
    getState(Open, [CurrentState,Parent], _), % Step 1
    CurrentState = Goal, !, % Step 2
    write("Search is complete!"), nl,
    printSolution([CurrentState,Parent], Closed, M).

search(Open, Closed, Goal, M, N):-
    getState(Open, CurrentNode, TmpOpen),
    getAllValidChildren(M, N, CurrentNode, TmpOpen, Closed, Children), % Step3
    addChildren(Children, TmpOpen, NewOpen), % Step 4
    append(Closed, [CurrentNode], NewClosed), % Step 5.1
    search(NewOpen, NewClosed, Goal, M, N). % Step 5.2

% Implementation of step 3 to get the next states
getAllValidChildren(M, N, Node, Open, Closed, Children):-
    findall(Next, getNextState(M, N, Node, Open, Closed, Next), Children).

getNextState(M, N, [State,_], Open, Closed, [Next,State]):-
    move(M, N, State, Next),
    \+member([Next,_], Open),
    \+member([Next,_], Closed).

% Implementation of getState and addChildren determine the search alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
    append(Open, Children, NewOpen).

% Implementation of printSolution to print the actual solution path
printSolution([State, null],_, M):-
    printGrid(State, 0, M), nl.

printSolution([State, Parent], Closed, M):-
    member([Parent, GrandParent], Closed),
    printSolution([Parent, GrandParent], Closed, M),
    printGrid(State, 0, M), nl.

printGrid([H|T], Count, RowSize):-
    write(H), write(' '),
    NewCount is Count + 1,
    (0 is NewCount mod RowSize -> nl ; true),
    printGrid(T, NewCount, RowSize).



printGrid([], _, _).

move(M, N, State, Next):-
    left(M, State, Next); right(M, State, Next);
    up(M,State, Next); down(M, N, State, Next).

left(M, State, Next):-
    nth0(DroneIndex, State, d),
    \+(0 is DroneIndex mod M),
    NewIndex is DroneIndex - 1,
    nth0(NewIndex, State, Element),
    \+(Element = o),
    % Swap
    substitute(DroneIndex, State, *, TmpList1),
    substitute(NewIndex, TmpList1, d, Next).

right(M, State, Next):-
    nth0(DroneIndex, State, d),
    K is M - 1,
    \+(K is DroneIndex mod M),
    NewIndex is DroneIndex + 1,
    nth0(NewIndex, State, Element),
    \+(Element = o),

    % Swap
    substitute(DroneIndex, State, *, TmpList1),
    substitute(NewIndex, TmpList1, d, Next).

up(M,State, Next):-
    nth0(DroneIndex, State, d),
    DroneIndex >= M,
    NewIndex is DroneIndex - M,
    nth0(NewIndex, State, Element),
    \+(Element = o),

    % Swap
    substitute(DroneIndex, State, Element, TmpList1),
    substitute(NewIndex, TmpList1, d, Next).

down(M, N, State, Next):-
    nth0(DroneIndex, State, d),
    LastRowStart is M * (N - 1),
    DroneIndex < LastRowStart + M,  % More accurate boundary check
    NewIndex is DroneIndex + M,
    nth0(NewIndex, State, Element),
    \+(Element = o),

    % Swap
    substitute(DroneIndex, State, *, TmpList1),
    substitute(NewIndex, TmpList1, d, Next).

substitute(Index, List, NewElement, NewList):-
    subs(Index, 0, List, NewElement, NewList).

subs(Index, Index, [_|T], NewElement, [NewElement|T]):- !.
subs(Index, Counter, [H|T], NewElement, [H|NewT]):-
    NewCounter is Counter + 1,
    subs(Index, NewCounter, T, NewElement, NewT).
