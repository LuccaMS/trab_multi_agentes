!monitor_sensor1.

+!monitor_sensor1
  <- makeArtifact("sensor1", "artifacts.SensorArtifact", [], D);
     focus(D);
     println("Agent initialized").

+ph(V) : V < 2.0 
  <- .print("ALERTA: NIVEIS DE PH EXTREMAMENTE ACIDOS: ", V);
  +ph_belief(extreme_acid);
  .abolish(ph_belief(_)).

+ph(V) : V >= 2.0 & V < 6.5
  <- .print("ALERTA: NIVEIS DE PH ACIDOS: ", V);
  +ph_belief(acid).

+ph(V) : V >= 6.5 & V < 8.5
  <- .print("INFORME: NIVEIS DE PH ACEITAVEIS: ", V);
  +ph_belief(normal).

+ph(V) : V > 8.5 & V <= 14.0
  <- .print("ALERT: NIVEIS DE PH BASICOS: ", V);
  +ph_belief(basic).

+ph(V) : V > 14.0
  <- .print("ERRO: NIVEIS DE PH FORA DE ESCALA: ", V);
  +ph_belief(out_of_scale).

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
