# 02c_extract_belinda.R
# BELINDA numbers, from Bishop 2022 (N Engl J Med 386:629-639).
# No long term journal follow-up was available at the data cut-off.

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

belinda_chars <- bind_rows(

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
    bridging_details           = "Investigator choice of four protocol-specified platinum regimens; 135 of 162 (83.3%) received bridging therapy",
    crossover_allowed          = "Yes",
    response_assessor          = "IRC",
    efs_definition_verbatim    = "Event-free survival was defined as time from randomization to stable or progressive disease at or after the week 12 assessment by the independent review committee according to the Lugano criteria, or death at any time",
    crr_definition_verbatim    = "Complete response according to Lugano criteria, assessed by independent review committee",
    crs_grading                = "Lee 2014",
    icans_grading              = "CTCAE v5.0",
    arm                        = "car_t",
    treatment                  = "Tisagenlecleucel",
    n_randomized               = 162,
    n_safety                   = 162,
    n_infused                  = 155,
    median_age                 = 59.5,
    pct_primary_refractory     = 66,
    pct_relapse_lt12mo         = 34,
    pct_ipi_distribution       = "IPI >=2: 65%; <2: 35%",
    pct_stage_iii_iv           = 66,
    region_note                = "65 centres in 18 countries; US 29.6%, non-US 70.4%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = NA_character_,
    pct_reached_asct           = NA_real_,
    pct_soc_subsequent_cart    = NA_real_,
    source                     = "Bishop 2022 NEJM",
    notes                      = "25.9% had progressive disease at week 6 versus 13.8% in the SOC arm"
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
    bridging_details           = "Investigator choice of four protocol-specified platinum regimens",
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
    region_note                = "65 centres in 18 countries; US 29.6%, non-US 70.4%",
    median_days_dx_to_infusion = NA_real_,
    salvage_regimens           = "R-DHAP / R-GDP / R-GemOx / R-ICE",
    pct_reached_asct           = 32.5,
    pct_soc_subsequent_cart    = 50.6,
    source                     = "Bishop 2022 NEJM",
    notes                      = "81 of 160 patients in this arm crossed over to tisa-cel (50.6%)"
  )
)

replace_trial("data/characteristics.csv", belinda_chars, "trial_name", "BELINDA")


# ------------------------------------------------------------------
# binary outcomes (best response at or after week 12, ITT denominators)
# ------------------------------------------------------------------

belinda_binary <- bind_rows(
  tibble(
    trial_id         = "BELINDA",
    arm              = "car_t",
    treatment        = "Tisagenlecleucel",
    outcome          = "crr",
    events           = 46,
    n                = 162,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Best overall response at or after week 12",
    source           = "Bishop 2022 NEJM Table 2"
  ),
  tibble(
    trial_id         = "BELINDA",
    arm              = "soc",
    treatment        = "Standard of care",
    outcome          = "crr",
    events           = 44,
    n                = 160,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Best overall response at or after week 12",
    source           = "Bishop 2022 NEJM Table 2"
  ),
  tibble(
    trial_id         = "BELINDA",
    arm              = "car_t",
    treatment        = "Tisagenlecleucel",
    outcome          = "orr",
    events           = 75,
    n                = 162,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Best overall response at or after week 12",
    source           = "Bishop 2022 NEJM Table 2"
  ),
  tibble(
    trial_id         = "BELINDA",
    arm              = "soc",
    treatment        = "Standard of care",
    outcome          = "orr",
    events           = 68,
    n                = 160,
    denominator_type = "randomized",
    assessor         = "IRC",
    timepoint_note   = "Best overall response at or after week 12",
    source           = "Bishop 2022 NEJM Table 2"
  )
)

replace_trial("data/binary-data.csv", belinda_binary, "trial_id", "BELINDA")


# ------------------------------------------------------------------
# time to event
# PFS was not reported, so BELINDA is left out of the PFS analysis.
# ------------------------------------------------------------------

