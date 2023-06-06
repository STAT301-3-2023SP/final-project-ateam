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

# split the training data in half
split_train <- initial_split(cars_train, prop = 0.5)

# extract the first half of the training data
cars_train_1 <- training(split_train)

# extract the second half of the training data
cars_train_2 <- testing(split_train)


# test for balance
ggplot(cars_train, mapping = aes(x = is_exchangeable)) +
  geom_bar()

# create recipe ----
## recipe with only related predictors
rec_rel <- recipe(is_exchangeable ~ odometer_value + year_produced + engine_capacity +
                    price_usd + number_of_photos + engine_has_gas + has_warranty +
                    state + drivetrain + location_region + manufacturer_name, 
                  data = cars_train_2) %>% 
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
cars_fold <- vfold_cv(cars_train_2, v = 5, repeats = 3,
                      strata = is_exchangeable)

# save setup
save(rec_rel, cars_fold, cars_test, cars_train_2,
     file = "results/rec_2_setup.rda")

