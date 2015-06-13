package interfata.prolog;

import java.io.IOException;
import java.io.InputStream;
import java.io.PipedOutputStream;
import java.io.PrintStream;
import java.net.ServerSocket;

public class ConexiuneProlog
{
    //Cale catre executabilul Sicstus
    final String executabilSicstus = "C:\\Users\\Simionescu Adrian\\Documents\\Old Windows\\FMI UNIBUC\\CTI\\anul III\\Sem II\\Sisteme Expert\\Sicstus\\SICStus Prolog 4.0.2\\bin\\spwin.exe";
    //Cale catre fisierul prolog parsor
    final String numeFisier = "system.pl";
    //Predicatul principal al fisierului prolog – cel care porneste comunicarea din partea cealalta
    final String scop = "pornire_app.";
    
    //Instantiaza obiecte de tip proces si pentru interactionarea cu Sicstus
    Process procesSicstus;
    CititorMesaje cititor;
    ExpeditorMesaje expeditor;
    //Instantiaza interfata si portul pentru conexiune
    MainPannel interfata;
    int port;
    
    //Returneaza interfata
    public MainPannel getInterfata() { return interfata;}
    
    public ConexiuneProlog(int setPort, MainPannel setInterfata) throws IOException, InterruptedException
    {
        //Seteaza valoarea pentru port si interfata, si creaza doua fluxuri de date de intrare
        InputStream processIs, processStreamErr;
        port = setPort;
        interfata = setInterfata;
        
        //Creaza si porneste un socket si thread-urile pentru cititorul si expeditorul de mesaje
        ServerSocket servS = new ServerSocket(port);
        cititor=new CititorMesaje(this,servS); cititor.start();
        expeditor=new ExpeditorMesaje(cititor); expeditor.start();
        
        Runtime rtime= Runtime.getRuntime();
        /*Parametri pentru rularea Sicstus
        ● -f pornire rapida (fara citirea fisierului de initializare)
        ● -l fisier_prolog incarca acest fisier prolog direct la pornire (voi veti pune fisierul prolog cu sistemul expert)
        ● --goal scop (unde scop e predicatul pe care vrem sa il apelam initial)
        ● -a lista_argumente (alte argumente pe care prologul le poate obtine cu ajutorul predicatului prolog_flag(argv, ListaArgumente))
        */
        String comanda=executabilSicstus+" -f -l "+numeFisier+" --goal "+scop+" -a "+port;
        //Executa spwin.exe
        procesSicstus = rtime.exec(comanda);
        
        //Fluxurile de input din care citim intrarea si erorile
        processIs=procesSicstus.getInputStream();
        processStreamErr=procesSicstus.getErrorStream();
    }
    
    
    //Functie apelata in InterfataProlog atunci cand se inchide fereastra
    void opresteProlog() throws InterruptedException
    {
        PipedOutputStream pos= this.expeditor.getPipedOutputStream();
        PrintStream ps=new PrintStream(pos);
        ps.println("iesire.");
        ps.flush();
    }
}
