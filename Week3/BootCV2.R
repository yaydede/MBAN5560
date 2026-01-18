# Data
n = 1000
set.seed(1)
x <- sort(runif(n) * 2 * pi)
y <- sin(x) + rnorm(n) / 4
data <- data.frame(y, x)
#plot (x, y, col = "pink")

grid <- expand.grid(seq(from = 0.5, to = 0.8, by = 0.02), c(1, 2))
frmspe <- c()

for (t in 1:8) {
  mean_rmspe <- c()
  
  testid <- sample(nrow(data), nrow(data) * 0.2)
  test <- data[testid, ]
  mdata <- data[-testid, ]
  
  for (i in 1:nrow(grid)) {
    rmspe <- c()
    
    for (j in 1:20) {
      
      cat("Loops: ", t, i, j, "\r")
      
      ind <- sample(nrow(mdata), nrow(mdata), replace = TRUE)
      ind <- unique(ind)
      
      train <- mdata[ind, ]
      val <- mdata[-ind, ]
      
      model <- loess(
        y ~ x,
        control = loess.control(surface = "direct"),
        degree = grid[i, 2],
        span = grid[i, 1],
        data = train
      )
      
      yhat <- predict(model, val)
      rmspe[j] <- sqrt(mean((val$y - yhat) ^ 2))
    }
    mean_rmspe[i] <- mean(rmspe)
  }
  
  opt <- which.min(mean_rmspe)
  fmodel <- loess(
    y ~ x,
    control = loess.control(surface = "direct"),
    degree = grid[opt, 2],
    span = grid[opt, 1],
    data = train
  )
  yhat <- predict(fmodel, test)
  frmspe[t] <- sqrt(mean((test$y - yhat) ^ 2))
}