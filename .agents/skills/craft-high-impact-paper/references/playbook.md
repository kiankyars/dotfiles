# Best-Paper Playbook

This reference distills the research and writing philosophy from Nicholas Carlini's essay "How to win a best paper award (or, an opinionated take on how to do important research that matters)" published on March 9, 2026.

Source:
- https://nicholas.carlini.com/writing/2026/how-to-win-a-best-paper-award.html

Use this file when you need detailed criteria, checklists, or rewrites that stay faithful to the essay's core ideas.

## Central Thesis

The real target is not "win an award." The real target is work that:

- advances knowledge
- is technically accurate
- is approachable enough that other people can understand and use it

Awards, acceptance outcomes, and timing depend partly on luck. The controllable part is the quality of the distribution you produce.

## Problem Taste Rubric

Ask these questions first:

- If this project succeeds completely, what would readers learn that matters?
- Is the contribution important outside the narrow benchmark or dataset?
- Does it change how people should think, measure, build, or defend something?
- Is the problem inevitable enough that the field will eventually have to confront it?
- Is the idea merely a local improvement, or does it reveal a broader lesson?

Warning signs:

- The best-case conclusion is "our method improves metric X by a small amount"
- The project exists mainly because the experiment is easy to run
- The paper is only interesting to people already invested in one narrow setup
- The title needs to promise too many different contributions

Recommended response:

- sharpen the question
- narrow the claim to the part that actually matters
- demote the work to a workshop paper or blog post
- kill the project and move on

## Project Selection And Prioritization

Use ruthless prioritization:

- compare projects by likely impact, not by how close they are to completion
- do not protect sunk cost
- if a far more important idea appears, consider pivoting immediately

Counterweight:

- new ideas often feel more exciting just because they are new
- only pivot after comparing plausible upside, not raw novelty

## Technical Execution Checklist

De-risk early:

- identify the assumption most likely to invalidate the paper
- build the smallest experiment that can test that assumption
- avoid polishing infrastructure before proving the idea is alive

Strengthen the argument:

- run multiple trials when variance matters
- control obvious confounders
- answer reviewer objections before reviewers ask them
- tighten loose claims such as "sometimes" into stronger supported statements when warranted

Do not oversolve:

- solve the central problem decisively
- leave nonessential extensions open if they are not required for the main claim

## Abstract Formulas

Default five-sentence structure:

1. Name the topic or setting
2. State the concrete problem
3. State the key result or method
4. State whichever of result or method did not fit in sentence three
5. State why the paper matters

Alternative short structure for narrow audiences:

1. State the main claim
2. State the evidence, method, or data that supports it
3. State the consequence or impact

Abstract rules:

- include at least one specific number or concrete fact when possible
- avoid hedging away the main message
- say the clean true result, not a vague approximation of it
- make the importance legible inside the abstract itself

## Introduction Story Arc

Think of the introduction as a story with three beats:

1. Start from the reader's current worldview
2. Move them into the paper's setting and stakes
3. Deliver the contribution inside that frame

Use a longer setup when:

- the audience is outside the paper's native area
- the premise of the paper is not yet widely accepted
- the reader would otherwise reject the claim before seeing the evidence

The introduction fails when:

- it presents the result before the reader is ready to care
- it assumes background the target audience does not have
- it spends too long on preliminaries and never reaches the action

## Title Guidance

The title matters less than the paper, but it still needs to:

- be accurate
- be specific enough for the right readers to find it
- avoid clickbait or overstating the scope

If the title is impossible to make clean and precise, suspect that the paper is trying to do more than one thing.

## Figure Guidance

Each figure should work for a skimming reader.

Every figure should have:

- one main takeaway
- a caption that explains the takeaway directly
- enough context to interpret the plot without reading surrounding paragraphs

If a figure cannot be explained cleanly in its caption:

- split it into multiple figures
- simplify the story it is trying to tell

## Conclusion Guidance

The conclusion is not:

- an abstract in past tense
- a compressed replay of the introduction

The conclusion is:

- the answer to "so what?"
- the paper's moral
- a brief reflection on the important lesson the reader should carry forward

Useful test:

- write the paper's best-case conclusion before doing the work
- if even the best-case conclusion sounds unimportant, the project likely is

## Writing Guidance

Favor communication over formal rule-following.

Practical habits:

- read sentences aloud
- use text-to-speech on drafts
- remove wording that leads readers toward the wrong interpretation
- place the emphasis on the words that matter most
- cut unnecessary words without making the prose abrupt or cryptic

Do not overinvest in proofreading at the expense of more important work, but do remove errors that make the writing feel careless.

## Review Template

When critiquing a draft or idea with this skill, structure the response around:

1. The strongest honest claim
2. The field-level reason the claim matters
3. The single biggest reason the paper may not land
4. The one experiment or rewrite that would most improve it
5. Whether the project should continue, narrow, pivot, or die
