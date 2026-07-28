# Ashfall — Game Design Document

> Working draft v0.1 — Core development loop, resources, progression, and campaign goal

## 1. High concept

**Ashfall** is a compact, turn-based post-apocalyptic settlement strategy game about leading a fragile community from a temporary camp toward a lasting future.

The player governs through a settlement view, a regional route map, short reports, and consequential events. Each turn asks the player to balance immediate survival against long-term development. Growth is desirable, but every new resident, building, expedition, and alliance creates new needs and risks.

The intended campaign is short enough to replay. A completed run should leave behind a concise chronicle of who survived, what the settlement became, and what the player sacrificed to secure its future.

## 2. Design pillars

1. **Survival before expansion**  
   Water, food, shelter, and safety are never completely solved. Expansion makes these pressures more manageable but also increases demand.

2. **Few decisions with layered consequences**  
   A turn should contain a small number of important orders. Depth comes from timing, trade-offs, and delayed effects rather than constant micromanagement.

3. **People, not counters**  
   Population is the heart of the settlement. Deaths, arrivals, injuries, specialists, dissent, and departures should be visible in reports and events.

4. **The region matters**  
   The settlement cannot become self-sufficient in isolation. Scouting, salvage, trade, diplomacy, and threats connect city building to the regional map.

5. **Growth changes the game**  
   A larger settlement gains options but also attracts attention, develops internal factions, and needs more sophisticated infrastructure and government.

6. **Every run becomes a history**  
   Procedural sites, factions, crises, and legacy choices should produce different stories without making careful planning meaningless.

## 3. Core development loop

### 3.1 Campaign loop

The campaign repeatedly moves through five steps:

1. **Assess**  
   Read the settlement report: production, consumption, current shortages, morale, health, threats, and important messages.

2. **Plan**  
   Assign available people, choose construction or repair work, set rationing or policy, and prepare an expedition or diplomatic action.

3. **Commit**  
   Spend limited orders and resources. Most major actions take time, reserve workers, or expose people to risk.

4. **Resolve**  
   Expeditions, negotiations, events, production, consumption, injuries, migration, and hostile actions resolve.

5. **Adapt**  
   The map and settlement change. New shortages, opportunities, factions, and dilemmas shape the next turn.

In compact form:

**Read pressures → allocate people and supplies → build or reach outward → resolve consequences → grow into new pressures**

### 3.2 What the player normally does in one turn

The exact number is still to be tested, but a turn should usually allow:

- one major settlement project or upgrade;
- one regional action, such as scouting, scavenging, trading, negotiating, or attacking;
- workforce reassignment;
- one policy or event decision;
- then advancement of time.

The order limit is important. The player should not be able to optimize every problem simultaneously.

### 3.3 The three connected play spaces

#### Settlement

Build, repair, assign workers, manage capacity, and see the community physically change.

#### Region

Discover connected sites and factions, establish routes and outposts, gather scarce resources, and respond to threats.

#### Council

Handle petitions, policies, disputes, alliances, leadership questions, and the social consequences of survival decisions.

These are not separate mini-games. An expedition may discover a water plant, restoring it may require a settlement workshop, and control of it may provoke a neighboring faction or political dispute.

## 4. Resource model

The interface should distinguish between **stockpiles**, **people**, **capacities**, and **conditions**. This avoids turning every system into another spendable currency.

### 4.1 Core stockpiles

| Resource | Purpose | Main sources | Main pressures |
|---|---|---|---|
| **Water** | Daily survival; farming; some industry | wells, collectors, purification, regional sources, trade | population, drought, contamination, damaged infrastructure |
| **Food** | Daily survival and population health | gathering, farming, livestock, hunting, trade | population, spoilage, poor weather, pests |
| **Salvage** | Basic construction, repair, tools, and trade | ruins, scrapyards, dismantling, tribute, trade | buildings, repairs, defenses, equipment |
| **Fuel** | Long-range expeditions, generators, vehicles, and advanced projects | depots, refining, trade, rare salvage | travel, powered infrastructure, emergency generation |

