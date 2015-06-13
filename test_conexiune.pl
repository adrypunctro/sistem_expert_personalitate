:-use_module(library(sockets)).

inceput:-
	prolog_flag(argv, [PortSocket|_]), %preiau numarul portului, dat ca argument cu -a
	%portul este atom, nu constanta numerica, asa ca trebuie sa il convertim la numar
	atom_chars(PortSocket,LCifre),
	number_chars(Port,LCifre),%transforma lista de cifre in numarul din
	socket_client_open(localhost: Port, Stream, [type(text)]),
	set_input(Stream),
	set_output(Stream),
	proceseaza_text_primit(0).

	
% -------------------------------------------------------------------------------
proceseaza_text_primit(C):-
	read(CevaCitit),
	proceseaza_termen_citit(CevaCitit,C).


% -------------------------------------------------------------------------------
proceseaza_termen_citit(pornire,C):-
	write('scrie o comanda...\n'),
	flush_output,
	C1 is C+1,
	proceseaza_text_primit(C1).
proceseaza_termen_citit(incarca,C):-
	write('scrie numele fisierului...\n'),
	flush_output,
	C1 is C+1,
	proceseaza_text_primit(C1).
proceseaza_termen_citit(consulta,C):-
	write('intrebarea este:... scrie raspunsul...\n'),
	flush_output,
	C1 is C+1,
	proceseaza_text_primit(C1).
proceseaza_termen_citit(X, _):-
	(X == end_of_file ; X == exit),
	close.
proceseaza_termen_citit(Altceva,C):-
	write('rezultat: Programator IT'),write(Altceva),nl,
	flush_output,
	C1 is C+1,
	proceseaza_text_primit(C1).