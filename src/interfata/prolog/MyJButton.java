/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfata.prolog;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.geom.Area;
import java.awt.geom.RoundRectangle2D;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import util.RoundedBorder;

/**
 *
 * @author Simionescu Adrian
 */
public class MyJButton extends JButton implements MouseListener
{
    public boolean selected;
    private boolean enabled;
    private Color activeColor;
    private Color selectedColor;
    private Color mouseOverColor;
    private Color disabledColor;
    
    public MyJButton(String text)
    {
        setText(text);
        setBorderPainted(false);
        setContentAreaFilled(false);
        setFocusPainted(false); 
        setBorder(null);
        setBackground(null);
        setOpaque(false);
        selected = false;
        enabled=false;
        
        this.activeColor = new Color(255, 255, 255);
        this.selectedColor = new Color(255, 255, 0);
        this.mouseOverColor = new Color(150, 255, 255);
        this.disabledColor = new Color(150, 150, 150);
        
        addMouseListener(this);
    }

    @Override
    public void setEnabled(boolean b)
    {
        enabled = b;
        if(enabled) 
        {
            if(selected)
                setForeground(selectedColor);
            else
                setForeground(activeColor);
            
            setFont(new Font("Arial", Font.BOLD, 12));
        }
        else
        {
            setForeground(disabledColor);
            setFont(new Font("Arial", Font.PLAIN, 12));
        }
    }
    
    //override the methods of implemented MouseListener
    @Override
    public void mouseClicked(MouseEvent e) { }
    @Override
    public void mousePressed(MouseEvent e) { }
    @Override
    public void mouseReleased(MouseEvent e) { }

    @Override
    public void mouseEntered(MouseEvent e)
    { 
        if(e.getSource()==this && enabled && !selected)
        {
            this.setForeground(this.mouseOverColor);
        }
    }

    @Override
    public void mouseExited(MouseEvent e)
    { 
        if(e.getSource()==this && enabled && !selected)
        {
            this.setForeground(this.activeColor);
        }
    }
}
