# 02b_extract_transform.R
# TRANSFORM numbers. Primary analysis: Abramson 2023 (Blood 141:1675-1684).
# Updated survival: Kamdar 2025 (J Clin Oncol 43:2671-2678), 3-year follow-up.

library(tibble)
library(dplyr)
library(readr)

if (!dir.exists("data")) dir.create("data")

replace_trial <- function(path, new_rows, key, trial) {
  if (file.exists(path)) {
    old <- read_csv(path, show_col_types = FALSE)
  } else {
    old <- tibble()
  }
  if ("data_cutoff_date" %in% names(old)) {
    old <- mutate(old, data_cutoff_date = as.character(data_cutoff_date))
  }
  if (nrow(old) > 0) old <- old[old[[key]] != trial, ]
  write_csv(bind_rows(old, new_rows), path)
}


# ------------------------------------------------------------------
# characteristics
# ------------------------------------------------------------------

transform_chars <- bind_rows(

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
    bridging_details           = "One cycle of a platinum-based regimen was allowed",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Time from randomization to death from any cause, progressive disease, failure to achieve CR or PR by 9 weeks after randomization, or start of new antineoplastic therapy because of efficacy concerns, whichever occurred first",
    crr_definition_verbatim    = NA_character_,
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v4.03",
    arm                        = "car_t",
    treatment                  = "Lisocabtagene maraleucel",
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
    pct_reached_asct           = NA_real_,
    pct_soc_subsequent_cart    = NA_real_,
    source                     = "Abramson 2023 Blood",
    notes                      = "Bridging chemotherapy allowed; 89 of 92 randomized were infused"
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
    bridging_details           = "One cycle of a platinum-based regimen was allowed",
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
    pct_reached_asct           = 47,
    pct_soc_subsequent_cart    = 67,
    source                     = "Abramson 2023 Blood; Kamdar 2025 JCO",
    notes                      = "61 of 91 treated patients in this arm crossed over to liso-cel (67%, primary analysis); 47% reached ASCT"
  )
)

replace_trial("data/characteristics.csv", transform_chars, "trial_name", "TRANSFORM")


# ------------------------------------------------------------------
# binary outcomes
# Response rates are from the primary analysis; the 3-year paper reports
# the same numbers, so they are not re-extracted there.
# ------------------------------------------------------------------

transform_binary <- bind_rows(
  tibble(
    trial_id         = "TRANSFORM",
    arm              = "car_t",
    treatment        = "Lisocabtagene maraleucel",
    outcome          = "crr",
    events           = 68,
    n                = 92,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Primary analysis",
    source           = "Abramson 2023 Blood Table 2"
  ),
  tibble(
    trial_id         = "TRANSFORM",
    arm              = "soc",
    treatment        = "Standard of care",
    outcome          = "crr",
    events           = 40,
    n                = 92,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Primary analysis",
    source           = "Abramson 2023 Blood Table 2"
  ),
  tibble(
    trial_id         = "TRANSFORM",
    arm              = "car_t",
    treatment        = "Lisocabtagene maraleucel",
    outcome          = "orr",
    events           = 80,
    n                = 92,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Primary analysis",
    source           = "Abramson 2023 Blood Table 2"
  ),
  tibble(
    trial_id         = "TRANSFORM",
    arm              = "soc",
    treatment        = "Standard of care",
    outcome          = "orr",
    events           = 45,
    n                = 92,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Primary analysis",
    source           = "Abramson 2023 Blood Table 2"
  )
)

replace_trial("data/binary-data.csv", transform_binary, "trial_id", "TRANSFORM")


# ------------------------------------------------------------------
# time to event
# ------------------------------------------------------------------

transform_tte <- bind_rows(
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "efs",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.356,
    hr_lower                 = 0.243,
    hr_upper                 = 0.522,
    treatment_median_months  = NA_real_,
    comparator_median_months = 2.4,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2022-05-13",
    median_followup_months   = 17.5,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Abramson 2023 Blood (EFS by IRC)"
  ),
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "efs",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.375,
    hr_lower                 = 0.259,
    hr_upper                 = 0.542,
    treatment_median_months  = 29.5,
    comparator_median_months = 2.4,
    publication_used         = "follow-up",
    source_type              = "reported",
    data_cutoff_date         = "2023-10-23",
    median_followup_months   = 33.9,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Kamdar 2025 JCO (3-year EFS)"
  ),
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "pfs",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.422,
    hr_lower                 = 0.279,
    hr_upper                 = 0.639,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "follow-up",
    source_type              = "reported",
    data_cutoff_date         = "2023-10-23",
    median_followup_months   = 33.9,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Kamdar 2025 JCO (PFS)"
  ),
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.724,
    hr_lower                 = 0.443,
    hr_upper                 = 1.183,
    treatment_median_months  = NA_real_,
    comparator_median_months = 29.9,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2022-05-13",
    median_followup_months   = 17.5,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Abramson 2023 Blood"
  ),
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.757,
    hr_lower                 = 0.481,
    hr_upper                 = 1.191,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "follow-up",
    source_type              = "reported",
    data_cutoff_date         = "2023-10-23",
    median_followup_months   = 33.9,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Kamdar 2025 JCO"
  ),
  tibble(
    trial_id                 = "TRANSFORM",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "liso_cel",
    comparator_arm           = "soc",
    hr                       = 0.335,
    hr_lower                 = 0.189,
    hr_upper                 = 0.594,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "follow-up",
    source_type              = "sensitivity_analysis",
    data_cutoff_date         = "2023-10-23",
    median_followup_months   = 33.9,
    estimand                 = "rpsft_adjusted",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Kamdar 2025 JCO (adjusted for crossover; the paper also reports a two-stage AFT estimate, HR 0.566, 95% CI 0.359-0.895)"
  )
)

