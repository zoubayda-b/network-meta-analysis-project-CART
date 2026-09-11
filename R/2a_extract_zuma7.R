library(tibble)
library(dplyr)
library(readr)

# Create data folder if it does not already exist
if (!dir.exists("data")) dir.create("data")

# Safe CSV reader
safe_read <- function(path) {
  if (!file.exists(path)) return(tibble())

  x <- read_csv(path, show_col_types = FALSE)

  if (nrow(x) == 0) return(tibble())

  x
}

# Read existing CSV files
characteristics_data <- safe_read("data/characteristics.csv")
binary_data          <- safe_read("data/binary-data.csv")
tte_data             <- safe_read("data/time-to-event-data.csv")
pro_data             <- safe_read("data/patient-reported-outcomes.csv")
ae_data              <- safe_read("data/adverse-events.csv")


# ============================================================
# ZUMA-7 CHARACTERISTICS
# ============================================================

zuma7_characteristics <- bind_rows(
  tibble(
    trial_name                 = "ZUMA-7",
    nct                        = "NCT03391466",
    car_t_product              = "Axicabtagene ciloleucel",
    primary_citation           = "Locke FL, et al. N Engl J Med 2022;386:640-654",
    followup_citation          = "Westin JR, et al. N Engl J Med 2023;389:148-157",
    data_cutoff_date           = "2021-03-18",
    median_followup_months     = 24.9,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "No",
    bridging_details           = "Glucocorticoids were permitted for disease control",
    crossover_allowed          = "No",
    response_assessor          = "Blinded central review",
    efs_definition_verbatim    = "Time from randomization to disease progression according to Lugano classification, commencement of new lymphoma therapy, or death from any cause",
    crr_definition_verbatim    = "Complete response according to the Lugano classification",
    crs_grading                = "Modified Lee 2014",
    icans_grading              = "CTCAE v4.03",
    arm                        = "car_t",
    treatment                  = "Axicabtagene ciloleucel (axi-cel); single infusion of 2×10^6 cells/kg after fludarabine/cyclophosphamide lymphodepletion",
    n_randomized               = 180,
    n_safety                   = 170,
    n_infused                  = 170,
    median_age                 = 58,
    pct_primary_refractory     = 74,
    pct_relapse_lt12mo         = 26,
    pct_ipi_distribution       = "Second-line age-adjusted IPI of 2 or 3: 46%",
    pct_stage_iii_iv           = 77,
    region_note                = "77 sites in 14 countries; North America 78%, Europe 19%, Israel/Australia ~3%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = NA_character_,
    pct_reached_asct            = NA_real_,
    pct_soc_subsequent_cart    = NA_real_,
    source                     = "Locke 2022 NEJM",
    notes                      = "Second-line LBCL; bridging chemotherapy prohibited; glucocorticoids permitted"
  ),

  tibble(
    trial_name                 = "ZUMA-7",
    nct                        = "NCT03391466",
    car_t_product              = "Axicabtagene ciloleucel",
    primary_citation           = "Locke FL, et al. N Engl J Med 2022;386:640-654",
    followup_citation          = "Westin JR, et al. N Engl J Med 2023;389:148-157",
    data_cutoff_date           = "2021-03-18",
    median_followup_months     = 24.9,
    randomization_ratio        = "1:1",
    bridging_chemo_allowed     = "No",
    bridging_details           = "Glucocorticoids were permitted for disease control",
    crossover_allowed          = "No",
    response_assessor          = "Blinded central review",
    efs_definition_verbatim    = "Time from randomization to disease progression according to Lugano classification, commencement of new lymphoma therapy, or death from any cause",
    crr_definition_verbatim    = "Complete response according to the Lugano classification",
    crs_grading                = "Modified Lee 2014",
    icans_grading              = "CTCAE v4.03",
    arm                        = "soc",
    treatment                  = "Investigator's choice of platinum-based chemoimmunotherapy followed by high-dose therapy and autologous stem-cell transplantation in eligible patients",
    n_randomized               = 179,
    n_safety                   = 168,
    n_infused                  = NA_real_,
    median_age                 = 60,
    pct_primary_refractory     = 73,
    pct_relapse_lt12mo         = 27,
    pct_ipi_distribution       = "Second-line age-adjusted IPI of 2 or 3: 44%",
    pct_stage_iii_iv           = 82,
    region_note                = "77 sites in 14 countries; North America 78%, Europe 19%, Israel/Australia ~3%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = NA_character_,
    pct_reached_asct            = 36,
    pct_soc_subsequent_cart    = 57,
    source                     = "Locke 2022 NEJM; Westin 2023 NEJM",
    notes                      = "Standard-care control arm; 57% subsequently received cellular immunotherapy off protocol"
  )
)

