# Design Style Compass

## The short version

We are interested in a **compact, retro strategy-management game where the player rules a vulnerable society through menus, maps, reports, and difficult decisions**.

The presentation should evoke an unusually polished late-era Commodore 64 game: low-resolution pixel art, a limited palette, strong iconography, short text, simple animation, and atmospheric sound. The simulation may be deeper than the graphics suggest, but the player should interact with it through clear, finite choices rather than spreadsheet-heavy administration.

The desired feeling is:

> A small world with readable rules, scarce resources, human consequences, and enough systemic variation for every reign or expedition to tell a different story.

## What the references contribute

| Reference | Contribution to our direction |
|---|---|
| **Battle for Frost** | Clear turn-based tactics; small maps; meaningful terrain, supply, unit combinations, and resource-based production; substantial strategy expressed with compact visuals and controls. |
| **Rise of Babylon** | Focused settlement growth; limited space and time; city planning mixed with ruler decisions, events, and external threats; a short, replayable strategy-puzzle structure. |
| **Supremacy** | A ruler's dashboard; population, taxation, food, energy, minerals, colonization, and military pressure feeding one another; an ambitious world conveyed through discrete, attractive screens. |
| **The Tribe** | Survival as the central measure of success; a journey through a hostile landscape; resource pressure and difficult choices with visible life-or-death consequences for a community. |
| **Warsim** | Text and ASCII used as strengths; procedural factions, characters, locations, petitions, and events; freedom to rule through diplomacy, cruelty, curiosity, commerce, or war; strong emergent storytelling and humor. |
| **Khaldun: Text Based Strategy** | A society that changes underneath the player; economy, demographics, military composition, terrain, morale, advisors, loyalty, and political cohesion; prosperity creating new vulnerabilities rather than serving as a simple win meter. |

## Shared design DNA

### 1. The player is a ruler, not a unit

The player makes policy, allocation, diplomatic, logistical, and moral decisions. Individuals and military units matter, but the player's main identity is leader of a settlement, tribe, kingdom, or faction.

### 2. Strategy comes from interlocking pressures

Food, population, morale, wealth, security, loyalty, territory, and time should push against one another. A decision that improves one condition should often create a cost, risk, or delayed consequence elsewhere.

### 3. Decisions are few, legible, and consequential

The interface can be simple enough for a joystick or a handful of keys. Depth should emerge from the consequences and combinations of decisions, not from a large number of nearly identical commands.

### 4. The world answers back

Weather, rivals, terrain, scarcity, migration, advisors, internal factions, and unexpected events should prevent a perfect static build order. The game should produce stories through systemic reactions rather than long scripted scenes.

### 5. People are more than a resource counter

Population loss, hunger, displacement, loyalty, and survival should be tangible. Reports, names, portraits, short petitions, or memorial summaries can give human meaning to numerical changes.

### 6. Modest presentation, strong atmosphere

Use a limited palette, chunky pixels, icon-driven panels, compact maps, bitmap typography, sparse animation, and memorable music or sound cues. Retro is an aesthetic and interaction discipline, not a requirement to reproduce old hardware frustrations.

### 7. Sessions produce a history

A campaign or reign should create a concise chronicle: settlements founded, winters survived, factions betrayed, battles lost, reforms made, and causes of collapse. Failure should be interesting enough to invite another attempt.

## The intended blend

The likely core loop is:

1. Read a compact state report.
2. Inspect the map, settlement, people, and immediate threats.
3. Allocate scarce resources or issue a small number of orders.
4. Resolve a dilemma, petition, negotiation, or tactical encounter.
5. Advance time.
6. See short- and long-term consequences reshape the next turn.

The game should sit between:

- a survival journey and settlement manager;
- a kingdom or faction simulator;
- a light, map-based tactical game;
- and a procedural narrative generator.

## Style guardrails

- **Simple graphics, not shallow systems.**
- **Deep consequences, not constant micromanagement.**
- **Readable numbers, not opaque calculation.**
- **Short text with character, not walls of exposition.**
- **A focused initial scope, not Warsim-sized feature sprawl.**
- **Tactical conflict as one tool of rule, not the whole game.**
- **Retro immediacy, with modern clarity and convenience.**
- **Replayable variation, but not randomness that erases planning.**
- **Bittersweet, grounded stakes, with room for dry humor and wonder.**

## Working design statement

> A low-resolution strategy chronicle about leading a fragile people through scarcity and conflict. The player governs through compact menus, maps, petitions, and turn-based encounters. Every choice alters resources, relationships, and the society itself, producing a short but memorable history of survival, growth, compromise, or collapse.

