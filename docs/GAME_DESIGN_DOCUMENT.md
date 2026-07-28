# Ashfall — Game Design Document

> Working draft v0.4 — Core development loop, resources, progression, controls, and campaign goal

## 1. High concept

**Ashfall** is a compact, turn-based post-apocalyptic settlement strategy game about leading a fragile community from a temporary camp toward a lasting future.

The player governs through a settlement view, a regional route map, short reports, and consequential events. Each turn asks the player to balance immediate survival against long-term development. Growth is desirable, but every new resident, building, expedition, and alliance creates new needs and risks.

The intended campaign is short enough to replay. A completed run should leave behind a concise chronicle of who survived, what the settlement became, and what the player sacrificed to secure its future.

## 2. Design pillars

1. **Survival before expansion**  
   Water, food, shelter, and safety are never completely solved. Expansion makes these pressures more manageable but also increases demand.

2. **Few decisions with layered consequences**  
   A turn should contain a small number of important orders. Depth comes from timing, trade-offs, and delayed effects rather than constant micromanagement.

3. **Population with human consequences**
   Population is managed at the level of a society through readable totals and workforce assignments, not as simulated individuals. Deaths, arrivals, injuries, dissent, and departures should still be visible in reports, events, and the campaign chronicle.

4. **The region matters**  
   The settlement cannot become self-sufficient in isolation. Scouting, scavenging, trade, diplomacy, and threats connect city building to the regional map.

5. **Growth changes the game**  
   A larger settlement gains options but also attracts attention, develops internal factions, and needs more sophisticated infrastructure and government.

6. **Every run becomes a history**  
   Procedural sites, factions, crises, and legacy choices should produce different stories without making careful planning meaningless.

## 3. Core development loop

### 3.1 Campaign loop

The campaign repeatedly moves through five steps:

1. **Assess**  
   Read the settlement report: production, consumption, current shortages, Cohesion, Health, threats, and important messages.

2. **Plan**  
   Allocate population, choose construction or repair work, set rationing or policy, and—once the capability is unlocked—prepare an expedition or diplomatic action.

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
- after expeditions are unlocked, one regional action, such as scouting, scavenging, trading, negotiating, or attacking;
- workforce reassignment;
- one policy or event decision;
- then advancement of time.

The order limit is important. The player should not be able to optimize every problem simultaneously.

### 3.3 The three connected play spaces

#### Settlement

Build, repair, assign workers, manage capacity, and see the community physically change.

#### Region

Discover connected sites and factions, establish routes and outposts, gather scarce resources, and respond to threats.

The regional map may show rumors and distant landmarks during the Camp stage, but the player cannot issue regional orders yet. These elements must use a visibly disabled presentation, such as muted markers and a short **Beyond our reach** label, rather than appearing selectable. Active regional play begins only after the settlement has established the infrastructure required to launch an expedition. This gate applies to all player-initiated regional orders, including trade and diplomacy; outside groups may still contact the Camp through events.

#### Council

Handle petitions, policies, disputes, alliances, leadership questions, and the social consequences of survival decisions.

These are not separate mini-games. An expedition may discover a water plant, restoring it may require a settlement workshop, and control of it may provoke a neighboring faction or political dispute.

### 3.4 Control scheme

The interface is mouse-first. A player must be able to complete the full core turn loop without
knowing a keyboard shortcut.

- Left click selects, opens, and activates clearly labeled primary actions.
- Hover previews information but never commits an action.
- Right click may provide details or back/cancel behavior, but visible controls must offer the same
  functions for a one-button mouse.
- Wheel and middle-button navigation are conveniences; visible zoom, scrolling, adjustment, and
  primary-button panning controls remain available.
- Costs, time, labor, people committed, risk, and projected effects are shown before the player
  commits an applicable action.
- Population and expedition controls operate on aggregate values rather than individual units.
- Disabled actions explain their requirement, including stage-gated expedition access.
- Hover, selection, pending, disabled, and danger states are distinguished by more than color.
- Keyboard and future controller inputs mirror mouse actions and do not expose unique core commands.

The complete interaction rules and prototype acceptance criteria are defined in
[Control Scheme](CONTROL_SCHEME.md).

## 4. Resource model

The interface should distinguish between **stockpiles**, **people**, **capacities**, and **conditions**. This avoids turning every system into another spendable currency.

### 4.1 Core stockpiles

| Resource | Purpose | Main sources | Main pressures |
|---|---|---|---|
| **Water** | Daily survival; farming; some industry | wells, collectors, purification, regional sources, trade | population, drought, contamination, damaged infrastructure |
| **Food** | Daily survival and population health | gathering, farming, livestock, hunting, trade | population, spoilage, poor weather, pests |
| **Scrap** | Basic construction, repair, tools, and trade | ruins, scrapyards, dismantling, tribute, trade | buildings, repairs, defenses, equipment |
| **Fuel** | Long-range expeditions, generators, vehicles, and advanced projects | depots, refining, trade, rare scrap | travel, powered infrastructure, emergency generation |

