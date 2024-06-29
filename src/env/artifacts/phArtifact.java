package artifacts;
import javax.swing.*;
import java.awt.event.*;
import java.awt.*;

import cartago.*;
import cartago.tools.*;
import java.util.Random;

public class phArtifact extends GUIArtifact {
    private SensorFrame frame;
    
    public void setup() {
        frame = new SensorFrame();
        
        //linkActionEventToOp(frame.okButton, "ok");
        linkActionEventToOp(frame.phOkButton, "phOk"); // New button for pH
        //linkKeyStrokeToOp(frame.phText, "ENTER", "updatePH");
        //linkKeyStrokeToOp(frame.tempText, "ENTER", "updateTemp");
        linkWindowClosingEventToOp(frame, "closed");
        defineObsProperty("ph", getPH());
        frame.setVisible(true);
    }

    /*
    @INTERNAL_OPERATION void ok(ActionEvent ev) {
        updatePH_new();
        updateTemp_new();
        signal("ok");
    }*/

    @INTERNAL_OPERATION void phOk(ActionEvent ev) { // Handle new button
        updatePH_new();
        signal("phOk");
    }

    @INTERNAL_OPERATION void closed(WindowEvent ev) {
        signal("closed");
    }

    @INTERNAL_OPERATION void updatePH_new() {
        getObsProperty("ph").updateValue(getPH());
    }


    @INTERNAL_OPERATION void updatePH(ActionEvent ev) {
        getObsProperty("ph").updateValue(getPH());
    }

    @OPERATION void displayMessage(String message, Color color) {
        frame.setMessage(message, color);
    }

    @OPERATION void neutralizeAcidity() {
        frame.setPHText("7.0");
        getObsProperty("ph").updateValue(7.0);
        displayMessage("Agente regulando o PH: neutralizou acidez", Color.GREEN);
    }

    @OPERATION void neutralizeBasicity() {
        frame.setPHText("7.0");
        getObsProperty("ph").updateValue(7.0);
        displayMessage("Agente regulando o PH: neutralizou basicidade", Color.BLUE);
    }

    @OPERATION void println(String value) {
        System.out.println(value);
    }

    public double getPH() {
        return Double.parseDouble(frame.getPHText());
    }


    class SensorFrame extends JFrame {
        //private JButton okButton;
        private JButton phOkButton;  // New button
        private JTextField phText;
        private JLabel messageLabel;

        public SensorFrame() {
            setTitle("Sensor PH");
            setSize(300, 200);
            
            JPanel panel = new JPanel();
            setContentPane(panel);
            

            phOkButton = new JButton("Update pH");  // New button
            phOkButton.setSize(100, 50);

            phText = new JTextField(10);
            phText.setText("7.0");
            phText.setEditable(true);

            messageLabel = new JLabel(" ");
            messageLabel.setOpaque(true);


            panel.add(new JLabel("pH:"));
            panel.add(phText);
            panel.add(new JLabel("Temperature:"));
            //panel.add(okButton);
            panel.add(phOkButton);  // Add new button to panel
            panel.add(messageLabel);
        }

        public String getPHText() {
            return phText.getText();
        }

        public void setPHText(String s) {
            phText.setText(s);
        }


        public void setMessage(String message, Color color) {
            messageLabel.setText(message);
            messageLabel.setBackground(color);
        }
    }

}
