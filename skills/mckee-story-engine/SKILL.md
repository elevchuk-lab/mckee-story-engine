---
name: mckee-story-engine
description: Use when writing, editing, diagnosing, or analyzing stories, screenplays, novels, essays, dialogues, characters, brand narratives, executive memos, or film/TV scripts. Also use when texts feel flat, AI-generated, conflict-averse, or on-the-nose, or when decoding hidden meaning and psychological depth in films, series, or literature.
---

# Robert McKee Story Engine (Tetralogy Edition)

## Overview

Principles—never mechanical formulas—distilled from Robert McKee's complete tetralogy: ***Story*** (1997), ***Dialogue*** (2016), ***Storynomics*** (2018), and ***Character*** (2021).

LLMs suffer from three structural defects caused by RLHF training:
1. **Negaphobia:** Fear of the negative, leading to toothless conflict, safe choices, and premature happy endings.
2. **Flat "Narratives" vs. Stories:** Listing chronological activities (`and then... and then...`) where the value charge never flips.
3. **On-the-Nose Duologue:** Characters stating their exact inner feelings and exposition directly in text instead of acting through subtext.

This engine overrides those defaults using strict dramatic mechanics.

## Operational Router

Select the primary mode based on the user's request and load the required reference file(s) from `references/`:

| Mode | When to Trigger | Required Reference Files |
|------|-----------------|--------------------------|
| **1. DEEP TEARDOWN** | Analyzing a film, TV series, novel, or script for hidden meaning, Controlling Idea, character variants, or psychological depth. | `references/4-storynomics-and-teardown.md` + `references/1-story-architecture.md` |
| **2. STORYNOMICS** | Writing brand stories, Threads/LinkedIn/Telegram essays, landing pages, founder pitches, case studies, or Bezos-style 6-page causal memos. | `references/4-storynomics-and-teardown.md` |
| **3. ARCHITECT** | Designing a story, novel, screenplay, cast of characters, or scene from scratch. | `references/1-story-architecture.md` + `references/2-character-design.md` |
| **4. SCRIPT DOCTOR** | Auditing, rewriting, or sharpening an existing draft, scene, or dialogue pass that feels flat or artificial. | `references/3-dialogue-and-subtext.md` + `references/1-story-architecture.md` |

---

## Non-Negotiable Iron Laws (All Modes)

1. **No Value Shift = No Scene:** Every scene and story must turn the charge of a human life value (`+` to `-`, or `-` to `+`) through conflict. If the value charge at the end of a scene is identical to the beginning, cut the scene or rewrite it into a clash.
2. **True Choice Only:** A choice between good and evil is trivial. Crisis decisions must force the protagonist between **Two Irreconcilable Goods (`+` vs `+`)** or the **Lesser of Two Evils (`-` vs `-`)**.
3. **Dimensions are Contradictions, Not Adjectives:** Never describe a character with flat traits ("smart, loyal, ambitious"). Build characters out of **consistent contradictions** between their outer mask (*Characterization*) and who they prove to be under fire (*True Character*).
4. **Action Over Activity in Dialogue:** Words are tactical weapons. Always distinguish surface *Activity* (drinking coffee, discussing weather) from subtextual *Action* (what the speaker is *doing* to the listener, defined by an active **gerund**: *baiting*, *begging*, *humiliating*, *evading*).
5. **Kill Duologue with "Trialogue" (The Third Thing):** When two characters confront an emotional truth, route their conflict through a **Third Thing** (an object, task, or external topic) so the emotion lives in the subtext rather than on the nose.
6. **Cure Negaphobia:** Never start persuasive or dramatic writing in a safe positive state that merely gets "better." Anchor the opening in a sharp negative imbalance or existential threat, and push antagonism all the way to the **Negation of the Negation** (`--`).

## Execution Workflow

1. **Identify Mode** (`DEEP TEARDOWN`, `STORYNOMICS`, `ARCHITECT`, or `SCRIPT DOCTOR`) and read the mapped `references/*.md` file(s).
2. **Run the Structural X-Ray first:** Before generating prose or analysis, explicitly define the **Core Binary Value** (`+/-`), **Controlling Idea** (`Value + Cause`), **The Gap** (Subjective Expectation vs. Objective Reality), and **Subtextual Gerunds**.
3. **Deliver Output:** Follow the exact diagnostic/writing templates defined in the loaded reference file.

---

## Legal & Attribution Notice
This skill is an independent open-source implementation for AI agents. Theoretical concepts and book references (*Story*, *Dialogue*, *Storynomics*, *Character*) are the intellectual property of Robert McKee / McKee Storylogue LLC and are referenced strictly under nominative fair use for pedagogical and algorithmic modeling.
