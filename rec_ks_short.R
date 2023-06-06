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

cars_train_2 <- slice_sample(cars_train, prop = 0.15)

# test for balance
ggplot(cars_train, mapping = aes(x = is_exchangeable)) +
  geom_bar()

# create recipes ----
## kitchen sink
rec_ks <- recipe(is_exchangeable ~ ., data = cars_train_2) %>% 
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
cars_fold <- vfold_cv(cars_train, v = 5, repeats = 3,
                      strata = is_exchangeable)

# save setup
save(rec_ks, cars_fold, cars_test, cars_train_2,
     file = "results/rec_ks_short_setup.rda")
