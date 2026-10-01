# Results Summary — NMA of 2L CD19 CAR-T in R/R LBCL

## Primary outcome — CRR (Lugano 2014, blinded IRC in all trials)

| Comparison | OR (95% CI) | Evidence |
|---|---|---|
| axi-cel vs SOC | 3.87 (2.50–6.00) | direct |
| liso-cel vs SOC | 3.68 (1.98–6.86) | direct |
| tisa-cel vs SOC | 1.05 (0.64–1.70) | direct |
| **axi-cel vs tisa-cel** | **3.71 (1.93–7.13)** | indirect only |
| **liso-cel vs tisa-cel** | **3.52 (1.60–7.76)** | indirect only |
| axi-cel vs liso-cel | 1.05 (0.49–2.25) | indirect only |

P-scores: axi-cel 0.851, liso-cel 0.816, tisa-cel 0.191, SOC 0.143.
*Protocol framing applies: ordering reflects point estimates only; no superiority conclusion between CAR-T products is warranted.*

## Key secondary — ORR (Sensitivity Analysis 1)

axi-cel 4.94 (3.03–8.07); liso-cel 6.96 (3.35–14.47); tisa-cel 1.17 (0.75–1.81). Direction and ranking consistent with CRR — confirmatory.

## Key secondary — OS (ITT, longest follow-up; largest caveat: crossover)

| Comparison | HR (95% CI) |
|---|---|
| axi-cel vs SOC | 0.73 (0.54–0.98) |
| liso-cel vs SOC | 0.76 (0.48–1.19) |
| tisa-cel vs SOC | 1.24 (0.83–1.85) |

P-scores: axi-cel 0.838, liso-cel 0.759, SOC 0.329, tisa-cel 0.073.

## Exploratory

- **EFS** (definitions NOT harmonized — caveat): axi-cel 0.42 (0.33–0.54); liso-cel 0.38 (0.26–0.54); tisa-cel 1.07 (0.82–1.40).
- **PFS**: axi-cel 0.51 (0.38–0.68); liso-cel 0.42 (0.28–0.64). BELINDA excluded (PFS not reported — documented exclusion, not imputation).

## Sensitivity analyses

| Analysis | Finding |
|---|---|
| SA2 follow-up duration (earliest readout) | OS/EFS essentially unchanged (ZUMA-7 OS 0.73→0.73; TRANSFORM OS 0.724→0.757) |
| SA3 crossover-adjusted OS | Strengthens CAR-T effect: axi-cel 0.58, liso-cel 0.335 (RPSFT); tisa-cel 0.99 (covariate-adjusted — **not** a crossover adjustment; flagged per protocol) |
| SA4 assumed τ (0.3 logOR / 0.2 logHR) | Point estimates identical; CIs widen as expected (e.g., axi-cel CRR CI 2.50–6.00 → 1.86–8.07); no conclusion changes |

## Comparator-node check (protocol's key empirical test)

| SOC arm | CRR | ORR | reached ASCT | subsequent CAR-T |
|---|---|---|---|---|
| ZUMA-7 | 32.4% | 50.3% | 36% | 57% (commercial, post-progression) |
| TRANSFORM | 43.5% | 48.9% | 47% | 62% (protocol crossover approved) |
| BELINDA | 27.5% | 42.5% | 32.5% | 50.6% (protocol crossover) |

The three SOC arms do **not** behave identically (BELINDA's SOC underperformed; ASCT rates differ). The single-node assumption is a stated limitation; indirect comparisons inherit it.

## Safety (descriptive only — no ranking)

- Anchored within-trial ORs exist only for ZUMA-7 neurologic events: ICANS any-grade OR 6.14 (3.76–10.01); grade ≥3 OR 44.9 (6.07–331.5) vs SOC.
- TEAEs ~100% on all arms (OR uninformative by design). ZUMA-7 TEAE OR not estimable (100% both arms).
- CAR-T-arm crude rates (no cross-trial ORs — randomization does not extend across trials): CRS any-grade 92% (axi-cel, modified Lee) / 49% (liso-cel, Lee 2014) / 61% (tisa-cel, Lee 2014, n=155 infused); grade ≥3 CRS 6% / 1% / 5.2%; ICANS any 60% / 11% / 10.3%; grade ≥3 ICANS 21% / 4.3% / 1.9%. Grading systems differ (CTCAE v4.03 vs v5.0; Lee variants) — transitivity caveat.

## PROs
Narrative only (ZUMA-7: QLQ-C30/EQ-5D mean changes favor axi-cel at day 100/150; TRANSFORM: QLQ-C30 TTD HR 0.47, MMRM differences favor liso-cel). Instruments overlap but measures/timepoints are not comparable; BELINDA PROs unpublished. No pooling, per protocol.

## RoB 2 / CINeMA
- `results/tables/rob2_draft_judgments.csv` + robvis plots — **DRAFT, ZB to review** (Low for CRR; Some concerns for OS due to crossover/deviations).
- `results/tables/cinema_qualitative_draft.csv` — CRR: Low/Moderate across domains; OS: Moderate–High concerns (indirectness, imprecision). Imprecision judged vs pre-specified thresholds (OR 1.25, HR 0.80).


