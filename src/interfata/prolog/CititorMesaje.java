package interfata.prolog;

import java.io.IOException;
import java.io.InputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.SwingUtilities;

public class CititorMesaje extends Thread {
    //Creaza instante pentru chestiile necesare
    ServerSocket servS;
    volatile Socket socket = null; //Volatile ca sa fie protejat la accesul concurent al mai multor threaduri
    volatile PipedInputStream pIS = null;
    ConexiuneProlog conexiune;
    private boolean rezultat = false;
    
    //Setteri sincronizati
    public synchronized void setSocket(Socket setS) {
        socket = setS;
        notify();   //Anunta thread-ul ca s-a intamplat ceva
    }
    
    public synchronized void setPipedInputStream(PipedInputStream setPIS) {
        pIS = setPIS;
        notify();   //Anunta thread-ul ca s-a intamplat ceva
    }
    
    //Getteri sincronizati
    public synchronized Socket getSocket() throws InterruptedException {
        if (socket == null) {
            wait(); //Asteapta pana cand este setat un socket
        }
        return socket;
    }
    
    public synchronized PipedInputStream getPipedInputStream() throws InterruptedException {
        if (pIS == null) {
            wait(); //Asteapta pana cand este setat un flux
        }
        return pIS;
    }
    
    //Constructor, initializeaza valorile pentru cititor
    public CititorMesaje(ConexiuneProlog setConexiune, ServerSocket setServS) throws IOException {
        servS = setServS;
        conexiune = setConexiune;
    }
    
    @Override
    public void run() {
        try {
            //Apel blocant, asteapta conexiunea. Conexiunea clinetului se face din prolog
            Socket sAux = servS.accept();
            setSocket(sAux);
            
            //Se pregateste InputStream-ul pentru a citi date de la socket
            InputStream inputS = sAux.getInputStream();
            
            //Se leaga un PipedInputStream de capatul in care se scrie
            PipedOutputStream pOS = new PipedOutputStream();
            setPipedInputStream(new PipedInputStream(pOS));
            
            //Se creaza variabilele necesare pentru citire
            int chr;
            String str = "";
            
            //Citeste date pana la end of file (EOF)
            while ((chr = inputS.read()) != -1) {
                //Se pun in pipe datele citite de la Prolog
                pOS.write(chr);
                str += (char)chr;
                
                //Daca s-a citit capatul randului, se creaza un sir cu tot continutul
                if (chr == '\n') {
                    final String sirDeScris = str;
                    //Se reseteaza sirul initial
                    str = "";
                    SwingUtilities.invokeLater(new Runnable() {
                        @Override
                        public void run() {
                            //Afiseaza textul citit in campul din interfata
                            //TODO conexiune.getInterfata().getDebugTextArea().append(sirDeScris);
                            //conexiune.getInterfata().
                            
                            System.out.print("<<");
                            System.out.print(sirDeScris);
                            System.out.println(">>");
                            
                            if(sirDeScris.startsWith("rezultat:"))
                            {
                                conexiune.getInterfata().afis_rez(sirDeScris);
                                rezultat = true;
                            }
                            
                            if(rezultat)
                            {
                                System.err.print("+"+sirDeScris);
                            }
                            
                            if(sirDeScris.startsWith("end rezultat"))
                            {
                                rezultat = false;
                            }
                           
                            if(sirDeScris.startsWith("I:"))
                            {
                                String lines[] = sirDeScris.split("\\'");
                                String intrebare = lines[1];
                                lines[2] = lines[2].replace('(', ' ');
                                lines[2] = lines[2].replace(')', ' ');
                                lines[2] = lines[2].trim();
                                String optiuni = lines[2].replace(' ', ',');
                                
                                conexiune.interfata.tabbedPane.newTab(intrebare, optiuni, 1);
                                conexiune.interfata.tabbedPane.gotoTab(conexiune.interfata.tabbedPane.currentNr);
                            }
                            
                            if(sirDeScris.startsWith("IC:"))
                            {
                                String lines[] = sirDeScris.split("\\'");
                                String intrebare = lines[1];
                                lines[2] = lines[2].replace('(', ' ');
                                lines[2] = lines[2].replace(')', ' ');
                                lines[2] = lines[2].trim();
                                String optiuni = lines[2].replace(' ', ',');
                                
                                conexiune.interfata.tabbedPane.newTab(intrebare, optiuni, 1);
                                conexiune.interfata.tabbedPane.gotoTab(conexiune.interfata.tabbedPane.currentNr);
                            }
                            
                            if(sirDeScris.startsWith("IB:"))
                            {
                                String lines[] = sirDeScris.split("\\'");
                                String intrebare = lines[1];
                                
                                conexiune.interfata.tabbedPane.newTab(intrebare, "da,nu", 2);
                                conexiune.interfata.tabbedPane.gotoTab(conexiune.interfata.tabbedPane.currentNr);
                            }
                            
                        }
                    }); //End SwingUtilities..
                }//End if
            }//End while
        }//End try
        catch (IOException ex) {
            Logger.getLogger(CititorMesaje.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
