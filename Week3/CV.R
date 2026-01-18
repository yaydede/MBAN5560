# Simulate data
n = 10000
set.seed(1)
x <- sort(runif(n)*2*pi)
y <- sin(x) + rnorm(n)/4
data <- data.frame(y, x)

# 10-fold cross-validation
k = 10
set.seed(123) 
data <- data[sample(nrow(data)), ]
folds <- cut(seq(1, n), breaks = k, labels = FALSE)

# let's see what cut does
groups <- cut(1:100, breaks = 10, labels = FALSE)
print(groups)

groups <- sample(cut(1:100, breaks = 10, labels = FALSE))
print(groups)
table(groups)

n = 9941  # Not evenly divisible by 10
k = 10
folds <- cut(seq(1, n), breaks = k, labels = FALSE)
table(folds)

# Initialize Mean Squared Prediction Error
mspe <- numeric(k)

for (i in 1:k) {
  testIndexes <- which(folds == i, arr.ind = TRUE)
  test <- data[testIndexes, ]
  train <- data[-testIndexes, ]
  model <- lm(y ~ poly(x, 4), data = train)
  predictions <- predict(model, test)
  mspe[i] <- mean((test$y - predictions)^2)
}

# Or with sapply

mspe_2 <- sapply(1:10, function(i) {
  testIndexes <- which(folds == i, arr.ind = TRUE)
  test <- data[testIndexes, ]
  train <- data[-testIndexes, ]
  model <- lm(y ~ poly(x, 4), data = train)
  predictions <- predict(model, test)
  mean((test$y - predictions)^2)
})

# Or with lapply

mspe_3 <- unlist(lapply(1:10, function(i) {
  testIndexes <- which(folds == i, arr.ind = TRUE)
  test <- data[testIndexes, ]
  train <- data[-testIndexes, ]
  model <- lm(y ~ poly(x, 4), data = train)
  predictions <- predict(model, test)
  mean((test$y - predictions)^2)
}))

# long way to do that

nvalidate <- round(n / k)
#Shuffle the order of observations by their index
set.seed(123)
mysample <- sample(nrow(data))
mspe_4 <- c() 

#loop
for (i in 1:k) {
  if (i < k) {
    ind_val <- mysample[((i - 1) * nvalidate + 1):(i * nvalidate)]
  } else{
    ind_val <- mysample[((i - 1) * nvalidate + 1):n]
  }
  cat("loop: ", i, "\r") # Counter, no need it in practice
  
  val <- data[ind_val, ]
  train <- data[-ind_val, ]
  
  model <- lm(y ~ poly(x, 4), data = train)
  predictions <- predict(model, test)
  mspe_4[i] <- mean((test$y - predictions)^2)
}