# Loading packages
library(tidyverse)
library(janitor)
library(naniar)

cars <- read_csv("data/raw/cars.csv") %>% 
  clean_names() %>% 
  # remove columns we don't have information on
  select(- contains("feature")) %>% 
  # remove repeated column
  select(-"engine_fuel") %>% 
  mutate(car_id = row_number(), .before = manufacturer_name) %>% 
  mutate(transmission = factor(transmission),
         engine_type = factor(engine_type),
         engine_has_gas = factor(engine_has_gas),
         has_warranty = factor(has_warranty),
         state = factor(state),
         drivetrain = factor(drivetrain),
         is_exchangeable = factor(is_exchangeable),
         year_produced = as.Date(year_produced))

# minimal missingness so don't have to remove any columns
miss_var_summary(cars)

# save cleaned dataset
write_rds(cars, file = "data/processed/cars_clean.rds")
