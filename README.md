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

## Background

I was looking for problem domains that use deductive reasoning and have both a high ceiling and a low floor, i.e. domains which can go really deep into the real, physical world, but also have toy versions that would be easier to model in Lean for me as a beginner. I thought about disputes and court cases. Can AI agents become actual judges at some point?

A court proceeding has 3 layers:

    - Establishing facts
    - Establishing legal conclusions
    - Incorporating wisdom and normative ethics for overriding legal conclusions appropriately.

The base layer, establishing facts in a court case, is already quite complex. So, I decided to build a Lean library that can be used to model criminal investigations, such as murder mysteries. The idea is to model persons and objects (such as weapons) and their spatio-temporal timelines - which is established only after considering unreliable clues and testimonies. I picked [Murdle puzzles](https://murdle.com/) as the toy versions of this. But a good target was to reach a place where we can model detective fiction like the movies Drishyam or Knives Out as Lean programs using my DSL. LLMs can easily convert informal narratives into formal, and Lean typechecker can then proof-check proposed conclusions.

It's fun, because we can choose to model as much of physics and math into our DSL as we'd like. For example, for checking alibis, we can model the physical world either as a graph of cities as discrete nodes for toy problems, or full ℝ^3 in cases where altitude plays a role. We can choose to model Time as a separate variable with LinearOrder, or we can use 4-d Spacetime from PhysLib, for more complex scenarios.

Criminal trials typically follow the MMO framework: Means, Motive and Opportunity. Out of these 3, Motives are the hardest to model in Lean, as it would involve modeling the emotional states of the agents, and a full world simulation in order to represent incentives. Currently, I have no idea how to go about tackling this aspect. But this is not a showstopper - because motives can be brought in as hypotheses.
