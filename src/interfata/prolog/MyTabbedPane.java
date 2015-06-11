/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfata.prolog;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.util.Arrays;
import javafx.beans.value.ChangeListener;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JTextField;
import javax.swing.JToggleButton;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;

/**
 *
 * @author Simionescu Adrian
 */
public class MyTabbedPane extends JPanel {
    private JTabbedPane tabbedPane;
    private MainPannel interfata;
    private int width;
    private int height;
    private int currentNr = 0;
    private ImageIcon icon = null;// createImageIcon("src\\resources\\right.png")
    
    // Lista cu taburi
    private JComponent[] tabs = new JComponent[100];
    
    // Lista cu raspunsuri
    private String[] intrebari = new String[100];
    private String[] raspunsuri = new String[100];
    private int[] fc = new int[100];
    
    // Campuri pentru raspuns
    private JToggleButton select = new JToggleButton("DA");
    private JTextField input = new JTextField(30);
    private MyJSlider slider = new MyJSlider();
    
    private int currTip = 0;
    private String currOptiuni;
    
    private int intrebare_MarginLeft;
    private int intrebare_MarginTop;
    private int intrebare_Width;
    private int intrebare_Height;
    
    
    
    public void reset()
    {
        currentNr = 0;
        tabbedPane.removeAll();
    }
    
    public MyTabbedPane(MainPannel interfata, int width, int height)
    {
        super(new GridLayout(1, 1));
         
        this.interfata = interfata;
        this.width = width;
        this.height = height;
        
        intrebare_MarginLeft = 20;
        intrebare_MarginTop = 90;
        intrebare_Width = width-40;
        intrebare_Height = 50;
        
        tabbedPane = new JTabbedPane();
        //The following line enables to use scrolling tabs.
        tabbedPane.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);
        //Add the tabbed pane to this panel.
        add(tabbedPane);
    }
    
    
    
    public void newTab(String Intrebare, String optiuni, int tip)
    {
        currTip = tip;
        currOptiuni = optiuni;
        
        //tabbedPane.setMnemonicAt(currentNr, KeyEvent.VK_TAB);
        
        intrebari[currentNr] = Intrebare;
        
        tabs[currentNr] = makeTextPanel("Panel #"+(currentNr+1)+" (has a preferred size of 410 x 50).");
        tabs[currentNr].setLayout(null);
        tabs[currentNr].setPreferredSize(new Dimension(410, 50));
        
        String IntrebareConcat = new String();
        
        switch(currTip)
        {
            case 1: IntrebareConcat = Intrebare+" ("+optiuni+")"; break;
            case 2: IntrebareConcat = Intrebare; break;
            case 3: IntrebareConcat = Intrebare; break;
        }
        
        JLabel label = new JLabel(IntrebareConcat, SwingConstants.CENTER);
        label.setFont(new Font("Default", Font.ITALIC, 20));
        tabs[currentNr].add(label);
        label.setBounds(intrebare_MarginLeft, intrebare_MarginTop, intrebare_Width, intrebare_Height);
        
        switch(currTip)
        {
            case 1:// lista optiuni
                tabs[currentNr].add(input);
                input.setBounds((int)(width-180)/2, intrebare_MarginTop+intrebare_Height, 180, 25);
                tabs[currentNr].add(slider);
                slider.setBounds((int)(width-200)/2, intrebare_MarginTop+intrebare_Height+35, 200, 45);
                break;
            case 2:// da/nu
                select.setSelected(true);
                select.addItemListener(new ItemListener() {
                    public void itemStateChanged(ItemEvent ev) {
                       if(ev.getStateChange()==ItemEvent.SELECTED){
                         select.setText("DA");
                       } else if(ev.getStateChange()==ItemEvent.DESELECTED){
                         select.setText("NU");
                       }
                    }
                 });
                tabs[currentNr].add(select);
                select.setBounds((int)(width-60)/2, intrebare_MarginTop+intrebare_Height, 60, 20);
                tabs[currentNr].add(slider);
                slider.setBounds((int)(width-200)/2, intrebare_MarginTop+intrebare_Height+35, 200, 45);
                break;
            case 3:// custom
            
                break;
        }
        
        
        JButton okButton = new JButton("Răspunde");
        okButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent ev) {
                switch(currTip)
                {
                    case 1:// lista optiuni
                        raspunsuri[currentNr] = input.getText();
                        input.setText("");
                        fc[currentNr] = slider.getValue();
                        slider.reset();
                        break;
                    case 2:// da/nu
                        raspunsuri[currentNr] = (select.isSelected()) ? "DA" : "NU";
                        select.setSelected(true);
                        fc[currentNr] = slider.getValue();
                        slider.reset();
                        break;
                    case 3:// custom

                        break;
                }
                
                
                if(
                    (currTip == 1 && Arrays.asList(currOptiuni.split("\\;")).contains(raspunsuri[currentNr]))
                    ||
                    (currTip == 2 && (raspunsuri[currentNr] == "DA" || raspunsuri[currentNr] == "NU"))
                )// Verificam daca este corect
                {
                    // Trimite catre Prolog
                    try {
                        System.err.println(raspunsuri[currentNr]);
                        interfata.cxp.expeditor.trimiteMesajSicstus(raspunsuri[currentNr]);
                    } catch (InterruptedException ex) {
                        System.err.println("Comanda Prolog '"+raspunsuri[currentNr]+"' a esuat!");
                    }
                    
                    
                    // Rescriem tabul current
                    tabs[currentNr].removeAll();

                    JLabel labelI = new JLabel(intrebari[currentNr], SwingConstants.CENTER);
                    labelI.setFont(new Font("Default", Font.ITALIC, 20));
                    tabs[currentNr].add(labelI);
                    labelI.setBounds(intrebare_MarginLeft, intrebare_MarginTop, intrebare_Width, intrebare_Height);

                    JLabel labelR = new JLabel(raspunsuri[currentNr]+" ("+fc[currentNr]+")", SwingConstants.CENTER);
                    labelR.setFont(new Font("Default", Font.BOLD, 16));
                    labelR.setForeground(Color.BLUE);
                    tabs[currentNr].add(labelR);
                    labelR.setBounds((int)(width-300)/2, intrebare_MarginTop+intrebare_Height, 300, 20);


                    currentNr++;
                    newTab("Va place sportul?", "deloc;putin;mult", 1);
                    tabbedPane.setSelectedIndex(currentNr);
                }
                else// Afisam mesaj de eroare
                {
                    JOptionPane.showMessageDialog(tabbedPane, "Valoarea introdusa nu este corecta!", "Raspunsul invalid", JOptionPane.ERROR_MESSAGE);
                }
            }
         });
        
        tabs[currentNr].add(okButton);
        okButton.setBounds((int)(width-200)/2, 250, 200, 40);
        
        
        tabbedPane.addTab("I:"+(currentNr+1)+"", icon, tabs[currentNr],"Does nothing at all");
    }
    
    protected JComponent makeTextPanel(String text) {
        JPanel panel = new JPanel(false);
        JLabel filler = new JLabel(text);
        filler.setHorizontalAlignment(JLabel.CENTER);
        panel.setLayout(new GridLayout(1, 1));
        panel.add(filler);
        return panel;
    }
     
    /** Returns an ImageIcon, or null if the path was invalid. */
    protected static ImageIcon createImageIcon(String path) {
        java.net.URL imgURL = MyTabbedPane.class.getResource(path);
        if (imgURL != null) {
            return new ImageIcon(imgURL);
        } else {
            System.err.println("Couldn't find file: " + path);
            return null;
        }
    }
     
    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from
     * the event dispatch thread.
     */

}
