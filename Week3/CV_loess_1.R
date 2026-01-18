# Simulated data
n = 1000
set.seed(1)
x <- sort(runif(n) * 2 * pi)
y <- sin(x) + rnorm(n) / 4
data <- data.frame(y, x)
set.seed(NULL)

grid <- expand.grid(seq(from = 0.01, to = 1, by = 0.02), c(1, 2))
RMSPE <- c()

# Training-test split
#set.seed(Sys.time())  # Or Random new seed
ind <- sample(nrow(data), 0.80 * nrow(data), replace = FALSE)
train <- data[ind, ]
test <- data[-ind, ]
  
for (s in 1:nrow(grid)) {
    
  model <- loess(
            y ~ x,
            control = loess.control(surface = "direct"),
            degree = grid[s, 2],
            span = grid[s, 1],
            data = train
          )
      
  RMSPE[s] <- sqrt(mean((test$y - predict(model, test$x)) ^ 2))
}

# Tuned hyperparameters
grid[which.min(RMSPE), ]


