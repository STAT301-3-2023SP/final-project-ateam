
library(tidymodels)
library(tidyverse)

tidymodels_prefer()

set.seed(1234)

# load in training and testing
load("results/rec_ks_setup.rda")

# load in results
load(file = "results/tuned_null.rda")
load(file = "results/tuning_knn_rel.rda")
load(file = "results/tuning_knn_ks.rda")
load(file = "results/tuning_rf_ks.rda")
load(file = "results/tuning_rf_rel.rda")
load(file = "results/tuning_rf_imp.rda")
load(file = "results/tuning_boost_ks.rda")
load(file = "results/tuning_boost_rel.rda")
load(file = "results/tuning_nn_ks.rda")
load(file = "results/tuning_nn_rel.rda")
load(file = "results/tuning_en_ks.rda")
load(file = "results/tuning_en_rel.rda")
load(file = "results/tuning_log_reg_ks.rda")
load(file = "results/tuning_log_reg_rel.rda")
load(file = "results/tuning_svm_poly_ks.rda")
load(file = "results/tuning_svm_poly_rel.rda")
load(file = "results/tuning_svm_rad_ks.rda")
load(file = "results/tuning_svm_rad_rel.rda")
load(file = "results/tuning_mars_ks.rda")
load(file = "results/tuning_mars_rel.rda")

# table of results
knn_ks <- show_best(knn_tune_ks, metric = "roc_auc")[1,]
knn_rel <- show_best(knn_tune_rel, metric = "roc_auc")[1,]

rf_ks <- show_best(rf_tune_ks, metric = "roc_auc")[1,]
rf_rel <- show_best(rf_tune_rel, metric = "roc_auc")[1,]
rf_imp <- show_best(rf_tune_imp, metric = "roc_auc")[1,]

bt_ks <- show_best(boost_tune_ks, metric = "roc_auc")[1,]
bt_rel <- show_best(boost_tune_rel, metric = "roc_auc")[1,]

nn_ks <- show_best(nn_tune_ks, metric = "roc_auc")[1,]
nn_rel <- show_best(nn_tune_rel, metric = "roc_auc")[1,]

en_ks <- show_best(en_tune_ks, metric = "roc_auc")[1,]
en_rel <- show_best(en_tune_rel, metric = "roc_auc")[1,]

log_reg_ks <- show_best(log_reg_tune_ks, metric = "roc_auc")[1,]
log_reg_rel <- show_best(log_reg_tune_rel, metric = "roc_auc")[1,]

svm_poly_ks <- show_best(svm_rad_tune_ks, metric = "roc_auc")[1,]
svm_poly_rel <- show_best(svm_poly_tune_rel_short, metric = "roc_auc")[1,]

svm_rad_ks <- show_best(svm_rad_tune_ks, metric = "roc_auc")[1,]
svm_rad_rel <- show_best(svm_rad_tune_rel_short, metric = "roc_auc")[1,]

mars_ks <- show_best(mars_tune_ks, metric = "roc_auc")[1,]
mars_rel <- show_best(mars_tune_rel, metric = "roc_auc")[1,]

null_results <- show_best(null_fit, metric = "roc_auc")[1,]

model_results <- tibble(model = c("Null", "KNN: KS Recipe",
                                  "KNN: Relationship Recipe", "Random Forest: KS Recipe",
                                  "Random Forest: Relationship Recipe", "Random Forest: Importance Recipe",
                                  "Boosted Tree: KS Recipe", "Boosted Tree: Relationship Recipe", 
                                  "Neural Network: KS Recipe", "Neural Network: Relationship Recipe", 
                                  "Elastic Net: KS Recipe", "Elastic Net: Relationhip Recipe", 
                                  "Logistic Regression: KS Recipe", "Logistic Regression: Relationship Recipe", 
                                  "SVM Poly: KS Recipe", "SVM Poly: Relationship Recipe", 
                                  "SVM Radial: KS Recipe", "SVM Radial: Relationship Recipe", 
                                  "MARS: KS Recipe", "MARS: Relationship Recipe"),
                        recipe_type = c("n/a", "long", "long", "long", "long", "short", "long", "long", "short",
                                        "short", "long", "long", "short", "long", "short", "short", "short",
                                        "short", "long", "long"),
                        roc_auc = c(null_results$mean, knn_ks$mean, knn_rel$mean,
                                    rf_ks$mean, rf_rel$mean, rf_imp$mean, bt_ks$mean, bt_rel$mean,
                                    nn_ks$mean, nn_rel$mean, en_ks$mean, en_rel$mean,
                                    log_reg_ks$mean, log_reg_rel$mean, svm_poly_ks$mean,
                                    svm_poly_rel$mean, svm_rad_ks$mean, svm_rad_rel$mean,
                                    mars_ks$mean, mars_rel$mean))

