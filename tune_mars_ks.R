library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_setup.rda")


# create models ----
## mars model ----
mars_mod <- mars(mode = "classification",
                 num_terms = tune(),
                 prod_degree = tune()) %>%
  set_engine("earth")


# create grids and parameters ----
## elastic net model ----
mars_params <- extract_parameter_set_dials(mars_mod)

mars_grid <- grid_regular(mars_params, levels = 5)


# create workflow ----
## mars model ----
mars_workflow_ks <- workflow() %>% 
  add_model(mars_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("MARS: KS Recipe")


mars_tune_ks <- tune_grid(
  mars_workflow_ks,
  resamples = cars_fold,
  grid = mars_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

mars_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                      runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(mars_tune_ks, mars_tictoc_ks,
     file = "results/tuning_mars_ks.rda")