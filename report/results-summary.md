# Results summary

Everything below comes from `R/08_run_all.R`. All comparisons are against standard
of care (SOC) unless the row says otherwise. Tables are in `results/tables/`,
figures in `results/figures/`.

The network is star shaped: three trials, each comparing one CAR-T product with a
standard-of-care arm. So every CAR-T versus CAR-T estimate is indirect and passes
through the SOC node.

## Primary outcome: complete response rate (OR, common effect model)

| Comparison | OR (95% CI) | Where it comes from |
|---|---|---|
| axi-cel vs SOC | 3.87 (2.50 to 6.00) | direct |
| liso-cel vs SOC | 3.68 (1.98 to 6.86) | direct |
| tisa-cel vs SOC | 1.05 (0.64 to 1.70) | direct |
| axi-cel vs tisa-cel | 3.71 (1.93 to 7.13) | indirect only |
| liso-cel vs tisa-cel | 3.52 (1.60 to 7.76) | indirect only |
| axi-cel vs liso-cel | 1.05 (0.49 to 2.25) | indirect only |

P-scores: axi-cel 0.851, liso-cel 0.816, tisa-cel 0.191, SOC 0.143.

The three direct estimates are just the trial results, which is what should happen
when each comparison has one trial. The indirect ones are the interesting part:
axi-cel and liso-cel both look better than tisa-cel, and axi-cel and liso-cel are
indistinguishable from each other (the interval runs from 0.49 to 2.25).

The P-score order should not be read as a ranking. The protocol says this in advance
and it holds: the intervals overlap, so the order reflects where the point estimates
fell, not evidence that one product is better.

## Key secondary: ORR (sensitivity analysis 1)

axi-cel 4.94 (3.03 to 8.07); liso-cel 6.96 (3.35 to 14.47); tisa-cel 1.17 (0.75 to
1.81). Both response outcomes point the same way, and tisa-cel is again the only
product whose interval includes 1. The P-score order is **not** the same, though:
liso-cel moves ahead of axi-cel for ORR (0.926 versus 0.741; for CRR it is axi-cel
0.851 versus liso-cel 0.816). The axi-cel versus liso-cel interval is wide and
includes 1 under both definitions, so this is a change in where the point estimates
fell, not evidence that either product is better. This is the one sensitivity
analysis that came out as expected in direction, with a caveat on ranking.

## Key secondary: OS (intention to treat, most mature follow-up)

| Comparison | HR (95% CI) |
|---|---|
| axi-cel vs SOC | 0.73 (0.54 to 0.98) |
| liso-cel vs SOC | 0.76 (0.48 to 1.19) |
| tisa-cel vs SOC | 1.24 (0.83 to 1.85) |

P-scores: axi-cel 0.838, liso-cel 0.759, SOC 0.329, tisa-cel 0.073.

OS is the weakest of the three main analyses. The standard-care arms were not
comparable in what happened after randomisation. In TRANSFORM, 61 of 92 (66%)
standard-care patients were approved for crossover and 57 (62%) had received
liso-cel by the 3-year update, against 63% in the primary analysis. BELINDA reports
subsequent tisa-cel in 50.6% of its standard-care arm, and 57% of ZUMA-7's
standard-care arm later received commercial CAR-T after progression, outside the
trial. Median follow-up for the OS analysis runs from about 10 months in BELINDA to
47 months in ZUMA-7. The liso-cel interval includes 1. Read this table with the
crossover-adjusted one below, not on its own.

A 2026 TRANSFORM long-term follow-up brief report was published after the data
cut-off. It reports 48-month OS of 61.5% and PFS of 52.2% in the selected
long-term-follow-up subset and no new hazard ratio, so it does not replace the
3-year analysis used here. It is noted in the protocol's timing section.

## Exploratory: EFS and PFS

EFS, with the caveat that the event definition is not the same in the three trials:
axi-cel 0.42 (0.33 to 0.54); liso-cel 0.38 (0.26 to 0.54); tisa-cel 1.07 (0.82 to
1.40).

PFS: axi-cel 0.51 (0.38 to 0.68); liso-cel 0.42 (0.28 to 0.64). BELINDA is not in
this one because PFS was not reported, and the protocol says to leave it out rather
than impute.

## Sensitivity analyses

