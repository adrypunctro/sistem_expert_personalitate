package interfata.prolog;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.io.PrintStream;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExpeditorMesaje extends Thread {
    //Creaza instante pentru chestiile necesare
    Socket socket;
    CititorMesaje cititorM;
    volatile PipedOutputStream pOS = null;
    PipedInputStream pIS;
    OutputStream outputS;
    volatile boolean gata = false;
    
    //Setteri sincronizati
    public final synchronized void setPipedOutputStream(PipedOutputStream setPOS) {
        pOS = setPOS;
        notify();
    }
    
    //Getteri sincronizati
    public synchronized PipedOutputStream getPipedOutputStream() throws InterruptedException {
        if (pOS == null) {
            wait();
        }
        return pOS;
    }
    
    //Constructor, initializeaza valorile pentru expeditor
    public ExpeditorMesaje (CititorMesaje setCM) throws IOException {
        cititorM = setCM;
        pIS = new PipedInputStream();
        setPipedOutputStream(new PipedOutputStream(pIS));
    }
    
    //TODO
    public void trimiteMesajSicstus(String mesaj) throws InterruptedException {
        PipedOutputStream pOS = getPipedOutputStream();
        PrintStream printS = new PrintStream (pOS);
        printS.println(mesaj + ".");
        printS.flush();
        System.err.println(mesaj);
    }
    
    public void trimiteMesajSicstus(String mesaj, boolean sufix) throws InterruptedException {
        PipedOutputStream pOS = getPipedOutputStream();
        PrintStream printS = new PrintStream (pOS);
        printS.println(mesaj);
        printS.flush();
        System.err.println(mesaj);
    }
    
    @Override
    public void run() {
        try {
            socket = cititorM.getSocket();
            outputS = socket.getOutputStream();
            int chr;
            //Cat timp poate citi caractere, scrie in fluxul de output
            while ((chr = pIS.read()) != -1) {
                outputS.write(chr);
            }//End while
        }//End try
        catch (IOException | InterruptedException ex) {
            Logger.getLogger(ExpeditorMesaje.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//End run
}
