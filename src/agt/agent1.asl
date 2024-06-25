!monitor_sensor1.

+!monitor_sensor1
  <- makeArtifact("sensor1", "artifacts.SensorArtifact", [], D);
     focus(D);
     println("Agent initialized").

+!update_ph_belief(NewBelief)
  <- ?ph_belief(CurrentBelief);
     !remove_ph_belief(CurrentBelief);
     +ph_belief(NewBelief).

+!remove_ph_belief(CurrentBelief)
  <- -ph_belief(CurrentBelief).

+ph(V) : V < 2.0 & V >= 0.0
  <- !update_ph_belief(extreme_acid);
     .print("ALERTA: NIVEIS DE PH EXTREMAMENTE ACIDOS: ", V).

+ph(V) : V >= 2.0 & V < 6.5
  <- !update_ph_belief(acid);
     .print("ALERTA: NIVEIS DE PH ACIDOS: ", V).

+ph(V) : V >= 6.5 & V < 8.5
  <- !update_ph_belief(normal);
     .print("INFORME: NIVEIS DE PH ACEITAVEIS: ", V).

+ph(V) : V > 8.5 & V <= 14.0
  <- !update_ph_belief(basic);
     .print("ALERTA: NIVEIS DE PH BASICOS: ", V).

+ph(V) : V > 14.0 | V < 0.0
  <- !update_ph_belief(out_of_scale);
    .print("Something might be wrong with the sensor, pH out of scale: ", V).

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
