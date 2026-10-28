# Makefile for LaTeX thesis compilation

# Main thesis file (without .tex extension)
THESIS = thesis

# LaTeX compiler
LATEX = pdflatex
LATEXFLAGS = -interaction=nonstopmode -halt-on-error -synctex=1
REVIEWINPUT = \def\REVIEWBUILD{1}\input{$(THESIS).tex}

# Build directory for auxiliary output
BUILD_DIR ?= .build

# Absolute paths for use when cd'ing into subdirectories
ABS_BUILD_DIR := $(abspath $(BUILD_DIR))
CUR_DIR := $(abspath .)

# Mirror the workspace into the build dir. LaTeX intermediate files are
# excluded, so files left in the workspace by an in-place build (e.g. an
# editor running latexmk with the workspace as output dir) are never copied
# over the build outputs, and the build outputs are never deleted.
LATEX_INTERMEDIATES = '*.aux' '*.toc' '*.lof' '*.lot' '*.glsdefs' '*.bbl' '*.bcf' \
	'*.blg' '*.run.xml' '*.log' '*.fls' '*.fdb_latexmk' '*.out' '*.mtc*' '*.maf' \
	'*.glg' '*.glo' '*.gls' '*.acn' '*.acr' '*.alg' '*.ist' '*.synctex.gz' \
	'/$(THESIS).pdf' '/thesis_chapter*.pdf' '/thesis_abstract.pdf' '/thesis_summary.pdf'
RSYNC_BUILD = rsync -a --delete --exclude='.git' --exclude='.build' \
	$(foreach p,$(LATEX_INTERMEDIATES),--exclude=$(p)) $(CUR_DIR)/ $(ABS_BUILD_DIR)/

# Later passes put the workspace first on TEXINPUTS (so SyncTeX points at the
# source files), which means TeX would also read workspace .aux files before
# the build ones. Remove the ones that belong to the full thesis build.
define remove-workspace-aux
@stale=$$(ls $(CUR_DIR)/$(THESIS).aux $(CUR_DIR)/chapters/*.aux 2>/dev/null); \
if [ -n "$$stale" ]; then \
	echo "Removing stale .aux files from the workspace (an in-place build left them):"; \
	echo "$$stale"; rm -f $$stale; \
fi
endef

# Default target
.PHONY: all
all: $(THESIS).pdf

# Collect chapter source files (top-level and one-level subdirectories)
CHAPTER_SRCS := $(wildcard chapters/*.tex) $(wildcard chapters/*/*.tex)

# Main compilation target


$(THESIS).pdf: $(THESIS).tex $(CHAPTER_SRCS) references.bib
	@mkdir -p $(BUILD_DIR)
	@$(RSYNC_BUILD)
	$(remove-workspace-aux)
	@# Delete the main aux before pass 1 so a crash-truncated aux from a
	@# previous run never poisons the next build (rsync excludes, and so keeps, it).
	@rm -f $(ABS_BUILD_DIR)/$(THESIS).aux
	@(cd $(ABS_BUILD_DIR) && $(LATEX) $(LATEXFLAGS) $(THESIS).tex)
	@(cd $(ABS_BUILD_DIR) && biber $(THESIS))
	@(cd $(ABS_BUILD_DIR) && TEXINPUTS=$(CUR_DIR): $(LATEX) $(LATEXFLAGS) $(THESIS).tex)
	@(cd $(ABS_BUILD_DIR) && TEXINPUTS=$(CUR_DIR): $(LATEX) $(LATEXFLAGS) $(THESIS).tex)
	cp $(ABS_BUILD_DIR)/$(THESIS).pdf $(CUR_DIR)/$(THESIS).pdf || true
	cp $(ABS_BUILD_DIR)/$(THESIS).synctex.gz $(CUR_DIR)/$(THESIS).synctex.gz || true

