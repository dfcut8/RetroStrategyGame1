# Project Agent Instructions

## GDD and style guard

For every task that changes files in this repository, verify the result against:

- `docs/GAME_DESIGN_DOCUMENT.md`
- `docs/DESIGN_STYLE.md`

Before implementation, read the relevant sections of both documents. If the task affects gameplay,
game balance, progression, interface, visuals, audio, narrative, worldbuilding, or player-facing
text, treat both documents as product requirements.

Before the final response, delegate an independent, read-only review to a sub-agent named
`gdd_style_guard` (reuse the existing agent when one is available). Give it the changed-file list
and diff, and require it to:

1. Check the changes against both source documents.
2. Cite the applicable file and section for each finding.
3. Separate direct conflicts from open design questions or subjective suggestions.
4. State explicitly when a change has no GDD or style-guide impact.

Resolve direct conflicts before completion. Do not silently reinterpret or update either source
document to make a conflict disappear. If the requested outcome intentionally departs from the
documents, explain the conflict and ask the user to approve the design change.

In the final response, state whether the completed work is aligned with the GDD and style guide,
including any approved exceptions or unresolved questions.

## Remote synchronization check

After any task that changes files in this repository, and before the final response:

1. Inspect the working tree with `git status --short --branch`.
2. Identify the current branch's upstream. If it has no upstream, report that the branch is not fully published.
3. Run `git fetch --prune` when network access is available so the remote-tracking reference is current. If the fetch fails, say that remote synchronization could not be conclusively verified.
4. Compare `HEAD` with its upstream using `git rev-list --left-right --count HEAD...@{upstream}`.
5. Consider all changes pushed only when:
   - there are no staged, unstaged, or untracked files;
   - the current branch has an upstream;
   - the local branch is zero commits ahead of its upstream; and
   - the remote check is current, or the final response clearly states that it relied on cached remote-tracking information.
6. In the final response, explicitly state one of:
   - all changes are pushed to the tracked remote;
   - local changes or commits are not pushed, with a concise summary; or
   - remote synchronization could not be verified, with the reason.

Checking synchronization does not authorize committing or pushing. Only commit or push when the user's request explicitly includes that action.
