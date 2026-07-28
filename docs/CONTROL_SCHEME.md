# Control Scheme

Status: prototype requirement

The game is designed to be fully playable with a mouse. A player should be able to complete every
core turn action without knowing a keyboard shortcut. Keyboard and controller input may mirror the
same actions, but they must not unlock unique core commands.

This scheme supports the game's grand-strategy focus: the player directs aggregate workforce,
settlement projects, policies, and—after reaching Settlement and building the Expedition Post—one
abstract expedition. It does not introduce individual-unit selection or character micromanagement.

## 1. Design goals

- Make almost every action discoverable through visible, clickable controls.
- Keep the number of choices compact enough to read at a glance.
- Show costs, time, people committed, and likely consequences before an order is confirmed.
- Preserve the deliberate rhythm of assess, plan, commit, resolve, and adapt.
- Support a one-button mouse by providing visible alternatives to wheel, middle-button, and
  right-button conveniences.
- Keep keyboard and future controller navigation in parity with the mouse interface.

## 2. Primary mouse actions

| Input | Default behavior |
| --- | --- |
| Move pointer | Highlight an interactive object and preview its summary. Hover never commits an action. |
| Left click | Select an object, open its primary panel, activate a visible button, or confirm a clearly labeled choice. |
| Right click | Open contextual details while browsing, or go back/cancel while a panel is open. |
| Mouse wheel | Zoom the map, scroll a list, or change a hovered numeric control by one step when that behavior is clearly indicated. |
| Middle-button drag | Pan the map as an optional convenience. |
| Left-button drag on empty terrain | Pan the map without requiring a middle mouse button. |

Right click, wheel, and middle-button actions always have visible equivalents:

- `DETAILS` buttons or primary-click panels containing the same information as right-click details.
- `BACK` or `CANCEL` buttons for closing and reversing navigation.
- `+` and `-` buttons for zoom and numeric adjustments.
- Scrollbars or page buttons for lists.
- Click-and-drag map panning with the primary button.

Double-clicking is never required for a core action.

## 3. Interaction states

Every interactive object uses a consistent set of states:

- **Default:** available but not focused.
- **Hover:** outlined or otherwise emphasized, with a short preview.
- **Selected:** remains visibly marked while its command panel is open.
- **Disabled:** visibly inactive and accompanied by a reason, such as `NEEDS 4 SCRAP` or
  `AVAILABLE AFTER SETTLEMENT`.
- **Pending:** an order has been planned but not yet resolved.
- **Danger or confirmation:** a permanent or unusually risky decision is called out before it is
  committed.

States must not rely on color alone. Borders, icons, labels, patterns, or shape changes provide the
same information. Critical costs and consequences cannot exist only in a hover tooltip; clicking
the object must expose them in a stable panel.

## 4. Mouse-only action paths

### 4.1 Settlement

1. Hover a plot or building to preview its identity, condition, and current output.
2. Left-click it to open the build or management panel.
3. Compare Scrap cost, labor required, build duration, and projected effect.
4. Left-click a labeled command such as `QUEUE SHELTER`.
5. Review the pending order in the settlement view before ending the turn. Until resolution, visible
   `CHANGE` and `CANCEL ORDER` controls allow the player to revise it.

Resource totals in the status bar are clickable. Selecting one opens its production, consumption,
and projected-change breakdown.

### 4.2 Workforce

Population remains aggregate. Workforce is assigned to categories rather than to individuals.

- Each category provides visible `-` and `+` buttons.
- Optional presets can apply common allocations in one click.
- A draggable allocation bar may be provided, but is never the only control.
- The panel immediately updates available workforce and projected production.
- Assignments never require typing a number.

### 4.3 Council and events

- Decisions appear as large, labeled rows or buttons.
- Known costs, expected effects, and affected resources are visible before selection.
- A normal choice is selected with one click and committed with a labeled button.
- Permanent or high-impact decisions receive a concise confirmation step.
- Core decisions never require text entry.

### 4.4 Region and expedition

During the Camp stage, the Region view may be inspected for rumors and distant landmarks, but all
player-initiated regional commands remain disabled. After the player reaches Settlement and builds
the unlocked Expedition Post, expedition commands and the active regional map become available.

1. Hover a destination to preview route, travel time, known risk, and available intelligence.
2. Left-click the destination to open its command panel.
3. Review people committed, Supply, Fuel, travel time, and expected condition on arrival.
4. Adjust the abstract expedition load using visible `-`, `+`, or preset buttons.
5. Left-click the labeled travel command to issue the order.