| Analysis | What changed |
|---|---|
| SA2, earliest readout instead of most mature | OS barely moves: ZUMA-7 stays at 0.73, TRANSFORM goes from 0.757 to 0.724. EFS moves slightly: axi-cel 0.42 to 0.40, liso-cel 0.375 to 0.356. |
| SA3, crossover-adjusted OS | The CAR-T effect gets stronger: axi-cel 0.58 (0.42 to 0.81) by RPSFT, liso-cel 0.335 (0.19 to 0.59) by RPSFT. BELINDA's 0.99 (0.64 to 1.52) is a covariate-adjusted estimate, not a crossover adjustment, so it answers a different question and the three rows are not directly comparable. |
| SA4, assumed tau (0.3 log OR, 0.2 log HR) | Point estimates do not move. The intervals widen, as they should. CRR conclusions are unchanged: axi-cel goes from 2.50 to 6.00 up to 1.86 to 8.07 and stays significant. OS is less robust: axi-cel goes from 0.73 (0.54 to 0.98) to 0.73 (0.45 to 1.19), so its interval now includes 1. The OS signal should not be called robust to a moderate assumed tau. |

## Comparator node check

This is the test the protocol asks for. If the three SOC arms were really one
treatment, their raw results would be close to each other.

| SOC arm | CRR | ORR | median OS (months) | reached ASCT | later CAR-T |
|---|---|---|---|---|---|
| ZUMA-7 | 32.4% | 50.3% | 31.1 | 36% | 57% (commercial, after progression) |
| TRANSFORM | 43.5% | 48.9% | 29.9 | 47% | 66% approved; 57 received liso-cel |
| BELINDA | 27.5% | 42.5% | not reached | 32.5% | 50.6% (protocol crossover) |

They are not the same. BELINDA's SOC arm did clearly worse on response than
ZUMA-7's and TRANSFORM's, and the share that got to ASCT ranges from 32.5% to 47%.
That does not invalidate the analysis, but it is a real limitation and the indirect
comparisons inherit it.

## Safety (descriptive, no ranking)

Odds ratios can only be computed where both arms of a trial report the same event.
That only really happens for ZUMA-7's neurologic events:

- ICANS any grade: OR 6.14 (3.76 to 10.01) versus SOC
- ICANS grade 3 or above: OR 44.9 (6.07 to 331.5) versus SOC

These are not a like-for-like ICANS contrast. The ZUMA-7 standard-care arm reports
treatment-emergent neurologic events rather than ICANS, so the odds ratio compares
ICANS in the CAR-T arm with a broader neurologic-event category in the control arm.
The direction is still informative; the magnitude should not be read as an ICANS
risk ratio.

The TEAE odds ratios are not worth much. TEAEs are around 100% on every arm, and in
ZUMA-7 both arms are at 100%, so the odds ratio is not estimable at all.

Crude rates in the CAR-T arms, which cannot be compared across trials:

| | axi-cel | liso-cel | tisa-cel |
|---|---|---|---|
| CRS any grade | 92% | 49% | 61% |
| CRS grade 3+ | 6% | 1% | 5.2% |
| ICANS any grade | 60% | 11% | 10% |
| ICANS grade 3+ | 21% | 4.3% | 1.9% |

Grading differs (modified Lee 2014 in ZUMA-7, Lee 2014 in the other two; CTCAE v4.03
in ZUMA-7 and TRANSFORM, v5.0 in BELINDA), and BELINDA's rates use the 155 infused
patients rather than the 162 randomised. The apparent difference between axi-cel and
the other two is big, but some of it is probably how the events were counted. I would
not put a number on it.

## Patient-reported outcomes

Narrative only, as planned. ZUMA-7 reports mean changes favouring axi-cel at day 100
and 150 on the QLQ-C30 and EQ-5D. TRANSFORM reports a time-to-deterioration HR of
0.47 and MMRM differences favouring liso-cel. The instruments overlap but the
measures and timepoints do not, so pooling them would be inventing a common scale.
BELINDA had no PRO publication at the cut-off.

## Risk of bias and confidence in the evidence

`results/tables/rob2_draft_judgments.csv` and the two robvis plots. CRR is low risk
in all three trials; OS is "some concerns" in all three because of the open-label
design and the crossover, which sits in the deviations domain.

`results/tables/cinema_qualitative_draft.csv`. For CRR, within-study bias is low and
indirectness and imprecision are moderate. For OS, indirectness and imprecision are
high. Heterogeneity and incoherence are recorded as "not assessable" rather than
rated, because tau^2 cannot be estimated with one trial per comparison and there is
no loop to test.

Both of these are my own first-pass judgments. They still need the second pass the
protocol asks for before they are treated as final.
