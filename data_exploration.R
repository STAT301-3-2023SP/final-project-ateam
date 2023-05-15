
library(tidyverse)
library(tidymodels)

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

cars_train_2 <- slice_sample(cars_train, prop = 0.5)

# Explore relationships with numerical variables ----
box_plots_num <- map(colnames(cars_train_2)
                 [c(6,7,10,15,18,19,20)],
                 function(x){
                   ggplot(cars_train_2, aes(x = !!sym(x), y = is_exchangeable) )+
                     geom_boxplot() + 
                     xlab(x)
                 })

gridExtra::grid.arrange(grobs = box_plots_num)
# weak relationships overall but very weak relationship with up_counter and duration_listed

# look at 