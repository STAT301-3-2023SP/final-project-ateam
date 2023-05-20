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
## boosted tree model ----
boost_mod <- boost_tree(mode = "classification",
                     mtry = tune(),
                     min_n = tune(),
                     learn_rate = tune()) %>% 
  set_engine("xgboost", importance = "impurity")


# create grids and parameters ----
## boosted tree model ----
boost_params <- parameters(boost_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

boost_grid <- grid_regular(boost_params, levels = 5)


# create workflow ----
## boosted tree model ----
boost_workflow <- workflow() %>% 
  add_model(boost_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(boost_workflow, cars_fold, file = "results/info_boost.rda")


# tuning/fitting ----
tic.clearlog()
tic("boost")


boost_tune <- tune_grid(
  boost_workflow,
  resamples = cars_fold,
  grid = boost_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"),
  metrics = metric_set(accuracy, f_meas))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

boost_tictoc <- tibble(model = time_log[[1]]$msg,
                       runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(boost_tune, boost_tictoc,
     file = "results/tuning_boost.rda")

# # Visualize confusion matrix -- don't know if we need this
# conf_mat(boost_result_1, diagnosis, .pred_class) 
# 
# boost_result_1 %>% 
#   conf_mat(diagnosis, .pred_class) %>% 
#   autoplot(type = "heatmap")