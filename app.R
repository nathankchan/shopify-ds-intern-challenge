# File name: app.R
# Path: './app.R'

# Author: N. Chan
# Purpose: Runs a Shiny R app to interactively view a histogram from input data

source(paste0(getwd(), "/scripts/01_loaddata.R"))

# Define UI

ui <- fluidPage(
  
  titlePanel("Histogram-Density Plot Viewer"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select your file and specify the settings below."),
      fileInput(inputId = "xlsxfile", "Select Excel File", accept = ".xlsx", multiple = FALSE),
      selectInput("selectedcolumn", "Choose Column (must be numeric)", choices = c("")),
      br(),
      textOutput("displaymax"),
      tags$head(tags$style("#displaymax{color: blue; font-style: bold;}")),
      textOutput("displaymin"),
      tags$head(tags$style("#displaymin{color: blue; font-style: bold;}")),
      textOutput("displayrechist"),
      tags$head(tags$style("#displayrechist{color: blue; font-style: bold;}")),
      br(),
      helpText("Specify plot limits."),
      numericInput("selectedmax", "X-axis Maximum", value = 1),
      numericInput("selectedmin", "X-axis Minimum", value = 0),
      br(),
      helpText("Specify a histogram bin size between the minimum and maximum of the column specified."),
      numericInput("selectedbinsize", "Histogram Bin Size", value = 1),
      helpText("Specify a density plot scale factor between the minimum and maximum of the column specified. It is recommended to start with the same value as the recommended histogram bin size above and adjust from there."),
      numericInput("selecteddensize", "Density Plot Scale Factor", value = 1)
      # sliderInput("selectedbinsize", "Specify Histogram Bin Size", min = 0, max = 10, value = 5, step = 1),
      # sliderInput("selecteddensize", "Specify Density Plot Scale Factor", min = 0, max = 10, value = 5, step = 1),
      # sliderInput("selectedmax", "Specify X-axis Maximum", min = 0, max = 10, value = 5, step = 1),
      # sliderInput("selectedmin", "Specify X-axis Minimum", min = 0, max = 10, value = 5, step = 1)
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Data",
          dataTableOutput(outputId = "displaydataTable")
        ),
        tabPanel(
          title = "Metrics",
          dataTableOutput(outputId = "displaymetrics")
        ),
        tabPanel(
          title = "Plot",
          plotlyOutput(outputId = "displayplot",
                       width = "100%",
                       height = "100%")
        )
    ))
    
  )
  
  
)


