# Simulated data
n = 1000
set.seed(1)
x <- sort(runif(n) * 2 * pi)
y <- sin(x) + rnorm(n) / 4
data <- data.frame(y, x)

grid <- expand.grid(seq(from = 0.01, to = 1, by = 0.05), c(1, 2))
RMSPE_test <- c()

for (l in 1:10) {
  
  # Training-test split
  set.seed(10 + l)
  ind <- sample(nrow(data), 0.80 * nrow(data), replace = FALSE)
  test <- data[-ind, ]
  modata <- data[ind, ]
  
  merror <- c()
  
  for (s in 1:nrow(grid)) {
    
    rmspe <- c()
    
    # k-CV, which is the same as before
    k = 10
    folds <- sample(cut(seq(1, nrow(modata)), breaks = k, labels = FALSE))
    
    for (i in 1:k) {
      testIndexes <- which(folds == i, arr.ind = TRUE)
      val <- modata[testIndexes, ]
      train <- modata[-testIndexes, ]
    
        model <- loess(
          y ~ x,
          control = loess.control(surface = "direct"),
          degree = grid[s, 2],
          span = grid[s, 1],
          data = train
        )
      
      cat("Loops: ", l, s, i, "\r")    
      rmspe[i] <- sqrt(mean((val$y - predict(model, val$x)) ^ 2))
    }

    merror[s] <- mean(rmspe)
  }
  
  # Tuned hyperparameters
  opt_degree <- grid[which.min(merror), 2]
  opt_span <- grid[which.min(merror), 1]
  
  # Using the tuned parameters in testset for final evaluation
  model <- loess(
    y ~ x,
    control = loess.control(surface = "direct"),
    degree = opt_degree,
    span = opt_span,
    data = modata
  )
  fit <- predict(model, test$x)
  RMSPE_test[l] <- sqrt(mean((test$y - fit) ^ 2))
}  
mean(RMSPE_test)