/* Librarii ------------------------------------------------------------------------
	Utilizare:
		- lists TODO: cazuri de utilizare
		- system TODO: cazuri de utilizare
*/
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(file_systems)).
:- use_module(library(sockets)).



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
:- dynamic interogabil/4.
:- dynamic regula/3.
:- dynamic config/2.



/* Operatori ------------------------------------------------------------------------
	Descriere: Definire operatori
*/
not(P):-
	P,
	!,
	fail.
not(_).



/* config_init ------------------------------------------------------------------------
	Descriere: Setarile sistemului
	Atribute:
		- root_dir este directorul din care ruleaza programul (working directory)
		- cale_fis_log este fisierul in care sunt salvate raspunsurile
		- cale_fis_dem este fisierul in care sunt salvate demonstratiile
		- cale_fis_sol este fisierul in care sunt salvate solutiile
*/
config_init:-
	assert(config(root_dir, 'C:/Users/Simionescu Adrian/Documents/Old Windows/FMI UNIBUC/CTI/anul III/Sem II/Sisteme Expert/sistem_expert_personalitate')),
	%assert(config(root_dir, 'C:/Users/Acasa/Documents/NetBeansProjects/Interfata Prolog')),
	assert(config(cale_fis_log, 'fisiere_log/log.txt')),
	assert(config(cale_fis_dem, 'fisiere_log/demonstratii.txt')),
	genereaza_fis_sol(CaleFisierSol),
	assert(config(cale_fis_sol, CaleFisierSol)).


/* pornire **************************************************************************
	Specificatie predicat: pornire
	Descriere:
		Este principalul predicat al shell-ului. Acesta determina un ciclu de executie incarcand optiunile: incarca, consulta, reinitiaza, afisare_fapte, iesire, cum.
*/
pornire:-
	config_init,
	config(root_dir, CaleFisier),
	current_directory(_, CaleFisier),% seteaza directorul de lucru
	retractall(interogat(_)),
	retractall(fapt(_,_,_)),
	repeat,
	write('Introduceti una din urmatoarele optiuni: '),
	nl, nl,
	write(' (Incarca Consulta Reinitiaza Afisare_fapte Cum Iesire) '),
	nl, nl,
	%write('|: '),
	citeste_linie([H|T]),
	executa([H|T]),
	H == iesire.

/* genereaza_fis_sol ------------------------------------------------------------------------
	Specificatie predicat: genereaza_fis_sol(-NumeFisier)
	Descriere: Genereaza nume pentru fisierul solutii
*/
genereaza_fis_sol(NumeFisier):-
	now(Time),
	number_chars(Time, TimeChars),
	atom_chars(TimeAtom, TimeChars),
    atom_concat(TimeAtom,'.txt', TimeExt),
	atom_concat('fisiere_log/solutii_posibile_', TimeExt, NumeFisier).
	
	
	
/* scrie_lista ------------------------------------------------------------------------
	Specificatie predicat: executa TODO: Parametri
	Descriere: TODO: descriere
*/
scrie_lista([]):-
	nl.
scrie_lista([H|T]):-
	write(H),
	write(' '),
	scrie_lista(T).

	

/* afiseaza_fapte ------------------------------------------------------------------------
	Specificatie predicat: executa TODO: Parametri
	Descriere: TODO: descriere
*/
afiseaza_fapte:-
	write('Fapte existente in baza de cunostinte:'),
	nl,
	nl,
	write(' (Atribut, valoare) '),
	nl,
	nl,
	listeaza_fapte,
	nl.
	
	
	
/* listeaza_fapte ------------------------------------------------------------------------
	Specificatie predicat: executa TODO: Parametri
	Descriere: TODO: descriere
*/
listeaza_fapte:-
	fapt(av(Atr,Val), FC, _),
	write('('),
	write(Atr),
	write(','),
	write(Val),
	write(')'),
	write(','),
	write(' certitudine '),
	FC1 is integer(FC),
	write(FC1),
	nl,
	fail.
