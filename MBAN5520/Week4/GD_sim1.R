# Visualizing Gradient Descent on MSE vs. Slope Coefficient

# 1. Generate synthetic data for a simple linear model with fixed intercept.
set.seed(1001)
N <- 1000
x1 <- rnorm(N, mean = 10, sd = 2)
true_slope <- 2
true_intercept <- 1
# Generate Y using a true model: Y = 1 + 2*x1 + noise
Y <- true_intercept + true_slope * x1 + rnorm(N, mean = 0, sd = 1)

# 2. Define the MSE function for the slope coefficient 'b', keeping intercept fixed.
mse <- function(b) {
  mean((Y - (true_intercept + b * x1))^2)
}

# 3. Define the derivative (gradient) of the MSE with respect to 'b'
#    Analytical derivative: d/d(b) MSE = -2 * mean(x1 * (Y - (1 + b*x1)))
grad_mse <- function(b) {
  -2 * mean(x1 * (Y - (true_intercept + b * x1)))
}

# 4. Pre-compute the MSE curve for a range of slope values for plotting
b_vals <- seq(0, 4, length.out = 200)
cost_vals <- sapply(b_vals, mse)

# 5. Set up the initial guess for the slope coefficient and learning rate.
b_current <- 5  # starting guess
alpha <- 0.001   # learning rate (adjust as needed)
num_iterations <- 120  # number of gradient descent steps

# 6. Create the initial plot of MSE vs. slope coefficient.
plot(b_vals, cost_vals, type = "l", lwd = 2, col = "black",
     xlab = "Slope Coefficient (b)", ylab = "Mean Squared Error (MSE)",
     main = "Gradient Descent on MSE vs. Slope Coefficient")
# Mark the true optimum
points(true_slope, mse(true_slope), pch = 19, col = "green")
# legend("topright", legend = c("True Minimum", "Current Point", "Tangent", "Update Step"),
#        pch = c(19, 19, NA, NA), lty = c(NA, NA, 2, 1), col = c("green", "blue", "blue", "red"))

# 7. Animate the gradient descent process.
for (i in 1:num_iterations) {
  # Calculate current MSE and its gradient at the current slope b_current.
  cost_current <- mse(b_current)
  grad_current <- grad_mse(b_current)
  
  # Mark the current point on the curve.
  points(b_current, cost_current, pch = 19, col = "blue")
  
  # Add marker on x-axis (bottom of plot)
  points(b_current, par("usr")[3], pch = 19, col = "orange")
  
  # Plot the tangent line at the current point.
  # Create a small window around b_current to display the tangent.
  b_tangent <- seq(b_current - 0.5, b_current + 0.5, length.out = 100)
  tangent_vals <- cost_current + grad_current * (b_tangent - b_current)
  lines(b_tangent, tangent_vals, col = "blue", lwd = 2, lty = 2)
  
  # Pause briefly to simulate live updates.
  Sys.sleep(1.2)
  
  # Compute the new slope using the gradient descent update rule.
  b_new <- b_current - alpha * grad_current
  cost_new <- mse(b_new)
  
  # Draw an arrow from the current point to the new point to indicate the update.
  arrows(b_current, cost_current, b_new, cost_new, col = "Red", lwd = 2, length = 0.1)
  
  # Update the current slope for the next iteration.
  b_current <- b_new
}