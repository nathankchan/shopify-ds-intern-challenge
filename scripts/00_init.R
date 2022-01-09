# File name: 00_init.R
# Path: './scripts/00_init.R'

# Author: N. Chan
# Purpose: Initializes project and installs required dependencies.

source(paste0(getwd(), "/R/functions.R"))
message("./R/functions.R is loaded.")

required_packages <-
  c(
    "knitr",
    "kableExtra",
    #"fansi",
    "tidyverse",
    "readxl",
    "plotly")

# Check, install, and load required packages
using(required_packages)

message("./scripts/00_init.R was executed.")
