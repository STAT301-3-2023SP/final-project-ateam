library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


# create models ----
## k nearest neighbors model ----
knn_mod <- nearest_neighbor(mode = "classification",
                            neighbors = tune()) %>% 
  set_engine("kknn")


# create grids and parameters ----
# k nearest neighbors model ----
knn_params <- parameters(knn_mod)

knn_grid <- grid_regular(knn_params, levels = 5)


# create workflow ----
## k nearest neighbors model ----
knn_workflow <- workflow() %>% 
  add_model(knn_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(knn_workflow, cars_fold, file = "results/info_knn.rda")


# tuning/fitting ----
tic.clearlog()
tic("knn")


knn_tune <- tune_grid(
  knn_workflow,
  resamples = cars_fold,
  grid = knn_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

knn_tictoc <- tibble(model = time_log[[1]]$msg,
                     runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(knn_tune, knn_tictoc,
     file = "results/tuning_knn.rda")
