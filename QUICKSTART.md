# Quick Start Guide

## Getting Started in 5 Minutes

### Step 1: Install LaTeX

**Ubuntu/Debian:**
```bash
sudo apt-get install texlive-latex-base texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra
```

**macOS:**
```bash
brew install --cask mactex
```

**Windows:**
Download and install MiKTeX from https://miktex.org/

### Step 2: Customize Your Thesis

Edit these files with your information:

1. **chapters/titlepage.tex** - Your name, university, date
2. **chapters/abstract.tex** - Your research abstract
3. **thesis.tex** - Update title and author metadata

### Step 3: Compile

```bash
make
```

That's it! Your `thesis.pdf` will be generated.

## Next Steps

### Add Your Content

Each chapter is a separate file in the `chapters/` directory. Edit them to add your research:

- **introduction.tex** - Your research introduction
- **theory.tex** - Theoretical background
- **experiment.tex** - Your experimental methods
- **results.tex** - Your results and analysis
- **conclusion.tex** - Conclusions and future work

### Add References

Add your citations to `references.bib` in BibTeX format, then cite them in your text:

```latex
The Standard Model \cite{standardmodel} describes...
```

### Add Figures

Create a `figures/` directory and add your images:

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{figures/myplot.pdf}
  \caption{My awesome result}
  \label{fig:myresult}
\end{figure}
```

### Compile Frequently

Run `make` after changes to catch errors early:

```bash
make          # Full compilation
make quick    # Fast single-pass
make clean    # Remove temp files
make view     # Open PDF
```

## Tips

- Use `\label{}` and `\ref{}` for cross-references
- Compile frequently to catch errors early
- Break long equations across lines
- Use version control (git) to track changes

## Getting Help

- LaTeX Wikibook: https://en.wikibooks.org/wiki/LaTeX
- TeX Stack Exchange: https://tex.stackexchange.com/
- See README.md for detailed documentation