Four stockpiles are enough for the initial design. Additional material types should be added only if playtesting proves that Salvage is doing too many jobs.

### 4.2 People

**Population** is both the community and the available workforce.

Residents may be:

- children or dependents;
- unassigned workers;
- assigned workers;
- specialists;
- injured or sick;
- away on expeditions;
- guards or militia.

The player cannot spend population like a normal resource. Assigning someone to one role makes them unavailable elsewhere, and risking them outside the settlement has human and economic consequences.

### 4.3 Capacities

Capacities are provided by buildings, equipment, and controlled sites:

- shelter;
- water production and storage;
- food production and storage;
- medical care;
- workshop capacity;
- defense;
- expedition range;
- power.

Capacity creates useful breakpoints. For example, having enough Food in storage is not sufficient if the settlement cannot produce enough each turn or protect it from spoilage.

### 4.4 Settlement conditions

These are status meters, not currencies the player directly spends:

| Condition | Meaning | Typical effects |
|---|---|---|
| **Health** | Nutrition, disease, injury, sanitation, and medical care | labor efficiency, mortality, recovery, population growth |
| **Cohesion** | Trust, morale, legitimacy, and willingness to cooperate | productivity, event choices, desertion, unrest, faction conflict |
| **Threat** | How exposed and attractive the settlement is to hostile forces | raids, demands, sabotage, escalation |

Threat should usually be shown by source—raiders, wildlife, contamination, or a rival faction—rather than only as one unexplained number.

### 4.5 Knowledge

**Knowledge** is proposed as unlock progress rather than a routinely spent stockpile. It is gained from specialists, recovered archives, faction exchange, and successful projects. Reaching a threshold unlocks a small choice of technologies or methods.

This keeps research readable and prevents the economy from gaining a fifth everyday currency.

## 5. Growth and progression

### 5.1 Settlement stages

Progression is divided into four stages. Advancement should require both a population range and completion of a defining project, so population alone cannot rush the game.

| Stage | Identity | New capabilities | New pressures |
|---|---|---|---|
| **I. Camp** | A group trying to survive | gathering, tents, water collection, short scavenging trips | exposure, hunger, illness, almost no reserve |
| **II. Settlement** | A permanent home | farming, workshop, clinic, storage, basic militia, migration | maintenance, sanitation, larger consumption, raids |
| **III. Township** | A regional power | specialists, outposts, trade routes, council factions, advanced defenses | politics, inequality, diplomacy, coordinated enemies |
| **IV. Haven** | A society choosing its future | major infrastructure and a legacy project | final crises, regional commitments, internal debate over the ending |

### 5.2 Population growth

Population increases mainly through **migration and rescued survivors** in the early campaign. Natural growth becomes meaningful only in longer campaigns.

Newcomers are attracted by:

- spare shelter;
- stable water and food;
- good health and cohesion;
- reputation;
- faction relationships;
- policies.

Growth slows or reverses when basic needs are unstable. Excess population without capacity should cause overcrowding, sickness, ration pressure, and dissent rather than an arbitrary hard cap.

New arrivals may bring skills, dependents, disputes, obligations, or enemies. This makes accepting migrants a strategic and moral decision rather than an automatic reward.

### 5.3 Development branches

At each stage, the player should choose a few developments from four broad branches:

- **Sustenance** — water security, farming, storage, medicine;
- **Industry** — repair, construction, power, vehicles, salvage efficiency;
- **Security** — scouting, fortification, militia, intelligence;
- **Society** — cohesion, education, diplomacy, migration, governance.

The player can mix branches, but cannot maximize all of them in one run. Buildings and policies should sometimes solve the same problem differently. For example, a water shortage might be answered by a new well, a trade agreement, strict rationing, or control of a regional pumping station.

### 5.4 Anti-snowball principle

Prosperity should create responsibility:

