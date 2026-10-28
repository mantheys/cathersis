# Use pdflatex with file-line-error for proper IDE error highlighting.
# max_print_line prevents log lines from wrapping at 79 chars, which breaks
# LaTeX Workshop's log parser (truncated "input line NNN" entries become "line N").
$pdf_mode = 1;
$pdflatex = 'max_print_line=10000 pdflatex -file-line-error -interaction=nonstopmode -synctex=1 %O %S';

# Keep all auxiliary files out of the project root
$out_dir = '.build';

# Run bibtex automatically when needed
$bibtex_use = 2;

# Continue building even when pdflatex reports non-fatal warnings
# (missing characters from pre-existing sources, multiply-defined labels, etc.)
$force_mode = 1;

# \include writes per-file .aux files relative to $out_dir, so the matching
# subdirectories must exist before pdflatex runs.  Create them here so that
# latexmk (and LaTeX Workshop) do not hit a fatal "cannot open file" error.
use File::Path qw(make_path);
make_path("$out_dir/chapters");
for my $d (glob('chapters/*')) {
    make_path("$out_dir/$d") if -d $d;
}
