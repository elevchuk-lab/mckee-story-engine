#!/usr/bin/env python3
"""
calculate_scores.py — Double-Blind Trial Statistical Analysis Tool
Compatible with standard Python 3.8+ (Zero external dependencies required).

Implements the statistical analysis protocol defined in blind_evaluation_protocol.md:
- Condition means (A = Vanilla, B = McKee Story Engine, C = Generic Craft Prompt Control)
- Clustered bootstrap confidence intervals (resampling scenes with replacement)
- Paired Wilcoxon signed-rank test with tie-corrected variance and continuity correction
- Cohen's d_z effect sizes for paired differences
- Evaluator-consensus scene-level disaggregation (N = 12 independent scenes)
- Blind forced-choice win rates and ranking distributions
- Rigorous hypothesis testing verdict (Supported / Mixed / Retained)
- Explicit warning banner on synthetic mock data
"""

import argparse
import csv
import math
import random
import sys
from typing import Dict, List, Tuple, Optional

DIMENSIONS = [
    ("subtext_depth", "1. Subtext Depth"),
    ("value_turn_velocity", "2. Value Turn Velocity"),
    ("voice_preservation", "3. Voice Preservation"),
    ("antagonism_calibration", "4. Antagonism Calibration"),
    ("sentence_craft", "5. Sentence Craft"),
    ("holistic_score", "6. Holistic Preference"),
    ("composite_5d", "Composite (Dim 1–5 Average)"),
]

CONDITION_MAP = {
    "a": "A_vanilla",
    "b": "B_mckee_engine",
    "c": "C_generic_craft",
    "a_vanilla": "A_vanilla",
    "b_mckee_engine": "B_mckee_engine",
    "c_generic_craft": "C_generic_craft",
}


def cluster_bootstrap_ci(
    scene_triads: Dict[str, List[Tuple[float, float, float]]],
    cond_target_idx: int,
    cond_baseline_idx: int,
    n_boot: int = 10000,
    alpha: float = 0.05,
    seed: int = 42,
) -> Tuple[float, float, float]:
    """
    Cluster-bootstrap confidence interval resampling SCENES with replacement.
    Accounts for intra-cluster correlation across evaluators within each scene.
    Returns: (mean_diff, ci_low, ci_high)
    """
    scene_keys = list(scene_triads.keys())
    n_scenes = len(scene_keys)
    if n_scenes == 0:
        return (0.0, 0.0, 0.0)

    # Compute observed mean difference across all observations
    all_diffs = []
    for sk in scene_keys:
        for t in scene_triads[sk]:
            all_diffs.append(t[cond_target_idx] - t[cond_baseline_idx])
    observed_mean = sum(all_diffs) / len(all_diffs) if all_diffs else 0.0

    rng = random.Random(seed)
    boot_means = []
    for _ in range(n_boot):
        sample_diffs = []
        for _ in range(n_scenes):
            rand_scene = scene_keys[rng.randint(0, n_scenes - 1)]
            for t in scene_triads[rand_scene]:
                sample_diffs.append(t[cond_target_idx] - t[cond_baseline_idx])
        if sample_diffs:
            boot_means.append(sum(sample_diffs) / len(sample_diffs))

    boot_means.sort()
    lower_idx = int((alpha / 2.0) * n_boot)
    upper_idx = int((1.0 - alpha / 2.0) * n_boot)
    return (observed_mean, boot_means[lower_idx], boot_means[upper_idx])


def cohens_d_paired(diffs: List[float]) -> float:
    """Calculate Cohen's d_z for paired differences: mean(diff) / std(diff)."""
    n = len(diffs)
    if n < 2:
        return 0.0
    m = sum(diffs) / n
    var = sum((x - m) ** 2 for x in diffs) / (n - 1)
    sd = math.sqrt(var) if var > 0 else 0.0
    return (m / sd) if sd > 0 else 0.0


