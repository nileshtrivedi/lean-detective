import Detective.Basic

inductive KnivesPerson | Harlan | Marta | Ransom | Richard
inductive KnivesLocation | Bedroom | Kitchen | Town
inductive KnivesItem | Poison | Knife

deriving instance DecidableEq for KnivesPerson
deriving instance DecidableEq for KnivesLocation
deriving instance DecidableEq for KnivesItem

open KnivesPerson KnivesLocation KnivesItem

def knivesPresence : KnivesPerson → KnivesLocation → Detective.DateTime → Prop
  -- At Midnight (Time of actual death)
  | Harlan,  Bedroom, ⟨120⟩ => True
  | Marta,   Kitchen, ⟨120⟩ => True -- She was sneaking downstairs
  | Ransom,  Town,    ⟨120⟩ => True -- Ransom has a rock-solid alibi for midnight
  | Richard, Town,    ⟨120⟩ => True
  -- At 10:00 PM (The Sabotage)
  | Ransom, Bedroom, ⟨100⟩ => True
  | _, _, _ => False

def knivesPossession : KnivesPerson → KnivesItem → Detective.DateTime → Prop
  -- The Poison Plot
  | Ransom, Poison, ⟨100⟩ => True -- Ransom swapped the vials earlier
  | Marta,  Poison, ⟨115⟩ => True -- Marta administered what she thought was poison
  -- The Actual Death
  | Harlan, Knife,  ⟨120⟩ => True -- Harlan took the knife to protect Marta
  | _, _, _ => False

def knivesMotive : KnivesPerson → KnivesPerson → Prop
  | Ransom,  Harlan => True -- He was cut out of the will
  | Richard, Harlan => True -- Harlan was going to expose his affair
  | Harlan,  Harlan => True -- To create a cover story and protect Marta
  | _, _ => False

def theThrombeyCase : Detective.CaseFile KnivesPerson KnivesLocation KnivesItem := {
  presence   := knivesPresence,
  possesses  := knivesPossession,
  hadMotive  := knivesMotive,
  crimeScene := {
    victim          := Harlan,
    location        := Bedroom,
    -- from 10:00 PM to Midnight, to include both the sabotage and suicide
    timeWindow      := { startTime := ⟨100⟩, endTime := ⟨120⟩, is_valid := by simp },
    -- We list both items as the potential murder weapon
    possibleWeapons := [Poison, Knife]
  }
}
