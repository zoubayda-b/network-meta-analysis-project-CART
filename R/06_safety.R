# 06_safety.R
# Safety tables. Descriptive only: there is no "safest CAR-T" ranking here.
#   1. event rates per arm, using the safety denominators
#   2. odds ratios only where both arms of the same trial report the outcome
#   3. CRS and ICANS in the CAR-T arms as crude rates, no cross trial odds ratios
# Run from the repo root: Rscript R/06_safety.R

library(tidyverse)

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)

aes <- read_csv("data/adverse-events.csv", show_col_types = FALSE) %>%
  mutate(outcome = recode(outcome, "teae" = "teae_any"),
         pct     = round(100 * events / n_safety, 1))


# ------------------------------------------------------------------
# odds ratio from a 2x2 table
# 0.5 is added to every cell when one of them is zero, as the protocol says.
# If both arms have an event in every patient the odds ratio says nothing,
# so NA is returned instead of a made up number.
# ------------------------------------------------------------------

or_from_2x2 <- function(a, n1, c, n2) {

  if (a == n1 && c == n2) {
    return(c(OR = NA_real_, lo = NA_real_, hi = NA_real_))
  }

  b <- n1 - a
  d <- n2 - c

  if (a == 0 || b == 0 || c == 0 || d == 0) {
    a <- a + 0.5; b <- b + 0.5
    c <- c + 0.5; d <- d + 0.5
  }

  log_or <- log((a * d) / (b * c))
  se     <- sqrt(1 / a + 1 / b + 1 / c + 1 / d)

  c(OR = exp(log_or),
    lo = exp(log_or - qnorm(0.975) * se),
    hi = exp(log_or + qnorm(0.975) * se))
}


# ------------------------------------------------------------------
# 1. event rates, this is the main safety output
# ------------------------------------------------------------------

rate_table <- aes %>%
  select(trial_id, arm, treatment, outcome, events, n_safety, pct,
         grading_system, source, notes) %>%
  arrange(outcome, trial_id, desc(arm))

write_csv(rate_table, "results/tables/safety_event_rates.csv")
print(rate_table, n = Inf)


# ------------------------------------------------------------------
# 2. anchored odds ratios, only where both arms report the same outcome
# ------------------------------------------------------------------

both_arms <- aes %>%
  group_by(trial_id, outcome) %>%
  filter(n() == 2) %>%
  ungroup()

groups <- split(both_arms, paste(both_arms$trial_id, both_arms$outcome))

anchored <- map_dfr(groups, function(g) {
  ct  <- g[g$arm == "car_t", ]
  so  <- g[g$arm == "soc", ]
  res <- or_from_2x2(ct$events, ct$n_safety, so$events, so$n_safety)
  tibble(trial_id = g$trial_id[1],
         outcome  = g$outcome[1],
         OR       = round(res["OR"], 3),
         lo       = round(res["lo"], 3),
         hi       = round(res["hi"], 3))
})

write_csv(anchored, "results/tables/safety_anchored_ors.csv")
cat("\nAnchored odds ratios (CAR-T vs SOC, within trial):\n")
print(anchored, n = Inf)


# ------------------------------------------------------------------
# 3. CRS and ICANS in the CAR-T arms, crude rates only
# The randomisation does not carry across trials, so no odds ratios here.
# ------------------------------------------------------------------

cart_rates <- aes %>%
  filter(arm == "car_t", str_detect(outcome, "crs|icans")) %>%
  select(trial_id, treatment, outcome, events, n_safety, pct, grading_system)

write_csv(cart_rates, "results/tables/safety_cart_arm_crude_rates.csv")
cat("\nCAR-T arm crude rates (descriptive, no cross trial odds ratios):\n")
print(cart_rates, n = Inf)


cat("\nthings to remember when writing this up:\n")
cat(" - TEAEs are close to 100% on every arm, so the odds ratio carries no information\n")
cat(" - the ZUMA-7 TEAE odds ratio cannot be estimated (100% in both arms)\n")
cat(" - the BELINDA TEAE counts were back-calculated from a percentage\n")
cat(" - CRS grading is modified Lee 2014 in ZUMA-7 and Lee 2014 in the other two\n")
cat(" - ICANS grading is CTCAE v4.03 in ZUMA-7 and TRANSFORM and v5.0 in BELINDA\n")
cat(" - BELINDA CRS and ICANS use the 155 infused patients, not the 162 randomised\n")
cat("done.\n")
