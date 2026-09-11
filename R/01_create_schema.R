library(tibble)
library(readr)


if (!dir.exists("data")) dir.create("data")


# characteristics.csv

characteristics_file <- "data/characteristics.csv"

characteristics <- tibble(
  trial_name                 = character(),  # zuma7 / transform / belinda
  nct                        = character(),  # NCT number
  car_t_product              = character(),  # axi-cel / liso-cel / tisa-cel
  primary_citation           = character(),  # e.g. "Locke 2022 NEJM"
  followup_citation          = character(),  # long-term paper
  data_cutoff_date           = character(),
  median_followup_months     = numeric(),
  randomization_ratio        = character(),
  bridging_chemo_allowed     = character(),  # yes / no
  bridging_details           = character(),
  crossover_allowed          = character(),  # yes / no
  response_assessor          = character(),  # IRC / investigator
  efs_definition_verbatim    = character(),
  crr_definition_verbatim    = character(),
  crs_grading               = character(),
  icans_grading              = character(),

  # arm-level
  arm                        = character(),  # car_t / soc
  treatment                  = character(),  # axi-cel / liso-cel / tisa-cel / soc
  n_randomized               = numeric(),
  n_safety                   = numeric(),
  n_infused                  = numeric(),
  median_age                 = numeric(),
  pct_primary_refractory     = numeric(),
  pct_relapse_lt12mo         = numeric(),
  pct_ipi_distribution       = character(),
  pct_stage_iii_iv            = numeric(),
  region_note                = character(),
  median_days_dx_to_infusion = numeric(),
  salvage_regimens           = character(),
  pct_reached_asct           = numeric(),
  pct_soc_subsequent_cart    = numeric(),
  source                     = character(),
  notes                      = character()
)

if (!file.exists(characteristics_file)) {
  write_csv(characteristics, characteristics_file)
} else {
  message("File already exists: ", characteristics_file)
}


# binary-data.csv

binary_file <- "data/binary-data.csv"

binary <- tibble(
  trial_id         = character(),
  arm              = character(),
  treatment        = character(),
  outcome          = character(),  # crr / orr
  events           = numeric(),
  n                = numeric(),
  denominator_type = character(),  # randomized = ITT
  assessor         = character(),  # IRC / investigator
  timepoint_note   = character(),  # e.g. "best response"
  source           = character()
)

if (!file.exists(binary_file)) {
  write_csv(binary, binary_file)
} else {
  message("File already exists: ", binary_file)
}


# time-to-event-data.csv

tte_file <- "data/time-to-event-data.csv"

tte <- tibble(
  trial_id                 = character(),
  outcome                  = character(),
  population               = character(),
  treatment_arm            = character(),
  comparator_arm           = character(),
  hr                       = numeric(),
  hr_lower                 = numeric(),
  hr_upper                 = numeric(),
  treatment_median_months  = numeric(),
  comparator_median_months = numeric(),
  publication_used         = character(),
  source_type              = character(),
  data_cutoff_date         = character(),
  median_followup_months   = numeric(),
  estimand                 = character(),
  treatment_4yr_survival   = numeric(),
  comparator_4yr_survival  = numeric(),
  source                   = character()
)

if (!file.exists(tte_file)) {
  write_csv(tte, tte_file)
} else {
  message("File already exists: ", tte_file)
}


# patient-reported-outcomes.csv

pro_file <- "data/patient-reported-outcomes.csv"

pro <- tibble(
  trial_id     = character(),
  arm          = character(),
  instrument   = character(),  # EORTC QLQ-C30 / EQ-5D-5L
  timepoint    = character(),  # e.g. "day 100", "month 6"
  measure_type = character(),  # mean_change / responder_pct
  value        = numeric(),
  sd_or_se     = numeric(),
  n            = numeric(),
  source       = character(),
  notes        = character()
)

if (!file.exists(pro_file)) {
  write_csv(pro, pro_file)
} else {
  message("File already exists: ", pro_file)
}

# adverse-events.csv

ae_file <- "data/adverse-events.csv"

ae <- tibble(
  trial_id       = character(),
  arm            = character(),
  treatment      = character(),
  outcome        = character(),  # crs_any / crs_g3plus / icans_any / etc.
  events         = numeric(),
  n_safety       = numeric(),
  grading_system = character(),
  source         = character(),
  notes          = character()
)

if (!file.exists(ae_file)) {
  write_csv(ae, ae_file)
} else {
  message("File already exists: ", ae_file)
}