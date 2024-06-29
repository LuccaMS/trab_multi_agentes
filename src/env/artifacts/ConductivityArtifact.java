package artifacts;

import javax.swing.*;
import java.awt.event.*;
import java.awt.*;

import cartago.*;
import cartago.tools.*;

public class ConductivityArtifact extends GUIArtifact {
    private ConductivityFrame frame;
    
    public void setup() {
        frame = new ConductivityFrame();
        
        linkActionEventToOp(frame.condOkButton, "condOk");
        linkWindowClosingEventToOp(frame, "closed");
        defineObsProperty("conductivity", getConductivity());
        frame.setVisible(true);
    }

    @OPERATION void set_conductivity(double newConductivity) {
    frame.setConductivityText(String.valueOf(newConductivity));
    getObsProperty("conductivity").updateValue(newConductivity);
    displayMessage("Conductivity set to: " + newConductivity, Color.GREEN);
    }


    @INTERNAL_OPERATION void condOk(ActionEvent ev) {
        updateConductivity_new();
        signal("condOk");
    }

    @INTERNAL_OPERATION void closed(WindowEvent ev) {
        signal("closed");
    }

    @INTERNAL_OPERATION void updateConductivity_new() {
        getObsProperty("conductivity").updateValue(getConductivity());
    }

    @OPERATION void displayMessage(String message, Color color) {
        frame.setMessage(message, color);
    }

    @OPERATION void adjustConductivity(double newConductivity) {
        frame.setConductivityText(String.valueOf(newConductivity));
        getObsProperty("conductivity").updateValue(newConductivity);
        displayMessage("Agente ajustou a condutividade para: " + newConductivity, Color.GREEN);
    }

    @OPERATION void println(String value) {
        System.out.println(value);
    }

    public double getConductivity() {
        return Double.parseDouble(frame.getConductivityText());
    }

    class ConductivityFrame extends JFrame {
        private JButton condOkButton;
        private JTextField conductivityText;
        private JLabel messageLabel;

        public ConductivityFrame() {
            setTitle("Sensor de Condutividade");
            setSize(300, 200);
            
            JPanel panel = new JPanel();
            setContentPane(panel);
            
            condOkButton = new JButton("Update Conductivity");
            condOkButton.setSize(100, 50);

            conductivityText = new JTextField(10);
            conductivityText.setText("0.0");
            conductivityText.setEditable(true);

            messageLabel = new JLabel(" ");
            messageLabel.setOpaque(true);

            panel.add(new JLabel("Conductivity:"));
            panel.add(conductivityText);
            panel.add(condOkButton);
            panel.add(messageLabel);
        }

        public String getConductivityText() {
            return conductivityText.getText();
        }

        public void setConductivityText(String s) {
            conductivityText.setText(s);
        }

        public void setMessage(String message, Color color) {
            messageLabel.setText(message);
            messageLabel.setBackground(color);
        }
    }
}
