# bayesian linear regression

library(tidyverse)
library(rstanarm)
library(broom.mixed)

# check R version
cat(paste0(R.version[6],".",R.version[7]))

data(mtcars)
mtcars %>%
  dplyr::glimpse()

# plot hp vs mpg
mtcars %>%
  ggplot2::ggplot(aes(x=hp, y=mpg)) +
  ggplot2::geom_point()


# fit model
stan_model <- rstanarm::stan_glm(mpg ~ hp,
                                 data = mtcars)

# inspect model
broom.mixed::tidy(stan_model)
