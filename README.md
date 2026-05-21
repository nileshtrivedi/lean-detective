# detective

This is a Lean Library that can assist with deductive reasoning in crime investigations such as murder mysteries.

Users of this library need to provide types for Person, Item and Location
They also need to bring presence history, posession history and motives for all persons.

A PhysicsModel is used in conjunction with credible alibi to reject impossible scenarios such as infeasible travel speeds.

To identify the prime suspect, 3 things are required: presence at the scene, posession of a possible weapon, and motive.

GOAL: Model these stories and formally verify conclusions, building up the physics model and epistemology model in the process.
 - [Murdle Puzzles](Detective/Murdle.lean)
 - [Knives Out](Detective/KnivesOut.lean)
 - [Drishyam](Detective/Drishyam.lean)

