// CentralAgent.asl
!start.

+!start
  <- println("Central Agent started").

+received_ph_belief(Belief, Value) 
  <- .print("Received belief: ", Belief, " with value: ", Value).

+received_alkalinity_belief(Belief, Value)
  <- .print("Received belief: ", Belief, " with value: ", Value).

+received_conductivity_belief(Belief, Value)
  <- .print("Received belief: ", Belief, " with value: ", Value).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }