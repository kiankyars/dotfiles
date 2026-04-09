---
name: craft-high-impact-paper
description: Help choose, pressure-test, and rewrite research papers for impact, rigor, and readability using a best-paper-oriented philosophy. Use when Codex needs to assess whether a research idea matters, prioritize among paper projects, plan decisive experiments, or critique or rewrite a paper's title, abstract, introduction, figures, or conclusion.
---

# Craft High Impact Paper

## Overview

Treat awards as a side effect, not the objective. Optimize for work that matters, is technically credible, and is easy for skeptical readers to absorb.

Read `references/playbook.md` when you need the detailed heuristics and checklists behind this workflow.

## Start Here

Identify which stage the user is in before giving advice:

- `idea`: decide whether the problem is worth pursuing
- `execution`: strengthen the technical plan and experiments
- `draft`: rewrite the paper so the main claim lands clearly
- `resubmission`: diagnose what readers or reviewers failed to understand

If the stage is unclear, infer it from the artifact the user provides and proceed.

## Core Operating Rules

- Start by writing the strongest honest version of the paper's eventual `so what?`
- If the best-case conclusion is only a modest metric bump or a narrow cleanup, say so directly and recommend killing, shrinking, or demoting the project
- Prefer important, inevitable, underexplored problems over safe incremental ones
- Attack the assumption most likely to fail before polishing anything else
- Suggest small prototypes to de-risk ideas quickly
- Ask what a skeptical reader would challenge, then run the experiment or analysis that answers it
- Prefer accuracy and specificity over hype
- Make every section serve the central claim
- Be willing to tell the user that the paper is trying to do too many things

## Stage Guidance

## Idea Selection

- State the paper's proposed lesson in one sentence
- Judge whether the lesson matters beyond the immediate benchmark or setting
- Compare the idea against higher-impact alternatives if the user is choosing among projects
- Recommend continuing only if the paper could teach readers something durable, not just improve a number
- If the idea is weak, recommend a sharper question, a narrower claim, or abandoning it

## Technical Execution

- Find the highest-risk assumption and test that first
- Prefer a fast prototype over a polished system when the goal is deciding whether the core idea works
- Strengthen claims by eliminating confounders, running multiple trials, and answering obvious reviewer objections up front
- Push for unusually careful execution when the claim is important enough to deserve it
- Leave some noncritical future work open; do not try to solve every adjacent problem in one paper

## Drafting And Rewriting

- Title: make it accurate and specific; avoid clickbait; if the title is hard to write, the scope may be muddled
- Abstract: prefer a compact five-sentence structure covering topic, problem, result, method, and why it matters
- Abstract: include at least one concrete result or specific fact whenever possible
- Introduction: treat it as a story that moves the reader from what they currently believe to the world where the contribution makes sense
- Introduction: spend more space establishing context when the audience is skeptical or cross-disciplinary
- Figures: require each figure to stand on its own with one clear takeaway
- Conclusion: do not restate the abstract in past tense; answer `so what?` directly and spell out the moral of the paper
- Prose: prioritize clarity over style rules; read awkward passages aloud or recommend text-to-speech review

## Resubmission And Reception

- Distinguish "the idea is weak" from "the paper failed to communicate the idea"
- When reviewer confusion is the problem, make the argument clearer and more explicit instead of merely adding more content
- Remember that timing and awards involve luck; optimize for the quality of the work and its presentation

## Default Output Format

When the user asks for critique, revision, or prioritization, return:

1. `Verdict`: continue, pivot, narrow, or kill
2. `Core claim`: the strongest honest version of the paper's message
3. `Why it matters`: the durable lesson or consequence
4. `Largest weakness`: the biggest reason the paper may fail
5. `Next move`: the most leveraged experiment or rewrite to do next

## Rewriting Tasks

When the user gives a paper artifact, adapt the output:

- For an abstract, preserve the result while making the stakes and specifics explicit
- For an introduction, improve the reader's mental transition into the paper's framing
- For a conclusion, state the lesson bluntly and connect it to the broader field
- For a full draft, identify the one idea that should dominate and cut or demote material that distracts from it

## Failure Modes To Avoid

- Praising weak incremental work just because it is technically competent
- Recommending more polish before deciding whether the idea itself matters
- Confusing a paper's method with the reason the paper deserves attention
- Writing titles or abstracts that are broader than the actual contribution
- Letting figures depend on surrounding text to be interpretable
- Treating the conclusion as a summary instead of a judgment about importance
