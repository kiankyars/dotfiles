---
name: semantic-git-push
description: Inspect the current branch's staged and unstaged git changes, infer a coherent commit message from the actual diff, commit the change set, and push the branch. Use when the user wants Codex to commit and push, write a good commit message and push, or do a semantic git push for the current branch.
---

# Semantic Git Push

## Overview

Turn the current branch's working tree changes into one clean commit with a good message, then push it. Infer the message from the actual diff, not just filenames.

## Workflow

1. Inspect branch and worktree state.
2. Decide whether the current changes belong in one commit.
3. Read enough of the diff to understand the dominant change.
4. Write a concise commit subject that matches repo history.
5. Stage the full coherent change set, commit it, and push the branch.

## Inspect First

Always start with:

- `git status --short --branch`
- `git diff --stat`
- `git diff --cached --stat`
- `git diff --name-only`
- `git diff --cached --name-only`
- `git log --oneline -10`

Then read the actual diff for the changed files that matter. Do not generate the commit message from filenames alone.

## Cohesion Check

Proceed automatically only when the changes clearly form one logical change.

Good signs:

- the files support one feature, fix, refactor, or cleanup theme
- generated file updates obviously belong to the source change
- staged and unstaged changes point at the same underlying task

Stop and ask the user before committing when:

- the diff contains unrelated changes that should become separate commits
- there are obvious debug edits, accidental files, or throwaway experiments mixed in
- the user appears to have staged one thing and left another unrelated thing unstaged

If there are no changes, say so and stop.

## Commit Message Rules

Infer the message from the dominant semantic change.

Prefer:

- imperative mood
- one concise subject line
- specific nouns and verbs
- alignment with the style in recent local commits

Avoid:

- vague subjects like `updates`, `misc fixes`, `wip`, or `changes`
- over-detailed laundry lists in the subject
- prefixes like `feat:` or `fix:` unless the repo already uses them consistently
- trailing periods

Use a body only when the subject is insufficient on its own. Most commits should be subject-only.

## Git Actions

If the change set is coherent:

- stage everything relevant with `git add -A`
- commit with the chosen message
- push the current branch

Use non-interactive git commands only.

For push behavior:

- if the branch already has an upstream, use `git push`
- if it does not, use `git push -u origin HEAD`

## Output

After pushing, report:

- branch name
- commit hash
- final commit message

If push fails, report the exact reason and do not guess.

## Failure Modes To Avoid

- committing only the staged subset when the unstaged changes are obviously part of the same task
- staging and pushing unrelated work without checking cohesion first
- writing the message before reading the diff
- using a generic subject when the diff supports a more specific one
- forcing a push unless the user explicitly asked for it
