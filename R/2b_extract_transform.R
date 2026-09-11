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
# CHARACTERISTICS — TRANSFORM
# ==================================================================

transform_characteristics <- bind_rows(

  tibble(
    trial_name                 = "TRANSFORM",
    nct                        = "NCT03575351",
    car_t_product              = "Lisocabtagene maraleucel",
    primary_citation           = "Abramson JS, et al. Blood 2023;141:1675-1684",
    followup_citation          = "Kamdar M, et al. J Clin Oncol 2025;43:2671-2678",
    data_cutoff_date           = "2022-05-13",
    median_followup_months     = 17.5,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "Yes",
    bridging_details           = "1 cycle of platinum-based standard-of-care regimen permitted",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Time from randomization to death from any cause, progressive disease, failure to achieve CR or PR by 9 weeks after randomization, or start of new antineoplastic therapy because of efficacy concerns, whichever occurred first",
    crr_definition_verbatim    = NA_character_,
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v4.03",
    arm                        = "car_t",
    treatment                  = "Lisocabtagene maraleucel (liso-cel)",
    n_randomized               = 92,
    n_safety                   = 92,
    n_infused                  = 89,
    median_age                 = 60,
    pct_primary_refractory     = 73,
    pct_relapse_lt12mo         = 27,
    pct_ipi_distribution       = "sAAIPI 0-1: 61%; 2-3: 39%",
    pct_stage_iii_iv           = 74,
    region_note                = "Multinational (US, Europe, Japan)",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = NA_character_,
    pct_reached_asct            = NA_real_,
    pct_soc_subsequent_cart    = NA_real_,
    source                     = "Abramson 2023 Blood",
    notes                      = "Second-line LBCL; bridging chemotherapy allowed (1 cycle); n_safety=92 and n_infused=89"
  ),

  tibble(
    trial_name                 = "TRANSFORM",
    nct                        = "NCT03575351",
    car_t_product              = "Lisocabtagene maraleucel",
    primary_citation           = "Abramson JS, et al. Blood 2023;141:1675-1684",
    followup_citation          = "Kamdar M, et al. J Clin Oncol 2025;43:2671-2678",
    data_cutoff_date           = "2022-05-13",
    median_followup_months     = 17.5,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "Yes",
    bridging_details           = "1 cycle of platinum-based standard-of-care regimen permitted",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Time from randomization to death from any cause, progressive disease, failure to achieve CR or PR by 9 weeks after randomization, or start of new antineoplastic therapy because of efficacy concerns, whichever occurred first",
    crr_definition_verbatim    = NA_character_,
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v4.03",
    arm                        = "soc",
    treatment                  = "Standard of care",
    n_randomized               = 92,
    n_safety                   = 91,
    n_infused                  = NA_real_,
    median_age                 = 58,
    pct_primary_refractory     = 76,
    pct_relapse_lt12mo         = 24,
    pct_ipi_distribution       = "sAAIPI 0-1: 60%; 2-3: 40%",
    pct_stage_iii_iv           = 68,
    region_note                = "Multinational (US, Europe, Japan)",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = "R-DHAP / R-ICE / R-GDP",
    pct_reached_asct            = 47,
    pct_soc_subsequent_cart    = 62,
    source                     = "Abramson 2023 Blood; Kamdar 2025 JCO",
    notes                      = "Second-line LBCL; protocol crossover to liso-cel allowed after IRC-confirmed failure"
  )
)

# Remove previous TRANSFORM rows if script is re-run
if ("trial_name" %in% names(characteristics)) {
  characteristics <- characteristics %>%
    filter(trial_name != "TRANSFORM")
}

# Prevent date-vs-character conflict with existing ZUMA-7 data
if ("data_cutoff_date" %in% names(characteristics)) {
  characteristics <- characteristics %>%
    mutate(data_cutoff_date = as.character(data_cutoff_date))
}

characteristics <- bind_rows(
  characteristics,
  transform_characteristics
)

write_csv(characteristics, "data/characteristics.csv")


# ==================================================================
# BINARY OUTCOMES — TRANSFORM
# ==================================================================

