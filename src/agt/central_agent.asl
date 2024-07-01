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
+!decide_action: ph_belief(start) | conductivity_belief(start) | alkalinity_belief(start)
  <- .print("Erro: algum sensor ainda não foi iniciado").

+!decide_action
  <- ?ph(Value_ph);
     ?conductivity(Value_cd);
     ?alkalinity(Value_al);
     !evaluate_ph(Value_ph, Value_cd, Value_al);
     !evaluate_conductivity(Value_cd, Value_ph, Value_al);
     !evaluate_alkalinity(Value_al, Value_ph, Value_cd).

+!evaluate_ph(Value_ph, Value_cd, Value_al): Value_ph < 6.5
  <- .print("ALERTA: Níveis de pH ácidos: ", Value_ph);
     !increase_ph. 

+!evaluate_ph(Value_ph, Value_cd, Value_al): Value_ph > 8.5
  <- .print("ALERTA: Níveis de pH básicos: ", Value_ph);
     !decrease_ph.

+!evaluate_ph(Value_ph, Value_cd, Value_al): Value_ph >= 6.5 & Value_ph <= 8.5
  <- .print("Níveis de pH normais: ", Value_ph).

+!evaluate_conductivity(Value_cd, Value_ph, Value_al): Value_cd < 100
  <- .print("ALERTA: Níveis de condutividade baixos: ", Value_cd);
     !increase_conductivity.

+!evaluate_conductivity(Value_cd, Value_ph, Value_al): Value_cd > 500
  <- .print("ALERTA: Níveis de condutividade altos: ", Value_cd);
     !decrease_conductivity.

+!evaluate_conductivity(Value_cd, Value_ph, Value_al): Value_cd >= 100 & Value_cd <= 500
  <- .print("Níveis de condutividade normais: ", Value_cd).

+!evaluate_alkalinity(Value_al, Value_ph, Value_cd): Value_al < 40.0
  <- .print("ALERTA: Níveis de alcalinidade baixos: ", Value_al);
     !increase_alkalinity.

+!evaluate_alkalinity(Value_al, Value_ph, Value_cd): Value_al > 120.0
  <- .print("ALERTA: Níveis de alcalinidade altos: ", Value_al);
     !decrease_alkalinity.

+!evaluate_alkalinity(Value_al, Value_ph, Value_cd): Value_al >= 40.0 & Value_al <= 120.0
  <- .print("Níveis de alcalinidade normais: ", Value_al).

+!increase_ph
  <- .print("Aumentando pH");
     .send(ph_collector_agent,achieve,adjust_pH(0.5));
     !decrease_conductivity_by_ph.

+!decrease_ph
  <- .print("Diminuindo pH");
     .send(ph_collector_agent,achieve,adjust_pH(-0.5));
     !increase_conductivity_by_ph.

+!increase_conductivity_by_ph
  <- .print("Aumentando condutividade devido à diminuição de pH");
     .send(conductivity_collector_agent,achieve,adjust_CD(25)).

+!decrease_conductivity_by_ph
  <- .print("Diminuindo condutividade devido ao aumento de pH");
     .send(conductivity_collector_agent,achieve,adjust_CD(-25)).

+!increase_conductivity
  <- .print("Aumentando condutividade");
     .send(conductivity_collector_agent,achieve,adjust_CD(50));
     !increase_alkalinity_by_conductivity.

+!decrease_conductivity
  <- .print("Diminuindo condutividade");
     .send(conductivity_collector_agent,achieve,adjust_CD(-50));
     !decrease_alkalinity_by_conductivity.

+!increase_alkalinity_by_conductivity
  <- .print("Aumentando alcalinidade devido ao aumento de condutividade");
     .send(alkalinity_collector_agent,achieve,adjust_alkalinity(10)).

+!decrease_alkalinity_by_conductivity
  <- .print("Diminuindo alcalinidade devido à diminuição de condutividade");
     .send(alkalinity_collector_agent,achieve,adjust_alkalinity(-10)).

+!increase_alkalinity
  <- .print("Aumentando alcalinidade");
     .send(alkalinity_collector_agent,achieve,adjust_alkalinity(10));
     !increase_ph_by_alkalinity.

+!decrease_alkalinity
  <- .print("Diminuindo alcalinidade");
     .send(alkalinity_collector_agent,achieve,adjust_alkalinity(-10));
     !decrease_ph_by_alkalinity.

+!increase_ph_by_alkalinity
  <- .print("Aumentando pH devido ao aumento de alcalinidade");
     .send(ph_collector_agent,achieve,adjust_pH(0.2)).

+!decrease_ph_by_alkalinity
  <- .print("Diminuindo pH devido à diminuição de alcalinidade");
     .send(ph_collector_agent,achieve,adjust_pH(-0.2)).

/*
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
*/
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }