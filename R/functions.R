# File name: functions.R
# Path: './R/functions.R'

# Author: N. Chan
# Purpose: Script for housing custom functions required for project.

# NB: Strictly speaking, this is a project and not a package. That said, using
# the Roxygen2 documentation style for writing functions is helpful for keeping
# information about custom functions organized.


#' @title Check, install, and load required packages
#'
#' @description Automated method for checking, installing, and loading a list
#' of packages provided by the user. Function asks the user before installing.
#'
#' @param ... A list or vector containing the names of packages as strings to
#' be loaded and installed.
#'
#' @return None
#'
#' @examples
#' \dontrun{
#' pkgs <- c("ggplot2", "tidyverse")
#' using(pkgs)
#' }
#'
#' @author N. Chan
#' @export
#'

using <- function(...) {
  libs <- unlist(list(...))
  req <- suppressWarnings(unlist(lapply(libs, require, character.only = TRUE)))
  need <- libs[req == FALSE]
  n <- length(need)
  
  if (n > 0) {
    libsmsg <-
      if (n > 2) {
        paste(paste(need[1:(n - 1)], collapse = ", "), ",", sep = "")
      } else
        need[1]
    
    if (n > 1) {
      libsmsg <- paste(libsmsg, " and ", need[n], sep = "")
    }
    
    libsmsg <-
      paste(
        "The following packages could not be found: ",
        libsmsg,
        "\n\r\n\rInstall missing packages?",
        collapse = ""
      )
    
    if (!(askYesNo(libsmsg, default = FALSE) %in% c(NA, FALSE))) {
      install.packages(need)
      lapply(need, require, character.only = TRUE)
    }
    
  }
  
  return(invisible(NULL))
}


#' @title Compute the statistical mode of an R object
#'
#' @description Computes the statistical mode of an R object.
#'
#' @param x An R object that can be interpreted as factors.
#'
#' @return A table with the name of the most frequent element and its respective
#'   count.
#'
#' @examples
#' \dontrun{
#' mydata <- c(1,1,1,1,2,2,2,3,3)
#' mode_stat(mydata)
#' }
#'
#' @author N. Chan
#' @export
#'

mode_stat <- function(x) {
  freqtable <- table(x)
  return(freqtable[which.max(freqtable)])
}


#' @title Compute the geometric mean of a numeric object
#'
#' @description Computes the statistical mode of an R object.
#'
#' @param x An R object that can be coerced into a numeric vector.
#'
#' @return A double representing the geometric mean.
#'
#' @examples
#' \dontrun{
#' mydata <- c(1,1,1,1,2,2,2,3,3)
#' geo_mean(mydata)
#' }
#'
#' @author N. Chan
#' @export
#'

geo_mean <- function(x) {
  # Taking the mean of the natural log then raising e to the mean is more 
  # computationally efficient than taking the product of all elements of x
  # and taking the n-th root.
  gm <- exp(mean(log(x)))
  return(gm)
}
