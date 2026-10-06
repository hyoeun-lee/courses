# STAT 400 -- Covariance through everyday experiments (companion to
# covariance_concepts_experiments.md). Base R only; section numbers match.
set.seed(400)

## ---- Experiment 1: two dice -------------------------------------------
# Exact: enumerate all 36 equally likely outcomes
o <- expand.grid(d1 = 1:6, d2 = 1:6)
o$s <- o$d1 + o$d2; o$gap <- abs(o$d1 - o$d2); o$mx <- pmax(o$d1, o$d2)
pop_cov <- function(a, b) mean(a * b) - mean(a) * mean(b)   # equally likely outcomes
pop_cor <- function(a, b) pop_cov(a, b) / sqrt(pop_cov(a, a) * pop_cov(b, b))
rbind(`d1,d2`  = c(pop_cov(o$d1, o$d2),  pop_cor(o$d1, o$d2)),   # 0, 0
      `d1,sum` = c(pop_cov(o$d1, o$s),   pop_cor(o$d1, o$s)),    # 2.917, 0.707
      `d1,max` = c(pop_cov(o$d1, o$mx),  pop_cor(o$d1, o$mx)),   # 1.458, 0.608
      `sum,gap`= c(pop_cov(o$s, o$gap),  pop_cor(o$s, o$gap)))   # 0, 0 (but dependent!)
# Dependence check for (sum, gap): P(sum=2, gap=0) vs P(sum=2) P(gap=0)
c(joint = mean(o$s == 2 & o$gap == 0), product = mean(o$s == 2) * mean(o$gap == 0))
# Simulation version: do the experiment 10,000 times
n <- 1e4; a <- sample(6, n, TRUE); b <- sample(6, n, TRUE)
c(cor_d1_d2 = cor(a, b), cor_d1_sum = cor(a, a + b))

## ---- Experiment 2: guessing on a 10-question true/false quiz -----------
correct <- rbinom(5000, 10, 0.5); wrong <- 10 - correct
c(cov = cov(correct, wrong), cor = cor(correct, wrong))   # ~ -2.5, exactly -1
cor(correct, 5 * correct)                                  # +1: scale does not matter
plot(correct, wrong, pch = 16, col = rgb(0, 0, 0, .1), main = "Perfect negative correlation")

## ---- Experiment 3: two cards, with vs without replacement --------------
deck <- rep(c(1, 0), c(13, 39))                     # 1 = heart
draw2 <- function(replace) {
  i <- sample(52, 2, replace = replace); deck[i]
}
res_wo <- t(replicate(2e5, draw2(FALSE))); res_w <- t(replicate(2e5, draw2(TRUE)))
c(without_replacement = cov(res_wo[, 1], res_wo[, 2]),   # ~ -0.0037 (exact -1/272)
  with_replacement    = cov(res_w[, 1],  res_w[, 2]))    # ~ 0
c(corr_without = cor(res_wo[, 1], res_wo[, 2]))          # ~ -0.0196 (exact -1/51)

## ---- Experiment 4: commute = bus + walk, both slowed by rain -----------
n <- 1e5
rain <- rbinom(n, 1, 0.3)
bus  <- 20 + 10 * rain + rnorm(n, 0, 3)
walk <- 10 +  6 * rain + rnorm(n, 0, 2)
total <- bus + walk
c(var_bus = var(bus), var_walk = var(walk), cov = cov(bus, walk))   # 30, 11.56, 12.6
c(var_total = var(total),                          # 66.76
  if_independent = var(bus) + var(walk),           # 41.56
  with_cov = var(bus) + var(walk) + 2 * cov(bus, walk))
# Buffer needed to be on time 95% of the time
quantile(total, 0.95)
mean(total) + qnorm(.95) * sqrt(var(bus) + var(walk))   # naive (independent) answer: too small
# Shuffle 'walk' to break the link: same marginals, covariance gone
walk_shuf <- sample(walk); var(bus + walk_shuf)         # ~41.6
hist(total, breaks = 60, main = "Commute time", col = "grey80")

## ---- Experiment 5: temperature vs. energy use (U-shape) ----------------
temp   <- runif(3000, -15, 15)          # degrees from a comfortable 20C
energy <- abs(temp) + rnorm(3000, 0, 1)
c(cov = cov(temp, energy), cor = cor(temp, energy))   # ~ 0
plot(temp, energy, pch = 16, col = rgb(0, 0, 0, .25),
     xlab = "Outdoor temp minus 20C", ylab = "Energy use",
     main = sprintf("Strong relationship, correlation = %.2f", cor(temp, energy)))

## ---- Experiment 6: class survey (replace with your students' data) -----
# Fake data stand-in: read.csv("survey.csv") with columns height, shoe, sleep, study
height <- rnorm(60, 67, 4); shoe <- 0.9 * (height - 67) + 9 + rnorm(60, 0, 0.8)
sleep <- rnorm(60, 7, 1);   study <- pmax(0, 12 - 0.8 * sleep + rnorm(60, 0, 2))
c(cov_in = cov(height, shoe), cov_cm = cov(height * 2.54, shoe),   # covariance changes
  cor_in = cor(height, shoe), cor_cm = cor(height * 2.54, shoe))   # correlation does not
cor(sleep, study)                                                  # trade-off: negative
# Outlier demo
cor(c(height, 84), c(shoe, 16))
# Rank correlation is more robust to outliers (preview)
cor(c(height, 84), c(shoe, 16), method = "spearman")
