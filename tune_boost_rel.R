
library(tidyverse)
library(tidymodels)
library(tictoc)

tidymodels_prefer()

<<<<<<< HEAD
## rec 1

=======
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
# set seed ----
set.seed(1234)

# load in data ---- 
<<<<<<< HEAD
load("results/rec_1_setup.rda")
=======
load("results/rec_2_setup.rda")
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a


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
<<<<<<< HEAD
boost_workflow_ks <- workflow() %>% 
  add_model(boost_mod) %>% 
  add_recipe(rec_ks)


# tuning/fitting ----
tic.clearlog()
tic("Boosted Tree: Relationship Recipe")


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

# # Visualize confusion matrix -- don't know if we need this
# conf_mat(boost_result_1, diagnosis, .pred_class) 
# 
# boost_result_1 %>% 
#   conf_mat(diagnosis, .pred_class) %>% 
#   autoplot(type = "heatmap")





## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")


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
=======
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
boost_workflow_rel <- workflow() %>% 
  add_model(boost_mod) %>% 
  add_recipe(rec_rel)


# tuning/fitting ----
tic.clearlog()
tic("Boosted Tree: Relationship Recipe")


boost_tune_rel <- tune_grid(
  boost_workflow_rel,
  resamples = cars_fold,
  grid = boost_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

boost_tictoc_rel <- tibble(model = time_log[[1]]$msg,
<<<<<<< HEAD
                           runtime = time_log[[1]]$toc - time_log[[1]]$tic)
=======
                       runtime = time_log[[1]]$toc - time_log[[1]]$tic)
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a


save(boost_tune_rel, boost_tictoc_rel,
     file = "results/tuning_boost_rel.rda")

<<<<<<< HEAD



## rec 3

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_3_setup.rda")


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
boost_workflow_log_sqrt <- workflow() %>% 
  add_model(boost_mod) %>% 
  add_recipe(rec_log_sqrt)


# tuning/fitting ----
tic.clearlog()
tic("Boosted Tree: Relationship Recipe")


boost_tune_log_sqrt <- tune_grid(
  boost_workflow_log_sqrt,
  resamples = cars_fold,
  grid = boost_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

boost_tictoc_log_sqrt <- tibble(model = time_log[[1]]$msg,
                           runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(boost_tune_log_sqrt, boost_tictoc_log_sqrt,
     file = "results/tuning_boost_log_sqrt.rda")
=======
# # Visualize confusion matrix -- don't know if we need this
# conf_mat(boost_result_1, diagnosis, .pred_class) 
# 
# boost_result_1 %>% 
#   conf_mat(diagnosis, .pred_class) %>% 
#   autoplot(type = "heatmap")
>>>>>>> d88a78f6dfcb0649d983d532b46a7f0a9568333a
