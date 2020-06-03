FROM oblique/archlinux-yay

RUN sed -i 's/tar\.xz/tar.zst/' /etc/makepkg.conf

RUN echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf

RUN sudo -u aur yay -Syu --noconfirm

RUN echo 'local({\n\
  r <- getOption("repos")\n\
  r["CRAN"] <- "https://cloud.r-proyect.org/"\n'\
  options(repos = r)\n'\
>> ~/.Rprofile

RUN mkdir ~/.R

RUN echo 'MAKEFLAGS = -j2\n\
CXXFLAGS = -O3 -pipe -fno-plt -flto -fno-fat-lto-objects\n\
CFLAGS = -O3 -pipe -fno-plt -flto -fno-fat-lto-objects\n'\
>> ~/.R/Makevars

RUN Rscript -e 'install.packages("rmarkdown")'

RUN Rscript -e 'install.packages("tidyverse")'