- more people consume more and require more shelter;
- valuable infrastructure attracts raids and political demands;
- specialists improve output but expect better conditions;
- outposts extend reach but need supply and protection;
- alliances provide help but create obligations;
- advanced power creates fuel and maintenance dependence.

The goal is not to punish success. It is to keep successful settlements strategically interesting.

## 6. Campaign goal

### 6.1 Recommended structure

The recommended campaign has a **finite survival horizon plus a chosen legacy project**.

The player must keep the settlement alive through a known period of worsening regional conditions. Before the final deadline, the community must commit to and complete one path toward a durable future.

Possible legacy paths:

1. **The Green Haven**  
   Restore a regional water system and create a self-sustaining agricultural settlement. Focus: Sustenance, population health, and cooperation.

2. **The Network**  
   Unite several settlements through trade, radio, and mutual defense. Focus: diplomacy, routes, reputation, and cohesion.

3. **The Iron Refuge**  
   Build a heavily defended, powered stronghold capable of surviving the coming crisis alone. Focus: industry, fuel, salvage, and security.

Each path changes the final crises, required allies or enemies, and epilogue. None should be presented as the universally “good” ending.

### 6.2 Why the campaign should have a clear ending

A defined ending fits the compact inspirations better than endless city growth:

- scarcity can remain meaningful;
- balance does not need to support infinite economic expansion;
- the player can take risks because the finish line is visible;
- a run produces a complete story;
- multiple legacy paths create replayability;
- the game remains feasible for a small development scope.

An endless mode could be added later, but it should not determine the initial design.

### 6.3 Victory and failure

**Victory requires:**

- surviving the final regional crisis;
- completing one legacy project;
- retaining a viable minimum population;
- avoiding complete social collapse.

**A run ends in failure when:**

- no viable population remains;
- the settlement is permanently abandoned or destroyed;
- cohesion collapses into an irreversible overthrow or dispersal;
- the final deadline arrives without a viable legacy.

Many severe setbacks should remain recoverable. A food shortage, lost expedition, or raid should create a difficult chapter, not automatically end the run.

### 6.4 Campaign length to prototype

Prototype target: **40 turns**, divided into four chapters of 10 turns.

Each chapter introduces a new layer:

1. survive and establish the camp;
2. secure local production and explore the region;
3. manage factions, routes, and regional threats;
4. build the legacy project and face the final crisis.

The fiction represented by one turn—days, weeks, or a season—should be chosen after testing expedition pacing and population growth. Mechanical clarity matters more than a literal calendar at this stage.

## 7. Initial playable scope

The first prototype should test the development loop, not the full content vision.

Include:

- one settlement;
- a small connected regional map;
- four stockpiles;
- population assignment;
- five to eight building types;
- scouting and scavenging expeditions;
- one neutral faction and one hostile threat;
- a small event deck;
- two settlement stages;
- one simplified legacy objective;
- a short 12–16 turn scenario.

Delay:

- tactical battle maps;
- detailed individual simulation;
- multiple settlements under direct control;
- large technology trees;
- extensive diplomacy;
- more than one vehicle type;
- endless mode.

## 8. Questions still to decide

1. Is **Ashfall** the intended game title or only a visual-concept codename?
2. Is the fantasy primarily **rebuilding in one place**, or should eventual migration remain a possible outcome?
3. How harsh should the tone be: hopeful reconstruction, bleak survival, or a balance of both?
4. Should conflict resolve through compact strategic choices, or eventually use a small tactical battle screen inspired by *Battle for Frost*?
5. Should the regional catastrophe be known from the start, gradually discovered, or different in every campaign?

## 9. Current design recommendation

Build the game around **Water, Food, Salvage, Fuel, and People**. Track **Health, Cohesion, and visible threats** as conditions. Let the settlement advance from **Camp → Settlement → Township → Haven**, with each stage unlocking options and adding obligations.

Use a **40-turn finite campaign** in which the player survives escalating pressure and completes one of several **legacy projects**. This gives Ashfall a clear purpose beyond simply making numbers rise: the player is deciding what kind of society deserves to survive.