belinda_tte <- bind_rows(
  tibble(
    trial_id                 = "BELINDA",
    outcome                  = "efs",
    population               = "itt",
    treatment_arm            = "tisa_cel",
    comparator_arm           = "soc",
    hr                       = 1.07,
    hr_lower                 = 0.82,
    hr_upper                 = 1.40,
    treatment_median_months  = 3.0,
    comparator_median_months = 3.0,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2021-05-06",
    median_followup_months   = 10.0,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Bishop 2022 NEJM (stratified analysis, P = 0.61)"
  ),
  tibble(
    trial_id                 = "BELINDA",
    outcome                  = "efs",
    population               = "itt",
    treatment_arm            = "tisa_cel",
    comparator_arm           = "soc",
    hr                       = 0.95,
    hr_lower                 = 0.72,
    hr_upper                 = 1.25,
    treatment_median_months  = 3.0,
    comparator_median_months = 3.0,
    publication_used         = "initial",
    source_type              = "sensitivity_analysis",
    data_cutoff_date         = "2021-05-06",
    median_followup_months   = 10.0,
    estimand                 = "covariate_adjusted",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Bishop 2022 NEJM Table S5 (covariate adjusted)"
  ),
  tibble(
    trial_id                 = "BELINDA",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "tisa_cel",
    comparator_arm           = "soc",
    hr                       = 1.24,
    hr_lower                 = 0.83,
    hr_upper                 = 1.85,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "initial",
    source_type              = "reported",
    data_cutoff_date         = "2021-05-06",
    median_followup_months   = 10.0,
    estimand                 = "itt",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Bishop 2022 NEJM (unadjusted HR; OS immature)"
  ),
  tibble(
    trial_id                 = "BELINDA",
    outcome                  = "os",
    population               = "itt",
    treatment_arm            = "tisa_cel",
    comparator_arm           = "soc",
    hr                       = 0.99,
    hr_lower                 = 0.64,
    hr_upper                 = 1.52,
    treatment_median_months  = NA_real_,
    comparator_median_months = NA_real_,
    publication_used         = "initial",
    source_type              = "sensitivity_analysis",
    data_cutoff_date         = "2021-05-06",
    median_followup_months   = 10.0,
    estimand                 = "covariate_adjusted",
    treatment_4yr_survival   = NA_real_,
    comparator_4yr_survival  = NA_real_,
    source                   = "Bishop 2022 NEJM (covariate adjusted, not a crossover adjustment)"
  )
)

replace_trial("data/time-to-event-data.csv", belinda_tte, "trial_id", "BELINDA")


# ------------------------------------------------------------------
# adverse events
# CRS and ICANS use the 155 infused patients as the denominator.
# The two TEAE counts were back-calculated from the reported 98.8% and are
# flagged here so they are not mistaken for raw counts.
# ------------------------------------------------------------------

belinda_ae <- bind_rows(
  tibble(
    trial_id       = "BELINDA",
    arm            = "car_t",
    treatment      = "Tisagenlecleucel",
    outcome        = "crs_any",
    events         = 95,
    n_safety       = 155,
    grading_system = "Lee 2014",
    source         = "Bishop 2022 NEJM",
    notes          = "Any grade CRS; denominator is the 155 infused patients"
  ),
  tibble(
    trial_id       = "BELINDA",
    arm            = "car_t",
    treatment      = "Tisagenlecleucel",
    outcome        = "crs_g3plus",
    events         = 8,
    n_safety       = 155,
    grading_system = "Lee 2014",
    source         = "Bishop 2022 NEJM",
    notes          = "Grade >=3 CRS; denominator is the 155 infused patients"
  ),
  tibble(
    trial_id       = "BELINDA",
    arm            = "car_t",
    treatment      = "Tisagenlecleucel",
    outcome        = "icans_any",
    events         = 16,
    n_safety       = 155,
    grading_system = "CTCAE v5.0",
    source         = "Bishop 2022 NEJM",
    notes          = "Any grade neurologic event; the paper does not use the term ICANS"
  ),
  tibble(
    trial_id       = "BELINDA",
    arm            = "car_t",
    treatment      = "Tisagenlecleucel",
    outcome        = "icans_g3plus",
    events         = 3,
    n_safety       = 155,
    grading_system = "CTCAE v5.0",
    source         = "Bishop 2022 NEJM",
    notes          = "Grade >=3 neurologic event"
  ),
  tibble(
    trial_id       = "BELINDA",
    arm            = "car_t",
    treatment      = "Tisagenlecleucel",
    outcome        = "teae_any",
    events         = 160,
    n_safety       = 162,
    grading_system = "CTCAE v5.0",
    source         = "Bishop 2022 NEJM",
    notes          = "BACK-CALCULATED from 98.8% of 162 randomized patients, not a raw count"
  ),
  tibble(
    trial_id       = "BELINDA",
    arm            = "soc",
    treatment      = "Standard of care",
    outcome        = "teae_any",
    events         = 158,
    n_safety       = 160,
    grading_system = "CTCAE v5.0",
    source         = "Bishop 2022 NEJM",
    notes          = "BACK-CALCULATED from 98.8% of 160 randomized patients, not a raw count"
  )
)

replace_trial("data/adverse-events.csv", belinda_ae, "trial_id", "BELINDA")


# ------------------------------------------------------------------
# patient reported outcomes
# Nothing to add: no peer-reviewed PRO publication was available.
# ------------------------------------------------------------------
