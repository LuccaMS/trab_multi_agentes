!test_sensor_gui.

+!test_sensor_gui
  <- makeArtifact("sensor", "artifacts.SensorArtifact", [], D);
     focus(D);
     println("Sensor GUI initialized").

+ph(V)
  <- println("pH updated: ", V, S).

+temperature(V)
  <- println("Temperature updated: ", V,S).

+ok : ph(PH) & temperature(TEMP) 
<- println("Current pH: ", PH, ", Current Temperature: ", TEMP).

+generated_values[artifact_id(S)] <- println("Generated working", S).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
