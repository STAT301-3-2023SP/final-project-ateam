library(tidyverse)
library(tidymodels)
library(textrecipes)

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

# create recipes ----
## kitchen sink
rec_ks <- recipe(is_exchangeable ~ ., data = cars_train) %>% 
  step_other(model_name) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_ks %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

# create folds ----
cars_fold <- vfold_cv(cars_train, v = 10, repeats = 5,
                       strata = is_exchangeable)

# save setup
save(rec_ks, cars_fold, cars_test, cars_train,
     file = "results/rec_1_setup.rda")

# do we need to update our recipe for any of these models ?
