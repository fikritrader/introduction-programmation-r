# This makefile provides three targets: tex, pdf and clean.
# The default is "pdf".
# To make a tex file type "make tex"
# To make a pdf file, type "make pdf" or simply "make".
# To remove all files generated by make, type "make clean".
#
# Rouben Rostmaian, minor adjustments for Rnw Nicholas Lewin-koh
# September 2002                              March 2005
# Further adjustments Vincent Goulet
# April 2008

MASTER = introduction_programmation_r.pdf

# The master document depends on all TeX files
RNWFILES = $(wildcard *.Rnw)
TEXFILES = $(wildcard *.tex)

# The work horses
SWEAVE = R CMD SWEAVE --encoding="utf-8"
TEXI2DVI = LATEX=xelatex texi2dvi -b
RM = rm -rf

.PHONY: tex pdf clean

pdf: $(MASTER)
tex: $(RNWFILES:.Rnw=.tex)

%.tex: %.Rnw
	$(SWEAVE) '$<'

$(MASTER): $(RNWFILES) $(TEXFILES)
	$(TEXI2DVI) $(MASTER:.pdf=.tex)

clean:
	$(RM) $(RNWFILES:.Rnw=.tex) \
	*-[0-9][0-9][0-9].eps \
	*-[0-9][0-9][0-9].pdf \
	*.aux *.log  *.blg *.bbl *.out *.rel *~ Rplots.ps
