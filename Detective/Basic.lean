/-
This is a Lean Library that can assist with deductive reasoning in crime investigations.
Users of this library need to provide types for Agent, Item and Location
They also need to bring presence history, posession history and motives for all agents

A PhysicsModel is used in conjunction with credible alibi to reject impossible scenarios such as infeasible travel speeds

To identify the prime suspect, 3 things are required: presence at the scene, posession of weapon, and motive

GOAL: Model these stories and formally verify conclusions, building up the physics model and epistemology model in the process.
 - Murdle puzzles: (1) Easy (Suspects, Weapons and Locations) (2) Hard (Statements and Motives)
 - Detective stories: Sherlock Holmes
 - Movies: Knives Out, Drishyam
-/

namespace Detective
  variable {Person Item Location : Type}

  structure DateTime where
   timestamp : Nat
  deriving Repr, DecidableEq, Inhabited

  structure TimeRange where
    startTime : DateTime
    endTime   : DateTime
    is_valid  : startTime.timestamp ≤ endTime.timestamp

  def TimeRange.contains (r : TimeRange) (t : DateTime) : Prop :=
    r.startTime.timestamp ≤ t.timestamp ∧ t.timestamp ≤ r.endTime.timestamp

  structure CrimeScene (Person Location Item : Type) where
    victim          : Person
    location        : Location
    timeWindow      : TimeRange
    possibleWeapons : List Item

  structure PhysicsModel (Presence : Person → Location → DateTime → Prop) : Type where
    -- no Person can be in multiple distinct locations at the same time
    single_location : ∀ (p : Person) (t : DateTime) (l1 l2 : Location),
      Presence p l1 t → Presence p l2 t → l1 = l2

    min_travel_time : Location → Location → Nat

    -- Persons cannot teleport or travel faster than physical limits
    speed_limit : ∀ (p : Person) (t1 t2 : DateTime) (l1 l2 : Location),
      l1 ≠ l2 →
      Presence p l1 t1 → Presence p l2 t2 → t1.timestamp < t2.timestamp →
      (t2.timestamp - t1.timestamp) ≥ min_travel_time l1 l2

  structure CaseFile (Person Location Item : Type) where
    presence  : Person → Location → DateTime → Prop
    possesses : Person → Item → DateTime → Prop
    hadMotive : Person → Person → Prop
    crimeScene: CrimeScene Person Location Item

  section Investigation
    variable (cf : CaseFile Person Location Item)

    -- DecidableEq not needed for pure Prop reasoning
    def HadOpportunity (p : Person) : Prop :=
      ∃ t : DateTime, cf.crimeScene.timeWindow.contains t ∧ cf.presence p cf.crimeScene.location t

    def HasAlibi (p : Person): Prop :=
      ∀ t : DateTime, cf.crimeScene.timeWindow.contains t → ∃ otherLoc : Location, otherLoc ≠ cf.crimeScene.location ∧ cf.presence p otherLoc t

    theorem alibi_means_no_opportunity
      (pm : PhysicsModel cf.presence)
      (p : Person)
      (alibi : HasAlibi cf p) :
      ¬ HadOpportunity cf p := by
      intro ⟨t, hcontains, hpresence⟩
      obtain ⟨otherLoc, hneq, hother⟩ := alibi t hcontains
      exact hneq (pm.single_location p t otherLoc cf.crimeScene.location hother hpresence)

    -- DecidableEq needed here for List.mem in possibleWeapons
    variable [DecidableEq Person] [DecidableEq Location] [DecidableEq Item]

    def HadMeans (p : Person) : Prop :=
      ∃ t : DateTime,
        cf.crimeScene.timeWindow.startTime.timestamp ≤ t.timestamp ∧
        t.timestamp ≤ cf.crimeScene.timeWindow.endTime.timestamp ∧
        ∃ w, w ∈ cf.crimeScene.possibleWeapons ∧ cf.possesses p w t

    def IsPrimeSuspect (p : Person) : Prop :=
      -- suspect = presence at the crime scene AND access to suspected weapon at the time AND has motive
      -- Q: Can the victim himself be the prime suspect?
      -- Q: Is prime suspect unique?
      (HadOpportunity cf p) ∧ (HadMeans cf p) ∧ cf.hadMotive p cf.crimeScene.victim

    def IsUniqueKiller (cf : CaseFile Person Location Item) (killer : Person) : Prop :=
      IsPrimeSuspect cf killer ∧ ∀ p : Person, IsPrimeSuspect cf p → p = killer

    omit [DecidableEq Person] [DecidableEq Location] [DecidableEq Item] in
    theorem unique_killer_from_elimination
      (cf       : CaseFile Person Location Item)
      (suspects : List Person)
      (killer   : Person)
      (hprime   : IsPrimeSuspect cf killer)
      (hclosed  : ∀ p : Person, IsPrimeSuspect cf p → p ∈ suspects)
      (helim    : ∀ p ∈ suspects, p ≠ killer → ¬ IsPrimeSuspect cf p) :
      IsUniqueKiller cf killer := by
    constructor
    · exact hprime
    · intro p hp
      apply Classical.byContradiction
      intro hne
      exact helim p (hclosed p hp) hne hp

  end Investigation
end Detective
