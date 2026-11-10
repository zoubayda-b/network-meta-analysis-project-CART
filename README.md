# Network meta-analysis of second-line CAR-T therapies in R/R large B-cell lymphoma

This is a small frequentist network meta-analysis (NMA) in R. It compares the three
CD19 CAR-T products that have been tested as second-line treatment in relapsed or
refractory large B-cell lymphoma (R/R LBCL) - axicabtagene ciloleucel (axi-cel),
tisagenlecleucel (tisa-cel) and lisocabtagene maraleucel (liso-cel) - against standard
salvage chemoimmunotherapy.

I built this as a learning project, so the aim is to do every step properly on a small
and well defined evidence base rather than to produce a big review.

## The evidence base

There are exactly three phase III trials:

| Trial | CAR-T | Comparator | Primary publication |
|---|---|---|---|
| ZUMA-7 | axi-cel | platinum salvage +/- ASCT | Locke 2022 NEJM |
| TRANSFORM | liso-cel | platinum salvage +/- ASCT | Abramson 2023 Blood |
| BELINDA | tisa-cel | platinum salvage +/- ASCT | Bishop 2022 NEJM |

There is no trial that randomises one CAR-T product against another. All three
trials only compare their product with a standard-of-care arm, so the network is
star shaped. Everything between two CAR-T products is therefore indirect, and it is
all calculated through the standard-of-care node.

Two consequences that shape the whole analysis:

- Consistency cannot be checked. There is no closed loop, so node splitting does
  not apply.
- Between-study heterogeneity cannot be estimated. Each comparison is informed by
  one trial, so tau^2 and I^2 have nothing to work with. I report this as a
  limitation rather than as "heterogeneity = 0".

Because of that, the primary model is a common-effect (fixed-effect) model. A
random-effects model would just be whatever tau^2 I decided to plug in.

## Outcomes

- **Primary:** complete response rate (CRR), on the log odds ratio scale. CR is
  defined the same way (Lugano) in all three trials and is measured before any
  treatment switching.
- **Key secondary:** overall response rate (ORR) and overall survival (OS).
- **Exploratory:** event-free survival (EFS) and progression-free survival (PFS).
  EFS is exploratory because the three trials define an EFS event differently.
- **Safety:** descriptive only. CRS and ICANS as any grade and grade >= 3, plus
  TEAEs for background.
- **PROs:** narrative summary, no pooling.

Standard of care is the reference treatment. Ranking uses P-scores, but in a
three-trial star network they mostly reflect the ordering of the point estimates,
so I do not use them to claim one product is better than another.

## What is in the repo

```
R/01_create_schema.R          empty CSV templates in data/
R/02a_extract_zuma7.R         extraction, one script per trial
R/02b_extract_transform.R
R/02c_extract_belinda.R
R/03_check_extraction.R       data checks before any analysis
R/04_nma_response.R           CRR (primary) and ORR, plus assumed-tau run
R/05_nma_tte.R                OS, EFS, PFS, plus sensitivity analyses
R/06_safety.R                 safety tables (descriptive)
R/07_transitivity_rob_cinema.R  comparator check, transitivity, RoB 2, CINeMA
R/08_run_all.R                runs 03 to 07 in order
data/                         extracted data + data dictionary
report/                       protocol, references, results summary
results/tables, results/figures
```

## How to run it

Open `network-meta-analysis-project-CART.Rproj` in RStudio (or use `Rscript` from
the repo root, which is what the scripts assume for their paths).

Install the pinned packages once, in R:

```r
renv::restore()
```

Then run the pipeline from a terminal in the project folder:

```sh
Rscript R/08_run_all.R
```

The extraction scripts (`02a`-`02c`) are only needed if the data files are
deleted. They append one trial at a time and replace that trial's rows if you run
them again. Run them in order a, b, c.

## Reading the results

`report/results-summary.md` has the numbers. Two things to keep in mind when
reading it:

1. The three standard-of-care arms are not the same treatment in practice. They
   used different salvage regimens, different proportions of patients actually got
   to ASCT, and different proportions later received CAR-T. Treating them as one
   node is an assumption. `results/tables/transitivity_comparator_check.csv` is
   the check I ran on it, and the arms do not line up perfectly.
2. The OS comparisons are the weakest part of the analysis, because the
   standard-of-care arms were contaminated by crossover or later commercial CAR-T
   in all three trials.

## Software

R 4.6.1, `netmeta` 3.6.1, `robvis` 0.3.1. Package versions are pinned in
`renv.lock`.

## Licence

MIT.
