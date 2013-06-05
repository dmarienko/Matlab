package com.mathworks.mwswing.plaf;

import com.jgoodies.looks.Options;
import com.jgoodies.looks.plastic.Plastic3DLookAndFeel;
import com.jgoodies.looks.plastic.PlasticTheme;
import com.mathworks.mwswing.*;
import com.mathworks.util.*;
import java.awt.*;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import javax.swing.*;
import net.neilcsmith.praxis.live.laf.*;

public class PlafUtils {
    private static String LAF = "com.jgoodies.looks.plastic.Plastic3DLookAndFeel";
    //private static String LAF = "com.jtattoo.plaf.hifi.HiFiLookAndFeel";
    //private static String LAF = "org.pushingpixels.substance.api.skin.SubstanceGraphiteLookAndFeel";

    private static class ContrastingCollapsedIcon extends com.sun.java.swing.plaf.windows.WindowsTreeUI.CollapsedIcon {
        public void paintIcon(Component component, Graphics g, int i, int j) {
            if (PlatformInfo.isWindowsModernAppearance() || !ColorUtils.isDark(component.getBackground())) {
                super.paintIcon(component, g, i, j);
            } else {
                g.setColor(component.getBackground());
                g.fillRect(i, j, 8, 8);
                g.setColor(Color.gray);
                g.drawRect(i, j, 8, 8);
                g.setColor(Color.white);
                g.drawLine(i + 2, j + 4, i + 6, j + 4);
                g.drawLine(i + 4, j + 2, i + 4, j + 6);
            }
        }

        private ContrastingCollapsedIcon() {
        }
    }

    private static class ContrastingExpandedIcon extends com.sun.java.swing.plaf.windows.WindowsTreeUI.ExpandedIcon {
        public void paintIcon(Component component, Graphics g, int i, int j) {
            if (PlatformInfo.isWindowsModernAppearance() || !ColorUtils.isDark(component.getBackground())) {
                super.paintIcon(component, g, i, j);
            } else {
                g.setColor(component.getBackground());
                g.fillRect(i, j, 8, 8);
                g.setColor(Color.gray);
                g.drawRect(i, j, 8, 8);
                g.setColor(Color.white);
                g.drawLine(i + 2, j + 4, i + 6, j + 4);
            }
        }

        private ContrastingExpandedIcon() {
        }
    }

    private static class SystemColorTracker
            implements PropertyChangeListener {
        public void propertyChange(PropertyChangeEvent propertychangeevent) {
            String s = propertychangeevent.getPropertyName();
            if (s.equals("win.3d.backgroundColor")) {
                Color color = UIManager.getColor("control");
                SystemColor systemcolor = SystemColor.control;
                if (color.getRGB() != systemcolor.getRGB())
                    UIManager.put("control", systemcolor);
                color = UIManager.getColor("textText");
                systemcolor = SystemColor.textText;
                if (color.getRGB() != systemcolor.getRGB())
                    UIManager.put("textText", systemcolor);
                color = UIManager.getColor("textInactiveText");
                systemcolor = SystemColor.textInactiveText;
                if (color.getRGB() != systemcolor.getRGB())
                    UIManager.put("textInactiveText", systemcolor);
            } else if (s.equals("win.3d.highlightColor")) {
                Color color1 = UIManager.getColor("controlLtHighlight");
                SystemColor systemcolor1 = SystemColor.controlLtHighlight;
                if (color1.getRGB() != systemcolor1.getRGB())
                    UIManager.put("controlLtHighlight", systemcolor1);
            } else if (s.equals("win.3d.lightColor")) {
                Color color2 = UIManager.getColor("controlHighlight");
                SystemColor systemcolor2 = SystemColor.controlHighlight;
                if (color2.getRGB() != systemcolor2.getRGB())
                    UIManager.put("controlHighlight", systemcolor2);
            } else if (s.equals("win.3d.shadowColor")) {
                Color color3 = UIManager.getColor("controlShadow");
                SystemColor systemcolor3 = SystemColor.controlShadow;
                if (color3.getRGB() != systemcolor3.getRGB())
                    UIManager.put("controlShadow", systemcolor3);
                color3 = UIManager.getColor("controlDkShadow");
                systemcolor3 = SystemColor.controlDkShadow;
                if (color3.getRGB() != systemcolor3.getRGB())
                    UIManager.put("controlDkShadow", systemcolor3);
            }
        }

        private SystemColorTracker() {
        }
    }

