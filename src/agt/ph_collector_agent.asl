!monitorar.
ph_belief(normal).

+!monitorar
  <- makeArtifact("sensor1", "artifacts.phArtifact", [], D);
     focus(D);
     println("Ph Agent initialized").

+!update_ph_belief(NewBelief, Value)
  <- ?ph_belief(CurrentBelief);
     !remove_ph_belief(CurrentBelief);
     +ph_belief(NewBelief);
     //!send_ph_belief(NewBelief, Value).
     !send_ph_belief(NewBelief).

+!remove_ph_belief(CurrentBelief)
  <- -ph_belief(CurrentBelief).

+!ph(V) : V < 2.0 & V >= 0.0
  <- !update_ph_belief(extreme_acid, V);
     .print("ALERTA: NIVEIS DE PH EXTREMAMENTE ACIDOS: ", V).
     //!send_ph_belief(extreme_acid, V).

+!ph(V) : V >= 2.0 & V < 6.5
  <- !update_ph_belief(acid, V);
     .print("ALERTA: NIVEIS DE PH ACIDOS: ", V).
     //!send_ph_belief(acid, V).

+!ph(V) : V >= 6.5 & V < 8.5
  <- !update_ph_belief(normal, V);
     .print("INFORME: NIVEIS DE PH ACEITAVEIS: ", V).
     //!send_ph_belief(normal, V).

+!ph(V) : V > 8.5 & V <= 14.0
  <- !update_ph_belief(basic, V); 
     .print("ALERTA: NIVEIS DE PH BASICOS: ", V).
      //!send_ph_belief(basic, V).

+!ph(V) : V > 14.0 | V < 0.0
  <- !update_ph_belief(out_of_scale, V);
    .print("Something might be wrong with the sensor, pH out of scale: ", V).
    //!send_ph_belief(out_of_scale, V).

+phOk[artifact_id(S)] : ph(PH)
  <- .print("pH updated via phOk button: ", PH);
      !ph(PH).

+!send_ph_belief(Belief)
  <- //.send(central_agent, tell, ph_belief(Belief)).
  .send(central_agent, achieve, update_ph_belief_central(Belief)).

+!set_pH(Value)
  <- .print("Setting pH to: ", Value);
     setPH(Value).

+!adjust_pH(Delta)
  <- ?ph(Value);
     NewValue = Value + Delta;
     .print("Adjusting pH by: ", Delta , " to: ", NewValue);
     !set_pH(NewValue).

/*
+!set_pH(Value)
  <- .print("Setting pH to: ", Value);
     .my_name(Me);
     focus(sensor);
     .set_obs_property("ph", Value).

+!adjust_pH(Delta)
  <- ?ph(Value);
     NewValue = Value + Delta;
     !set_pH(NewValue).*/


+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
