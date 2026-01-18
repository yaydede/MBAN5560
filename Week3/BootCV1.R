# Data
n = 1000
set.seed(1)
x <- sort(runif(n) * 2 * pi)
y <- sin(x) + rnorm(n) / 4
data <- data.frame(y, x)
plot (x, y, col = "pink")

grid <- expand.grid(seq(from = 0.5, to = 0.8, by = 0.02), c(1, 2))

mean_rmspe <- c()

for (i in 1:nrow(grid)) {
  
  rmspe <- c()
  
  for (j in 1:50) {
    ind <- unique(sample(nrow(data), nrow(data), replace = TRUE))
    train <- data[ind,]
    val <- data[-ind,]

    model <- loess(
      y ~ x,
      control = loess.control(surface = "direct"),
      degree = grid[i, 2],
      span = grid[i, 1],
      data = train
    )
    
    cat("K-fold loop: ", i, j, "\r")
    
    yhat <- predict(model, val)
    rmspe[j] <- sqrt(mean((val$y - yhat) ^ 2))
  }
  mean_rmspe[i] <- mean(rmspe)
}

grid[which.min(mean_rmspe), ]
