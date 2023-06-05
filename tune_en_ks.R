library(tidymodels)
library(tidyverse)
library(tictoc)

tidymodels_prefer()

## rec 1

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
en_workflow_ks <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_ks)


<<<<<<< HEAD:2_tune_en.R
# save workflows and grids ----
save(en_workflow_ks, cars_fold, file = "results/info_en.rda")


=======
>>>>>>> 09ecc67545282768e93d0a0a7e4bef9e53f4e95e:tune_en_ks.R
# tuning/fitting ----
tic.clearlog()
tic("Elastic Net: KS recipe")


en_tune_ks <- tune_grid(
<<<<<<< HEAD:2_tune_en.R
  en_workflow_ks,
=======
  en_workflow,
>>>>>>> 09ecc67545282768e93d0a0a7e4bef9e53f4e95e:tune_en_ks.R
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
<<<<<<< HEAD:2_tune_en.R




## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")


# create models ----
## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- extract_parameter_set_dials(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)


# create workflow ----
## elastic net model ----
en_workflow_ks <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(en_workflow_ks, cars_fold, file = "results/info_en_ks.rda")


# tuning/fitting ----
tic.clearlog()
tic("elastic net")


en_tune_ks <- tune_grid(
  en_workflow_ks,
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




## rec 2

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_2_setup.rda")


# create models ----
## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- extract_parameter_set_dials(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)


# create workflow ----
## elastic net model ----
en_workflow_rel <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_rel)


# save workflows and grids ----
save(en_workflow_rel, cars_fold, file = "results/info_en_rel.rda")


# tuning/fitting ----
tic.clearlog()
tic("elastic net")


en_tune_rel <- tune_grid(
  en_workflow_rel,
  resamples = cars_fold,
  grid = en_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

en_tictoc_rel <- tibble(model = time_log[[1]]$msg,
                       runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(en_tune_rel, en_tictoc_rel,
     file = "results/tuning_en_rel.rda")





## rec 3

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_3_setup.rda")


# create models ----
## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- extract_parameter_set_dials(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)


# create workflow ----
## elastic net model ----
en_workflow_log_sqrt <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_log_sqrt)


# save workflows and grids ----
save(en_workflow_log_sqrt, cars_fold, file = "results/info_en_log_sqrt.rda")


# tuning/fitting ----
tic.clearlog()
tic("elastic net")


en_tune_log_sqrt <- tune_grid(
  en_workflow_log_sqrt,
  resamples = cars_fold,
  grid = en_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

en_tictoc_log_sqrt <- tibble(model = time_log[[1]]$msg,
                        runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(en_tune_log_sqrt, en_tictoc_log_sqrt,
     file = "results/tuning_en_log_sqrt.rda")
=======
>>>>>>> 09ecc67545282768e93d0a0a7e4bef9e53f4e95e:tune_en_ks.R


