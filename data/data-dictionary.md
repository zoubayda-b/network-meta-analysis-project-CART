# Data dictionary

Project: network-meta-analysis-project-CART
Extracted by: Zoubayda Baoubbou
Protocol: `report/protocol.md`
Dictionary version: 2.0

The dictionary describes the five CSV files in `data/` that the analysis actually
reads. If a column changes, this file changes with it.

## 1. Source publications

| Trial | NCT | Primary source | Follow-up source |
|---|---|---|---|
| ZUMA-7 | NCT03391466 | Locke FL, et al. N Engl J Med 2022;386:640-654 | Westin JR, et al. N Engl J Med 2023;389:148-157 |
| TRANSFORM | NCT03575351 | Abramson JS, et al. Blood 2023;141:1675-1684 | Kamdar M, et al. J Clin Oncol 2025;43:2671-2678 |
| BELINDA | NCT03570892 | Bishop MR, et al. N Engl J Med 2022;386:629-639 | none available |

The TRANSFORM interim analysis (Kamdar M, et al. Lancet 2022;399:2294-2308) is not
used for the primary analysis. It is the source of the earlier readout in
sensitivity analysis 2.

PDFs are kept locally and are not committed, to avoid putting copyrighted material in
the repository.

## 2. Extraction rules

| Rule | How it was applied |
|---|---|
| Efficacy population | Randomised (ITT) set, so `n` in `binary-data.csv` equals `n_randomized` |
| Safety population | As-treated set (`n_safety`), which is smaller than the randomised set wherever not everyone was infused |
| Time to event | Hazard ratio and 95% CI as reported; `seTE = (log(upper) - log(lower)) / (2 * qnorm(0.975))` |
| Binary effect measure | Odds ratio |
| Outcome labels | `crr`, `orr`, `efs`, `os`, `pfs`, `crs_any`, `crs_g3plus`, `icans_any`, `icans_g3plus`, `teae` / `teae_any` |
| Response readout | Primary analysis of each trial, because response rates do not change with longer follow-up |
| Survival readout | Longest available follow-up in a journal publication |
| PROs | Descriptive summary only, no pooling |

## 3. Files

### 3.1 characteristics.csv

One row per trial arm, six rows in total.

| Column | Meaning |
|---|---|
| `trial_name`, `nct` | Trial label and registration |
| `car_t_product`, `primary_citation`, `followup_citation` | Product and the papers it came from |
| `data_cutoff_date`, `median_followup_months` | Cut-off and follow-up of the source publication |
| `randomization_ratio`, `bridging_chemo_allowed`, `bridging_details` | Design |
| `crossover_allowed` | Whether the protocol allowed crossover from the SOC arm |
| `response_assessor` | Independent review committee or investigator |
| `efs_definition_verbatim`, `crr_definition_verbatim` | Quoted from the paper, because the EFS definitions differ |
| `crs_grading`, `icans_grading` | Grading system used in that trial |
| `arm`, `treatment` | `car_t` or `soc` |
| `n_randomized`, `n_safety`, `n_infused` | The three denominators, kept apart on purpose |
| `median_age`, `pct_primary_refractory`, `pct_relapse_lt12mo`, `pct_ipi_distribution`, `pct_stage_iii_iv` | Baseline characteristics used in the transitivity assessment |
| `region_note` | Where the trial enrolled |
| `median_days_dx_to_infusion` | Not extracted, left empty |
| `salvage_regimens`, `pct_reached_asct`, `pct_soc_subsequent_cart` | SOC-arm checks; only filled in for the SOC rows |
| `source`, `notes` | Where each row came from and anything odd about it |

### 3.2 binary-data.csv

Two arms per trial per outcome, twelve rows.

| Column | Meaning |
|---|---|
| `trial_id`, `arm`, `treatment` | Which trial and arm |
| `outcome` | `crr` or `orr` |
| `events`, `n` | Responders and the ITT denominator |
| `denominator_type` | Always `randomized` here |
| `assessor` | Response assessor |
| `timepoint_note` | Which readout the numbers come from |
| `source` | Table in the paper |

