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
## svm radial model ----
svm_radial_mod <- svm_rbf(mode = "classification", 
                          cost = tune(),
                          rbf_sigma = tune()) %>%
  set_engine("kernlab")


# create grids and parameters ----
## svm radial model ----
svm_rad_params <- extract_parameter_set_dials(svm_rad_mod)

svm_rad_grid <- grid_regular(svm_rad_params, levels = 5)


# create workflow ----
## svm radial model ----
svm_radial_workflow <- workflow() %>% 
  add_model(svm_radial_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(svm_radial_workflow, cars_fold, file = "results/info_svm_radial.rda")


# tuning/fitting ----
tic.clearlog()
tic("radial svm")


svm_rad_tune <- tune_grid(
  svm_rad_workflow,
  resamples = cars_fold,
  grid = svm_rad_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"),
  metrics = metric_set(accuracy, f_meas)
)

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

svm_rad_tictoc <- tibble(model = time_log[[1]]$msg,
                         runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(svm_rad_tune, svm_rad_tictoc,
     file = "results/tuning_svm_rad.rda")


