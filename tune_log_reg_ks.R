library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_setup.rda")

# create models ----
## logistic regression model ----
log_reg_mod <- logistic_reg(mode = "classification",
                            mixture = tune(),
                            penalty = tune()) %>% 
  set_engine("glmnet")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- extract_parameter_set_dials(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)

# create workflow ----
## logistic reg model ----
log_reg_workflow_ks <- workflow() %>% 
  add_model(log_reg_mod) %>% 
  add_recipe(rec_ks)

tic.clearlog()
tic("Logistic Regression: KS Recipe")

log_reg_tune_ks <- log_reg_workflow_ks %>% 
  tune_grid(cars_fold, grid = log_reg_grid)

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

log_reg_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                          runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(log_reg_tune_ks, log_reg_tictoc_ks, file = "results/tuning_log_reg_ks.rda")
