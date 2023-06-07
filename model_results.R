
library(tidymodels)
library(tidyverse)

tidymodels_prefer()

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
  select(model, roc_auc, runtime)

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

result_ks_graph_4 <- ggarrange(result_ks_graph_3, result_ks_graph_2)

save(result_ks_graph_1, result_ks_graph_4, file = "results/result_graph_ks.rda")

## put all tune_grids together (rel recipe)
model_set_rel_1 <- as_workflow_set(
  "elastic_net_rel" = en_tune_rel,
  "mars_rel" = mars_tune_rel)

model_set_rel_2 <- as_workflow_set(
  "svm_poly_rel" = svm_poly_tune_rel_short,
  "svm_radial_rel" = svm_rad_tune_rel_short,
  "nn_rel" = nn_tune_rel
)

model_set_rel_3 <- as_workflow_set(
  "knn_rel" = knn_tune_rel,
  "boosted_tree_rel" = boost_tune_rel
)

model_set_rel_4 <- as_workflow_set(
  "rf_rel" = rf_tune_rel
)

model_set_rel_5 <- as_workflow_set(
  "log_reg_rel" = log_reg_tune_rel
)

## plot just the best
result_rel_graph_1 <- model_set_rel_1 %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.03, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.53, 0.72) +
  theme(legend.position = "none")

result_rel_graph_2 <- model_set_rel_2 %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.02, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.6, 0.65) +
  theme(legend.position = "none")

result_rel_graph_3 <- model_set_rel_3 %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.02, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.56, 0.66) +
  theme(legend.position = "none")

result_rel_graph_4 <- model_set_rel_4 %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.02, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.6, 0.65) +
  theme(legend.position = "none")

result_rel_graph_5 <- model_set_rel_5 %>% 
  autoplot(metric = "roc_auc", select_best = TRUE) +
  theme_minimal() +
  geom_text(aes(y = mean - 0.01, label = wflow_id), angle = 90, hjust = 0.6) +
  ylim(0.6, 0.65) +
  theme(legend.position = "none")

save(result_rel_graph_1, result_rel_graph_2, result_rel_graph_3, result_rel_graph_4,
     result_rel_graph_5, file = "results/result_graph_rel.rda")

model_set_best_ks_long <- as_workflow_set(
  "elastic_net_ks" = en_tune_ks,
  "rand_forest_ks" = rf_tune_ks,
  "boosted_tree_ks" = boost_tune_ks,
  "mars_ks" = mars_tune_ks
)

model_set_best_ks_short <- as_workflow_set(
  "nn_ks" = nn_tune_ks
)
