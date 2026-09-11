# ==================================================================
# BELINDA EXTRACTION
# ==================================================================

library(tidyverse)

# ------------------------------------------------------------------
# SAFE CSV READER
# ------------------------------------------------------------------

safe_read <- function(path) {
  if (!file.exists(path)) return(tibble())

  x <- read_csv(path, show_col_types = FALSE)

  if (nrow(x) == 0) return(tibble())

  x
}

# ------------------------------------------------------------------
# READ EXISTING DATA
# ------------------------------------------------------------------

characteristics <- safe_read("data/characteristics.csv")
binary_data     <- safe_read("data/binary-data.csv")
tte_data        <- safe_read("data/time-to-event-data.csv")
ae_data         <- safe_read("data/adverse-events.csv")
pro_data        <- safe_read("data/patient-reported-outcomes.csv")


# ==================================================================
# CHARACTERISTICS — BELINDA
# ==================================================================

belinda_characteristics <- bind_rows(

  tibble(
    trial_name                 = "BELINDA",
    nct                        = "NCT03570892",
    car_t_product              = "Tisagenlecleucel",
    primary_citation           = "Bishop MR, et al. N Engl J Med 2022;386:629-639",
    followup_citation          = NA_character_,
    data_cutoff_date           = "2021-05-06",
    median_followup_months     = 10.0,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "Yes",
    bridging_details           = "Investigator choice of protocol-specified bridging chemotherapy; 135/162 (83.3%) received bridging therapy",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Event-free survival was defined as time from randomization to stable or progressive disease at or after the week 12 assessment by the independent review committee according to the Lugano criteria, or death at any time",
    crr_definition_verbatim    = "Complete response according to Lugano criteria, assessed by independent review committee",
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v5.0",
    arm                        = "car_t",
    treatment                  = "Tisagenlecleucel (tisa-cel)",
    n_randomized               = 162,
    n_safety                   = 162,
    n_infused                  = 155,
    median_age                 = 59.5,
    pct_primary_refractory     = 66,
    pct_relapse_lt12mo         = 34,
    pct_ipi_distribution       = "IPI >=2: 65%; <2: 35%",
    pct_stage_iii_iv           = 66,
    region_note                = "65 centers in 18 countries; US 29.6%, non-US 70.4%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = NA_character_,
    pct_reached_asct           = NA_real_,
    pct_soc_subsequent_cart    = NA_real_,
    source                     = "Bishop 2022 NEJM",
    notes                      = "Second-line LBCL; 25.9% had progressive disease at week 6 versus 13.8% with SOC"
  ),

  tibble(
    trial_name                 = "BELINDA",
    nct                        = "NCT03570892",
    car_t_product              = "Tisagenlecleucel",
    primary_citation           = "Bishop MR, et al. N Engl J Med 2022;386:629-639",
    followup_citation          = NA_character_,
    data_cutoff_date           = "2021-05-06",
    median_followup_months     = 10.0,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "Yes",
    bridging_details           = "Investigator choice of protocol-specified salvage/bridging chemotherapy",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Event-free survival was defined as time from randomization to stable or progressive disease at or after the week 12 assessment by the independent review committee according to the Lugano criteria, or death at any time",
    crr_definition_verbatim    = "Complete response according to Lugano criteria, assessed by independent review committee",
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v5.0",
    arm                        = "soc",
    treatment                  = "Standard of care",
    n_randomized               = 160,
    n_safety                   = 160,
    n_infused                  = NA_real_,
    median_age                 = 58,
    pct_primary_refractory     = 67,
    pct_relapse_lt12mo         = 33,
    pct_ipi_distribution       = "IPI >=2: 58%; <2: 42%",
    pct_stage_iii_iv           = 61,
    region_note                = "65 centers in 18 countries; US 29.6%, non-US 70.4%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = "R-DHAP / R-GDP / R-GemOx / R-ICE",
    pct_reached_asct            = 32.5,
    pct_soc_subsequent_cart    = 50.6,
    source                     = "Bishop 2022 NEJM",
    notes                      = "Second-line LBCL; 81/160 patients crossed over to receive tisa-cel"
  )
)

# Remove previous BELINDA rows
if ("trial_name" %in% names(characteristics)) {
  characteristics <- characteristics %>%
    filter(trial_name != "BELINDA")
}

# Fix date type before combining with BELINDA
if ("data_cutoff_date" %in% names(characteristics)) {
  characteristics <- characteristics %>%
    mutate(data_cutoff_date = as.character(data_cutoff_date))
}

belinda_characteristics <- belinda_characteristics %>%
  mutate(data_cutoff_date = as.character(data_cutoff_date))

characteristics <- bind_rows(
  characteristics,
  belinda_characteristics
)

write_csv(characteristics, "data/characteristics.csv")


# ==================================================================
# BINARY OUTCOMES — BELINDA
# ==================================================================

belinda_binary <- tribble(
  ~trial_id, ~arm, ~treatment, ~outcome, ~events, ~n,
  ~denominator_type, ~assessor, ~timepoint_note, ~source,

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "CRR", 46, 162,
  "randomized", "IRC",
  "Best overall response at or after week 12",
  "Bishop 2022 NEJM Table 2",

  "BELINDA", "soc", "Standard of care",
  "CRR", 44, 160,
  "randomized", "IRC",
  "Best overall response at or after week 12",
  "Bishop 2022 NEJM Table 2",

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "ORR", 75, 162,
  "randomized", "IRC",
  "Best overall response at or after week 12",
  "Bishop 2022 NEJM Table 2",

  "BELINDA", "soc", "Standard of care",
  "ORR", 68, 160,
  "randomized", "IRC",
  "Best overall response at or after week 12",
  "Bishop 2022 NEJM Table 2"
)

