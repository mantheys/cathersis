# Thesis Style Guide

Working reference for consistent formatting across all chapters.
Update this document when a new convention is decided.

---

## 0. Sub-subsection structure (below `\subsection`)

**Single standard: `\paragraph{Heading}`** for all run-in topic headings within a subsection.

- Do not use `\noindent\textbf{...}`, `\subsubsection*{...}` or `\medskip` + bold text as headings.
- Remove any `\medskip` or `\noindent` preceding an old-style bold heading; `\paragraph` provides its own spacing.
- Do **not** use `\subparagraph` or `\subsubsection` for this purpose.
- `\subsubsection` is reserved for appendices where a numbered, TOC-listed heading is genuinely needed.

**Lists vs. headings:** Use `\paragraph` when the block has prose of its own. Use a labelled `\item \textbf{Label:}` list (see §1) when items are short and parallel. Do not mix the two in the same logical grouping.

**Colon placement in labelled list items:** colon always **inside** the bold:

```latex
\item \textbf{Electroweak sector:} The LEP experiments measured...   % correct
\item \textbf{Electroweak sector}:  The LEP experiments measured...  % wrong
```

---

## 1. Bold text (`\textbf`)

Two sanctioned uses, **no others**.

| Use case | Form | Example |
|---|---|---|
| Bullet-list label | `\item \textbf{Label:}` | `\item \textbf{Electroweak sector:} The LEP experiments...` |
| First formal definition of a named quantity | inline `\textbf{name}` | `The \textbf{track quality score} is...` |

The `\medskip\noindent\textbf{Heading.}` heading pattern is **not used**; use `\paragraph{Heading}` instead (see §0).

**Do not use bold for:**
- General emphasis in running prose (rephrase instead; `\emph` is reserved for first appearances of key terms, see §2)
- Figure/table caption direction markers; use `(left)`, `(right)` plain text (see §12 and §15)
- Detector names or acronyms

**Rule for inline definitions:** use `\textbf` only for a quantity being *named and defined* for the first time and that will be referenced later by that name. Use `\emph` for the first appearance of an important term without a glossary entry (see §2).

---

## 2. Italic text (`\emph` vs `\textit`)

**`\emph` is reserved for the first appearance of an important term that has no glossary entry.** It marks a term the reader should notice and remember, at the point where the text introduces it.

- **Terms with a glossary or acronym entry** use `\gls{...}` and are **never** wrapped in `\emph`; the glossary already highlights them.
- **First appearance only:** later occurrences of the term are plain text, anywhere in the thesis.
- **Important terms only:** passing technical words that are not referred to again are not emphasised.
- **No general emphasis:** do not use `\emph` (or `\textit`) to stress words in running prose. Rephrase the sentence instead.

```latex
The hits are first grouped into \emph{track seeds} ...   % correct: first use, no glossary entry
... the \emph{track seeds} are then fitted ...           % wrong: not the first use
The \emph{\gls{geant}} toolkit ...                       % wrong: glossary term
This is \emph{not} what is observed.                     % wrong: general emphasis
```

| Use case | Command | Rationale |
|---|---|---|
| First appearance of an important term without a glossary entry | `\emph{term}` | The sanctioned use; renders correctly even inside already-italic environments |
| Figure/table caption directional labels | `(left)`, `(right)` plain text | See §12 for the multi-panel caption format; never use `\textit` here |
| Software stage or algorithm names used as identifiers | `\emph{reco1}`, `\emph{AntiKt}` | Naming-convention exception; apply it to every occurrence, consistently across chapters |
| Names the field writes in italics | e.g. process or reaction labels | Field convention; overrides the "`\gls` entries are never `\emph`" rule, since `\gls` renders upright. Do not use the glossary entry inline for these terms; a `\glsadd{key}` after the first `\emph` occurrence puts it in the printed glossary (unused entries are not printed) |

Do not use `\textit` in running prose.

---

## 3. Cross-references (`\cref` / `\Cref`)