    private static class CorrectedPlasticCheckBoxIcon
            implements Icon {
        public void paintIcon(Component component, Graphics g, int i, int j) {
            g.setColor(Plastic3DLookAndFeel.getControl());
            g.fillRect(i, j, 13, 13);
            fIcon.paintIcon(component, g, i, j);
        }

        public int getIconWidth() {
            return fIcon.getIconWidth();
        }

        public int getIconHeight() {
            return fIcon.getIconHeight();
        }
        private final Icon fIcon;

        private CorrectedPlasticCheckBoxIcon(Icon icon) {
            fIcon = icon;
        }
    }

    public static boolean isMotifLookAndFeel() {
        return UIManager.getLookAndFeel().getClass().getName().equals("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
    }

    public static boolean isPlasticLookAndFeel() {
        return UIManager.getLookAndFeel().getClass().getName().equals("com.jgoodies.looks.plastic.Plastic3DLookAndFeel");
    }

    public static boolean isWindowsLookAndFeel() {
        return UIManager.getLookAndFeel().getClass().getName().equals("com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
    }

    public static boolean isMetalLookAndFeel() {
        return UIManager.getLookAndFeel().getClass().getName().equals("javax.swing.plaf.metal.MetalLookAndFeel");
    }

    public static boolean isAquaLookAndFeel() {
        return PlatformInfo.isMacintosh();
    }

    public static void correctPlatformLookAndFeel() {
        if (isAquaLookAndFeel())
            correctMacintoshLookAndFeel();
        else if (isWindowsLookAndFeel())
            correctWindowsLookAndFeel();
        else if (isPlasticLookAndFeel())
            correctPlasticLookAndFeel();
    }

    public static void correctWindowsLookAndFeel() {
        correctWindowsCaretBlinkRate();
        correctWindowsFonts();
        trackWindowsSystemColors();
        updateTreeIcons();
        UIManager.put("TextField.disabledBackground", UIManager.getColor("control"));
        UIManager.put("TextField.inactiveBackground", UIManager.getColor("control"));
        UIManager.put("PopupMenu.consumeEventOnClose", Boolean.valueOf(false));
        if (PlatformInfo.isWindowsModernAppearance())
            correctXPMenuBorders();
        if (MJUtilities.isHighContrast())
            UIManager.put("Table.scrollPaneBorder", BorderFactory.createLineBorder((Color) UIManager.get("windowBorder"), 1));
    }

    public static void correctPlasticLookAndFeel() {
        UIManager.put("MenuItem.acceleratorDelimiter", "+");
        UIManager.put("Button.defaultButtonFollowsFocus", Boolean.TRUE);
        updateTreeIcons();
        UIManager.put("CheckBox.icon", new CorrectedPlasticCheckBoxIcon(UIManager.getIcon("CheckBox.icon")));
    }

    public static void correctMacintoshLookAndFeel() {
        MacAppearanceUtils.initialize();
        String s = System.getProperty("apple.laf.useScreenMenuBar");
        boolean flag = PlatformInfo.getVersion() >= 7 && "true".equals(s);
        System.setProperty("apple.laf.useScreenMenuBar", flag ? "true" : "false");
        if (PlatformInfo.isMacintosh() && flag)
            NativeJava.setDefaultMenuBar();
        System.setProperty("apple.awt.showGrowBox", "true");
    }

    public static void correctWindowsCaretBlinkRate() {
        Integer integer = Integer.valueOf(MJUtilities.getCaretBlinkRate());
        UIManager.put("TextField.caretBlinkRate", integer);
        UIManager.put("FormattedTextField.caretBlinkRate", integer);
        UIManager.put("PasswordField.caretBlinkRate", integer);
        UIManager.put("TextArea.caretBlinkRate", integer);
        UIManager.put("TextPane.caretBlinkRate", integer);
        UIManager.put("EditorPane.caretBlinkRate", integer);
    }

    public static void correctWindowsFonts() {
        Font font = FontUtils.getSystemUIFont();
        if (LanguageUtils.isCJK()) {
            UIManager.put("Menu.font", font);
            UIManager.put("MenuItem.font", font);
            UIManager.put("CheckBoxMenuItem.font", font);
            UIManager.put("RadioButtonMenuItem.font", font);
        }
        UIManager.getDefaults().put("Button.font", font);
        UIManager.getDefaults().put("CheckBox.font", font);
        UIManager.getDefaults().put("ComboBox.font", font);
        UIManager.getDefaults().put("EditorPane.font", font);
        UIManager.getDefaults().put("FormattedTextField.font", font);
        UIManager.getDefaults().put("Label.font", font);
        UIManager.getDefaults().put("List.font", font);
        UIManager.getDefaults().put("Panel.font", font);
        UIManager.getDefaults().put("ProgressBar.font", font);
        UIManager.getDefaults().put("RadioButton.font", font);
        UIManager.getDefaults().put("ScrollPane.font", font);
        UIManager.getDefaults().put("TabbedPane.font", font);
        UIManager.getDefaults().put("Table.font", font);
        UIManager.getDefaults().put("TableHeader.font", font);
        UIManager.getDefaults().put("TextField.font", font);
        UIManager.getDefaults().put("TextPane.font", font);
        UIManager.getDefaults().put("TitledBorder.font", font);
        UIManager.getDefaults().put("ToggleButton.font", font);
        UIManager.getDefaults().put("Tree.font", font);
        UIManager.getDefaults().put("Viewport.font", font);
    }

    public static void setLookAndFeel() {
        if (!sLookAndFeelAlreadySet) {
            try {
                if (PlatformInfo.isXWindows())
                    setUnixLookAndFeel();
                else
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (UnsupportedLookAndFeelException unsupportedlookandfeelexception) {
                System.out.println("Look & Feel not supported.");
            } catch (IllegalAccessException illegalaccessexception) {
                System.out.println("Look & Feel could not be accessed.");
            } catch (ClassNotFoundException classnotfoundexception) {
                System.out.println("Look & Feel could not be found.");
            } catch (InstantiationException instantiationexception) {
                System.out.println("Look & Feel could not be instantiated.");
            }
            correctPlatformLookAndFeel();
            sLookAndFeelAlreadySet = true;
        }
    }

    private static void setUnixLookAndFeel()
            throws ClassNotFoundException, InstantiationException, IllegalAccessException, UnsupportedLookAndFeelException {

        if (GraphicsEnvironment.isHeadless()) {
            return;
        } else {
            if (true) {
                //System.setProperty("insubstantial.logEDT", "false");
//                SwingUtilities.invokeLater(new Runnable() {
//                    public void run() {
//                        try {
                            //UIManager.setLookAndFeel("org.pushingpixels.substance.api.skin.SubstanceGraphiteLookAndFeel");
				Options.setUseNarrowButtons(false);
                UIManager.put("Nb.PraxisLFCustoms", new PraxisLFCustoms());
                UIManager.setLookAndFeel("net.neilcsmith.praxis.laf.PraxisLookAndFeel");
                System.setProperty("awt.useSystemAAFontSettings", "lcd");
                            updateTreeIcons();
//                        } catch (Exception e) {
//                        }
//                    }
//                });

                //JFrame.setDefaultLookAndFeelDecorated(true);
                //JDialog.setDefaultLookAndFeelDecorated(true);
            } else {
                Options.setUseNarrowButtons(false);
                Plastic3DLookAndFeel.setPlasticTheme((PlasticTheme) Class.forName("com.jgoodies.looks.plastic.theme.DarkStar").newInstance());
                UIManager.setLookAndFeel(LAF);
                updateTreeIcons();
            }

            return;
        }
    }

    private static void correctXPMenuBorders() {
        javax.swing.border.CompoundBorder compoundborder = BorderFactory.createCompoundBorder(BorderFactory.createMatteBorder(1, 1, 1, 1, UIManager.getColor("controlShadow")), BorderFactory.createEmptyBorder(2, 2, 2, 2));
        UIManager.put("PopupMenu.border", compoundborder);
    }

    private static void trackWindowsSystemColors() {
        Toolkit toolkit = Toolkit.getDefaultToolkit();
        SystemColorTracker systemcolortracker = new SystemColorTracker();
        toolkit.addPropertyChangeListener("win.3d.backgroundColor", systemcolortracker);
        toolkit.addPropertyChangeListener("win.3d.highlightColor", systemcolortracker);
        toolkit.addPropertyChangeListener("win.3d.lightColor", systemcolortracker);
        toolkit.addPropertyChangeListener("win.3d.shadowColor", systemcolortracker);
    }

    public static void updateTreeIcons() {
        UIManager.put("Tree.expandedIcon", new ContrastingExpandedIcon());
        UIManager.put("Tree.collapsedIcon", new ContrastingCollapsedIcon());
    }

    private PlafUtils() {
    }
    private static boolean sLookAndFeelAlreadySet = false;
    private static final int SIZE = 9;
    private static final int HALF_SIZE = 4;
}
