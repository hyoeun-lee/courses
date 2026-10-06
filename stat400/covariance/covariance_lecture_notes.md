# STAT 400 -- Covariance, Variance and Correlation (lecture notes)

Companion R code: `covariance_simulation.R` (Demos 1-6).

## 0. Flow (about 50 min)

| Time | Piece |
|---|---|
| 5 min | Motivation: variance measures spread of ONE variable; how do two vary together? |
| 10 min | Definition + intuition via the quadrant picture (R Demo 1, 2) |
| 15 min | Worked discrete example (below), done by hand with the shortcut formula |
| 5 min | Correlation and units (Demo 3) |
| 5 min | Var(X+Y) (Demo 4) |
| 5 min | Cov = 0 does not mean independent (Demo 5) + clicker questions |

## 1. Definitions

- Variance: Var(X) = E[(X - mu_X)^2] = E[X^2] - (E X)^2
- Covariance: **Cov(X,Y) = E[(X - mu_X)(Y - mu_Y)] = E[XY] - E[X]E[Y]**
- Correlation: **rho = Corr(X,Y) = Cov(X,Y) / (sigma_X sigma_Y)**, always in [-1, 1]
- Cov(X,X) = Var(X): variance is covariance of a variable with itself.

**Intuition (quadrants).** Draw lines at mu_X and mu_Y. In the upper-right and lower-left,
(x - mu_X)(y - mu_Y) > 0; in the other two it is < 0. Covariance is the average
product: positive if points mostly lie in the "positive" quadrants, negative if in the
other two, near 0 if balanced.

## 2. Worked example (discrete, by hand)

Joint pmf p(x,y):

| | y=0 | y=1 | y=2 | p_X(x) |
|---|---|---|---|---|
| **x=0** | 0.2 | 0.1 | 0.0 | 0.3 |
| **x=1** | 0.1 | 0.3 | 0.1 | 0.5 |
| **x=2** | 0.0 | 0.1 | 0.1 | 0.2 |
| **p_Y(y)** | 0.3 | 0.5 | 0.2 | 1 |

Context to tell: X = number of late assignments, Y = number of missed lectures for a
student (high X tends to go with high Y).

1. Marginal means: E[X] = 0(.3)+1(.5)+2(.2) = **0.9**; likewise E[Y] = **0.9**.
2. E[XY] = 1*1*.3 + 1*2*.1 + 2*1*.1 + 2*2*.1 = .3+.2+.2+.4 = **1.1**
   (cells with x=0 or y=0 contribute 0).
3. **Cov(X,Y) = 1.1 - 0.9*0.9 = 0.29 > 0.**
4. E[X^2] = 0+.5+.8 = 1.3, so Var(X) = 1.3 - .81 = **0.49**, sigma_X = 0.7; same for Y.
5. **Corr = 0.29 / (0.7*0.7) = 0.592.**

Quick independence check to tie back to last week: P(X=0,Y=0) = 0.2 but
p_X(0)p_Y(0) = 0.09, so X and Y are dependent -- consistent with Cov != 0.

*Student exercise:* change p(0,0) and p(1,1) so X, Y become independent
(e.g. p(x,y) = p_X(x)p_Y(y)) and confirm Cov = 0.

## 3. Key properties (state, then verify with simulation)

- Cov(aX + b, cY + d) = ac Cov(X,Y) -- covariance depends on units; **correlation does not** (up to sign of ac). Demo 3.
- **Var(X + Y) = Var(X) + Var(Y) + 2 Cov(X,Y)**; Var(X - Y) = Var X + Var Y - 2 Cov. If independent, the cov term vanishes. Demo 4.
- Independent => Cov = 0, **but not conversely**. Counterexample: X uniform on {-1,0,1}, Y = X^2.
  E[X]=0, E[XY]=E[X^3]=0, so Cov = 0, yet Y is a function of X. Demo 5 shows the continuous version.
- |rho| = 1 iff Y = aX + b exactly (a != 0). Correlation measures **linear** association only.

## 4. A second, quick example (continuous, optional)

f(x,y) = x + y on [0,1]^2. E[X]=E[Y]=7/12, E[XY] = 1/3, so
Cov = 1/3 - 49/144 = **-1/144**, Var(X) = 5/12 - 49/144 = 11/144, rho = **-1/11** (slightly
negative: a larger x makes large y a bit less likely than under a uniform).

## 5. Clicker / discussion questions

1. If Var(X)=4, Var(Y)=9, Cov(X,Y)=3, find Var(X+Y) (= 4+9+6 = 19) and Corr (= 3/6 = 0.5).
2. Cov(X,Y) = 2 in inches*pounds. Does converting height to cm change the correlation? (No.)
3. Can Corr = 0.9 and Cov = -3? (No: same sign.)
4. Shoe size and reading ability among elementary-school kids are positively correlated. Does buying bigger shoes help reading? (Confounding by age; correlation is not causation.)
5. Sketch a scatterplot with Corr = 0 but clear dependence.

## 6. Common pitfalls

- Forgetting the covariance can be any real number while correlation is in [-1, 1].
- Treating "uncorrelated" as "independent" (true only for jointly normal variables, a fact to preview later).
- Using E[XY] alone: it is Cov + E[X]E[Y]; centered products are what matter.