Four stockpiles are enough for the initial design. Additional material types should be added only if playtesting proves that Scrap is doing too many jobs.

### 4.2 People

**Population** is both the community and the available workforce. It is represented through aggregate numbers rather than individual residents.

Useful population categories include:

- total population;
- available workforce;
- assigned workforce by sector;
- dependents;
- injured or sick population;
- population committed to expeditions;
- guards or militia.

The interface should favor a small number of readable totals and assignments rather than rosters, named workers, or per-person simulation. Specialists should normally be represented as capabilities, bonuses, or population groups rather than individual characters.

The player cannot spend population like a normal resource. Allocating people to one role makes that portion of the population unavailable elsewhere, and risking a group outside the settlement has human and economic consequences. Reports and events should give aggregate changes human meaning without requiring individual records.

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

Progression is divided into five stages. Advancement should require both a population range and completion of a defining project, so population alone cannot rush the game.

| Stage | Identity | New capabilities | New pressures |
|---|---|---|---|
| **I. Camp** | A group trying to survive | local gathering and salvage, tents, water collection | exposure, hunger, illness, almost no reserve |
| **II. Settlement** | A permanent home | farming, workshop, clinic, storage, basic militia, migration, expedition infrastructure | maintenance, sanitation, larger consumption, raids |
| **III. Township** | A stable local community | specialists, improved workshops, local markets, basic outposts | competing interests, maintenance, nearby rivals |
| **IV. City** | A major regional center | advanced industry, districts, trade routes, council factions, strong defenses | inequality, infrastructure dependence, diplomacy, coordinated enemies |
| **V. The Capitol** | The recognized seat of regional leadership | major infrastructure, regional governance, and a legacy project | final crises, alliance obligations, internal debate over the ending |

A **City** is achieved through population, infrastructure, and specialization. Becoming **The Capitol** is a political achievement: the City must earn regional legitimacy through alliances, influence, controlled routes, and completion of its legacy project.

### 5.1.1 Camp progression model

The **Camp** should play as a compact settlement-planning chapter rather than a reduced version of the whole game. Its structure takes inspiration from *Rise of Babylon*: limited time and building space make cheap immediate growth compete with efficient long-term development, population depends on housing capacity, and looming threats prevent a perfect leisurely build.

The Camp is expected to last roughly **6–10 turns** in the 40-turn campaign. It does not end automatically on a fixed turn, but a clearly forecast first major crisis should arrive near the end of that window. Remaining a Camp is allowed, but makes the crisis much harder because makeshift structures provide poor protection.

#### Camp economy

Camp play uses a closed local loop:

**Allocate population → gather Water, Food, and Scrap → add or improve capacity → absorb consequences → prepare permanence**

There is no active regional trade, diplomacy, or expedition play. All gathering and salvage come from the settlement's immediate catchment and are represented as workforce assignments rather than map missions.

Each Camp turn should normally ask the player to make:

- one construction, repair, or defining-project order;
- a small number of aggregate workforce allocations;
- one rationing, reception, or event decision;
- then advance time.

#### Space and building choices

The Camp has a small number of visually distinct **safe plots**. Early structures should offer alternatives rather than a single upgrade chain:

- **makeshift structures** are cheap and quick, but fragile, maintenance-heavy, and space-inefficient;
- **permanent structures** cost more Scrap and labor, but provide better capacity per plot and contribute toward Settlement advancement.

For example, several tarp shelters may solve tonight's exposure more cheaply than a bunkhouse, while consuming plots that will later be needed for storage, sanitation, or the defining project. Demolition can recover part of the Scrap, but not the spent time. The goal is to create understandable tension between building now, saving for something better, and running out of room.

The settlement view should visibly replace tents, debris, and improvised work areas with sturdier structures. Population remains an aggregate number; small crowd animations, occupied shelter lights, work activity, and density communicate growth without representing residents individually.

#### Population resolution

At the end of a Camp turn, resolve population in this order:

1. production and consumption;
2. shelter, health, and overcrowding effects;
3. arrivals, departures, injuries, and deaths;
4. Cohesion changes;
5. threat escalation.

Show this sequence as a short resolution report so the player can connect aggregate gains or losses to their causes.

Shelter is a strong growth constraint, but exceeding it does not delete population. Exposed or overcrowded people increase consumption pressure, reduce Health and Cohesion, and may leave if the situation continues. Spare shelter, stable necessities, and good Cohesion improve the chance and size of migrant arrivals.

Growth should come mainly from discrete survivor-arrival opportunities. The player may accept everyone, accept a smaller group, or turn people away. These decisions make population growth valuable but not automatically correct.