# Quick compilation for review: draft graphics so the build finishes fast.
.PHONY: quick
quick:
	@mkdir -p $(BUILD_DIR)
	@$(RSYNC_BUILD)
	@(cd $(ABS_BUILD_DIR) && $(LATEX) $(LATEXFLAGS) "$(REVIEWINPUT)")
	cp $(ABS_BUILD_DIR)/$(THESIS).pdf $(CUR_DIR)/$(THESIS).pdf || true
	cp $(ABS_BUILD_DIR)/$(THESIS).synctex.gz $(CUR_DIR)/$(THESIS).synctex.gz || true

# Shared helpers used inside chapter/chapter-full recipes.
# CH_PREV: chapter counter value before \chapter{} increments it.
# CHSET:   inline TeX fragment that sets the counter at \begin{document}.
# CHBIB:   inline TeX fragment that emits a bibliography at \end{document}.
CH_PREV = $$(( $(CH) - 1 ))
CHSET   = \AtBeginDocument{\setcounter{chapter}{$(CH_PREV)}}
CHBIB   = \AtEndDocument{\printbibliography}

# Inject cross-reference labels from a full thesis build so \cref resolves.
# pdflatex overwrites the aux on every pass, so this must run before each pass.
define inject-labels
grep '\\newlabel' $(ABS_BUILD_DIR)/thesis.aux >> $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.aux 2>/dev/null || true
endef

# Seed the chapter's minitoc from the last full thesis build.
# \dominitoc reads the .toc from the previous chapter pass; on the very first
# build (no .toc yet) this pre-seeds the mtc so pass 1 already shows content.
define inject-mtc
cp $(ABS_BUILD_DIR)/thesis.mtc$(CH) $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.mtc$(CH) 2>/dev/null || true
endef

# Build a single chapter by number in review mode (draft graphics, 2 passes).
# Two passes are required: pass 1 writes the .toc; pass 2 \dominitoc reads it
# and populates the .mtcN file so \minitoc has content to display.
.PHONY: chapter
chapter:
	@if [ -z "$(CH)" ]; then \
		echo "Usage: make chapter CH=<n>"; exit 1; \
	fi
	@mkdir -p $(ABS_BUILD_DIR)/chapters/$(CH)_chapter
	@$(RSYNC_BUILD)
	@rm -f $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.aux
	@$(inject-labels)
	@$(inject-mtc)
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && $(LATEX) $(LATEXFLAGS) -jobname=$(CH)_chapter "\def\REVIEWBUILD{1}\def\CHAPTERBUILD{1}$(CHSET)\input{$(CH)_chapter.tex}")
	@$(inject-labels)
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && $(LATEX) $(LATEXFLAGS) -jobname=$(CH)_chapter "\def\REVIEWBUILD{1}\def\CHAPTERBUILD{1}$(CHSET)\input{$(CH)_chapter.tex}")
	cp $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.pdf $(CUR_DIR)/thesis_chapter$(CH).pdf || true
	cp $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.synctex.gz $(CUR_DIR)/thesis_chapter$(CH).synctex.gz || true

# Build a single chapter by number in full mode (full graphics, bibtex, 3 passes).
# Produces a standalone PDF with correct chapter/figure numbers and a bibliography.
.PHONY: chapter-full
chapter-full:
	@if [ -z "$(CH)" ]; then \
		echo "Usage: make chapter-full CH=<n>"; exit 1; \
	fi
	@mkdir -p $(ABS_BUILD_DIR)/chapters/$(CH)_chapter
	@$(RSYNC_BUILD)
	@rm -f $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.aux
	@$(inject-labels)
	@$(inject-mtc)
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && $(LATEX) $(LATEXFLAGS) -jobname=$(CH)_chapter "\def\CHAPTERBUILD{1}$(CHSET)$(CHBIB)\input{$(CH)_chapter.tex}")
	@cp $(ABS_BUILD_DIR)/references.bib $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/references.bib
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && biber $(CH)_chapter || true)
	@$(inject-labels)
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && $(LATEX) $(LATEXFLAGS) -jobname=$(CH)_chapter "\def\CHAPTERBUILD{1}$(CHSET)$(CHBIB)\input{$(CH)_chapter.tex}")
	@$(inject-labels)
	@(cd $(ABS_BUILD_DIR)/chapters/$(CH)_chapter && $(LATEX) $(LATEXFLAGS) -jobname=$(CH)_chapter "\def\CHAPTERBUILD{1}$(CHSET)$(CHBIB)\input{$(CH)_chapter.tex}")
	cp $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.pdf $(CUR_DIR)/thesis_chapter$(CH).pdf || true
	cp $(ABS_BUILD_DIR)/chapters/$(CH)_chapter/$(CH)_chapter.synctex.gz $(CUR_DIR)/thesis_chapter$(CH).synctex.gz || true

