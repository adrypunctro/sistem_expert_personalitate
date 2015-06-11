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
import java.awt.Graphics;
import java.awt.Image;
import javax.swing.JPanel;

@SuppressWarnings("serial")
class ImagePanel extends JPanel
{
    private Image image;
    private int height;
    private Boolean repeat_y;

    ImagePanel(Image image, int height)
    {
        this.image = image;
        this.height = height;
        this.repeat_y = (height == 0);
    }

    @Override
    public void paintComponent(Graphics g) {

        super.paintComponent(g);
        int iw = image.getWidth(this);
        int ih = (repeat_y) ? image.getHeight(this) : height;
        int eh = (repeat_y) ? getHeight() : height;
        if (iw > 0 && ih > 0) {
            for (int x = 0; x < getWidth(); x += iw) {
                for (int y = 0; y < eh; y += ih) {
                    g.drawImage(image, x, y, iw, ih, this);
                }
            }
        }
    }

}