def wilcoxon_signed_rank(diffs: List[float], continuity_correction: bool = True, exact_threshold: int = 25) -> Tuple[float, float, float]:
    """
    Paired Wilcoxon signed-rank test.
    Uses exact permutation test via subset-sum dynamic programming when n <= exact_threshold (N=12 is 4,096 combinations).
    Uses asymptotic normal approximation with tie correction and continuity adjustment when n > exact_threshold.
    Returns: (w_statistic, p_value, effect_size_r)
    """
    non_zero = [d for d in diffs if d != 0.0]
    n = len(non_zero)
    if n == 0:
        return (0.0, 1.0, 0.0)

    # Sort absolute differences
    ranked = sorted([(abs(d), d) for d in non_zero], key=lambda x: x[0])
    ranks = []
    tie_counts = []
    i = 0
    while i < n:
        j = i
        while j < n and ranked[j][0] == ranked[i][0]:
            j += 1
        tie_size = j - i
        if tie_size > 1:
            tie_counts.append(tie_size)
        avg_rank = (i + 1 + j) / 2.0
        for k in range(i, j):
            ranks.append((avg_rank, ranked[k][1]))
        i = j

    w_plus = sum(r for r, d in ranks if d > 0)
    w_minus = sum(r for r, d in ranks if d < 0)
    w_stat = min(w_plus, w_minus)
    total_w = w_plus + w_minus
    # Matched-pairs rank-biserial correlation: r = (W+ - W-) / (W+ + W-)
    r_val = (w_plus - w_minus) / total_w if total_w > 0 else 0.0

    if n <= exact_threshold:
        # Exact permutation distribution via subset-sum dynamic programming
        # Scale average tied ranks by 2 to ensure integer arithmetic
        scaled_ranks = [int(round(r * 2)) for r, _ in ranks]
        max_scaled = sum(scaled_ranks)
        dp = [0] * (max_scaled + 1)
        dp[0] = 1
        for r in scaled_ranks:
            for s in range(max_scaled, r - 1, -1):
                dp[s] += dp[s - r]

        scaled_w = int(round(w_stat * 2))
        extreme_count = sum(dp[s] for s in range(scaled_w + 1))
        # Two-sided exact p-value
        p_val = min(1.0, (extreme_count * 2.0) / (2 ** n))
    else:
        # Asymptotic normal approximation with tie and continuity correction
        mean_w = n * (n + 1) / 4.0
        var_w = (n * (n + 1) * (2 * n + 1)) / 24.0
        tie_adj = sum((t**3 - t) for t in tie_counts) / 48.0
        var_w -= tie_adj
        sd_w = math.sqrt(var_w) if var_w > 0 else 1.0

        diff_val = abs(w_plus - mean_w)
        if continuity_correction and diff_val > 0.5:
            diff_val -= 0.5
        z = diff_val / sd_w
        p_val = math.erfc(z / math.sqrt(2.0))

    return (w_stat, p_val, r_val)


def generate_mock_data() -> List[Dict]:
    """Generate synthetic evaluation dataset for testing (12 scenes x 3 evaluators = 36 triads)."""
    rng = random.Random(1337)
    scenes = [f"scene_{i:02d}" for i in range(1, 13)]
    evaluators = ["evaluator_01", "evaluator_02", "evaluator_03"]

    rows = []
    for sc in scenes:
        for ev in evaluators:
            score_a = {
                "subtext_depth": max(1, min(5, round(rng.gauss(2.5, 0.8)))),
                "value_turn_velocity": max(1, min(5, round(rng.gauss(2.7, 0.7)))),
                "voice_preservation": max(1, min(5, round(rng.gauss(3.3, 0.8)))),
                "antagonism_calibration": max(1, min(5, round(rng.gauss(2.6, 0.7)))),
                "sentence_craft": max(1, min(5, round(rng.gauss(3.0, 0.7)))),
                "holistic_score": max(1, min(5, round(rng.gauss(2.7, 0.8)))),
            }
            score_b = {
                "subtext_depth": max(1, min(5, round(rng.gauss(4.6, 0.5)))),
                "value_turn_velocity": max(1, min(5, round(rng.gauss(4.5, 0.5)))),
                "voice_preservation": max(1, min(5, round(rng.gauss(4.2, 0.6)))),
                "antagonism_calibration": max(1, min(5, round(rng.gauss(4.7, 0.5)))),
                "sentence_craft": max(1, min(5, round(rng.gauss(4.4, 0.5)))),
                "holistic_score": max(1, min(5, round(rng.gauss(4.5, 0.5)))),
            }
            score_c = {
                "subtext_depth": max(1, min(5, round(rng.gauss(3.6, 0.7)))),
                "value_turn_velocity": max(1, min(5, round(rng.gauss(3.5, 0.6)))),
                "voice_preservation": max(1, min(5, round(rng.gauss(3.8, 0.7)))),
                "antagonism_calibration": max(1, min(5, round(rng.gauss(3.6, 0.7)))),
                "sentence_craft": max(1, min(5, round(rng.gauss(3.8, 0.6)))),
                "holistic_score": max(1, min(5, round(rng.gauss(3.7, 0.6)))),
            }

            h_scores = [
                ("A_vanilla", score_a["holistic_score"] + rng.random() * 0.1),
                ("B_mckee_engine", score_b["holistic_score"] + rng.random() * 0.1),
                ("C_generic_craft", score_c["holistic_score"] + rng.random() * 0.1),
            ]
            h_scores.sort(key=lambda x: x[1], reverse=True)
            ranks = {cond: rank + 1 for rank, (cond, _) in enumerate(h_scores)}

            for cond, sc_dict in [("A_vanilla", score_a), ("B_mckee_engine", score_b), ("C_generic_craft", score_c)]:
                row = {
                    "scene_id": sc,
                    "evaluator_id": ev,
                    "condition": cond,
                    "forced_choice_rank": ranks[cond],
                }
                row.update(sc_dict)
                rows.append(row)

    return rows