listeaza_fapte.



/* lista_float_int ------------------------------------------------------------------------
	Specificatie predicat: executa TODO: Parametri
	Descriere: TODO: descriere
*/
lista_float_int([],[]).
lista_float_int([Regula|Reguli],[Regula1|Reguli1]):-
	(Regula \== utiliz,
	Regula1 is integer(Regula);
	Regula == utiliz,
	Regula1 = Regula),
	lista_float_int(Reguli, Reguli1).

	



/* executa ------------------------------------------------------------------------
	Specificatie predicat: executa(+Comanda)
	Descriere: Predicatul executa comanda primita de la utilizator.
*/
executa([incarca]):-
	incarca,
	!,
	nl,
	write('Fisierul dorit a fost incarcat'),
	nl.
executa([consulta]):-
	fisiere_log,
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
executa([iesire]):-
	!.
executa([_|_]):-
	write('Comanda incorecta! '),
	nl.

	

/* fisiere_log ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: Parametri
	Descriere: TODO: descriere
*/
fisiere_log:-
	(directory_exists('fisiere_log');
	make_directory('fisiere_log')),% creaza directorul daca nu exista
	
	config(cale_fis_log, CaleFisierLog),
	append_fisier(CaleFisierLog, '=========================='),% TODO: sa fie append la sfarsit
	
	config(cale_fis_dem, CaleFisierDem),
	resetare_fisier(CaleFisierDem)/*,
	
	config(cale_fis_sol, CaleFisierSol),
	resetare_fisier(CaleFisierSol)*/.



/* resetare_fisier ------------------------------------------------------------------------
	Specificatie predicat: resetare_fisier(+Nume)
	Descriere: Sterge continutul dintr-un fisier.
*/
resetare_fisier(Nume):-
	open(Nume,write,Fisier),
	close(Fisier).
	

	
/* resetare_fisier ------------------------------------------------------------------------
	Specificatie predicat: resetare_fisier(+Nume)
	Descriere: Sterge continutul dintr-un fisier.
*/
append_fisier(Nume, Val):-
	open(Nume,append,Fisier),
	write(Fisier, Val),
	nl(Fisier),
	close(Fisier).
	
	
/* scopuri_princ ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: Parametri
	Descriere: TODO: descriere
*/
scopuri_princ:-
	scop(Atr),
	determina(Atr),
	format('~w~N',[Atr]),
	afiseaza_scop(Atr),
	fail.
scopuri_princ.



/* determina ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: Parametri
	Descriere: TODO: descriere
*/
determina(Atr):-
	realizare_scop(av(Atr,_),_,[scop(Atr)]),
	!.
determina(_).



/* afiseaza_scop ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: Parametri
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
	Specificatie predicat: scopuri_princ TODO: Parametri
	Descriere: TODO: descriere
*/
scrie_scop(av(Atr,Val),FC):-
	transformare(av(Atr,Val), X),
	scrie_lista(X),
	write('  '),
	write(' '),
	write('factorul de certitudine este '),
	FC1 is integer(FC),
	write(FC1).

	
	
/* realizare_scop ------------------------------------------------------------------------
	Specificatie predicat: realizare_scop(+Scop,+FC,-Istorie) 
	Parametri: 
		- Scop are fie forma av(Atr,Val), fie forma not av(Atr,Val); Av este atributul despre care dorim sa aflam informatii la un moment dat si, de obicei, atunci cand acest predicat este folosit, Atr este deja instantiat.
		- FC reprezinta factorul de certitudine ce va fi asociat faptului nostru in final.
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
	Specificatie predicat: scopuri_princ TODO: Parametri
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
	Specificatie predicat: pot_interoga
	Descriere: TODO: descriere
*/
pot_interoga(av(Atr,_), Istorie):-
	not interogat(av(Atr, _)),
	interogabil(Atr, Optiuni, Mesaj, Custom),
	interogheaza(Atr, Mesaj, Optiuni, Istorie, Custom),
	nl,
	asserta(interogat(av(Atr,_))).


	
