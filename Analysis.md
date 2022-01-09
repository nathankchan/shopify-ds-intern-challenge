<!-- **Recommended: For HTML document, hide code snippets by choosing the respective option in top right drop-down menu for improved readability.** -->

<br>

#### **Table of Contents**

1.  [Question 1: Analysis of sneaker shop AOV](#s1)
    1.  [Better ways to evaluate data](#s1.1)
    2.  [Best metric to report](#s1.2)
    3.  [Value of reported metric](#s1.3)
2.  [Question 2: SQL for Northwind sample database](#s2)
    1.  [Response 2.a](#s2.1)
    2.  [Response 2.b](#s2.2)
    3.  [Response 2.c](#s2.3)
3.  [Appendix](#s3)
    1.  [functions.R](#s3.1)
    2.  [00_init.R](#s3.2)
    3.  [01_loaddata.R](#s3.3)

<br>

------------------------------------------------------------------------

## Question 1: Analysis of sneaker shop AOV

#### Prompt

*Given some sample data, write a program to answer the following: [click
here to access the required data
set](https://docs.google.com/spreadsheets/d/16i38oonuX1y1g7C_UAmiK9GkY7cS-64DfiDMNiR41LM/edit#gid=0)*

<ul>
<li style="list-style-type: none;">
*On Shopify, we have exactly 100 sneaker shops, and each of these shops
sells only one model of shoe. We want to do some analysis of the average
order value (AOV). When we look at orders data over a 30 day window, we
naively calculate an AOV of $3145.13. Given that we know these shops are
selling sneakers, a relatively affordable item, something seems wrong
with our analysis.*
</li>
<li style="list-style-type: none;">
<br>
</li>
<ol>
<li style="list-style-type: lower-alpha;">
*Think about what could be going wrong with our calculation. Think about
a better way to evaluate this data.*
</li>
<li style="list-style-type: lower-alpha;">
*What metric would you report for this dataset?*
</li>
<li style="list-style-type: lower-alpha;">
*What is its value?*
</li>
</ol>
</ul>

------------------------------------------------------------------------

#### Getting Started

This analysis requires **R** to be installed. If it is not installed,
please visit [r-project.org](https://www.r-project.org/) to download the
latest version.

This analysis requires the *tidyverse* **R** package. If *tidyverse* is
not installed, this analysis will ask for your permission to install
*tidyverse*.

To ensure this analysis is reproducible, a series of scripts (see
[Appendix](#s3)) are run to initialize the environment and load the
`2019 Winter Data Science Intern Challenge Data Set.xlsx` excel file
into R.

``` r
# NB: If any required packages are missing and you are running this code block
# within an R Notebook, it will fail to execute properly. This behaviour is
# intentional and acts as a safety mechanism to ensure the user provides
# explicit consent before installing packages. If this occurs and you wish to
# install the packages, copy the code below into your terminal or console, then
# continue with the rest of this document.

source(paste0(getwd(), "/scripts/01_loaddata.R"))
## ./R/functions.R is loaded.
## Loading required package: knitr
## Loading required package: fansi
## Loading required package: tidyverse
## ── [1mAttaching packages[22m ─────────────────────────────────────── tidyverse 1.3.0 ──
## [32m✓[39m [34mggplot2[39m 3.3.2     [32m✓[39m [34mpurrr  [39m 0.3.4
## [32m✓[39m [34mtibble [39m 3.0.4     [32m✓[39m [34mdplyr  [39m 1.0.2
## [32m✓[39m [34mtidyr  [39m 1.1.2     [32m✓[39m [34mstringr[39m 1.4.0
## [32m✓[39m [34mreadr  [39m 1.4.0     [32m✓[39m [34mforcats[39m 0.5.0
## ── [1mConflicts[22m ────────────────────────────────────────── tidyverse_conflicts() ──
## [31mx[39m [34mdplyr[39m::[32mfilter()[39m masks [34mstats[39m::filter()
## [31mx[39m [34mdplyr[39m::[32mlag()[39m    masks [34mstats[39m::lag()
## Loading required package: readxl
## ./scripts/00_init.R was executed.
## ./scripts/01_loaddata.R was executed.
```

------------------------------------------------------------------------

### 1.a. Better ways to evaluate data

asdfasdf more words….
