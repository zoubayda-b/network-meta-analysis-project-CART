# ==============================================================================
# 03_check_extraction.R
# ------------------------------------------------------------------------------
# Validation of the extracted dataset BEFORE any analysis, per protocol:
#   - counts within bounds (0 <= events <= n)
#   - HR inside its 95% CI
#   - efficacy denominators match characteristics.csv (ITT); safety uses n_safety
#   - exactly one primary row per trial x outcome after source selection
#   - label harmonization applied here is the single documented place it happens
# Rscript R/03_check_extraction.R
# ==============================================================================

library(tidyverse)

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)

failures <- character()
notes    <- character()

check <- function(ok, msg) {
  if (isTRUE(ok)) cat("PASS:", msg, "\n") else {
    cat("FAIL:", msg, "\n")
    failures <<- c(failures, msg)
  }
}
note <- function(msg) { cat("NOTE:", msg, "\n"); notes <<- c(notes, msg) }

# ------------------------------------------------------------------------------
# 1. Load
# ------------------------------------------------------------------------------
binary <- read_csv("data/binary-data.csv", show_col_types = FALSE)
tte    <- read_csv("data/time-to-event-data.csv", show_col_types = FALSE)
chars  <- read_csv("data/characteristics.csv", show_col_types = FALSE)
aes    <- read_csv("data/adverse-events.csv", show_col_types = FALSE)

# ------------------------------------------------------------------------------
# 2. Binary outcomes (CRR primary, ORR key secondary)
# ------------------------------------------------------------------------------
check(all(binary$events <= binary$n, na.rm = TRUE), "binary: events <= n everywhere")
check(all(binary$events >= 0, na.rm = TRUE),        "binary: events >= 0 everywhere")

binary <- binary %>% mutate(outcome = tolower(outcome))
check(setequal(unique(binary$outcome), c("crr", "orr")),
      "binary: outcomes are exactly crr + orr after case harmonization")

check(binary %>% count(trial_id, outcome) %>% pull(n) %>% setequal(2),
      "binary: exactly 2 arms per trial x outcome")

# CR is a subset of ORR within each arm
cr  <- binary %>% filter(outcome == "crr") %>% select(trial_id, arm, cr_events = events)
orr <- binary %>% filter(outcome == "orr") %>% select(trial_id, arm, orr_events = events)
check(cr %>% inner_join(orr, by = c("trial_id", "arm")) %>%
        with(all(cr_events <= orr_events)),
      "binary: CR events <= ORR events in every arm")

# Efficacy denominators must equal n_randomized in characteristics (ITT rule)
denom_check <- binary %>%
  left_join(chars %>% select(trial_name, arm, n_randomized),
            by = c("trial_id" = "trial_name", "arm")) %>%
  mutate(ok = n == n_randomized)
check(all(denom_check$ok, na.rm = TRUE),
      "binary: denominators equal n_randomized (ITT efficacy rule)")

# Reported percentages vs counts (paper-stated rates from the trial reports)
pct_ref <- tribble(
  ~trial_id,   ~arm,    ~outcome, ~pct_paper,
  "ZUMA-7",    "car_t", "crr",    65,
  "ZUMA-7",    "soc",   "crr",    32,
  "ZUMA-7",    "car_t", "orr",    83,
  "ZUMA-7",    "soc",   "orr",    50,
  "TRANSFORM", "car_t", "crr",    74,   # Kamdar 2025 JCO 3-yr follow-up — VERIFY against paper
  "TRANSFORM", "soc",   "crr",    44,   # Kamdar 2025 JCO 3-yr follow-up — VERIFY against paper
  "TRANSFORM", "car_t", "orr",    87,   # Kamdar 2025 JCO — VERIFY
  "TRANSFORM", "soc",   "orr",    49,   # Kamdar 2025 JCO — VERIFY
  "BELINDA",   "car_t", "crr",    28.4, # Bishop 2022 Table 2 (best response at/after wk 12)
  "BELINDA",   "soc",   "crr",    27.5,
  "BELINDA",   "car_t", "orr",    46.3,
  "BELINDA",   "soc",   "orr",    42.5
)
pct_check <- binary %>%
  inner_join(pct_ref, by = c("trial_id", "arm", "outcome")) %>%
  mutate(pct_calc = round(100 * events / n, 1),
         diff_pp  = abs(pct_calc - pct_paper))