- **Always** use `\cref{label}` (sentence-internal) or `\Cref{label}` (sentence-initial).
- `\cref` produces lowercase type names: "figure 3.1", "section 2.4", "equation 3.1", "table 2.1".
- `\Cref` capitalises for sentence-initial use: "Figure 3.1", "Section 2.4", "Equation 3.1".
- Equations render as `equation 3.1` (no abbreviation, no parentheses).
- For ranges: `\crefrange{label_a}{label_b}`.
- For multiple targets: `\cref{label_a,label_b}`.
- **Never** write `Fig.~\ref`, `Eq.~\eqref`, `Section~\ref`, etc.; the type names are set by cleveref's `\crefname` settings in `thesis.tex`.
- Non-breaking space before `\cref` when it follows "see": `see~\cref{...}`.
- **Parenthetical pointers:** write the bare reference, `(\cref{label})`, not `(see~\cref{label})`. Panel qualifiers stay: `(\cref{fig:x}, left)`. Drop filler verbs such as "see also", "as represented in" or "described in" inside the parentheses; keep extra words only when they say *what* the reader finds there (e.g. `(software versions in~\cref{app:x})`, `(red dashed in~\cref{fig:x})`).

---

## 4. Units (siunitx v3 interface)

The thesis uses **siunitx v3**. Use the v3 commands listed below. The legacy aliases `\SI` and `\si` still work (backward compatibility) but new code should use the canonical v3 forms.

| Task | Command | Example |
|---|---|---|
| Value + unit | `\qty{value}{unit}` | `\qty{125.1}{\giga\electronvolt}` |
| Unit alone | `\unit{unit}` | `\unit{\tera\electronvolt}` |
| Number only | `\num{number}` | `\num{1.23e-5}` |
| Range | `\qtyrange{lo}{hi}{unit}` | `\qtyrange{110}{160}{\giga\electronvolt}` |
| Product dimensions | `\qtyproduct{a x b x c}{unit}` | `\qtyproduct{25 x 25 x 46}{\metre}` |

**Do not use** `\text{GeV}`, `\text{fb}`, etc. for units; always use a declared `\unit`/`\qty` macro. Units not built into siunitx (e.g. `\barn` variants, `\year`) are declared once with `\DeclareSIUnit` in the preamble.

---

## 5. Quotation marks

Use LaTeX double quotes throughout: `` ``text'' ``.

