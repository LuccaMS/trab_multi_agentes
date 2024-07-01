!monitorar.

+!monitorar
  <- makeArtifact("sensor1", "artifacts.phArtifact", [], D);
     focus(D);
     println("Ph Agent initialized").

+!update_ph_belief(NewBelief)
  <- ?ph_belief(CurrentBelief);
     !remove_ph_belief(CurrentBelief);
     +ph_belief(NewBelief);
     !send_ph_belief(NewBelief).

+!remove_ph_belief(CurrentBelief)
  <- -ph_belief(CurrentBelief).

+!ph(V) : V < 2.0 & V >= 0.0
  <- !update_ph_belief(extreme_acid).
     //.print("ALERTA: NIVEIS DE PH EXTREMAMENTE ACIDOS: ", V).

+!ph(V) : V >= 2.0 & V < 6.5
  <- !update_ph_belief(acid).
     //.print("ALERTA: NIVEIS DE PH ACIDOS: ", V).

+!ph(V) : V >= 6.5 & V < 8.5
  <- !update_ph_belief(normal).
     //.print("INFORME: NIVEIS DE PH ACEITAVEIS: ", V).

+!ph(V) : V > 8.5 & V <= 14.0
  <- !update_ph_belief(basic).
     //.print("ALERTA: NIVEIS DE PH BASICOS: ", V).

+!ph(V) : V > 14.0 | V < 0.0
  <- !update_ph_belief(out_of_scale).
    //.print("Something might be wrong with the sensor, pH out of scale: ", V).

+phOk[artifact_id(S)] : ph(PH)
  <- .print("pH updated via phOk button: ", PH);
      !ph(PH).

+!send_ph_belief(Belief)
  <- .send(central_agent, achieve, update_ph_belief_central(Belief)).

+!return_Ph_value: ph(PH)
  <- .send(central_agent, achieve, get_ph_value(PH)).

+!set_pH(Value)
  <- //.print("Setting pH to: ", Value);
     setPH(Value).

+!adjust_pH(Delta)
  <- ?ph(Value);
     NewValue = Value + Delta;
     //.print("Adjusting pH by: ", Delta , " to: ", NewValue);
     !set_pH(NewValue).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
