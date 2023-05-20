library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


# create models ----
## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- parameters(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)


# create workflow ----
## elastic net model ----
en_workflow <- workflow() %>% 
  add_model(en_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(en_workflow, cars_fold, file = "results/info_en.rda")


# tuning/fitting ----
tic.clearlog()
tic("elastic net")


en_tune <- tune_grid(
  en_workflow,
  resamples = cars_fold,
  grid = en_grid,
  control = control_grid(save_pred = TRUE,
                         save_workflow = TRUE,
                         parallel_over = "everything"))

toc(log = TRUE)

time_log <- tic.log(format = FALSE)

en_tictoc <- tibble(model = time_log[[1]]$msg,
                    runtime = time_log[[1]]$toc - time_log[[1]]$tic)


save(en_tune, en_tictoc,
     file = "results/tuning_en.rda")


