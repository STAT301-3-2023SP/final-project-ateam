library(tidyverse)
library(tidymodels)
<<<<<<< HEAD
library(textrecipes)
=======
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
<<<<<<< HEAD
load("results/rec_1_setup.rda")
=======
load("results/rec_ks_setup.rda")
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a


# create models ----
## mars model ----
mars_mod <- mars(mode = "classification",
                 num_terms = tune(),
                 prod_degree = tune()) %>%
  set_engine("earth")


# create grids and parameters ----
## elastic net model ----
<<<<<<< HEAD
en_params <- extract_parameter_set_dials(en_mod)

en_grid <- grid_regular(en_params, levels = 5)
=======
mars_params <- extract_parameter_set_dials(mars_mod)

mars_grid <- grid_regular(mars_params, levels = 5)
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a


# create workflow ----
## mars model ----
<<<<<<< HEAD
mars_workflow <- workflow() %>% 
=======
mars_workflow_ks <- workflow() %>% 
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
  add_model(mars_mod) %>% 
  add_recipe(rec_ks)


<<<<<<< HEAD
# save workflows and grids ----
save(mars_workflow, cars_fold, file = "results/info_mars.rda")


# tuning/fitting ----
tic.clearlog()
tic("mars")


mars_tune <- tune_grid(
  mars_workflow,
=======
# tuning/fitting ----
tic.clearlog()
tic("MARS: KS Recipe")


mars_tune_ks <- tune_grid(
  mars_workflow_ks,
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
  resamples = cars_fold,
  grid = mars_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

<<<<<<< HEAD
mars_tictoc <- tibble(model = time_log[[1]]$msg,
                      runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(mars_tune, mars_tictoc,
     file = "results/tuning_mars.rda")




## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")
=======
mars_tictoc_ks <- tibble(model = time_log[[1]]$msg,
                      runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(mars_tune_ks, mars_tictoc_ks,
     file = "results/tuning_mars_ks.rda")
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
