#!/usr/bin/env Rscript

if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")

renv::consent(TRUE)
renv::init()

renv::install("rmarkdown")
renv::install("tidyverse")

renv::snapshot()
