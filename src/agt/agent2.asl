!monitor_sensor2.

+!monitor_sensor2
  <- makeArtifact("sensor2", "artifacts.Sensor2Artifact", [], D);
     focus(D);
     println("Agent2 initialized").

+ph(V) : V >= 6.0 & V <= 14.0
  <- .print("pH updated: ", V).

+ph(V) : V < 6.0
  <- .print("ALERT: Low pH level detected: ", V).

+ph(V) : V > 14.0
  <- .print("Something might be wrong with the sensor, pH out of scale: ", V).

+temperature(V) : V >= 10 & V <= 30.0
  <- .print("Temperature updated: ", V).

+temperature(V) : V < 10.0
  <- .print("Low temperature detected: ", V).

+temperature(V) : V > 30.0
  <- .print("High temperature detected: ", V).

+ok[artifact_id(S)] : ph(PH) & temperature(TEMP)
  <- .print("Current pH: ", PH, ", Current Temperature: ", TEMP).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