/* cum ------------------------------------------------------------------------
	Specificatie predicat: scopuri_princ TODO: Parametri
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
	fapt(Scop, FC, Reguli),
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
	write('     '),
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

	
	
/* scrie_fis_log ------------------------------------------------------------------------
	Specificatie predicat: transformare
	Descriere:
*/
scrie_fis_log(Atr, [Val|_]):-
	config(cale_fis_log, CaleFisier),
	open(CaleFisier, append, Fisier),
	write(Fisier, Atr),
	write(Fisier, '='),
	write(Fisier, Val),
	nl(Fisier),
	close(Fisier).
	
	

/* interogheaza ------------------------------------------------------------------------
	Specificatie predicat: interogheaza(+Atr, +Mesaj, +Optiuni, +Istorie, +Custom)
	Parametri:
		- Atr este identificatorul intrebarii
		- Mesajul este intrebarea
		- Optiuni este o lista cu optiunile
		- Custom este o variabila bool (val 0 sau 1) care spune daca intrebarea accepta raspuns custom
	Descriere: Predicatul interogheaza utilizatorul. Ii afiseaza intrebarea si proceseaza raspunsul.
*/
interogheaza(Atr, Mesaj, Optiuni, Istorie, 1):-% pentru intrebarea cu raspuns custom
	!,
	write(Mesaj),
	write(' CUSTOM'),
	nl,
	citeste_opt(VLista, Optiuni, Istorie, 1),% citire custom
	scrie_fis_log(Atr,VLista),% scrie raspunsul in fisierul log.txt
	assert_fapt(Atr, VLista).
interogheaza(Atr, Mesaj, [da,nu], Istorie, 0):-% pentru intrebarea cu raspuns da/nu
	!,
	write(Mesaj),
	nl,
	de_la_utiliz(X, Istorie, [da, nu], 0),
	det_val_fc(X, Val, FC),
	scrie_fis_log(Atr,X),% scrie raspunsul in fisierul log.txt
	asserta(fapt(av(Atr, Val), FC, [utiliz])).
interogheaza(Atr, Mesaj, Optiuni, Istorie, 0):-% pentru intreb. cu raspuns din optiuni
	write(Mesaj),
	nl,
	citeste_opt(VLista, Optiuni, Istorie, 0),
	scrie_fis_log(Atr,VLista),% scrie raspunsul in fisierul log.txt
	assert_fapt(Atr, VLista).

	
	
/* citeste_opt ------------------------------------------------------------------------
	Specificatie predicat: citeste_opt
	Descriere:
*/
citeste_opt(X, Optiuni, Istorie, 0):-% citire normala
	append(['('], Optiuni, Opt1),
	append(Opt1,[')'],Opt),
	scrie_lista(Opt),
	de_la_utiliz(X, Istorie, Optiuni, 0).
	
citeste_opt(X, Optiuni, Istorie, 1):-% citire custom
	de_la_utiliz(X, Istorie, Optiuni, 1).
	
	
	
/* de_la_utiliz ------------------------------------------------------------------------
	Specificatie predicat: de_la_utiliz(+X, +Istorie, +Lista_opt)
	Descriere:
*/
de_la_utiliz(X, Istorie, Lista_opt, 0):-
	repeat,
	write(': '),
	citeste_linie(X),
	proceseaza_raspuns(X, Istorie, Lista_opt).

de_la_utiliz(X, Istorie, Lista_opt, 1):-
	repeat,
	write(': '),
	citeste_linie(XCustom),
	alege_custom(XCustom, Lista_opt, X), % transformare raspuns
	X \= -1,
	proceseaza_raspuns(X, Istorie, Lista_opt).

	

/* transforma_custom ------------------------------------------------------------------------
	Specificatie predicat: transforma_custom(+Xcustom, -X)
	Descriere: Transforma raspunsul custom intr-o optiune.
*/
%TODO - verifica daca merge asta

