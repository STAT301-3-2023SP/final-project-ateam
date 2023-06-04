# Load package(s)
library(tidymodels)
library(tidyverse)
library(vip)

# handle common conflicts
tidymodels_prefer()

# Seed
set.seed(1234)

# load in data
cars <- read_rds(file = "data/processed/cars_clean.rds")

# split data
cars_split <- initial_split(cars, 
                            strata = is_exchangeable, 
                            prop = 0.7)

cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# load rf tuning and recipe
load(file = "results/tuning_rf_ks.rda")
load("results/rec_ks_setup.rda")

# finalize workflow
rf_mod <- rand_forest(mode = "classification",
                      min_n = tune(),
                      mtry = tune()) %>% 
  set_engine("ranger", importance = "impurity")

rf_workflow <- workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(rec_ks)

rf_workflow_final <- rf_workflow %>%
  finalize_workflow(select_best(rf_tune_ks, metric = "roc_auc"))

rf_fit <- fit(rf_workflow_final, data = cars_train)

rf_vars <- rf_fit %>%
  extract_fit_parsnip() %>%
  vip::vi()

rf_vars <- rf_vars %>%
  filter(Importance != 0)

save(rf_vars, file = "results/rf_vars.rda")
