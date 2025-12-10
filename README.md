Evaporation Forecasting at Cardinia Reservoir
Statistical Modelling Project in R
1. Project Overview

This project investigates how daily evaporation at Cardinia Reservoir varies with weather and seasonal factors. Using one year of Melbourne meteorological data, I built and validated a multiple linear regression model to support Melbourne Water’s operational planning.

Completed as part of my Postgraduate Certificate in Applied Data Science.


2. Objectives

Identify key drivers of daily evaporation

Explore seasonal and meteorological patterns

Build a regression model with interactions

Validate assumptions through diagnostic plots

Produce predictions and 95% prediction intervals for specific dates.


3. Data Summary

Daily weather observations including:

evap (mm)

mintemp, maxtemp (°C)

rh9 (9am relative humidity %)

Month, Day (derived from Date)

Cleaning steps included removing missing rows, converting factors, renaming columns, and preparing variables for modelling.


4. Methods
Exploratory Analysis

Boxplots: evaporation by Month (clear seasonal pattern)

Scatterplots:

mintemp ↑ → evap ↑

rh9 ↑ → evap ↓

Day of week showed no meaningful pattern

Model Building

Started with a full model:

evap ~ Month + Day + mintemp + maxtemp + rh9 + Month:rh9


Used backward elimination (F-tests).
Final model retained:

Month

mintemp

rh9

Month × rh9 interaction

Model Performance

R² ≈ 0.64

Mild skewness but diagnostics acceptable

No major violations of linear regression assumptions.


5. Key Findings

Higher minimum temperature increases evaporation

Higher humidity reduces evaporation

Humidity effects vary by month (interaction)

Maximum temperature and weekday were not useful predictors

Summer (Jan–Mar) consistently shows the highest evaporation.


6. Predictions

Generated 95% prediction intervals for specific dates.
Example:

13 Jan 2020: Predicted ≈ 14.9 mm

95% PI: 10.1 – 19.6 mm

Interpretation: Very likely to exceed the 10 mm threshold → operational action recommended.


7. Tools & Packages

R, RStudio

tidyverse, ggplot2, dplyr

Base R modelling functions


8. Repository Structure
/scripts        R scripts for cleaning, EDA, modelling
/plots          Figures (optional)
/report.pdf     Full detailed analysis
README.md       Project summary


9. How to Run This Project

Install required R packages (tidyverse).

Load the dataset (melbourne.csv).

Run scripts in order: cleaning → EDA → modelling → predictions.

View report.pdf for full results and interpretation.