%Pentru atomi
alege_custom([Raspuns], [HO|TO], X):-
	atom(Raspuns),
	if(Raspuns = HO,
		X = [HO],
		alege_custom([Raspuns], TO, X)).

%Pentru numere
alege_custom([Raspuns], [HO|TO], X):-
	number(Raspuns), Raspuns >= 0,
	if(Raspuns =< HO,
		X = [HO],
		alege_custom([Raspuns], TO, X)).

%Daca s-a ajuns la capatul listei fara sa gaseasca vreun raspuns care sa se potriveasca
alege_custom([Raspuns],[],-1):-
	format('Raspunsul ~w este invalid.~N',[Raspuns]).
	
/* proceseaza_raspuns ------------------------------------------------------------------------
	Specificatie predicat: proceseaza_raspuns(+Input, +Istorie, +ListaOptiuni)
	Descriere: Predicatul primeste raspunsul de la utilizator si il proceseaza.
*/
proceseaza_raspuns([de_ce], Istorie, _):-
	nl,
	afis_istorie(Istorie),
	!,
	fail.

proceseaza_raspuns([X], _, Lista_opt):-
	member(X, Lista_opt).
	
proceseaza_raspuns([X,fc,FC], _, Lista_opt):-
	format('~w ~w~N',[X, FC]),
	member(X, Lista_opt), float(FC).
	

	
/* assert_fapt ------------------------------------------------------------------------
	Specificatie predicat: assert_fapt()
	Descriere: Adauga faptele in baza de cunostinte.
*/
assert_fapt(Atr, [Val,fc,FC]):-
	!,
	asserta(fapt(av(Atr,Val), FC, [utiliz])).
assert_fapt(Atr, [Val]):-
	asserta(fapt(av(Atr,Val), 100, [utiliz])).
	
	
	
/* det_val_fc ------------------------------------------------------------------------
	Specificatie predicat: det_val_fc
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
	Specificatie predicat: afis_istorie
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
	Specificatie predicat: demonstreaza
	Descriere:
*/
demonstreaza(N, ListaPremise, Val_finala, Istorie):-
	dem(ListaPremise, 100, Val_finala, [N|Istorie]),
	!.

	
	
/* dem ------------------------------------------------------------------------
	Specificatie predicat: dem
	Descriere:
*/
dem([], Val_finala, Val_finala, _).
dem([H|T], Val_actuala, Val_finala, Istorie):-
	realizare_scop(H, FC, Istorie),
	Val_interm is min(Val_actuala, FC),
	Val_interm >= 20,
	dem(T, Val_interm, Val_finala, Istorie).

	
	
/* actualizeaza ------------------------------------------------------------------------
	Specificatie predicat: actualizeaza
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
%Daca fisierul introdus exista
incarca(F):-
	retractall(interogat(_)),
	retractall(fapt(_,_,_)),
	retractall(scop(_)),
	retractall(interogabil(_,_,_,_)),
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
	citeste_propozitie(L),
	proceseaza(L),
	L == [end_of_file],
	nl,
	cauta_solutii_posibile.% cauta valorile pentru scop

	

/* cauta_solutii_posibile ------------------------------------------------------------------------
	Specificatie predicat: cauta_solutii_posibile
	Descriere:
*/
cauta_solutii_posibile:-
	scop(Scop),
	%regula(Nr,ListaPremise,concluzie(av(Scop,Sol),_)),
	regula(_,_,concluzie(av(Scop,Sol),_)),
	scrie_fis_sol(Sol),
	fail;true.

	

/* cauta_solutii_posibile ------------------------------------------------------------------------
	Specificatie predicat: scrie_fis_sol(+Sol)
	Descriere: Adauga solutia in fisierul pentru solutii
*/
scrie_fis_sol(Sol):-
	config(cale_fis_sol, CaleFisierSol),
	open(CaleFisierSol, append, Fisier),
	write(Fisier, Sol),
	nl(Fisier),
	close(Fisier).
	

