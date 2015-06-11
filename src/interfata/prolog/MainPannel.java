package interfata.prolog;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import static java.lang.Math.pow;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.beans.value.ChangeListener;
import javax.imageio.ImageIO;
import javax.swing.AbstractButton;
import javax.swing.ButtonModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.event.ChangeEvent;

public class MainPannel
{
    // -------------------------------------------------------------------------
    final int USER_RESOLUTION_W = 1600;
    final int USER_RESOLUTION_H = 900;
    final int MAIN_PANNEL_W = 1066;
    final int MAIN_PANNEL_H = 600;
    
    private ConexiuneProlog cxp;
    private JFrame mainFrame;
    private JLabel headerLabel;
    private JLabel statusLabel;
    private JPanel controlPanel;
    private JLabel msglabel;
    //Portul prin care se face legatura cu programul
    static final int PORT = 9876;
    
    // incarca consulta reinitiaza afiseaza cum iesire
    private MyJButton[] bar_buts = new MyJButton[7];// incarca
    
    // -------------------------------------------------------------------------
    public MainPannel()
    {
        try {
            prepareGUI();
        } catch (IOException ex) {
            Logger.getLogger(MainPannel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    
    // -------------------------------------------------------------------------
    public static void main(String[] args)
    {
        MainPannel mainPannel = new MainPannel();
        mainPannel.conProlog();
        mainPannel.show();
    }
    
    private void conProlog()
    {
        try
        {
            //Initializeaza conexiunea cu portul si o referinta la mainFrame grafica
            cxp = new ConexiuneProlog(PORT, this);
            //setConexiune(cxp); //Face legatura intre ferestra si conexiune
            //mainPannel.setVisible(true);  //Face ferestra vizibila
        }
        catch (IOException ex) {
            Logger.getLogger(MainPannel.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Eroare clasa initiala");
        } 
        catch (InterruptedException ex) {
            Logger.getLogger(MainPannel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    // -------------------------------------------------------------------------
    private void prepareGUI() throws IOException
    {
        // LOGO ----------------------------------------------------------------
        ImageIcon image_logo = new ImageIcon("src\\resources\\logo.png");
        Image image_src = image_logo.getImage(); // transform it 
        Image newimg = image_src.getScaledInstance(80, 80,  java.awt.Image.SCALE_SMOOTH); // scale it the smooth way  
        image_logo = new ImageIcon(newimg);  // transform it back
        JLabel logo = new JLabel("", image_logo, JLabel.LEFT);
        
        // HEADER BACKGROUND ---------------------------------------------------
        final Image image = ImageIO.read(new File("src\\resources\\pannel_bg.png"));
        JPanel imagePanel = new ImagePanel(image, 80);
        imagePanel.setLayout(new BorderLayout());
        imagePanel.add( logo, BorderLayout.NORTH );
        
         // BUTTONS -------------------------------------------------------------
        bar_buts[0] = new MyJButton("Porneste");
        bar_buts[1] = new MyJButton("Incarca");
        bar_buts[2] = new MyJButton("Consulta");
        bar_buts[3] = new MyJButton("Reinitiaza");
        bar_buts[4] = new MyJButton("Afiseaza");
        bar_buts[5] = new MyJButton("Cum");
        bar_buts[6] = new MyJButton("Iesire");
        
        for(int i=0; i<7; ++i)
        {
            bar_buts[i].setVerticalTextPosition(AbstractButton.CENTER);
            bar_buts[i].setHorizontalTextPosition(AbstractButton.LEADING); //aka LEFT, for left-to-right locales
            bar_buts[i].setMnemonic(KeyEvent.VK_D);
            bar_buts[i].setActionCommand("disable");
            bar_buts[i].setEnabled(false);
        }
        bar_buts[0].setEnabled(true);

        // HEADER BACKGROUND 2 ---------------------------------------------------
        final Image image2 = ImageIO.read(new File("src\\resources\\pannel_bg2.png"));
        JPanel imagePanel2 = new ImagePanel(image2, 50);
        imagePanel2.setLayout(null);
        
        {
            int cLeft = 10;
            int width = 100;
            int height = 27;
            int margin = 10;
            for(int i=0; i<7; ++i)
            {
                imagePanel2.add(bar_buts[i]);
                bar_buts[i].setBounds(cLeft, 4, width, height);
                cLeft += width + margin;
            }
        }
        
        // HEADER BODY ---------------------------------------------------
        final Image image3 = ImageIO.read(new File("src\\resources\\what.png"));
        JPanel imagePanel3 = new ImagePanel(image3, 0);
        imagePanel3.setLayout(new BorderLayout());
        
        
        // ---------------------------------------------------------------------
        mainFrame = new JFrame("Sistem Expert - Orientare in cariera");
        mainFrame.setLocation((int)(USER_RESOLUTION_W-MAIN_PANNEL_W)/2, (int)(USER_RESOLUTION_H-MAIN_PANNEL_H)/2);
        mainFrame.setSize(MAIN_PANNEL_W,MAIN_PANNEL_H);
        mainFrame.setLayout(null);
        
        mainFrame.add(imagePanel);
        imagePanel.setBounds(0, 0, MAIN_PANNEL_W, 80);
        
        mainFrame.add(imagePanel2);
        imagePanel2.setBounds(0, 80, MAIN_PANNEL_W, 50);
        
        mainFrame.add(imagePanel3);
        imagePanel3.setBounds(0, 130, MAIN_PANNEL_W, MAIN_PANNEL_H-130);

        headerLabel = new JLabel("", JLabel.CENTER);        
        statusLabel = new JLabel("",JLabel.CENTER);    

        statusLabel.setSize(350,100);

        msglabel = new JLabel("Welcome to TutorialsPoint SWING Tutorial.", JLabel.CENTER);

        controlPanel = new JPanel();
        controlPanel.setLayout(new FlowLayout());

        mainFrame.add(headerLabel);
        mainFrame.add(controlPanel);
        mainFrame.add(statusLabel);
        mainFrame.setVisible(true);  
        
        
        // Consulta ------------------------------------------------------------
        bar_buts[0].addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                bar_buts[0].setSelected(!bar_buts[0].isSelected());
                System.out.println("selecting incarca");
            }
        });
        
        // Consulta ------------------------------------------------------------
        bar_buts[1].addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                bar_buts[1].setSelected(!bar_buts[1].isSelected());
                System.out.println("selecting consulta");
            }
        });
        
        //cxp.cititor.run();

        mainFrame.addWindowListener(new WindowAdapter() {
           @Override
           public void windowClosing(WindowEvent windowEvent)
           {
               try {
                   //Inchide conexiunea la Prolog
                   cxp.opresteProlog();
                   cxp.expeditor.gata=true;
                   
                   // inchide sistemul
                   System.exit(0);
               } catch (InterruptedException ex) {
                   Logger.getLogger(MainPannel.class.getName()).log(Level.SEVERE, null, ex);
               }
           }
        });   
    }

    
    
    // -------------------------------------------------------------------------
    private void show()
    {
        headerLabel.setText("Container in action: JPanel");      

        JPanel panel = new JPanel();
        panel.setBackground(Color.magenta);
        panel.setLayout(new FlowLayout());        
        panel.add(msglabel);

        controlPanel.add(panel);        
        mainFrame.setVisible(true);      
    }   
    
}