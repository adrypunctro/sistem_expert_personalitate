:-use_module(library(sockets)).

inceput:-
	prolog_flag(argv, [PortSocket|_]), %preiau numarul portului, dat ca argument cu -a
	%portul este atom, nu constanta numerica, asa ca trebuie sa il convertim la numar
	atom_chars(PortSocket,LCifre),
	number_chars(Port,LCifre),%transforma lista de cifre in numarul din
	socket_client_open(localhost: Port, Stream, [type(text)]),
	proceseaza_text_primit(Stream,0).

	
% -------------------------------------------------------------------------------
proceseaza_text_primit(Stream,C):-
	read(Stream,CevaCitit),
	proceseaza_termen_citit(Stream,CevaCitit,C).


% -------------------------------------------------------------------------------
proceseaza_termen_citit(Stream,pornire,C):-
	write(Stream,'scrie o comanda...\n'),
	flush_output(Stream),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream,incarca,C):-
	write(Stream,'scrie numele fisierului...\n'),
	flush_output(Stream),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream,consulta,C):-
	write(Stream,'intrebarea este:... scrie raspunsul...\n'),
	flush_output(Stream),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream, X, _):-
	(X == end_of_file ; X == exit),
	close(Stream).
proceseaza_termen_citit(Stream, Altceva,C):-
	write(Stream,'rezultat: Programator IT'),write(Stream,Altceva),nl(Stream),
	flush_output(Stream),
	C1 is C+1,
	proceseaza_text_primit(Stream,C1).