/* Для проверки, было ли это состояние уже в истории */
member1(X, [X|_]). 
member1(X, [_|Ys]):- member1(X, Ys).


/* Проверяет, находятся ли во множестве вместе коза и волк */
illegal(P) :- 	member(wolf, P), member(goat, P).

/* Проверяет, находятся ли во множестве вместе коза и капуста */
illegal(P) :- 	member(goat, P), member(cabbage, P).


/* Проверяет уже новый правый берег */
legal(wgc(left, _, R)) :-	not(illegal(R)).

/* Проверяет уже новый левый берег */
legal(wgc(right, L, _)) :-	not(illegal(L)).


/* Чтобы не повторялась перевозка одного и того же туда обратно */
precedes(wolf, _).
precedes(_, cabbage).


/* Всталяет отсортированно в список (Может быть только волк, коза, капуста) */
insert(X, [Y|Ys], [X, Y | Ys]) :- precedes(X, Y).

insert(X, [Y|Ys], [Y|Zs]) :- precedes(Y, X), insert(X, Ys, Zs).

/* Добавляет элемент в пустой список. */
insert(X, [], [X]).


/* Если лодка идет одна, то все оставляет как есть. */
update_bank(alone, _, L, R, L, R).

/* Если лодка движется слева направо, то слева удалить того, кого перевозит лодка, а справа добавить  */
update_bank(Cargo, left, L, R, L1, R1) :- 	select(Cargo, L, L1),
						insert(Cargo, R, R1).

/* Если лодка движется справа налево, то справа удалить того, кого перевозит лодка, а слева добавить  */
update_bank(Cargo, right, L, R, L1, R1) :-	select(Cargo, R, R1),
						insert(Cargo, L, L1).



/* По сути, двигает лодку! */
update_boat(left, right).
update_boat(right, left).



/* Обновляет положения волка/капусты/козла и лодки при движении лодки. */
update(wgc(B, L, R), Cargo, wgc(B1, L1, R1)) :- update_boat(B, B1),
						update_bank(Cargo, B, L, R, L1, R1).


/* Заносит в Cargo первый элемент списка */
member(X, [X|_]).

/* Будет проходить по всем элементам списка */
member(X, [_|Ys]) :- member(X, Ys).



/* Если лодка будет плыть слева направо, то в лодку заходит кто-то с левого берега. Пример: Cargo = wolf. */
move(wgc(left, L, _), Cargo) :-	member(Cargo, L).

/* Если лодка будет плыть справа налево, то в лодку заходит кто-то с правого берега */
move(wgc(right, _, R), Cargo):- member(Cargo, R).

/* Сохраняет в Cargo значение alone. Т.е. лодка будет плыть без пассажиров. */
move(wgc(_, _, _), alone). 



/* На старте он здесь накалывается, поэтому идет в следующий solve */
solve(State, _, []) :- 	final_state(State).

/* Сначала, в зависимости от того, где находится лодка (left/right), решается, кого взять с собой(алгоритм проходит циклом по всему списку), после обновляет состояние, т.е. лодка, если была справа, то булет слева, а перевозимый волк удалится из правого списка и добавится в левый. Потом происходит проверка на согласие с требованиями: остались ли на одном берегу волк и коза..., после чего происходит просмотр, записан ли этот вариант в истории, (пытается найти состояние в списке истории). Если не находит, то пытается решать дальше, записывая в истории. Находит - возвращается в предыдущую функцию и вызывает с другими параметрами.  */
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
          