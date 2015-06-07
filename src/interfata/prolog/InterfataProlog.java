package interfata.prolog;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InterfataProlog {
    //Portul prin care se face legatura cu programul
    static final int PORT = 9876;
    
    public static void main(String[] args) {
        
        //Creaza o instanta a clasei ConexiuneProlog
        ConexiuneProlog cxp;
        
        try {
            //Creaza interfata
            final GUI interfata = new GUI("Interfata Prolog");

            //Initializeaza conexiunea cu portul si o referinta la interfata grafica
            cxp = new ConexiuneProlog(PORT, interfata);
            interfata.setConexiune(cxp); //Face legatura intre ferestra si conexiune
            interfata.setVisible(true);  //Face ferestra vizibila

            //Adauga un WindowAdapter care primeste evenimente de la ferestra
            interfata.addWindowListener(new WindowAdapter() {
                //Adauga un event listener pentru inchiderea ferestrei
                public void windowClosing(WindowEvent e) {
                        try {
                            //Inchide conexiunea la Prolog
                            interfata.conexiune.opresteProlog();                        
                            interfata.conexiune.expeditor.gata=true;
                        } 
                        catch (InterruptedException ex) {
                            Logger.getLogger(InterfataProlog.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                });
        }
        catch (IOException ex) {
            Logger.getLogger(InterfataProlog.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Eroare clasa initiala");
        } 
        catch (InterruptedException ex) {
            Logger.getLogger(InterfataProlog.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
