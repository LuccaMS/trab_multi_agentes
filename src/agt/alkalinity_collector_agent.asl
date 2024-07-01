!monitorar.
//alkalinity_belief(normal).

+!monitorar
  <- makeArtifact("sensor2", "artifacts.AlkalinityArtifact", [], D);
     focus(D);
     println("Alkalinity Agent initialized").

+!update_alkalinity_belief(NewBelief)
  <- ?alkalinity_belief(CurrentBelief);
     !remove_alkalinity_belief(CurrentBelief);
     +alkalinity_belief(NewBelief);
     !send_alkalinity_belief(NewBelief).

+!remove_alkalinity_belief(CurrentBelief)
  <- -alkalinity_belief(CurrentBelief).

+!alkalinity(V) : V < 40.0
  <- !update_alkalinity_belief(low).
     //.print("ALERTA: NIVEIS DE ALCALINIDADE BAIXOS: ", V).

+!alkalinity(V) : V >= 40.0 & V <= 120.0
  <- !update_alkalinity_belief(normal).
     //.print("INFORME: NIVEIS DE ALCALINIDADE NORMAIS: ", V).

+!alkalinity(V) : V > 120.0
  <- !update_alkalinity_belief(high).
     //.print("ALERTA: NIVEIS DE ALCALINIDADE ALTOS: ", V).

+alkOk[artifact_id(S)] : alkalinity(AL)
  <- .print("Alkalinity updated via alkOk button: ", AL);
      !alkalinity(AL).

+!send_alkalinity_belief(Belief)
  <- .send(central_agent, achieve, update_alkalinity_belief_central(Belief)).

+!return_alkalinity_value: alkalinity(AL)
  <- .send(central_agent, achieve, get_alkalinity_value(AL)).

+!set_alkalinity(Value)
  <- //.print("Setting alkalinity to: ", Value);
      set_alkalinity(Value).

+!adjust_alkalinity(Delta)
  <- ?alkalinity(Value);
     NewValue = Value + Delta;
     //.print("Adjusting alkalinity by: ", Delta , " to: ", NewValue);
     !set_alkalinity(NewValue).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
