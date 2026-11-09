#!/bin/sh
# Robert McKee Story Engine — Automated Verification & Regression Test Suite
# Compatible with POSIX sh (macOS, Linux, WSL)

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALLER="$REPO_ROOT/install.sh"

echo "==> [1/7] Checking POSIX shell syntax for install.sh and verify_repo.sh..."
sh -n "$INSTALLER"
sh -n "$0"
echo "    PASS: POSIX sh syntax valid."

echo "==> [2/7] Validating XML well-formedness of prompts/claude-project.xml..."
python3 - "$REPO_ROOT/prompts/claude-project.xml" << 'PYEOF'
import sys
import xml.etree.ElementTree as ET

xml_path = sys.argv[1]
tree = ET.parse(xml_path)
root = tree.getroot()
assert root.tag == "system_instructions", f"Unexpected root tag: {root.tag}"
print("    PASS: prompts/claude-project.xml is valid, well-formed XML.")
PYEOF

echo "==> [3/7] Verifying all local Markdown links resolve to existing files..."
python3 - "$REPO_ROOT" << 'PYEOF'
import os
import re
import sys

repo_root = sys.argv[1]
link_re = re.compile(r'\[[^\]]+\]\(([^)]+)\)')

checked = 0
for root, dirs, files in os.walk(repo_root):
    if ".git" in dirs:
        dirs.remove(".git")
    for fname in files:
        if not fname.endswith(".md"):
            continue
        fpath = os.path.join(root, fname)
        with open(fpath, "r", encoding="utf-8") as f:
            content = f.read()
        for match in link_re.finditer(content):
            target = match.group(1).strip()
            if target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            target_path = target.split("#")[0]
            if not target_path:
                continue
            resolved = os.path.normpath(os.path.join(root, target_path))
            if not os.path.exists(resolved):
                raise AssertionError(f"Broken relative link in {fpath}: {target} -> {resolved}")
            checked += 1

print(f"    PASS: Verified {checked} local Markdown links.")
PYEOF

echo "==> [4/7] Validating benchmarks/blind_eval_scenes.json and regression assertions..."
python3 - "$REPO_ROOT" << 'PYEOF'
import os
import json
import re
import sys

repo_root = sys.argv[1]

# 1. Validate blind benchmark scenes JSON
scenes_file = os.path.join(repo_root, "benchmarks", "blind_eval_scenes.json")
assert os.path.exists(scenes_file), "benchmarks/blind_eval_scenes.json missing"
with open(scenes_file, "r", encoding="utf-8") as f:
    data = json.load(f)
assert len(data.get("scenes", [])) == 12, f"Expected 12 scenes, got {len(data.get('scenes', []))}"

# 2. Regression assertions guarding against previously reported text defects
ref3 = os.path.join(repo_root, "skills", "mckee-story-engine", "references", "3-dialogue-and-subtext.md")
with open(ref3, "r", encoding="utf-8") as f:
    c3 = f.read()
assert "$200,000" not in c3, "Found $200,000 in ref 3; expected francs"
assert "200,000 francs" in c3 or "200 000" in c3, "Expected 200,000 francs in ref 3"
assert "four acoustic laws" not in c3.lower(), "Found 'four acoustic laws' in ref 3; expected three"
assert "80% of the emotional voltage" not in c3, "Found '80% of the emotional voltage' in ref 3"

ref5 = os.path.join(repo_root, "skills", "mckee-story-engine", "references", "5-action-suspense-and-pacing.md")
with open(ref5, "r", encoding="utf-8") as f:
    c5 = f.read()
assert '*"Set pieces are the arias of Action Stories' not in c5, "Found unverified quote attribution in ref 5"

ref4 = os.path.join(repo_root, "skills", "mckee-story-engine", "references", "4-storynomics-and-teardown.md")
with open(ref4, "r", encoding="utf-8") as f:
    c4 = f.read()
assert "Ch. 6" in c4, "Expected Ch. 6 reference for Storynomics in ref 4"

# 3. Guard against uncalibrated prompt tone, spelling errors, and unverified empirical claims
# Ensure authentic author spelling: Bassim El-Wakil (published by Hachette/Twelve, 2022)
for r, ds, fs in os.walk(repo_root):
    if ".git" in ds:
        ds.remove(".git")
    for f in fs:
        if f.endswith((".md", ".xml", ".json", ".cff", ".sh")) and f not in ["verify_repo.sh", "CHANGELOG.md"]:
            p = os.path.join(r, f)
            with open(p, "r", encoding="utf-8", errors="ignore") as fh:
                txt = fh.read()
            assert "Bassam" not in txt, f"Found erroneous 'Bassam' in {p}; expected authentic published name 'Bassim'"

# Affirm Bassim presence in core files
for cf in [
    os.path.join(repo_root, "README.md"),
    os.path.join(repo_root, "skills", "mckee-story-engine", "SKILL.md"),
    os.path.join(repo_root, "skills", "mckee-story-engine", "references", "5-action-suspense-and-pacing.md"),
    os.path.join(repo_root, "prompts", "claude-project.xml"),
    os.path.join(repo_root, "prompts", "chatgpt-system-prompt.md"),
    os.path.join(repo_root, "prompts", "gemini-gem.md"),
    os.path.join(repo_root, "examples", "5-action-set-piece-breakdown.md"),
]:
    with open(cf, "r", encoding="utf-8") as fh:
        ctxt = fh.read()
    assert "Bassim El-Wakil" in ctxt, f"Missing authentic name 'Bassim El-Wakil' in {cf}"

# Tone checks across prompts and .cursorrules
for pf in [
    os.path.join(repo_root, "prompts", "claude-project.xml"),
    os.path.join(repo_root, "prompts", "chatgpt-system-prompt.md"),
    os.path.join(repo_root, "prompts", "gemini-gem.md"),
    os.path.join(repo_root, "prompts", "local-llm-compact.md"),
    os.path.join(repo_root, ".cursorrules"),
]:
    with open(pf, "r", encoding="utf-8") as fh:
        ptxt = fh.read()
    assert "RLHF" not in ptxt, f"Found 'RLHF' in {pf}"
    assert "fatal storytelling flaws" not in ptxt, f"Found 'fatal storytelling flaws' in {pf}"
    assert "Anti-AI" not in ptxt, f"Found 'Anti-AI' in {pf}"

readme_p = os.path.join(repo_root, "README.md")
with open(readme_p, "r", encoding="utf-8") as fh:
    rtxt = fh.read()
assert "Empirical Double-Blind" not in rtxt, "Found uncalibrated 'Empirical Double-Blind' in README"
assert "refined through empirical testing" not in rtxt, "Found 'refined through empirical testing' in README"

# 4. Verify SOURCES.md presence and bibliographic completeness
sources_p = os.path.join(repo_root, "SOURCES.md")
assert os.path.exists(sources_p), "SOURCES.md missing from repository root"
with open(sources_p, "r", encoding="utf-8") as fh:
    stxt = fh.read()
assert "978-0060391683" in stxt, "Missing Story ISBN in SOURCES.md"
assert "978-1455591916" in stxt, "Missing Dialogue ISBN in SOURCES.md"
assert "978-1538727935" in stxt, "Missing Storynomics ISBN in SOURCES.md"
assert "978-1455591954" in stxt, "Missing Character ISBN in SOURCES.md"
assert "978-1538726914" in stxt, "Missing Action ISBN in SOURCES.md"
assert "Bassim El-Wakil" in stxt, "Missing Bassim El-Wakil in SOURCES.md"

# 5. Automated ISBN-13 checksum validator
def valid_isbn13(isbn_str):
    clean = isbn_str.replace("-", "").replace(" ", "")
    if len(clean) != 13 or not clean.isdigit():
        return False
    return sum(int(c) * (1 if i % 2 == 0 else 3) for i, c in enumerate(clean)) % 10 == 0

isbn13_matches = re.findall(r'978-[\d-]+', stxt)
assert len(isbn13_matches) == 5, f"Expected 5 ISBN-13 entries, found {len(isbn13_matches)}: {isbn13_matches}"
for isbn in isbn13_matches:
    assert valid_isbn13(isbn), f"Invalid ISBN-13 checksum: {isbn}"

# 6. Verify calculate_scores.py statistical algorithms (Wilcoxon with ties & mock output)
calc_script = os.path.join(repo_root, "benchmarks", "calculate_scores.py")
assert os.path.exists(calc_script), "calculate_scores.py missing"

sys.path.insert(0, os.path.join(repo_root, "benchmarks"))
from calculate_scores import wilcoxon_signed_rank

# Test vector with multiple ties and opposite signs:
# Non-zero diffs: [1, -1, 1, 2, 1, -1, 2, 1, 1, -2, 1]
# Ties at |d|=1 (count 8, avg rank 4.5: positive 6, negative 2)
# Ties at |d|=2 (count 3, avg rank 10.0: positive 2, negative 1)
# W+ = 6 * 4.5 + 2 * 10.0 = 27 + 20 = 47.0
# W- = 2 * 4.5 + 1 * 10.0 = 9 + 10 = 19.0 -> W = min(47, 19) = 19.0
w_stat, p_val, r_val = wilcoxon_signed_rank([1, -1, 1, 2, 0, 1, -1, 2, 1, 1, -2, 1])
assert w_stat == 19.0, f"Wilcoxon signed-rank math error: expected W=19.0, got {w_stat}"
assert 0.25 < p_val < 0.28, f"Wilcoxon exact permutation p-value out of range: got {p_val}"
assert 0.41 < r_val < 0.44, f"Wilcoxon rank-biserial r out of range: got {r_val}"

import subprocess
mock_out = subprocess.check_output([sys.executable, calc_script, "--mock"]).decode("utf-8")
assert "[SYNTHETIC MOCK DATA — NOT AN EMPIRICAL TRIAL]" in mock_out, "Missing mock simulation warning banner"
assert "Verdict:" in mock_out, "Missing hypothesis testing verdict in report"

print("    PASS: Benchmark dataset and regression assertions verified.")
PYEOF

echo "==> [5/7] Testing install.sh refusal on unrelated non-empty directory..."
TMP_UNRELATED="$(mktemp -d "${TMPDIR:-/tmp}/mckee_test_unrelated.XXXXXX")"
TMP_SRC_LINK="${TMPDIR:-/tmp}/mckee_src_$$"
ln -s "$REPO_ROOT/skills/mckee-story-engine" "$TMP_SRC_LINK"
echo "important_user_file" > "$TMP_UNRELATED/user.txt"
if MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TMP_UNRELATED" "$INSTALLER" >/dev/null 2>&1; then
    echo "    FAIL: install.sh overwrote unrelated non-empty directory!" >&2
    rm -rf "$TMP_UNRELATED" "$TMP_SRC_LINK"
    exit 1
fi
if [ ! -f "$TMP_UNRELATED/user.txt" ]; then
    echo "    FAIL: user.txt was deleted!" >&2
    rm -rf "$TMP_UNRELATED" "$TMP_SRC_LINK"
    exit 1
fi
rm -rf "$TMP_UNRELATED"
echo "    PASS: Unrelated non-empty directory protected."

echo "==> [6/7] Testing install.sh no-op on identical version & backup on local edits..."
TMP_INSTALL_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/mckee_test_install.XXXXXX")"
TARGET_SKILL="$TMP_INSTALL_ROOT/mckee-story-engine"

# Fresh install via file:// URL
MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >/dev/null
test -f "$TARGET_SKILL/SKILL.md"
test -f "$TARGET_SKILL/references/4-storynomics-and-teardown.md"

