# File name: 01_loaddata.R
# Path: './scripts/01_loaddata.R'

# Author: N. Chan
# Purpose: Loads the 2019 Winter Data Science Intern Challenge Data Set

source(paste0(getwd(), "/scripts/00_init.R"))

shopifydata <-
  read_excel(
    paste0(
      getwd(),
      "/data/raw_data/2019 Winter Data Science Intern Challenge Data Set.xlsx"
    )
  )

message("./scripts/01_loaddata.R was executed.")
