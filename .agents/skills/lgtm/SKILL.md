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
7. Verify the pull request reports `MERGED` and the remote base branch contains the resulting commit.

The authorization does not include releases, deployments, branch deletion, or unrelated cleanup.
