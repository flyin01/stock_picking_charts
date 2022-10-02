# t-test vs KS-tests - a comparison

group_a <- rnorm(n=20, mean=0, sd=1)
group_b <- rnorm(n=20, mean=0, sd=3)

set.seed(42)
df <- data.frame("group_a" = as.numeric(group_a),
                 "group_b" = as.numeric(group_b))

dplyr::glimpse(df)

t_a = round(mean(df$group_a),5)
t_b = round(mean(df$group_b),5)

# Plot the two distributions
df %>% 
  ggplot(aes(x=group_a)) +
  geom_histogram(alpha = .25, fill="blue") +
  geom_vline(xintercept = t_a, color="blue") +
  geom_text(aes(x=t_a, label=t_a),
            y=0.5, angle=90, vjust=-0.2, size=3, color="blue") +
  geom_histogram(aes(x=group_b), alpha=.25, fill="red") +
  geom_vline(xintercept = t_b, color="red") +
  geom_text(aes(x=t_b, label=t_b),
            y=0.5, angle=90, vjust=-0.2, size=3, color="red") +
  ggtitle("Historgram of two groups with rounded mean on v-lines")

# 1. Student´s t-test for mean
res <- t.test(x=df$group_a,
              y=df$group_b,
              mu=0, # diff of means
              aternative = "two.sided",
              conf.level = 0.95)

res

print(res$p.value)
# cannot reject the h0 of 0 diff in mean

# 2. KS (Kolmogovor-Smirnov) test - a non-parametric and distribution free test.
res2 <- ks.test(x=df$group_a,
                y=df$group_b,
                alternative = "two.sided")

res2
print(res2$p.value) # 0.03354
# What is the implication of this?

# Ref - Lue valmiiks
# https://towardsdatascience.com/when-to-use-the-kolmogorov-smirnov-test-dd0b2c8a8f61

