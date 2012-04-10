MAIN = ellipses
MS=$(MAIN)
VERSION =
TGZFILE = $(MS)$(VERSION).tar.gz
ZIPFILE  = $(MS)${VERSION}.zip
ZIPSUPP = $(MS)-suppfiles.zip

# Stuff for making the archives
TEXDEPEND = texdepend
TAR = /bin/tar
ZIP = /usr/bin/zip
BIBTOOL = bibtool -- quiet=on -r ~/texmf/bibtex/bib/aux2bib.rsc

#  latex or  pdflatex?
LATEX = latex
# name of BibTeX command
BIBTEX = bibtex

# LaTeX flags
LATEXFLAGS = -interaction=nonstopmode


# texdepend, v0.96 (Michael Friendly (friendly@yorku.ca))
# commandline: texdepend ellipses.tex
#INCLUDES = introduction.tex geometric.tex statistical.tex dataellipse.tex linreg.tex simpson-iris.tex paradoxes.tex levdemo.tex betaspace.tex measerror.tex avplot.tex MLM.tex criteria.tex kiss.tex discrim.tex ridge.tex ridge2.tex bayesian.tex mixed.tex hsbmix.tex mvmeta.tex conclusions.tex properties.tex conjugate.tex geneig.tex
INCLUDES = introduction.tex geometric.tex statistical.tex dataellipse.tex linreg.tex simpson-iris.tex paradoxes.tex levdemo.tex betaspace.tex measerror.tex avplot.tex MLM.tex criteria.tex kiss.tex discrim.tex ridge.tex ridge2.tex bayesian.tex mixed.tex hsbmix.tex mvmeta.tex conclusions.tex taxonomy2.tex properties.tex conjugate.tex geneig.tex
#
PACKAGES = article.cls times.sty natbib.sty url.sty bm.sty graphicx.sty epigraph.sty comment.sty mdwlist.sty amsmath.sty amssymb.sty latexsym.sty color.sty afterpage.sty fancyhdr.sty
#
FIGS = fig/galton-corr.* fig/galton-reg3.* fig/scatirisd1.* fig/scatirisd3.* fig/ellipses-demo.* fig/vis-reg-prestige1.* fig/vis-reg-prestige2.* fig/contiris3.* fig/between-within1.* fig/between-within2.* fig/between-HE1.* fig/between-HE2.* fig/levdemo21.* fig/levdemo22.* fig/vis-reg-coffee11.* fig/vis-reg-coffee12a.* fig/vis-reg-coffee12b.* fig/vis-reg-coffee13.* fig/coffee-stress1.* fig/coffee-stress2.* fig/coffee-measerr.* fig/coffee-avplot1.* fig/coffee-avplot2.* fig/coffee-av3D-1.* fig/coffee-av3D-2.* fig/coffee-avplot3.* fig/coffee-avplot4.* fig/mtests.* fig/heplot3a.* fig/HE-contrasts-iris.* fig/HE-can-iris.* fig/kiss-demo.* fig/kiss-demo2a.* fig/kiss-demo2b.* fig/ridge-demo.* fig/ridge2ab.* fig/hsbmix41.* fig/hsbmix42.* fig/hsbmix43.* fig/mvmeta2a.* fig/mvmeta2b.* fig/inverse.* fig/conjugate1.* fig/conjugate2.* fig/ellipse-geneig1.* fig/ellipse-geneig2.*
#
BIB_FILES = ellipses.bib
#
STYLES = /usr/share/texmf-texlive/tex/latex/psnfss/times.sty /usr/share/texmf-texlive/tex/latex/natbib/natbib.sty /usr/share/texmf-texlive/tex/latex/ltxmisc/url.sty /usr/share/texmf-texlive/tex/latex/tools/bm.sty /usr/share/texmf-texlive/tex/latex/graphics/graphicx.sty /usr/share/texmf-texlive/tex/latex/graphics/keyval.sty /usr/share/texmf-texlive/tex/latex/graphics/graphics.sty /usr/share/texmf-texlive/tex/latex/graphics/trig.sty /home/friendly/texmf/tex/latex/misc/epigraph.sty /usr/share/texmf-texlive/tex/latex/comment/comment.sty /usr/share/texmf-texlive/tex/latex/mdwtools/mdwlist.sty /usr/share/texmf-texlive/tex/latex/amsmath/amsmath.sty /usr/share/texmf-texlive/tex/latex/amsmath/amstext.sty /usr/share/texmf-texlive/tex/latex/amsmath/amsgen.sty /usr/share/texmf-texlive/tex/latex/amsmath/amsbsy.sty /usr/share/texmf-texlive/tex/latex/amsmath/amsopn.sty /usr/share/texmf-texlive/tex/latex/amsfonts/amssymb.sty /usr/share/texmf-texlive/tex/latex/amsfonts/amsfonts.sty /usr/share/texmf-texlive/tex/latex/base/latexsym.sty /usr/share/texmf-texlive/tex/latex/graphics/color.sty /usr/share/texmf-texlive/tex/latex/tools/afterpage.sty /usr/share/texmf-texlive/tex/latex/fancyhdr/fancyhdr.sty