- **Do not use** `"text"` (straight quotes) or `\enquote{text}`.
- Single quotes: `` `text' `` only for quotes-within-quotes.

---

## 6. Footnotes

Use footnotes for technical asides that would interrupt prose flow but are genuinely needed (e.g., a definition clarifying a boundary condition, a caveat about a simulation setting).

**Do not use footnotes for:**
- Information that belongs in the main text
- Citations (put them inline)
- Long explanatory paragraphs; move those to an appendix instead

Footnote punctuation: the `\footnote{}` command comes **before** the full stop if it applies to the whole sentence, **after** the word it qualifies if it is word-specific. Prefer end-of-sentence placement.

---

## 7. LaTeX comments (`%`)

Two sanctioned forms:

| Form | Purpose |
|---|---|
| `% =======...` divider (≥ 40 `=`) | Section boundary inside long files (e.g., long chapters, appendices). Keep or add freely. |
| `% prose comment` | Commented-out draft text or notes. Acceptable during writing; remove before submission. |

**Convention for actionable notes:** prefix with `% TODO:` so they can be grepped.
```
% TODO: add figure reference once fig is generated
```
Do not introduce `% NOTE:` or `% FIXME:`; use `% TODO:` for everything actionable.

Put a `% TODO:` on its **own line** after the paragraph it concerns, never inside a paragraph: TeX drops the rest of the source line after `%`, and most paragraphs are a single long line. Do not use a rendered `\todo{}` macro in chapter text.

---

## 8. Mathematical notation

| Element | Convention | Example |
|---|---|---|
| Vectors (physics) | bold roman via `\mathbf` | `\mathbf{p}` |
| Operators / named functions | `\text{}` inside math | `\text{d}x`, `p_{\text{T}}` |
| Units inside equations | `\,\unit{unit}` with thin space, or `\qty` | `m_H = 125\,\unit{\giga\electronvolt}` |
| Parentheses around large expressions | `\left(` … `\right)` | always |
| Equation references | `\cref{eq:label}` (renders "equation n") | see §3 |

---

## 9. Tense and voice

- **Past tense** for experimental descriptions and results: *"The cut was optimised…"*, *"The simulation produced…"*
- **Present tense** for statements of fact and interpretation: *"The forward-backward asymmetry measures…"*, *"This result implies…"*
- **Avoid passive** where an active construction is equally clear. Prefer active in methodology sections.

---

## 10. Capitalisation and recurring names

| Term | Rule |
|---|---|
| Physics concepts | Lower case unless a proper name: "electroweak symmetry breaking", "Higgs mechanism", "Standard Model" |
| Analysis names | Title case in headings, lower case in prose: "the diphoton analysis" |
| Defined names carrying a macro (see below) | **Title Case everywhere**, treated as proper names. Overrides the "lower case in prose" rule above for these specific terms |
| Software/framework names | Preserve original case: Geant4, ROOT, MadGraph5\_aMC@NLO |

**Recurring names are macros.** Any name that recurs across chapters (detector subsystems, data-taking periods, sample or configuration names, analysis names) is defined once as a macro in `references/style/main.tex` and always typed through it, never by hand:

```latex
% references/style/main.tex
\newcommand{\Tracker}{Inner Tracker\xspace}
\newcommand{\RunTwo}{Run~2\xspace}
```

Fix one spelling per name and do not introduce synonyms. When the names form a fixed set (e.g. several detector configurations), list them in a fixed order and keep that order in every figure, legend, table and caption.

---

## 11. Inline examples and parenthetical asides

Use **commas** or **parentheses** to set off inline examples and explanations. Do not use em-dashes (`---`) for this purpose.

| Purpose | Preferred | Avoid |
| --- | --- | --- |
| Inline example | `..., for instance a precision $W$-mass measurement, provides...` | `... --- for instance a precision $W$-mass measurement --- provides...` |
| Parenthetical elaboration | `...(combining the diphoton and four-lepton channels) provides...` | `... --- combining the diphoton and four-lepton channels --- provides...` |
| Clarifying aside | `..., which constrains the Higgs self-coupling, ...` | `... --- which constrains the Higgs self-coupling --- ...` |

En-dashes (`--`) and em-dashes (`---`) are reserved for:

- Ranges and joins between proper nouns or concepts: `the Cabibbo--Kobayashi--Maskawa matrix`
- Abrupt breaks in sentence structure (rare in scientific prose)

Do **not** use `---` or `***` as section separators in prose or as decorative punctuation.

---

## 12. Multi-panel figures

**Never** use `\subcaptionbox`, `\subfloat`, or `\begin{subfigure}`. Place panels side by side with plain `\includegraphics` at `.49\linewidth`:

```latex
\begin{figure}[!ht]
    \centering
    \includegraphics[width=.49\linewidth]{figures/foo/left.png}
    \includegraphics[width=.49\linewidth]{figures/foo/right.png}
    \caption[Short title]{(left) Description of left panel. (right) Description of right panel.}
    \label{fig:example}