/* proceseaza ------------------------------------------------------------------------
	Specificatie predicat: proceseaza(+L)
	Parametri:
		- L reprezinta o lista de atomi, despre care consideram ca este valida daca ea corespunde cuvintelor unei fraze din fisierul in care este specificata baza de cunostinte a sistemului.
	Descriere:
*/
proceseaza([end_of_file]):- !.
proceseaza(L):-
	trad(R,L,[]),
	assertz(R),
	!.



/* trad ------------------------------------------------------------------------
	Specificatie predicat: trad(?)
	Parametri:
	Descriere:
		Predicat folosit pentru traducerea unei fraze valide din baza de cunostinte in formatul intern al Prologului.
*/
%trad(scop(X)) -->% Pentru scop
%	[scop, este, X].

trad(scop(X)) -->% Pentru scop
	[scop, ':',':',X].

trad(interogabil(Atr,M,P,1)) -->% pentru intrebari custom
	[???, Atr, '!','input'],
	lista_optiuni(M),
	afiseaza(Atr,P).

trad(interogabil(Atr,M,P,0)) -->% pentru intrebari
	[???, Atr],
	lista_optiuni(M),
	afiseaza(Atr,P).

trad(regula(N, premise(Daca), concluzie(Atunci,F))) -->% Pentru reguli
	identificator(N),
	daca(Daca),
	atunci(Atunci,F).

trad('Eroare la parsare'-L,L,_).



/* lista_optiuni ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
lista_optiuni(M) -->
	[raspunsuri,posibile,':'],
	lista_de_optiuni(M).

	
	
/* lista_de_optiuni ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
lista_de_optiuni([Element]) -->
	[Element,';'].
lista_de_optiuni([Element|T]) -->
	[Element,';'], lista_de_optiuni(T).
	
	

/* afiseaza ------------------------------------------------------------------------
	Specificatie predicat: afiseaza() TODO: de scris speficicatie
	Parametri: TODO: de scris ce fac Parametri
	Descriere: TODO: de scris descrierea
*/
afiseaza(_, P) -->
	[intrebare, P].
afiseaza(P, P) -->
	[].

	
	
/* identificator ------------------------------------------------------------------------
	Specificatie predicat: identificator(+N)
	Parametri: N - este un intreg pozitiv ce identifica in mod unic regula
	Descriere: Parseaza regula si indentificatorul ei
*/
identificator(N) -->
	[rg, ':', ':', N].

	
	
/* daca ------------------------------------------------------------------------
	Specificatie predicat: daca() TODO: de scris speficicatie
	Parametri: TODO: de scris ce fac Parametri
	Descriere: parseaza concluzia
*/
daca(Daca) -->
	[conditii,'=','{'],
	lista_premise(Daca).

	
/* lista_premise ------------------------------------------------------------------------
	Specificatie predicat: lista_premise(?)
	Parametri:
	Descriere:
*/
lista_premise([Daca]) -->
	propoz(Daca),
	[atunci].
lista_premise([Prima|Celelalte]) -->
	propoz(Prima),
	[si],
	lista_premise(Celelalte).
lista_premise([Prima|Celelalte]) -->
	propoz(Prima),
	[','],
	lista_premise(Celelalte).

	
	
/* atunci ------------------------------------------------------------------------
	Specificatie predicat: atunci(?)
	Parametri:
	Descriere:
*/
atunci(Atunci, FC) -->
	propoz(Atunci),
	[fc,':'],
	[FC].
atunci(Atunci, 100) -->
	propoz(Atunci).

	

