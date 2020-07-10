FROM ubuntu

# Las instrucciones para compilar el proyecto están en el README del repositorio
# en Github. https://github.com/2020-01-est-19/proyecto

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	libcurl4-gnutls-dev \
	libssl-dev \
	libxml2-dev \
	pandoc \
	r-base

RUN Rscript -e "install.packages(c(\"rmarkdown\", \"tidyverse\", \"berryFunctions\", \"wordcloud\", \"tm\"))"

WORKDIR /root

ENTRYPOINT [ "/bin/bash" ]
