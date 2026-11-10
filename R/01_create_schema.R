# 01_create_schema.R
# Makes the empty CSV files that the extraction scripts fill in.
# Run this once before 02a/02b/02c. Files that already exist are left alone.

library(tibble)
library(readr)

if (!dir.exists("data")) dir.create("data")

write_if_missing <- function(x, path) {
  if (file.exists(path)) {
    message("already exists, skipping: ", path)
  } else {
    write_csv(x, path)
  }
}

# characteristics.csv - one row per trial arm
characteristics <- tibble(
  trial_name                 = character(),  # ZUMA-7 / TRANSFORM / BELINDA
  nct                        = character(),
  car_t_product              = character(),
  primary_citation           = character(),
  followup_citation          = character(),  # long term paper, if there is one
  data_cutoff_date           = character(),
  median_followup_months     = numeric(),
  randomization_ratio        = character(),
  bridging_chemo_allowed     = character(),
  bridging_details           = character(),
  crossover_allowed          = character(),
  response_assessor          = character(),  # IRC or investigator
  efs_definition_verbatim    = character(),
  crr_definition_verbatim    = character(),
  crs_grading                = character(),
  icans_grading              = character(),
  arm                        = character(),  # car_t / soc
  treatment                  = character(),
  n_randomized               = numeric(),
  n_safety                   = numeric(),
  n_infused                  = numeric(),
  median_age                 = numeric(),
  pct_primary_refractory     = numeric(),
  pct_relapse_lt12mo         = numeric(),
  pct_ipi_distribution       = character(),
  pct_stage_iii_iv           = numeric(),
  region_note                = character(),
  median_days_dx_to_infusion = numeric(),
  salvage_regimens           = character(),
  pct_reached_asct           = numeric(),
  pct_soc_subsequent_cart    = numeric(),
  source                     = character(),
  notes                      = character()
)

write_if_missing(characteristics, "data/characteristics.csv")


# binary-data.csv - CRR and ORR counts
binary <- tibble(
  trial_id         = character(),
  arm              = character(),
  treatment        = character(),
  outcome          = character(),  # crr / orr
  events           = numeric(),
  n                = numeric(),
  denominator_type = character(),  # randomized = ITT
  assessor         = character(),
  timepoint_note   = character(),
  source           = character()
)

write_if_missing(binary, "data/binary-data.csv")


# time-to-event-data.csv - one row per reported HR
tte <- tibble(
  trial_id                 = character(),
  outcome                  = character(),  # efs / pfs / os
  population               = character(),
  treatment_arm            = character(),
  comparator_arm           = character(),
  hr                       = numeric(),
  hr_lower                 = numeric(),
  hr_upper                 = numeric(),
  treatment_median_months  = numeric(),
  comparator_median_months = numeric(),
  publication_used         = character(),  # initial / followup
  source_type              = character(),
  data_cutoff_date         = character(),
  median_followup_months   = numeric(),
  estimand                 = character(),  # itt / rpsft_adjusted / covariate_adjusted
  treatment_4yr_survival   = numeric(),
  comparator_4yr_survival  = numeric(),
  source                   = character()
)

write_if_missing(tte, "data/time-to-event-data.csv")


# patient-reported-outcomes.csv
pro <- tibble(
  trial_id     = character(),
  arm          = character(),
  instrument   = character(),  # EORTC QLQ-C30 / EQ-5D-5L
  timepoint    = character(),
  measure_type = character(),  # mean_change / responder_pct / ...
  value        = numeric(),
  sd_or_se     = numeric(),
  n            = numeric(),
  source       = character(),
  notes        = character()
)

write_if_missing(pro, "data/patient-reported-outcomes.csv")


# adverse-events.csv - denominators are the safety set, not the randomized set
ae <- tibble(
  trial_id       = character(),
  arm            = character(),
  treatment      = character(),
  outcome        = character(),  # crs_any / crs_g3plus / icans_any / icans_g3plus / teae
  events         = numeric(),
  n_safety       = numeric(),
  grading_system = character(),
  source         = character(),
  notes          = character()
)

write_if_missing(ae, "data/adverse-events.csv")
