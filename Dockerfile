FROM oblique/archlinux-yay

RUN sed -i 's/tar\.xz/tar.zst/' /etc/makepkg.conf

RUN echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf

RUN sudo -u aur yay -Syu inkscape r pandoc --noconfirm

RUN echo "local({" >> ~/.Rprofile
RUN echo "r <- getOption(\"repos\")" >> ~/.Rprofile
RUN echo "r[\"CRAN\"] <- \"https://cloud.r-proyect.org/\"" >> ~/.Rprofile
RUN echo "options(repos = r)" >> ~/.Rprofile
RUN echo "})" >> ~/.Rprofile

RUN mkdir ~/.R

RUN echo "MAKEFLAGS = -j2" >> ~/.R/Makevars
RUN echo "CXXFLAGS = -O3 -pipe -fno-plt -flto -fno-fat-lto-objects" >> ~/.R/Makevars
RUN echo "CFLAGS = -O3 -pipe -fno-plt -flto -fno-fat-lto-objects" >> ~/.R/Makevars

# https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file
RUN R -e "install.packages('rmarkdown', dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN R -e "install.packages('tidyverse', dependencies=TRUE, repos='http://cran.rstudio.com/')"
