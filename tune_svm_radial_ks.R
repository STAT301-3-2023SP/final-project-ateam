library(tidyverse)
library(tidymodels)
library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_setup.rda")


# create models ----
## svm radial model ----
svm_radial_mod <- svm_rbf(mode = "classification", 
                          cost = tune(),
                          rbf_sigma = tune()) %>%
  set_engine("kernlab")


# create grids and parameters ----
## svm radial model ----
svm_rad_params <- extract_parameter_set_dials(svm_radial_mod)

svm_rad_params <- extract_parameter_set_dials(svm_radial_mod)


svm_rad_grid <- grid_regular(svm_rad_params, levels = 5)


# create workflow ----
## svm radial model ----
svm_radial_workflow_ks <- workflow() %>% 
  add_model(svm_radial_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("SVM Radial: KS Recipe")


svm_rad_tune_ks <- tune_grid(
  svm_rad_workflow_ks,
  svm_radial_workflow_ks,
  resamples = cars_fold,
  grid = svm_rad_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"),
  metrics = metric_set(accuracy, f_meas)
)

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

svm_rad_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                         runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(svm_rad_tune_ks, svm_rad_tictoc_ks,
     file = "results/tuning_svm_rad_ks.rda")
