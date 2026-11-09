# Changelog

All notable changes to the Robert McKee Story Engine will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v2.0.0] - 2026-11-11

### Major Milestone Release
- **Unified Algorithmic Pentalogy Engine:**
  - Formal synthesis of Robert McKee's complete five-volume life's work: *Story* (1997), *Dialogue* (2016), *Storynomics* (2018), *Character* (2021), and *Action* (2022).
  - 6 operational modes: Deep Teardown, Storynomics, Architect, Script Doctor, Action & Pacing Doctor, Quick Audit.
- **Scientifically Rigorous Double-Blind Evaluation Framework:**
  - Standardized 12-scenario benchmark dataset across 4 languages in `benchmarks/blind_eval_scenes.json`.
  - Three-condition experimental design (Condition A: Vanilla Baseline, Condition B: McKee Engine, Condition C: Strong Generic Craft Control).
  - Zero-dependency statistical analysis engine (`benchmarks/calculate_scores.py`) featuring clustered bootstrap (resampling by scene), exact permutation Wilcoxon signed-rank distribution ($2^{12} = 4,096$ exact sign permutations), Cohen's $d_z$, and matched-pairs rank-biserial effect sizes.
- **Verified Bibliographical Registry (`SOURCES.md`):**
  - Fully cataloged and verified primary editions from official publishers (HarperCollins, Twelve / Hachette) with automated ISBN-13 checksum validation.
- **Production-Grade Agent & IDE Integrations:**
  - Cross-platform agent skill (`SKILL.md`), Claude Project XML (`prompts/claude-project.xml`), ChatGPT system instructions, Gemini Gem instructions, Local LLM compact prompt, and Cursor rules (`.cursorrules`).
  - Automated 7-part regression test suite (`tests/verify_repo.sh`).

---

## [v1.1.9] - 2026-11-11

### Added
- **Exact Permutation Wilcoxon Distribution ($N \le 25$):**
  - Upgraded `wilcoxon_signed_rank()` in `benchmarks/calculate_scores.py` from asymptotic normal approximation to an **exact permutation distribution** calculated via subset-sum dynamic programming with tie-scaled integer ranks.
  - Completely eliminates normal approximation error near the $\alpha = 0.05$ threshold for trial sample sizes ($N = 12$ evaluates all $2^{12} = 4,096$ exact sign permutations).
  - Adopted matched-pairs rank-biserial correlation $r = (W^+ - W^-) / (W^+ + W^-)$ for non-parametric effect size reporting.
- **Regression Test Suite:**
  - Extended `tests/verify_repo.sh` block [4/7] to assert exact permutation $p$-values and rank-biserial correlation.

---

## [v1.1.8] - 2026-11-11

### Fixed
- **Accurate *Character* ISBN-13 & Bibliographical Verification (`SOURCES.md`):**
  - Corrected *Character: The Art of Role and Cast Design for Page, Stage, and Screen* (2021) ISBN-13 to **`978-1455591954`** (hardcover edition, Twelve / Hachette Book Group) and updated publisher catalog URL.
  - Independently verified against publisher catalogs the remaining volumes: *Story* (`978-0060391683`, HarperCollins), *Dialogue* (`978-1455591916`, Twelve / Hachette), *Storynomics* (`978-1538727935`, Twelve / Hachette), and *Action* (`978-1538726914`, Twelve / Hachette).
- **Statistical Unit-of-Analysis Alignment (`benchmarks/calculate_scores.py`):**
  - Unified the analysis unit for both the cluster bootstrap and the Wilcoxon signed-rank test on scene-level consensus means ($N=12$ independent scene clusters).
  - Evaluators evaluating the same scene are averaged into scene consensus scores prior to paired differences, eliminating pseudoreplication in the hypothesis test $p$-values.
- **Automated Regression Suite (`tests/verify_repo.sh`):**
  - Updated line 150 to assert the presence of verified ISBN-13 `978-1455591954`.

---

## [v1.1.7] - 2026-11-11

### Fixed
- **Corrected Paired Wilcoxon Signed-Rank Algorithm (`benchmarks/calculate_scores.py`):**
  - Fixed a critical indexing bug in tied-rank handling: ranks assigned across a tie group now strictly retain each individual pair's sign (`ranked[k][1]`) rather than erroneously inheriting the sign of the first item in the group (`ranked[i][1]`).
  - Added variance tie-correction penalty $\sum (t^3 - t) / 48$ and continuity correction ($0.5$), ensuring mathematical consistency with standard Wilcoxon signed-rank formulations.
- **Clustered Bootstrap Resampling:**
  - Upgraded bootstrap resampling to cluster by scene ($N=12$ independent scene clusters $\times$ 3 evaluators), eliminating artificial variance deflation caused by treating nested rater evaluations as independent observations.
