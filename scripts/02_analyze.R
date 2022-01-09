# File name: 02_analyze.R
# Path: './scripts/02_analyze.R'

# Author: N. Chan
# Purpose: Performs analysis per questions provided in challenge

# Prompt:
# Question 1: On Shopify, we have exactly 100 sneaker shops, and each of these
# shops sells only one model of shoe. We want to do some analysis of the average
# order value (AOV). When we look at orders data over a 30 day window, we
# naively calculate an AOV of $3145.13. Given that we know these shops are
# selling sneakers, a relatively affordable item, something seems wrong with our
# analysis.
# 
# 1a. Think about what could be going wrong with our calculation. Think about a
# better way to evaluate this data. 
# 1b. What metric would you report for this dataset? 
# 1c. What is its value?


# Load up packages and data required for analysis
source(paste0(getwd(), "/scripts/01_loaddata.R"))
attach(shopifydata)

if (exists("voi")) {
  var_interest <- shopifydata %>% pull(voi)
  voi_char <- as.character(voi)
  message(paste0("Using user-provided variable of interest: ", voi))
} else {
  var_interest <- order_amount
  voi_char <- "order_amount"
  message(paste0("Using default variable of interest: order_amount"))
}

if (!(is.numeric(var_interest))) {
  stop("The variable of interest is not numeric. Only numeric variables are supported.")
}

if (exists("binsize")) {
  binwidth <- as.numeric(binsize)
  binwidth_density <- as.numeric(binsize)
  message(paste0("Using user-provided bin width: ", binsize))
} else {
  binwidth <- 10000
  binwidth_density <- binwidth/100
  message(paste0("Using default bin width: ", binwidth))
}

# Get summary statistics for var_interest
summarystats <- summ_stats(var_interest)

# Produce plot of var_interest
p <-
  ggplot(data = shopifydata, aes(x = var_interest)) +
  geom_histogram(
    aes(color = "Histogram"),
    fill = "springgreen4",
    size = 0,
    binwidth = binwidth) +
  geom_density(
    # Density plots are usually constrained within [0,1]. However, ggplot 
    # requires that the y-axis of plots have the same scale. This is a 
    # workaround to let our density plot display properly.
    aes(y = ..density.. * nrow(shopifydata) * binwidth_density, color = "Density Plot"),
    fill = "springgreen4",
    size = 0,
    alpha = 0.3
  ) +
  geom_vline(
    aes(xintercept = summarystats[which(summarystats == "Arithmetic Mean"), 2], color = "Arithmetic Mean"),
    linetype = "longdash",
    size = 0.25,
  ) +
  geom_vline(
    aes(xintercept = summarystats[which(summarystats == "Median"), 2], color = "Median"),
    linetype = "dotdash",
    size = 0.25,
  ) +
  geom_vline(
    aes(xintercept = summarystats[which(summarystats == "Mode"), 2], color = "Mode"),
    linetype = "dotted",
    size = 0.25,
  ) +
  geom_vline(
    aes(xintercept = summarystats[which(summarystats == "Geometric Mean"), 2], color = "Geometric Mean"),
    linetype = "twodash",
    size = 0.25,
  ) +
  geom_vline(
    aes(xintercept = summarystats[which(summarystats == "Harmonic Mean"), 2], color = "Harmonic Mean"),
    linetype = "dashed",
    size = 0.25,
  ) +
  labs(
    x = "Value",
    y = "Count"
  ) +
  scale_x_continuous(
    labels = function(x)
      format(x, scientific = FALSE),
    guide = guide_legend()
  ) +
  scale_color_manual(
    name = "Key Metrics",
    values = c(
      "Histogram" = "springgreen4",
      "Density Plot" = "springgreen4",
      "Arithmetic Mean" = "red",
      "Median" = "blue",
      "Mode" = "orange",
      "Geometric Mean" = "green",
      "Harmonic Mean" = "grey"
    )
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# plotly does not support subtitles or captions, so we need to manually define
# them with HTML as part of the title
p_out <- 
  ggplotly(p) %>%
  layout(title = list(text = paste0(
    '<span style = "font-size: 15px;">',
    "<b>Histogram of ",
    voi_char,
    "</b>",
    "</span>")))

# Save out the key metrics to csv and plot to HTML file
write.csv(summarystats, 
          file = paste0(
            getwd(),
            "/output/summarystats.csv"))
saveWidget(p_out,
           file = paste0(
             getwd(),
             "/output/plot.html"))
message("./scripts/02_analyze.R was executed.")
message(paste0("Outputs saved to ", getwd(), "/output"))
