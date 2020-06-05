SOURCE = $(wildcard *.rmd) $(wildcard *.png) plots.r
TARGET = $(SOURCE:%.rmd=%.html)

PNGSOURCE = $(wildcard *.svg)
PNGTARGET = $(PNGSOURCE:%.svg=%.png)

default: $(TARGET)

%.html: %.rmd $(PNGTARGET)
	Rscript -e 'library(rmarkdown); render("$<")'
	mv $(@:%.html=%.nb.html) $@ || true

%.png: %.svg
	inkscape --export-type=png $< || inkscape $< -e $@

zip: proyecto.zip
.PHONY: zip

proyecto.zip: $(TARGET) $(SOURCE) $(PNGTARGET)
	zip $@  $^

install: $(TARGET) $(SOURCE) $(PNGTARGET)
	install -d $(DESTDIR)
	cp $^ $(DESTDIR)
