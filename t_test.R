# t-test vs KS-tests - a comparison

set.seed(42)
### rnorm
group_a <- rnorm(n = 20, mean = 0, sd = 1)
group_b <- rnorm(n = 20, mean = 0, sd = 3)

df <- data.frame("group_a" = as.numeric(group_a),
                 "group_b" = as.numeric(group_b))

dplyr::glimpse(df)

t_a <- round(mean(df$group_a), 5)
t_b <- round(mean(df$group_b), 5)

library(tidyverse)

# Plot the two distributions
df %>%
  ggplot(aes(x = group_a)) +
  geom_histogram(alpha = .25, fill = "blue") +
  geom_vline(xintercept = t_a, color = "blue") +
  geom_text(aes(x = t_a, label = t_a),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "blue") +
  geom_histogram(aes(x = group_b), alpha = .25, fill = "red") +
  geom_vline(xintercept = t_b, color = "red") +
  geom_text(aes(x = t_b, label = t_b),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "red") +
  ggtitle("Historgram of two sammple normal groups with rounded mean on v-lines")

# 1. Welch Two Sample t-test for mean
res <- t.test(x = df$group_a,
              y = df$group_b,
              mu = 0, # diff of means
              aternative = "two.sided",
              conf.level = 0.95,
              var.equal = FALSE) # Welch approximation to the degrees of freedom is used

res
print(res$p.value)

# 1b. Student Two Sample t-test for mean
res1 <- t.test(x = df$group_a,
              y = df$group_b,
              mu = 0, # diff of means
              aternative = "two.sided",
              conf.level = 0.95,
              var.equal = TRUE) # Pooled variance is used to estimate the variance

res1
print(res1$p.value)
# cannot reject the h0 of 0 diff in mean


# 2. KS (Kolmogovor-Smirnov) test - a non-parametric and distribution free test.
res2 <- ks.test(x = df$group_a,
                y = df$group_b,
                alternative = "two.sided")


res2
print(res2$p.value) # 0.03354
# What is the implication of this?

# Ref - Lue valmiiks
# https://towardsdatascience.com/when-to-use-the-kolmogorov-smirnov-test-dd0b2c8a8f61


### lognorm
#group_a1 <- rlnorm(n=20, meanlog=3, sdlog=10)
#group_b1 <- rlnorm(n=20, meanlog=8, sdlog=10)
group_a1 <- rlnorm(n = 200, meanlog = 0, sdlog = 1)
group_b1 <- rlnorm(n = 200, meanlog = 0, sdlog = 1.1)

df2 <- data.frame("group_a1" = as.numeric(group_a1),
                  "group_b1" = as.numeric(group_b1))

t_a1 <- round(mean(df2$group_a1), 5)
t_b1 <- round(mean(df2$group_b1), 5)

df2 %>%
  filter(group1_a1 < 3) %>%
  ggplot(aes(x = group_a1)) +
  geom_histogram(alpha = .25, fill = "blue") +
  geom_vline(xintercept = t_a1, color = "blue") +
  geom_text(aes(x = t_a1, label = t_a1),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "blue") +
  geom_histogram(aes(x = group_b1), alpha = .25, fill = "red") +
  geom_vline(xintercept = t_b1, color = "red") +
  geom_text(aes(x = t_b1, label = t_b1),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "red") +
  ggtitle("Historgram of two sample lognormal groups with rounded mean on v-lines")

# exp log vals
df2 <- df2 %>%
  mutate(group_a1_exp = exp(group_a1)) %>%
  mutate(group_b1_exp = exp(group_b1))

t_a1_exp <- round(mean(df2$group_a1_exp), 5)

df2 %>%
  filter(group_a1 < 3) %>%
  filter(group_b1 < 3) %>%
  ggplot(aes(x = group_a1)) +
  geom_histogram(alpha = .25, fill = "blue") +
  geom_vline(xintercept = t_a1, color = "blue") +
  geom_text(aes(x = t_a1, label = t_a1),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "blue") +
  geom_histogram(aes(x = group_a1_exp), alpha = .25, fill = "red") +
  geom_vline(xintercept = t_a1_exp, color = "red") +
  geom_text(aes(x = t_a1_exp, label = t_a1_exp),
            y = 0.5, angle = 90, vjust = -0.2, size = 3, color = "red") +
  ggtitle("Historgram of two sample lognormal groups with rounded mean on v-lines")
