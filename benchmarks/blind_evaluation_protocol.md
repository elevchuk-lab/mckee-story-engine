# Double-Blind Evaluation Protocol: McKee Story Engine

> **Status:** Proposed Protocol & Test Dataset Specification (Awaiting Trial Execution & Empirical Data Collection).  
> **Purpose:** Formalizes a controlled, double-blind human rating methodology to test whether the **McKee Story Engine** produces measurable improvements in narrative craft over standard (Vanilla) and generic prompted LLM baselines.

---

## 1. Study Design: Three-Condition Double-Blind Protocol

To isolate whether performance gains derive from **McKee's specific dramatic pentalogy** rather than simply from providing a detailed system prompt, the evaluation includes a three-condition comparison:

1. **Test Dataset:** 12 diverse scenarios across drama, comedy of manners, executive memos, action, and multilingual dialogue defined in [`blind_eval_scenes.json`](blind_eval_scenes.json).
2. **Experimental Conditions (Generation Triads):**
   - **Condition A (Vanilla Baseline):** Scene prompt sent to target model with default system instructions.
   - **Condition B (McKee Story Engine):** Same prompt sent to the exact same model with `SKILL.md` (or prompt template) loaded.
   - **Condition C (Strong Generic Prompt Control):** Same prompt sent with a strong, concise generic craft prompt:  
     *`"Write with rich dramatic subtext, avoid on-the-nose emotional exposition, maintain compelling conflict, and ensure the scene's emotional stakes turn dynamically."`*  
     *(This controls for prompt-length effect and general advice to "write well").*
3. **Execution Controls:**
   - Evaluated across active frontier and open LLM architectures at trial time, recording exact model checkpoint/snapshot IDs, sampling temperature ($T=0.7$), top-p, and generation timestamps.
4. **Blinding & Randomization:**
   - Strip all internal tags, structural X-Ray headers, and diagnostic notes from outputs.
   - Anonymize and randomly permute conditions into `Sample 1`, `Sample 2`, and `Sample 3` per scene.
   - Human raters (screenwriters, fiction editors, literary critics) receive only the prompt and blinded texts.

---

## 2. Six Scoring Rubrics (1–5 Likert Scale)

Each evaluator independently scores each sample across five specific dimensions plus one holistic preference dimension:

### 1. Subtext Depth vs. On-the-Nose Speech
- **1 (Unacceptable):** Pure informational exposition; characters state their exact feelings, fears, and themes aloud.
- **3 (Acceptable):** Some restraint and hesitation, but key emotional truths are stated directly during turning points.
- **5 (Masterful):** Words function as tactical weapons; emotion is routed through behavior, physical objects (The Third Thing), or pauses.

### 2. Value Turn Velocity & The Gap
- **1 (Flat):** No value shift; the emotional or situational polarity at the end of the scene matches the start (`+ → +` or `- → -`).
- **3 (Predictable):** Value flips, but predictably across conventional narrative beats without a sharp Gap.
- **5 (Irreversible & Earned):** Objective reality violates subjective expectation; the value flips irreversibly through costly choice under fire.

### 3. Preservation of Authorial Voice & Genre Fit
- **1 (Homogenized):** The model overrides the author's tone, forcing an unfitting generic noir, cynical melodrama, or corporate PR template.
- **3 (Passable):** Tone mostly matches the genre, but contains occasional AI platitudes or uncalibrated mood swings.
- **5 (Authentic & Tailored):** Respects the author's intended genre (e.g. light comedy of manners, formal procedural, or dry executive memo) while maximizing dramatic friction.

### 4. Antagonism Calibration & Friction
- **1 (Conflict-Averse):** Artificial harmony; conflict is softened or instantly resolved by moralizing dialogue.
- **3 (Standard Conflict):** Clear opposition, but antagonist lacks compelling causal justification.
- **5 (Rigorous Antagonism):** Fully calibrated conflict; antagonist operates with compelling internal logic; true dilemmas force a choice between Two Irreconcilable Goods or Lesser of Two Evils.

### 5. Acoustic Sentence Craft & Cadence
- **1 (Flaccid / AI Tics):** Cumulative loose sentences, monotonous syntax length, cliché padding words (*"testament to", "delve into"*).
- **3 (Competent):** Grammatically clean and readable, but neutral cadence.
- **5 (Dynamic & Periodic):** Deliberate pausal structure; punch-words held until the final syllable of key lines; contrast between short visceral root verbs and abstract nouns.

### 6. Holistic Preference (Blind Forced-Choice & Overall Rating)
- Evaluator indicates overall artistic preference (`Sample 1 vs. 2 vs. 3`) and assigns a general 1–5 score reflecting reader engagement and literary credibility, independent of specific rubric categories.

---

## 3. Statistical Analysis & Evaluation Reporting

When trial data is collected:
- **Effect Size Reporting:** Report mean score differentials ($\Delta_{\text{B vs A}}$, $\Delta_{\text{B vs C}}$) alongside 95% bootstrap confidence intervals and effect sizes (Cohen's $d$ and Wilcoxon signed-rank effect size $r$).
- **Pairwise Win Rates:** Report the percentage of trials where Condition B is preferred over Condition A and Condition C in the holistic forced-choice evaluation.
- **Genre-Specific Disaggregation:** Separately analyze performance across dramatic dialogue, comedy, corporate memos, and multilingual scenes.
- **Null Hypothesis Note:** If $\Delta_{\text{B vs C}}$ does not demonstrate a positive differential, the hypothesis that McKee's structured pentalogy architecture provides specific advantage over generic prompting is rejected.

---

## 4. Evaluation Tooling & Automated Calculator

1. **Evaluator Scorecard Template:**
   Use [`evaluator_sheet_template.csv`](evaluator_sheet_template.csv) to collect independent human ratings across the 12 scenes.
2. **Automated Analysis & Report Generator:**
   Run [`calculate_scores.py`](calculate_scores.py) to process completed scorecards:
   ```bash
   python3 benchmarks/calculate_scores.py --csv path/to/completed_scores.csv --output benchmarks/TRIAL_RESULTS.md
   ```
   Or run the built-in self-test / mock evaluation simulation:
   ```bash
   python3 benchmarks/calculate_scores.py --mock
   ```
