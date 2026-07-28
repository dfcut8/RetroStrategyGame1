# Mouse-first control prototypes

These mockups explore local mouse-first interaction while preserving the established
low-resolution settlement and regional-map presentation. They are cropped component studies, not
complete full-screen layouts or control-compliance proofs.

The formal [Control Scheme](../../CONTROL_SCHEME.md) is authoritative where these early visual
studies omit a required control or readout.

## Control principles

- Every actionable map object receives a visible hover state.
- Left click selects, opens, or confirms the primary action.
- Right click opens details when browsing and cancels or steps back when choosing; visible Details,
  Cancel, or Back buttons—and the primary-click panel itself—provide the same actions.
- Wheel zooms the map; visible zoom controls support one-button mouse play.
- Important actions use labeled rectangular hit targets instead of unexplained icons.
- Costs, risks, duration, and disabled actions are visible before confirmation.
- Hover, selected, disabled, and route-preview states differ by border, value, and label,
  not color alone.
- Keyboard and controller shortcuts may mirror these actions later, but are not required
  to understand the interface.

## Settlement flow

1. `01-settlement-plot-hover.png` shows an empty safe plot under the pointer. The plot,
   tooltip, and Build button all reinforce the same available action.
2. `02-settlement-build-menu.png` shows the result of clicking the plot. Large rows compare
   immediate shelter, Scrap cost, labor, build duration, and the current hover choice before
   construction.

The expected interaction is:

**Hover plot → left click → compare buildings → left click to build**

Right click or the visible Cancel button returns to the settlement without committing.

## Expedition flow

These screens represent play after reaching Settlement and completing the Expedition Post. The
regional map may be inspected for disabled rumors during the Camp stage, but all regional commands
remain non-interactive.

1. `03-expedition-site-hover.png` shows a regional destination under the pointer with its
   route, risk, and travel time previewed.
2. `04-expedition-command-panel.png` shows the result of clicking the destination. The
   expedition remains one aggregate strategic object, with Travel available, Scavenge
   labeled as unavailable until arrival, and Return available. Supply and route Fuel
   commitments are shown before the player confirms Travel.

The expected interaction is:

**Hover site → left click → inspect command panel → left click to confirm**

Right click or the visible Cancel button closes the command panel without changing orders.

## Known prototype omissions

- The persistent `END TURN` button and visible `+`/`-` zoom controls belong to the global interface
  shell and sit outside these cropped studies. They remain required in final full-screen layouts.
- The expedition command panel must add an expected condition on arrival or an explicit `UNKNOWN`
  readout when intelligence is insufficient.
- Workforce, reports, Council/events, pending-order revision, and disabled Camp-region states need
  separate interaction studies before the complete mouse-only acceptance checklist can pass.

## Source concepts

- `../01-settlement-growth.png`
- `../02-wasteland-exploration.png`

The prototypes are interface explorations, not final art or final balance values.