The game models one aggregate expedition concept, not individually controlled explorers. Unknown
or unavailable sites remain visible when useful for anticipation, but are disabled and explain why
they cannot yet be reached.

Later regional actions such as trade, negotiation, and attack use the same mouse path: inspect the
destination or contact, open a stable action panel, review the known costs and consequences, then
activate a labeled command. High-risk or irreversible actions add the confirmation described below.

### 4.5 Reports and conditions

- Left-click a notification, resource, condition, or status summary to open its full breakdown.
- Hover may show a quick explanation, but all essential information is also available by click.
- Camp-stage rumors of the wider region may appear as disabled leads labeled `BEYOND OUR REACH`;
  they do not expose expedition commands early.

### 4.6 End turn

`END TURN` is a persistent, labeled button in the main interface.

- A click resolves all pending orders and advances the turn.
- An unresolved mandatory decision blocks advancement and links directly to that decision.
- Optional unspent actions may produce a warning with `END ANYWAY`; they do not silently block the
  player.
- The button is placed away from frequently used adjustment controls to reduce accidental clicks.

Save, options, help, and return-to-game actions must also be available through visible buttons.

## 5. Confirmation rules

Ordinary, reversible planning should stay quick. Selecting an object and then clicking its labeled
command is enough; an extra confirmation dialog is unnecessary.

A confirmation is appropriate for:

- Demolishing or permanently replacing an occupied structure.
- Rejecting migrants or making another irreversible population decision.
- Sending the expedition into a known severe threat.
- Ending the turn after an optional unspent-action warning.

Before any commitment, the interface shows the relevant resource cost, labor, duration, population,
risk, and projected outcome. Disabled commands explain their unmet requirement.

## 6. Map and panel navigation

- Drag empty terrain with the left button to pan; middle-button drag is optional.
- Use the wheel to zoom, with visible `+` and `-` controls as an alternative.
- Lists use a visible scrollbar or page controls.
- A minimap may support click-to-center, but is not required for the first prototype.
- Opening a panel never hides the route back to the previous view.

## 7. Keyboard and controller parity

Keyboard shortcuts are optional accelerators:

| Keyboard | Mouse equivalent |
| --- | --- |
| `Enter` or `Space` | Left click / confirm |
| `Escape` | Right click / `BACK` / `CANCEL` |
| Arrow keys or `WASD` | Move focus or pan |
| `Tab` / `Shift+Tab` | Cycle interactive controls |
| Number keys | Optional shortcuts for visible choices |

A future controller scheme should navigate the same focus order and activate the same commands.
Tutorials and interface labels default to mouse instructions when a mouse is active, and update to
the current input device when practical.

## 8. Readability and accessibility

- Interactive targets are generous and do not demand pixel-perfect pointing.
- The pointer remains visible against every map surface.
- Pixel-art presentation must not compromise legibility of numbers or labels.
- Button placement remains stable between comparable panels.
- Tooltips may have an adjustable delay.
- Cursor scale and reduced-motion options should be considered during accessibility work.
- Information is never communicated by color alone or by hover alone.

## 9. Prototype acceptance checklist

The control prototype is successful when a player can use only the mouse to:

- Inspect the turn report and resource breakdowns.
- Reallocate aggregate workforce.
- Inspect, compare, and queue a settlement project.
- Resolve a council or event decision.
- End the turn.
- After expedition access is unlocked, inspect a destination, configure the aggregate expedition,
  issue a travel order, cancel it before commitment, and open its details.

Additionally:

- Every committing choice exposes its applicable cost, labor, time, people, risk, and outcome.
- Every disabled control explains why it is unavailable.
- Every pending order provides visible change or cancel controls until it becomes committed.
- Wheel, middle-button, and right-click conveniences have visible one-button alternatives.
- Keyboard and controller input do not provide any unique core action.

## 10. Visual references

The current control-flow mockups are:

- [Settlement plot hover](visual-concepts/mouse-first-controls/01-settlement-plot-hover.png)
- [Settlement build menu](visual-concepts/mouse-first-controls/02-settlement-build-menu.png)
- [Expedition site hover](visual-concepts/mouse-first-controls/03-expedition-site-hover.png)
- [Expedition command panel](visual-concepts/mouse-first-controls/04-expedition-command-panel.png)

Numbers and balance values in these mockups are illustrative, not final.
