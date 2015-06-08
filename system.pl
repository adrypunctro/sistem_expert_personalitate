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

	

/* pot_interoga ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
pot_interoga(av(Atr,_), Istorie):-
	not interogat(av(Atr, _)),
	interogabil(Atr, Optiuni, Mesaj),
	interogheaza(Atr, Mesaj, Optiuni, Istorie),
	nl,
	asserta(interogat(av(Atr,_))).


	
/* cum ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: parametrii
	Descriere: TODO: descriere
*/
cum([]):-
	write('Scop? '),
	nl,
	write('|:'),
	citeste_linie(Linie),
	nl,
	transformare(Scop, Linie),
	cum(Scop).
cum(L):-
	transformare(Scop, L),
	nl,
	cum(Scop).
cum(not Scop):-
	fapt(Scop. FC, Reguli),
	lista_float_int(Reguli, Reguli1),
	FC < -20,
	transformare(not Scop, PG),
	append(PG, [a,fost,derivat,cu,ajutorul, 'regulilor:'|Reguli1],LL),
	scrie_lista(LL),
	nl,
	afis_reguli(Reguli),
	fail.
cum(Scop):-
	fapt(Scop, FC, Reguli),
	lista_float_int(Reguli,Reguli1),
	FC > 20,
	transformare(Scop, PG),
	append(PG, [a, fost, derivat, cu, ajutorul, 'regulilor:'|Reguli1], LL),
	scrie_lista(LL),
	nl,
	afis_reguli(Reguli),
	fail.
cum(_).



/* afis_reguli ------------------------------------------------------------------------
	Specificatie predicat: incarca_reguli
	Descriere:
*/
afis_reguli([]).
afis_reguli([N|X]):-
	afis_regula(N),
	premisele(N),
	afis_reguli(X).



/* afis_regula ------------------------------------------------------------------------
	Specificatie predicat: incarca_reguli
	Descriere:
*/
afis_regula(N):-
	regula(N, premise(Lista_premise), concluzie(Scop, FC)),
	NN is integer(N),
	scrie_lista(['regula ', NN]),
	scrie_lista([' Daca ']),
	scrie_lista_premise(Lista_premise),
	scrie_lista([' Atunci']),
	transformare(Scop, Scop_tr),
	append([' '], Scop_tr, L1),
	FC1 is integer(FC),
	append(L1, [FC1], LL),
	scrie_lista(LL),
	nl.

	

/* scrie_lista_premise ------------------------------------------------------------------------
	Specificatie predicat: incarca_reguli
	Descriere:
*/
scrie_lista_premise([]).
scrie_lista_premise([H|T]):-
	transformare(H,H_tr),
	tab(5),
	scrie_lista(H_tr),
	scrie_lista_premise(T).

	
	
/* transformare ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
transformare(av(A,da),[A]):-
	!.
transformare(not av(A,da), [not,A]):-
	!.
transformare(av(A,nu),[not,A]):-
	!.
transformare(av(A,V),[A,este,V]).



/* premise ------------------------------------------------------------------------
	Specificatie predicat: premise
	Descriere:
*/
premisele(N):-
	regula(N, premise(Lista_premise), _),
	!,
	cum_premise(Lista_premise).

	
	
/* cum_premise ------------------------------------------------------------------------
	Specificatie predicat: cum_premise
	Descriere:
*/
cum_premise([]).
cum_premise([Scop|X]):-
	cum(Scop),
	cum_premise(X).

	

