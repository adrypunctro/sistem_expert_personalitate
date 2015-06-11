package interfata.prolog;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
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
import java.io.PipedOutputStream;
import java.io.PrintStream;
import static java.lang.Math.pow;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.beans.value.ChangeListener;
import javax.imageio.ImageIO;
import javax.swing.AbstractButton;
import javax.swing.BorderFactory;
import javax.swing.ButtonModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;
import javax.swing.border.Border;
import javax.swing.event.ChangeEvent;

public class MainPannel
{
    // -------------------------------------------------------------------------
    final int USER_RESOLUTION_W = 1600;
    final int USER_RESOLUTION_H = 900;
    final int MAIN_PANNEL_W = 1066;
    final int MAIN_PANNEL_H = 600;
    
    public ConexiuneProlog cxp;
    public JFrame mainFrame;
    private JLabel headerLabel;
    private JLabel statusLabel;
    private JPanel controlPanel;
    private JLabel msglabel;
    
    private JPanel imagePanel1;
    private JPanel imagePanel2;
    private JPanel imagePanel3;// intro
    private JPanel imagePanel4;// consultatii
    private JPanel imagePanel5;// rezultat
    
    MyTabbedPane tabbedPane;// tabed pane
    
    //Portul prin care se face legatura cu programul
    static final int PORT = 9876;
    
    // incarca consulta reinitiaza afiseaza cum iesire
    private MyJButton[] bar_buts = new MyJButton[7];
    private boolean[] show_bt;
    
    private JButton startButton = new JButton("Incepe acum");
    
    JLabel label_rezultat = new JLabel("Ocupatii recomandate", SwingConstants.CENTER);
    
