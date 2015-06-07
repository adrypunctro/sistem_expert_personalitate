/* Librarii ------------------------------------------------------------------------
	Utilizare:
		- lists TODO: cazuri de utilizare
		- system TODO: cazuri de utilizare
*/
:- use_module(library(lists)).
:- use_module(library(system)).



/* Operatori ------------------------------------------------------------------------
	Descriere: Declarare operatori
*/
:- op(900,fy,not).



/* Predicate dinamice ------------------------------------------------------------------------
	Descriere: TODO: utilizare
*/
:- dynamic fapt/3.
:- dynamic interogat/1.
:- dynamic scop/1.
:- dynamic interogabil/3.
:- dynamic regula/3.



/* Operatori ------------------------------------------------------------------------
	Descriere: Definire operatori
*/
not(P):-
	P,
	!,
	fail.
not(_).


/* pornire **************************************************************************
	Specificatie predicat: pornire
	Descriere:
		Este principalul predicat al shell-ului. Acesta determina un ciclu de executie incarcand optiunile: incarca, consulta, reinitiaza, afisare_fapte, iesire, cum.
*/
pornire:-
	retractall(interogat(_)),
	retractall(fapt(_,_,_)),
	repeat,
	write('Introduceti una din urmatoarele optiuni: '),
	nl, nl,
	write(' (Incarca Consulta Reinitiaza Afiseare_fapte Cum Iesire) '),
	nl, nl,
	write('|: '),
	citeste_linie([H|T]),
	executa([H|T]),
	H == iesire.



/* executa ------------------------------------------------------------------------
	Specificatie predicat: executa TODO: parametrii
	Descriere: TODO: descriere
*/
executa([incarca]):-
	incarca,
	!,
	nl,
	write('Fisierul dorit a fost incarcat'),
	nl.
executa([consulta]):-
	scopuri_princ,
	!.
executa([reinitiaza]):-
	retractall(interogat(_)),
	retractall(fapt(_,_,_)),
	!.
executa([afisare_fapte]):-
	afiseaza_fapte,
	!.
executa([cum|L]):-
	cum(L),
	!.
executa([iesite]):-
	!.
executa([_|_]):-
	write('Comanda incorecta! '),
	nl.



/* scopuri_princ ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
scopuri_princ:-
	scop(Atr),
	determina(Atr),
	afiseaza_scop(Atr),
	fail.
scopuri_princ.



/* determina ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
determina(Atr):-
	realizare_scop(av(Atr,_),_,[scop(Atr)]),
	!.
determina(_).



/* afiseaza_scop ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
afiseaza_scop(Atr):-
	nl,
	fapt(av(Atr,Val),FC,_),
	FC >= 20,
	scrie_scop(av(Atr,Val),FC),
	nl,
	fail.
afiseaza_scop(_):-
	nl, nl.



/* scrie_scop ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
scrie_scop(av(Atr,Val),FC):-
	transformare(av(Atr,Val), X),
	scrie_lista(X),
	tab(2),
	write(' '),
	write('factorul de certitudine este '),
	FC1 is integer(FC),
	write(FC1).

	
	
/* realizare_scop ------------------------------------------------------------------------
	Specificatie predicat: realizare_scop(+Scop,+FC,-Istorie) 
	Parametrii: 
		- Scop are fie forma av(Atr,Val), fie forma not av(Atr,Val); Av este atributul despre care dorim sa aflam informatii la un moment dat si, de obicei, atunci cand acest predicat este folosit, Atr este deja instantiat.
		- FC reprezinta factorul de incertitudine ce va fi asociat faptului nostru in final.
		- Istorie retine "istoria" si este folosit pentru a raspunde la intrebarea "de ce?".
*/
realizare_scop(not Scop, Not_FC, Istorie):-
	realizare_scop(Scop, FC, Istorie),
	Not_FC is - FC,
	!.
realizare_scop(Scop, FC, _):-
	fapt(Scop, FC, _),
	!.
realizare_scop(Scop, FC, Istorie):-
	pot_interoga(Scop, Istorie),
	!,
	realizare_scop(Scop, FC, Istorie).
realizare_scop(Scop, FC_curent, Istorie):-
	fg(Scop, FC_curent, Istorie).


	
/* fg ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
fg(Scop, FC_curent, Istorie):-
	regula(N, premise(Lista), concluzie(Scop, FC)),
	demonstreaza(N, Lista, FC_premise, Istorie),
	ajusteaza(FC, FC_premise, FC_nou),
	actualizeaza(Scop, FC_nou, FC_curent, N),
	FC_curent == 100,
	!.
fg(Scop, FC, _):-
	fapt(Scop, FC, _).

	

/* incarca_reguli ------------------------------------------------------------------------
	Specificatie predicat: incarca_reguli
	Descriere:
*/
incarca_reguli:-
	repeat,
	citeste_propozitie(L),% TODO: predicat nedefinit
	proceseaza(L),
	L == [end_of_file],
	nl.



/* proceseaza ------------------------------------------------------------------------
	Specificatie predicat: proceseaza(+L)
	Parametrii:
		- L reprezinta o lista de atomi, despre care consideram ca este valida daca ea corespunde cuvintelor unei fraze din fisierul in care este specificata baza de cunostinte a sistemului.
	Descriere:
*/
proceseaza([end_of_file]):- !.
proceseaza(L):-
	trad(R,L,[]),% TODO: predicat nedefinit
	assertz(R),
	!.



/* trad ------------------------------------------------------------------------
	Specificatie predicat: trad(?)
	Parametrii:
	Descriere:
		Predicat folosit pentru traducerea unei fraze valide din baza de cunostinte in formatul intern al Prologului.
*/





scop::ocupatie.

creaza_director(Nume):-
	\+ exists_directory(Nume),
	make_directory(Nume).
	

/* processFile ------------------------------------------------------------------------
	Descriere: 
	Specificatie predicat: processFile(+NumeFisier) 
*/
processFile(NumeFisier).