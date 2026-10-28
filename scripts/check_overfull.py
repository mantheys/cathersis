#!/usr/bin/env python3
"""List pages whose content sticks out of the text block (tables, figures, headings, URLs).

Usage:  python3 scripts/check_overfull.py thesis.pdf [--tol 2]

Uses `pdftotext -bbox`. The text block is inferred per page (odd/even margins) from the two
dominant left edges, so a table wider than the block is flagged with its overshoot in points.
Complements the LaTeX log, whose "Overfull \\hbox" warnings are hard to map back to a table.
"""
import argparse, collections, re, subprocess, sys

ap = argparse.ArgumentParser()
ap.add_argument("pdf")
ap.add_argument("--tol", type=float, default=2.0)
a = ap.parse_args()
html = subprocess.run(["pdftotext", "-bbox", a.pdf, "-"], capture_output=True, text=True).stdout
pages = re.split(r"<page ", html)[1:]
parsed = []
for p in pages:
    ws = [(float(x0), float(x1), w) for x0, x1, w in re.findall(r'<word xMin="([\d.]+)" yMin="[\d.]+" xMax="([\d.]+)" yMax="[\d.]+">(.*?)</word>', p)]
    parsed.append(ws)
lefts = collections.Counter(round(min(w[0] for w in ws)) for ws in parsed if ws).most_common(2)
rights = collections.Counter(round(max(w[1] for w in ws)) for ws in parsed if ws).most_common(2)
blocks = sorted(zip(sorted(l for l, _ in lefts), sorted(r for r, _ in rights)))
bad = 0
for i, ws in enumerate(parsed, 1):
    if not ws:
        continue
    lo = min(w[0] for w in ws)
    L, R = min(blocks, key=lambda b: abs(b[0] - lo))
    over = [w for w in ws if w[1] > R + a.tol or w[0] < L - a.tol]
    if over:
        bad += 1
        print(f"page {i}: {max(max(w[1] - R, L - w[0]) for w in over):.1f} pt over: " + " ".join(w[2] for w in over[:8]))
print(f"{bad} page(s) with content outside the text block")
