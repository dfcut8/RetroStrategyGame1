---
name: lgtm
description: Merge the open pull request associated with the current worktree branch. Use only when the user explicitly invokes $lgtm or sends /lgtm as the entire trimmed message.
---

# LGTM

Follow the repository's `/lgtm` pull request workflow in `AGENTS.md`.

1. Treat the invocation as explicit authorization to merge only the open pull request associated with the current branch.
2. Resolve the pull request from the current branch. Stop if none exists or the target is ambiguous.
3. Refresh remote state and verify the pull request is open, mergeable, and targets the intended base branch.
4. Inspect required checks and reviews. Wait for pending required checks when practical.
5. Do not bypass failed checks, branch protection, merge conflicts, or missing required reviews without specific user authorization.
6. Merge with a repository-supported method, preferring squash when multiple methods are available.
7. Verify the pull request reports `MERGED` and the remote base branch contains the resulting commit before deleting either branch.
8. Delete the pull request's remote head branch, if it still exists, only when it belongs to the same `origin` repository and exactly matches the current worktree branch. An already-absent remote branch counts as complete cleanup. Do not guess when the remote repository or branch identity is ambiguous.
9. Detach the current worktree at the refreshed remote base branch, then delete the now-unchecked-out local pull request branch. Never delete a base, protected, unrelated, or other-worktree branch.
10. Verify the pull request branch is absent locally and on its applicable remote. If cleanup fails, preserve the verified merge and report the remaining branch and failure clearly.

The authorization includes deletion of the merged pull request's local and remote head branches. It does not include releases, deployments, other branch deletion, or unrelated cleanup.
