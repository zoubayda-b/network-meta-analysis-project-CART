library(tibble)
library(readr)

    # characteristics.csv 

characteristics_file <- "data/characteristics.csv"
characteristics <- tibble(
  trial_name            = character(),  # zuma7 / transform / belinda
  nct                   = character(),  # NCT number
  car_t_product         = character(),  # axi-cel / liso-cel / tisa-cel
  primary_citation      = character(),  # e.g. "Locke 2022 NEJM"
  followup_citation     = character(),  # long-term paper; non-existent for BELINDA
  data_cutoff_date      = character(),
  median_followup_months = numeric(),
  randomization_ratio   = character(),
  bridging_allowed      = character(),  # yes / no
  crossover_allowed     = character(),  # yes / no
  response_assessor     = character(),  # IRC / investigator 
  efs_definition_verbatim = character(), # quoted sentence + page
  crs_grading           = character(),  # e.g. Lee 2014 / ASTCT
  icans_grading         = character(),
  # arm-level
  arm                   = character(),  # car_t / soc
  treatment             = character(),  # axi-cel / liso-cel / tisa-cel / soc
  n_randomized          = numeric(),
  n_safety              = numeric(),    # as-treated population (Issue 7)
  n_infused             = numeric(),    # CAR-T arm; blank for SOC
  median_age            = numeric(),
  pct_primary_refractory = numeric(),
  pct_relapse_lt12mo    = numeric(),
  ipi_distribution      = character(),  # as reported, e.g. "IPI 0-1: 45%; 2-3: 55%"
  pct_stage_iii_iv      = numeric(),
  region_note           = character(),  # e.g. "heavily Asia/Australia" (BELINDA)
  median_days_dx_to_infusion = numeric(), # CAR-T arm
  salvage_regimens      = character(),  # SOC arm, e.g. "R-DHAP / R-ICE / R-GDP"
  pct_reached_asct      = numeric(),    # SOC arm (comparator-node check)
  pct_soc_subsequent_cart = numeric(),  # SOC arm, on- or off-protocol
  source                = character(),
  notes                 = character()
)
write_csv(characteristics, characteristics_file)

    # binary-data.csv

binary_file <- "data/binary-data.csv"
binary <- tibble(
  trial_id         = character(),
  arm              = character(),
  treatment        = character(),
  outcome          = character(),  # crr / orr
  events           = numeric(),    # verbatim count from the paper
  n                = numeric(),
  denominator_type = character(),  # randomized (efficacy = ITT population)
  assessor         = character(),  # IRC / investigator for THIS outcome
  timepoint_note   = character(),  # e.g. "best response"
  source           = character()   # e.g. "Locke 2022 NEJM, Table 2"
)
write_csv(binary, binary_file)

#time-to-event-data.csv

timetoevent_file <- "data/time-to-event-data.csv"
tte <- tibble(
  trial_id          = character(),
  outcome           = character(),  # os / efs / pfs
  estimand          = character(),  # itt / rpsft_adjusted
  hr                = numeric(),
  hr_lower          = numeric(),
  hr_upper          = numeric(),
  publication_used  = character(),  # initial / followup
  source_type       = character(),  # reported / reconstructed_tierney
  data_cutoff_date  = character(),
  median_followup_months = numeric(),
  source            = character()
)
write_csv(tte, timetoevent_file)

    # patient-reported-outcomes.csv

pro_file <- "data/patient-reported-outcomes.csv"
pro <- tibble(
  trial_id     = character(),
  arm          = character(),
  instrument   = character(),   # FACT-Lym / EQ-5D / ...
  timepoint    = character(),   # e.g. "day 100", "month 6"
  measure_type = character(),   # mean_change / responder_pct / ...
  value        = numeric(),
  sd_or_se     = numeric(),
  n            = numeric(),
  source       = character(),
  notes        = character()
)
write_csv(pro, pro_file)

    #adverse-events.csv

ae_file <- "data/adverse-events.csv"
ae <- tibble(
  trial_id        = character(),
  arm             = character(),
  treatment       = character(),
  outcome         = character(),  # crs_any / crs_g3plus / icans_any / icans_g3plus /
                                  # teae / sae / ae_g3plus
  events          = numeric(),
  n_safety        = numeric(),    # ALWAYS the as-treated denominator (Issue 7)
  grading_system  = character(),  # CRS/ICANS scale used by this trial
  source          = character(),  # usually the supplementary appendix
  notes           = character()
)
write_csv(ae, ae_file)
