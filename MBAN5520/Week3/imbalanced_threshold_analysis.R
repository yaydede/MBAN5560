# =============================================================================
# IMBALANCED DATA & THRESHOLD OPTIMIZATION
# =============================================================================

library(tidyverse)
library(gridExtra)

# =============================================================================
# 1. SIMULATE IMBALANCED DATA (5% churn rate)
# =============================================================================

set.seed(42)
n <- 1000

monthly_charges <- rnorm(n, mean = 65, sd = 20)
tenure_months <- rpois(n, lambda = 24) + 1
service_calls <- rpois(n, lambda = 2)

log_odds <- -5.5 + 0.03 * monthly_charges - 0.05 * tenure_months + 0.4 * service_calls
true_prob <- 1 / (1 + exp(-log_odds))
churn <- rbinom(n, size = 1, prob = true_prob)

data <- data.frame(
  monthly_charges = monthly_charges,
  tenure_months = tenure_months,
  service_calls = service_calls,
  churn = churn
)

table(data$churn)
mean(data$churn)


# =============================================================================
# 2. VISUALIZE CLASS IMBALANCE
# =============================================================================

ggplot(data, aes(x = factor(churn), fill = factor(churn))) +
  geom_bar() +
  geom_text(stat = 'count', aes(label = after_stat(count)), vjust = -0.5, size = 6) +
  labs(title = "Class Distribution: Highly Imbalanced",
       x = "Churn (0 = No, 1 = Yes)", y = "Count") +
  scale_fill_manual(values = c("steelblue", "coral")) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")


# =============================================================================
# 3. LINEAR PROBABILITY MODEL (LPM)
# =============================================================================

lpm <- lm(churn ~ monthly_charges + tenure_months + service_calls, data = data)
summary(lpm)

data$pred_prob <- predict(lpm)

summary(data$pred_prob)
sum(data$pred_prob < 0)
sum(data$pred_prob > 1)


# =============================================================================
# 4. CONFUSION MATRIX AT 0.5 THRESHOLD
# =============================================================================

data$pred_class_05 <- ifelse(data$pred_prob >= 0.5, 1, 0)

# Confusion Matrix Structure:
#          Actual
#               1    0
# Predicted 1  TP  FP
#           0  FN  TN

conf_05 <- table(
  Predicted = factor(data$pred_class_05, levels = c(1, 0)),
  Actual = factor(data$churn, levels = c(1, 0))
)
conf_05

# Extract values (CORRECT ORDER)
TP <- conf_05[1, 1]  # Row 1 (Pred=1), Col 1 (Actual=1)
TN <- conf_05[2, 2]  # Row 2 (Pred=0), Col 2 (Actual=0)
FP <- conf_05[1, 2]  # Row 1 (Pred=1), Col 2 (Actual=0)
FN <- conf_05[2, 1]  # Row 2 (Pred=0), Col 1 (Actual=1)

accuracy_05 <- (TP + TN) / sum(conf_05)
precision_05 <- TP / (TP + FP)
recall_05 <- TP / (TP + FN)
specificity_05 <- TN / (TN + FP)
f1_05 <- 2 * (precision_05 * recall_05) / (precision_05 + recall_05)

if (is.na(precision_05)) precision_05 <- 0
if (is.na(recall_05)) recall_05 <- 0
if (is.na(f1_05)) f1_05 <- 0

metrics_05 <- data.frame(
  Metric = c("Accuracy", "Precision", "Recall", "Specificity", "F1-Score"),
  Value = round(c(accuracy_05, precision_05, recall_05, specificity_05, f1_05), 4)
)
metrics_05

