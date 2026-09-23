# ==============================================================================
# 06_safety.R
# ------------------------------------------------------------------------------
# Safety synthesis — DESCRIPTIVE ONLY (protocol: no "safest CAR-T" ranking).
#   1. Event-rate table per arm (as-treated denominators, never ITT)
#   2. Anchored within-trial ORs ONLY where both arms report the outcome
#      (ZUMA-7 neurologic events; TEAE in all three trials)
#   3. CRS/ICANS in CAR-T arms compared across trials as CRUDE RATES ONLY —
#      no odds ratios: cross-trial comparisons of single arms break randomization.
# Zero cells: 0.5 continuity correction to both arms (pairwise default,
# pre-specified in protocol).
# Run from repo root: Rscript R/06_safety.R
# ==============================================================================

library(tidyverse)
library(meta)   # metabin for anchored ORs

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)

aes <- read_csv("data/adverse-events.csv", show_col_types = FALSE) %>%
  mutate(outcome = recode(outcome, "teae" = "teae_any")) %>%  # label harmonization
  mutate(pct = round(100 * events / n_safety, 1))

# ------------------------------------------------------------------------------
# 1. Descriptive event-rate table (primary safety output)
# ------------------------------------------------------------------------------
rate_table <- aes %>%
  select(trial_id, arm, treatment, outcome, events, n_safety, pct,
         grading_system, source) %>%
  arrange(outcome, trial_id, desc(arm))
write_csv(rate_table, "results/tables/safety_event_rates.csv")
print(rate_table, n = Inf)

# ------------------------------------------------------------------------------
# 2. Anchored ORs where BOTH arms report the outcome (randomization preserved)
# ------------------------------------------------------------------------------
both_arms <- aes %>%
  group_by(trial_id, outcome) %>%
  filter(n() == 2) %>%
  ungroup()

anchored <- both_arms %>%
  group_by(trial_id, outcome) %>%
  group_modify(~ {
    ct <- .x %>% filter(arm == "car_t")
    so <- .x %>% filter(arm == "soc")
    mb <- metabin(event.e = ct$events, n.e = ct$n_safety,
                  event.c = so$events, n.c = so$n_safety,
                  sm = "OR", method = "MH", incr = 0.5, allincr = TRUE)
    tibble(OR = round(exp(mb$TE), 3),
           lo = round(exp(mb$lower), 3),
           hi = round(exp(mb$upper), 3))
  }) %>%
  ungroup() %>%
  mutate(interpretation = "anchored OR (CAR-T vs SOC, within trial)")

write_csv(anchored, "results/tables/safety_anchored_ors.csv")
cat("\nAnchored ORs (both arms reported):\n")
print(anchored, n = Inf)

# ------------------------------------------------------------------------------
# 3. CAR-T-arm crude rates across trials (NO pooling, NO ORs — randomization
#    does not extend across trials; descriptive display only)
# ------------------------------------------------------------------------------
cart_rates <- aes %>%
  filter(arm == "car_t", str_detect(outcome, "crs|icans")) %>%
  select(trial_id, treatment, outcome, events, n_safety, pct, grading_system)

write_csv(cart_rates, "results/tables/safety_cart_arm_crude_rates.csv")
cat("\nCAR-T arm crude rates (descriptive only, no cross-trial ORs):\n")
print(cart_rates, n = Inf)

cat("\nCaveats for the report:\n")
cat(" - TEAE ~100% on every arm: OR uninformative by design (protocol anticipated).\n")
cat(" - BELINDA TEAE counts back-calculated from 98.8% — flagged.\n")
cat(" - CRS grading: modified Lee 2014 (ZUMA-7) vs Lee 2014 (TRANSFORM/BELINDA);\n")
cat("   ICANS: CTCAE v4.03 (ZUMA-7/TRANSFORM) vs v5.0 (BELINDA) — transitivity caveat.\n")
cat(" - BELINDA CRS/ICANS denominators = 155 infused (not 162 randomized).\n")
cat("Done.\n")
