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

# create recipe ----
## rf variable selection
rec_imp <- recipe(is_exchangeable ~ up_counter + duration_listed + odometer_value +
                    number_of_photos + price_usd + car_id + year_produced +
                    engine_capacity + state + has_warranty + location_region +
                    color + body_type + drivetrain + manufacturer_name +
                    engine_type + engine_has_gas, 
                  data = cars_train) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_imp %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

# create folds ----
cars_fold <- vfold_cv(cars_train, v = 5, repeats = 3,
                      strata = is_exchangeable)

# save setup
save(rec_imp, cars_fold, cars_test, cars_train,
     file = "results/rec_imp_setup.rda")
