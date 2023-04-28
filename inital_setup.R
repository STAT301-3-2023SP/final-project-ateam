
library(tidyverse)
library(tidymodels)

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


# create folds ----
cars_fold <- vfold_cv(cars_train, v = 10, repeats = 5,
                       strata = is_exchangeable)

# create models ----
## null model ----
null_mod <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("classification")

## random forest model ----
rf_mod <- rand_forest(mode = "classification",
                      min_n = tune(),
                      mtry = tune()) %>% 
  set_engine("ranger")

## logistic regression model ----
log_reg_mod <- logistic_reg(mode = "classification",
                            mixture = tune(),
                            penalty = tune()) %>% 
  set_engine("glmnet")

## boosted tree model ----
bt_mod <- boost_tree(mode = "classification",
                     mtry = tune(),
                     min_n = tune(),
                     learn_rate = tune()) %>% 
  set_engine("xgboost")

## k nearest neighbors model ----
knn_mod <- nearest_neighbor(mode = "classification",
                            neighbors = tune()) %>% 
  set_engine("kknn")

## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")

# create grids and parameters ----
## random forest model ----
rf_params <- parameters(rf_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

rf_grid <- grid_regular(rf_params, levels = 5)

## logistic regression model ----
log_reg_params <- parameters(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)

## boosted tree model ----
bt_params <- parameters(bt_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

bt_grid <- grid_regular(bt_params, levels = 5)

# k nearest neighbors model ----
knn_params <- parameters(knn_mod)

knn_grid <- grid_regular(knn_params, levels = 5)

## elastic net model ----
en_params <- parameters(en_mod)

en_grid <- grid_regular(en_params, levels = 5)

# create workflow ----

# save workflows and grids ----
