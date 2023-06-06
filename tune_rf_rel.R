## rec 2
library(textrecipes)
library(tictoc)
library(tidyverse)
library(tidymodels)
library(doMC)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")


# create models ----
## random forest model ----
rf_mod <- rand_forest(mode = "classification",
                      min_n = tune(),
                      mtry = tune()) %>% 
  set_engine("ranger", importance = "impurity")


# create grids and parameters ----
## random forest model ----
rf_params <- extract_parameter_set_dials(rf_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

rf_grid <- grid_regular(rf_params, levels = 5)


# create workflow ----
## random forest model ----
rf_workflow_rel <- workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(rec_rel)

# tuning/fitting ----
tic.clearlog()
tic("Random Forest: Rel Recipe")


rf_tune_rel <- tune_grid(
  rf_workflow_rel,
  resamples = cars_fold,
  grid = rf_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

rf_tictoc_rel <- tibble(model = time_log[[1]]$msg,
                       runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(rf_tune_rel, rf_tictoc_rel,
     file = "results/tuning_rf_rel.rda")

