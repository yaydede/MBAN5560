# Bootstrapping

# Out of bag (OOB) percentage
a <- 1:100

# Bootstrap
b <- sample(a, 100, replace = TRUE)

b_unique <- unique(b)
length(b_unique)/length(b)

oob <- setdiff(a, b_unique)
length(oob)/length(a)

# Splitting a data frame with bootstrapping

# Simulate data
set.seed(123)
x <- rnorm(100)
y <- 2*x + rnorm(100)
df <- data.frame(x, y)

# Bootstrap
ind <- sample(nrow(df), nrow(df), replace = TRUE)
train <- df[ind, ]
test <- df[-ind, ]