replace_trial("data/time-to-event-data.csv", transform_tte, "trial_id", "TRANSFORM")


# ------------------------------------------------------------------
# patient reported outcomes
# ------------------------------------------------------------------

transform_pro <- bind_rows(
  tibble(
    trial_id     = "TRANSFORM",
    arm          = "car_t",
    instrument   = "EORTC QLQ-C30 global health status",
    timepoint    = "time to deterioration",
    measure_type = "hazard_ratio",
    value        = 0.47,
    sd_or_se     = NA_real_,
    n            = 47,
    source       = "Abramson 2022 Blood Advances",
    notes        = "HR 0.47 (95% CI 0.24-0.94) for time to deterioration, liso-cel vs SOC; PRO-evaluable 47 liso-cel and 43 SOC"
  ),
  tibble(
    trial_id     = "TRANSFORM",
    arm          = "car_t",
    instrument   = "EORTC QLQ-C30 fatigue",
    timepoint    = "month 6",
    measure_type = "between_arm_diff_MMRM",
    value        = -5.7,
    sd_or_se     = NA_real_,
    n            = 47,
    source       = "Abramson 2022 Blood Advances",
    notes        = "MMRM difference at month 6; negative favours liso-cel"
  ),
  tibble(
    trial_id     = "TRANSFORM",
    arm          = "car_t",
    instrument   = "EORTC QLQ-C30 cognitive functioning",
    timepoint    = "through month 36",
    measure_type = "between_arm_diff_MMRM",
    value        = 4.3,
    sd_or_se     = NA_real_,
    n            = 47,
    source       = "Abramson 2022 Blood Advances",
    notes        = "MMRM difference through month 36"
  )
)

replace_trial("data/patient-reported-outcomes.csv", transform_pro, "trial_id", "TRANSFORM")


# ------------------------------------------------------------------
# adverse events (safety population)
# ------------------------------------------------------------------

transform_ae <- bind_rows(
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "car_t",
    treatment      = "Lisocabtagene maraleucel",
    outcome        = "crs_any",
    events         = 45,
    n_safety       = 92,
    grading_system = "Lee 2014",
    source         = "Abramson 2023 Blood Supplement",
    notes          = "Any grade CRS"
  ),
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "car_t",
    treatment      = "Lisocabtagene maraleucel",
    outcome        = "crs_g3plus",
    events         = 1,
    n_safety       = 92,
    grading_system = "Lee 2014",
    source         = "Abramson 2023 Blood Supplement",
    notes          = "One grade 3 event; no grade 4 or 5"
  ),
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "car_t",
    treatment      = "Lisocabtagene maraleucel",
    outcome        = "icans_any",
    events         = 10,
    n_safety       = 92,
    grading_system = "CTCAE v4.03",
    source         = "Abramson 2023 Blood Supplement",
    notes          = "Any grade neurologic event"
  ),
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "car_t",
    treatment      = "Lisocabtagene maraleucel",
    outcome        = "icans_g3plus",
    events         = 4,
    n_safety       = 92,
    grading_system = "CTCAE v4.03",
    source         = "Abramson 2023 Blood Supplement",
    notes          = "Grade 3 only; no grade 4 or 5"
  ),
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "car_t",
    treatment      = "Lisocabtagene maraleucel",
    outcome        = "teae_any",
    events         = 92,
    n_safety       = 92,
    grading_system = NA_character_,
    source         = "Abramson 2023 Blood Supplement",
    notes          = "Any treatment-emergent adverse event"
  ),
  tibble(
    trial_id       = "TRANSFORM",
    arm            = "soc",
    treatment      = "Standard of care",
    outcome        = "teae_any",
    events         = 90,
    n_safety       = 91,
    grading_system = NA_character_,
    source         = "Abramson 2023 Blood Supplement",
    notes          = "Any treatment-emergent adverse event"
  )
)

replace_trial("data/adverse-events.csv", transform_ae, "trial_id", "TRANSFORM")
