# Robert McKee Story Engine (Complete Pentalogy Edition 1997–2022)

[![ORCID: 0009-0006-7103-0823](https://img.shields.io/badge/ORCID-0009--0006--7103--0823-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0006-7103-0823)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Models](https://img.shields.io/badge/Models-Claude%20%7C%20GPT--4o%2Fo3%20%7C%20Gemini%20%7C%20Local%20LLMs-blue)](#installation--multi-model-setup)
[![Agent Skill](https://img.shields.io/badge/Format-SKILL.md%20%2B%20XML%20%2B%20Cursor-emerald)](#repository-structure)
[![Examples](https://img.shields.io/badge/Showcases-5%20Full%20Benchmarks-amber)](#five-operational-modes--full-benchmark-examples-show-dont-tell)
[![Patreon](https://img.shields.io/badge/Support-Patreon-F96854?logo=patreon&logoColor=white)](https://www.patreon.com/elevchuk)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?logo=paypal&logoColor=white)](https://paypal.me/elevchuk)

An open-source narrative architecture, script-doctoring, storynomics, action pacing, and psychological film-teardown engine distilled from **Robert McKee's complete five-volume life's work**:
- ***Story*** (1997) — Substance, Structure, Style, and the Principles of Screenwriting
- ***Dialogue*** (2016) — The Art of Verbal Action for Page, Stage, and Screen
- ***Storynomics*** (2018, with Thomas Gerace) — Story-Driven Marketing and Causal Executive Narratives in the Post-Advertising World
- ***Character*** (2021) — The Art of Role and Cast Design for Page, Stage, and Screen
- ***Action*** (2022, with Bassim El-Wakil) — The Art of Excitement for Screen, Page, and Game

---

## ⚡ One-Line Install (Claude Code & Google Antigravity)

```bash
curl -fsSL https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/install.sh | sh
```
*(Installs `mckee-story-engine` globally to `~/.claude/skills/` and locally to `.agent/skills/` if run inside an Antigravity workspace.)*

> **Not a developer? No terminal needed:** Jump to [1-Click Copy for ChatGPT, Claude Web & Gemini](#non-technical-quickstart-chatgpt-claude-web-gemini) to copy-paste the standalone prompt directly into your browser.

---

## Why Default LLMs Fail at Storytelling

Out of the box, modern Large Language Models (Claude, ChatGPT, Gemini, Llama) are trained with RLHF to be *helpful, harmless, and agreeable*. While great for customer support, those exact instincts **destroy dramatic writing, executive memos, essays, and film analysis**:

1. **AI Negaphobia:** LLMs are terrified of dark, irreversible conflict. They soften antagonists, avoid real pain, and rush toward safe, moralizing happy endings.
2. **Flat "Narratives" Instead of Stories:** LLMs chain events chronologically (*"and then... and then..."*) without inverting the underlying binary value charge (`+` ↔ `-`). As McKee warns: *if the value charge at the end of a scene is the same as at the start, nothing happened.*
3. **On-the-Nose "Duologue":** When asked to write dialogue, LLMs make characters state their exact emotions, themes, and backstory directly aloud (*"I'm angry because you never respected my career!"*) instead of fighting through subtext.
4. **Pacing Flaccidity & Safe Climax:** Action sequences devoid of true physical dread, power asymmetry, or consequence, resolved by random coincidence rather than costly choices under fire.

**The McKee Story Engine overrides these RLHF defaults** with explicit structural mechanics: Value Pendulums, The Gap, The Negation of the Negation (`--`), True Dilemmas (`+ vs +` or `- vs -`), Contradiction Axes, Subtextual Action Gerunds, Cross-Linguistic Acoustics, "The Third Thing" (Trialogue), and **Set Piece Engineering** (*Action Triad*, *Power Asymmetry*, and *Hero at the Mercy*).

---

## Five Operational Modes & Full Benchmark Examples ("Show, Don't Tell")

Explore the [`examples/`](examples/) directory to see complete, unedited outputs across all five modes:

| Mode | Full Benchmark Artifact | What It Demonstrates |
| :--- | :--- | :--- |
| **1. `DEEP TEARDOWN`** | [**`examples/1-deep-teardown-dark-matter.md`**](examples/1-deep-teardown-dark-matter.md) | Complete 6-layer structural & Jungian shadow teardown of Apple TV+'s *Dark Matter* (Controlling Idea, Square of Antagonism to `--`, Solar System of Jason variants, Quantum Box as skull metaphor). |
| **2. `STORYNOMICS`** | [**`examples/2-storynomics-bezos-memo-and-essay.md`**](examples/2-storynomics-bezos-memo-and-essay.md) | Side-by-side transformation of a corporate slide deck (suffering from *Negaphobia*) into a causal **Jeff Bezos 6-page executive memo** + an 8-stage founder essay for LinkedIn/Telegram. |
| **3. `ARCHITECT`** | [**`examples/3-architect-solar-system-cast.md`**](examples/3-architect-solar-system-cast.md) | Designing a prestige biotech thriller protagonist using McKee's **5-Axis Contradiction Grid** (*Mask vs. True Character*) and a **Solar System Cast** where each supporting character pressures a specific axis. |
| **4. `SCRIPT DOCTOR`** | [**`examples/4-script-doctor-scene-audit.md`**](examples/4-script-doctor-scene-audit.md) | Auditing an on-the-nose co-founder betrayal scene with a **4-Column Beat Diagnostic Table** (*Action Gerunds*) and rewriting it via **Trialogue ("The Third Thing": a dead vintage watch)** and Periodic sentences. |
| **5. `ACTION & PACING DOCTOR`** | [**`examples/5-action-set-piece-breakdown.md`**](examples/5-action-set-piece-breakdown.md) | Auditing a toothless action scene and transforming it into an engineered **Set Piece** (Action Triad, Power Asymmetry, "Hero at the Mercy", Midpoint Sag cure, Screen/Page/Game adaptations). |

---

## Before & After Snapshot (`SCRIPT DOCTOR` Mode)

**Prompt:** *Write a scene where a husband confronts his workaholic wife about feeling neglected.*

| Default LLM (On-the-Nose Duologue) | McKee Story Engine (Trialogue via "The Third Thing" + Gerunds) |
| :--- | :--- |
| **Mark:** "Sarah, we need to talk. You're always on your laptop and I feel like you don't care about our marriage anymore."<br>**Sarah:** "That's not fair, Mark! I work this hard because I saw my parents lose everything, and I'm terrified of going broke." | **[X-Ray: Guilt-tripping vs. Stonewalling routed through an unopened restaurant receipt. Value: `+ truce → -- weaponized coldness`]**<br><br>Mark smoothed the crumpled receipt on the granite counter between them. "One seat. Nine-fifteen PM."<br>Sarah didn't look up from her spreadsheet. "The risotto was overcooked. Put it in the tax folder."<br>"I kept the porch light on until midnight."<br>Sarah closed the laptop—slowly, deliberately—and aligned the edges of the receipt with her thumb. "That bulb costs four cents an hour, Mark. Somebody in this house has to pay for the electricity." |

---

## Multilingual & Cross-Linguistic Support (EN / RU / ES / DE / FR / ZH / KK / AR)

While the engine's architectural rules and foundational references are authored in English to ensure maximum reasoning fidelity and instruction adherence across frontier LLMs, **the engine accepts inputs, source texts, screenplays, and narrative fragments in any language and outputs its analysis, diagnostic audits, and creative deliverables in the language requested by the user or the native discourse**:

1. **Adaptive Linguistic Realization:**
   - **Russian / Slavic Languages:** Accounts for Pro-Drop flexibility, expressive word order, synthetic aspectual verbs (perfective vs. imperfective action beats), and passive bureaucratic nominalizations (*канцелярит*) used as an emotional shield.
   - **Romance Languages (Spanish, French, Italian):** Calibrates subjunctive mood evasions, register shifts (*tu/usted*), and clitic pronoun distancing under pressure.
   - **Germanic Languages (German):** Leverages modal particle inflation (*ja, eben, halt, eigentlich*) and state passives (*Zustandspassiv*) to expose subconscious resistance.
   - **High-Context / Asian & Middle Eastern (ZH / KK / AR):** Calibrates against Western directness bias; distinguishes respectful indirectness and collective responsibility from authentic deception or weakness.

2. **Cross-Linguistic Acoustics:**
   - In [`3-dialogue-and-subtext.md`](skills/mckee-story-engine/references/3-dialogue-and-subtext.md), McKee's *Anglo-Saxon vs. Latinate Diction* polarity is mathematically generalized: contrasting **short, visceral root verbs and somatic nouns** (spoken truth under fire) against **defensive bureaucratic abstractions and Latinate polysyllables** used by characters to hide vulnerability.

---

## Repository Structure

```text
mckee-story-engine/
├── README.md                                         # Architecture, benchmarks & pentalogy documentation
├── LICENSE                                           # MIT License
├── .gitignore                                        # Clean git hygiene (no binary ebooks tracked)
├── .cursorrules                                      # Drop-in rules for Cursor IDE / Windsurf
├── install.sh                                        # 1-line POSIX installer for Claude Code & Antigravity
├── examples/                                         # 5 Complete Benchmark Outputs ("Show, Don't Tell")
│   ├── 1-deep-teardown-dark-matter.md                # Mode 1: Film/Series 6-Layer X-Ray
│   ├── 2-storynomics-bezos-memo-and-essay.md         # Mode 2: Bezos Narrative Memo + Founder Essay
│   ├── 3-architect-solar-system-cast.md              # Mode 3: 5-Axis Contradiction Grid & Cast Design
│   ├── 4-script-doctor-scene-audit.md                # Mode 4: Beat Table Audit & Subtextual Rewrite
│   └── 5-action-set-piece-breakdown.md               # Mode 5: Action Set Piece & Pacing Audit
├── skills/
│   └── mckee-story-engine/                           # Modular Agent Skill (Claude Code / Antigravity)
│       ├── SKILL.md                                  # Router, Iron Laws & cross-linguistic directives
│       └── references/                               # 5 Foundational Reference Treatises
│           ├── 1-story-architecture.md               # From "Story" (1997)
│           ├── 2-character-design.md                 # From "Character" (2021)
│           ├── 3-dialogue-and-subtext.md             # From "Dialogue" (2016) + Cross-Linguistic Acoustics
│           ├── 4-storynomics-and-teardown.md         # From "Storynomics" (2018) + Deep Teardown X-Ray
│           └── 5-action-suspense-and-pacing.md       # From "Action" (2022) + Set Piece Engineering
└── prompts/                                          # Standalone System Prompts per Model Family
    ├── claude-project.xml                            # XML-structured prompt for Claude Projects (Sonnet/Opus)
    ├── chatgpt-system-prompt.md                      # Markdown instructions for ChatGPT / Custom GPTs / o1 / o3
    ├── gemini-gem.md                                 # Instructions for Google Gemini Gems & AI Studio
    └── local-llm-compact.md                          # High-density + Few-Shot prompt for Ollama / Llama / Qwen / DeepSeek
```

---

## Installation & Multi-Model Setup

### 1. Automated CLI Install (Claude Code & Google Antigravity)
```bash
curl -fsSL https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/install.sh | sh
```
Or copy manually after cloning:
```bash
cp -r skills/mckee-story-engine ~/.claude/skills/
cp -r skills/mckee-story-engine /path/to/your/workspace/.agent/skills/
```

### 2. Non-Technical Quickstart (ChatGPT, Claude Web, Gemini)
If you are a writer, filmmaker, marketer, or founder using web chat interfaces:
- **For Claude Projects (Claude.ai):** Open [`prompts/claude-project.xml`](prompts/claude-project.xml), click **Copy raw file**, and paste it into your **Project Instructions**. *(Optional: upload the 5 files from `skills/mckee-story-engine/references/` into Project Knowledge).*
- **For ChatGPT / Custom GPTs:** Open [`prompts/chatgpt-system-prompt.md`](prompts/chatgpt-system-prompt.md), copy the raw text into **Custom GPT Instructions**, and upload the 5 `references/` files into **Knowledge**.
- **For Google Gemini Gems / AI Studio:** Copy [`prompts/gemini-gem.md`](prompts/gemini-gem.md) into your **Gem Instructions**.

### 3. Local LLMs (Ollama, LM Studio, OpenWebUI, vLLM)
Copy the compact prompt and Few-Shot block inside [`prompts/local-llm-compact.md`](prompts/local-llm-compact.md) directly into your `Modelfile` (`SYSTEM """..."""`) or LM Studio System Prompt box.

### 4. Cursor / Windsurf IDE
Copy [`.cursorrules`](.cursorrules) to the root of your writing, screenwriting, or content repository.

---

## Quick Trigger Commands

Once installed, invoke any mode in English or your native language:
- `[DEEP TEARDOWN] Analyze the hidden Controlling Idea, Negation of the Negation, and character shadow system in Apple TV's "Severance".`
- `[STORYNOMICS] Turn this personal realization about founder burnout into a high-tension essay for Threads/LinkedIn with a 6–8 second Mind-Opening climax.`
- `[ARCHITECT] Help me design a Solar System cast and a 5-axis contradiction grid for a neo-noir thriller.`
- `[SCRIPT DOCTOR] Audit this dialogue scene beat-by-beat using Action Gerunds, introduce a Third Thing, and rewrite it.`
- `[ACTION & PACING DOCTOR] Audit this sagging midpoint chase scene: establish Power Asymmetry, engineer a Set Piece with sensory verbs, and stage a Hero at Mercy crisis.`

---

## Project Status & Evolution Roadmap (Early Stage)

**Robert McKee Story Engine is in active, early-stage development.**

1. **From Classical Dramaturgy to the Complete Pentalogy:**  
   The algorithmic formalization of Robert McKee's complete five-volume pentalogy (*Story*, *Dialogue*, *Storynomics*, *Character*, and *Action*) establishes an unmatched foundation across screenwriting, literary prose, and interactive game narrative design.
2. **Practitioner-Driven Calibration:**  
   The engine is continuously refined through empirical testing by screenwriters, novelists, startup founders, and AI prompt engineers. We systematically test frontier LLM behavior on complex dramatic scenes, purge residual AI agreeableness ("negaphobia"), and sharpen subtextual authenticity.
3. **Community Contributions:**  
   Propose scene audits, share script-doctoring breakdowns, or suggest new dramatic paradigms via [GitHub Issues](https://github.com/elevchuk-lab/mckee-story-engine/issues) — standout benchmarks and analytical cases will be integrated into the core showcase library.

---

## Support the Lab & Upcoming Skills

If the **Robert McKee Story Engine** has sharpened your writing, scripts, or agent workflows, you can support ongoing open-source research and get early access to upcoming cognitive skills (**Decision Architecture, Strategic Audits, Executive Team Facilitation**) on Patreon:

- **Direct Support (PayPal):** [paypal.me/elevchuk](https://paypal.me/elevchuk)
- **Patreon (Architect's Lab):** [patreon.com/elevchuk](https://www.patreon.com/elevchuk)

---

## Trademark & Copyright Disclaimer

This repository is an **independent, open-source educational and engineering research project** developed by Yevgeniy Levchuk. It algorithmically formalizes classical dramatic principles for Large Language Models (LLMs) and autonomous AI coding agents.

- **Intellectual Property Attribution:** The names "Robert McKee", "Story", "Dialogue", "Storynomics", "Character", and "Action", as well as foundational dramatic concepts (*The Gap*, *Controlling Idea*, *Negation of the Negation*, *Square of Antagonism*, *Trialogue*, *Action Triad*, *Hero at the Mercy*), refer to the seminal books and methodologies authored by **Robert McKee** (with Tom Gerace for *Storynomics*, and Bassim El-Wakil for *Action*). All original book content, trademarks, and associated intellectual property belong exclusively to Robert McKee, McKee Storylogue LLC, and their respective publishers (HarperCollins Publishers, Hachette Book Group, Bloomsbury).
- **Non-Affiliation Notice:** This project is **not** endorsed by, directly affiliated with, maintained, authorized, or sponsored by Robert McKee, McKee Storylogue LLC, or any of their affiliates. The use of Robert McKee's name and book titles is strictly for nominative fair use (educational synthesis, identification, and academic reference) to accurately describe the theoretical storytelling framework implemented in this software.
- **Software License:** The original software architecture, markdown schemas, `SKILL.md` orchestrators, diagnostic workflows, system prompts, and example benchmark files authored by Yevgeniy Levchuk are open-source and released under the [MIT License](LICENSE).

---

## Citation & Academic Attribution

If you utilize this engine or narrative physics architecture in academic research, script analysis, or computational narratology, please cite:

```bibtex
@software{levchuk_mckee_2026,
  author       = {Levchuk, Yevgeniy},
  title        = {{Algorithmic Implementation of Robert McKee's Narrative Pentalogy: Story, Dialogue, Character, Action \& Subtext}},
  version      = {v1.1.1},
  year         = {2026},
  month        = nov,
  publisher    = {GitHub},
  url          = {https://github.com/elevchuk-lab/mckee-story-engine},
  note         = {ORCID: https://orcid.org/0009-0006-7103-0823}
}
```

---

## License & Attribution

Created by **[Yevgeniy Levchuk](https://orcid.org/0009-0006-7103-0823)** ([@elevchuk-lab](https://github.com/elevchuk-lab)) and released under the [MIT License](LICENSE). All dramatic theory foundations are credited with deepest gratitude to the lifetime works of **Robert McKee** (*Story*, *Dialogue*, *Storynomics*, *Character*, and *Action*).
