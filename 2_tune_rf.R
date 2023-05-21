library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


# create models ----
## random forest model ----
rf_mod <- rand_forest(mode = "classification",
                      min_n = tune(),
                      mtry = tune()) %>% 
  set_engine("ranger", importance = "impurity")


# create grids and parameters ----
## random forest model ----
rf_params <- extract_parameter_set_dials(rf_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

rf_grid <- grid_regular(rf_params, levels = 5)


# create workflow ----
## random forest model ----
rf_workflow <- workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(rf_workflow, cars_fold, file = "results/info_rf.rda")


# tuning/fitting ----
tic.clearlog()
tic("random forest")


rf_tune <- tune_grid(
  rf_workflow,
  resamples = cars_fold,
  grid = rf_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

rf_tictoc <- tibble(model = time_log[[1]]$msg,
                    runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(rf_tune, rf_tictoc,
     file = "results/tuning_rf.rda")