- **Hypothesis Testing Verdict & Simulation Guardrails:**
  - Standardized verdict logic to require both strictly positive 95% cluster-bootstrap confidence intervals ($CI_{\text{low}} > 0$) AND Wilcoxon statistical significance ($p < 0.05$). Added explicit "Mixed Results" reporting when only a subset of dimensions reaches dual significance.
  - Added prominent `[SYNTHETIC MOCK DATA — NOT AN EMPIRICAL TRIAL]` warning banner to `--mock` outputs.
- **Bibliographical Hygiene & Checksum Verification (`SOURCES.md`):**
  - Corrected *Action* (2022) ISBN-13 to `978-1538726914` (matching Hachette and bookstore registries).
  - Removed speculative ISBN-10 entries and unverified chapter numbers for *Story*, *Dialogue*, *Character*, and *Action*, preserving verified Chapter 6 for *Storynomics*.
  - Removed unsubstantiated "verified in CIP / copyright registration" assertions.
- **Automated Regression Test Suite (`tests/verify_repo.sh`):**
  - Added automated ISBN-13 checksum validation across all entries in `SOURCES.md`.
  - Added deterministic unit test for `wilcoxon_signed_rank()` against an analytical test vector with multiple tie groups and opposing signs.

---

## [v1.1.6] - 2026-11-11

