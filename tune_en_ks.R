library(tidymodels)
library(tidyverse)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_ks_setup.rda")


# create models ----
## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")


# create grids and parameters ----
## logistic regression model ----
en_params <- extract_parameter_set_dials(en_mod)

en_grid <- grid_regular(en_params, levels = 5)


# create workflow ----
## elastic net model ----
en_workflow <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("Elastic Net: KS recipe")


en_tune_ks <- tune_grid(
  en_workflow,
  resamples = cars_fold,
  grid = en_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

en_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                    runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(en_tune_ks, en_tictoc_ks,
     file = "results/tuning_en_ks.rda")