# Remove previous BELINDA rows
if ("trial_id" %in% names(binary_data)) {
  binary_data <- binary_data %>%
    filter(trial_id != "BELINDA")
}

binary_data <- bind_rows(
  binary_data,
  belinda_binary
)

write_csv(binary_data, "data/binary-data.csv")


# ==================================================================
# TIME-TO-EVENT — BELINDA
# ==================================================================

belinda_tte <- tribble(
  ~trial_id, ~outcome, ~population, ~treatment_arm, ~comparator_arm,
  ~hr, ~hr_lower, ~hr_upper,
  ~treatment_median_months, ~comparator_median_months,
  ~publication_used, ~source_type, ~data_cutoff_date,
  ~median_followup_months, ~estimand,
  ~treatment_4yr_survival, ~comparator_4yr_survival, ~source,

  "BELINDA", "EFS", "itt", "tisa_cel", "soc",
  1.07, 0.82, 1.40,
  3.0, 3.0,
  "Bishop 2022 NEJM", "reported",
  "2021-05-06",
  10.0, "itt",
  NA_real_, NA_real_,
  "Bishop 2022 NEJM; primary stratified analysis, P=0.61",

  "BELINDA", "EFS", "itt", "tisa_cel", "soc",
  0.95, 0.72, 1.25,
  3.0, 3.0,
  "Bishop 2022 NEJM", "reported",
  "2021-05-06",
  10.0, "covariate_adjusted",
  NA_real_, NA_real_,
  "Bishop 2022 NEJM Table S5; covariate-adjusted supportive analysis",

  "BELINDA", "OS", "itt", "tisa_cel", "soc",
  1.24, 0.83, 1.85,
  NA_real_, NA_real_,
  "Bishop 2022 NEJM", "reported",
  "2021-05-06",
  10.0, "itt",
  NA_real_, NA_real_,
  "Bishop 2022 NEJM; stratified unadjusted HR for death; OS immature",

  "BELINDA", "OS", "itt", "tisa_cel", "soc",
  0.99, 0.64, 1.52,
  NA_real_, NA_real_,
  "Bishop 2022 NEJM", "reported",
  "2021-05-06",
  10.0, "covariate_adjusted",
  NA_real_, NA_real_,
  "Bishop 2022 NEJM; covariate-adjusted OS analysis"
)

# Remove previous BELINDA rows
if ("trial_id" %in% names(tte_data)) {
  tte_data <- tte_data %>%
    filter(trial_id != "BELINDA")
}

# Fix date type before combining
if ("data_cutoff_date" %in% names(tte_data)) {
  tte_data <- tte_data %>%
    mutate(data_cutoff_date = as.character(data_cutoff_date))
}

belinda_tte <- belinda_tte %>%
  mutate(data_cutoff_date = as.character(data_cutoff_date))

tte_data <- bind_rows(
  tte_data,
  belinda_tte
)

write_csv(tte_data, "data/time-to-event-data.csv")


# ==================================================================
# ADVERSE EVENTS — BELINDA
# ==================================================================

belinda_ae <- tribble(
  ~trial_id, ~arm, ~treatment, ~outcome, ~events, ~n_safety,
  ~grading_system, ~source, ~notes,

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "crs_any", 95, 155,
  "Lee 2014",
  "Bishop 2022 NEJM",
  "Any-grade CRS; denominator = 155 infused tisa-cel patients",

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "crs_g3plus", 8, 155,
  "Lee 2014",
  "Bishop 2022 NEJM",
  "Grade >=3 CRS; denominator = 155 infused patients",

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "icans_any", 16, 155,
  "CTCAE v5.0",
  "Bishop 2022 NEJM",
  "Any-grade neurologic events; paper does not use the term ICANS; denominator = 155 infused patients",

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "icans_g3plus", 3, 155,
  "CTCAE v5.0",
  "Bishop 2022 NEJM",
  "Grade >=3 neurologic events; denominator = 155 infused patients",

  "BELINDA", "car_t", "Tisagenlecleucel (tisa-cel)",
  "teae_any", 160, 162,
  "CTCAE v5.0",
  "Bishop 2022 NEJM",
  "Any treatment-emergent adverse event; 98.8% of 162 randomized patients",

  "BELINDA", "soc", "Standard of care",
  "teae_any", 158, 160,
  "CTCAE v5.0",
  "Bishop 2022 NEJM",
  "Any treatment-emergent adverse event; 98.8% of 160 randomized patients"
)

# Remove previous BELINDA rows
if ("trial_id" %in% names(ae_data)) {
  ae_data <- ae_data %>%
    filter(trial_id != "BELINDA")
}

ae_data <- bind_rows(
  ae_data,
  belinda_ae
)

write_csv(ae_data, "data/adverse-events.csv")


# ==================================================================
# PATIENT-REPORTED OUTCOMES — BELINDA
# ==================================================================

# No BELINDA PRO rows extracted.
# No peer-reviewed PRO publication is included in this dataset.

