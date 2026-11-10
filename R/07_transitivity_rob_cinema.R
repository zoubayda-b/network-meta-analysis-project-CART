# 07_transitivity_rob_cinema.R
# The parts of the protocol that are not a model:
#   1. comparator node check (the three SOC arms side by side)
#   2. transitivity table
#   3. data maturity table
#   4. RoB 2 judgments + robvis plots
#   5. CINeMA ratings
#   6. PRO summary
# Run from the repo root: Rscript R/07_transitivity_rob_cinema.R

library(tidyverse)
library(robvis)

dir.create("results/tables",  showWarnings = FALSE, recursive = TRUE)
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)

chars  <- read_csv("data/characteristics.csv", show_col_types = FALSE)
binary <- read_csv("data/binary-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome))
tte    <- read_csv("data/time-to-event-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome))


# ------------------------------------------------------------------
# 1. comparator node check
# This is the important one. If the three SOC arms behave like three
# different treatments, every indirect comparison inherits that problem.
# ------------------------------------------------------------------

soc_response <- binary %>%
  filter(arm == "soc") %>%
  mutate(rate = round(events / n, 3)) %>%
  select(trial_id, outcome, events, n, rate) %>%
  pivot_wider(names_from = outcome, values_from = c(events, n, rate))

# median OS of the SOC arm, from the row with the longest follow-up
soc_os <- tte %>%
  filter(outcome == "os", !is.na(comparator_median_months)) %>%
  group_by(trial_id) %>%
  slice_max(median_followup_months, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(trial_id, soc_median_os = comparator_median_months,
         median_followup_months)

soc_design <- chars %>%
  filter(arm == "soc") %>%
  select(trial_name, salvage_regimens, pct_reached_asct, pct_soc_subsequent_cart)

comparator_check <- soc_response %>%
  left_join(soc_os, by = "trial_id") %>%
  left_join(soc_design, by = c("trial_id" = "trial_name"))

write_csv(comparator_check, "results/tables/transitivity_comparator_check.csv")

cat("== comparator node check (the three SOC arms compared with each other) ==\n")
print(comparator_check, width = Inf)
cat("\nSOC complete response ranges from 27.5% to 43.5% and the share that reached\n")
cat("ASCT from 32.5% to 47%. BELINDA's SOC arm did worse than the other two. So the\n")
cat("three arms are not really one treatment, and the CAR-T vs CAR-T comparisons\n")
cat("are built on that assumption.\n\n")


# ------------------------------------------------------------------
# 2. transitivity table
# ------------------------------------------------------------------

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
cat("== transitivity table written ==\n\n")


# ------------------------------------------------------------------
# 3. data maturity table
# The protocol wants this next to every time to event table, because the
# trials have very different follow-up.
# ------------------------------------------------------------------

maturity <- tte %>%
  select(trial_id, outcome, estimand, data_cutoff_date, median_followup_months,
         source) %>%
  distinct() %>%
  arrange(trial_id, outcome)

write_csv(maturity, "results/tables/data_maturity_table.csv")
cat("== data maturity table ==\n")
print(maturity, n = Inf, width = Inf)
cat("\n")


# ------------------------------------------------------------------
# 4. RoB 2
# These are my first pass judgments, done outcome by outcome. The protocol
# asks for a second pass over all of them after a break before they are final.
# ------------------------------------------------------------------

rob2 <- tribble(
  ~Study,      ~Outcome, ~D1,   ~D2,             ~D3,   ~D4,   ~D5,   ~Overall,
  # CRR: objective response, blinded central review in all three trials
  "ZUMA-7",    "CRR",    "Low", "Low",           "Low", "Low", "Low", "Low",
  "TRANSFORM", "CRR",    "Low", "Low",           "Low", "Low", "Low", "Low",
  "BELINDA",   "CRR",    "Low", "Low",           "Low", "Low", "Low", "Low",
  # OS: open label, and the SOC arm is changed by crossover or later CAR-T
  "ZUMA-7",    "OS",     "Low", "Some concerns", "Low", "Low", "Low", "Some concerns",
  "TRANSFORM", "OS",     "Low", "Some concerns", "Low", "Low", "Low", "Some concerns",
  "BELINDA",   "OS",     "Low", "Some concerns", "Low", "Low", "Low", "Some concerns"
)

# domain 2 is where the crossover lands: TRANSFORM 67% and BELINDA 50.6% crossed
# over by protocol, and 57% of ZUMA-7's SOC arm got commercial CAR-T afterwards.
# domain 4 is low everywhere: response is read by a blinded review committee and
# death is death.

write_csv(rob2, "results/tables/rob2_draft_judgments.csv")

rob2_plot <- rob2 %>%
  mutate(Weight = 1) %>%
  select(Study, D1:Overall, Weight)

png("results/figures/rob2_traffic_light.png", width = 1100, height = 700, res = 110)
print(rob_traffic_light(rob2_plot, tool = "ROB2", psize = 12))
dev.off()

png("results/figures/rob2_summary.png", width = 900, height = 500, res = 110)
print(rob_summary(rob2_plot, tool = "ROB2"))
dev.off()

cat("RoB 2 judgments and the two robvis plots are written. Still to do: second pass.\n\n")


# ------------------------------------------------------------------
# 5. CINeMA, done by hand
# Heterogeneity and incoherence cannot be rated here: tau^2 is not estimable
# with one trial per comparison and there is no closed loop to test. I write
# "not assessable" rather than a rating, because a rating would suggest the
# domain had been checked.
# Imprecision is judged against the thresholds set in the protocol:
# OR 1.25 for binary outcomes, HR 0.80 for time to event outcomes.
# ------------------------------------------------------------------

cinema <- tribble(
  ~Outcome, ~Domain,              ~Rating,         ~Justification,
  "CRR", "Within-study bias",     "Low",           "All three are randomised, response is read by a blinded committee, RoB 2 low.",
  "CRR", "Indirectness",          "Moderate",      "The SOC node mixes three salvage and ASCT pathways (SOC CRR 27.5% to 43.5%), and the refractory/relapse mix differs a little between trials.",
  "CRR", "Imprecision",           "Moderate",      "The CAR-T vs CAR-T intervals are wide and cross the OR 1.25 threshold in both directions.",
  "CRR", "Heterogeneity",         "Not assessable", "One trial per comparison, so tau^2 cannot be estimated. This is a limit of the data, not evidence that heterogeneity is zero.",
  "CRR", "Incoherence",           "Not assessable", "Star network with no closed loop, so there is no direct and indirect evidence to compare.",
  "OS",  "Within-study bias",     "Moderate",      "Open label, with crossover in TRANSFORM and BELINDA and commercial CAR-T after progression in ZUMA-7. RoB 2 some concerns.",
  "OS",  "Indirectness",          "High",          "The SOC node means three different things for OS, and follow-up runs from 10 to 47 months.",
  "OS",  "Imprecision",           "High",          "All intervals cross the HR 0.80 threshold and two of the three include 1.",
  "OS",  "Heterogeneity",         "Not assessable", "Not estimable. The clinical differences in crossover are the real concern here.",
  "OS",  "Incoherence",           "Not assessable", "No closed loop, so incoherence cannot be tested."
)

write_csv(cinema, "results/tables/cinema_qualitative_draft.csv")
cat("CINeMA table written.\n\n")


# ------------------------------------------------------------------
# 6. PROs
# Two trials report them, but the instruments and timepoints do not line up,
# so this stays narrative. BELINDA had no PRO publication at the cut-off.
# ------------------------------------------------------------------

pros <- read_csv("data/patient-reported-outcomes.csv", show_col_types = FALSE)
write_csv(pros, "results/tables/pro_narrative_summary.csv")

cat("PROs: ZUMA-7 reports mean changes at day 100 and 150, TRANSFORM reports time\n")
cat("to deterioration and MMRM differences. Not comparable, so narrative only.\n")
cat("done.\n")
