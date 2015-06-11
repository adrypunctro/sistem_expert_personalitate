/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfata.prolog;

/**
 *
 * @author Simionescu Adrian
 */
import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JSlider;

public class MyJSlider extends JPanel
{
    private JSlider slider;
    
    public MyJSlider()
    {
    super(true);
    this.setLayout(new BorderLayout());
    slider = new JSlider(JSlider.HORIZONTAL, 0, 100, 100);

    slider.setMinorTickSpacing(5);
    slider.setMajorTickSpacing(20);
    slider.setPaintTicks(true);
    slider.setPaintLabels(true);

    
    // We'll just use the standard numeric labels for now...
    slider.setLabelTable(slider.createStandardLabels(20));

    add(slider, BorderLayout.CENTER);
    }
  
    public int getValue()
    {
        return slider.getValue();
    }
    
    public void reset()
    {
        slider.setValue(100);
    }
}
