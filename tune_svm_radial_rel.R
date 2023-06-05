library(tidyverse)
library(tidymodels)
library(textrecipes)
library(tictoc)

tidymodels_prefer()


## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")

# set seed ----
set.seed(1234)

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
svm_radial_workflow_rel <- workflow() %>% 
  add_model(svm_radial_mod) %>% 
  add_recipe(rec_rel)


# tuning/fitting ----
tic.clearlog()
tic("SVM Radial: REL Recipe")


svm_rad_tune_rel <- tune_grid(
  svm_radial_workflow_rel,
  svm_radial_workflow_rel,
  resamples = cars_fold,
  grid = svm_rad_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"),
  metrics = metric_set(accuracy, f_meas)
)

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

svm_rad_tictoc_rel <- tibble(model = time_log[[1]]$msg,
                             runtime = time_log[[1]]$toc - time_log[[1]]$tic)

save(svm_rad_tune_rel, svm_rad_tictoc_rel,
     file = "results/tuning_svm_rad_rel.rda")

