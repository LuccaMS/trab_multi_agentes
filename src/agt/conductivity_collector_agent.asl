!monitorar.
conductivity_belief(normal).

+!monitorar
  <- makeArtifact("sensor3", "artifacts.ConductivityArtifact", [], D);
     focus(D);
     println("Conductivity Agent initialized").

+!update_conductivity_belief(NewBelief, Value)
  <- ?conductivity_belief(CurrentBelief);
     !remove_conductivity_belief(CurrentBelief);
     +conductivity_belief(NewBelief);
     !send_conductivity_belief(NewBelief, Value).

+!remove_conductivity_belief(CurrentBelief)
  <- -conductivity_belief(CurrentBelief).

+conductivity(V) : V < 100
  <- !update_conductivity_belief(low, V);
     .print("ALERTA: NIVEIS DE CONDUTIVIDADE BAIXOS: ", V).

+conductivity(V) : V >= 100 & V <= 500
  <- !update_conductivity_belief(normal, V);
     .print("INFORME: NIVEIS DE CONDUTIVIDADE NORMAIS: ", V).

+conductivity(V) : V > 500
  <- !update_conductivity_belief(high, V);
     .print("ALERTA: NIVEIS DE CONDUTIVIDADE ALTOS: ", V).

+condOk[artifact_id(S)] : conductivity(CD)
  <- .print("Conductivity updated via condOk button: ", CD).

+!send_conductivity_belief(Belief, Value)
  <- .send(central_agent, tell, received_conductivity_belief(Belief, Value)).

+closed
  <- .print("Close");
     .my_name(Me);
     .kill_agent(Me).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
