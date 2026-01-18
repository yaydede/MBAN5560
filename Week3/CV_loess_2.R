# Simulated data
n = 1000
set.seed(1)
x <- sort(runif(n) * 2 * pi)
y <- sin(x) + rnorm(n) / 4
data <- data.frame(y, x)
plot(x, y)

grid <- expand.grid(seq(from = 0.01, to = 1, by = 0.05), c(1, 2))
RMSPE_test <- c() 

for (l in 1:10) {
  
  # Training-test split
  set.seed(10 + l)
  ind <- sample(nrow(data), 0.80 * nrow(data), replace = FALSE)
  test <- data[-ind, ]
  modata <- data[ind, ]
  
  # k-CV, which is the same as before
  k = 10
  folds <- sample(cut(seq(1, nrow(modata)), breaks = k, labels = FALSE))
  
  OPT <- c()
  
  for (i in 1:k) {
    testIndexes <- which(folds == i, arr.ind = TRUE)
    val <- modata[testIndexes, ]
    train <- modata[-testIndexes, ]
    
    RMSPE <- c()
    
    for (s in 1:nrow(grid)) {
      
      cat("Loops: ", l, i, s, "\r")
      
      model <- loess(
        y ~ x,
        control = loess.control(surface = "direct"),
        degree = grid[s, 2],
        span = grid[s, 1],
        data = train
      )
      
      fit <- predict(model, val$x)
      RMSPE[s] <- sqrt(mean((val$y - fit) ^ 2))
    }
    OPT[i] <- which.min(RMSPE)
  }
  
  # Hyperparameters
  opgrid <- grid[OPT, ]
  colnames(opgrid) <- c("span", "degree")
  rownames(opgrid) <- c(1:10)
  opt_degree <- raster::modal(opgrid[, 2])
  opt_span <- mean(opgrid[, 1])
  
  # **** Using the test set for final evaluation ******
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