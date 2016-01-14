# This makefile provides three targets: tex, pdf and clean.
# The default is "pdf".
# To make a tex file type "make tex"
# To make a pdf file, type "make pdf" or simply "make".
# To remove all files generated by make, type "make clean".
#
# Rouben Rostmaian, minor adjustments for Rnw Nicholas Lewin-koh
# September 2002                              March 2005
# Additions Vincent Goulet
# January 2016

# Correspondances url des capsules sur YouTube.
#
#  TITRE ABRÉGÉ  	  CHAPITRE	ACT-2002			INTRO R
#  Présentation		  presentation	http://youtu.be/LTOOBBGDuek	http://youtu.be/PSQIKSKw_ys
#  Indiçage		  bases		http://youtu.be/sMd1IyTg-ic	http://youtu.be/cQUjdwgTyz4
#  Fonction order	  operateurs	http://youtu.be/pPLxbuEZmkA	http://youtu.be/uC-zkzwsCVY
#  Fonction outer	  operateurs	http://youtu.be/Ht04UiHnU_0	http://youtu.be/cyPUAnieWHw
#  Fonction apply	  avance	http://youtu.be/EN-a8bTefNk	http://youtu.be/8UQN6RRnsFA
#  Anatomie		  emacs+ess	http://youtu.be/xiNnHegDau8	http://youtu.be/KtmFDm2AKM4
#  Fichiers configuration emacs+ess	http://youtu.be/IsyQn7d2Ao0	http://youtu.be/jdtjBBkfhO0
#  Installation packages  packages	http://youtu.be/DL48oi2RKjM	http://youtu.be/mL6iNzjHMKE

MASTER = introduction_programmation_r.pdf
CODE = code-partie_1.zip
SORTIES = code-partie_1-sorties.zip

# The master document depends on all TeX files
RNWFILES = $(wildcard *.Rnw)
TEXFILES = $(wildcard *.tex)
RFILES   = presentation.R bases.R operateurs.R fonctions.R avance.R
ROUTFILES := $(RFILES:.R=.Rout)

# The work horses
SWEAVE = R CMD SWEAVE --encoding="utf-8"
TEXI2DVI = LATEX=xelatex TEXINDY=makeindex texi2dvi -b
RBATCH = R CMD BATCH --no-timing
RM = rm -rf

.PHONY: tex pdf clean

pdf: $(MASTER)
tex: $(RNWFILES:.Rnw=.tex)

%.tex: %.Rnw
	$(SWEAVE) '$<'
	sed -E -i "" \
	    -e "s:youtu.be/(presentation|LTOOBBGDuek):youtu.be/PSQIKSKw_ys:" \
	    presentation.tex
	sed -E -i "" \
	    -e "s:youtu.be/(indicage|sMd1IyTg-ic):youtu.be/cQUjdwgTyz4:" \
	    bases.tex
	sed -E -i "" \
	    -e "s:youtu.be/(order|pPLxbuEZmkA):youtu.be/uC-zkzwsCVY:" \
	    -e "s:youtu.be/(outer|Ht04UiHnU_0):youtu.be/cyPUAnieWHw:" \
	    operateurs.tex
	sed -E -i "" \
	    -e "s:youtu.be/(apply|EN-a8bTefNk):youtu.be/8UQN6RRnsFA:" \
	    avance.tex
	sed -E -i "" \
	    -e "s:youtu.be/(anatomie|xiNnHegDau8):youtu.be/KtmFDm2AKM4:" \
	    -e "s:youtu.be/(configuration|IsyQn7d2Ao0):youtu.be/jdtjBBkfhO0:" \
	    emacs+ess.tex
	sed -E -i "" \
	    -e "s:youtu.be/(packages|DL48oi2RKjM):youtu.be/mL6iNzjHMKE:" \
	    packages.tex
	sed -i "" \
	    -e "s:youtu.be/(anatomie|xiNnHegDau8):youtu.be/KtmFDm2AKM4:" \
	    emacs+ess.tex

$(MASTER): $(RNWFILES) $(RFILES) $(TEXFILES)
	$(TEXI2DVI) $(MASTER:.pdf=.tex)

%.Rout: %.R
	echo "options(error=expression(NULL))" | cat - $< > $<.tmp
	$(RBATCH) $<.tmp $@
	$(RM) $<.tmp

zip: $(RFILES) $(ROUTFILES)
	zip -j $(CODE) ${RFILES}
	zip -j $(SORTIES) ${ROUTFILES}

clean:
	$(RM) $(RNWFILES:.Rnw=.tex) \
	*-[0-9][0-9][0-9].eps \
	*-[0-9][0-9][0-9].pdf \
	*.aux *.log  *.blg *.bbl *.out *.rel *~ Rplots.ps