transform_binary <- tribble(
  ~trial_id,      ~arm,      ~treatment,                              ~outcome, ~events, ~n,  ~denominator_type, ~assessor, ~timepoint_note, ~source,

  "TRANSFORM",    "car_t",   "Lisocabtagene maraleucel (liso-cel)",   "CRR",    68,       92,   "ITT",             "IRC",     "Primary analysis", "Abramson 2023 Blood; Kamdar 2025 JCO",
  "TRANSFORM",    "soc",     "Standard of care",                      "CRR",    40,       92,   "ITT",             "IRC",     "Primary analysis", "Abramson 2023 Blood; Kamdar 2025 JCO",

  "TRANSFORM",    "car_t",   "Lisocabtagene maraleucel (liso-cel)",   "ORR",    80,       92,   "ITT",             "IRC",     "Primary analysis", "Abramson 2023 Blood; Kamdar 2025 JCO",
  "TRANSFORM",    "soc",     "Standard of care",                      "ORR",    45,       92,   "ITT",             "IRC",     "Primary analysis", "Abramson 2023 Blood; Kamdar 2025 JCO"
)

if ("trial_id" %in% names(binary_data)) {
  binary_data <- binary_data %>%
    filter(trial_id != "TRANSFORM")
}

binary_data <- bind_rows(
  binary_data,
  transform_binary
)

write_csv(binary_data, "data/binary-data.csv")


# ==================================================================
# TIME-TO-EVENT OUTCOMES — TRANSFORM
# ==================================================================

transform_tte <- tribble(
  ~trial_id,   ~outcome, ~population, ~treatment_arm, ~comparator_arm,
  ~hr, ~hr_lower, ~hr_upper,
  ~treatment_median_months, ~comparator_median_months,
  ~publication_used, ~source_type, ~data_cutoff_date,
  ~median_followup_months, ~estimand,
  ~treatment_4yr_survival, ~comparator_4yr_survival, ~source,

  "TRANSFORM", "EFS", "itt", "liso_cel", "soc",
  0.356, 0.243, 0.522,
  NA_real_, NA_real_,
  "Abramson 2023 Blood", "primary",
  "2022-05-13",
  17.5, "itt",
  NA_real_, NA_real_,
  "Abramson 2023 Blood",

  "TRANSFORM", "EFS", "itt", "liso_cel", "soc",
  0.375, 0.259, 0.542,
  NA_real_, NA_real_,
  "Kamdar 2025 JCO", "follow-up",
  "2023-10-23",
  33.9, "itt",
  NA_real_, NA_real_,
  "Kamdar 2025 JCO",

  "TRANSFORM", "PFS", "itt", "liso_cel", "soc",
  0.422, 0.279, 0.639,
  NA_real_, NA_real_,
  "Kamdar 2025 JCO", "follow-up",
  "2023-10-23",
  33.9, "itt",
  NA_real_, NA_real_,
  "Kamdar 2025 JCO",

  "TRANSFORM", "OS", "itt", "liso_cel", "soc",
  0.724, 0.443, 1.183,
  NA_real_, NA_real_,
  "Abramson 2023 Blood", "primary",
  "2022-05-13",
  17.5, "itt",
  NA_real_, NA_real_,
  "Abramson 2023 Blood",

  "TRANSFORM", "OS", "itt", "liso_cel", "soc",
  0.757, 0.481, 1.191,
  NA_real_, NA_real_,
  "Kamdar 2025 JCO", "follow-up",
  "2023-10-23",
  33.9, "itt",
  NA_real_, NA_real_,
  "Kamdar 2025 JCO",

  "TRANSFORM", "OS", "itt", "liso_cel", "soc",
  0.335, 0.189, 0.594,
  NA_real_, NA_real_,
  "Kamdar 2025 JCO", "follow-up",
  "2023-10-23",
  33.9, "rpsft_adjusted",
  NA_real_, NA_real_,
  "Kamdar 2025 JCO; two-stage AFT HR 0.566 (95% CI 0.359-0.895)"
)

if ("trial_id" %in% names(tte_data)) {
  tte_data <- tte_data %>%
    filter(trial_id != "TRANSFORM")
}

