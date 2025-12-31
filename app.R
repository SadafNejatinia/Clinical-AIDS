############################################################
# Shiny App: Clinical AIDS Dashboard (Australia)
#
# Dataset:
# - Aids2 (CRAN package: MASS)
#
# Description:
# - Clinical data on AIDS diagnoses in Australia
# - Includes diagnosis date, sex, and state
#
# Mapping to project requirements:
# - Clinical dataset -> AIDS cases
# - Region           -> Australian state
# - Category         -> Sex
# - Time-series      -> Year of diagnosis
#
# This version fixes all previous errors
############################################################

# ---------------------------
# 1) Auto-install & load required packages
# ---------------------------
required_pkgs <- c(
  "shiny",
  "ggplot2",
  "dplyr",
  "tidyr",
  "MASS"
)

missing_pkgs <- required_pkgs[!required_pkgs %in% rownames(installed.packages())]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs, dependencies = TRUE)
}

invisible(lapply(required_pkgs, library, character.only = TRUE))

# ---------------------------
# 2) Load clinical dataset (built-in)
# ---------------------------
data("Aids2", package = "MASS")

df_raw <- Aids2

# ---------------------------
# 3) Prepare clean dataset (SAFE VERSION)
# ---------------------------
df <- df_raw %>%
  transmute(
    # SAFE extraction of year from Date
    year   = as.integer(format(as.Date(diag), "%Y")),
    region = factor(state),
    sex    = factor(sex)
  ) %>%
  drop_na()

# ---------------------------
# 4) User Interface (UI)
# ---------------------------
ui <- fluidPage(
  titlePanel("Clinical Dashboard: AIDS Cases in Australia"),
  
  sidebarLayout(
    sidebarPanel(
      # CATEGORY filter
      selectInput(
        "sex",
        "Sex (category)",
        choices = c("All", levels(df$sex)),
        selected = "All"
      ),
      
      # REGION filter
      selectInput(
        "region",
        "State (region)",
        choices = c("All", levels(df$region)),
        selected = "All"
      ),
      
      # TIME filter
      sliderInput(
        "year",
        "Year of diagnosis",
        min = min(df$year),
        max = max(df$year),
        value = c(min(df$year), max(df$year)),
        step = 1
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Time-series", plotOutput("timePlot", height = 320)),
        tabPanel("Bar chart", plotOutput("barPlot", height = 320)),
        tabPanel("Heatmap", plotOutput("heatPlot", height = 360))
      )
    )
  )
)

# ---------------------------
# 5) Server logic
# ---------------------------
server <- function(input, output) {
  
  # ---- Apply filters ----
  filtered_data <- reactive({
    d <- df %>%
      filter(year >= input$year[1], year <= input$year[2])
    
    if (input$sex    != "All") d <- d %>% filter(sex == input$sex)
    if (input$region != "All") d <- d %>% filter(region == input$region)
    
    d
  })
  
  # ---- Helper for empty plots ----
  empty_plot <- function(msg = "No data for selected filters") {
    plot.new()
    text(0.5, 0.5, msg, cex = 1.1)
  }
  
  # ---------------------------
  # Plot 1: Time-series
  # ---------------------------
  output$timePlot <- renderPlot({
    d <- filtered_data()
    if (nrow(d) == 0) return(empty_plot())
    
    d %>%
      count(year) %>%
      ggplot(aes(year, n)) +
      geom_line() +
      geom_point() +
      theme_minimal() +
      labs(
        x = "Year",
        y = "Number of cases",
        title = "AIDS diagnoses over time"
      )
  })
  
  # ---------------------------
  # Plot 2: Bar chart
  # ---------------------------
  output$barPlot <- renderPlot({
    d <- filtered_data()
    if (nrow(d) == 0) return(empty_plot())
    
    d %>%
      count(region) %>%
      ggplot(aes(region, n)) +
      geom_col() +
      theme_minimal() +
      labs(
        x = "State",
        y = "Number of cases",
        title = "AIDS cases by state"
      )
  })
  
  # ---------------------------
  # Plot 3: Heatmap
  # ---------------------------
  output$heatPlot <- renderPlot({
    d <- filtered_data()
    if (nrow(d) == 0) return(empty_plot())
    
    d %>%
      count(region, sex) %>%
      ggplot(aes(sex, region, fill = n)) +
      geom_tile() +
      theme_minimal() +
      labs(
        x = "Sex",
        y = "State",
        title = "Heatmap of AIDS cases"
      )
  })
}

# ---------------------------
# 6) Run the app
# ---------------------------
shinyApp(ui, server)