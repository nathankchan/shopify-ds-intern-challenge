# File name: 00_init.R
# Path: './scripts/00_init.R'

# Author: N. Chan
# Purpose: Initializes project and installs required dependencies.

source(paste0(getwd(), "/R/functions.R"))

required_packages <-
  c("tidyverse",
    "readxl")

# Check, install, and load required packages
using(required_packages)