# Prevent date-type conflicts
if ("data_cutoff_date" %in% names(tte_data)) {
  tte_data <- tte_data %>%
    mutate(data_cutoff_date = as.character(data_cutoff_date))
}

transform_tte <- transform_tte %>%
  mutate(data_cutoff_date = as.character(data_cutoff_date))

tte_data <- bind_rows(
  tte_data,
  transform_tte
)

write_csv(tte_data, "data/time-to-event-data.csv")


# ==================================================================
# PATIENT-REPORTED OUTCOMES — TRANSFORM
# ==================================================================

transform_pro <- tribble(
  ~trial_id,   ~arm,      ~instrument,     ~timepoint,              ~measure_type, ~value, ~sd_or_se, ~n, ~source, ~notes,

  "TRANSFORM", "liso_cel", "EORTC QLQ-C30", "time-to-deterioration",
  "global_health_status_QoL_HR",
  0.47, NA_real_, 47,
  "Abramson 2022 Blood Advances",
  "HR 0.47 (95% CI 0.24-0.94) vs SOC; median NR vs 19.0 weeks; PRO-evaluable population: 47 liso-cel and 43 SOC",

  "TRANSFORM", "liso_cel", "EORTC QLQ-C30", "month_6",
  "fatigue_MMRM_between_arm_difference",
  -5.7, NA_real_, 47,
  "Abramson 2022 Blood Advances",
  "MMRM between-arm difference at month 6; negative value favors liso-cel",

  "TRANSFORM", "liso_cel", "EORTC QLQ-C30", "through_month_36",
  "cognitive_functioning_MMRM_between_arm_difference",
  4.3, NA_real_, 47,
  "Abramson 2022 Blood Advances",
  "MMRM between-arm difference through month 36"
)

if ("trial_id" %in% names(pro_data)) {
  pro_data <- pro_data %>%
    filter(trial_id != "TRANSFORM")
}

pro_data <- bind_rows(
  pro_data,
  transform_pro
)

write_csv(pro_data, "data/patient-reported-outcomes.csv")


# ==================================================================
# ADVERSE EVENTS — TRANSFORM
# ==================================================================

transform_ae <- tribble(
  ~trial_id,   ~arm,      ~treatment,                            ~outcome,       ~events, ~n_safety, ~grading_system, ~source, ~notes,

  "TRANSFORM", "car_t",   "Lisocabtagene maraleucel (liso-cel)", "crs_any",      45,       92,       "Lee 2014",       "Abramson 2023 Blood Supplement", "Any-grade CRS",

  "TRANSFORM", "car_t",   "Lisocabtagene maraleucel (liso-cel)", "crs_g3plus",    1,       92,       "Lee 2014",       "Abramson 2023 Blood Supplement", "Single grade-3 CRS; no grade 4/5 CRS",

  "TRANSFORM", "car_t",   "Lisocabtagene maraleucel (liso-cel)", "icans_any",    10,       92,       "CTCAE v4.03",    "Abramson 2023 Blood Supplement", "Any-grade neurologic/ICANS event",

  "TRANSFORM", "car_t",   "Lisocabtagene maraleucel (liso-cel)", "icans_g3plus",  4,       92,       "CTCAE v4.03",    "Abramson 2023 Blood Supplement", "Grade 3 only; no grade 4/5 neurologic events",

  "TRANSFORM", "car_t",   "Lisocabtagene maraleucel (liso-cel)", "teae_any",     92,       92,       NA_character_,    "Abramson 2023 Blood Supplement", "Any treatment-emergent adverse event",

  "TRANSFORM", "soc",     "Standard of care",                    "teae_any",     90,       91,       NA_character_,    "Abramson 2023 Blood Supplement", "Any treatment-emergent adverse event"
)

if ("trial_id" %in% names(ae_data)) {
  ae_data <- ae_data %>%
    filter(trial_id != "TRANSFORM")
}

ae_data <- bind_rows(
  ae_data,
  transform_ae
)

write_csv(ae_data, "data/adverse-events.csv")


