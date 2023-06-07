
library(tidymodels)
library(tidyverse)

tidymodels_prefer()

# load in results
load(file = "results/tuned_null.rda")
load(file = "results/tuning_knn_rel.rda")
load(file = "results/tuning_knn_ks.rda")
load(file = "results/tuning_rf_ks.rda")
load(file = "results/tuning_rf_rel.rda")
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
                                  "Random Forest: Relationship Recipe", "Boosted Tree: KS Recipe",
                                  "Boosted Tree: Relationship Recipe", "Neural Network: KS Recipe",
                                  "Neural Network: Relationship Recipe", "Elastic Net: KS Recipe",
                                  "Elastic Net: Relationhip Recipe", "Logistic Regression: KS Recipe",
                                  "Logistic Regression: Relationship Recipe", "SVM Poly: KS Recipe",
                                  "SVM Poly: Relationship Recipe", "SVM Radial: KS Recipe",
                                  "SVM Radial: Relationship Recipe", "MARS: KS Recipe",
                                  "MARS: Relationship Recipe"),
                        roc_auc = c(null_results$mean, knn_ks$mean, knn_rel$mean,
                                    rf_ks$mean, rf_rel$mean, bt_ks$mean, bt_rel$mean,
                                    nn_ks$mean, nn_rel$mean, en_ks$mean, en_rel$mean,
                                    log_reg_ks$mean, log_reg_rel$mean, svm_poly_ks$mean,
                                    svm_poly_rel$mean, svm_rad_ks$mean, svm_rad_rel$mean,
                                    mars_ks$mean, mars_rel$mean))


# table of times
model_times <- bind_rows(knn_tictoc_rel,
                         null_tictoc) %>% 
  select(model, runtime)

# join tables
result_table <- merge(model_results, model_times) %>% 
  select(model, roc_auc, runtime)

save(result_table, file = "results/model_results")
