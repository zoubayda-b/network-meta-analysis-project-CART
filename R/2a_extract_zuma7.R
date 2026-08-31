# 02a_extract_zuma7.R
# -------------------
# Extracts ZUMA-7 data from Locke 2022 NEJM and 5-year follow-up from Westin 2023 NEJM

library(tidyverse)

# ------------------------------------------------------------------
# Safe read: if file doesn't exist yet, start with empty tibble
# ------------------------------------------------------------------
safe_read <- function(path) {
  if (file.exists(path)) {
    read_csv(path, show_col_types = FALSE)
  } else {
    tibble()
  }
}

characteristics <- safe_read("data/characteristics.csv")
binary_data     <- safe_read("data/binary-data.csv")
tte_data        <- safe_read("data/time-to-event-data.csv")
ae_data         <- safe_read("data/adverse-events.csv")
pro_data        <- safe_read("data/patient-reported-outcomes.csv")

# ------------------------------------------------------------------
# CHARACTERISTICS — ZUMA-7 (both arms)
# ------------------------------------------------------------------
zuma7_characteristics <- bind_rows(

  # CAR-T arm
  tibble(
    trial_name              = "ZUMA-7",
    nct                     = "NCT03391466",
    car_t_product           = "Axicabtagene ciloleucel",
    primary_citation        = "Locke FL, et al. N Engl J Med 2022;386:640-654",
    followup_citation       = "Westin JR, et al. N Engl J Med 2023;389:148-157",
    data_cutoff_date        = "2021-03-18",
    median_followup_months  = 24.9,
    randomization_ratio     = "1:1",
    bridging_allowed        = "steroids_only",   
    crossover_allowed       = "No",              # Protocol-defined; off-protocol switching occurred
    response_assessor       = "Investigator",
    efs_definition_verbatim = "Time from randomization to earliest date of disease progression per Lugano classification, commencement of new therapy for lymphoma, death from any cause, or best response of stable disease up to and including day 150 assessment",
    crs_grading             = "Modified Lee 2014",
    icans_grading           = "CTCAE v4.03",
    arm                     = "car_t",
    treatment               = "Axi-cel",
    n_randomized            = 180,
    n_safety                = 170,
    n_infused               = 170,
    median_age              = 58,
    pct_primary_refractory  = 74,
    pct_relapse_lt12mo      = 26,
    ipi_distribution        = "aaIPI 0-1: 54%; 2-3: 46%",
    pct_stage_iii_iv        = 77,
    region_note             = "Multinational (US, EU, Australia)",
    median_days_dx_to_infusion = NA,
    salvage_regimens        = NA,
    pct_reached_asct        = NA,
    pct_soc_subsequent_cart = NA,
    source                  = "Locke 2022 NEJM",
    notes                   = "Second-line LBCL; bridging chemo prohibited (steroids only)"
  ),

  # SOC arm
  tibble(
    trial_name              = "ZUMA-7",
    nct                     = "NCT03391466",
    car_t_product           = "Axicabtagene ciloleucel",
    primary_citation        = "Locke FL, et al. N Engl J Med 2022;386:640-654",
    followup_citation       = "Westin JR, et al. N Engl J Med 2023;389:148-157",
    data_cutoff_date        = "2021-03-18",
    median_followup_months  = 24.9,
    randomization_ratio     = "1:1",
    bridging_allowed        = "steroids_only",
    crossover_allowed       = "No",
    response_assessor       = "Investigator",
    efs_definition_verbatim = "Time from randomization to earliest date of disease progression per Lugano classification, commencement of new therapy for lymphoma, death from any cause, or best response of stable disease up to and including day 150 assessment",
    crs_grading             = "Modified Lee 2014",
    icans_grading           = "CTCAE v4.03",
    arm                     = "soc",
    treatment               = "Standard of care",
    n_randomized            = 179,
    n_safety                = 168,
    n_infused               = NA,
    median_age              = 59,
    pct_primary_refractory  = 73,
    pct_relapse_lt12mo      = 27,
    ipi_distribution        = "aaIPI 0-1: 56%; 2-3: 44%",
    pct_stage_iii_iv        = 82,
    region_note             = "Multinational (US, EU, Australia)",
    median_days_dx_to_infusion = NA,
    salvage_regimens        = "R-DHAP / R-ICE / R-GDP / R-DHAX / R-ESHAP",
    pct_reached_asct        = 36,
    pct_soc_subsequent_cart = 56,   
    source                  = "Locke 2022 NEJM",
    notes                   = "Second-line LBCL; SOC patients could receive CAR-T off-protocol"
  )
)