/* interogheaza ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
interogheaza(Atr, Mesaj, [da,nu], Istorie):-
	!,
	write(Mesaj),
	nl,
	de_la_utiliz(X, Istorie, [da, nu]),
	det_val_fc(X, Val, FC),
	asserta(fapt(av(Atr, Val), FC, [utiliz])).
interogheaza(Atr, Mesaj, Optiuni, Istorie):-
	write(Mesaj),
	nl,
	citeste_opt(VLista, Optiuni, Istorie),
	assert_fapt(Atr, VLista).

	
	
/* citeste_opt ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
citeste_opt(X, Optiuni, Istorie):-
	append(['('], Optiuni, Opt1),
	append(Opt1,[')'],Opt),
	scrie_lista(Opt),
	de_la_utiliz(X, Istorie, Optiuni).
	
	
	
/* de_la_utiliz ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
de_la_utiliz(X, Istorie, Lista_opt):-
	repeat,
	write(': '),
	citeste_linie(X),
	proceseaza_raspuns(X, Istorie, Lista_opt).

	
		
/* proceseaza_raspuns ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
proceseaza_raspuns([de_ce], Istorie, _):-
	nl,
	afis_istorie(Istorie),
	!,
	fail.
proceseaza_raspuns([X], _, Lista_opt):-
	member(X, Lista_opt).
proceseaza_raspuns([X,fc,FC], _, Lista_opt):-
	member(X, Lista_opt), float(FC).
	

	
/* assert_fapt ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
assert_fapt(Atr, [Val,fc,FC]):-
	!,
	asserta(fapt(av(Atr,Val), FC, [utiliz])).
assert_fapt(Atr, [Val]):-
	asserta(fapt(av(Atr,Val), 100, [utiliz])).
	
	
	
/* det_val_fc ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
det_val_fc([nu],da,-100).
det_val_fc([nu,FC],da,NFC):-
	NFC is -FC.
det_val_fc([nu,fc,FC],da,NFC):-
	NFC is -FC.
det_val_fc([Val,FC],Val,FC).
det_val_fc([Val,fc,FC],Val,FC).
det_val_fc([Val],Val,100).



/* afis_istorie ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
afis_istorie([]):-
	nl.
afis_istorie([scop(X)|T]):-
	scrie_lista([scop, X]),
	!,
	afis_istorie(T).
afis_istorie([N|T]):-
	afis_regula(N),
	!,
	afis_istorie(T).


	
/* demonstreaza ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
demonstreaza(N, ListaPremise, Val_finala, Istorie):-
	dem(ListaPremise, 100, Val_finala, [N|Istorie]),
	!.

	
	
/* dem ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
dem([], Val_finala, Val_finala, _).
dem([H|T], Val_actuala, Val_finala, Istorie):-
	realizare_scop(H, FC, Istorie),
	Val_interm is min(Val_actuala, FC),
	Val_interm >= 20,
	dem(T, Val_interm, Val_finala, Istorie).

	
	
/* actualizeaza ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
actualizeaza(Scop, FC_nou, FC, RegulaN):-
	fapt(Scop, FC_vechi, _),
	combina(FC_nou, FC_vechi, FC),
	retract(fapt(Scop, FC_vechi, Reguli_vechi)),
	asserta(fapt(Scop, FC, [RegulaN | Reguli_vechi])),
	!.
actualizeaza(Scop, FC, FC, RegulaN):-
	asserta(fapt(Scop, FC, [RegulaN])).

	
	
/* ajusteaza ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
ajusteaza(FC1, FC2, FC):-
	X is FC1 * FC2 / 100,
	FC is round(X).

	
	
/* combina ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
combina(FC1, FC2, FC):-
	FC1 >= 0,
	FC2 >= 0,
	X is FC2*(100-FC1)/100 + FC1,
	FC is round(X).
combina(FC1, FC2, FC):-
	FC1 < 0,
	FC2 < 0,
	X is - ( -FC1 -FC2 * (100 + FC1)/100),
	FC is round(X).
combina(FC1, FC2, FC):-
	(FC1 < 0; FC2 < 0),
	(FC1 > 0; FC2 > 0),
	FCM1 is abs(FC1), FCM2 is abs(FC2),
	MFC is min(FCM1, FCM2),
	X is 100 * (FC1 + FC2) / (100 - MFC),
	FC is round(X).

	
	
/* incarca ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
incarca:-
	write('Introduceti numele fisierului care doriti sa fie incarcat: '),
	nl,
	write('|:'),
	read(F),
	file_exists(F),
	!,
	incarca(F).
incarca:-
	write('Nume incorect de fisier! '),
	nl,
	fail.
incarca(F):-
	retractall(interogat(_)),
	retractall(fapt(_,_,_)),
	retractall(regula(_,_,_)),
	see(F),
	incarca_reguli,
	seen,
	!.


	
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
trad(scop(X)) -->
	[scopul, este, X].
trad(scop(X)) -->
	[scopul, X].
trad(interogabil(Atr,M,P)) -->
	[intreaba,Atr],
	lista_optiuni(M),
	afiseaza(Atr,P).
trad(regula(N, premise(Daca), concluzie(Atunci,F))) -->
	identificator(N),
	daca(Daca),
	atunci(Atunci,F).
trad('Eroare la parsare'-L,L,_).



