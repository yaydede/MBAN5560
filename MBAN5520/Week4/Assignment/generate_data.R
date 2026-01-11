#!/usr/bin/env Rscript

#################################################
# Generate Data for Gradient Descent Assignment
# MBAN 5520: Statistics for Business
# Dr. Aydede
#################################################

# Set seed for reproducibility
set.seed(2024)

# Number of observations
n <- 200

# Generate temperature data (in Celsius)
# Realistic range: -10°C to 35°C
temperature <- round(runif(n, min = -10, max = 35), 1)

# Create a quadratic relationship with energy consumption
# Energy consumption is higher at both very cold and very hot temperatures
# Minimum consumption around 18°C (comfortable temperature)

# True parameters (unknown to students)
beta0_true <- 50      # Base consumption
beta1_true <- -2      # Linear effect
beta2_true <- 0.1     # Quadratic effect

# Generate consumption with quadratic relationship + noise
consumption <- beta0_true + 
               beta1_true * temperature + 
               beta2_true * temperature^2 + 
               rnorm(n, mean = 0, sd = 3)  # Add some noise

# Ensure consumption is positive
consumption <- pmax(consumption, 5)

# Round to realistic values
consumption <- round(consumption, 1)

# Create data frame
energy_data <- data.frame(
  temperature = temperature,
  consumption = consumption
)

# Sort by temperature for better visualization
energy_data <- energy_data[order(energy_data$temperature), ]

# Reset row numbers
rownames(energy_data) <- NULL

# Display summary
cat("Energy Consumption Dataset Generated\n")
cat("====================================\n")
cat("Number of observations:", nrow(energy_data), "\n")
cat("Temperature range:", min(energy_data$temperature), "to", 
    max(energy_data$temperature), "°C\n")
cat("Consumption range:", min(energy_data$consumption), "to", 
    max(energy_data$consumption), "kWh\n")
cat("\nTrue relationship (hidden from students):\n")
cat("consumption = 50 - 2*temperature + 0.1*temperature^2 + noise\n")
cat("Minimum consumption at temperature ≈", -beta1_true/(2*beta2_true), "°C\n")

# Save to CSV
write.csv(energy_data, "energy_consumption.csv", row.names = FALSE)
cat("\nDataset saved as 'energy_consumption.csv'\n")

# Create a simple visualization
if (require(ggplot2, quietly = TRUE)) {
  library(ggplot2)
  
  p <- ggplot(energy_data, aes(x = temperature, y = consumption)) +
    geom_point(alpha = 0.6, color = "steelblue", size = 2) +
    geom_smooth(method = "lm", formula = y ~ poly(x, 2), 
                se = TRUE, color = "red", alpha = 0.3) +
    labs(title = "Energy Consumption vs Temperature",
         subtitle = "Synthetic dataset for gradient descent assignment",
         x = "Temperature (°C)",
         y = "Energy Consumption (kWh)") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold"))
  
  print(p)
  
  # Save plot
  ggsave("data_preview.png", plot = p, width = 8, height = 6, dpi = 150)
  cat("Preview plot saved as 'data_preview.png'\n")
}

# Display first few rows
cat("\nFirst 10 rows of the dataset:\n")
print(head(energy_data, 10))

# Basic statistics
cat("\nBasic Statistics:\n")
cat("================\n")
print(summary(energy_data))

# Correlation
cat("\nCorrelation between temperature and consumption:", 
    round(cor(energy_data$temperature, energy_data$consumption), 3), "\n")