#### Pressure and warning

The Camp chapter combines two kinds of pressure:

- **time pressure** escalates weather, contamination, decay, or a roaming threat even if the player stays small;
- **visibility pressure** reacts to population, stored resources, smoke, light, and permanent construction.

The first major threat must be announced several turns in advance through a compact forecast or report. Each minor random event may occur at most once per run, while major Camp decisions should occur at known points so the player can learn from previous campaigns. Visibility pressure must identify its active sources and, when reasonably predictable, the next escalation breakpoint. Cohesion penalties may reinforce later trouble, but the interface must show the feedback and provide a recovery action.

#### Advancing to Settlement

Advancement should be a visible strategic objective rather than an automatic population level. The Camp becomes a **Settlement** when it has:

- reached the prototype population range for Stage II;
- enough shelter for its current population;
- maintained non-negative projected Water and Food for two consecutive turns;
- completed a **Permanent Hub**, the defining Camp project.

The Permanent Hub represents durable storage, administration, shared meeting space, and a commitment to remain. Its exact theme may vary with the settlement's development branch, but it always occupies a safe plot and requires a meaningful Scrap and labor investment. Branch-themed variants should remain mechanically equivalent in the initial prototype.

The interface should present these requirements as four clear readiness marks, not a hidden score. Readiness is evaluated after all five Camp-resolution steps, using the resulting population, capacities, and projections. If the forecast crisis occurs on the same turn, the crisis resolves first and the Camp must still satisfy all four marks afterward. Advancement then occurs, and Settlement capabilities become available. The **Expedition Post remains a separate post-advancement project**.

This model borrows *Rise of Babylon*'s pressure between cheap growth, limited space, efficiency, and a finite horizon. It does not copy that game's single population-maximization goal: Ashfall's Camp is successful when it becomes resilient enough to survive and reach outward.

### 5.1.2 Unlocking expeditions

Expeditions are a capability earned through settlement development, not a starting action.

During the **Camp** stage, the player is confined to the settlement and its immediate catchment. Gathering and salvage are local workforce assignments resolved through the settlement economy. The regional map can foreshadow future play with distant smoke, radio fragments, landmarks, or rumors, but its destinations cannot yet be selected.

After advancing from **Camp** to **Settlement**, the **Expedition Post** becomes available as a new project. It is a separate, post-advancement project rather than the defining project used to reach Settlement. The Post represents the communications, route knowledge, equipment, and organization needed to operate beyond the local area. Completing it unlocks the first expedition and the active regional map.

The initial expedition model should remain compact:

- one active expedition at a time;
- one aggregate population commitment rather than a roster;
- a chosen mission and destination;
- committed supplies, with Fuel required only for routes beyond the initial short-range area;
- estimated duration and visible risk;
- aggregate results, losses, and discoveries.

An expedition traveling on the map does not consume the regional action each turn merely by existing. A regional action may redirect it, resolve a destination, order its return, or conduct another unlocked regional operation. The limit on active expeditions is therefore separate from the per-turn regional order limit.

An expedition appears on the regional map as a single animated caravan, convoy, or expedition marker following a visible route. Its silhouette may change with its scale or transport type, but it remains one strategic object. Its panel shows progress, people committed, supplies, risk, and status. Later development may increase expedition range or allow a second simultaneous expedition, but it should not introduce individual-unit control.

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

New arrivals may change the workforce mix or bring dependents, disputes, obligations, or enemies. This makes accepting migrants a strategic and moral decision rather than an automatic reward.

### 5.3 Development branches

At each stage, the player should choose a few developments from four broad branches:

- **Sustenance** — water security, farming, storage, medicine;
- **Industry** — repair, construction, power, vehicles, scrap recovery;
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
   Build a heavily defended, powered stronghold capable of surviving the coming crisis alone. Focus: industry, fuel, scrap, and security.

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
- aggregate population assignment;
- five to eight building types;
- a small fixed set of Camp safe plots with makeshift and permanent building alternatives;
- four visible Settlement-readiness marks and the Permanent Hub project;
- a Settlement-stage Expedition Post and one active scouting or scavenging expedition;
- one neutral faction and one hostile threat;
- a small event deck;
- two settlement stages;
- one simplified legacy objective;
- a short 12–16 turn scenario, with Camp progression compressed to roughly 4–6 turns for this vertical slice.

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

Build the game around **Water, Food, Scrap, Fuel, and People**. Track **Health, Cohesion, and visible threats** as conditions. Let the settlement advance from **Camp → Settlement → Township → City → The Capitol**, with each stage unlocking options and adding obligations.

Use a **40-turn finite campaign** in which the player survives escalating pressure and completes one of several **legacy projects**. This gives Ashfall a clear purpose beyond simply making numbers rise: the player is deciding what kind of society deserves to survive.