    JProgressBar[] progress = new JProgressBar[32];
    JLabel[] progress_label = new JLabel[32];
    JCheckBox[] check = new JCheckBox[32];
    JTextArea textArea = new JTextArea();
    
    
    // -------------------------------------------------------------------------
    public MainPannel()
    {
        // Se stabileste conexiunea cu Prolog
        conProlog();
        
        // Se pregateste interfata grafica
        try {
            prepareGUI();
        } catch (IOException ex) {
            Logger.getLogger(MainPannel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    // -------------------------------------------------------------------------
    public void afis_rez(String rez)
    {
        imagePanel4.setVisible(false);
        imagePanel5.setVisible(true);
        //label_rezultat.setText(rez);
        bar_buts[2].setEnabled(false);
        show_bt[2] = false;
        bar_buts[3].setEnabled(true);
        show_bt[3] = true;
        bar_buts[4].setEnabled(true);
        show_bt[4] = true;
        bar_buts[5].setEnabled(true);
        show_bt[5] = true;
    }
    
    
    // -------------------------------------------------------------------------
    public static void main(String[] args)
    {
        MainPannel mainPannel = new MainPannel();
        
        mainPannel.show();
    }
    
    private void conProlog()
    {
        try
        {
            //Initializeaza conexiunea cu portul si o referinta la mainFrame grafica
            cxp = new ConexiuneProlog(PORT, this);
            //setConexiune(cxp); //Face legatura intre ferestra si conexiune
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
        imagePanel1 = new ImagePanel(image, 80);
        imagePanel1.setLayout(new BorderLayout());
        imagePanel1.add( logo, BorderLayout.NORTH );
        
         // BUTTONS ------------------------------------------------------------
        bar_buts[0] = new MyJButton("Pornire");
        bar_buts[1] = new MyJButton("Incarca");
        bar_buts[2] = new MyJButton("Consulta");
        bar_buts[3] = new MyJButton("Reinitiaza");
        bar_buts[4] = new MyJButton("Afiseaza");
        bar_buts[5] = new MyJButton("Cum");
        bar_buts[6] = new MyJButton("Iesire");
        
        show_bt = new boolean[7];
        for(int i=0; i<7; ++i)
        {
            bar_buts[i].setVerticalTextPosition(AbstractButton.CENTER);
            bar_buts[i].setHorizontalTextPosition(AbstractButton.LEADING); //aka LEFT, for left-to-right locales
            bar_buts[i].setMnemonic(KeyEvent.VK_D);
            bar_buts[i].setActionCommand("disable");
            bar_buts[i].setEnabled(false);
            show_bt[i] = false;
        }
        bar_buts[0].setEnabled(true);
        show_bt[0] = true;

        // HEADER BACKGROUND 2 ---------------------------------------------------
        final Image image2 = ImageIO.read(new File("src\\resources\\pannel_bg2.png"));
        imagePanel2 = new ImagePanel(image2, 50);
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
        
        
        startButton.setVerticalTextPosition(AbstractButton.CENTER);
        startButton.setHorizontalTextPosition(AbstractButton.LEADING); //aka LEFT, for left-to-right locales
        startButton.setMnemonic(KeyEvent.VK_D);
        startButton.setActionCommand("disable");
        startButton.setEnabled(false);
        
        
        // HEADER BODY INTRO ---------------------------------------------------
        final Image image3 = ImageIO.read(new File("src\\resources\\what.png"));
        imagePanel3 = new ImagePanel(image3, 0);
        imagePanel3.setLayout(null);
        
        imagePanel3.add(startButton);
        startButton.setBounds(80, 170, 200, 50);
        
        tabbedPane = new MyTabbedPane(this, MAIN_PANNEL_W, MAIN_PANNEL_H-130);// tabed pane
        JLabel label_consulting = new JLabel("Răspundeţi la întrebări", SwingConstants.CENTER);
        label_consulting.setFont(new Font("Default", Font.BOLD, 30));
        
        // HEADER BODY CONSULTATII ---------------------------------------------------
        final Image image4 = ImageIO.read(new File("src\\resources\\pannel_bg3.png"));
        imagePanel4 = new ImagePanel(image4, 0);
        imagePanel4.setLayout(null);
        imagePanel4.setVisible(false);
        
        imagePanel4.add(label_consulting);
        label_consulting.setBounds(0, 0, MAIN_PANNEL_W, 100);
        
        imagePanel4.add(tabbedPane);
        tabbedPane.setBounds(0, 100, MAIN_PANNEL_W, MAIN_PANNEL_H-100);
        
        
        
        label_rezultat.setFont(new Font("Default", Font.BOLD, 30));
        
        for(int i=0; i<5; ++i)
        {
            progress[i] = new JProgressBar(0, 100);
            progress[i].setValue(55);
            progress[i].setStringPainted(true);
            progress_label[i] = new JLabel("Ocupatie "+i);
            progress_label[i].setFont(new Font("Default", Font.PLAIN, 13));
            check[i] = new JCheckBox("CT scan performed");
        }
        Border border = BorderFactory.createLineBorder(Color.LIGHT_GRAY);
        textArea.setBorder(BorderFactory.createCompoundBorder(border, BorderFactory.createEmptyBorder(10, 10, 10, 10)));
        textArea.setEditable(false);
        textArea.setBackground(new Color(230, 230, 230));
        
        // HEADER BODY REZULTAT ---------------------------------------------------
        final Image image5 = ImageIO.read(new File("src\\resources\\pannel_bg3.png"));
        imagePanel5 = new ImagePanel(image5, 0);
        imagePanel5.setLayout(null);
        imagePanel5.setVisible(false);
        
        imagePanel5.add(label_rezultat);
        label_rezultat.setBounds(0, 0, MAIN_PANNEL_W, 100);
        for(int i=0; i<5; ++i)
        {
            imagePanel5.add(progress[i]);
            progress[i].setBounds(380, (i*28)+100, 60, 20);
            imagePanel5.add(progress_label[i]);
            progress_label[i].setBounds(460, (i*28)+100, 200, 20);
            imagePanel5.add(check[i]);
            check[i].setBounds(670, (i*28)+100, 20, 20);
        }
        imagePanel5.add(textArea);
        textArea.setBounds(720, 100, MAIN_PANNEL_W-760, 200);
        
        
        // ---------------------------------------------------------------------
        mainFrame = new JFrame("Sistem Expert - Orientare in cariera");
        mainFrame.setLocation((int)(USER_RESOLUTION_W-MAIN_PANNEL_W)/2, (int)(USER_RESOLUTION_H-MAIN_PANNEL_H)/2);
        mainFrame.setSize(MAIN_PANNEL_W,MAIN_PANNEL_H);
        mainFrame.setLayout(null);
        mainFrame.setVisible(true);
        
        mainFrame.add(imagePanel1);
        imagePanel1.setBounds(0, 0, MAIN_PANNEL_W, 80);
        
        mainFrame.add(imagePanel2);
        imagePanel2.setBounds(0, 80, MAIN_PANNEL_W, 50);
        
        mainFrame.add(imagePanel3);
        imagePanel3.setBounds(0, 130, MAIN_PANNEL_W, MAIN_PANNEL_H-130);
        
        mainFrame.add(imagePanel4);
        imagePanel4.setBounds(0, 130, MAIN_PANNEL_W, MAIN_PANNEL_H-130);
        
        mainFrame.add(imagePanel5);
        imagePanel5.setBounds(0, 130, MAIN_PANNEL_W, MAIN_PANNEL_H-130);

        headerLabel = new JLabel("", JLabel.CENTER);        
        statusLabel = new JLabel("",JLabel.CENTER);    

        statusLabel.setSize(350,100);

        msglabel = new JLabel("Welcome to TutorialsPoint SWING Tutorial.", JLabel.CENTER);

        controlPanel = new JPanel();
        controlPanel.setLayout(new FlowLayout());

        mainFrame.add(headerLabel);
        mainFrame.add(controlPanel);
        mainFrame.add(statusLabel);
        
        
        
        
        // Pornire ------------------------------------------------------------
        bar_buts[0].addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                if(show_bt[0])
                {
                    try {
                        cxp.expeditor.trimiteMesajSicstus("pornire");// porneste programul
                        cxp.expeditor.trimiteMesajSicstus("incarca");// asteapta sa fie incarcat fisierul cu reguli
                        bar_buts[0].setEnabled(false);
                        show_bt[0] = false;
                        bar_buts[1].setEnabled(true);
                        show_bt[1] = true;

                    } catch (InterruptedException ex) {
                        System.err.println("Comanda Prolog 'pornire' a esuat!");
                    }
                }
            }
        });
        
        // Incarca ------------------------------------------------------------
        bar_buts[1].addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                if(show_bt[1])
                {
                    //System.out.println("selecting consulta");
                    bar_buts[1].setEnabled(false);
                    show_bt[1] = false;
                    startButton.setEnabled(true);
                }
            }
        });
        
        // Reinitiaza ------------------------------------------------------------
        bar_buts[3].addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                if(show_bt[3])
                {
                    //System.out.println("selecting consulta");
                    bar_buts[0].setEnabled(true);
                    show_bt[0] = true;
                    for(int i=1; i<6; ++i)
                    {
                        bar_buts[i].setEnabled(false);
                        show_bt[i] = false;
                    }
                    startButton.setEnabled(false);
                    imagePanel3.setVisible(true);
                    imagePanel4.setVisible(false);
                    imagePanel5.setVisible(false);
                    tabbedPane.reset();
                }
            }
        });
        
        
        // Start button --------------------------------------------------------
        startButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
                if(startButton.isEnabled())
                {
                    try {
                        cxp.expeditor.trimiteMesajSicstus("consulta");
                    } catch (InterruptedException ex) {
                        System.err.println("Comanda Prolog 'consulta' a esuat!");
                    }
                    
                    // afiseaza panoul de consulta
                    imagePanel3.setVisible(false);
                    imagePanel4.setVisible(true);
                    bar_buts[2].setEnabled(true);
                    show_bt[2] = true;
                    
                    // Adauga prima intrebare
                    tabbedPane.newTab("Sunteti o persoana pasionata de IT?(bla bla bla bla bla bla bla bla bla)", "deloc;putin;mult", 2);
                }
            }
        });
        
        
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