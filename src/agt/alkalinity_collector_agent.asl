!monitorar.
alkalinity_belief(normal).

+!monitorar
  <- makeArtifact("sensor2", "artifacts.AlkalinityArtifact", [], D);
     focus(D);
     println("Alkalinity Agent initialized").

+!update_alkalinity_belief(NewBelief, Value)
  <- ?alkalinity_belief(CurrentBelief);
     !remove_alkalinity_belief(CurrentBelief);
     +alkalinity_belief(NewBelief);
     !send_alkalinity_belief(NewBelief, Value).

+!remove_alkalinity_belief(CurrentBelief)
  <- -alkalinity_belief(CurrentBelief).

+alkalinity(V) : V < 40.0
  <- !update_alkalinity_belief(low, V);
     .print("ALERTA: NIVEIS DE ALCALINIDADE BAIXOS: ", V).

+alkalinity(V) : V >= 40.0 & V <= 120.0
  <- !update_alkalinity_belief(normal, V);
     .print("INFORME: NIVEIS DE ALCALINIDADE NORMAIS: ", V).

+alkalinity(V) : V > 120.0
  <- !update_alkalinity_belief(high, V);
     .print("ALERTA: NIVEIS DE ALCALINIDADE ALTOS: ", V).

+alkOk[artifact_id(S)] : alkalinity(AL)
  <- .print("Alkalinity updated via alkOk button: ", AL).

+!send_alkalinity_belief(Belief, Value)
  <- .send(central_agent, tell, received_alkalinity_belief(Belief, Value)).


+!set_alkalinity(Value)
  <- .print("Setting alkalinity to: ", Value);
     .my_name(Me);
     focus(sensor);
     .set_obs_property("alkalinity", Value).

+!adjust_alkalinity(Delta)
  <- ?alkalinity(Value);
     NewValue = Value + Delta;
     !set_alkalinity(NewValue).


+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