### Added
- **Primary Source & Bibliographical Registry (`SOURCES.md`):**
  - Created a definitive reference registry cataloging all 5 volumes of the McKee pentalogy, official publishers (HarperCollins, Twelve / Hachette), ISBNs, Library of Congress data, and chapter mappings for all core dramatic principles.
  - Documented verified historical facts (e.g. Yasmina Reza's *Art* in French francs, co-author names, and *Storynomics* Chapter 6).
- **Double-Blind Evaluation Execution Tooling:**
  - Added [`benchmarks/evaluator_sheet_template.csv`](benchmarks/evaluator_sheet_template.csv) for recording blinded human ratings across 12 test scenes and 3 conditions.
  - Added [`benchmarks/calculate_scores.py`](benchmarks/calculate_scores.py): standalone Python CLI engine implementing the statistical protocol (paired mean differences, 10,000-resample bootstrap 95% confidence intervals, Cohen's $d_z$, Wilcoxon signed-rank tests, and holistic forced-choice win rates).
  - Includes `--mock` self-test generator for immediate end-to-end simulation.
- **Automated Verification:**
  - Extended [`tests/verify_repo.sh`](tests/verify_repo.sh) block [4/7] to verify `SOURCES.md` bibliographic completeness and `calculate_scores.py` mock execution.

---

## [v1.1.5] - 2026-11-11

### Fixed
- **Restoration of Authentic Published Co-Author Name:**
  - Reverted the erroneous substitution of co-author name back to **Bassim El-Wakil** (*Action: The Art of Excitement for Screen, Page, and Game*, 2022, published by Twelve / Hachette Book Group) across `README.md`, `SKILL.md`, `references/5-action-suspense-and-pacing.md`, all prompt templates, and examples.
  - Inverted regression test block [4/7] in `tests/verify_repo.sh` to strictly assert the presence of `Bassim El-Wakil` and ban the erroneous variant `Bassam`.
- **Calibrated Tone in `.cursorrules`:**
  - Updated `.cursorrules` section header from `## 1. Anti-AI Writing Guardrails` to `## 1. Calibrating Conversational Default Tendencies`.
  - Replaced combative "Ban ..." imperatives with constructive craft directives ("Counter Negaphobia & Conflict Avoidance", "Counter Flat Chronology", "Counter On-the-Nose Dialogue", "Counter Pacing Flaccidity"), adding author voice preservation.
  - Added `.cursorrules` to the automated regression suite checking for absence of legacy `Anti-AI` and `RLHF` terminology.

---

## [v1.1.4] - 2026-11-11

### Changed
- **Synchronized Prompt Tone Across All Formats:**
  - Calibrated `prompts/claude-project.xml`, `prompts/chatgpt-system-prompt.md`, `prompts/gemini-gem.md`, and `prompts/local-llm-compact.md` to match the balanced tone of `SKILL.md` and `README.md`.
  - Replaced legacy references to "RLHF defects", "fatal storytelling flaws", and "Anti-AI Overrides" with professional guidance on conversational default tendencies (agreeableness, conflict avoidance, flat chronology, on-the-nose dialogue, unearned climaxes).
  - Added explicit instructions across prompt files to preserve the author's stylistic voice during script-doctoring and rewrites.
- **Calibrated Empirical Claims:**
  - Updated `README.md` repository tree and project status to replace unverified claims of "empirical testing" with "Double-Blind Evaluation Protocol & Benchmark Dataset" and practitioner-informed design.
- **Model Version Specification Neutrality:**
  - Updated the repository Models badge to `Active Frontier & Open LLMs`.
  - In `benchmarks/blind_evaluation_protocol.md`, replaced fixed legacy model references with dynamic specification ("active frontier and open LLM architectures evaluated at trial time, recording snapshot IDs, sampling temperature, and parameters").
- **Bibliographical Orthography (Erroneous Substitution in v1.1.4):**
  - Erroneously substituted authentic co-author name Bassim El-Wakil with Bassam (reverted in v1.1.5).
- **Automated Regression Suite:**
  - Extended `tests/verify_repo.sh` block [4/7] with automated regression guards against legacy prompt phrasing and unverified empirical claims.

---

## [v1.1.3] - 2026-11-11

### Changed
- **Honest Evaluation Protocol Scope:**
  - Renamed benchmark badge from misleading "success" indicator to explicit `Evaluation: Protocol Only (Awaiting Trials)`.
  - Added Condition C (Strong Generic Writing Baseline) to `benchmarks/blind_evaluation_protocol.md` to control for prompt-length effect and general "write well" advice.
  - Replaced arbitrary statistical significance thresholds ($p < 0.01$) with effect size reporting (Cohen's $d$, Wilcoxon $W$) and 95% bootstrap confidence intervals.
  - Added Dimension 6 (Holistic Blended Preference / Forced Choice) to guard against rubric circularity.
  - Clarified model generation parameters (dynamic model versions at test time, recorded with snapshot IDs and sampling temperature).
- **Nuanced Framing of LLM Creative Tendencies:**
  - Softened blanket claims about "RLHF-induced defects" to neutral descriptions of conversational default tendencies (agreeableness, conflict avoidance, on-the-nose exposition).
- **Source Text Hygiene:**
  - Replaced italicized pseudo-quotation in French (*«un tableau blanc de deux cent mille francs»*) with accurate analytical summary of Yasmina Reza's *Art* (1994).
- **Test Suite Calibration:**
  - Block [4/7] in `tests/verify_repo.sh` explicitly designated as regression assertions guarding against known text defects rather than broader "factual verifications."
- **Changelog:**
  - Adopted structured linear release history and dedicated `CHANGELOG.md`.

---

## [v1.1.2] - 2026-11-11

### Added
- **Core Pentalogy vs. Pedagogical Extensions Architecture:**
  - Explicit architectural scope notices added across all 5 reference treatises distinguishing authentic McKee theory from modern pedagogical case studies (*Dark Matter*, *Succession*, *Breaking Bad*).
- **Double-Blind Evaluation Framework:**
  - Added `benchmarks/blind_evaluation_protocol.md` and `benchmarks/blind_eval_scenes.json` (12 test prompt scenarios).
- **Authorial Voice Protection:**
  - Added dedicated doctrine to `SKILL.md` enforcing preservation of the author's original genre, register, and tone during Script Doctor audits.
- **Quick Audit Mode:**
  - Added Mode 6 (`QUICK AUDIT / SCENE POLISH`) for rapid 3-beat diagnosis of passages under 500 words.

### Fixed
- Corrected currency in Yasmina Reza's *Art* from $200,000 to 200,000 francs.
- Corrected acoustic laws count from four to three in reference 3.
- Removed arbitrary "80% emotional voltage" phrasing.
- Removed unverified direct quote attribution for "arias of action" in reference 5, replacing it with conceptual exposition.
- Corrected chapter reference for *Storynomics* to Chapter 6 ("The Purpose-Told Story") and separated authorial neurobiological heuristics from McKee's core concept.
- Replaced rigid "Iron Laws" with genre-calibrated "Architectural Defaults."

---

## [v1.1.1] - 2026-11-09

### Added
- Complete integration of Robert McKee & Bassim El-Wakil's *Action: The Art of Excitement for Screen, Page, and Game* (2022).
- Reference 5: Action Triad, Power Asymmetry, Hero at the Mercy of the Villain, and Set Piece Engineering.
- Automated POSIX sh test suite (`tests/verify_repo.sh`) and XML validation.

---

## [v1.1.0] - 2026-11-05

### Added
- Initial pentalogy release covering *Story* (1997), *Dialogue* (2016), *Storynomics* (2018), and *Character* (2021).
- 5 operational modes (Deep Teardown, Storynomics, Architect, Script Doctor, Action & Pacing Doctor).
- Multi-model prompt templates for Claude, ChatGPT, Gemini, and Local LLMs.
