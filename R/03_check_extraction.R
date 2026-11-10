# 03_check_extraction.R
# Checks the data files before anything is analysed. If something is wrong here
# it is much easier to fix than after the models have run.
# Run from the repo root: Rscript R/03_check_extraction.R

library(tidyverse)

dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)

failures <- character()
notes    <- character()

check <- function(ok, msg) {
  if (isTRUE(ok)) {
    cat("PASS:", msg, "\n")
  } else {
    cat("FAIL:", msg, "\n")
    failures <<- c(failures, msg)
  }
}

note <- function(msg) {
  cat("NOTE:", msg, "\n")
  notes <<- c(notes, msg)
}


# ------------------------------------------------------------------
# 1. load
# ------------------------------------------------------------------

binary <- read_csv("data/binary-data.csv", show_col_types = FALSE)
tte    <- read_csv("data/time-to-event-data.csv", show_col_types = FALSE)
chars  <- read_csv("data/characteristics.csv", show_col_types = FALSE)
aes    <- read_csv("data/adverse-events.csv", show_col_types = FALSE)


# ------------------------------------------------------------------
# 2. binary outcomes (CRR primary, ORR key secondary)
# ------------------------------------------------------------------

binary <- mutate(binary, outcome = tolower(outcome))

check(all(binary$events <= binary$n, na.rm = TRUE), "binary: events <= n everywhere")
check(all(binary$events >= 0, na.rm = TRUE), "binary: events >= 0 everywhere")
check(setequal(unique(binary$outcome), c("crr", "orr")),
      "binary: outcomes are exactly crr and orr")

arm_counts <- binary %>% count(trial_id, outcome) %>% pull(n)
check(all(arm_counts == 2), "binary: two arms per trial and outcome")

# CR has to be a subset of ORR inside each arm
cr  <- binary %>% filter(outcome == "crr") %>% select(trial_id, arm, cr_events = events)
orr <- binary %>% filter(outcome == "orr") %>% select(trial_id, arm, orr_events = events)
cr_orr <- inner_join(cr, orr, by = c("trial_id", "arm"))
check(nrow(cr_orr) == 6, "binary: CR and ORR rows matched up for all 6 arms")
check(all(cr_orr$cr_events <= cr_orr$orr_events), "binary: CR events <= ORR events in every arm")

# efficacy denominators are the randomised numbers (ITT)
denom_check <- binary %>%
  left_join(select(chars, trial_name, arm, n_randomized),
            by = c("trial_id" = "trial_name", "arm")) %>%
  mutate(ok = n == n_randomized)
check(all(denom_check$ok, na.rm = TRUE),
      "binary: denominators equal n_randomized (ITT rule)")

# do the counts reproduce the percentages printed in the papers?
pct_ref <- tribble(
  ~trial_id,   ~arm,    ~outcome, ~pct_paper,
  "ZUMA-7",    "car_t", "crr",    65.0,
  "ZUMA-7",    "soc",   "crr",    32.4,
  "ZUMA-7",    "car_t", "orr",    83.3,
  "ZUMA-7",    "soc",   "orr",    50.3,
  "TRANSFORM", "car_t", "crr",    73.9,
  "TRANSFORM", "soc",   "crr",    43.5,
  "TRANSFORM", "car_t", "orr",    87.0,
  "TRANSFORM", "soc",   "orr",    48.9,
  "BELINDA",   "car_t", "crr",    28.4,
  "BELINDA",   "soc",   "crr",    27.5,
  "BELINDA",   "car_t", "orr",    46.3,
  "BELINDA",   "soc",   "orr",    42.5
)

pct_check <- binary %>%
  inner_join(pct_ref, by = c("trial_id", "arm", "outcome")) %>%
  mutate(pct_calc = round(100 * events / n, 1),
         diff_pp  = abs(pct_calc - pct_paper))

check(nrow(pct_check) == 12, "binary: all 12 counts matched to a paper percentage")
check(all(pct_check$diff_pp <= 0.6),
      "binary: counts reproduce the paper percentages within 0.6 percentage points")


# ------------------------------------------------------------------
# 3. time to event
# ------------------------------------------------------------------

tte <- mutate(tte, outcome = tolower(outcome))

check(all(tte$hr > 0, na.rm = TRUE), "tte: all HRs positive")
check(all(tte$hr >= tte$hr_lower & tte$hr <= tte$hr_upper, na.rm = TRUE),
      "tte: every HR sits inside its 95% CI")

# one primary row per trial and outcome (the most mature follow-up, ITT)
primary_source <- c("ZUMA-7" = "Westin 2023",
                    "TRANSFORM" = "Kamdar 2025",
                    "BELINDA" = "Bishop 2022")

tte_primary <- tte %>%
  filter(str_detect(source, primary_source[trial_id])) %>%
  filter(is.na(estimand) | estimand == "itt")

n_per_cell <- tte_primary %>% count(trial_id, outcome) %>% filter(n != 1)
check(nrow(n_per_cell) == 0,
      "tte: exactly one primary row per trial and outcome")

note("BELINDA PFS was not reported, so BELINDA is left out of the PFS network.")
note("BELINDA OS: the primary row is the unadjusted HR 1.24 (0.83-1.85). The
     covariate adjusted 0.99 is kept for the sensitivity analysis only.")
note("ZUMA-7 updated EFS (Westin 2023) is investigator assessed, while the primary
     EFS was centrally reviewed. Worth mentioning in the transitivity discussion.")


# ------------------------------------------------------------------
# 4. adverse events
# ------------------------------------------------------------------

check(all(aes$events <= aes$n_safety, na.rm = TRUE), "AE: events <= n_safety everywhere")

safety_denom <- aes %>%
  left_join(select(chars, trial_name, arm, n_safety_char = n_safety),
            by = c("trial_id" = "trial_name", "arm")) %>%
  filter(!is.na(n_safety_char)) %>%
  mutate(ok = n_safety <= n_safety_char)
check(all(safety_denom$ok), "AE: denominators are not larger than the safety population")

note("BELINDA TEAE counts (160/162 and 158/160) were back-calculated from 98.8%,
     so they are not raw counts. They are flagged in the extraction notes.")
note("CRS and ICANS in the SOC arms are only available for ZUMA-7 (neurologic
     events), so safety stays descriptive apart from the ZUMA-7 odds ratios.")


# ------------------------------------------------------------------
# 5. verdict
# ------------------------------------------------------------------

cat("\n==== validation summary ====\n")
cat("failures:", length(failures), "\n")
if (length(failures)) cat(paste0(" - ", failures, collapse = "\n"), "\n")
cat("notes:", length(notes), "\n")

tibble(check = c(failures, notes),
       type  = c(rep("FAIL", length(failures)), rep("NOTE", length(notes)))) %>%
  write_csv("results/tables/00_validation_log.csv")

if (length(failures)) stop("validation failed, fix the data before running the models")
cat("validation passed. next: R/04_nma_response.R\n")