characteristics_data <- characteristics_data %>%
  {
    if ("trial_name" %in% names(.))
      filter(., trial_name != "ZUMA-7")
    else .
  } %>%
  bind_rows(zuma7_characteristics)

write_csv(characteristics_data, "data/characteristics.csv")


# ============================================================
# ZUMA-7 BINARY OUTCOMES
# ============================================================

zuma7_binary <- bind_rows(
  tibble(
    trial_id         = "ZUMA-7",
    arm              = "car_t",
    treatment        = "Axicabtagene ciloleucel",
    outcome          = "crr",
    events           = 117,
    n                = 180,
    denominator_type = "randomized",
    assessor         = "Blinded central review",
    timepoint_note   = "Primary analysis",
    source           = "Locke 2022 NEJM"
  ),

  tibble(
    trial_id         = "ZUMA-7",
    arm              = "soc",
    treatment        = "Standard care",
    outcome          = "crr",
    events           = 58,
    n                = 179,
    denominator_type = "randomized",
    assessor         = "Blinded central review",
    timepoint_note   = "Primary analysis",
    source           = "Locke 2022 NEJM"
  ),

  tibble(
    trial_id         = "ZUMA-7",
    arm              = "car_t",
    treatment        = "Axicabtagene ciloleucel",
    outcome          = "orr",
    events           = 150,
    n                = 180,
    denominator_type = "randomized",
    assessor         = "Blinded central review",
    timepoint_note   = "Primary analysis",
    source           = "Locke 2022 NEJM"
  ),

  tibble(
    trial_id         = "ZUMA-7",
    arm              = "soc",
    treatment        = "Standard care",
    outcome          = "orr",
    events           = 90,
    n                = 179,
    denominator_type = "randomized",
    assessor         = "Blinded central review",
    timepoint_note   = "Primary analysis",
    source           = "Locke 2022 NEJM"
  )
)

binary_data <- binary_data %>%
  {
    if ("trial_id" %in% names(.))
      filter(., trial_id != "ZUMA-7")
    else .
  } %>%
  bind_rows(zuma7_binary)

write_csv(binary_data, "data/binary-data.csv")


# ============================================================
# ZUMA-7 TIME-TO-EVENT OUTCOMES
# ============================================================

zuma7_tte <- bind_rows(
  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "efs",
    population               = "efficacy_set",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.40,
    hr_lower                 = 0.31,
    hr_upper                 = 0.51,
    treatment_median_months  = 8.3,
    comparator_median_months = 2.0,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2021-03-18",
    median_followup_months   = 24.9,
    estimand                 = NA_character_,
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Locke 2022 NEJM (primary EFS; blinded central review)"
  ),

  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "efs",
    population               = "efficacy_set",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.42,
    hr_lower                 = 0.33,
    hr_upper                 = 0.55,
    treatment_median_months  = 10.8,
    comparator_median_months = 2.3,
    publication_used         = "followup",
    source_type              = "reported",
    data_cutoff_date         = "2023-01-25",
    median_followup_months   = 47.2,
    estimand                 = NA_character_,
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Westin 2023 NEJM (updated EFS; investigator assessed)"
  ),

  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "pfs",
    population               = "itt",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.51,
    hr_lower                 = 0.38,
    hr_upper                 = 0.67,
    treatment_median_months  = 14.7,
    comparator_median_months = 3.7,
    publication_used         = "followup",
    source_type              = "reported",
    data_cutoff_date         = "2023-01-25",
    median_followup_months   = 47.2,
    estimand                 = NA_character_,
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Westin 2023 NEJM (investigator-assessed PFS)"
  ),

  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.73,
    hr_lower                 = 0.53,
    hr_upper                 = 1.01,
    treatment_median_months  = NA_real_,
    comparator_median_months = 35.1,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2021-03-18",
    median_followup_months   = 24.9,
    estimand                 = NA_character_,
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Locke 2022 NEJM"
  ),

  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.73,
    hr_lower                 = 0.54,
    hr_upper                 = 0.98,
    treatment_median_months  = NA_real_,
    comparator_median_months = 31.1,
    publication_used         = "followup",
    source_type              = "reported",
    data_cutoff_date         = "2023-01-25",
    median_followup_months   = 47.2,
    estimand                 = NA_character_,
    treatment_4yr_survival   = 0.546,
    comparator_4yr_survival  = 0.460,
    source                   = "Westin 2023 NEJM"
  ),

  tibble(
    trial_id                 = "ZUMA-7",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "axi_cel",
    comparator_arm           = "soc",
    hr                       = 0.58,
    hr_lower                 = 0.42,
    hr_upper                 = 0.81,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "initial",
    source_type              = "sensitivity_analysis",
    data_cutoff_date         = "2021-03-18",
    median_followup_months   = 24.9,
    estimand                 = "rpsft_adjusted",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Locke 2022 NEJM Supplement"
  )
)

