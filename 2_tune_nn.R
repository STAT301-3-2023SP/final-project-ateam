library(tidyverse)
library(tidymodels)
library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


# create models ----
## neural network model ----
nn_mod <- mlp(mode = "classification",
              hidden_units = tune(),
              penalty = tune()) %>%
  set_engine("nnet")


# create grids and parameters ----
## neural network model ----
nn_params <- extract_parameter_set_dials(nn_mod)

nn_grid <- grid_regular(nn_params, levels = 5)


# create workflow ----
## neural network model ----
nn_workflow <- workflow() %>% 
  add_model(nn_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(nn_workflow, cars_fold, file = "results/info_nn.rda")


# tuning/fitting ----
tic.clearlog()
tic("mlp")


nn_tune <- tune_grid(
  nn_workflow,
  resamples = cars_fold,
  grid = nn_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

nn_tictoc <- tibble(model = time_log[[1]]$msg,
                     runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(nn_tune, nn_tictoc, nn_workflow,
     file = "results/tuning_nn.rda")