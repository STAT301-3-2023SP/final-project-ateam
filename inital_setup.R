
library(tidyverse)
library(tidymodels)
library(textrecipes)

tidymodels_prefer()

# set seed ----
set.seed(1234)

# load in data ---- 
cars <- read_rds(file = "data/processed/cars_clean.rds")

# split data ----
cars_split <- initial_split(cars, 
                            strata = is_exchangeable, 
                            prop = 0.7)

cars_train <- training(cars_split)
cars_test <- testing(cars_split)

# test for balance
ggplot(cars_train, mapping = aes(x = is_exchangeable)) +
  geom_bar()

# create recipes ----
## kitchen sink
rec_ks <- recipe(is_exchangeable ~ ., data = cars_train) %>% 
  step_clean_levels(all_nominal_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_ks %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

## recipe with only related predictors
rec_rel <- recipe(is_exchangeable ~ odometer_value + year_produced + engine_capacity +
                  price_usd + number_of_photos + engine_has_gas + has_warranty +
                  state + drivetrain + manufacturer_name + location_region, 
                data = cars_train) %>% 
  step_clean_levels(all_nominal_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_rel %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

## relationship with log and square root transformations
rec_log_sqrt <- recipe(is_exchangeable ~ ., data = cars_train) %>%
  step_rm(up_counter) %>% 
  step_clean_levels(all_nominal_predictors()) %>% 
  step_log(engine_capacity, price_usd, duration_listed) %>% 
  step_sqrt(odometer_value, number_of_photos) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_knn(all_predictors()) %>% 
  step_corr(all_predictors())

rec_log_sqrt %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  view()

# create folds ----
cars_fold <- vfold_cv(cars_train, v = 10, repeats = 5,
                       strata = is_exchangeable)

# create models ----
## null model ----
null_mod <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("classification")

## random forest model ----
rf_mod <- rand_forest(mode = "classification",
                      min_n = tune(),
                      mtry = tune()) %>% 
  set_engine("ranger", importance = "impurity")

## logistic regression model ----
log_reg_mod <- logistic_reg(mode = "classification",
                            mixture = tune(),
                            penalty = tune()) %>% 
  set_engine("glmnet")

## boosted tree model ----
bt_mod <- boost_tree(mode = "classification",
                     mtry = tune(),
                     min_n = tune(),
                     learn_rate = tune()) %>% 
  set_engine("xgboost", importance = "impurity")

## k nearest neighbors model ----
knn_mod <- nearest_neighbor(mode = "classification",
                            neighbors = tune()) %>% 
  set_engine("kknn")

## elastic net model ----
en_mod <- multinom_reg(penalty = tune(),
                       mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification")

## mars model ----
mars_mod <- mars(mode = "classification",
                 num_terms = tune(),
                 prod_degree = tune()) %>%
  set_engine("earth")

## neural network model ----
nn_mod <- mlp(mode = "classification",
              hidden_units = tune(),
              penalty = tune()) %>%
  set_engine("nnet")

## svm poly model ----
svm_poly_mod <- svm_poly(mode = "classification", 
                         cost = tune(),
                         degree = tune(),
                         scale_factor = tune()) %>%
  set_engine("kernlab")

## svm radial model ----
svm_radial_mod <- svm_rbf(mode = "classification", 
                          cost = tune(),
                          rbf_sigma = tune()) %>%
  set_engine("kernlab")

# create grids and parameters ----
## random forest model ----
rf_params <- parameters(rf_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

rf_grid <- grid_regular(rf_params, levels = 5)

## logistic regression model ----
log_reg_params <- parameters(log_reg_mod)

log_reg_grid <- grid_regular(log_reg_params, levels = 5)

## boosted tree model ----
bt_params <- parameters(bt_mod) %>% 
  update(mtry = mtry(range = c(1, 19)))

bt_grid <- grid_regular(bt_params, levels = 5)

# k nearest neighbors model ----
knn_params <- parameters(knn_mod)

knn_grid <- grid_regular(knn_params, levels = 5)

## elastic net model ----
en_params <- parameters(en_mod)

en_grid <- grid_regular(en_params, levels = 5)


# create workflow ----
## null workflow
null_workflow <- workflow() %>% 
  add_model(null_mod) %>%
  add_recipe(rec_ks)



# save workflows and grids ----
save(null_workflow, cars_fold, file = "results/info_null.rda")
