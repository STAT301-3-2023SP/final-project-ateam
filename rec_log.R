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

## ks with log and square root transformations
rec_log_sqrt <- recipe(is_exchangeable ~ ., data = cars_train) %>%
  step_rm(up_counter) %>% 
  step_clean_levels(all_nominal_predictors()) %>% 
  step_log(engine_capacity, price_usd, duration_listed) %>% 
  step_sqrt(odometer_value, number_of_photos) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_log_sqrt %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

# create folds ----
cars_fold <- vfold_cv(cars_train, v = 10, repeats = 5,
                      strata = is_exchangeable)

# save setup
save(rec_log_sqrt, cars_fold, cars_test, cars_train,
     file = "results/rec_3_setup.rda")

