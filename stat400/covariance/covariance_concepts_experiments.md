# STAT 400 -- Covariance, Variance, Correlation: Concepts through Everyday Experiments

Goal: build the *meaning* of covariance before (or alongside) the formulas.
Each experiment is something students can do, imagine or simulate, and each one is
used to teach one idea. R code for all of them is in `covariance_experiments.R`
(section numbers match).

---

## Part A. The big ideas in plain language

**Variance = "how much does ONE thing bounce around its average?"**
Bus arrival time: if it is always exactly 8:00, variance is 0. If it ranges from 7:50 to 8:20, variance is large.
Units are squared (minutes^2), so we often report the standard deviation (minutes).

**Covariance = "when X bounces ABOVE its average, which way does Y tend to bounce?"**
- Y tends to be above its average too -> positive covariance ("move together")
- Y tends to be below its average -> negative covariance ("move opposite")
- Y shows no consistent pattern -> covariance near 0

Covariance is just the **average of (how far X is from its mean) x (how far Y is from its mean)**.
The product is positive when both are on the same side of their means, negative when on
opposite sides. Positive and negative products cancel when there is no pattern.

**Correlation = covariance with the units removed.**
Cov = 40 "inch-pounds" is hard to judge: is that a lot? Dividing by sigma_X * sigma_Y gives
a unit-free number between -1 and 1, where +/-1 means a perfect straight-line relationship.

**Three things to repeat all semester**
1. Covariance/correlation describe **linear** togetherness only.
2. Independent => covariance 0. The reverse is **false**.
3. Correlation is **not causation**.

---

## Experiment 1. Two dice (the "clean lab" experiment)
*Use first, because students already know the sample space (36 equally likely outcomes).*

Roll two fair dice. D1 = first die, D2 = second die, S = D1 + D2.

**Q1: Is Cov(D1, D2) positive, negative or zero?** The dice cannot influence each other.
Knowing D1 tells you nothing about D2, so Cov = 0 (independent).

**Q2: Cov(D1, S)?** Ask: "If the first die is high, is the sum likely high?" Obviously yes,
so the covariance is positive. Because S contains D1, we get

Cov(D1, S) = Cov(D1, D1) + Cov(D1, D2) = Var(D1) + 0 = **35/12 = 2.92**,
Corr(D1, S) = 2.92 / (sqrt(2.92) * sqrt(5.83)) = **0.707 = 1/sqrt(2)**.

Teaching point: *half* the variability of the sum comes from the first die (Var D1 / Var S = 1/2),
which is why the correlation is 0.707 (its square, 0.5, is the fraction of variance "shared").

**Q3 (cov = 0 but NOT independent): S = D1 + D2 and G = |D1 - D2| (the "gap").**
Compute Cov(S, G): exactly 0. By symmetry, a big sum is no more likely to have a big gap than
a small one. But if S = 2 (both dice show 1), then G must be 0, so they are clearly dependent.
Students *discover* the independence != uncorrelated caveat with a tiny sample space.

**Q4: D1 and M = max(D1, D2).** Cov = 1.46, Corr = 0.61. Ask for the *sign* first, then compute.

---

## Experiment 2. Guessing on a true/false quiz (perfect negative correlation)

A 10-question true/false quiz, a student guesses every answer (each correct with prob 1/2).
X = number correct, Y = number wrong. Obviously **Y = 10 - X**.

- Cov(X, Y) = -Var(X) = -10(1/4) = **-2.5**, Corr = **-1**.
- Teaching point: a perfect linear relationship with negative slope gives exactly -1,
  and the sign of the correlation is the sign of the slope.
- Follow-up: "X = number correct, Z = score on the quiz where each correct is worth 5 points" -> Corr = +1.
  *Units/scale changes (positive multiples) do not change correlation.*

Same idea: heads and tails in n coin flips, or "hours awake" vs "hours asleep" in a day.

---

## Experiment 3. Dealing cards (tiny dependence that still counts)

Deal 2 cards from a standard deck. X = 1 if card 1 is a heart, Y = 1 if card 2 is a heart.

- With replacement (shuffle back): independent, Cov = 0.
- Without replacement: P(X=1,Y=1) = (13/52)(12/51) = 0.0588 vs P(X=1)P(Y=1) = 0.0625.
  Cov = -1/272 = **-0.0037**, Corr = **-1/51 = -0.02**.