characteristics <- characteristics %>%
  { if ("trial_name" %in% names(.)) filter(., trial_name != "zuma7") else . } %>%
  bind_rows(zuma7_characteristics)
write_csv(characteristics, "data/characteristics.csv")


# ------------------------------------------------------------------
# BINARY OUTCOMES — ZUMA-7
# ------------------------------------------------------------------
zuma7_binary <- bind_rows(
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "crr", events = 117, n = 180,
         denominator_type = "randomized", assessor = "Investigator",
         timepoint_note = "best response", source = "Locke 2022 NEJM Table 2"),
  tibble(trial_id = "ZUMA-7", arm = "soc", treatment = "Standard of care",
         outcome = "crr", events = 57, n = 179,
         denominator_type = "randomized", assessor = "Investigator",
         timepoint_note = "best response", source = "Locke 2022 NEJM Table 2"),
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "orr", events = 149, n = 180,
         denominator_type = "randomized", assessor = "Investigator",
         timepoint_note = "best response", source = "Locke 2022 NEJM Table 2"),
  tibble(trial_id = "ZUMA-7", arm = "soc", treatment = "Standard of care",
         outcome = "orr", events = 90, n = 179,
         denominator_type = "randomized", assessor = "Investigator",
         timepoint_note = "best response", source = "Locke 2022 NEJM Table 2")
)

binary_data <- binary_data %>%
  { if ("trial_id" %in% names(.)) filter(., trial_id != "zuma7") else . } %>%
  bind_rows(zuma7_binary)
write_csv(binary_data, "data/binary-data.csv")


# ------------------------------------------------------------------
# TIME-TO-EVENT — ZUMA-7
# ------------------------------------------------------------------
zuma7_tte <- bind_rows(
  tibble(trial_id = "ZUMA-7", outcome = "efs", estimand = "itt",
         hr = 0.398, hr_lower = 0.308, hr_upper = 0.514,
         publication_used = "initial", source_type = "reported",
         data_cutoff_date = "2021-03-18", median_followup_months = 24.9,
         source = "Locke 2022 NEJM"),
  tibble(trial_id = "ZUMA-7", outcome = "os", estimand = "itt",
         hr = 0.726, hr_lower = 0.540, hr_upper = 0.977,
         publication_used = "followup", source_type = "reported",
         data_cutoff_date = "2022-04-29", median_followup_months = 47.2,
         source = "Westin 2023 NEJM")   
)

tte_data <- tte_data %>%
  { if ("trial_id" %in% names(.)) filter(., trial_id != "zuma7") else . } %>%
  bind_rows(zuma7_tte)
write_csv(tte_data, "data/time-to-event-data.csv")


# ------------------------------------------------------------------
# ADVERSE EVENTS — ZUMA-7
# ------------------------------------------------------------------
zuma7_ae <- bind_rows(
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "crs_any", events = 157, n_safety = 170,
         grading_system = "Modified Lee 2014", source = "Locke 2022 NEJM Supp", notes = NA_character_),
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "crs_g3plus", events = 14, n_safety = 170,
         grading_system = "Modified Lee 2014", source = "Locke 2022 NEJM Supp", notes = NA_character_),
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "icans_any", events = 101, n_safety = 170,
         grading_system = "CTCAE v4.03", source = "Locke 2022 NEJM Supp", notes = NA_character_),
  tibble(trial_id = "ZUMA-7", arm = "car_t", treatment = "Axi-cel",
         outcome = "icans_g3plus", events = 25, n_safety = 170,
         grading_system = "CTCAE v4.03", source = "Locke 2022 NEJM Supp", notes = NA_character_),
  tibble(trial_id = "ZUMA-7", arm = "soc", treatment = "Standard of care",
         outcome = "teae", events = 165, n_safety = 168,
         grading_system = "CTCAE v4.03", source = "Locke 2022 NEJM Supp", notes = NA_character_)
)

ae_data <- ae_data %>%
  { if ("trial_id" %in% names(.)) filter(., trial_id != "zuma7") else . } %>%
  bind_rows(zuma7_ae)
write_csv(ae_data, "data/adverse-events.csv")


# ------------------------------------------------------------------
# VIEW EVERYTHING
# ------------------------------------------------------------------
print(characteristics, width = Inf)
print(binary_data, width = Inf)
print(tte_data, width = Inf)
print(ae_data, width = Inf)