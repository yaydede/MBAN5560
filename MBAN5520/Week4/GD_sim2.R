# Example: Visualizing Steepest Descent on a Quadratic Function

# Define the cost function: f(x, y) = (x - 2)^2 + (y - 3)^2
# This function has a global minimum at (2, 3)
f <- function(x, y) {
  (x - 2)^2 + (y - 3)^2
}

# Define the gradient of the function
grad_f <- function(x, y) {
  # Partial derivatives: df/dx = 2*(x - 2), df/dy = 2*(y - 3)
  c(2 * (x - 2), 2 * (y - 3))
}

# Create a grid for contour plotting
x_seq <- seq(-5, 10, length.out = 100)
y_seq <- seq(-5, 10, length.out = 100)
z <- outer(x_seq, y_seq, FUN = function(x, y) f(x, y))

# Set up the initial point for gradient descent (start far from the minimum)
current_point <- c(8, -2)

# Set the learning rate
alpha <- 0.1

# Plot the contour map of the cost function
contour(x_seq, y_seq, z, nlevels = 30,
        xlab = "x", ylab = "y", 
        main = "Steepest Descent Path (Live Animation)")
# Mark the global minimum
points(2, 3, pch = 19, col = "red")
# Mark the initial point
points(current_point[1], current_point[2], pch = 19, col = "blue")

# Number of iterations for the demonstration
num_iterations <- 50

# To store the path (for later use if needed)
path <- matrix(current_point, ncol = 2)

# Run the gradient descent loop and update the plot in real time
for (i in 1:num_iterations) {
  # Calculate the gradient at the current point
  grad <- grad_f(current_point[1], current_point[2])
  
  # Compute the next point using the steepest descent update rule
  next_point <- current_point - alpha * grad
  
  # Draw a line segment from the current point to the next point
  segments(current_point[1], current_point[2], next_point[1], next_point[2],
           col = "blue", lwd = 2)
  
  # Plot the new point
  points(next_point[1], next_point[2], pch = 19, col = "blue")
  
  # Update the current point for the next iteration
  current_point <- next_point
  path <- rbind(path, current_point)
  
  # Pause briefly to simulate live updates (adjust sleep time as desired)
  Sys.sleep(0.2)
}

# Optionally, you could add a legend
legend("topright", legend = c("Minimum", "Descent Path"),
       pch = c(19, NA), lwd = c(NA, 2), col = c("red", "blue"))
