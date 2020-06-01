SOURCE = $(wildcard *.rmd) $(wildcard *.png)
TARGET = $(SOURCE:%.rmd=%.nb.html)

PNGSOURCE = $(wildcard *.svg)
PNGTARGET = $(PNGSOURCE:%.svg=%.png)

default: $(TARGET)

%.nb.html: %.rmd $(PNGTARGET)
	Rscript -e 'library(rmarkdown); render("$<")'

%.png: %.svg
	inkscape --export-type=png $< || inkscape $< -e $@

zip: proyecto.zip
.PHONY: zip

proyecto.zip: $(TARGET) $(SOURCE) $(PNGTARGET)
	zip $@  $^

install: $(TARGET) $(SOURCE) $(PNGTARGET)
	install -d $(DESTDIR)
	cp $^ $(DESTDIR)
