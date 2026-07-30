# Agentic Considerations to Try in the Future

> Status: installed for evaluation, not yet adopted as the default toolchain
>
> Recorded: July 30, 2026
>
> Installed: July 30, 2026

This note records possible improvements to Ashfall's AI-assisted Godot workflow. The two candidates
worth evaluating first are:

- [Funplay MCP for Godot](https://github.com/FunplayAI/funplay-godot-mcp), as a richer bridge between
  an agent and the live Godot editor;
- the modular Godot skills in
  [awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills),
  as focused Godot implementation guidance.

Neither candidate should be installed or enabled merely because it appears here. Trial changes
should use a dedicated branch, pin reviewed versions, and remain easy to remove.

## Installed evaluation snapshot

The evaluation branch currently includes:

- Funplay MCP for Godot `v0.9.6`, pinned to upstream commit
  `206a30c56ebaa661c910f068e74b649bbcd9ae23`, under `src/addons/funplay_mcp`;
- the five recommended Godot skills, pinned to upstream commit
  `01b3eb41b359a6386e7d27c8a704baaa2a2fcfd9`, under `.agents/skills`;
- the corresponding MIT and Apache-2.0 license and attribution files.

The Funplay editor plugin is enabled in `src/project.godot`. Its first editor launch created a
random per-project auth token under Godot's `user://` data, and an authenticated, pinned
`funplay-godot-mcp@0.9.6` client entry was added to the user-local Codex configuration. The token
remains outside Git. The user-local settings retain the `core` profile and safety checks, with the
high-impact `execute_code` and `install_runtime_bridge` tools disabled by default. Restart Codex so
the new MCP server is discovered. A runtime-capture trial may temporarily re-enable the bridge
installer only after snapshotting `src/project.godot`; remove the bridge and review the exact diff
immediately afterward because its default save path invokes `ProjectSettings.save()`.

Until the Codex restart is complete, the existing `@coding-solo/godot-mcp` connection remains the
active MCP in this session.

## Current baseline

Codex currently launches
[`@coding-solo/godot-mcp`](https://github.com/Coding-Solo/godot-mcp) through the repository's
`.codex/config.toml`. It provides a useful, narrow feedback loop:

- identify the installed Godot version and inspect project metadata;
- launch the editor;
- run and stop the project;
- collect debug output;
- create and save scenes;
- add nodes and load sprites;
- manage Godot resource UIDs.

This is a good headless run/debug baseline, but it cannot directly inspect a live scene tree,
simulate player input, or capture the native and integer-scale screenshots required for a full
pixel-perfect presentation review.

The current command also resolves an unpinned npm package through `npx -y`. Whether the project
keeps or replaces this MCP, a reviewed version should be pinned so the available tools do not
change unexpectedly between sessions.

## Candidate 1: Funplay MCP for Godot

Funplay is the preferred first MCP experiment because it is an MIT-licensed, editor-only bridge
designed for Godot 4.2 or newer and explicitly supports Codex. Its documented safeguards include:

- binding its local server to `127.0.0.1`;
- a per-project authentication token;
- rejection of non-local browser origins;
- normalization of file and resource paths under `res://`.

Its additional capabilities are closer to Ashfall's needs:

- inspect and modify scenes, nodes, scripts, and `Control`-based UI;
- inspect the running scene tree;
- map scenes, scripts, functions, signals, and dependencies;
- assist with project-scoped file search and changes;
- expose asset-import planning and release-readiness helpers.

### Proposed Funplay trial

Run the trial on a disposable branch against a small, reversible task. Do not begin with a major
scene rewrite.

1. Pin a reviewed Funplay release instead of tracking an unversioned package.
2. Install only the editor addon and client configuration required for the trial.
3. Confirm that the server listens only on localhost and requires its project token.
4. Keep high-impact editor execution tools, including arbitrary editor-code execution, disabled
   unless a narrowly scoped trial explicitly requires them.
5. Verify read-only operations first:
   - report the current scene tree;
   - inspect representative `Control` nodes and scripts;
   - read editor and runtime errors;
   - inspect the running scene without changing it.
6. Exercise one reversible mutation, then confirm that the exact diff is understandable in Git.
7. Test whether native 640x480 and exact 2x or 3x captures can be obtained reliably.
8. Run the existing project smoke tests and compare their output with the current MCP workflow.
9. Remove the addon and configuration to prove that rollback is complete.

### Acceptance criteria

Adopt Funplay only if the trial demonstrates all of the following:

- meaningful live-editor or runtime capabilities that the current MCP lacks;
- deterministic, reviewable changes under `res://`;
- reliable error reporting with no silent scene corruption;
- no unexpected network listener, telemetry, or write outside the project;
- compatibility with the installed stable Godot version;
- no degradation of headless smoke-test automation;
- enough screenshot or runtime inspection support to improve pixel-perfect verification;
- successful validation of one complete mouse-only action path, including its disabled and pending
  states;
- a straightforward uninstall and rollback path.

Do not keep two mutation-capable Godot MCP servers enabled for routine work. Overlapping scene and
script tools make it harder to identify which server changed a resource or why.

## Candidate 2: modular Godot agent skills

The `awesome-gamedev-agent-skills` repository contains portable `SKILL.md` packages for Godot 4.x.
Ashfall should evaluate a small project-relevant subset rather than installing its complete
game-development catalog.

### Recommended initial subset

| Skill | Why it fits Ashfall |
|---|---|
| `godot-gdscript` | Static typing, lifecycle, exports, signals, and current GDScript idioms |
| `godot-nodes-scenes` | Scene composition, instancing, node ownership, and `PackedScene` usage |
| `godot-signals-groups` | Decoupled event flow suitable for turn resolution and compact UI updates |
| `godot-ui-control` | Containers, anchors, themes, focus, and readable `Control`-based interfaces |
| `godot-resources` | Data-driven buildings, events, balance data, and reusable `.tres` resources |

Possible later additions:

- `godot-tilemap`, when regional or settlement maps actually use `TileMapLayer`;
- `godot-audio`, when the sound pipeline enters active implementation;
- `godot-animation`, when UI and settlement animation need a shared approach;
- `godot-export`, when reproducible packaged builds become a current milestone.

Avoid installing unrelated movement, 3D, multiplayer, physics, shader, or C# skills until the
project has a concrete need for them.

### Skill evaluation criteria

Review every candidate skill before copying it into the repository or a personal skill directory.

- Pin the source commit or release and record its license.
- Treat instructions as third-party executable guidance, not trusted project policy.
- Reject guidance that conflicts with `GAME_DESIGN_DOCUMENT.md`, `DESIGN_STYLE.md`,
  `CONTROL_SCHEME.md`, repository instructions, or the installed Godot version.
- Prefer official Godot documentation for version-sensitive API and rendering behavior.
- Confirm that activation descriptions are narrow enough to avoid loading irrelevant skills.
- Check scripts and referenced assets separately; a reasonable `SKILL.md` does not make bundled
  executable code safe automatically.
- Install only the smallest useful subset and remove skills that add noise without improving
  implementation or review quality.

## Project-specific authority

External MCP servers and skills are implementation aids. They do not override Ashfall's existing
requirements or reviewers.

The following remain authoritative:

- `GAME_DESIGN_DOCUMENT.md` for gameplay, progression, scope, and player-facing behavior;
- `DESIGN_STYLE.md` for the compact late-C64 strategy presentation and interaction discipline;
- `CONTROL_SCHEME.md` for mouse-first controls and prototype acceptance criteria;
- `.agents/skills/pixel-art` for final Ashfall raster conversion;
- `pixel_art_guardian` for raster-art preflight and final review;
- `godot_pixel_guardian` for viewport, scaling, filtering, imports, cameras, and pixel-perfect
  runtime presentation.

A general Godot skill should complement these sources. If generic best practice conflicts with a
project requirement, the conflict must be surfaced rather than silently "correcting" Ashfall.

## Suggested sequence

1. Restart Codex so it loads the installed Funplay MCP client entry and the five Godot skills.
2. Trial Funplay on a disposable branch using the acceptance criteria above.
3. Pin the current MCP version if it remains part of the long-term baseline.
4. Decide whether Funplay replaces the current MCP or whether the current narrow MCP remains the
   better default.
5. Review and trial the five installed Godot skills individually.
6. After real usage, consider extracting the useful parts into a small repository-local
   `ashfall-godot` skill tied to the installed Godot version and Ashfall's tests.

The goal is not to maximize the number of tools available to an agent. It is to improve the
feedback loop while keeping every change secure, reproducible, visually verifiable, and subordinate
to the game's design.