Teaching points: (1) dependence can be real yet very weak -- covariance quantifies *how much*;
(2) it gets weaker with more cards in the deck: sampling without replacement from a
huge population is nearly independent (this is why polls of 1,000 people work).
Ask: what happens with a 5-card deck with 2 hearts?

---

## Experiment 4. Commute time and rain (why Var(X+Y) needs covariance)
*The most useful "real-life" example for Var(X+Y) = Var X + Var Y + 2Cov.*

Your trip = bus ride (B) + walk from stop to class (W). Random weather: it rains with
probability 0.3 (R = 1).

- B = 20 + 10R + noise(sd 3)  (rain slows the bus)
- W = 10 + 6R + noise(sd 2)   (rain slows your walk)

Rain affects both, so they move together: Cov(B, W) = 10 * 6 * Var(R) = 60(0.21) = **12.6**.

| | Variance | SD |
|---|---|---|
| B | 30.0 | 5.5 |
| W | 11.56 | 3.4 |
| Total T = B+W, if (wrongly) independent | 41.56 | 6.4 |
| **Total T, with covariance** | 30 + 11.56 + 2(12.6) = **66.76** | **8.2** |

Class discussion: "You want to arrive on time 95% of the time. How much buffer do you need?"
Ignoring covariance underestimates the buffer by ~1.7 minutes of SD, which is
many late arrivals. Same math underlies **risk in investing**: two stocks that fall together
(positive covariance) are riskier as a pair than their separate variances suggest;
two stocks that move oppositely (negative covariance) diversify risk.

---

## Experiment 5. Temperature and electricity use (cov = 0, dependence is obvious)

A house uses electricity for heating (cold days) and air conditioning (hot days).
Let X = outdoor temperature relative to a comfortable 20C, uniform on [-15, 15], and
Y = energy use ~ |X| (plus a little noise).

- Scatterplot is a perfect "V" or "U" -- Y is almost determined by X.
- But Cov(X, Y) = E[X|X|] - E[X]E|X| = 0 by symmetry. **Correlation 0.**
- Teaching point: Correlation measures *straight-line* association only. Always plot the data.
  A correlation near 0 does not mean "no relationship".

Other everyday U-shapes: stress vs. exam score, hours of sleep vs. health, speed vs. fuel economy.

---

## Experiment 6. Class survey (what real data look like; units; causation)
*Collect 3 numbers from each student (anonymous Google Form): hours of sleep last night,
hours studied for STAT 400 this week, height in inches. Add shoe size.*

Use real data to discuss:
1. **Predict the sign first** (height & shoe size: +; sleep & study: ? -- maybe negative because
   a day has only 24 hours; "trade-off" is a classic source of negative covariance).
2. **Units:** compute cov(height in inches, shoe size), then convert height to cm. Covariance changes by 2.54x,
   correlation does not.
3. **Outliers:** add one data point (a 7-foot basketball player) and watch r change.
4. **Causation:** e.g. "ice cream sales and swimming-pool drownings are positively correlated"
   -- the lurking variable is hot weather. "Students who sleep more get higher grades": cause or
   something else (conscientiousness)?

---

## Suggested in-class sequence (50 min)

1. (5 min) Hook: two scatterplots, ask "which one has bigger covariance?" (Experiment 6 data or R Demo 1)
2. (10 min) Experiment 1 Q1-Q2 with the 36-outcome table, by hand.
3. (5 min) Experiment 2 -> correlation = -1 and what the sign means.
4. (10 min) Experiment 4 commute -> Var(X+Y).
5. (10 min) Experiment 5 / Exp. 1 Q3 -> uncorrelated != independent.
6. (5 min) Wrap-up: three things to remember; exit ticket: "Give an example of two variables with
   negative covariance from your own life and say why."

## Quick conceptual check questions

1. Which pair has the larger correlation: (height, weight) of adults, or (height, shoe size)? Why?
2. If every student's quiz score is multiplied by 1.1 (curve), what happens to Var, Cov with HW score, and Corr with HW score?
3. A coach says "players' sprint speed and endurance are negatively correlated". Does that mean training speed hurts endurance? (No: it might come from a trade-off in body type, which is a different claim.)
4. Two independent stocks each have SD $10. What is the SD of the sum? What if the correlation is +0.8? -0.8? (14.1, 18.97, 6.32)
