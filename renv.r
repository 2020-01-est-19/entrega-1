#!/usr/bin/env Rscript

library(renv)

renv::consent(TRUE)
renv::init()

renv::install("rmarkdown")
renv::install("tidyverse")

renv::snapshot()