\end{figure}
```

- Panel labels in the caption use plain parenthetical text: `(left)`, `(right)`, `(top)`, `(bottom)`; **not** `\textit{left}`, sub-labels, or lettered suffixes `(a)`, `(b)`.
- The single `\label` on the outer figure environment is sufficient; panels are referenced by direction in prose ("the right panel of \cref{fig:example}"), not by sub-labels.
- Width `.49\linewidth` is the default for two-panel rows; adjust only when panels have very different aspect ratios.
- A `\hspace` or `\hfill` between the two `\includegraphics` is unnecessary; LaTeX's natural inter-word space provides adequate separation at `.49` width.

---

## 13. Numbers with uncertainties (siunitx v3)

`thesis.tex` sets `uncertainty-mode = separate` and `uncertainty-descriptor-mode = subscript`, so bracket-form input is printed with ± automatically. All three uncertainty patterns use native siunitx v3 compact input syntax.

**Symmetric uncertainty**: `value(unc)` or `value(unc)eN` for powers of ten. The bracket digits refer to the last significant place of the main value:

```latex
\qty{125.10(14)}{\giga\electronvolt}       % 125.10 ± 0.14 GeV
\qty{1.166(6)e-5}{\per\giga\electronvolt\squared}  % (1.166 ± 0.006) × 10⁻⁵ GeV⁻²
\qty{80.37(2)}{\giga\electronvolt}         % 80.37 ± 0.02 GeV
```

**Asymmetric (upper/lower) uncertainty**: `value(pos:neg)` with a colon dividing the positive and negative parts. Use decimal form when the uncertainties have more digits than the last place of the value:

```latex
\qty{3.2(1.1:0.9)}{\mega\electronvolt}     % 3.2^{+1.1}_{-0.9} MeV
\qty{4.5(1.9:1.4)e-3}{\pico\barn}          % 4.5^{+1.9}_{-1.4} × 10⁻³ pb
\num{1.02(0.11:0.10)}                      % 1.02^{+0.11}_{-0.10}  (no unit)
```

**Split stat/syst uncertainty**: list both uncertainties in sequence and pass `uncertainty-descriptors`. With the global `subscript` mode the labels appear as subscripts:

```latex
\qty[uncertainty-descriptors = {stat, syst}]{55.4(3.1)(2.0)}{\pico\barn}
% → 55.4 ± 3.1_stat ± 2.0_syst pb
```

**Rules:**
- Use `\qty{value}{unit}` (v3) for number + unit. The legacy `\SI` alias still compiles but new code should use `\qty`.
- Use `\unit{...}` for a standalone unit; `\num{...}` for a number without a unit.
- Never write units as `\text{GeV}`, `\text{pb}`, etc.
- Never split a number and its unit across math/text mode (`$x \pm u$\,\unit{...}`). Use `\qty` or `\num` instead.
- Never use bare `\%` in math mode. For a numeric percentage use `\qty{x}{\percent}`; for inline ±x% write `$\pm\qty{x}{\percent}$`; for a symbolic expression followed by a percent unit use `$\text{expr}$\,\unit{\percent}`.

---

## 14. Tables

**Rules, no exceptions:**

- Use `booktabs` rules only: `\toprule` (top), `\midrule` (header separator), `\bottomrule` (bottom). **Never** use `\hline`, `\hline\hline`, or `\cmidrule`.
- Title row (if any) goes **before** `\toprule`, as a `\multicolumn{n}{c}{Title}` row. Do not put the title inside or after the rules.
- For grouped column headers, add a plain `\multicolumn{n}{c}{Group}` row between `\toprule` and the column-header row, with no `\cmidrule` separators beneath it.
- A `\midrule` before a summary/total row (e.g., "Mean") is allowed and encouraged.
- **External files:** each tabular lives in its own file in `tables/` and is included with `\input` inside the `table` environment of the chapter.
- **Font size:** table text is set in the body font size. Never scale a table up to fill the width (a scaled-up table has larger text than the page, a common error): `\fitwidth` widens the column separation instead and only scales tables that are wider than the text down.
- **Width:** every tabular is wrapped in `\fitwidth{...}` (`\fitwidth{\input{tables/foo.tex}}` in the chapter). A table wider than about two thirds of the text width (`0.66\linewidth`) is set to the full text width by spreading its columns; a narrower one keeps its natural width. Never scale a table by hand with `\resizebox` or `\small`.
- **Generated tables are changed at the source.** When a file in `tables/` is written by an analysis or plotting script, change the script (new options default to the old behaviour) or the command that calls it, regenerate, and copy the output into `tables/`; never hand-edit the generated file, or the change is lost at the next regeneration. Hand-written tables (e.g. those built from `\res*`/`\fom*` macros, §17) are edited directly.

**Template:**

```latex
\begin{tabular}{lcc}
    \multicolumn{3}{c}{Table Title} \\
    \toprule
    Column A & \multicolumn{2}{c}{Group} \\
    & Sub-col 1 & Sub-col 2 \\
    \midrule
    Row 1 & val & val \\
    \midrule
    Mean & val & val \\
    \bottomrule
