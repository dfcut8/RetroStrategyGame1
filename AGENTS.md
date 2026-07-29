# Project Agent Instructions

## Line endings

Use Unix/Linux-style LF (`\n`) line endings for every text file. Never introduce Windows-style
CRLF (`\r\n`) line endings. Before committing, verify that all changed text files use LF and
normalize any changed text file that does not.

## Isolated worktree and pull request workflow

For every user prompt that requires file changes in this repository, perform the work in a
dedicated Git worktree on a dedicated branch based on the current remote base. Do not edit files
in the primary checkout, and do not create a second worktree when Codex already started the task
in a dedicated worktree.

1. Before changing files, inspect the checkout supplied for the task with
   `git status --short --branch` and `git worktree list --porcelain`. Determine whether the
   supplied checkout is the primary checkout or a dedicated worktree. Do not discard, stash,
   relocate, or build on existing changes in order to obtain a clean state.
2. Refresh the intended base branch with `git fetch --prune origin`. For a normal task based on
   `main`, use the refreshed `origin/main`; do not check out or pull a local `main` first. If the
   fetch fails, do not begin file changes from a potentially stale base unless the user explicitly
   approves that fallback.
3. Use a new branch named `codex/<prompt-slug>` created directly from the refreshed
   remote-tracking base.
   - If Codex already started the task in a dedicated worktree, keep that worktree and create or
     switch to the task branch there. Do not create a nested or sibling worktree for the same
     prompt. A Codex-managed worktree may have an opaque directory name and may initially use a
     detached `HEAD`; neither condition requires replacing it.
   - If the supplied checkout is the primary checkout, create a separate worktree for the task
     branch. For manually created worktrees, the directory name must be `<prompt-slug>` so it
     matches the branch suffix; for example, branch `codex/update-orders` uses worktree directory
     `update-orders`.
4. Before editing, verify the selected worktree is on the intended task branch, is based on the
   refreshed remote-tracking base, and has an empty `git status --short`. If it is not clean, stop
   and resolve the worktree setup without altering user-owned changes.
5. Keep the prompt's changes isolated to that worktree and branch. Do not reuse a worktree or
   branch created for a different prompt.
6. Treat a file-changing prompt as authorization to create the worktree and branch, commit the
   requested changes, push that branch, and open or update its pull request.
7. Open a pull request into the intended base branch, normally `main` (or `master` when that is
   the repository's base). Never merge the work directly into `main` or `master`.
8. Do not merge the pull request unless the user explicitly requests it, including through the
   `/lgtm` workflow below.
9. In the final response, provide the pull request link and explicitly ask the user to review it.

Read-only prompts do not require a worktree or branch.

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

The isolated worktree and pull request workflow above authorizes committing and pushing for
file-changing prompts. Outside that workflow, only commit or push when the user's request
explicitly includes that action.

## `/lgtm` pull request workflow

When the user's entire trimmed message is `/lgtm`, treat it as explicit authorization to merge the
open pull request associated with the current worktree branch. Do not ask for another confirmation.

1. Resolve the pull request from the current branch rather than guessing from recent repository
   activity. If there is no associated open pull request, or the target is ambiguous, stop and
   report that clearly.
2. Refresh the remote state and verify the pull request is open, mergeable, and targeting the
   intended base branch.
3. Inspect required checks and reviews. Wait for pending required checks when practical. Do not
   bypass a failed check, branch protection, merge conflict, or missing required review unless the
   user explicitly authorizes that specific override.
4. Merge using a repository-supported method, preferring squash when more than one method is
   available. Do not merge unrelated pull requests.
5. Verify that the pull request reports `MERGED` and that the remote base branch contains the
   resulting commit before reporting success.

The `/lgtm` command authorizes the merge and its normal verification steps. It does not authorize
unrelated releases, deployments, branch deletions, or cleanup of other worktrees.
