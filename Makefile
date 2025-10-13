# Makefile for LaTeX thesis compilation

# Main thesis file (without .tex extension)
THESIS = thesis

# LaTeX compiler
LATEX = pdflatex
BIBTEX = bibtex

# Compilation flags
LATEXFLAGS = -interaction=nonstopmode -halt-on-error

# Default target
.PHONY: all
all: $(THESIS).pdf

# Main compilation target
$(THESIS).pdf: $(THESIS).tex chapters/*.tex references.bib
	$(LATEX) $(LATEXFLAGS) $(THESIS)
	$(BIBTEX) $(THESIS)
	$(LATEX) $(LATEXFLAGS) $(THESIS)
	$(LATEX) $(LATEXFLAGS) $(THESIS)

# Quick compilation (single pass, no bibliography)
.PHONY: quick
quick:
	$(LATEX) $(LATEXFLAGS) $(THESIS)

# Clean auxiliary files
.PHONY: clean
clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg *.fls *.fdb_latexmk
	rm -f chapters/*.aux

# Clean everything including PDF
.PHONY: cleanall
cleanall: clean
	rm -f $(THESIS).pdf

# View the PDF (using default PDF viewer)
.PHONY: view
view: $(THESIS).pdf
	@if command -v xdg-open > /dev/null 2>&1; then \
		xdg-open $(THESIS).pdf; \
	elif command -v open > /dev/null 2>&1; then \
		open $(THESIS).pdf; \
	else \
		echo "No PDF viewer found. Please open $(THESIS).pdf manually."; \
	fi

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all (default) - Compile the thesis with bibliography"
	@echo "  quick         - Quick compilation (single pass, no bibliography)"
	@echo "  clean         - Remove auxiliary files"
	@echo "  cleanall      - Remove all generated files including PDF"
	@echo "  view          - Open the PDF after compilation"
	@echo "  help          - Show this help message"
