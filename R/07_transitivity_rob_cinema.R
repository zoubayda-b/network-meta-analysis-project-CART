# ==============================================================================
# 07_transitivity_rob_cinema.R
# ------------------------------------------------------------------------------
# Protocol-mandated qualitative assessments:
#   1. Comparator-node check: raw CRR/ORR/OS of the three SOC arms side by side
#   2. Transitivity characteristics table (population + design effect modifiers)
#   3. Data maturity table (trial x outcome x cutoff x median follow-up)
#   4. RoB 2 DRAFT judgments (single reviewer — ZB must review/finalize) + robvis
#   5. CINeMA qualitative table (draft ratings with justifications)
#   6. PRO narrative summary (no pooling: instruments/timepoints not comparable)
# Run from repo root: Rscript R/07_transitivity_rob_cinema.R
# ==============================================================================

library(tidyverse)
library(robvis)

dir.create("results/tables",  showWarnings = FALSE, recursive = TRUE)
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)

chars  <- read_csv("data/characteristics.csv", show_col_types = FALSE)
binary <- read_csv("data/binary-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome))
tte    <- read_csv("data/time-to-event-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome))

# ------------------------------------------------------------------------------
# 1. Comparator-node check (the key empirical test of the SOC-node assumption)
# ------------------------------------------------------------------------------
soc_response <- binary %>%
  filter(arm == "soc") %>%
  mutate(rate = round(events / n, 3)) %>%
  select(trial_id, outcome, events, n, rate) %>%
  pivot_wider(names_from = outcome, values_from = c(events, n, rate))

mature_src <- c("ZUMA-7" = "Westin 2023", "TRANSFORM" = "Kamdar 2025",
                "BELINDA" = "Bishop 2022")
soc_os <- tte %>%
  filter(outcome == "os", (is.na(estimand) | estimand == "itt")) %>%
  filter(str_detect(source, mature_src[trial_id])) %>%
  select(trial_id, hr, hr_lower, hr_upper, median_followup_months)

soc_design <- chars %>%
  filter(arm == "soc") %>%
  select(trial_name, salvage_regimens, pct_reached_asct, pct_soc_subsequent_cart)

comparator_check <- soc_response %>%
  left_join(soc_os, by = "trial_id") %>%
  left_join(soc_design, by = c("trial_id" = "trial_name"))

write_csv(comparator_check, "results/tables/transitivity_comparator_check.csv")
cat("== Comparator-node check (three SOC arms compared directly) ==\n")
print(comparator_check, width = Inf)
cat("\nReading: SOC CRR ranges 27.5%-44% — BELINDA's SOC arm underperformed vs\n")
cat("ZUMA-7/TRANSFORM SOC arms; ASCT reach 32.5%-47%. The SOC node is not one\n")
cat("treatment; indirect comparisons inherit this (protocol-stated limitation).\n\n")

# ------------------------------------------------------------------------------
# 2. Transitivity characteristics table
# ------------------------------------------------------------------------------
transitivity <- chars %>%
  select(trial_id = trial_name, arm, n_randomized, median_age,
         pct_primary_refractory, pct_relapse_lt12mo, pct_ipi_distribution,
         pct_stage_iii_iv, region_note, bridging_chemo_allowed, bridging_details,
         crossover_allowed, response_assessor, crs_grading, icans_grading,
         pct_reached_asct, pct_soc_subsequent_cart) %>%
  mutate(across(-c(trial_id, arm), as.character)) %>%
  pivot_longer(-c(trial_id, arm)) %>%
  pivot_wider(names_from = c(trial_id, arm), values_from = value)

write_csv(transitivity, "results/tables/transitivity_characteristics.csv")
cat("== Transitivity characteristics table written ==\n\n")

# ------------------------------------------------------------------------------
# 3. Data maturity table (must accompany every TTE league table, per protocol)
# ------------------------------------------------------------------------------
maturity <- tte %>%
  select(trial_id, outcome, estimand, data_cutoff_date, median_followup_months,
         source) %>%
  distinct() %>%
  arrange(trial_id, outcome)
write_csv(maturity, "results/tables/data_maturity_table.csv")
cat("== Data maturity table ==\n")
print(maturity, n = Inf, width = Inf)
cat("\n")

# ------------------------------------------------------------------------------
# 4. RoB 2 — DRAFT judgments for ZB review (single-reviewer protocol).
#    Judgments are outcome-specific (CRR primary; OS key secondary).
#    !!! These are a drafting aid only — review each against the papers before
#    freezing; the protocol requires a second pass over every judgment. !!!
# ------------------------------------------------------------------------------
rob2 <- tribble(
  ~Study,      ~Outcome, ~D1,   ~D2,              ~D3,   ~D4,   ~D5,   ~Overall,
  # CRR — objective response, blinded central review in all three trials
  "ZUMA-7",    "CRR",    "Low", "Low",            "Low", "Low", "Low", "Low",
  "TRANSFORM", "CRR",    "Low", "Low",            "Low", "Low", "Low", "Low",
  "BELINDA",   "CRR",    "Low", "Low",            "Low", "Low", "Low", "Low",
  # OS — open-label + crossover/subsequent CAR-T contaminate deviations domain
  "ZUMA-7",    "OS",     "Low", "Some concerns",  "Low", "Low", "Low", "Some concerns",
  "TRANSFORM", "OS",     "Low", "Some concerns",  "Low", "Low", "Low", "Some concerns",
  "BELINDA",   "OS",     "Low", "Some concerns",  "Low", "Low", "Low", "Some concerns"
)
# D2 rationale: crossover (TRANSFORM 62% approved; BELINDA 51%) and off-protocol
# commercial CAR-T (ZUMA-7 57%) are deviations from intended SOC for OS.
# D4 Low everywhere: response by blinded IRC; OS is objective.
write_csv(rob2, "results/tables/rob2_draft_judgments.csv")

rob2_plot <- rob2 %>% mutate(Weight = 1) %>% select(Study, D1:Overall, Weight)

png("results/figures/rob2_traffic_light.png", width = 1100, height = 700, res = 110)
print(rob_traffic_light(rob2_plot, tool = "ROB2", psize = 12))
dev.off()

png("results/figures/rob2_summary.png", width = 900, height = 500, res = 110)
print(rob_summary(rob2_plot, tool = "ROB2"))
dev.off()
cat("RoB2 draft + robvis plots written (review judgments before freezing).\n\n")

# ------------------------------------------------------------------------------
# 5. CINeMA qualitative (draft) — primary CRR and key secondary OS
#    Pre-specified imprecision thresholds: OR 1.25 (binary), HR 0.80 (TTE)
# ------------------------------------------------------------------------------
cinema <- tribble(
  ~Outcome, ~Domain,              ~Rating,    ~Justification,
  "CRR", "Within-study bias",     "Low",      "All three RCTs centrally randomized; response by blinded IRC; RoB2 Low.",
  "CRR", "Indirectness",          "Moderate", "SOC node pools 3 different salvage/ASCT programs (SOC CRR 27.5-44%); BELINDA enrolled more non-US; refractory/relapse mix differs.",
  "CRR", "Imprecision",           "Moderate", "CIs for CAR-T vs CAR-T comparisons are wide and cross the pre-specified OR 1.25 threshold in both directions.",
  "CRR", "Heterogeneity",         "Moderate", "Not estimable (one trial per edge); structural limitation, not evidence of absence.",
  "CRR", "Incoherence",           "Low",      "Star network: no closed loops, no direct-indirect contrast exists to disagree.",
  "OS",  "Within-study bias",     "Moderate", "Open-label with crossover (TRANSFORM/BELINDA) and off-protocol CAR-T (ZUMA-7): RoB2 some concerns for OS.",
  "OS",  "Indirectness",          "High",     "SOC node means 3 different things for OS (crossover 51-62%, commercial CAR-T 57%); follow-up maturity 10-47 months.",
  "OS",  "Imprecision",           "High",     "All CIs cross HR 0.80 threshold; TRANSFORM and BELINDA OS CIs span 1.",
  "OS",  "Heterogeneity",         "Moderate", "Not estimable; clinical heterogeneity (crossover routes) is demonstrable instead.",
  "OS",  "Incoherence",           "Low",      "No closed loops; not assessable statistically."
)
write_csv(cinema, "results/tables/cinema_qualitative_draft.csv")
cat("CINeMA qualitative draft written (ratings to be confirmed by ZB).\n\n")

# ------------------------------------------------------------------------------
# 6. PRO narrative summary (protocol: no pooling unless >=2 comparable
#    instruments+timepoints — ZUMA-7 mean changes at day 100/150 vs TRANSFORM
#    TTD/MMRM are NOT comparable; BELINDA unpublished -> narrative only)
# ------------------------------------------------------------------------------
pros <- read_csv("data/patient-reported-outcomes.csv", show_col_types = FALSE)
write_csv(pros, "results/tables/pro_narrative_summary.csv")
cat("PROs: 2/3 trials report; instruments overlap (QLQ-C30) but measures/timepoints\n")
cat("differ (mean change vs TTD/MMRM) -> narrative synthesis only, per protocol.\n")
cat("BELINDA PROs unpublished at data freeze.\n\n")

cat("All qualitative assessment outputs written to results/tables|figures.\n")
