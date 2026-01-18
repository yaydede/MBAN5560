# Function to perform kernel smoothing and return a prediction function
create_kernel_smoother <- function(x, y, bandwidth = NULL, kernel_type = "gaussian") {
  # Order the data
  ord <- order(x)
  x <- x[ord]
  y <- y[ord]
  
  # Set default bandwidth using Silverman's rule if not provided
  if (is.null(bandwidth)) {
    bandwidth <- 0.9 * min(sd(x), IQR(x)/1.34) * length(x)^(-0.2)
  }
  
  # Define kernel functions
  kernels <- list(
    gaussian = function(x) dnorm(x, sd = 1),
    epanechnikov = function(x) ifelse(abs(x) <= 1, 3/4 * (1 - x^2), 0),
    triangular = function(x) ifelse(abs(x) <= 1, 1 - abs(x), 0)
  )
  
  kernel_fn <- kernels[[kernel_type]]
  
  # Create prediction function
  predict_fn <- function(new_x) {
    sapply(new_x, function(x0) {
      # Calculate scaled distances
      scaled_dist <- (x - x0) / bandwidth
      
      # Calculate weights
      weights <- kernel_fn(scaled_dist)
      weights <- weights / sum(weights)
      
      # Return weighted average
      sum(y * weights)
    })
  }
  
  # Return a list containing the prediction function and metadata
  structure(list(
    predict = predict_fn,
    x = x,
    y = y,
    bandwidth = bandwidth,
    kernel_type = kernel_type
  ), class = "kernel_smoother")
}

# Example usage:
set.seed(123)
x <- sort(runif(100) * 2 * pi)
y <- sin(x) + rnorm(100, 0, 0.2)

# Create smoother
smoother <- create_kernel_smoother(x, y, bandwidth = 0.5)

# Generate predictions for new data
new_x <- seq(min(x), max(x), length.out = 200)
predicted_y <- smoother$predict(new_x)

# Plot original data and smoothed line
plot(x, y, pch = 16, col = "gray", main = "Kernel Smoothing Example")
lines(new_x, predicted_y, col = "red", lwd = 2)

# Example of how to use the smoothed function for prediction
new_point <- 6
predicted_value <- smoother$predict(new_point)
points(new_point, predicted_value, col = "blue", pch = 16, cex = 2)


