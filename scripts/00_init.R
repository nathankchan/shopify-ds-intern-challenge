# File name: 00_init.R
# Path: './scripts/00_init.R'

# Author: N. Chan
# Purpose: Initializes project and installs required dependencies.

# Load up custom functions
source(paste0(getwd(), "/R/functions.R"))
message("./R/functions.R is loaded.")

# List of required packages for analysis
required_packages <-
  c(
    "knitr",
    "kableExtra",
    #"fansi",
    "tidyverse",
    "readxl",
    "plotly",
    "htmlwidgets",
    "shiny")

# Check, install, and load required packages
using(required_packages)

message("./scripts/00_init.R was executed.")