ALTFIGS =
#

SUPPDOC = supp.tex taxonomy2.tex properties.tex conjugate.tex geneig.tex
SUPPFIGS = fig/gell3d-1.png fig/gell3d-4.png fig/inverse.png fig/conjugate1.pdf fig/conjugate2.pdf fig/ellipse-geneig1.pdf fig/ellipse-geneig2.pdf fig/galton-reg3.pdf fig/scatirisd1.pdf fig/ellipses-demo.pdf fig/vis-reg-prestige1.pdf fig/contiris3.pdf fig/between-within1.png fig/between-HE1.png fig/levdemo21.pdf fig/vis-reg-coffee11.pdf fig/vis-reg-coffee12a.pdf fig/vis-reg-coffee13.pdf fig/coffee-stress1.png fig/coffee-measerr.png fig/coffee-avplot1.png fig/coffee-av3D-1.png fig/coffee-avplot3.png fig/mtests.png fig/heplot3a.pdf fig/HE-contrasts-iris.pdf fig/HE-can-iris.pdf fig/kiss-demo.png fig/kiss-demo2a.pdf fig/ridge-demo.png fig/ridge2.pdf fig/hsbmix41.pdf fig/hsbmix43.pdf fig/mvmeta2a.png
SUPPBIB = supp.bib

#SUPPFILES = SAS/*.sas R/*.R  movies/*.gif
SUPPFILES = SAS/*.sas R/*.R 
SUPPFILES = supp.pdf ${SUPPDOC} ${SUPPFIGS} ${SUPPBIB} SAS/*.sas R/*.R 


SHIPSTYLES = styles/*

EXTRAS = $(MAIN:%=%.aux) $(MAIN:%=%.bbl)  \
 $(SHIPSTYLES) Makefile FIGLIST

ALLFILES = $(MAIN).tex $(MAIN).pdf  $(INCLUDES) $(BIB_FILES) $(FIGS) $(ALTFIGS) $(EXTRAS)

# Dependencies
#
paper:	$(MAIN).tex $(INCLUDES)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	-@egrep -c 'Citation .* undefined.' $(MAIN).log && ($(BIBTEX) $(MAIN);$(LATEX) $(MAIN))
	dvipdf $(MAIN)

${ZIPFILE}: ${ALLFILES}

${TARFILE}: ${ALLFILES}

${ZIPSUPP}: ${SUPPFILES}

$(MAIN).dvi: $(MAIN).tex $(FIGS)

$(MAIN).ps: $(MAIN).dvi

#  BUG:  Preamble lines are not included in the new bib file
#references.bib : $(MAIN).aux
#	aux2bib $(MAIN)
# Switch to using bibtool
$(MAIN).bib : 
	$(BIBTOOL) -x $(MAIN).aux -o $(MAIN).bib
	
## Hand edited FIGLIST because of multiple images/fig
#FIGLIST:
#	$(TEXDEPEND) -format=1 -print=f $(MAIN)  | perl -pe 'unless (/^#/){\$f++; s/^/Figure \$f: /}' > FIGLIST
	


# Targets for archives
# note
zip: ${ALLFILES}
	$(ZIP) -r -u  $(ZIPFILE) $(ALLFILES)

tar: ${ALLFILES}
	$(TAR) cvhf - $(ALLFILES) | $(GZIP) > $(TGZFILE) 

supp: ${SUPPFILES}
	$(ZIP) -r -u  $(ZIPSUPP) $(SUPPFILES)

git-push: ${ALLFILES}
	git push -u origin master