server <- function(input, output, session) {
  
  xlsxdata <- reactive({
    req(input$xlsxfile)
    read_excel(input$xlsxfile$datapath)
  })
  
  output$displaymetrics <- renderDataTable({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata <- xlsxdata()
    summ_stats(xlsxdata[[input$selectedcolumn]])
  })
  
  output$displaydataTable <- renderDataTable({xlsxdata()})
  
  output$displaymax <- renderText({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata <- xlsxdata()
    selectedcolumn <- as.character(input$selectedcolumn)
    maxval <- max(xlsxdata[, selectedcolumn])
    paste0("Maximum: ", maxval)
  })
  
  output$displaymin <- renderText({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata <- xlsxdata()
    selectedcolumn <- as.character(input$selectedcolumn)
    minval <- min(xlsxdata[, selectedcolumn])
    paste0("Minimum: ", minval)
  })
  
  output$displayrechist <- renderText({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata_max <- input$selectedmax
    xlsxdata_min <- input$selectedmin
    xlsxdata_range <- xlsxdata_max - xlsxdata_min
    paste0("Recommended Histogram Bin Size: ", xlsxdata_range * 0.01)
  })
  
  output$displayplot <- renderPlotly({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    req(input$selectedbinsize)
    xlsxdata <- xlsxdata()
    selectedcolumn <- input$selectedcolumn
    summarystats <- summ_stats(xlsxdata[[selectedcolumn]])
    binwidth <- input$selectedbinsize
    binwidth2 <- input$selecteddensize
    xmin <- input$selectedmin
    xmax <- input$selectedmax
    
    p <-
      ggplot(data = xlsxdata, aes_string(x = selectedcolumn)) +
      geom_histogram(
        aes(color = "Histogram"),
        fill = "springgreen4",
        size = 0,
        binwidth = binwidth) +
      geom_density(
        # Density plots are usually constrained within [0,1]. However, ggplot
        # requires that the y-axis of plots have the same scale. This is a
        # workaround to let our density plot display properly.
        aes(y = ..density.. * nrow(xlsxdata) * binwidth2, color = "Density Plot"),
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
        y = "Count"
      ) +
      scale_x_continuous(
        labels = function(x)
          format(x, scientific = FALSE),
        guide = guide_legend(),
        limits = c(xmin, xmax)
      ) +
      scale_color_manual(
        name = "",
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
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p) %>%
      layout(
        legend = list(
          orientation = "h", x = 0.5, y = -0.25, xanchor = "center"))
    
  })
  
  
  observe({
    req(input$xlsxfile)
    xlsxdata <- xlsxdata()
    updateSelectInput(
      session = session,
      inputId = "selectedcolumn",
      choices = colnames(xlsxdata[, sapply(xlsxdata, is.numeric)])
    )
  })
  
  observe({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata <- xlsxdata()
    selectedcolumn <- as.character(input$selectedcolumn)
    xlsxdata_max <- range(xlsxdata[, selectedcolumn])[2]
    xlsxdata_min <- range(xlsxdata[, selectedcolumn])[1]
    xlsxdata_range <- xlsxdata_max - xlsxdata_min
    xlsxdata_rec <- (input$selectedmax - input$selectedmin) * 0.01
    
    updateNumericInput(
      session = session,
      inputId = "selectedbinsize",
      max = xlsxdata_range * 0.1,
      min = xlsxdata_range * 0.001,
      value = xlsxdata_rec,
      step = xlsxdata_range * 0.001
    )
    updateNumericInput(
      session = session,
      inputId = "selecteddensize",
      max = xlsxdata_range * 0.1,
      min = xlsxdata_range * 0.0001,
      value = xlsxdata_rec,
      step = xlsxdata_range * 0.0001
    )
    # updateSliderInput(
    #   session = session,
    #   inputId = "selectedbinsize",
    #   max = xlsxdata_range * 0.1,
    #   min = xlsxdata_range * 0.001,
    #   value = xlsxdata_range * 0.01,
    #   step = xlsxdata_range * 0.001
    # )
    # updateSliderInput(
    #   session = session,
    #   inputId = "selecteddensize",
    #   max = xlsxdata_range * 0.1,
    #   min = xlsxdata_range * 0.0001,
    #   value = xlsxdata_range * 0.01,
    #   step = xlsxdata_range * 0.0001
    # )
  })
  
  observe({
    req(input$xlsxfile)
    req(input$selectedcolumn)
    xlsxdata <- xlsxdata()
    selectedcolumn <- as.character(input$selectedcolumn)
    xlsxdata_max <- range(xlsxdata[, selectedcolumn])[2]
    xlsxdata_min <- range(xlsxdata[, selectedcolumn])[1]
    xlsxdata_range <- xlsxdata_max - xlsxdata_min
    updateNumericInput(
      session = session,
      inputId = "selectedmax",
      max = xlsxdata_max,
      min = xlsxdata_min,
      value = xlsxdata_max,
      step = xlsxdata_range * 0.001
    )
    updateNumericInput(
      session = session,
      inputId = "selectedmin",
      max = xlsxdata_max,
      min = xlsxdata_min,
      value = xlsxdata_min,
      step = xlsxdata_range * 0.001
    )
    # updateSliderInput(
    #   session = session,
    #   inputId = "selectedmax",
    #   max = xlsxdata_max,
    #   min = xlsxdata_min,
    #   value = xlsxdata_max,
    #   step = xlsxdata_range * 0.001
    # )
    # updateSliderInput(
    #   session = session,
    #   inputId = "selectedmin",
    #   max = xlsxdata_max,
    #   min = xlsxdata_min,
    #   value = xlsxdata_min,
    #   step = xlsxdata_range * 0.001
    # )
  })
  
}


shinyApp(ui, server)