\end{tabular}
```

**Number formatting inside tables:**

- Dimensionless values with uncertainty: `\num{3.2(2)}` (renders as $3.2 \pm 0.2$). **Never** write `3.2 $\pm$ 0.2` or `$3.2 \pm 0.2$`.
- Values with a unit: `\qty{3.2(2)}{\percent}`.
- Never use `\rm` or `$\rm ...$` in column headers; use `\text{}` for math-mode text (see §8) or plain text outside math.

---

## 15. Caption placement

Captions go **below** both figures and tables, no exceptions.

**Figures:** `\caption` always after the last `\includegraphics` (or `\input` for externally generated artwork).

**Tables:** `\caption` always after `\end{tabular}` (or after the `\fitwidth{...}`/`\end{minipage}` wrapping it). `\sisetup` and column-format declarations go before `\begin{tabular}`, never between `\caption` and the tabular.

**List titles:** every `\caption` carries a short title in the optional argument, `\caption[Short title]{Full caption.}`, which is what the List of Figures and List of Tables show. The title names the content in a few words (no full sentence, no final full stop), is plain text (no `\gls`, `\fom*`, `\res*` or name macros, so the lists do not consume the first use of a glossary entry), and must not contain `]`. Parallel figures share a pattern, e.g. `Diphoton mass spectrum, 2016` / `Diphoton mass spectrum, 2017`.

```latex
% Correct figure layout
\begin{figure}[!ht]
  \centering
  \includegraphics[width=\linewidth]{figures/foo/plot.png}
  \caption[Short title]{Caption text.}
  \label{fig:example}
\end{figure}

% Correct table layout
\begin{table}[!ht]
  \centering
  \sisetup{table-format=2.1}
  \fitwidth{\input{tables/foo.tex}}
  \caption[Short title]{Caption text.}
  \label{tab:example}
