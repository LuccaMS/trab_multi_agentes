/*
!start.

+!start
  <- println("Central Agent started").

+received_ph_belief(Belief, Value)
  <- .print("Received pH belief: ", Belief, " with value: ", Value);
     ?update_pH(Belief, Value).

+received_alkalinity_belief(Belief, Value)
  <- .print("Received alkalinity belief: ", Belief, " with value: ", Value);
     ?update_alkalinity(Belief, Value).

+received_conductivity_belief(Belief, Value)
  <- .print("Received conductivity belief: ", Belief, " with value: ", Value);
     ?update_conductivity(Belief, Value).

+update_pH(Belief, Value) : Belief == "extreme_acid"
  <- .print("Taking action: neutralize extreme acidity");
     .send(pH_agent, tell, neutralize_acidity).

+update_pH(Belief, Value) : Belief == "acid"
  <- .print("Taking action: increase pH");
     .send(pH_agent, tell, neutralize_acidity).

+update_pH(Belief, Value) : Belief == "basic"
  <- .print("Taking action: decrease pH");
     .send(pH_agent, tell, neutralize_basicity).

+update_alkalinity(Belief, Value) : Belief == "low"
  <- .print("Taking action: increase alkalinity");
     .send(alkalinity_agent, tell, increase_alkalinity).

+update_alkalinity(Belief, Value) : Belief == "high"
  <- .print("Taking action: decrease alkalinity");
     .send(alkalinity_agent, tell, decrease_alkalinity).

+update_conductivity(Belief, Value) : Belief == "low"
  <- .print("Taking action: increase conductivity");
     .send(conductivity_agent, tell, increase_conductivity).

+update_conductivity(Belief, Value) : Belief == "high"
  <- .print("Taking action: decrease conductivity");
     .send(conductivity_agent, tell, decrease_conductivity).

// Actions to adjust pH, alkalinity, and conductivity
+neutralize_acidity
  <- .print("Neutralizing acidity");
     // Simulate increasing pH and its effects on other variables
     .send(pH_agent, tell, set_pH(7.0));
     // Rough estimation
     .send(alkalinity_agent, tell, set_alkalinity(50.0));
     .send(conductivity_agent, tell, set_conductivity(300.0)).

+neutralize_basicity
  <- .print("Neutralizing basicity");
     // Simulate decreasing pH and its effects on other variables
     .send(pH_agent, tell, set_pH(7.0));
     // Rough estimation
     .send(alkalinity_agent, tell, set_alkalinity(50.0));
     .send(conductivity_agent, tell, set_conductivity(300.0)).

+increase_alkalinity
  <- .print("Increasing alkalinity");
     // Simulate increasing alkalinity and its effects on other variables
     .send(alkalinity_agent, tell, set_alkalinity(100.0));
     // Rough estimation
     .send(pH_agent, tell, adjust_pH(0.5));
     .send(conductivity_agent, tell, adjust_conductivity(50.0)).

+decrease_alkalinity
  <- .print("Decreasing alkalinity");
     // Simulate decreasing alkalinity and its effects on other variables
     .send(alkalinity_agent, tell, set_alkalinity(50.0));
     // Rough estimation
     .send(pH_agent, tell, adjust_pH(-0.5));
     .send(conductivity_agent, tell, adjust_conductivity(-50.0)).

+increase_conductivity
  <- .print("Increasing conductivity");
     // Simulate increasing conductivity and its effects on other variables
     .send(conductivity_agent, tell, set_conductivity(500.0));
     // Rough estimation
     .send(pH_agent, tell, adjust_pH(0.2));
     .send(alkalinity_agent, tell, adjust_alkalinity(10.0)).

+decrease_conductivity
  <- .print("Decreasing conductivity");
     // Simulate decreasing conductivity and its effects on other variables
     .send(conductivity_agent, tell, set_conductivity(200.0));
     // Rough estimation
     .send(pH_agent, tell, adjust_pH(-0.2));
     .send(alkalinity_agent, tell, adjust_alkalinity(-10.0)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

*/


// CentralAgent.asl
!start.

+!start
  <- println("Central Agent started").

+!update_ph_belief_central(NewBelief)
  <- ?ph_belief(CurrentBelief);
     -ph_belief(CurrentBelief);
     +ph_belief(NewBelief);
     .print("Updated pH belief to: ", NewBelief);
     .send(ph_collector_agent,achieve,return_Ph_value).

+!get_ph_value(PH)
  <- ?ph(Value);
     -ph(Value);
     +ph(PH);
     .print("Received pH value: ", PH).

/*+received_ph_belief(Belief, Value)
  <- .print("Received belief: ", Belief, " with value: ", Value);
     !set_values(Value - 10).

+received_alkalinity_belief(Belief, Value)
  <- .print("Received belief: ", Belief, " with value: ", Value).

+received_conductivity_belief(Belief, Value)
  <- .print("Received belief: ", Belief, " with value: ", Value).*/

+!set_values(Value)
  <- .send(ph_collector_agent, achieve, set_pH(Value)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }