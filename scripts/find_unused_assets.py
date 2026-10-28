#!/usr/bin/env python3
"""Flag figures / tables / diagrams that the thesis does not use.

Starting from thesis.tex, follow \\input / \\include / \\subfile recursively
(ignoring commented-out lines), collect every \\includegraphics target and
every input file, then report files under figures/, tables/, diagrams/ and
chapters/ that are never reached.

Usage:
    scripts/find_unused_assets.py            # report only
    scripts/find_unused_assets.py --list     # bare paths, one per line
    scripts/find_unused_assets.py --rm       # `git rm` (tracked) / delete (untracked)
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCAN_DIRS = ["figures", "tables", "diagrams", "chapters"]
KEEP_NAMES = {".gitkeep"}
EXTS = ["", ".tex", ".png", ".jpg", ".jpeg", ".pdf", ".webp", ".svg", ".eps"]

INPUT_RE = re.compile(r"\\(?:input|include|subfile|import)\s*\{([^}]+)\}")
GFX_RE = re.compile(r"\\includegraphics\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")
# Any quoted/braced path-like string into a scanned dir (e.g. inside macros)
PATH_RE = re.compile(r"((?:figures|tables|diagrams)/[\w./+\-]+)")


def strip_comments(text):
    return "\n".join(re.sub(r"(?<!\\)%.*", "", ln) for ln in text.splitlines())


MACRO_RE = re.compile(r"\\(?:newcommand|renewcommand)\s*\{\\(\w+)\}\s*\{([^{}]*)\}")


def expand(ref, macros):
    """Substitute simple \\newcommand{\\x}{value} macros in a path."""
    for name, val in macros.items():
        ref = ref.replace("\\" + name, val)
    return ref


def resolve(ref):
    """Return existing files matching a LaTeX reference (extension optional)."""
    out = []
    for e in EXTS:
        p = ROOT / (ref + e)
        if p.is_file():
            out.append(p)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--rm", action="store_true")
    args = ap.parse_args()

    macros = dict(MACRO_RE.findall(strip_comments((ROOT / "thesis.tex").read_text())))
    used, seen, todo = set(), set(), [ROOT / "thesis.tex"]
    missing = set()
    while todo:
        f = todo.pop()
        if f in seen:
            continue
        seen.add(f)
        used.add(f)
        text = strip_comments(f.read_text(errors="ignore"))
        refs = INPUT_RE.findall(text) + GFX_RE.findall(text) + PATH_RE.findall(text)
        for r in refs:
            for ref in (expand(x.strip(), macros) for x in r.split(",")):
                hits = resolve(ref)
                if not hits:
                    if ref.startswith(tuple(SCAN_DIRS)):
                        missing.add((str(f.relative_to(ROOT)), ref))
                    continue
                for h in hits:
                    used.add(h)
                    if h.suffix == ".tex":
                        todo.append(h)

    unused = []
    for d in SCAN_DIRS:
        for p in sorted((ROOT / d).rglob("*")):
            if p.is_file() and p.name not in KEEP_NAMES and p.suffix != ".aux" and p not in used:
                unused.append(p)

    if args.list:
        print("\n".join(str(p.relative_to(ROOT)) for p in unused))
    else:
        by_dir = {}
        for p in unused:
            by_dir.setdefault(str(p.parent.relative_to(ROOT)), []).append(p)
        for d, ps in by_dir.items():
            print(f"{d}/  ({len(ps)} unused)")
            for p in ps:
                print(f"    {p.name}")
        print(f"\n{len(unused)} unused files, {len(used)} used.", file=sys.stderr)
        for src, ref in sorted(missing):
            print(f"WARNING: {src} references missing file {ref}", file=sys.stderr)

    if args.rm and unused:
        tracked = set(subprocess.run(["git", "ls-files"], cwd=ROOT, capture_output=True,
                                     text=True).stdout.splitlines())
        for p in unused:
            rel = str(p.relative_to(ROOT))
            if rel in tracked:
                subprocess.run(["git", "rm", "-q", "--", rel], cwd=ROOT)
            else:
                p.unlink()
        print(f"Removed {len(unused)} files.", file=sys.stderr)


if __name__ == "__main__":
    main()
