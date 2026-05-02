import Detective.Basic

-- Here is the puzzle: https://github.com/user-attachments/assets/53a00d94-c5ba-46d6-bfb1-f224ad84e282

-- 1. Define the specific domains for Murdle: The Art of the Kill
inductive MurdlePerson where
  | Artist      -- The Victim
  | Slate       -- Captain Slate (Suspect)
  | Azure       -- Bishop Azure (Suspect)
  | Blackstone  -- Blackstone, Esq. (Suspect)
deriving Repr, DecidableEq, Inhabited

inductive MurdleLocation where
  | RooftopGarden
  | EntryHall       -- The Crime Scene
  | ArtStudio
deriving Repr, DecidableEq, Inhabited

inductive MurdleItem where
  | PoisonedWine
  | AbstractStatue
  | RareVase
deriving Repr, DecidableEq, Inhabited

-- 2. Define a generic timeline for the puzzle
-- Murdle puzzles don't rely on strict timestamps, so we use a single point in time.
def murderTime : Detective.TimeRange := {
  startTime := { timestamp := 1200 }
  endTime   := { timestamp := 1200 }
  is_valid  := by decide
}

-- 3. Construct the Crime Scene
def murdleCrimeScene : Detective.CrimeScene MurdlePerson MurdleLocation MurdleItem := {
  victim          := MurdlePerson.Artist
  location        := MurdleLocation.EntryHall
  timeWindow      := murderTime
  -- Any of the three items could potentially be the murder weapon at the start
  possibleWeapons := [MurdleItem.PoisonedWine, MurdleItem.AbstractStatue, MurdleItem.RareVase]
}

-- 4. Map out the Deducted Truth (Omniscient view)
def mPresence (p : MurdlePerson) (l : MurdleLocation) (t : Detective.DateTime) : Prop :=
  match p, l with
  -- The victim is found at the scene
  | MurdlePerson.Artist, MurdleLocation.EntryHall => t.timestamp = 1200

  -- Suspect Locations derived from clues
  | MurdlePerson.Slate, MurdleLocation.EntryHall => t.timestamp = 1200
  | MurdlePerson.Azure, MurdleLocation.RooftopGarden => t.timestamp = 1200
  | MurdlePerson.Blackstone, MurdleLocation.ArtStudio => t.timestamp = 1200
  | _, _ => False

def mPossesses (p : MurdlePerson) (i : MurdleItem) (t : Detective.DateTime) : Prop :=
  match p, i with
  -- Weapon possessions derived from clues
  | MurdlePerson.Slate, MurdleItem.PoisonedWine => t.timestamp = 1200
  | MurdlePerson.Azure, MurdleItem.AbstractStatue => t.timestamp = 1200
  | MurdlePerson.Blackstone, MurdleItem.RareVase => t.timestamp = 1200
  | _, _ => False

def mMotive (suspect : MurdlePerson) (victim : MurdlePerson) : Prop :=
  match suspect, victim with
  -- In a standard Murdle logic puzzle, we assume all suspects have theoretical motive,
  -- and elimination is purely based on means and opportunity.
  | MurdlePerson.Slate, MurdlePerson.Artist => True
  | MurdlePerson.Azure, MurdlePerson.Artist => True
  | MurdlePerson.Blackstone, MurdlePerson.Artist => True
  | _, _ => False

-- 5. Compile the Official CaseFile
def murdleCaseFile : Detective.CaseFile MurdlePerson MurdleLocation MurdleItem := {
  presence   := mPresence
  possesses  := mPossesses
  hadMotive  := mMotive
  crimeScene := murdleCrimeScene
}
