SOURCE = $(wildcard *.rmd) $(wildcard *.svg) Dockerfile Makefile
TARGET = $(SOURCE:%.rmd=%.html)

default: $(TARGET)

%.html: %.rmd
	Rscript -e 'library(rmarkdown); render("$<")'
	mv $(@:%.html=%.nb.html) $@ || true

zip: proyecto.zip
.PHONY: zip

proyecto.zip: $(TARGET) $(SOURCE)
	zip $@  $^

install: $(TARGET) $(SOURCE)
	install -d $(DESTDIR)
	cp $^ $(DESTDIR)
