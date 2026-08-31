library(tibble)
library(readr)

# ------------------------------------------------------------------
# characteristics.csv
# ------------------------------------------------------------------
characteristics_file <- "data/characteristics.csv"

characteristics <- tibble(
  trial_name              = character(),  # zuma7 / transform / belinda
  nct                     = character(),  # NCT number
  car_t_product           = character(),  # axi-cel / liso-cel / tisa-cel
  primary_citation        = character(),  # e.g. "Locke 2022 NEJM"
  followup_citation       = character(),  # long-term paper
  data_cutoff_date        = character(),
  median_followup_months  = numeric(),
  randomization_ratio     = character(),
  bridging_chemo_allowed  = character(),  # yes / no (chemotherapy bridging)
  bridging_details        = character(),  # e.g. "glucocorticoids only"
  crossover_allowed       = character(),  # yes / no
  response_assessor       = character(),  # IRC / investigator
  efs_definition_verbatim = character(),  # quoted sentence + page
  crs_grading             = character(),  # e.g. Lee 2014 / ASTCT
  icans_grading           = character(),
  # arm-level
  arm                     = character(),  # car_t / soc
  treatment               = character(),  # axi-cel / liso-cel / tisa-cel / soc
  n_randomized            = numeric(),
  n_safety                = numeric(),    # as-treated population
  n_infused               = numeric(),    # CAR-T arm; blank for SOC
  median_age              = numeric(),
  pct_primary_refractory  = numeric(),
  pct_relapse_lt12mo      = numeric(),
  ipi_distribution        = character(),  # e.g. "IPI 0-1: 45%; 2-3: 55%"
  pct_stage_iii_iv        = numeric(),
  region_note             = character(),  # e.g. "heavily Asia/Australia"
  median_days_dx_to_infusion = numeric(), # CAR-T arm
  salvage_regimens        = character(),  # SOC arm
  pct_reached_asct        = numeric(),    # SOC arm
  pct_soc_subsequent_cart = numeric(),    # SOC arm
  source                  = character(),
  notes                   = character()
)
if (!file.exists(characteristics_file)) {
  write_csv(characteristics, characteristics_file)
} else {
  message("File already exists: ", characteristics_file)
}

# ------------------------------------------------------------------
# binary-data.csv
# ------------------------------------------------------------------
binary_file <- "data/binary-data.csv"

binary <- tibble(
  trial_id         = character(),
  arm              = character(),
  treatment        = character(),
  outcome          = character(),   # crr / orr
  events           = numeric(),     # verbatim count from paper
  n                = numeric(),
  denominator_type = character(),   # randomized = ITT
  assessor         = character(),   # IRC / investigator
  timepoint_note   = character(),   # e.g. "best response"
  source           = character()    # e.g. "Locke 2022 NEJM, Table 2"
)
if (!file.exists(binary_file)) {
  write_csv(binary, binary_file)
} else {
  message("File already exists: ", binary_file)
}

# ------------------------------------------------------------------
# time-to-event-data.csv
# ------------------------------------------------------------------
tte_file <- "data/time-to-event-data.csv"

tte <- tibble(
  trial_id               = character(),
  outcome                = character(),  # os / efs / pfs
  estimand               = character(),  # itt / rpsft_adjusted
  hr                     = numeric(),
  hr_lower               = numeric(),
  hr_upper               = numeric(),
  publication_used       = character(),  # initial / followup
  source_type            = character(),  # reported / reconstructed
  data_cutoff_date       = character(),
  median_followup_months = numeric(),
  source                 = character()
)
if (!file.exists(tte_file)) {
  write_csv(tte, tte_file)
} else {
  message("File already exists: ", tte_file)
}

# ------------------------------------------------------------------
# patient-reported-outcomes.csv
# ------------------------------------------------------------------
pro_file <- "data/patient-reported-outcomes.csv"

pro <- tibble(
  trial_id     = character(),
  arm          = character(),
  instrument   = character(),   # FACT-Lym / EQ-5D
  timepoint    = character(),   # e.g. "day 100", "month 6"
  measure_type = character(),   # mean_change / responder_pct
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

# ------------------------------------------------------------------
# adverse-events.csv
# ------------------------------------------------------------------
ae_file <- "data/adverse-events.csv"

ae <- tibble(
  trial_id       = character(),
  arm            = character(),
  treatment      = character(),
  outcome        = character(),  # crs_any / crs_g3plus / icans_any / etc.
  events         = numeric(),
  n_safety       = numeric(),    # as-treated denominator
  grading_system = character(),  # CRS/ICANS scale used
  source         = character(),  # usually supplementary appendix
  notes          = character()
)

if (!file.exists(ae_file)) {
  write_csv(ae, ae_file)
} else {
  message("File already exists: ", ae_file)
}