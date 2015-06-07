package interfata.prolog;

import java.io.IOException;
import java.io.PipedInputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class CititorMesaje {
    //Creaza instante pentru chestiile necesare
    ServerSocket servS;
    volatile Socket socket = null; //Volatile ca sa fie protejat la accesul concurent al mai multor threaduri
    volatile PipedInputStream pIS = null;
    ConexiuneProlog conexiune;
    
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
    
    //Constructor, initializeaza valorile
    public CititorMesaje(ConexiuneProlog setConexiune, ServerSocket setServS) throws IOException {
        servS = setServS;
        conexiune = setConexiune;
    }
    
    TODO
}
