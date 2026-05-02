import Detective.Basic

-- 1. Define the specific domains for Drishyam (Hindi version)
inductive DPerson where
  | Vijay     -- The Father / Mastermind (Not present at the time of death)
  | Nandini   -- The Mother (Present, accessory after the fact)
  | Anju      -- The Daughter (The actual killer, self-defense)
  | Sam       -- The Blackmailer / Victim
  | Gaitonde  -- Corrupt Inspector (Investigator)
deriving Repr, DecidableEq, Inhabited

inductive DLocation where
  | SalgaonkarHouse  -- The Crime Scene (specifically the compost pit area)
  | CableOffice      -- Where Vijay was working during the incident
  | Panaji           -- The fake alibi location (Swami Chinmayananda Ashram/Cinema)
  | PoliceStation    -- Where the body is eventually hidden
deriving Repr, DecidableEq, Inhabited

inductive DItem where
  | MetalPipe  -- The weapon used to strike Sam
  | VideoPhone -- The motive (contains the blackmail material)
  | YellowCar  -- Sam's vehicle (disposed of by Vijay)
deriving Repr, DecidableEq, Inhabited

-- 2. Define the timeline for October 2nd (Gandhi Jayanti)
-- We'll use military time on Oct 2nd for simplicity: 22:00 to 23:00.
def octSecondNight : TimeRange := {
  startTime := { timestamp := 2200 }
  endTime   := { timestamp := 2300 }
  is_valid  := by decide
}


-- 3. Map out the Absolute Truth (Omniscient view)
def dPresence (p : DPerson) (l : DLocation) (t : Detective.DateTime) : Prop :=
  match p, l with
  -- Nandini and Anju are home when Sam arrives
  | DPerson.Anju, DLocation.SalgaonkarHouse => t.timestamp = 2230
  | DPerson.Nandini, DLocation.SalgaonkarHouse => t.timestamp = 2230
  | DPerson.Sam, DLocation.SalgaonkarHouse => t.timestamp = 2230

  -- Vijay is working a night shift at his cable office during the killing
  | DPerson.Vijay, DLocation.CableOffice => t.timestamp = 2230
  -- Vijay only returns to the house AFTER the crime (e.g., midnight)
  | DPerson.Vijay, DLocation.SalgaonkarHouse => t.timestamp = 2400

  | _, _ => False

def dPossesses (p : DPerson) (i : DItem) (t : Detective.DateTime) : Prop :=
  match p, i with
  -- Anju grabs the metal pipe during the struggle
  | DPerson.Anju, DItem.MetalPipe => t.timestamp = 2230
  -- Sam holds the phone with the video
  | DPerson.Sam, DItem.VideoPhone => t.timestamp = 2230
  -- Vijay later takes possession of Sam's phone and car to dispose of them
  | DPerson.Vijay, DItem.VideoPhone => t.timestamp = 2400
  | DPerson.Vijay, DItem.YellowCar => t.timestamp = 2400
  | _, _ => False

def dMotive (suspect : DPerson) (victim : DPerson) : Prop :=
  match suspect, victim with
  -- Anju is being actively blackmailed by Sam (Self-defense)
  | DPerson.Anju, DPerson.Sam => True
  -- Nandini wants to protect her daughter
  | DPerson.Nandini, DPerson.Sam => True
  -- Vijay also has motive to protect his family
  | DPerson.Vijay, DPerson.Sam => True
  | _, _ => False

-- 4. the CaseFile
def drishyamCaseFile : Detective.CaseFile DPerson DLocation DItem := {
  presence   := dPresence
  possesses  := dPossesses
  hadMotive  := dMotive
  crimeScene := {
    victim          := DPerson.Sam
    location        := DLocation.SalgaonkarHouse
    timeWindow      := octSecondNight
    possibleWeapons := [DItem.MetalPipe]
  }
}