# table of times

model_times <- bind_rows(null_tictoc, knn_tictoc_ks, knn_tictoc_rel, rf_tictoc_ks,
                         rf_tictoc_rel, rf_tictoc_imp, boost_tictoc_ks, boost_tictoc_rel, 
                         nn_tictoc_ks, nn_tictoc_rel, en_tictoc_ks, en_tictoc_rel,
                         log_reg_tictoc_ks, log_reg_tictoc_rel, svm_poly_tictoc_ks,
                         svm_poly_tictoc_rel_short, svm_rad_tictoc_ks, svm_rad_tictoc_rel_short,
                         mars_tictoc_ks, mars_tictoc_rel) %>% 
  select(model, runtime) %>% 
  mutate(model = c("Null", "KNN: KS Recipe",
                   "KNN: Relationship Recipe", "Random Forest: KS Recipe",
                   "Random Forest: Relationship Recipe", "Random Forest: Importance Recipe",
                   "Boosted Tree: KS Recipe", "Boosted Tree: Relationship Recipe", 
                   "Neural Network: KS Recipe", "Neural Network: Relationship Recipe", 
                   "Elastic Net: KS Recipe", "Elastic Net: Relationhip Recipe", 
                   "Logistic Regression: KS Recipe", "Logistic Regression: Relationship Recipe", 
                   "SVM Poly: KS Recipe", "SVM Poly: Relationship Recipe", "SVM Radial: KS Recipe",
                   "SVM Radial: Relationship Recipe", "MARS: KS Recipe", "MARS: Relationship Recipe"))

# join tables
result_table <- merge(model_results, model_times) %>% 
  select(model, roc_auc, recipe_type, runtime)

save(result_table, file = "results/model_results")

## put all tune_grids together (ks recipe)
model_set_best_ks_long <- as_workflow_set(
  "elastic_net_ks" = en_tune_ks,
  "rand_forest_ks" = rf_tune_ks,
  "boosted_tree_ks" = boost_tune_ks,
  "mars_ks" = mars_tune_ks
)

model_set_best_ks_short <- as_workflow_set(
  "nn_ks" = nn_tune_ks
)

## plot just the best
result_ks_graph_long <- model_set_best_ks_long %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.03, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.6, 0.72) +
  theme(legend.position = "none")

result_ks_graph_short <- model_set_best_ks_short %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.01, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.66, 0.68) +
  theme(legend.position = "none")

## put all tune_grids together (rel recipe)
model_set_best_rel <- as_workflow_set(
  "boosted_tree_rel" = boost_tune_rel
)


## plot just the best
result_rel_graph <- model_set_best_rel %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.01, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(.63, 0.66) +
  theme(legend.position = "none")

## put all tune_grids together (imp recipe)
model_set_best_imp <- as_workflow_set(
  "rf_imp" = rf_tune_imp
)

result_imp_graph <- model_set_best_imp %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.005, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.7, 0.72) +
  theme(legend.position = "none") 

save(result_ks_graph_long, result_ks_graph_short,
     result_rel_graph, result_imp_graph, file = "results/result_graphs")


# fit final model
load(file = "results/rf_workflow_ks")

final_workflow <- rf_workflow_ks %>% 
  finalize_workflow(select_best(rf_tune_ks, metric = "roc_auc"))

final_fit <- fit(final_workflow, cars_train)

final_result <- cars_test %>% 
  select(is_exchangeable) %>%
  bind_cols(predict(final_fit, cars_test, type = "class")) %>% 
  bind_cols(predict(final_fit, cars_test, type = "prob"))

save(final_result, file = "results/final_result")
