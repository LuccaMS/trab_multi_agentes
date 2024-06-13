package artifacts;
import javax.swing.*;
import java.awt.event.*;
import cartago.*;
import cartago.tools.*;


public class Sensor1Artifact extends GUIArtifact {
    private SensorFrame frame;
    
    public void setup() {
        frame = new SensorFrame();
        
        linkActionEventToOp(frame.okButton, "ok");
        linkKeyStrokeToOp(frame.phText, "ENTER", "updatePH");
        linkKeyStrokeToOp(frame.tempText, "ENTER", "updateTemp");
        linkWindowClosingEventToOp(frame, "closed");
        
        defineObsProperty("ph", getPH());
        defineObsProperty("temperature", getTemperature());
        frame.setVisible(true);
    }

    @INTERNAL_OPERATION void ok(ActionEvent ev) {
        signal("ok");
    }

    @INTERNAL_OPERATION void closed(WindowEvent ev) {
        signal("closed");
    }

    @INTERNAL_OPERATION void updatePH(ActionEvent ev) {
        getObsProperty("ph").updateValue(getPH());
    }

    @INTERNAL_OPERATION void updateTemp(ActionEvent ev) {
        getObsProperty("temperature").updateValue(getTemperature());
    }

    @OPERATION void setSensorData(double ph, double temperature) {
        frame.setPHText(String.valueOf(ph));
        frame.setTempText(String.valueOf(temperature));
        getObsProperty("ph").updateValue(ph);
        getObsProperty("temperature").updateValue(temperature);
    }

    @OPERATION void println(String value) {
        System.out.println(value);
    }

    private double getPH() {
        return Double.parseDouble(frame.getPHText());
    }

    private double getTemperature() {
        return Double.parseDouble(frame.getTempText());
    }

    class SensorFrame extends JFrame {
        private JButton okButton;
        private JTextField phText;
        private JTextField tempText;

        public SensorFrame() {
            setTitle("Agent 1");
            setSize(300, 200);
            
            JPanel panel = new JPanel();
            setContentPane(panel);
            
            okButton = new JButton("ok");
            okButton.setSize(80, 50);
            
            phText = new JTextField(10);
            phText.setText("7.0");
            phText.setEditable(true);

            tempText = new JTextField(10);
            tempText.setText("21.0");
            tempText.setEditable(true);
            
            panel.add(new JLabel("pH:"));
            panel.add(phText);
            panel.add(new JLabel("Temperature:"));
            panel.add(tempText);
            panel.add(okButton);
        }

        public String getPHText() {
            return phText.getText();
        }

        public void setPHText(String s) {
            phText.setText(s);
        }

        public String getTempText() {
            return tempText.getText();
        }

        public void setTempText(String s) {
            tempText.setText(s);
        }
    }
}