# Standalone PDFs of the abstract (Resumen + Abstract) and of the summary
# (Conclusiones + Summary), typeset with the thesis preamble in the build root.
# Cross-references take the numbering of the last full thesis build; the
# summary prints its own bibliography for the works it cites.
# EXCERPT_TEX: $(1) preamble additions, $(2) document body.
# build-excerpt: $(1) job name, then the two EXCERPT_TEX arguments.
EXCERPT_TEX = \def\CHAPTERBUILD{1}\documentclass[$(THESIS).tex]{subfiles}$(1)\begin{document}$(2)\end{document}

define inject-excerpt-labels
grep '\\newlabel' $(ABS_BUILD_DIR)/$(THESIS).aux >> $(ABS_BUILD_DIR)/$(1).aux 2>/dev/null || true
endef

define build-excerpt
@mkdir -p $(BUILD_DIR)
@$(RSYNC_BUILD)
@rm -f $(ABS_BUILD_DIR)/$(1).aux
@$(call inject-excerpt-labels,$(1))
@(cd $(ABS_BUILD_DIR) && $(LATEX) $(LATEXFLAGS) -jobname=$(1) "$(call EXCERPT_TEX,$(2),$(3))")
@(cd $(ABS_BUILD_DIR) && if grep -q '\\abx@aux@cite' $(1).aux; then biber $(1); fi)
@$(call inject-excerpt-labels,$(1))
@(cd $(ABS_BUILD_DIR) && $(LATEX) $(LATEXFLAGS) -jobname=$(1) "$(call EXCERPT_TEX,$(2),$(3))")
@$(call inject-excerpt-labels,$(1))
@(cd $(ABS_BUILD_DIR) && $(LATEX) $(LATEXFLAGS) -jobname=$(1) "$(call EXCERPT_TEX,$(2),$(3))")
cp $(ABS_BUILD_DIR)/$(1).pdf $(CUR_DIR)/$(1).pdf || true
endef

.PHONY: abstract
abstract:
	$(call build-excerpt,thesis_abstract,,\input{chapters/abstract})

# Chapter that holds the Conclusiones + Summary
SUMMARY_CH ?= 5

.PHONY: summary
summary:
	$(call build-excerpt,thesis_summary,\AtEndDocument{\printbibliography},\subfile{chapters/$(SUMMARY_CH)_chapter/$(SUMMARY_CH)_chapter.tex})

# Clean auxiliary files
.PHONY: clean
clean:
	if [ -d "$(BUILD_DIR)" ]; then rm -rf $(BUILD_DIR); fi

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
	@echo "  quick         - Quick compilation (single pass, draft graphics, no bibliography)"
	@echo "  clean         - Remove auxiliary files"
	@echo "  cleanall      - Remove all generated files including PDF"
	@echo "  view          - Open the PDF after compilation"
	@echo "  chapter       - Build a single chapter (usage: make chapter CH=<n>)"
	@echo "  chapter-full  - Build a single chapter with bibliography (usage: make chapter-full CH=<n>)"
	@echo "  abstract      - Build the Resumen + Abstract as thesis_abstract.pdf"
	@echo "  summary       - Build the Conclusiones + Summary as thesis_summary.pdf"
	@echo "  help          - Show this help message"
