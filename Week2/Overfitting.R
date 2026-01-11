###### Simulate data ######
# Training data
set.seed(1)
x <- seq(from = 0, to = 20, by = 0.1)
dgm <- 500 + 20*x - 90*sin(x)                 # deterministic part

n <- length(x)
y <- dgm + rnorm(n, mean = 0, sd = 100)       # stochastic part  
df_train = data.frame(y, x)

plot(x, y, col='deepskyblue4',
     xlab='x', main='Observed data', ylab='y')

# Test data
set.seed(2)
x_test <- seq(from = 0, to = 20, by = 0.1)
dgm <- 500 + 20*x - 90*sin(x)                 # deterministic part

n_test <- length(x_test)
y_test <- dgm + rnorm(n, mean = 10, sd = 100)       # stochastic part
df_test = data.frame(y_test, x_test)

plot(x_test, y_test, col='red',
     xlab='x_test', main='Unobserved data', ylab='y_test')

###### Using Training data ######
# linear model #
model1 <- lm(y ~ x, data = df_train)
summary(model1)

plot(x, y, col='deepskyblue4', xlab ='x', main = 'Linear')
lines(x, model1$fitted.values, col = "blue", lwd=2)

# Polynomial model #
model2 <- lm(y ~ poly(x, 19), data = df_train)
summary(model2)

plot(x, y, col='deepskyblue4', xlab ='x', main = 'Polynomial')
lines(x, model2$fitted.values, col = "green", lwd=2)

# Nonparametric model: Smooth Spline #
model3 <- lm(y ~ splines::bs(x, df = 200), data = df_train)
summary(model3)

plot(x, y, col='deepskyblue4', lwd = 0.5, xlab ='x', main = 'Smooth spline')
lines(x, model3$fitted.values, col = "red", lwd=2)

# Training RMSPE #
RMSPE1 <- sqrt(mean((y - model1$fitted.values)^2))
RMSPE2 <- sqrt(mean((y - model2$fitted.values)^2))
RMSPE3 <- sqrt(mean((y - model3$fitted.values)^2))
RMSPE <- c(RMSPE1, RMSPE2, RMSPE3)
names(RMSPE) <- c("Linear", "Polynomial", "Smooth spline")
RMSPE

###### Using the models on Test data ######
# Linear model #
y_pred1 <- predict(model1, newdata = df_test)
RMSPE1 <- sqrt(mean((y_test - y_pred1)^2))

# Polynomial model #
y_pred2 <- predict(model2, newdata = df_test)
RMSPE2 <- sqrt(mean((y_test - y_pred2)^2))

# Nonparametric model: Smooth Spline #
y_pred3 <- predict(model3, newdata = df_test)
RMSPE3 <- sqrt(mean((y_test - y_pred3)^2))

# Test RMSPE #
RMSPE <- c(RMSPE1, RMSPE2, RMSPE3)
names(RMSPE) <- c("Linear", "Polynomial", "Smooth spline")
RMSPE



