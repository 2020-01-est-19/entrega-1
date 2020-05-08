SOURCE = $(wildcard *.rmd)
TARGET = $(SOURCE:%.rmd=%.nb.html)

default: $(TARGET)

%.nb.html: %.rmd
	Rscript -e 'library(rmarkdown); render("$<")'

zip: proyecto.zip
.PHONY: zip

proyecto.zip: $(TARGET) $(SOURCE) $(wildcard *.png)
	zip $@  $^
