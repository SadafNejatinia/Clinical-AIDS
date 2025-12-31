# Clinical AIDS Dashboard (Shiny App)

This project is an interactive **Shiny dashboard** built using a real **clinical dataset** provided in R.  
The application explores AIDS diagnosis data in Australia with a focus on **region**, **category**, and **time trends**.

---

## Dataset

- **Name:** Aids2  
- **Source:** `MASS` package (CRAN)  
- **Description:**  
  Clinical records of AIDS diagnoses in Australia, including diagnosis date, patient sex, and state of residence.

This dataset is:
- Fully **clinical**
- Included directly in R (no external downloads)
- Widely used for teaching epidemiology and biostatistics

---

## Project Requirements (Satisfied)

- **Clinical dataset:** ✅  
- **Region:** Australian states (`state`)  
- **Category:** Sex (`Male` / `Female`)  
- **Time-series:** Year of diagnosis  
- **Visualizations:**
  - Time-series line chart
  - Bar chart
  - Heatmap
- **Filters:** Category + Region (+ time)

---

## Application Features

### Filters
- Sex (category)
- State (region)
- Year range (time)

### Visualizations
- **Time-series plot:** Number of AIDS diagnoses per year  
- **Bar chart:** Total AIDS cases by state  
- **Heatmap:** Distribution of cases by state and sex  

All plots update dynamically based on selected filters.

---

## Requirements

- R (version 4.x recommended)
- The following packages (auto-installed by the app):
  - shiny  
  - ggplot2  
  - dplyr  
  - tidyr  
  - MASS  

No internet connection is required to run the app.

---

## How to Run the App

### Option 1: Using RStudio
1. Open `app.R`
2. Click **Run App**

### Option 2: Using R Console
```r
shiny::runApp()