### 3.3 time-to-event-data.csv

One row per hazard ratio reported, including the ones only used in sensitivity
analyses.

| Column | Meaning |
|---|---|
| `trial_id`, `outcome`, `population` | Trial, `efs`/`pfs`/`os`, and the analysis set |
| `treatment_arm`, `comparator_arm` | `axi_cel` / `liso_cel` / `tisa_cel` against `soc` |
| `hr`, `hr_lower`, `hr_upper` | Reported estimate |
| `treatment_median_months`, `comparator_median_months` | Median survival where reported |
| `publication_used` | `initial` or `follow-up` |
| `source_type` | `reported` or `sensitivity_analysis` |
| `data_cutoff_date`, `median_followup_months` | Feeds the data maturity table |
| `estimand` | Empty or `itt` for the primary rows; `rpsft_adjusted` and `covariate_adjusted` mark the sensitivity rows |
| `treatment_4yr_survival`, `comparator_4yr_survival` | Only filled in where the paper gives them |
| `source` | Paper and, where needed, a note about the adjustment method |

### 3.4 adverse-events.csv

| Column | Meaning |
|---|---|
| `trial_id`, `arm`, `treatment` | Which trial and arm |
| `outcome` | `crs_any`, `crs_g3plus`, `icans_any`, `icans_g3plus`, `teae` |
| `events`, `n_safety` | Count and the as-treated denominator |
| `grading_system` | Lee 2014, modified Lee 2014, CTCAE v4.03 or v5.0 |
| `source`, `notes` | Paper, and flags for anything back-calculated |

### 3.5 patient-reported-outcomes.csv

| Column | Meaning |
|---|---|
| `trial_id`, `arm`, `instrument`, `timepoint` | What was measured and when |
| `measure_type` | `between_arm_diff_mean_change`, `hazard_ratio`, `between_arm_diff_MMRM` |
| `value`, `sd_or_se`, `n` | The number itself and its denominator |
| `source`, `notes` | Paper and a plain-language note |

The `value` column holds a between-arm difference, not an arm mean. That is written
into `measure_type` and repeated in `notes`, because it would be easy to misread.

## 4. Derived and back-calculated values

| File | Row | What was done | Flag |
|---|---|---|---|
| adverse-events.csv | BELINDA, `teae_any`, both arms | Counts 160/162 and 158/160 were back-calculated from the reported 98.8% | Marked BACK-CALCULATED in `notes` |

Nothing in the time-to-event file was reconstructed from Kaplan-Meier curves. Every
hazard ratio is as reported by the trial investigators.

## 5. Known gaps

- **BELINDA PFS** was not reported, so BELINDA is absent from the PFS analysis. It
  was left out rather than imputed.
- **Serious adverse events and grade 3 or above adverse events** were in the
  protocol's list of aggregate safety outcomes but were not extracted. The safety
  analysis therefore covers CRS, ICANS and TEAEs only.
- **Median time from diagnosis to infusion** was not extracted for any trial.
- **BELINDA** had no long-term journal follow-up at the cut-off, so its data are much
  less mature than the other two trials. This shows up in the data maturity table.
- **TRANSFORM crossover**: 61 of 91 treated patients in the SOC arm crossed over by
  the primary analysis (67%). The interim analysis reported 50 of 92 (54%), which is
  where the 54% sometimes quoted comes from.

## 6. Change log

| Date | Change |
|---|---|
| 2026-08-19 | First version of the dictionary |
| 2026-08-19 | Corrected TRANSFORM phase to 3, added EFS rows and the EFS definition column, completed ORR and safety rows for all three trials, renamed CR to CRR |
| 2026-11-10 | Rewritten to match the five CSV files the scripts actually read; corrected the BELINDA and TRANSFORM citations; added the known gaps section |