# Re-running on identical version should be a strict no-op (same inode, zero backups created)
INODE_BEFORE="$(ls -i "$TARGET_SKILL/SKILL.md" | awk '{print $1}')"
MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >/dev/null
INODE_AFTER="$(ls -i "$TARGET_SKILL/SKILL.md" | awk '{print $1}')"
if [ "$INODE_BEFORE" != "$INODE_AFTER" ]; then
    echo "    FAIL: Identical installation was deleted/recreated instead of preserved in-place!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi

# Simulate user local edit and re-run installer -> verify backup is created
echo "# Local User Customization" >> "$TARGET_SKILL/SKILL.md"
MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >/dev/null
BACKUP_COUNT="$(ls -1d "${TARGET_SKILL}.bak."* 2>/dev/null | wc -l | tr -d ' ')"
if [ "$BACKUP_COUNT" -lt 1 ]; then
    echo "    FAIL: Expected automatic backup directory when local SKILL.md was modified!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi
echo "    PASS: Idempotent no-op on identical files and automatic backup on modified files verified."

echo "==> [7/7] Testing rollback on mid-download failure AND rollback on mid-swap mv failure..."
# 6a. Mid-download failure
echo "# Marker Before Failed Update" >> "$TARGET_SKILL/SKILL.md"
if MCKEE_REPO_RAW="file:///tmp/nonexistent_mckee_path_$$" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >/dev/null 2>&1; then
    echo "    FAIL: install.sh succeeded with broken source URL!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi
if ! grep -q "# Marker Before Failed Update" "$TARGET_SKILL/SKILL.md"; then
    echo "    FAIL: Failed download corrupted existing installation!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi

# 6b. Mid-swap mv failure (even with MCKEE_FORCE_UPDATE=1) -> must restore TARGET_SKILL from backup
if MCKEE_FORCE_UPDATE=1 MCKEE_MV_CMD="false" MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >/dev/null 2>&1; then
    echo "    FAIL: install.sh succeeded when final mv command failed!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi
if [ ! -f "$TARGET_SKILL/SKILL.md" ] || ! grep -q "# Marker Before Failed Update" "$TARGET_SKILL/SKILL.md"; then
    echo "    FAIL: Target directory was lost or corrupted when final mv failed during replacement!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi

# 6c. Mid-swap SIGTERM signal interruption -> must restore TARGET_SKILL, stop immediately, and exit with 143
SIG_HELPER="$TMP_INSTALL_ROOT/kill_parent_mv.sh"
cat > "$SIG_HELPER" << 'SIGEOF'
#!/bin/sh
kill -TERM "$PPID"
sleep 1
exit 1
SIGEOF
chmod +x "$SIG_HELPER"

OUT_LOG="$TMP_INSTALL_ROOT/sig_out.log"
set +e
MCKEE_FORCE_UPDATE=1 MCKEE_MV_CMD="$SIG_HELPER" MCKEE_REPO_RAW="file://$TMP_SRC_LINK" MCKEE_INSTALL_DIR="$TARGET_SKILL" "$INSTALLER" >"$OUT_LOG" 2>&1
SIG_STATUS=$?
set -e

if [ "$SIG_STATUS" -ne 143 ]; then
    echo "    FAIL: Expected exit code 143 on SIGTERM, got $SIG_STATUS!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi
if grep -q "Done!" "$OUT_LOG" || grep -q "Updated mckee-story-engine" "$OUT_LOG"; then
    echo "    FAIL: install.sh continued execution after SIGTERM!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi
if [ ! -f "$TARGET_SKILL/SKILL.md" ] || ! grep -q "# Marker Before Failed Update" "$TARGET_SKILL/SKILL.md"; then
    echo "    FAIL: Target directory was not restored after SIGTERM mid-swap!" >&2
    rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
    exit 1
fi

rm -rf "$TMP_INSTALL_ROOT" "$TMP_SRC_LINK"
echo "    PASS: Two-phase replacement rollback (download failure, mid-swap mv failure & SIGTERM abort) verified."
echo "==> All automated checks passed!"
