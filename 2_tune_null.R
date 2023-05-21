library(tidymodels)
library(tidyverse)
library(tictoc)
set.seed(1234)

load(file = "results/rec_2_setup.rda")

null_mod <- null_model() %>% 
  set_engine("parsnip") %>% 
  set_mode("classification")

null_workflow <- workflow() %>% 
  add_model(null_mod) %>%
  # doesn't actually use recipe
  add_recipe(rec_rel)

tic("Null")

null_fit <- fit_resamples(
  null_workflow,
  resamples = cars_fold,
  control = control_resamples(save_pred = TRUE)
)

toc(log = TRUE)

# save runtime info
time_log <- tic.log(format = FALSE)

null_tictoc <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

save(null_tictoc, null_fit, file = "results/tuned_null.rda")

