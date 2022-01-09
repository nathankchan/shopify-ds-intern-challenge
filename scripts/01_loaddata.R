# File name: 01_loaddata.R
# Path: './scripts/01_loaddata.R'

# Author: N. Chan
# Purpose: Loads the 2019 Winter Data Science Intern Challenge Data Set

# Load and install missing packages
source(paste0(getwd(), "/scripts/00_init.R"))

# Read in data
if (exists("xlsxfile")) {
  datafile <- xlsxfile
  message(paste0("Using user-provided xlsxfile: ", datafile))
} else {
  datafile <- paste0(
    getwd(),
    "/data/raw_data/2019 Winter Data Science Intern Challenge Data Set.xlsx"
    )
  message(paste0("Using default xlsxfile: ", datafile))
}

shopifydata <- read_excel(datafile)

message("./scripts/01_loaddata.R was executed.")
