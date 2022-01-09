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
    
    # Checks if R is in interactive mode. If yes, then prompt user for
    # interactive response. If no, prompt user for input from stdin.
    if (interactive()) {
      if (!(askYesNo(libsmsg, default = FALSE) %in% c(NA, FALSE))) {
        install.packages(need)
        lapply(need, require, character.only = TRUE)
      } else {
        stop("required packages were not installed or loaded")
      }
      
    } else {
      cat(libsmsg, "(yes/No/cancel) ")
      response <- readLines("stdin", n = 1)
      input <- pmatch(tolower(response), c("yes", "no", "cancel"))
      
      if (!nchar(response) | input %in% c(2, 3)) {
        stop("required packages were not installed or loaded")
      } else if (is.na(input)) {
        stop("Unrecognized response ", dQuote(response))
      } else {
        install.packages(need)
        lapply(need, require, character.only = TRUE)
      }
    }
  
  }
  
  return(invisible(NULL))
}


user_input <- function(prompt) {
  if(interactive()) {
    return(readlin)
  }
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
#' @description Computes the geometric mean of a numeric object.
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


#' @title Compute the harmonic mean of a numeric object
#'
#' @description Computes the harmonic mean of a numeric object.
#'
#' @param x An R object that can be coerced into a numeric vector.
#'
#' @return A double representing the harmonic mean.
#'
#' @examples
#' \dontrun{
#' mydata <- c(1,1,1,1,2,2,2,3,3)
#' har_mean(mydata)
#' }
#'
#' @author N. Chan
#' @export
#'

har_mean <- function(x) {
  hm <- 1/(mean(1/x))
  return(hm)
}

#' @title Provides summary statistics 
#'
#' @description Wrapper for summary(), mode_stat(), geo_mean(), and har_mean()
#'
#' @param x An R object that can be coerced into a numeric vector.
#'
#' @return A data frame containing two columns (name of statistic and value)
#'
#' @examples
#' \dontrun{
#' mydata <- c(1,1,1,1,2,2,2,3,3)
#' summ_stats(mydata)
#' }
#'
#' @author N. Chan
#' @export
#'

summ_stats <- function(x) {
  
  if(!is.numeric(x)) {
    stop("x must be a numeric object.")
  }
  
  summ <- summary(x)
  mo <- as.numeric(names(mode_stat(x)))
  gm <- geo_mean(x)
  hm <- har_mean(x)
  
  out <- data.frame(
    Statistic = c(names(summ), "Mode", "Geometric Mean", "Harmonic Mean"),
    Value = c(as.vector(summ), mo, gm, hm)
  )
  
  out[which(out[,1] == "Min."), 1] <- "Minimum"
  out[which(out[,1] == "1st Qu."), 1] <- "1st Quartile"
  out[which(out[,1] == "Mean"), 1] <- "Arithmetic Mean"
  out[which(out[,1] == "3rd Qu."), 1] <- "3rd Quartile"
  out[which(out[,1] == "Max."), 1] <- "Maximum"
  
  return(out)
}

