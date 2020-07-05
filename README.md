[![R CI](https://github.com/2020-01-est-19/proyecto/workflows/R%20CI/badge.svg)](https://github.com/2020-01-est-19/proyecto/actions?query=workflow%3A%22R+CI%22)
[![Ppt](https://img.shields.io/badge/Ioslides-Ppt-informational?logo=R)](https://2020-01-est-19.github.io/proyecto/pres.html)

# Proyecto

https://2020-01-est-19.github.io/proyecto/

https://2020-01-est-19.github.io/proyecto/pres.html

## Build (Ubuntu >= 20.04)

### Dependencias

- `r-base`
- `pandoc`
- `libcurl4-gnutls-dev`

### Make
``` bash
$ sudo apt install r-base pandoc libcurll4-gnutls-dev
$ R
> if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
> renv::consent(TRUE)
> renv::restore()
> q()

$ make -j$(nproc)
$ make install DESTDIR=dest/
```
