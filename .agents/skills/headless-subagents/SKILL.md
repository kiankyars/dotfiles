---
name: headless-subagents
description: Instruct the agent on how to use Grok, Gemini, and AGY as headless subagents to scale concurrency without rate limits, checking CodexBar for usage limits.
version: 1.0.0
license: MIT
author: "Antigravity"
tags:
  - headless
  - subagents
  - scaling
  - codexbar
  - concurrency
---

## Instructions

Use this skill when you need to execute tasks (e.g., bulk text labeling, data classification, PII parsing, trace scrubbing) concurrently using headless subagent CLIs (`grok`, `gemini`, `agy`) while dynamically monitoring model quotas and rate limits using `codexbar`.

Headless CLIs run as complete agent loops inside their own workspace sandbox. This enables you to delegate work to multiple parallel subagents without hitting rate limits or consuming the primary agent's token context.

### When to Use

- Executing bulk operations across many files or traces (e.g., PII labeling).
- Running parallel jobs without exceeding your primary conversation's rate limits.
- Selecting appropriate models based on real-time quota availability.
- Scaling task worker threads dynamically.

### How to Use

#### 1. Check Usage Limits using `codexbar`
Before launching any headless subagent batch, run the `codexbar` CLI to inspect available credits and token pacing:
```bash
codexbar usage
# Or for structured parsing:
codexbar usage --format json
```
Analyze the returned usage quotas:
- **Grok**: Ensure the web billing status is active and credits are remaining.
- **Claude**: Inspect weekly limits and pace.
- **Gemini**: Check the remaining percentage for `Pro`, `Flash`, and `Flash Lite`. If `Flash` is exhausted (e.g., "you have exhausted your capacity"), fall back to other available models like `gemini-3-flash-preview` or `grok`.

#### 2. Invoking Headless Subagents
To run a subagent headlessly, invoke its CLI with the appropriate prompt and non-interactive flags:

- **Grok CLI**:
  ```bash
  grok -p "PROMPT" --permission-mode bypassPermissions
  ```
  *Tip*: Grok is highly reliable. Run with a light pace (~5 seconds sleep between workers) to avoid hitting request rate limits.

- **Gemini CLI**:
  ```bash
  gemini -p "PROMPT" -m "gemini-3-flash-preview" --approval-mode yolo --skip-trust -o text
  ```
  *Tip*: Do NOT use `gemini-3-flash-lite-preview` (retired). Keep concurrency low (e.g., 5-8 workers) to avoid quick quota depletion.

- **Antigravity (AGY) CLI**:
  ```bash
  agy -p "PROMPT" --dangerously-skip-permissions --print-timeout 15m
  ```
  *Tip*: Make sure you are logged in to `agy` first. If headless OAuth times out, run `agy` interactively to re-authenticate.

#### 3. Concurrency and Collision Prevention
When running multiple headless subagents in parallel:
- **Partition Tasks**: Use an input generator or index list (e.g., `list_pending.py`) to assign distinct files or lines to each worker, avoiding duplicate processing.
- **Limit Concurrency**: Keep the total number of parallel workers under 8 to prevent API request spikes.
- **Detect Completion**: Monitor the target output directory for output JSON files (e.g. `.json` for success, `.failed` for failures) rather than checking shell returns.

## Examples

**Example 1: Triage and Run via Grok**
```bash
# Check if there are tasks
python3 list_pending.py --all --limit 5

# Dispatch batch using grok
bash dispatch_batch_grok.sh 5 --all
```

**Example 2: Check CodexBar before dispatch**
```bash
# Run codexbar to verify gemini and grok status
codexbar usage

# If gemini is 100% left, run gemini dispatch; if exhausted, use grok
bash dispatch_batch.sh 5 delve-700-labelled
```

## Limitations

- **Authentication**: `gemini` and `agy` require active login sessions. If they ask for login interactively, they will hang in headless mode.
- **Network**: Commands running in sandboxed or isolated terminal shells might fail to resolve DNS or reach auth servers. Always check logs on failure.
- **Resource Competition**: Parallel writing can lead to race conditions if two workers edit the same database or config file. Write to unique, trace-specific output files.

## Dependencies

- `codexbar` CLI (installed at `/opt/homebrew/bin/codexbar`)
- `grok`, `gemini`, or `agy` CLI tools
- Python 3.9+ for task listing scripts
