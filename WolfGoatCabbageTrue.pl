/* ��� ��������, ���� �� ��� ��������� ��� � ������� */
member1(X, [X|_]). 
member1(X, [_|Ys]):- member1(X, Ys).


/* ���������, ��������� �� �� ��������� ������ ���� � ���� */
illegal(P) :- 	member(wolf, P), member(goat, P).

/* ���������, ��������� �� �� ��������� ������ ���� � ������� */
illegal(P) :- 	member(goat, P), member(cabbage, P).


/* ��������� ��� ����� ������ ����� */
legal(wgc(left, _, R)) :-	not(illegal(R)).

/* ��������� ��� ����� ����� ����� */
legal(wgc(right, L, _)) :-	not(illegal(L)).


/* ����� �� ����������� ��������� ������ � ���� �� ���� ������� */
precedes(wolf, _).
precedes(_, cabbage).


/* �������� �������������� � ������ (����� ���� ������ ����, ����, �������) */
insert(X, [Y|Ys], [X, Y | Ys]) :- precedes(X, Y).

insert(X, [Y|Ys], [Y|Zs]) :- precedes(Y, X), insert(X, Ys, Zs).

/* ��������� ������� � ������ ������. */
insert(X, [], [X]).


/* ���� ����� ���� ����, �� ��� ��������� ��� ����. */
update_bank(alone, _, L, R, L, R).

/* ���� ����� �������� ����� �������, �� ����� ������� ����, ���� ��������� �����, � ������ ��������  */
update_bank(Cargo, left, L, R, L1, R1) :- 	select(Cargo, L, L1),
						insert(Cargo, R, R1).

/* ���� ����� �������� ������ ������, �� ������ ������� ����, ���� ��������� �����, � ����� ��������  */
update_bank(Cargo, right, L, R, L1, R1) :-	select(Cargo, R, R1),
						insert(Cargo, L, L1).



/* �� ����, ������� �����! */
update_boat(left, right).
update_boat(right, left).



/* ��������� ��������� �����/�������/����� � ����� ��� �������� �����. */
update(wgc(B, L, R), Cargo, wgc(B1, L1, R1)) :- update_boat(B, B1),
						update_bank(Cargo, B, L, R, L1, R1).


/* ������� � Cargo ������ ������� ������ */
member(X, [X|_]).

/* ����� ��������� �� ���� ��������� ������ */
member(X, [_|Ys]) :- member(X, Ys).



/* ���� ����� ����� ����� ����� �������, �� � ����� ������� ���-�� � ������ ������. ������: Cargo = wolf. */
move(wgc(left, L, _), Cargo) :-	member(Cargo, L).

/* ���� ����� ����� ����� ������ ������, �� � ����� ������� ���-�� � ������� ������ */
move(wgc(right, _, R), Cargo):- member(Cargo, R).

/* ��������� � Cargo �������� alone. �.�. ����� ����� ����� ��� ����������. */
move(wgc(_, _, _), alone). 



/* �� ������ �� ����� ������������, ������� ���� � ��������� solve */
solve(State, _, []) :- 	final_state(State).

/* �������, � ����������� �� ����, ��� ��������� ����� (left/right), ��������, ���� ����� � �����(�������� �������� ������ �� ����� ������), ����� ��������� ���������, �.�. �����, ���� ���� ������, �� ����� �����, � ����������� ���� �������� �� ������� ������ � ��������� � �����. ����� ���������� �������� �� �������� � ������������: �������� �� �� ����� ������ ���� � ����..., ����� ���� ���������� ��������, ������� �� ���� ������� � �������, (�������� ����� ��������� � ������ �������). ���� �� �������, �� �������� ������ ������, ��������� � �������. ������� - ������������ � ���������� ������� � �������� � ������� �����������.  */
solve(State, History, [Move|Moves]) :- 	move(State, Move),
					update(State, Move, State1),
					legal(State1),
					not(member1(State1, History)),
					solve(State1, [State1 | History], Moves).



/* Start state : wolf, goat and cabbage are in the left bank. Nothing is in the right. "left" is the location of the cargo. */
initial_state(wgc(left, [wolf, goat, cabbage], [])).

/* Final state : wolf, goat and cabbage are in the right bank. Nothing is in the left. "right" is the location of the cargo */ 
final_state(wgc(right, [], [wolf, goat, cabbage])).



/* Task (transportation of wolf, goat and cabbage)*/
test :- initial_state(State) , solve(State, [State], Moves), write(Moves).
          