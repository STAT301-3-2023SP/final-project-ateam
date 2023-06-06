library(tidyverse)
library(tidymodels)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
cars <- read_rds(file = "data/processed/cars_clean.rds")

# split data ----
cars_split <- initial_split(cars, 
                            strata = is_exchangeable, 
                            prop = 0.7)

cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# test for balance
ggplot(cars_train, mapping = aes(x = is_exchangeable)) +
  geom_bar()

# create recipe ----
## recipe with only related predictors
rec_rel <- recipe(is_exchangeable ~ odometer_value + year_produced + engine_capacity +
                    price_usd + number_of_photos + engine_has_gas + has_warranty +
                    state + drivetrain + location_region + manufacturer_name, 
                  data = cars_train) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_rel %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

# create folds ----
cars_fold <- vfold_cv(cars_train, v = 5, repeats = 10,
                      strata = is_exchangeable)

# save setup
save(rec_rel, cars_fold, cars_test, cars_train,
     file = "results/rec_2_setup.rda")

