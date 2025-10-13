# PhD Thesis in Particle Physics

A simple LaTeX template for writing a PhD thesis in particle physics.

## Overview

This repository contains a comprehensive LaTeX template for a PhD thesis in particle physics. The template follows standard academic formatting and includes all necessary sections for a complete thesis.

## Structure

The thesis is organized as follows:

```
THESIS/
├── thesis.tex              # Main thesis file
├── references.bib          # Bibliography file
├── Makefile               # Build automation
├── chapters/              # Individual chapters
│   ├── titlepage.tex     # Title page
│   ├── abstract.tex      # Abstract
│   ├── introduction.tex  # Introduction chapter
│   ├── theory.tex        # Theoretical framework
│   ├── experiment.tex    # Experimental setup
│   ├── results.tex       # Results and analysis
│   ├── conclusion.tex    # Conclusion
│   └── appendix.tex      # Appendix
└── README.md             # This file
```

## Features

- **Clean, professional layout** with proper page margins and spacing
- **Complete chapter structure** covering all aspects of a particle physics thesis:
  - Introduction to particle physics and the Standard Model
  - Theoretical framework (QFT, electroweak theory, QCD)
  - Experimental setup (accelerators, detectors, data acquisition)
  - Results and analysis (systematic uncertainties, statistical methods)
  - Conclusions and future outlook
  - Appendix with supplementary material
- **Bibliography support** with BibTeX and sample particle physics references
- **Proper mathematical typesetting** with AMS packages
- **Hyperlinked cross-references** for easy navigation
- **Makefile** for easy compilation

## Prerequisites

To compile this thesis, you need a LaTeX distribution installed:

- **Linux**: Install TeX Live
  ```bash
  sudo apt-get install texlive-full
  ```

- **macOS**: Install MacTeX
  ```bash
  brew install --cask mactex
  ```

- **Windows**: Install MiKTeX or TeX Live

## Compilation

### Using Make (Recommended)

The easiest way to compile the thesis is using the provided Makefile:

```bash
# Full compilation with bibliography (default)
make

# Quick compilation (single pass, no bibliography)
make quick

# Clean auxiliary files
make clean

# Clean everything including PDF
make cleanall

# View the PDF after compilation
make view

# Show all available commands
make help
```

### Manual Compilation

If you prefer to compile manually:

```bash
pdflatex thesis
bibtex thesis
pdflatex thesis
pdflatex thesis
```

The multiple `pdflatex` runs are necessary to resolve all cross-references and include the bibliography.

## Customization

### Personal Information

Edit the following files to add your personal information:

1. **thesis.tex**: Update the document metadata (title, author, date)
2. **chapters/titlepage.tex**: Modify title page with your details
3. **chapters/abstract.tex**: Write your abstract

### Content

Each chapter is in a separate file in the `chapters/` directory:

- `introduction.tex` - Introduce your research topic
- `theory.tex` - Present the theoretical background
- `experiment.tex` - Describe your experimental methods
- `results.tex` - Present your results and analysis
- `conclusion.tex` - Summarize findings and future work
- `appendix.tex` - Add supplementary material

### Bibliography

Add your references to `references.bib` following the BibTeX format. The template includes sample references for common particle physics papers and textbooks.

### Styling

To modify the appearance, edit `thesis.tex`:

- Page margins: Adjust the `geometry` package settings
- Line spacing: Change `\onehalfspacing` to `\singlespacing` or `\doublespacing`
- Font size: Modify the document class option (e.g., `12pt`)
- Headers/footers: Customize the `fancyhdr` settings

## Tips

1. **Compile frequently** to catch errors early
2. **Use version control** (Git) to track changes
3. **Break long equations** across multiple lines for readability
4. **Label everything** (chapters, sections, equations, figures, tables) for easy cross-referencing
5. **Use `\cite{key}` for citations** to automatically generate the bibliography
6. **Add figures** to a `figures/` directory and include them with `\includegraphics`

## Resources

### Particle Physics

- Particle Data Group: https://pdg.lbl.gov/
- CERN Document Server: https://cds.cern.ch/
- arXiv.org (High Energy Physics): https://arxiv.org/archive/hep-ph

### LaTeX Help

- LaTeX Wikibook: https://en.wikibooks.org/wiki/LaTeX
- TeX Stack Exchange: https://tex.stackexchange.com/
- Overleaf Documentation: https://www.overleaf.com/learn

## License

This template is provided as-is for academic use. Feel free to modify and adapt it for your own thesis.

## Contributing

If you find issues or have suggestions for improvements, please open an issue or submit a pull request.
