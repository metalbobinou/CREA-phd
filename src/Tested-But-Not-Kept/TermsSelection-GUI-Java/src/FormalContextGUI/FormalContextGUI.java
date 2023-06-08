package FormalContextGUI;

import java.awt.Frame;
import java.awt.Panel;
import java.awt.MenuBar;
import java.awt.Menu;
import java.awt.MenuItem;

import java.awt.Scrollbar;
import java.awt.Label;
import java.awt.TextField;
import java.awt.Button;
import java.awt.Checkbox;
import java.awt.CheckboxMenuItem;
import java.awt.FlowLayout;

import java.awt.AWTEvent;
import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class FormalContextGUI extends Frame
{
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public FormalContextGUI()
	{
		/* FRAME PARAMETERS */
		//Setting the title of Frame
    setTitle("This is my First AWT example");
    //Setting Frame width and height
    setSize(500, 300);
    setResizable(true);
    addWindowListener(new WindowAdapter()
    {
    	public void windowClosing(WindowEvent e)
    	{
    		QuitGUI();
      }
    });

    /*** MENU ***/
    // Menu Bar
    MenuBar mb = new MenuBar();
    setMenuBar(mb);

    Menu menuFile = new Menu("File");
    MenuItem miOpenReference = new MenuItem("Open Reference");
    menuFile.add(miOpenReference); ///
    MenuItem miOpenStrategy = new MenuItem("Open Strategy");
    menuFile.add(miOpenStrategy); ///
    menuFile.addSeparator(); ////
    MenuItem miExport = new MenuItem("Export Output");
    miExport.setEnabled(false);
    menuFile.add(miExport); ///
    menuFile.addSeparator(); ////
    MenuItem miQuit = new MenuItem("Quit");
    miQuit.addActionListener(new ActionListener ()
    {
    	 public void actionPerformed (ActionEvent e)
    	 {
    		 QuitGUI();
    	 }
    });
    menuFile.add(miQuit); ///
    mb.add(menuFile);

    Menu menuHelp = new Menu("Help");
    MenuItem miAbout = new MenuItem("About");
    miAbout.addActionListener(new ActionListener ()
    {
    	 public void actionPerformed (ActionEvent e)
    	 {
    		 AboutGUI();
    	 }
    });
    menuHelp.add(miAbout); ///
    mb.add(menuHelp);
    mb.setHelpMenu(menuHelp);

    Menu m1 = new Menu("Other");
    Menu m2 = new Menu("SubMenu");
    CheckboxMenuItem cbm1 = new CheckboxMenuItem(" menu item 1.3.1 ");
    m2.add(cbm1);
    cbm1.setState(true);
    CheckboxMenuItem cbm2 = new CheckboxMenuItem(" menu item 1.3.2 ");
    m2.add(cbm2);

    m1.add(m2);
    mb.add(m1);
    /*** END MENU ***/

    // Button
		Button b = new Button("Button!!");
    // setting button position on screen
    b.setBounds(50, 50, 50, 50);
    //adding button into frame
    add(b);

    //Creating a label
    Label lb = new Label("UserId: ");
    lb.setBounds(70, 70, 80, 80);
    //adding label to the frame
    add(lb);

    //Creating Text Field
    TextField t = new TextField();
    t.setBounds(80, 80, 50, 50);
    //adding text field to the frame
    add(t);

    // Creating checkbox
    Checkbox cb = new Checkbox("CB Text"); // Name
    // Add state (checkd or not)
    cb.setState(true);
    cb.setBounds(100, 100, 50, 50);
    add(cb);

    // Creating Scrollbars
    Scrollbar sb_h = new Scrollbar(Scrollbar.HORIZONTAL);
    Scrollbar sb_v = new Scrollbar(Scrollbar.VERTICAL);

    add(sb_h);
    add(sb_v);

    // Creating Panel
    Panel p = new Panel();
    // Create a button in the panel
    p.add(new Button("bouton"));

    //Setting the layout for the Frame
    setLayout(new FlowLayout());

    /* By default frame is not visible so
     * we are setting the visibility to true
     * to make it visible.
     */
    setVisible(true);
	}

	public void AboutGUI()
	{
		Frame AboutFrame = new Frame();

		AboutFrame.setTitle("About");
		AboutFrame.setSize(400, 100); // horizontal, vertical
		AboutFrame.setResizable(false);
		AboutFrame.addWindowListener(new WindowAdapter()
    {
    	public void windowClosing(WindowEvent e)
    	{
    		AboutFrame.dispose();
      }
    });
		AboutFrame.setVisible(true);
		//AboutFrame.setLayout(null); // Absolute layout
    AboutFrame.setLayout(new BorderLayout()); // Relative layout

		// Label
    Label lb = new Label("MatrixGUI made by Fabrice Boissier");
    //lb.setBounds(70, 70, 80, 80);
    lb.setAlignment(Label.CENTER);
    AboutFrame.add(lb, BorderLayout.NORTH);

		// Close button
		Button b = new Button("Close");
		b.addActionListener(new ActionListener ()
		{
			public void actionPerformed (ActionEvent e)
			{
				AboutFrame.dispose();
			}
	  });
    //b.setBounds(0, 10, 10, 10); // pos_x, pos_y, size_x, size_y
		//b.setSize(10, 20);
    AboutFrame.add(b, BorderLayout.SOUTH);
	}


	public void QuitGUI()
	{
		this.dispose();
	}

	/*
	public void windowClosing(WindowEvent e)
	{
    this.dispose();
	}
	*/

	public static void main(String args[])
	{
		FormalContextGUI f = new FormalContextGUI();
	}
}
