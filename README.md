# sistem_expert_personalitate
Sistem expert care identifica pentru un om, in functie de personalitatea si pasiunile sale, cel mai potrivit domeniu in care acesta sa lucreze.

--------------------------------------------------------------------------------------------

Program prolog:

a. regulile vor avea formatul (ceea ce e scris cu gri e doar comentariu, nu face parte din format): 
selecteaza textul
rg::id
conditii={(conditiile intre acolade, atributele separate cu virgula)
    atr e egal cu valoare , (pentru atribute cu valori multiple)
    atr , (pentru atribute booleene, valoare true)
    atr[fals] (pentru atribute booleene, valoare false)
}
atunci(concluzie)
    atr e egal cu valoare fc:nr(concluzia)

b. intrebarile vor avea formatul: 
selecteaza textul
??? atribut
raspunsuri posibile: val1; val2; val3 ...
intrebare 'continut intrebare'
minim o intrebare va avea formatul: 
selecteaza textul
??? atribut !input
raspunsuri posibile: val1; val2; val3 ...
intrebare 'continut intrebare'
Acest format inseamna ca intrebarea respectiva nu va primi de la utilizator ca raspuns una dintre optiuni, ci un raspuns custom, in functie de care se va calcula, printr-un predicat definit special pentru acel atribut, optiunea ce va fi atribuita ca valoare atributului.

c. scopul se va defini: 
selecteaza textul
scop::atr

d. Programul va crea un director numit fisiere_log (daca exista, il va folosi pe acela, iar daca nu exista, il va crea), in care va exista un fisier numit log.txt, in care se vor scrie raspunsurile utilizatorului la fiecare intrebare, sub forma atr=val, unde atr e atributul corespunzator intrebarii, iar val e valoarea data ca raspuns de catre utilizator. Pentru fiecare consultare, se va adauga, la sfarsitul fisierului log.txt, o linie departitoare ("=========================="), urmata de raspunsurile la intrebari conform precizarilor de mai sus.

e. Se va scrie un predicat in prolog care sa genereze un fisier in care sa fie scrise toate valorile posibile pentru atributul scop. Acest predicat va fi apelat de predicatul care incarca fisierele de intrare (cu regulile si intrebarile) in baza de cunostinte. Numele fisierulul va avea formatul solutii_posibile_timestamp.txt, unde cuvantul timestamp va fi calculat cu ajutorul predicatului now (vezi laboratorul 5).

f. Programul, la fiecare rulare va crea un fisier numit demonstratii.txt (daca exista deja, il va sterge si-l va crea din nou). Fisierul va contine demonstratia pentru rasppunsul cu cel mai mare factor de certitudine. In demonstratie, afisarea regulilor se va face exact in forma in care au fost scrise in fisierul de intrare.: 
selecteaza textul
rg::id
conditii={(conditiile intre acolade, atributele separate cu virgula)
    atr e egal cu valoare , (pentru atribute cu valori multiple)
    atr , (pentru atribute booleene, valoare true)
    atr[fals] (pentru atribute booleene, valoare false)
}
atunci(concluzie)
    atr e egal cu valoare fc:nr(concluzia)
Forma de afisare a celorlaltor tipuri de informatii din demonstratie se lasa la alegerea studentilor.

--------------------------------------------------------------------------------------------

Urmatoarele exemple sunt doar cu titlu orientativ, nu trebuie neaparat sa puneti regulile de mai jos printre regulile sistemului expert.

Exemple de reguli :

Daca petrece mai mult de 8 ore jucandu-se la calculator si e bun la matematica si nu e lenes, atunci ocupatia potrivita pentru el este developper de jocuri pentru pc, cu factor de certitudine 60. 
selecteaza textul
rg::15
conditii={
    ore_joc_calculator_zi e egal cu 'mai mult de 8 ore' ,
    bun_la_matematica ,
    lenes[fals]
}
atunci
    ocupatie e egal cu developper_jocuri_pc fc:60
Exemple de intrebari:


selecteaza textul
??? ore_joc_calculator_zi !input
raspunsuri posibile: 'deloc'; 'intre 0 si 2 ore'; 'intre 2 si 4 ore'; 'intre 4 si 6 ore'; 'intre 6 si 8 ore'; 'mai mult de 8 ore'
intrebare 'Cate ore petrece zilnic jucand jocuri pe calculator?'

selecteaza textul
??? tip_emisiuni_tv_vizionate
raspunsuri posibile: 'documentare'; 'filme politiste'; 'videoclipuri muzicale'; 'emisiuni umoristice'; 'jurnal de stiri'; 'desene animate'
intrebare 'Ce fel de emisiuni tv vizionati?'

--------------------------------------------------------------------------------------------

Interfata grafica:

a. Initial pe interfata grafica vom avea mai multe imagini ilustrand oameni cu diverse ocupatii. Si un titlu scris in mijloc "Ce ocupatie ti se potriveste?", iar sub titlu, un buton cu textul "Afla Acum!", care va porni intrebarile.

b. Pentru intrebarile cu raspuns de tip da/nu, se va folosi un jToggleButton (implicit va fi selectat raspunsul "da" corespunzand butonului activat; buton dezactivat inseamna "nu" ), pentru celelalte tipuri de intrebari se vor folosi TextFields. Pentru factorul de certitudine al raspunsurilor, veti avea un JSlider cu minim 0 si maxim 100. Va exista un buton cu textul "OK" care va lua in considerare raspunsul dat si va trece la urmatoarea intrebare (vezi in subpunctul urmator cum anume). Trecerea la urmatoarea intrebare se face dupa ce se verifica faptul ca utilizatorul a raspuns ceva corect. Daca a dat o optiune inexistenta, sau pentru o intrebare de tip !input a raspuns cu o valoare invalida, se va afisa intr-un mesaj de tip alerta (JOptionPane.showMessageDialog(...)) un text care sa atentioneze utilizatorul, si i se va stege raspunsul din text field.

c. Intrebarile vor fi puse intr-un tabbed pane. La trecerea la o noua intrebare se va crea un nou tab. Intrebarile vechi vor putea fi accesate, dar nu si modificate (butonul "OK" va fi sters din tabul curent, atunci cand se creaza tabul cu urmatoarea intrebare).

d. La final, se vor afisa raspunsurile cu factorii de certitudine. Va exista si un checkbox in dreptul fiecaruia, care in starea de "activat" va afisa sub raspuns un TextArea cu continutul demonstratiei pentru acel raspuns. Cand e debifat, TextArea-ul va fi ascuns.
