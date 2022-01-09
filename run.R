# File name: run.R
# Path: './run.R'

# Author: N. Chan
# Purpose: Command line option to run all scripts and analyses
# Usage: Rscript run.R [xlsxfile voi binsize]

# Takes three optional arguments: (1) path to excel file, (2) name of a numeric 
# variable of interest, and (3) size of histogram bins. If using optional 
# arguments, all three must be defined.

# Returns a histogram-density plot of the data depicting several key metrics,
# as well as a csv file containing the names and values of the key metrics.
# Files are saved in "shopify-ds-intern-challenge/output".

# Optional arguments:
#   xlsxfile voi binsize
#       xlsxfile is the path to the excel file.
#       voi is the name of the numeric variable of interest as written in row 1 
#         of the respective column in the excel file.
#       binsize is the size of each bin in the histogram.
#       All three arguments must be defined if using.

cmdargs <- commandArgs(trailingOnly = TRUE)

if(length(cmdargs) == 0) {
  message("No arguments provided. Using defaults.")
} else if (length(cmdargs) > 3 | length(cmdargs) %in% c(1,2)) {
  message("Invalid number of optional arguments provided. Using defaults.")
} else {
  xlsxfile <- cmdargs[1]
  voi <- cmdargs[2]
  binsize <- cmdargs[3]
}

source(paste0(getwd(), "/scripts/02_analyze.R"))
cat(paste0("The geometric mean of ", voi_char, " is ", geo_mean(var_interest), ".\n"))
message("run.R has completed.")
