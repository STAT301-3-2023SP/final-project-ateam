
library(tidyverse)
library(tidymodels)
library(naniar)

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

# Check missingness ----
miss_var_summary(cars)
# minor missingess in engine_capacity - will impute

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

# Explore relationships with nominal variables ----
ggplot(cars_train_2, mapping = aes(x = engine_has_gas)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # seems to have relationship

ggplot(cars_train_2, mapping = aes(x = engine_type)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # weak relationship

ggplot(cars_train_2, mapping = aes(x = has_warranty)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # seems to have relationship

ggplot(cars_train_2, mapping = aes(x = state)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # seems to have relationship

ggplot(cars_train_2, mapping = aes(x = drivetrain)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # seems to have relationship

ggplot(cars_train_2, mapping = aes(x = manufacturer_name)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # possible relationship

ggplot(cars_train_2, mapping = aes(x = model_name)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # too many characters

ggplot(cars_train_2, mapping = aes(x = color)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # weak relationship

ggplot(cars_train_2, mapping = aes(x = body_type)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # weak relationship

ggplot(cars_train_2, mapping = aes(x = location_region)) +
  geom_bar(aes(fill = is_exchangeable), position = "dodge") # seems to have relationship

# Distribution of numerical predictors ----
# right skewed - fixed with square root
ggplot(cars_train_2, mapping = aes(x = odometer_value)) +
  geom_histogram()
ggplot(cars_train_2, mapping = aes(x = sqrt(odometer_value))) +
  geom_histogram()

# slightly left skewed - worsens with log and sqrt
ggplot(cars_train_2, mapping = aes(x = year_produced)) +
  geom_histogram()

# right skewed - fixed with log transformation
ggplot(cars_train_2, mapping = aes(x = engine_capacity)) +
  geom_histogram()
ggplot(cars_train_2, mapping = aes(x = log(engine_capacity))) +
  geom_histogram()

# heavily right skewed - fixed with log transformation
ggplot(cars_train_2, mapping = aes(x = price_usd)) +
  geom_histogram()
ggplot(cars_train_2, mapping = aes(x = log(price_usd))) +
  geom_histogram()

# heavily right skewed - fixed with square root
ggplot(cars_train_2, mapping = aes(x = number_of_photos)) +
  geom_histogram()
ggplot(cars_train_2, mapping = aes(x = sqrt(number_of_photos))) +
  geom_histogram()

# heavily right skewed - remains right skewed with transformations
ggplot(cars_train_2, mapping = aes(x = up_counter)) +
  geom_histogram()

# heavily right skewed - fixed with square root
ggplot(cars_train_2, mapping = aes(x = duration_listed)) +
  geom_histogram()
ggplot(cars_train_2, mapping = aes(x = log(duration_listed))) +
  geom_histogram()