ggplot(as.data.frame(conf_05), aes(x = Actual, y = Predicted, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 10, fontface = "bold") +
  scale_fill_gradient(low = "white", high = "coral") +
  scale_y_discrete(limits = rev) +
  labs(title = "Confusion Matrix (Threshold = 0.5)") +
  theme_minimal(base_size = 14) +
  coord_fixed()


# =============================================================================
# 5. THRESHOLD SWEEP: 0.01 to 0.99
# =============================================================================

thresholds <- seq(0.01, 0.99, by = 0.01)
results <- data.frame(threshold = thresholds)

for (i in 1:length(thresholds)) {
  thresh <- thresholds[i]
  pred_class <- ifelse(data$pred_prob >= thresh, 1, 0)
  
  cm <- table(
    Predicted = factor(pred_class, levels = c(1, 0)),
    Actual = factor(data$churn, levels = c(1, 0))
  )
  
  TP <- ifelse("1" %in% rownames(cm) && "1" %in% colnames(cm), cm["1", "1"], 0)
  TN <- ifelse("0" %in% rownames(cm) && "0" %in% colnames(cm), cm["0", "0"], 0)
  FP <- ifelse("1" %in% rownames(cm) && "0" %in% colnames(cm), cm["1", "0"], 0)
  FN <- ifelse("0" %in% rownames(cm) && "1" %in% colnames(cm), cm["0", "1"], 0)
  
  acc <- (TP + TN) / sum(cm)
  prec <- ifelse((TP + FP) > 0, TP / (TP + FP), 0)
  rec <- ifelse((TP + FN) > 0, TP / (TP + FN), 0)
  spec <- ifelse((TN + FP) > 0, TN / (TN + FP), 0)
  f1 <- ifelse((prec + rec) > 0, 2 * prec * rec / (prec + rec), 0)
  
  results$accuracy[i] <- acc
  results$precision[i] <- prec
  results$recall[i] <- rec
  results$specificity[i] <- spec
  results$f1_score[i] <- f1
}

head(results, 10)
tail(results, 10)


# =============================================================================
# 6. FIND OPTIMAL THRESHOLDS
# =============================================================================

optimal_acc_idx <- which.max(results$accuracy)
optimal_f1_idx <- which.max(results$f1_score)

optimal_thresholds <- data.frame(
  Metric = c("Max Accuracy", "Max F1-Score", "Default (0.5)"),
  Threshold = c(
    results$threshold[optimal_acc_idx],
    results$threshold[optimal_f1_idx],
    0.5
  ),
  Accuracy = c(
    results$accuracy[optimal_acc_idx],
    results$accuracy[optimal_f1_idx],
    accuracy_05
  ),
  F1_Score = c(
    results$f1_score[optimal_acc_idx],
    results$f1_score[optimal_f1_idx],
    f1_05
  )
)
optimal_thresholds


# =============================================================================
# 7. VISUALIZE: F1-SCORE VS THRESHOLD
# =============================================================================

ggplot(results, aes(x = threshold, y = f1_score)) +
  geom_line(color = "coral", size = 1.2) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "red") +
  geom_vline(xintercept = results$threshold[optimal_f1_idx], 
             linetype = "dotted", color = "darkgreen") +
  annotate("text", x = 0.5, y = f1_05, 
           label = "Default (0.5)", color = "red", hjust = -0.1) +
  annotate("text", x = results$threshold[optimal_f1_idx], y = max(results$f1_score), 
           label = paste0("Max F1\n(", round(results$threshold[optimal_f1_idx], 2), ")"), 
           color = "darkgreen", hjust = 1.1) +
  labs(title = "F1-Score vs Threshold",
       subtitle = "F1-Score is more sensitive to threshold choice with imbalanced data",
       x = "Classification Threshold", y = "F1-Score") +
  theme_minimal(base_size = 14)


# =============================================================================
# 8. PRECISION-RECALL TRADE-OFF
# =============================================================================

ggplot(results, aes(x = threshold)) +
  geom_line(aes(y = precision, color = "Precision"), size = 1.2) +
  geom_line(aes(y = recall, color = "Recall"), size = 1.2) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "black", alpha = 0.5) +
  scale_color_manual(values = c("Precision" = "purple", "Recall" = "orange")) +
  labs(title = "Precision-Recall Trade-off",
       subtitle = "Higher threshold → Higher precision, Lower recall",
       x = "Classification Threshold", y = "Metric Value", color = "Metric") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")