/* propoz ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
propoz(not av(Atr, da)) -->
	[Atr, fals].% parseaza comanda Atr[fals]
propoz(av(Atr, Val)) -->
	[Atr, este, Val].
propoz(av(Atr, Val)) -->
	[Atr, e, egal, cu, Val].% parseaza comanda Atr e egal cu Val
propoz(av(Atr, da)) -->
	[Atr].

	
	
/* citeste_linie ------------------------------------------------------------------------
	Specificatie predicat: citeste_linie(-Lista cuvinte)
	Parametri: 
		- Cuv = Un cuvant citit de la tastatura
		- Lista_cuv = Restul cuvintelor
	Descriere: Citeste de la tastatura, caracter cu caracter
*/
citeste_linie([Cuv|Lista_cuv]):-
	get_code(Car),
	citeste_cuvant(Car, Cuv, Car1),
	rest_cuvinte_linie(Car1, Lista_cuv).


	
/* rest_cuvinte_linie ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere: 
*/
%Daca citeste EOF (ASCII -1), iese
rest_cuvinte_linie(-1, []):-
	!.
%Daca citeste new line (13 = carriage return, 10 = line feed), iese
rest_cuvinte_linie(Car, []):-
	(Car == 13; Car == 10),
	!.
%Altfel, citeste urmatorul cuvant recursiv
rest_cuvinte_linie(Car, [Cuv|Lista_cuv]):-
	citeste_cuvant(Car, Cuv1, Car1),
	rest_cuvinte_linie(Car1, Lista_cuv).

	

/* citeste_propozitie ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
citeste_propozitie([Cuv|Lista_cuv]):-
	get_code(Car),
	citeste_cuvant(Car, Cuv, Car1),
	rest_cuvinte_propozitie(Car1, Lista_cuv).

	
	
/* rest_cuvinte_propozitie ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
rest_cuvinte_propozitie(-1, []):-
	!.

rest_cuvinte_propozitie(Car, []):-
	Car == 46,% .
	!.

rest_cuvinte_propozitie(Car, [Cuv1|Lista_cuv]):-
	citeste_cuvant(Car, Cuv1, Car1),
	rest_cuvinte_propozitie(Car1, Lista_cuv).

	
	
/* citeste_cuvant ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/

%Daca citeste -1 (end of file), iese
citeste_cuvant(-1, end_of_file, -1):-
	!.

%Daca citeste un caracter special
citeste_cuvant(Caracter, Cuvant, Caracter1):-
	caracter_cuvant(Caracter),
	!,
	name(Cuvant, [Caracter]),
	get_code(Caracter1).

%Daca citeste o cifra
citeste_cuvant(Caracter, Numar, Caracter1):-
	caracter_numar(Caracter),
	!,
	citeste_tot_numarul(Caracter, Numar, Caracter1).
	
%39 este codul ASCII pentru ' citeste toate caracterele pana la urmatorul '
citeste_cuvant(Caracter, Cuvant, Caracter1):-
	Caracter == 39,% '
	!,
	pana_la_urmatorul_apostrof(Lista_caractere),
	L = [Caracter|Lista_caractere],
	name(Cuvant, L),
	get_code(Caracter1).
	
%Daca citeste o majuscula o transforma in lowercase
citeste_cuvant(Caracter, Cuvant, Caracter1):-
	caractere_in_interiorul_unui_cuvant(Caracter),
	!,
	((Caracter > 64, Caracter < 91),% [A-Z]
	!,
	Caracter_modificat is Caracter+32;% transforma in lowercase
	Caracter_modificat is Caracter),
	citeste_intreg_cuvantul(Caractere, Caracter1),
	name(Cuvant, [Caracter_modificat|Caractere]).
	
%Daca citeste o litera mica
citeste_cuvant(_, Cuvant, Caracter1):-
	get_code(Caracter),
	citeste_cuvant(Caracter, Cuvant, Caracter1).
	
/* citeste_tot_numarul ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/	
citeste_tot_numarul(Caracter, Numar, Caracter1):-
	determina_lista(Lista1, Caracter1),
	append([Caracter], Lista1, Lista),
	transforma_lista_numar(Lista, Numar).
	
	
	
/* determina_lista ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
determina_lista(Lista, Caracter1):-
	get_code(Caracter),
	(caracter_numar(Caracter),
	determina_lista(Lista1, Caracter1),
	append([Caracter], Lista1, Lista);
	\+(caracter_numar(Caracter)),
	Lista = [],
	Caracter1 = Caracter).
	

	
/* transforma_lista_numar ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
transforma_lista_numar([], 0).
transforma_lista_numar([H|T], N):-
	transforma_lista_numar(T, NN),
	lungime(T, L),
	Aux is exp(10, L),
	HH is H-48,
	N is HH*Aux+NN.

	

/* lungime ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
lungime([],0).
lungime([_|T],L):-
	lungime(T,L1),
	L is L1+1.	
	
	
	
/* pana_la_urmatorul_apostrof ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
pana_la_urmatorul_apostrof(Lista_caractere):-
	get_code(Caracter),
	(Caracter == 39,% '
	Lista_caractere=[Caracter];
	Caracter \== 39,% '
	pana_la_urmatorul_apostrof(Lista_caractere1),
	Lista_caractere=[Caracter|Lista_caractere1]).
	
	
	
/* citeste_intreg_cuvantul ------------------------------------------------------------------------
	Specificatie predicat: citeste_intreg_cuvantul(?)
	Parametri:
	Descriere:
*/
citeste_intreg_cuvantul(Lista_Caractere, Caracter1):-
	get_code(Caracter),
	(caractere_in_interiorul_unui_cuvant(Caracter),
	((Caracter > 64, Caracter < 91),
	!,
	Caracter_modificat is Caracter+32;
	Caracter_modificat is Caracter),
	citeste_intreg_cuvantul(Lista_Caractere1, Caracter1),
	Lista_Caractere = [Caracter_modificat|Lista_Caractere1];
	\+(caractere_in_interiorul_unui_cuvant(Caracter)),
	Lista_Caractere=[],
	Caracter1=Caracter).

	
	
