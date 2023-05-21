
library(tidymodels)
library(tidyverse)

tidymodels_prefer()

# load in results
load(file = "results/tuned_null.rda")
load(file = "results/tuning_knn_rel.rda")

# table of results

knn_rel <- show_best(knn_tune_rel, metric = "roc_auc")[1,]

null_results <- show_best(null_fit, metric = "roc_auc")[1,]

model_results <- tibble(model = c("KNN: Relationship Recipe", "Null"),
                        roc_auc = c(knn_rel$mean, null_results$mean))


# table of times
model_times <- bind_rows(knn_tictoc_rel,
                         null_tictoc) %>% 
  select(model, runtime)

# join tables
result_table <- merge(model_results, model_times) %>% 
  select(model, roc_auc, runtime)

save(result_table, file = "results/model_results")
