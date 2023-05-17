
library(tidymodels)
library(tidyverse)
library(tictoc)
set.seed(1234)

load("results/info_null.rda")

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

