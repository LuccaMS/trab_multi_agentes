// CentralAgent.asl
!start.

+!start
  <- println("Central Agent started").

+!update_ph_belief_central(NewBelief)
  <- ?ph_belief(CurrentBelief_ph);
     -ph_belief(CurrentBelief_ph);
     +ph_belief(NewBelief);
     .print("Updated pH belief to: ", NewBelief);
     .send(ph_collector_agent,achieve,return_Ph_value).

+!get_ph_value(PH)
  <- ?ph(Value);
     -ph(Value);
     +ph(PH);
     .print("Received pH value: ", PH);
      !decide_action.

+!update_conductivity_belief_central(NewBelief)
  <- ?conductivity_belief(CurrentBelief_cd);
     -conductivity_belief(CurrentBelief_cd);
     +conductivity_belief(NewBelief);
     .print("Updated conductivity belief to: ", NewBelief);
     .send(conductivity_collector_agent,achieve,return_CD_value).

+!get_CD_value(CD)
  <- ?conductivity(Value);
     -conductivity(Value);
     +conductivity(CD);
     .print("Received conductivity value: ", CD);
     !decide_action.

+!update_alkalinity_belief_central(NewBelief)
  <- ?alkalinity_belief(CurrentBelief_al);
     -alkalinity_belief(CurrentBelief_al);
     +alkalinity_belief(NewBelief);
     .print("Updated alkalinity belief to: ", NewBelief);
     .send(alkalinity_collector_agent,achieve,return_alkalinity_value).

+!get_alkalinity_value(AL)
  <- ?alkalinity(Value);
     -alkalinity(Value);
     +alkalinity(AL);
     .print("Received alkalinity value: ", AL);
     !decide_action.

//Caso algum dos sensores não tenha sido iniciado ainda está no estado inicial então não vamos tomar ações
+!decide_action(Value_ph, Value_cd, Value_al): ph_belief(start) | conductivity_belief(start) | alkalinity_belief(start)
  <- .print("Erro: algum sensor ainda não foi iniciado").

+!decide_action: ph < 6.5 & conductivity < 100
  <- !increase_ph;
     !increase_conductivity.

+!decide_action: ph > 8.5 & conductivity > 500
  <- !decrease_ph;
     !decrease_conductivity.

+!decide_action: alkalinity < 40.0
  <- !increase_alkalinity.

+!decide_action: alkalinity > 120.0
  <- !decrease_alkalinity.

+!increase_ph
  <- .print("Increasing pH");
     .send(ph_collector_agent,achieve,adjust_pH(0.5)).

+!decrease_ph
  <- .print("Decreasing pH");
     .send(ph_collector_agent,achieve,adjust_pH(-0.5)).

+!increase_conductivity
  <- .print("Increasing conductivity");
     .send(conductivity_collector_agent,achieve,adjust_CD(50)).

+!decrease_conductivity
  <- .print("Decreasing conductivity");
     .send(conductivity_collector_agent,achieve,adjust_CD(-50)).

+!increase_alkalinity
  <- .print("Increasing alkalinity");
    .send(alkalinity_collector_agent,achieve,adjust_alkalinity(10)).

+!decrease_alkalinity
  <- .print("Decreasing alkalinity");
     .send(alkalinity_collector_agent,achieve,adjust_alkalinity(-10)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }