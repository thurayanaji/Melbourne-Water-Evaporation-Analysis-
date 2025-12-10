
# Melbourne Evaporation Case Study - R Code 
# Load packages 
library(tidyverse) 
# 1. Data import and preparation 
# Read data 
melb <- read_csv("melbourne.csv") 
# Clean and transform variables 
melb <- melb %>% 
  mutate( 
    # Parse date 
    Date  = as.Date(Date), 
    # Derive Month and Day as ordered factors 
    Month = factor( 
      month.name[as.integer(format(Date, "%m"))], 
      levels = month.name 
    ), 
    Day   = factor( 
      weekdays(Date), 
      levels = c("Monday","Tuesday","Wednesday","Thursday", 
                 "Friday","Saturday","Sunday") 
    ) 
  ) %>% 
 
  # Rename key variables for convenience 
  rename( 
    evap    = `Evaporation (mm)`, 
    mintemp = `Minimum temperature (Deg C)`, 
    maxtemp = `Maximum Temperature (Deg C)`, 
    rh9     = `9am relative humidity (%)` 
  ) 
 
# Remove rows with missing evaporation 
melb <- melb %>% filter(!is.na(evap)) 
 
 
 
 
# 2. Bivariate summaries 
 
# Evaporation vs Month (boxplot) 
ggplot(melb, aes(x = Month, y = evap)) + 
  geom_boxplot() + 
  labs( 
    title = "Daily evaporation by month", 
    x = "Month", 
    y = "Evaporation (mm)" 
  ) 
 
# Evaporation vs Day of week (boxplot) 
ggplot(melb, aes(x = Day, y = evap)) + 
  geom_boxplot() + 
  labs( 
    title = "Daily evaporation by day of week", 
    x = "Day of week", 
    y = "Evaporation (mm)" 
  ) 
 
# Evaporation vs minimum temperature (scatter with smooth) 
ggplot(melb, aes(x = mintemp, y = evap)) + 
  geom_point(alpha = 0.6) + 
  geom_smooth(method = "lm", se = FALSE) + 
  labs( 
    title = "Evaporation vs minimum temperature", 
    x = "Minimum temperature (°C)", 
    y = "Evaporation (mm)" 
  ) 
 
# Evaporation vs maximum temperature (scatter with smooth) 
ggplot(melb, aes(x = maxtemp, y = evap)) + 
  geom_point(alpha = 0.6) + 
  geom_smooth(method = "lm", se = FALSE) + 
  labs( 
    title = "Evaporation vs maximum temperature", 
    x = "Maximum temperature (°C)", 
    y = "Evaporation (mm)" 
  ) 
 
# Evaporation vs 9am relative humidity (scatter with smooth) 
ggplot(melb, aes(x = rh9, y = evap)) + 
  geom_point(alpha = 0.6) + 
  geom_smooth(method = "lm", se = FALSE) + 
  labs( 
    title = "Evaporation vs 9am relative humidity", 
    x = "9am relative humidity (%)", 
    y = "Evaporation (mm)" 
  ) 
 
# 3. Model building and selection 
 
# FULL model including ALL predictors and the interaction 
mod0 <- lm(evap ~ Month + Day + mintemp + maxtemp + rh9 + Month:rh9, 
           data = melb) 
 
# Look at the output to see p-values of numeric predictors 
summary(mod0) 
 
 
#Test whether 'Day of the week' is significant 
# Model without Day (for comparison) 
mod_no_day <- lm(evap ~ Month + mintemp + maxtemp + rh9 + Month:rh9, 
                 data = melb) 
 
# F-test comparing mod_no_day vs full model 
anova(mod_no_day, mod0)   # If p > 0.05, Day is NOT significant 
 
 
# Since Day is not significant, we drop it and continue from mod_no_day 
mod1 <- mod_no_day 
 
#Test if the Month × humidity interaction is significant 
# Model without interaction 
mod_no_int <- lm(evap ~ Month + mintemp + maxtemp + rh9, data = melb) 
 
# Compare models: If p < 0.05, interaction is significant and must stay 
anova(mod_no_int, mod1)    
 
 
 
# Test maximum temperature 
# Model without maximum temperature 
mod_no_max <- lm(evap ~ Month + mintemp + rh9 + Month:rh9, 
                 data = melb) 
 
# Compare models: If p > 0.05, maxtemp is NOT significant and can be 
removed 
anova(mod_no_max, mod1)    
 
 
 
# FINAL model after removing Day and maxtemp 
mod_final <- mod_no_max 
summary(mod_final) 
 
 
 
# 4. Model diagnostics 
 
# Standard diagnostic plots 
par(mfrow = c(2, 2)) 
plot(mod_final) 
par(mfrow = c(1, 1)) 
 
 
 
# 5. Predictions for specified days 
 
# Construct new data for prediction 
new_days <- tibble( 
  Date    = as.Date(c("2020-02-29", 
                      "2020-12-25", 
                      "2020-01-13", 
                      "2020-07-06")), 
  mintemp = c(13.8, 16.4, 26.5, 6.8), 
  maxtemp = c(23.2, 31.9, 44.3, 10.6), 
  rh9     = c(74,   57,   35,   76) 
) %>% 
  mutate( 
    Month = factor( 
      month.name[as.integer(format(Date, "%m"))], 
      levels = month.name 
    ) 
  ) 
 
# Use final model to make predictions with 95% prediction intervals 
predictions <- predict( 
  mod_final, 
  newdata = new_days, 
  interval = "prediction", 
  level = 0.95 
) 
 
# Combine with input data for a nice table 
pred_table <- bind_cols(new_days, as_tibble(predictions)) 
pred_table 
 
# round 
pred_table_rounded <- pred_table %>% 
  mutate(across(c(fit, lwr, upr), ~ round(.x, 2))) 
pred_table_rounded 
# End of R code
