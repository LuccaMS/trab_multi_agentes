package artifacts;

import javax.swing.*;
import java.awt.event.*;
import java.awt.*;

import cartago.*;
import cartago.tools.*;

public class AlkalinityArtifact extends GUIArtifact {
    private AlkalinityFrame frame;
    
    public void setup() {
        frame = new AlkalinityFrame();
        
        linkActionEventToOp(frame.alkOkButton, "alkOk");
        linkWindowClosingEventToOp(frame, "closed");
        defineObsProperty("alkalinity", getAlkalinity());
        frame.setVisible(true);
    }

    @OPERATION void set_alkalinity(double newAlkalinity) {
    frame.setAlkalinityText(String.valueOf(newAlkalinity));
    getObsProperty("alkalinity").updateValue(newAlkalinity);
    displayMessage("Alkalinity set to: " + newAlkalinity, Color.GREEN);
    }

    @INTERNAL_OPERATION void alkOk(ActionEvent ev) {
        updateAlkalinity_new();
        signal("alkOk");
    }

    @INTERNAL_OPERATION void closed(WindowEvent ev) {
        signal("closed");
    }

    @INTERNAL_OPERATION void updateAlkalinity_new() {
        getObsProperty("alkalinity").updateValue(getAlkalinity());
    }

    @OPERATION void displayMessage(String message, Color color) {
        frame.setMessage(message, color);
    }

    @OPERATION void adjustAlkalinity(double newAlkalinity) {
        frame.setAlkalinityText(String.valueOf(newAlkalinity));
        getObsProperty("alkalinity").updateValue(newAlkalinity);
        displayMessage("Agente ajustou a alcalinidade para: " + newAlkalinity, Color.GREEN);
    }

    @OPERATION void println(String value) {
        System.out.println(value);
    }

    public double getAlkalinity() {
        return Double.parseDouble(frame.getAlkalinityText());
    }

    class AlkalinityFrame extends JFrame {
        private JButton alkOkButton;
        private JTextField alkalinityText;
        private JLabel messageLabel;

        public AlkalinityFrame() {
            setTitle("Sensor de Alcalinidade");
            setSize(300, 200);
            
            JPanel panel = new JPanel();
            setContentPane(panel);
            
            alkOkButton = new JButton("Update Alkalinity");
            alkOkButton.setSize(100, 50);

            alkalinityText = new JTextField(10);
            alkalinityText.setText("0.0");
            alkalinityText.setEditable(true);

            messageLabel = new JLabel(" ");
            messageLabel.setOpaque(true);

            panel.add(new JLabel("Alkalinity:"));
            panel.add(alkalinityText);
            panel.add(alkOkButton);
            panel.add(messageLabel);
        }

        public String getAlkalinityText() {
            return alkalinityText.getText();
        }

        public void setAlkalinityText(String s) {
            alkalinityText.setText(s);
        }

        public void setMessage(String message, Color color) {
            messageLabel.setText(message);
            messageLabel.setBackground(color);
        }
    }
}
