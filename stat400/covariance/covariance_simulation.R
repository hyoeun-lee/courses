# STAT 400 -- Covariance, Variance, Correlation: classroom simulations
# Base R only. Run top to bottom; each "Demo" is independent.
set.seed(400)

## ---- Demo 1: What does covariance "look like"? -------------------------
# Same marginals (X, Y ~ N(0,1)), different dependence. Cov(X,Y) = rho here.
n <- 2000
sim_pair <- function(rho, n) {
  x <- rnorm(n)
  y <- rho * x + sqrt(1 - rho^2) * rnorm(n)   # Var(Y)=1, Cov(X,Y)=rho
  cbind(x, y)
}
rhos <- c(-0.9, -0.5, 0, 0.5, 0.9)
par(mfrow = c(1, 5), mar = c(4, 4, 3, 1))
for (r in rhos) {
  d <- sim_pair(r, n)
  plot(d, pch = 16, cex = 0.4, col = rgb(0, 0, 0, 0.3), xlim = c(-4, 4), ylim = c(-4, 4),
       main = sprintf("rho = %.1f\nsample cor = %.2f", r, cor(d[, 1], d[, 2])))
  abline(h = mean(d[, 2]), v = mean(d[, 1]), col = "red", lty = 2)  # quadrants!
}
par(mfrow = c(1, 1))
# Talking point: red lines cut the plot into 4 quadrants. (x-mu_x)(y-mu_y) > 0 in
# upper-right/lower-left, < 0 in the other two. Cov = average of those products.

## ---- Demo 2: Covariance as an average of products (by hand vs cov()) ----
d <- sim_pair(0.7, 500); x <- d[, 1]; y <- d[, 2]
prod_dev <- (x - mean(x)) * (y - mean(y))
sum(prod_dev) / (length(x) - 1)    # sample covariance by hand
cov(x, y)                          # identical
# Color points by the sign of the product
plot(x, y, pch = 16, col = ifelse(prod_dev > 0, "blue", "red"),
     main = "Blue: product > 0   Red: product < 0")
abline(h = mean(y), v = mean(x))

## ---- Demo 3: Covariance depends on units; correlation does not ---------
height_in <- rnorm(300, 68, 3)
weight_lb <- 150 + 4 * (height_in - 68) + rnorm(300, 0, 15)
c(cov_in_lb  = cov(height_in, weight_lb),
  cov_cm_kg  = cov(height_in * 2.54, weight_lb * 0.4536),   # changes!
  cor_in_lb  = cor(height_in, weight_lb),
  cor_cm_kg  = cor(height_in * 2.54, weight_lb * 0.4536))   # same!

## ---- Demo 4: Var(X+Y) = Var X + Var Y + 2 Cov(X,Y) ---------------------
# Why portfolios / sums of dependent variables are not "just add the variances".
for (rho in c(-0.8, 0, 0.8)) {
  d <- sim_pair(rho, 1e5); x <- d[, 1]; y <- d[, 2]
  cat(sprintf("rho=%+.1f  var(X+Y)=%.3f  var(X)+var(Y)+2cov=%.3f  var(X)+var(Y)=%.3f\n",
              rho, var(x + y), var(x) + var(y) + 2 * cov(x, y), var(x) + var(y)))
}

## ---- Demo 5: Cov = 0 does NOT imply independence -----------------------
x <- runif(5000, -1, 1); y <- x^2          # Y is a function of X!
c(cov = cov(x, y), cor = cor(x, y))        # approximately 0
plot(x, y, pch = 16, cex = 0.4, main = "Perfectly dependent, yet cor ~ 0")
# Correlation only measures LINEAR association.

## ---- Demo 6: Check the discrete worked example from the notes ----------
p <- matrix(c(.2, .1, 0,
              .1, .3, .1,
              0,  .1, .1), nrow = 3, byrow = TRUE,
            dimnames = list(X = 0:2, Y = 0:2))
vals <- 0:2
EX <- sum(vals * rowSums(p)); EY <- sum(vals * colSums(p))
EXY <- sum(outer(vals, vals) * p)
covXY <- EXY - EX * EY
varX <- sum(vals^2 * rowSums(p)) - EX^2
varY <- sum(vals^2 * colSums(p)) - EY^2
c(EX = EX, EY = EY, EXY = EXY, Cov = covXY, VarX = varX, VarY = varY,
  Corr = covXY / sqrt(varX * varY))        # 0.9, 0.9, 1.1, 0.29, 0.49, 0.49, 0.592
# Simulate from the table and compare
# Rows of t(p) run over x slowest, y fastest; make the cell list in the same order
cells <- expand.grid(Y = vals, X = vals)[, c("X", "Y")]
idx <- sample(nrow(cells), 1e5, replace = TRUE, prob = as.vector(t(p)))
s <- cells[idx, ]
c(cov = cov(s$X, s$Y), cor = cor(s$X, s$Y))                           # ~0.29, ~0.59
