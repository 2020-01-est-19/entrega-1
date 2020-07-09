FROM ubuntu

RUN apt-get update && \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	libcurl4-gnutls-dev \
	libssl-dev \
	libxml2-dev \
	pandoc \
	r-base

RUN Rscript -e "install.packages(c(\"rmarkdown\",\"tidyverse\", \"berryFunctions\"))"

WORKDIR /root

ENTRYPOINT [ "/bin/bash" ]
