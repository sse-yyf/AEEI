library(mltools)
library(dplyr)
library(data.table)
library(grf)
library(ggplot2)

load("../input/politician_gender_prefs.rdata")

set.seed(123456)

# Ex1

ols <- lm(picked_cand_a ~ cand_a_female, df)
summary(ols)

# Ex2
df$y <- as.numeric(df$picked_cand_a)
df$w <- as.numeric(df$cand_a_female)
df<- one_hot(
          data.table(
            df
            ) 
          )

train_fraction <- 0.75  # Use train_fraction % of the dataset to train our models
n <- dim(df)[1]
train_idx <- sample.int(n, replace=F, size=floor(n*train_fraction))
df_train <- df[train_idx,]
df_test <- df[-train_idx,]

covariates_train <- select(df_train,-cand_a_female, -picked_cand_a)

cf<- causal_forest( 
      Y = df_train$y,  
      X = covariates_train,  
      W = df_train$w,  
      num.trees = 5000
        )

covariates_test <- select(df_test,-cand_a_female, -picked_cand_a)
test_pred<- predict(cf, newdata=as.matrix(covariates_test), estimate.variance=TRUE)
covariates_test$preds<- test_pred$predictions

# Ex3
ggplot(data = covariates_test, aes(x = preds)) +
  geom_histogram(fill = "lightblue", color = "black", alpha = 0.7) +
  labs(title = "Predicted treatment effects", x = "Treatment effects", y = "Frequency")

ggsave("../outcome/Predicted treatment effects.png")

# Ex4
covariate_names <- names(df)[-c(1,2)]
var_imp <- c(variable_importance(cf))
names(var_imp) <- covariate_names
sorted_var_imp <- data.frame(sort(var_imp, decreasing=TRUE))

predict_means <- covariates_test %>%  
  group_by(age) %>%  
  summarize(mean_predicted_te = mean(preds))  

ggplot(data = predict_means, aes(x = age, y = mean_predicted_te)) +
  geom_bar(stat = "identity", fill = "lightblue", color = "black", alpha = 0.7) +  
  labs(title = "Mean Predicted Treatment Effects by Age", x = "Age", y = "Mean Predicted Treatment Effects")

ggsave("../outcome/Mean Predicted treatment effects by Age.png")

predict_means <- covariates_test %>%  
  group_by(sdo) %>%  
  summarize(mean_predicted_te = mean(preds))  

ggplot(data = predict_means, aes(x = sdo, y = mean_predicted_te)) +
  geom_bar(stat = "identity", fill = "lightblue", color = "black", alpha = 0.7) +  
  labs(title = "Mean Predicted Treatment Effects by sdo", x = "sdo", y = "Mean Predicted Treatment Effects")

ggsave("../outcome/Mean Predicted treatment effects by sdo.png")
