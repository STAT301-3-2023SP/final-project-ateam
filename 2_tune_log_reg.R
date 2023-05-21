library(textrecipes)
library(tictoc)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
load("results/rec_1_setup.rda")


# create models ----
## logistic regression model ----
log_reg_mod <- logistic_reg(mode = "classification",
                            mixture = tune(),
                            penalty = tune()) %>% 
  set_engine("glmnet")


# create grids and parameters ----
## logistic regression model ----
log_reg_params <- extract_parameter_set_dials(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)


# create workflow ----
## logistic reg model ----
log_reg_workflow <- workflow() %>% 
  add_model(log_reg_mod) %>% 
  add_recipe(rec_ks)


# save workflows and grids ----
save(log_reg_workflow, cars_fold, file = "results/info_log_reg.rda")


## still need to add tuning

