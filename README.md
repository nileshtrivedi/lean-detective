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

## Origin

This project was built during the **LeanLang for Verified
Autonomy Hackathon** (April 17–18 + online through May 1,
2026) at the **Indian Institute of Science (IISc),
Bangalore**.
Sponsored by **[Emergence AI](https://www.emergence.ai)**
Organized by **[Emergence India Labs]
(https://east.emergence.ai)** in collaboration with
**IISc Bangalore**.

## Acknowledgments
This project was made possible by:
- **Emergence AI** — Hackathon sponsor
- **Emergence India Labs** — Event organizer and
research direction
- **Indian Institute of Science (IISc), Bangalore** —
Academic partner, hackathon co-design, tutorials,
and mentorship

## Links
- [Hackathon Page](https://east.emergence.ai/
hackathon-april2026.html)
- [Emergence India Labs](https://east.emergence.ai)
- [Emergence AI](https://www.emergence.ai)