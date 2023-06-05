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
## mars model ----
mars_mod <- mars(mode = "classification",
                 num_terms = tune(),
                 prod_degree = tune()) %>%
  set_engine("earth")


# create grids and parameters ----
## elastic net model ----
en_params <- extract_parameter_set_dials(en_mod)

en_grid <- grid_regular(en_params, levels = 5)


# create workflow ----
## mars model ----
mars_workflow <- workflow() %>% 
  add_model(mars_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(mars_workflow, cars_fold, file = "results/info_mars.rda")


# tuning/fitting ----
tic.clearlog()
tic("mars")


mars_tune <- tune_grid(
  mars_workflow,
  resamples = cars_fold,
  grid = mars_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

mars_tictoc <- tibble(model = time_log[[1]]$msg,
                      runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(mars_tune, mars_tictoc,
     file = "results/tuning_mars.rda")




## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")