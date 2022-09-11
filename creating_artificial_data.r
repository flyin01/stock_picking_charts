# Creating artificial data

library(tibble)
library(ggplot2)

set.seed(42)
#mu <- 0
#sigma <- 0.1

# This is our predefined function
f <- function(x) 3*x^2 + 2*x + 1

# Adding noise to a point along a defined function is a way to create artificial dataset to test model fitting
noise <- function(x, scale) {rnorm(n = length(x), mean = 0, sd = scale)}
add_noise <- function(x, mult, add) {x * (1 + noise(x, mult)) + noise(x, add)}

x <- seq(-2, 2, length.out = 20)
y <- add_noise(f(x), 0.3, 1.5)

tibble(x=x, y=y) %>%
  ggplot(aes(x,y)) +
  geom_point(colour = "dark blue", size = 3) +
  geom_function(fun = f, colour = "red", size = 0.8)


# Another linear predefined function
f <- function(x) - 1.2*x + 1

# store data to df
df <-tibble(x=x,y=y)
head(df)

# fit linear model
mod <- lm(formula = y ~ x, data=df)
summary(mod)

# add 2nd order term
df$x2 = df$x^2

mod2 <- lm(formula = y ~ x + x2, data=df)
summary(mod2)