\end{table}
```

---

## 16. Figure caption structure

Every figure caption follows the same shape. The goal: a caption orients the reader to *what the figure shows*; it does not explain *what it means* or *why it matters*. That belongs in the prose paragraph near the `\cref`/`\Cref` to the figure.

**Template:**

```
<Lead: noun phrase naming the quantity/subject plotted, "as a function of X",
for <selection A> (left) and <selection B> (right), with panel tags folded
in inline when both panels show the same quantity for different selections>.
<0-2 sentences of visual encoding only: curve colours, line styles, markers,
shaded-band/contour meaning, what a dashed line represents>.
\figfrom{...}/\adaptedfrom{...} if applicable.
```

When panels show genuinely **different** content (not the same quantity for different selections), split into a per-panel form instead; a short shared intro sentence is optional:

```
<optional one-sentence shared intro naming the overall subject>.
(left) <noun phrase for left panel + visual encoding>.
(right) <noun phrase for right panel + visual encoding>.
```

See §12 for the mechanics of panel labels themselves (`(left)`/`(right)`/`(top)`/`(bottom)`, plain parenthetical text, no `\textit`, no lettered sub-labels); this section only governs how much *content* goes in the caption, not how panels are tagged.

**Reproduced figures:** a figure taken unchanged from another work ends its caption with `\figfrom{key}`; a figure redrawn or modified from another work ends with `\adaptedfrom{key}`. Never write the source by hand ("Taken from~\cite{...}").

**Rules:**
- No finite-verb opening sentence ("This figure shows...", "The plot displays..."). Lead with the noun phrase.
- Visual-encoding sentences (what a colour/line style/marker/band *is*) stay in the caption; they are needed to read the figure.
- Interpretive content (what a trend means, why it happens, what it implies, comparisons to expectation) does not belong in the caption:
  - If the adjacent prose already states it, cut it from the caption.
  - If it does not appear anywhere in the prose, move it into the prose paragraph carrying the `\cref` to that figure; do not delete information, relocate it.
- Schematics/diagrams with no axes: replace "as a function of X" with a list of the labelled components shown ("Schematic of X, showing A, B, and C").
- Photographs: lead noun phrase names the subject and orients the reader to visible labelled features only, with no claims about what a feature demonstrates.
- External reproductions (`\figfrom`/`\adaptedfrom`): may carry slightly longer visual-encoding sentences than average, since the source's own framing often is not reproduced in the thesis prose, but still no added interpretation beyond the source figure's own content.

---

## 17. Metric and result macros for numerical values

All numerical results cited in prose (significances, luminosities, thresholds, and any derived quantity read from data or figures) **must** use a predefined macro. Hardcoded numbers are forbidden in chapter text. Two sources:

| Macro family | File | Written by |
|---|---|---|
| `\fom...` | `references/metrics/main.tex` | Hand, for conventions, study parameters and values read from figures or the literature |
| `\res...` | `results/*macros.tex` | Analysis scripts; regenerated, never hand-edited |

**Rule:** If no macro exists for the value you need, define one first (or add it to the script that writes the `results/` file), then cite it.

Macros that print a quantity with `\sigma` must wrap it in `\ensuremath{...}` so they work both inside and outside `$...$`. Approximation markers travel with the macro, so do not write "approximately" or "about" in front of a macro whose value already carries `\sim`.

```latex
% references/metrics/main.tex: add the macro
\newcommand{\fomHggCombSignificanceAtRunTwo}{\num{5.2}\,\sigma\xspace} % expected Z, diphoton + 4l, full Run 2

% chapter text: use the macro
the combination reaches \fomHggCombSignificanceAtRunTwo\ with the full dataset.
```

**One source per quantity:** before defining a macro, search `references/metrics/main.tex` and `results/` for the value. If the same physical quantity already has a macro, reuse it; if a second name is useful for readability, define it as an alias (`\newcommand{\fomBeamEnergy}{\fomLHCBeamEnergy}`), never with a second literal value. Derived wording should build on the base macro (`\fomTrigEfficiencyLevel` is `${>}\,$\fomTrigEfficiencyValue`). Coincidental equal values with different meanings (e.g. two unrelated 20 cm distances) keep separate macros with a comment stating what each one is. Delete macros that are no longer used rather than leaving stale values.

**Scope:** analysis conventions (reference luminosities, radii, mass windows, priors), results and study parameters in all chapters and appendices, and literature values quoted in more than one place. Numbers inside tables, equations defining a method, and single-use literature values in the introductory chapters may stay literal.

**Rationale:** When analysis results are updated, a single edit to the macro file (or one regeneration of `results/`) propagates everywhere. A hardcoded value in prose silently goes stale and is not caught by grep.

**Naming convention:** `\fom[Analysis][Selection][Quantity][EvaluatedAt]` (same pattern for `\res...`)

| Segment | Examples |
|---|---|
| Analysis | `Hgg`, `Hzz`, `Comb` |
| Selection / sample | `Barrel`, `Endcap`, `RunTwo`, `Combined` |
| Quantity | `Significance`, `MassResolution`, `FiveSigmaLumi` |
| EvaluatedAt (if derived) | `AtRunTwo`, `AtBarrelFiveSigma` |

**Do not** use `\approx`, `\sim`, or prose like "approximately X" with an inline literal; wrap the approximation inside the macro value itself (e.g. `\num{\sim 1.4}`), so the approximation marker travels with the number.

---

## 18. Plot and table labels

Text inside generated plots and tables is set where they are generated (plotting script options, label mappings) and changed there, then regenerated (§14).

**Plot titles**: `{Sample/Selection} {Data} - {Study}`, Title Case:

- *Sample/Selection*: the recurring name as defined in §10. Omit it when several are overlaid and named in the legend. Never in parentheses at the end of the title.
- *Data*: the analysis or quantity, spelled as in the thesis: `Diphoton Invariant Mass`, `Jet Energy Resolution`, `Track Reconstruction Efficiency`.
- *Study*: what varies or which selection stage is shown: `Pile-Up Dependence`, `Preselection`, `Significance`. Qualifiers go in parentheses after it: `- Impact Parameter Residuals (MC, After Cut)`.
- No abbreviations (`Uncertainty`, not `Unc.`; `Efficiency`, not `Eff.`).
- Reference or physics-input plots (spectra, cross sections, lab measurements) keep a plain descriptive title; the source goes in parentheses: `Parton Distribution Functions (NNPDF3.1)`.

**Legends**: entries use the same names as titles and prose. Legend titles are words, not column names (`Pile-Up Condition`, not `PileUpCondition`).

- **No title on legends whose entries explain themselves** (samples, background components, selections), so no `Sample`, `Component` or `Name` heading. A title stays where the entries are values of a scanned quantity (`Transverse Momentum (GeV)`, `Pile-Up`).
- **One name and one colour per entity, in every figure.** Keep a single mapping from entity to colour and reuse it; never assign ad-hoc colours. Entries follow the fixed order of §10.
- **Line-style legends:** when a second legend explains the line styles (e.g. `Raw`/`Smoothed`), the colour legend shows solid lines.
- **Text size of multi-panel figures:** a three-panel row is shrunk more to fit the text width, so enlarge its text accordingly in the plotting configuration, not per figure.
- **Tables of optimised quantities** (cut thresholds, selection limits) also give the value of the metric that was maximised, with the metric named in the header or caption.
- **Placement:** the legend never covers data.

**Panel subtitles** (multi-panel plots): only what distinguishes the panel, Title Case: the named value alone (`Nominal`, `Energy Scale Up`, not `Variation: Nominal`), `Signal` / `Background` for boolean splits, and `Key: value` only for numeric values (`Pile-Up: 40`).

**Axis labels**: Title Case, unit in parentheses: `Diphoton Mass (GeV)`, `Significance ($\sigma$)`, `$p_{\mathrm{T}}$ (GeV)`, `Drift Time ($\mu$s)`. The same applies to colorbar (z) labels; do not append `(log scale)`, the tick labels show it. Use `True`/`Reco` for truth and reconstructed quantities (`|Reco $\eta$ - True $\eta$|`).

**Units in axis labels**: exponent form, as the siunitx text, with negative powers in one fixed order throughout the thesis: `Rate (cm$^{-2}$ s$^{-1}$)`, `Events (GeV$^{-1}$)`, `Events (GeV$^{-1}$, 139 fb$^{-1}$)`; normalised distributions: `Density (GeV$^{-1}$)`. No slash forms (`events / GeV`) and no grouped forms (`(cm$^{2}$ s)$^{-1}$`).

**Table headers**: column headers in sentence case (`Mass resolution (GeV)`, `Efficiency (\unit{\percent})`), units in parentheses, never brackets; category labels that are names keep their case. A title row, when present, is Title Case like a plot title.

---

## 19. Plot styles: step, line and markers

The drawing style tells the reader what kind of quantity is plotted. Choose it from the nature of the data, not from what looks smoother.

| Data | Style | Examples |
|---|---|---|
| Histogram of counts, density or weighted counts | step outline; filled step for stacked or component spectra | invariant-mass spectra, residuals, background stacks |
| Per-bin quantity computed from binned MC (efficiency, fraction, mean, median, RMS per bin of a numeric axis) | step; open outline for ratios | trigger efficiency, fake rate, resolution vs true energy |
| Analytical or model curve, fit, or quantity evaluated on a parameter grid | line | cross sections, fit functions, significance vs luminosity, figure of merit vs cut value, CDFs, waveforms |
| Measurement at discrete settings, sparse points, or a categorical x axis | markers (with error bars), no joining line | values per run period or per detector region |

**Rules:**
- A line never joins histogram bins: binned data drawn as a line suggests a continuous model and hides the bin width.
- A step never draws an analytical curve: a model evaluated on a grid is a line, whatever the grid spacing.
- Fits and model predictions overlaid on data use a line over markers or steps; the data keep their own style.
- Ratios and efficiencies are drawn with an open outline: the closing edge of a histogram outline would read as a zero fraction. Bins without entries are left out, not drawn as zero.
- Measurements with a fitted model (e.g. gain vs bias voltage) show the data as markers and the fit as a line; the caption names the line as the fit.
- Lines joining measurements are only used as a guide to the eye and the caption says so.
- Figures of the same kind (e.g. one filled spectrum per selection stage) share one fill opacity, line width and reference-line style.

---

## 20. Workflow schemes (TikZ)

All workflow schemes (simulation, reconstruction, calibration, statistical analysis chains) are TikZ files in `diagrams/` and share one visual language. Physics diagrams (Feynman diagrams, decay chains, level schemes, detector sketches) are not workflow schemes; they use the same palette but define their own colour key in the caption.

**Colour = role of the box.** Fills are always the `!20` tint; one colour has one meaning in every scheme:

| Fill | Role | Examples |
|---|---|---|
| `gray!20` | Data products and inputs that are not operations: events, samples, histograms, results, configuration lists, external software tools | Raw Event, Simulated Sample, Geant4 |
| `accentVermilion!20` | Processing step of the main chain | Hit Finding, Track Fitting, Event Selection |
| `accentSkyBlue!20` | Parallel branch processed alongside the main chain | Calorimeter Clustering, Background Estimation |
| `accentGreen!20` | Steps that combine the two branches | Track-Cluster Matching, Particle Flow |
| `accentOrange!20` | Classification and statistical inference | Multivariate Classifier, Likelihood Fit |

`accentBlack` is reserved for text and outlines.

**Boxes:**

- Common base style: `rectangle, draw, rounded corners, align=center, font=\footnotesize, minimum height=1.3cm, execute at begin node=\hyphenpenalty10000\relax` (no hyphenation inside boxes).
- Widths and column positions from one shared grid across all schemes (e.g. single column, three-column row, half and full width), so boxes line up between figures.
- At most three lines of text per box: a Title Case title in `\footnotesize`, then up to two detail lines in `{\scriptsize ...\par}`.
- No `\textbf`, no section, chapter or figure links inside boxes; pointers go in the caption or the prose. Use `\qtyrange`/`\fom*` macros and the name macros (§10) as in prose.

**Frames, lines and arrows:**

- Arrows: `thick, ->, >=stealth`. Merging lines are plain `thick` segments meeting at right angles.
- Dashed arrows mark feedback or optimisation loops; the caption names them.
- Stages are grouped by dashed rounded frames (`inner sep=6pt`) or by dashed horizontal separators, labelled in `\footnotesize\itshape` at a frame corner where no arrow crosses the label.
- A dashed, unfilled box marks the continuation outside the scheme (the next stage or chapter).
- A `very thick` frame marks steps developed or tuned for this thesis; the caption says so.

**Caption:** follows §16 for schematics, "Schematic of X, showing/from A ... to B", plus one sentence for any non-obvious line style. Multi-stage schemes may be full-page floats (`[p]`): scheme plus caption fill exactly one page, tuned with the vertical unit of the picture (`y=1.07cm` etc. in the `tikzpicture` options) so box sizes stay on the grid. Short schemes stay inline (`[!ht]`).

---

## 21. Acronyms and glossary entries

Acronyms are defined in `references/acronyms/main.tex` (`\newacronym`, printed "long form (SHORT)" at the first `\gls` and as SHORT afterwards), named entities in `references/glossary/main.tex` (`\newglossaryentry`, printed by name only). The lists are printed with `\printnoidxglossary`, which shows **only entries that are used**.

- **Long forms in lower case** unless they are proper names: `{transverse momentum}`, `{silicon photomultiplier}`, `{quantum chromodynamics}`; keep the case of names, documents and models (`{Cabibbo--Kobayashi--Maskawa}`, `{Standard Model}`, `{Technical Design Report}`, `{Monte Carlo}`). Names joined by a dash use `--`. British spelling (`{minimum ionising particle}`).
- **Sentence start:** use `\Gls{...}` / `\Glspl{...}` when an acronym can open a sentence on its first use.
- **Irregular plurals** go in the definition: `\newacronym[longplural={analyses of variance}]{anova}{ANOVA}{analysis of variance}`.
- **Define once.** The first `\gls` prints the expansion; never also write it by hand ("transverse momentum ($p_{\mathrm{T}}$)", "boosted decision tree (BDT)"), and do not use `\acrfull` to re-expand (it does not mark the entry as used, so the next `\gls` expands again).
- **First use in running text**, not in a caption, heading or table: floats move, and headings feed the table of contents and running heads. Headings use plain text (`\paragraph{Quantum Chromodynamics}`, not `\paragraph{\gls{qcd}}`).
- **No raw abbreviation without a definition.** Every abbreviation the reader meets (ADC, ROC, AUC, ...) is either an entry used with `\gls` at its first occurrence or spelled out by hand once (institutes and companies: "the European Organization for Nuclear Research (CERN)", "the manufacturer Hamamatsu").
- **No single-use acronyms** (write the words) and **no unused entries**: delete an entry when its last `\gls` goes.
- **Experiments and facilities** with an abbreviated name are glossary entries; spell the full name out by hand at the first use in running text: "the Large Hadron Collider (\gls{lhc})".
- **Glossary descriptions** are one noun phrase in the present tense for running projects and the past tense for finished ones ("operated from 1989 to 2000"); no thesis-specific results.
- **Names** keep their official form: Geant4, ROOT, Pythia, MadGraph5\_aMC@NLO.
