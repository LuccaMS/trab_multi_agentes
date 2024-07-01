!monitorar.

+!monitorar
  <- makeArtifact("sensor3", "artifacts.ConductivityArtifact", [], D);
     focus(D);
     println("Conductivity Agent initialized").

+!update_conductivity_belief(NewBelief)
  <- ?conductivity_belief(CurrentBelief);
     !remove_conductivity_belief(CurrentBelief);
     +conductivity_belief(NewBelief);
     !send_conductivity_belief(NewBelief).

+!remove_conductivity_belief(CurrentBelief)
  <- -conductivity_belief(CurrentBelief).

+!conductivity(V) : V < 100
  <- !update_conductivity_belief(low).
     //.print("ALERTA: NIVEIS DE CONDUTIVIDADE BAIXOS: ", V).

+!conductivity(V) : V >= 100 & V <= 500
  <- !update_conductivity_belief(normal).
     //.print("INFORME: NIVEIS DE CONDUTIVIDADE NORMAIS: ", V).

+!conductivity(V) : V > 500
  <- !update_conductivity_belief(high).
     //.print("ALERTA: NIVEIS DE CONDUTIVIDADE ALTOS: ", V).

+condOk[artifact_id(S)] : conductivity(CD)
  <- .print("Conductivity updated via condOk button: ", CD);
      !conductivity(CD).

+!send_conductivity_belief(Belief)
  <- .send(central_agent, achieve, update_conductivity_belief_central(Belief)).

+!return_CD_value: conductivity(CD)
  <- .send(central_agent, achieve, get_CD_value(CD)).

+!set_CD(Value)
  <- //.print("Setting conductivity to: ", Value);
     set_conductivity(Value). 

+!adjust_CD(Delta)
  <- ?conductivity(Value);
     NewValue = Value + Delta;
     //.print("Adjusting conductivity by: ", Delta , " to: ", NewValue);
     !set_CD(NewValue).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