/* caracter_cuvant ------------------------------------------------------------------------
	Specificatie predicat: caracter_cuvant(+Caracter)
	Parametri:
		- Caracter = Raspunsul la verificarea daca C face parte din lista de caractere valide
	Descriere: am specificat codurile ASCII pentru , . ) ( = { ; : !
*/
caracter_cuvant(C):-
	member(C, [44, 46, 41, 40, 61, 123, 59, 58, 33]).
	

	
/* caractere_in_interiorul_unui_cuvant ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere:
*/
caractere_in_interiorul_unui_cuvant(C):-
	C > 64, C < 91;% [A-Z]
	C > 47, C < 58;% [0-9]
	C == 45;% -
	C == 95;% _
	C == 63;% ?
	C > 96, C < 123.% [a-z]

	
	
/* caracter_numar ------------------------------------------------------------------------
	Specificatie predicat: lista_optiuni(?)
	Parametri:
	Descriere: interval [0-9]
*/
caracter_numar(C):-
	C >= 48, C < 58.
	
	
	
/* pornire_app **************************************************************************
	Specificatie predicat: pornire_app
	Descriere: Folosit de catre aplicatia java.
*/
pornire_app:-
	prolog_flag(argv, [PortSocket|_]),
	atom_chars(PortSocket,LCifre),
	number_chars(Port,LCifre),
	socket_client_open(localhost: Port, Stream, [type(text)]),
	proceseaza_text_primit(Stream,0).
	
% -------------------------------------------------------------------------------
proceseaza_text_primit(Stream,C):-
	read(Stream,CevaCitit),
	proceseaza_termen_citit(Stream,CevaCitit,C).


% -------------------------------------------------------------------------------
proceseaza_termen_citit(Stream,pornire,C):-
	pornire,
	write(Stream,'Program pornit!\n'),
	flush_output(Stream),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).

proceseaza_termen_citit(Stream,incarca,C):-
	executa([incarca]),
	
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).

proceseaza_termen_citit(Stream,File,C):-
	executa([incarca]),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).

proceseaza_termen_citit(Stream,consulta,C):-
	executa([consulta]),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).