tte_data <- tte_data %>%
  {
    if ("trial_id" %in% names(.))
      filter(., trial_id != "ZUMA-7")
    else .
  } %>%
  bind_rows(zuma7_tte)

write_csv(tte_data, "data/time-to-event-data.csv")


# ============================================================
# ZUMA-7 PATIENT-REPORTED OUTCOMES
# ============================================================

zuma7_pro <- bind_rows(
  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EORTC QLQ-C30 global health status/QoL",
    timepoint    = "day 100",
    measure_type = "mean_change",
    value        = 18.1,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); 95% CI 12.3-23.9; P < 0.0001"
  ),

  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EORTC QLQ-C30 physical functioning",
    timepoint    = "day 100",
    measure_type = "mean_change",
    value        = 13.1,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); 95% CI 8.0-18.2; P < 0.0001"
  ),

  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EQ-5D-5L VAS",
    timepoint    = "day 100",
    measure_type = "mean_change",
    value        = 13.7,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); 95% CI 8.5-18.8; P < 0.0001"
  ),

  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EORTC QLQ-C30 global health status/QoL",
    timepoint    = "day 150",
    measure_type = "mean_change",
    value        = 9.8,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); 95% CI 2.6-17.0; P = 0.0124"
  ),

  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EQ-5D-5L VAS",
    timepoint    = "day 150",
    measure_type = "mean_change",
    value        = 11.3,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); 95% CI 5.4-17.1; P = 0.0004"
  ),

  tibble(
    trial_id     = "ZUMA-7",
    arm          = "axi_cel",
    instrument   = "EQ-5D-5L index",
    timepoint    = "day 100",
    measure_type = "mean_change",
    value        = 0.081,
    sd_or_se     = NA_real_,
    n            = 165,
    source       = "ZUMA-7 PRO publication",
    notes        = "Between-arm difference in mean change from baseline (axi-cel vs SOC); US value set; 95% CI 0.024-0.138; P = 0.0112"
  )
)

pro_data <- pro_data %>%
  {
    if ("trial_id" %in% names(.))
      filter(., trial_id != "ZUMA-7")
    else .
  } %>%
  bind_rows(zuma7_pro)

write_csv(pro_data, "data/patient-reported-outcomes.csv")


# ============================================================
# ZUMA-7 ADVERSE EVENTS
# ============================================================

zuma7_ae <- bind_rows(
  tibble(
    trial_id       = "ZUMA-7",
    arm            = "car_t",
    treatment      = "Axi-cel",
    outcome        = "crs_any",
    events         = 157,
    n_safety       = 170,
    grading_system = "Modified Lee 2014",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "92%; no grade 5 CRS"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "car_t",
    treatment      = "Axi-cel",
    outcome        = "crs_g3plus",
    events         = 11,
    n_safety       = 170,
    grading_system = "Modified Lee 2014",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "6%; no grade 5 CRS"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "car_t",
    treatment      = "Axi-cel",
    outcome        = "icans_any",
    events         = 102,
    n_safety       = 170,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "60%; treatment-emergent neurologic events"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "car_t",
    treatment      = "Axi-cel",
    outcome        = "icans_g3plus",
    events         = 36,
    n_safety       = 170,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "21%; treatment-emergent neurologic events"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "soc",
    treatment      = "Standard care",
    outcome        = "icans_any",
    events         = 33,
    n_safety       = 168,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "20%; treatment-emergent neurologic events"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "soc",
    treatment      = "Standard care",
    outcome        = "icans_g3plus",
    events         = 1,
    n_safety       = 168,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "1%; treatment-emergent neurologic events"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "car_t",
    treatment      = "Axi-cel",
    outcome        = "teae",
    events         = 170,
    n_safety       = 170,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "100%"
  ),

  tibble(
    trial_id       = "ZUMA-7",
    arm            = "soc",
    treatment      = "Standard care",
    outcome        = "teae",
    events         = 168,
    n_safety       = 168,
    grading_system = "CTCAE v4.03",
    source         = "Locke 2022 NEJM Supplement",
    notes          = "100%"
  )
)

ae_data <- ae_data %>%
  {
    if ("trial_id" %in% names(.))
      filter(., trial_id != "ZUMA-7")
    else .
  } %>%
  bind_rows(zuma7_ae)

write_csv(ae_data, "data/adverse-events.csv")