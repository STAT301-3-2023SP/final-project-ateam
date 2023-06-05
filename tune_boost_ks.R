
library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_setup.rda")


# create models ----
## boosted tree model ----
boost_mod <- boost_tree(mode = "classification",
                        mtry = tune(),
                        min_n = tune(),
                        learn_rate = tune()) %>% 
  set_engine("xgboost", importance = "impurity")


# create grids and parameters ----
## boosted tree model ----
boost_params <- extract_parameter_set_dials(boost_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

boost_grid <- grid_regular(boost_params, levels = 5)


# create workflow ----
## boosted tree model relation recipe ----
boost_workflow_ks <- workflow() %>% 
  add_model(boost_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("Boosted Tree: KS Recipe")


boost_tune_ks <- tune_grid(
  boost_workflow_ks,
  resamples = cars_fold,
  grid = boost_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

boost_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                           runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(boost_tune_ks, boost_tictoc_ks,
     file = "results/tuning_boost_ks.rda")