def parse_csv(filepath: str) -> List[Dict]:
    """Parse evaluator responses CSV."""
    rows = []
    with open(filepath, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            cond_raw = r["condition"].strip().lower()
            cond = CONDITION_MAP.get(cond_raw, cond_raw)
            clean_row = {
                "scene_id": r["scene_id"].strip(),
                "evaluator_id": r["evaluator_id"].strip(),
                "condition": cond,
                "forced_choice_rank": int(r["forced_choice_rank"]) if r.get("forced_choice_rank") else None,
            }
            for d, _ in DIMENSIONS:
                if d == "composite_5d":
                    continue
                if d in r and r[d].strip():
                    clean_row[d] = float(r[d])
            rows.append(clean_row)
    return rows


def analyze(data: List[Dict], is_mock: bool = False) -> str:
    """Run full statistical evaluation protocol and format Markdown report."""
    # Structure data by (scene_id, evaluator_id)
    triads: Dict[Tuple[str, str], Dict[str, Dict]] = {}
    scene_set = set()
    evaluator_set = set()

    for r in data:
        key = (r["scene_id"], r["evaluator_id"])
        scene_set.add(r["scene_id"])
        evaluator_set.add(r["evaluator_id"])
        if key not in triads:
            triads[key] = {}
        dim_vals = [r[d] for d, _ in DIMENSIONS[:5] if d in r]
        if len(dim_vals) == 5:
            r["composite_5d"] = sum(dim_vals) / 5.0
        triads[key][r["condition"]] = r

    n_triads = len(triads)
    n_scenes = len(scene_set)
    n_evaluators = len(evaluator_set)

    # Clustered structures: scene -> list of (A, B, C) values for each dimension
    scene_dim_triads: Dict[str, Dict[str, List[Tuple[float, float, float]]]] = {
        d: {sc: [] for sc in scene_set} for d, _ in DIMENSIONS
    }

    cond_scores: Dict[str, Dict[str, List[float]]] = {
        "A_vanilla": {d: [] for d, _ in DIMENSIONS},
        "B_mckee_engine": {d: [] for d, _ in DIMENSIONS},
        "C_generic_craft": {d: [] for d, _ in DIMENSIONS},
    }
    paired_diffs_ba: Dict[str, List[float]] = {d: [] for d, _ in DIMENSIONS}
    paired_diffs_bc: Dict[str, List[float]] = {d: [] for d, _ in DIMENSIONS}

    b_wins_over_a = 0
    b_wins_over_c = 0
    first_place = {"A_vanilla": 0, "B_mckee_engine": 0, "C_generic_craft": 0}

    for (sc, ev), triad in triads.items():
        if "A_vanilla" in triad and "B_mckee_engine" in triad and "C_generic_craft" in triad:
            a_row = triad["A_vanilla"]
            b_row = triad["B_mckee_engine"]
            c_row = triad["C_generic_craft"]

            for d, _ in DIMENSIONS:
                if d in a_row and d in b_row and d in c_row:
                    va = a_row[d]
                    vb = b_row[d]
                    vc = c_row[d]
                    cond_scores["A_vanilla"][d].append(va)
                    cond_scores["B_mckee_engine"][d].append(vb)
                    cond_scores["C_generic_craft"][d].append(vc)
                    paired_diffs_ba[d].append(vb - va)
                    paired_diffs_bc[d].append(vb - vc)
                    scene_dim_triads[d][sc].append((va, vb, vc))

            ra = a_row.get("forced_choice_rank")
            rb = b_row.get("forced_choice_rank")
            rc = c_row.get("forced_choice_rank")
            if ra and rb and rc:
                if rb < ra:
                    b_wins_over_a += 1
                if rb < rc:
                    b_wins_over_c += 1
                for c_name, r_val in [("A_vanilla", ra), ("B_mckee_engine", rb), ("C_generic_craft", rc)]:
                    if r_val == 1:
                        first_place[c_name] += 1

    lines = []
    if is_mock:
        lines.append("# [SYNTHETIC MOCK DATA — NOT AN EMPIRICAL TRIAL]")
        lines.append("")
        lines.append("> [!WARNING]")
        lines.append("> **SIMULATION NOTICE:** This report was generated using synthetic mock data (`--mock`) for test pipeline validation and statistical algorithm verification. No actual human trials have taken place. Do not cite these figures as empirical performance measurements.")
        lines.append("")
    else:
        lines.append("# Double-Blind Benchmark Evaluation Report")
        lines.append("")

    lines.append(f"- **Total Independent Scenes (Clusters):** {n_scenes}")
    lines.append(f"- **Evaluators per Scene:** {n_evaluators}")
    lines.append(f"- **Total Completed Evaluation Triads:** {n_triads}")
    lines.append(f"- **Conditions:** Condition A (Vanilla Baseline) vs. Condition B (McKee Engine) vs. Condition C (Generic Craft Control)")
    lines.append(f"- **Cluster Bootstrap:** 10,000 iterations resampling by scene (95% Confidence Interval)")
    lines.append(f"- **Hypothesis Testing Standard:** Paired Wilcoxon Signed-Rank Test on Scene-Level Consensus Means (N = {n_scenes} independent scene clusters) using exact permutation distribution (for N <= 25, 2^12 = 4,096 sign combinations) and matched-pairs rank-biserial correlation r")
    lines.append("")
    lines.append("## 1. Summary Statistics Across Dimensions (Likert 1–5 Scale)")
    lines.append("")
    lines.append("| Metric / Dimension | Cond A Mean ± SD | Cond C Mean ± SD | Cond B Mean ± SD | Δ(B − A) [95% Cluster CI] | Δ(B − C) [95% Cluster CI] | Cohen's d (Scenes N=12) | Wilcoxon p (Scenes N=12) |")
    lines.append("| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |")

    sig_count = 0
    dim_count = 0
    failing_dims = []

    for d, label in DIMENSIONS:
        sa = cond_scores["A_vanilla"][d]
        sb = cond_scores["B_mckee_engine"][d]
        sc = cond_scores["C_generic_craft"][d]

        mean_a = sum(sa) / len(sa) if sa else 0.0
        var_a = sum((x - mean_a) ** 2 for x in sa) / (len(sa) - 1) if len(sa) > 1 else 0.0
        sd_a = math.sqrt(var_a)

        mean_b = sum(sb) / len(sb) if sb else 0.0
        var_b = sum((x - mean_b) ** 2 for x in sb) / (len(sb) - 1) if len(sb) > 1 else 0.0
        sd_b = math.sqrt(var_b)

        mean_c = sum(sc) / len(sc) if sc else 0.0
        var_c = sum((x - mean_c) ** 2 for x in sc) / (len(sc) - 1) if len(sc) > 1 else 0.0
        sd_c = math.sqrt(var_c)

        # Clustered bootstrap for Delta(B - A): idx 1 vs 0
        d_ba_mean, ci_ba_low, ci_ba_high = cluster_bootstrap_ci(scene_dim_triads[d], cond_target_idx=1, cond_baseline_idx=0)
        # Clustered bootstrap for Delta(B - C): idx 1 vs 2
        d_bc_mean, ci_bc_low, ci_bc_high = cluster_bootstrap_ci(scene_dim_triads[d], cond_target_idx=1, cond_baseline_idx=2)

        # Scene-level aggregation: average evaluators per scene to yield N=12 independent paired differences
        scene_diffs_bc = []
        for sc_key in sorted(list(scene_set)):
            triads_in_sc = scene_dim_triads[d][sc_key]
            if triads_in_sc:
                m_b = sum(t[1] for t in triads_in_sc) / len(triads_in_sc)
                m_c = sum(t[2] for t in triads_in_sc) / len(triads_in_sc)
                scene_diffs_bc.append(m_b - m_c)

        d_effect = cohens_d_paired(scene_diffs_bc)
        w_stat, p_val, r_val = wilcoxon_signed_rank(scene_diffs_bc)

        is_significant = (ci_bc_low > 0.0) and (p_val < 0.05)
        if d != "composite_5d":
            dim_count += 1
            if is_significant:
                sig_count += 1
            else:
                failing_dims.append((label, ci_bc_low, p_val))

        p_str = "< 0.001" if p_val < 0.001 else f"{p_val:.3f}"
        lines.append(
            f"| **{label}** | {mean_a:.2f} ± {sd_a:.2f} | {mean_c:.2f} ± {sd_c:.2f} | {mean_b:.2f} ± {sd_b:.2f} | "
            f"+{d_ba_mean:.2f} [{ci_ba_low:+.2f}, {ci_ba_high:+.2f}] | "
            f"+{d_bc_mean:.2f} [{ci_bc_low:+.2f}, {ci_bc_high:+.2f}] | "
            f"{d_effect:.2f} | p = {p_str} (r = {r_val:.2f}) |"
        )

    lines.append("")
    lines.append("## 2. Holistic Blind Forced-Choice Rankings")
    lines.append("")
    win_rate_ba = (b_wins_over_a / n_triads * 100.0) if n_triads else 0.0
    win_rate_bc = (b_wins_over_c / n_triads * 100.0) if n_triads else 0.0
    p1_a = (first_place["A_vanilla"] / n_triads * 100.0) if n_triads else 0.0
    p1_b = (first_place["B_mckee_engine"] / n_triads * 100.0) if n_triads else 0.0
    p1_c = (first_place["C_generic_craft"] / n_triads * 100.0) if n_triads else 0.0

    lines.append(f"- **Pairwise Win Rate (Condition B vs. Condition A):** **{win_rate_ba:.1f}%** ({b_wins_over_a}/{n_triads} triads)")
    lines.append(f"- **Pairwise Win Rate (Condition B vs. Condition C):** **{win_rate_bc:.1f}%** ({b_wins_over_c}/{n_triads} triads)")
    lines.append("")
    lines.append("| Condition | # 1st Place Selections | 1st Place Percentage (%) |")
    lines.append("| :--- | :---: | :---: |")
    lines.append(f"| **Condition B (McKee Story Engine)** | {first_place['B_mckee_engine']} | **{p1_b:.1f}%** |")
    lines.append(f"| **Condition C (Generic Craft Control)** | {first_place['C_generic_craft']} | {p1_c:.1f}% |")
    lines.append(f"| **Condition A (Vanilla Baseline)** | {first_place['A_vanilla']} | {p1_a:.1f}% |")
    lines.append("")
    lines.append("## 3. Methodological Null Hypothesis Evaluation")
    lines.append("")

    if sig_count == dim_count:
        lines.append(f"> **Verdict: Hypothesis Supported ({sig_count}/{dim_count} Dimensions Significant).**")
        lines.append("> Condition B (McKee Story Engine) demonstrated statistically significant superiority over Condition C (Generic Craft Control) across all evaluated dimensions, with 95% cluster-bootstrap confidence intervals strictly excluding zero and Wilcoxon signed-rank tests reaching significance (p < 0.05).")
    elif sig_count > 0:
        lines.append(f"> **Verdict: Mixed Results ({sig_count}/{dim_count} Dimensions Significant).**")
        lines.append("> Condition B (McKee Story Engine) outperformed Condition C on several key dimensions, but did not reach statistical significance across all criteria. Specifically:")
        for fl, ci_low, p_v in failing_dims:
            lines.append(f"> - *{fl}* did not meet full dual-significance (Cluster CI lower bound = {ci_low:+.2f}, Wilcoxon p = {p_v:.3f}).")
        lines.append("> Conclusions regarding overall engine superiority over strong generic prompting must be qualified by dimension.")
    else:
        lines.append(f"> **Verdict: Null Hypothesis Retained (0/{dim_count} Dimensions Significant).**")
        lines.append("> Condition B did not demonstrate statistically significant advantage over Condition C (Generic Craft Control). The hypothesis that McKee's structured pentalogy provides a specific measurable gain over strong concise craft advice is not supported by these trial data.")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Double-Blind Benchmark Evaluation Score Calculator")
    parser.add_argument("--csv", type=str, help="Path to evaluator responses CSV")
    parser.add_argument("--mock", action="store_true", help="Generate synthetic mock evaluation trial data (12 scenes x 3 evaluators) and run analysis")
    parser.add_argument("--output", type=str, help="Optional output markdown file path")

    args = parser.parse_args()

    if args.mock:
        data = generate_mock_data()
        report = analyze(data, is_mock=True)
    elif args.csv:
        data = parse_csv(args.csv)
        report = analyze(data, is_mock=False)
    else:
        parser.print_help()
        sys.exit(1)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(report)
        print(f"Report written to {args.output}")
    else:
        print(report)


if __name__ == "__main__":
    main()
