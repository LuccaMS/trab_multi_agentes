
!test_sensor_gui.

+!test_sensor_gui
  <- makeArtifact("sensor", "artifacts.SensorArtifact", [], D);
     //makeArtifact("sensor2", "artifacts.SensorArtifact", [], I);
     focus(D);
     //focus(I);
     println("Sensor GUI initialized").

+ph(V)
  <- println("pH updated: ", V).

+temperature(V)
  <- println("Temperature updated: ", V).

+ok[artifact_id(S)] : ph(PH) & temperature(TEMP)
  <- .print("Current pH: ", PH, ", Current Temperature: ", TEMP).
     //setSensorData(PH + 0.1, TEMP + 0.5)[artifact_id(S)].

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