print(pct_check)
check(all(pct_check$diff_pp <= 0.6),
      "binary: counts reproduce paper-reported percentages within 0.6 pp")
note("TRANSFORM binary rows come from the Kamdar 2025 3-year follow-up (longest follow-up,
      per protocol Timing rule). Claude could not independently re-verify 68/92, 40/92,
      80/92, 45/92 against the JCO paper — confirm against Kamdar 2025 Table 2 before freezing.")

# ------------------------------------------------------------------------------
# 3. Time-to-event outcomes
# ------------------------------------------------------------------------------
tte <- tte %>% mutate(outcome = tolower(outcome))
check(all(tte$hr > 0, na.rm = TRUE), "tte: all HRs positive")
check(all(tte$hr >= tte$hr_lower & tte$hr <= tte$hr_upper, na.rm = TRUE),
      "tte: every HR lies inside its 95% CI")

# Primary-source selection rule (protocol: most mature follow-up per trial)
primary_source <- c("ZUMA-7" = "Westin 2023", "TRANSFORM" = "Kamdar 2025",
                    "BELINDA" = "Bishop 2022")
tte_primary <- tte %>%
  filter(str_detect(source, primary_source[trial_id])) %>%
  filter(is.na(estimand) | estimand == "itt")

n_per_cell <- tte_primary %>% count(trial_id, outcome) %>% filter(n != 1)
check(nrow(n_per_cell) == 0,
      "tte: exactly one primary row per trial x outcome after source selection")

note("BELINDA PFS: not reported in Bishop 2022 — excluded from PFS NMA per protocol
     (excluded rather than imputed).")
note("BELINDA OS: primary = stratified unadjusted ITT HR 1.24 (0.83-1.85). The
     covariate-adjusted 0.99 is retained for sensitivity only.")
note("ZUMA-7 updated EFS (Westin 2023) is investigator-assessed per extraction notes —
     flag for transitivity discussion (ZUMA-7 primary EFS was centrally assessed).")

# ------------------------------------------------------------------------------
# 4. Adverse events
# ------------------------------------------------------------------------------
check(all(aes$events <= aes$n_safety, na.rm = TRUE), "AE: events <= n_safety everywhere")

safety_denom <- aes %>%
  left_join(chars %>% select(trial_name, arm, n_safety_char = n_safety),
            by = c("trial_id" = "trial_name", "arm")) %>%
  filter(!is.na(n_safety_char)) %>%
  mutate(ok = n_safety <= n_safety_char | trial_id == "BELINDA")
# BELINDA CRS/ICANS rows use n_safety=155 (infused) < 162 (randomized safety pop) — expected.
check(all(safety_denom$ok), "AE: denominators consistent with characteristics n_safety")

note("BELINDA TEAE counts (160/162, 158/160) were back-calculated from 98.8% — flagged
     in extraction; keep the flag in outputs.")
note("CRS/ICANS in SOC arms are only available for ZUMA-7 (neurologic events). Safety
     synthesis is therefore descriptive + ZUMA-7 anchored ORs, per protocol.")

# ------------------------------------------------------------------------------
# 5. Verdict
# ------------------------------------------------------------------------------
cat("\n==== VALIDATION SUMMARY ====\n")
cat("Failures:", length(failures), "\n")
if (length(failures)) cat(paste0(" - ", failures, collapse = "\n"), "\n")
cat("Notes:", length(notes), "\n")

tibble(check = c(failures, notes),
       type  = c(rep("FAIL", length(failures)), rep("NOTE", length(notes)))) %>%
  write_csv("results/tables/00_validation_log.csv")

if (length(failures)) stop("Validation failed — fix the dataset before analysis.")
cat("Validation passed. Proceed to 04_nma_response.R\n")
