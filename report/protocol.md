# Protocol

## Title

Comparative efficacy and safety of second-line CD19-directed CAR T-cell therapies
for relapsed or refractory large B-cell lymphoma: a frequentist network
meta-analysis.

## What this project is

A frequentist network meta-analysis (NMA) in R, comparing the three CD19 CAR-T
products that have been tested as second-line treatment in relapsed or refractory
large B-cell lymphoma (R/R LBCL): axicabtagene ciloleucel (axi-cel),
tisagenlecleucel (tisa-cel) and lisocabtagene maraleucel (liso-cel).

This is a learning project. The point is to plan and run an NMA properly on a
small evidence base where every decision can be checked, rather than to produce a
large review. The analysis is reproducible: the R environment is locked with
`renv` and the R and `netmeta` versions are reported with the results.

## Background

Aggressive non-Hodgkin lymphoma (NHL) is one of the more common haematological
cancers. Around 250,000 new cases are diagnosed worldwide each year, and large
B-cell lymphoma (LBCL) makes up about a third of adult NHL cases. It mostly
affects older adults, who often have other conditions as well [@sehn2021]. In the
United States about 80,350 new NHL cases were expected in 2025, 45,140 in men and
35,210 in women [@acs2025].

Diffuse large B-cell lymphoma (DLBCL) is the most common subtype of LBCL and
accounts for roughly 80-90% of cases [@sehn2021]. First-line rituximab plus
cyclophosphamide, doxorubicin, vincristine and prednisone (R-CHOP) cures many
patients, but the ones with primary refractory disease or a relapse within 12
months do badly [@sehn2021]. The standard second-line option for patients who are
fit enough has been platinum-based salvage immunochemotherapy followed by high-dose
chemotherapy and autologous stem-cell transplantation (ASCT) in those who respond
well enough. More than half of patients never get to ASCT because salvage therapy
does not shrink the disease enough [@bishop2022], which is the gap the CAR-T trials
were designed to fill.

Newer treatments have changed the picture for R/R LBCL, including monoclonal
antibodies, antibody-drug conjugates, bispecific antibodies and CD19-directed CAR
T-cell therapy [@sehn2021]. Axi-cel, tisa-cel and liso-cel were first approved
for third-line or later treatment, on the basis of the single-arm ZUMA-1, JULIET
and TRANSCEND NHL 001 studies [@neelapu2017; @schuster2019; @abramson2020].

Three phase III randomised trials then moved CAR-T into second line: ZUMA-7,
TRANSFORM and BELINDA. ZUMA-7 and TRANSFORM both beat standard salvage chemotherapy
followed by ASCT, and axi-cel and liso-cel were approved in second line on the back
of them [@locke2022; @abramson2023]. BELINDA did not show a difference, and tisa-cel
was not approved for second-line use, so it stays a later-line option
[@bishop2022]. BELINDA still enrolled the same kind of patient and tested the same
strategy, so it belongs in the comparison.

No trial has randomised one CAR-T product against another. Each product has only
been compared with a standard-of-care arm, so an indirect comparison is the only way
to put them side by side. An NMA does this while keeping the randomisation inside
each trial, and gives estimates for comparisons that were never run directly.

The question this project answers is therefore: in adults with primary refractory
or early relapsed LBCL who are eligible for second-line treatment, how do axi-cel,
tisa-cel and liso-cel compare with each other and with standard-of-care salvage
chemoimmunotherapy?

## PICO

### Population

Adults (18 years or older) with large B-cell lymphoma that is primary refractory to,
or has relapsed within 12 months of, first-line anti-CD20 plus anthracycline-based
chemoimmunotherapy, and who are considered fit for second-line treatment.

### Intervention

One of three CD19-directed CAR-T products given as second-line treatment:
axicabtagene ciloleucel, lisocabtagene maraleucel or tisagenlecleucel.

### Comparator

Platinum-based salvage immunochemotherapy followed, where appropriate, by high-dose
chemotherapy and ASCT.

The three trials' standard-of-care arms are treated as one comparator node. This is
an assumption and it is worth being explicit about it. The arms were not identical:
the salvage regimens differed, the share of patients who actually reached ASCT
differed, and supportive care differed. Since every CAR-T versus CAR-T estimate in
this network passes through that node, any real difference between the three arms
goes straight into the indirect comparisons. I test this by comparing the raw CRR,
ORR and OS of the three standard-of-care arms with each other, and I discuss it as a
limitation.

### Outcomes

The outcomes are ranked in advance so that the project does not turn into a pile of
separate NMAs. One primary outcome and two key secondary outcomes carry the
confirmatory analysis. The rest is exploratory or descriptive.

#### Primary outcome

**Complete response rate (CRR).** This is the outcome where transitivity is easiest
to defend, because CR is defined the same way in all three trials (Lugano 2014,
PET-based). That is why CRR is the primary outcome even though EFS was the primary
endpoint of all three trials. Response is also measured before any treatment
switching, so crossover does not affect it, which is not true for OS.

Whether response was read by an independent review committee or by the investigators
was checked during extraction; it is recorded per trial in the data. All three
trials used blinded independent review.

#### Key secondary outcomes (confirmatory)

- **Overall response rate (ORR)**, defined as CR plus partial response under the
  same Lugano criteria. This is the pre-specified companion analysis to CRR.
- **Overall survival (OS)**, as a hazard ratio with 95% CI. OS is the most
  clinically meaningful endpoint but also the least transitive one in this network,
  so its results carry the biggest caveat.

#### Exploratory outcomes

- **Event-free survival (EFS)**, as a hazard ratio. EFS is what the trials were
  powered on, but the event definition is not the same in the three trials, which
  is a direct threat to transitivity for this outcome. It is reported as
  exploratory for that reason.
- **Progression-free survival (PFS)**, as a hazard ratio where it is reported.

#### Safety (descriptive)

Safety is reported at two levels.

1. **Named toxicities**, which are the informative part: cytokine release syndrome
   (CRS) and neurotoxicity/ICANS, each as any grade and grade 3 or above. These are
   the events that separate CAR-T from chemotherapy. The grading systems differ
   between trials (Lee versus ASTCT for CRS [@lee2014crs], CTCAE v4.03 versus v5.0
   for ICANS), and
   the system used by each trial is recorded. Those differences are a transitivity
   caveat for safety.
2. **Aggregate measures** for background only: treatment-emergent adverse events
   (TEAEs), serious adverse events (SAEs) and grade 3 or above adverse events.
   "Any grade 3 or above AE" will be close to universal on every arm, since CAR-T,
   salvage chemotherapy and ASCT are all toxic, so the number says very little.

Safety denominators are the as-treated (safety) population, not the randomised
population. In TRANSFORM and BELINDA a number of randomised patients were never
infused, so `n_safety` and `n_randomised` are extracted separately and never mixed.

Safety is summarised quantitatively (odds ratios with 95% CI) where both arms of a
trial report the same event, but the safety table is descriptive. It is not meant to
support a "safest CAR-T" ranking. CRS, ICANS, platinum salvage and ASCT are
mechanistically unrelated kinds of harm, and averaging over them would not mean
anything.

#### Patient-reported outcomes (descriptive)

Health-related quality of life and other PROs reported in the trial publications
(for example FACT-Lym, EQ-5D, EORTC QLQ-C30) are extracted and summarised in a
table. They are pooled only if at least two trials report the same instrument at the
same timepoint. They do not, so PROs stay narrative.

### Timing

Outcomes are taken at the longest available follow-up in a peer-reviewed journal
publication. For EFS, OS and PFS that means the hazard ratio from the most mature
report of each trial. For CRR, ORR and safety, response rates do not change with
longer follow-up, so the numbers come from the trial's primary analysis; a later
paper reporting the same response rates is not a new data point.

This rule has a consequence that should be stated: the trials contribute data at
very different maturity. ZUMA-7 has follow-up beyond four years, TRANSFORM has three,
BELINDA has ten months. A hazard ratio is an average over the period observed, so
hazard ratios measured over different windows are not perfectly comparable. A data
maturity table (trial by outcome by cut-off date by median follow-up) is produced
and shown next to every time-to-event table for this reason. Proportional hazards
are checked by eye from the published curves rather than formally.

## Eligibility criteria

### Inclusion

- Phase III randomised controlled trials.
- Adults with primary refractory or early relapsed LBCL (relapse within 12 months of
  first-line therapy) who are eligible for second-line treatment.
- One of the three CD19 CAR-T products as the intervention.
- Standard-of-care salvage chemoimmunotherapy, or another eligible intervention in
  the network, as the comparator.
- At least one of the predefined outcomes reported.
- Peer-reviewed journal publications only.

### Exclusion

- Non-randomised studies and single-arm studies.
- Phase I or phase II trials.
- Studies that include children.
- Studies of third-line or later treatment.
- Lymphoma subtypes outside the LBCL population.
- Reviews, editorials, letters, case reports, case series and protocols.
- Conference abstracts, all of them. The most recent follow-up for these trials
  usually appears at ASH, EHA or ASCO before it appears in a journal, so the rule
  "use the most mature follow-up" would otherwise collide with "exclude abstracts".
  The decision is that only journal publications count, and the data are frozen at a
  declared cut-off date. The cost is that a conference-only update at the cut-off
  may be missed, and that is accepted as a limitation.
- Duplicate publications; the one with the most complete or most recent data is
  kept.

## Search strategy

### Databases

PubMed and ClinicalTrials.gov, from inception to the declared cut-off date (the day
the search is run, recorded in the report). CENTRAL will be added if institutional
access becomes available. ClinicalTrials.gov is used both to find trials and to
cross-check the registrations of the included publications. WHO ICTRP or the EU CTR
will be used as an extra free registry check if time allows. Reference lists of the
included studies and of relevant reviews are screened by hand.

It is worth saying in advance that the eligible universe here is tiny and more or
less known: three phase III trials plus their follow-up publications and their
registrations. The search is there to show the set is complete, not to discover
things. If it turns up many more eligible RCTs than that, the eligibility criteria
are wrong somewhere and need another look before going further.

### Search terms

- Population: "large B-cell lymphoma", "diffuse large B-cell lymphoma", DLBCL, LBCL.
- Intervention: "CAR-T", "CAR T-cell", "chimeric antigen receptor", "axicabtagene
  ciloleucel", "axi-cel", "tisagenlecleucel", "tisa-cel", "lisocabtagene
  maraleucel", "liso-cel".
- Design: randomised, randomised controlled trial, phase III, phase 3, clinical
  trial.

The draft PubMed string is below. The version that is actually run, with its
execution date, will be added to this protocol before the search is executed.

```
("large B-cell lymphoma"[tiab] OR "large B cell lymphoma"[tiab] OR "diffuse large B-cell lymphoma"[tiab] OR DLBCL[tiab] OR LBCL[tiab] OR "Lymphoma, Large B-Cell, Diffuse"[Mesh])
AND
("Receptors, Chimeric Antigen"[Mesh] OR "chimeric antigen receptor"[tiab] OR "CAR-T"[tiab] OR "CAR T"[tiab] OR "CAR T-cell"[tiab] OR "axicabtagene ciloleucel"[tiab] OR "axi-cel"[tiab] OR "tisagenlecleucel"[tiab] OR "tisa-cel"[tiab] OR "lisocabtagene maraleucel"[tiab] OR "liso-cel"[tiab])
AND
("Randomized Controlled Trial"[pt] OR randomized[tiab] OR randomised[tiab] OR "phase III"[tiab] OR "phase 3"[tiab])
```

### Study selection

Records go into Rayyan and duplicates are removed. Titles and abstracts are screened
against the eligibility criteria, then full texts are assessed. Screening is done by
one reviewer, which is not the standard two-reviewer approach and is acknowledged as
a limitation.

Three safeguards are planned instead:

1. After a break of one to two weeks, 10-20% of the titles and abstracts are
   re-screened blind to the first decision, and agreement is reported.
2. Every full-text exclusion is read a second time before the dataset is frozen.
3. Reasons for exclusion at full text are documented and summarised in a PRISMA 2020
   flow diagram.

### Language

No language restriction. English and French publications are assessed directly;
other languages are included if a reliable translation is available.

### Limitations

Embase and MEDLINE via Ovid are not searched, because there is no institutional
access. PubMed covers a lot but not everything, so this may miss studies. Reference
screening and ClinicalTrials.gov searches partly make up for it. Conference
abstracts are excluded as data sources, so follow-up that exists only as an abstract
at the cut-off is not captured.

## Data extraction

### Sources

For each trial the most mature peer-reviewed follow-up publication is used. Where a
trial has more than one, the longest follow-up with the most complete outcome data is
the primary source and the earlier one is kept for sensitivity analysis. In practice
that means the primary and long-term papers for ZUMA-7 and TRANSFORM
[@westin2023; @kamdar2025], and the primary paper for BELINDA, which had no long-term
journal follow-up at the time of writing.

### Variables

A standard extraction form is piloted on one trial first. The variables are:

- **Trial identifiers:** NCT number, citation, year, journal, data cut-off, median
  follow-up.
- **Design:** randomisation ratio, blinding, sample size per arm, bridging therapy
  policy, crossover, how response was assessed.
- **Population:** age, prior lines, stage, IPI, region, primary refractory versus
  early relapse, time from diagnosis to infusion.
- **Comparator-arm checks:** the salvage regimens used in each standard-of-care arm,
  the proportion of that arm that reached ASCT, and its raw CRR, ORR and OS. These
  are what the comparator-node assumption is tested with.
- **Crossover and subsequent CAR-T:** the proportion of the standard-of-care arm
  that received CAR-T afterwards, whether by protocol crossover or commercially.
- **Outcome definitions:** who assessed response in each trial, and each trial's EFS
  event definition quoted word for word.
- **Safety:** `n_safety` alongside `n_randomised` for every arm, and the grading
  system used for CRS and for ICANS.

### Outcome data

Hazard ratios with 95% CI are extracted for EFS, OS and PFS from the longest
follow-up. For CRR, ORR and safety, the number of patients and the number with the
event are taken from the tables or supplementary appendices.

If a trial does not report a hazard ratio, it is reconstructed from the Kaplan-Meier
curves and numbers at risk using the methods of Tierney et al. (2007) and Parmar et
al. (1998). Reconstructed estimates are flagged and checked against any directly
reported HR from the same trial. If reconstruction is not possible, that trial and
outcome is left out of the analysis rather than imputed, and the reason is recorded
in the data dictionary. Nothing in the current dataset is reconstructed.

Where trial investigators report a crossover-adjusted OS hazard ratio (for example
with an RPSFT model), it is extracted alongside the intention-to-treat estimate for
the pre-specified sensitivity analysis.

PRO instruments, timepoints and available summary statistics are extracted for
narrative description.

### Double extraction

All data are extracted once, left for at least a few days, then extracted again blind
onto a fresh form. The two passes are compared and differences are settled by going
back to the paper. This is the honest substitute for a second extractor.

## Risk of bias

Risk of bias is assessed with Cochrane RoB 2 across its five domains: randomisation,
deviations from intended interventions, missing outcome data, measurement of the
outcome, and selection of the reported result. It is done outcome by outcome,
because the answers differ: CRR is low risk throughout, while OS is not, since the
trials are open label and the standard-of-care arm is changed by crossover or by
later commercial CAR-T.

The assessment is by one reviewer, with a second pass over every judgment after a
break. Results are shown with the `robvis` package as a traffic-light plot and a
weighted summary plot [@mcguinness2021].

## Statistical analysis

### Network meta-analysis

Frequentist NMAs are run with the `netmeta` package. Time-to-event outcomes use
hazard ratios, dichotomous outcomes use odds ratios, and standard of care is the
reference treatment. Results are shown as network plots, league tables of all
pairwise comparisons, forest plots against standard of care, and P-scores.

`pairwise()` from `netmeta` is used only to reshape the arm-level data into the
contrast format the network model needs. It is not pooling anything, because each
direct comparison is informed by exactly one trial.

**Why a common-effect model.** The common-effect (fixed-effect) model is the primary
analysis, and the reason is what the data can estimate rather than a claim that the
trials are identical. With one trial per comparison, tau^2 cannot be estimated at
all, and with three trials a random-effects estimate would be driven almost entirely
by whatever tau^2 was assumed. The trials do differ clinically, in bridging policy,
in EFS definition and in follow-up length, and a common-effect model does not make
that go away; it just does not model it. Sensitivity analysis 4 re-runs the main
analyses with a plausible tau^2 assumed, to see whether the conclusions depend on
the choice.

**Validation.** With one study per comparison, the direct (CAR-T versus SOC)
estimates of the NMA have to reproduce the trial inputs exactly. This is checked in
every script; a mismatch would mean the data were assembled incorrectly.

**Zero cells.** Where an arm has zero events, 0.5 is added to all four cells of that
comparison. This is decided here rather than after looking at the results. It is
expected to matter mainly for named toxicities, for example zero grade 3 or above CRS
events in a standard-care arm. The known problem with a fixed 0.5 is that with very
rare events it pulls the estimate towards no effect, so if a zero cell turns up in a
key safety comparison, a second analysis with a treatment-arm-sized correction is
reported alongside it.

### Heterogeneity

Not formally estimable. tau^2 and I^2 need more than one trial per comparison, and
every comparison here has exactly one. This is reported as a structural limitation
of the evidence base, not as heterogeneity of zero.

### Transitivity

Assessed qualitatively, by comparing baseline characteristics and design features
across the three trials, with particular attention to the three standard-of-care
arms, since the whole network passes through them.

Characteristics compared:

- Age, prior lines, stage.
- **IPI distribution.** IPI is a plausible effect modifier in DLBCL, so a different
  mix across trials threatens transitivity directly.
- **Region.** BELINDA enrolled heavily in Asia and Australia, unlike the other two.
  Regional differences in salvage practice and supportive care matter.
- **Primary refractory versus early relapse.** These groups have different
  prognoses, so an imbalance across trials biases the indirect comparison.
- **Time from diagnosis to infusion**, which says something about how realistic the
  trial setting is. A long interval disadvantages the CAR-T arm.
- **Design features:** bridging policy, crossover, who assessed response.
- **The comparator check:** salvage regimens, the proportion of the standard-of-care
  arm that reached ASCT, and the raw CRR, ORR and OS of each standard-of-care arm.
  This is the best empirical test of the comparator-node assumption. If the three
  arms' raw outcomes look very different, the common comparator is not behaving like
  one treatment and the indirect comparisons have to be read with that in mind.

Transitivity is also assessed per outcome, not only per population.

- **EFS is not harmonised.** ZUMA-7 counts death, progression, new therapy, or
  relapse after stable disease or a non-CR/PR response. BELINDA additionally counts
  failure to reach a PET-negative CR by week 6 (followed by progression or death) as
  an event, which turns a slow CAR-T response into an event when the other trials
  would not. This is a common explanation for BELINDA's null EFS result despite an
  identical CR rate in its two arms. EFS transitivity is therefore not assumed.
- **OS is the least transitive outcome here.** All three standard-of-care arms are
  contaminated by later CAR-T, but by different routes. TRANSFORM allowed protocol
  crossover to liso-cel, BELINDA allowed crossover to tisa-cel, and ZUMA-7 did not
  allow crossover inside the trial but a large share of its standard-care arm
  received commercial CAR-T after progression. So the "standard of care" node means
  three different things for OS, and the crossover-adjusted sensitivity analysis
  matters most here. Adjusted estimates produced by different methods in different
  trials are also not necessarily comparable with each other.
- **CRR is unaffected by switching**, because response is read before any switch.

Named design differences that go in the transitivity table:

- ZUMA-7 did not allow chemotherapy bridging; TRANSFORM allowed one cycle and
  BELINDA allowed bridging in most patients.
- 25.9% of BELINDA's CAR-T arm had progressed by week 6, against 13.8% in its own
  control arm. This is often cited as a mechanical reason the trial read null rather
  than as evidence that the drug does not work.
- Crossover differs a lot: 67% of TRANSFORM's standard-care arm crossed over to
  liso-cel by the primary analysis (50/92, 54%, at the interim), 50.6% of BELINDA's
  crossed over, and 57% of ZUMA-7's standard-care arm later received commercial
  CAR-T.

### Consistency

Not assessable. Consistency is the agreement between direct and indirect evidence,
and it can only be checked where a closed loop gives both kinds of evidence for the
same comparison. This network is star shaped with no direct CAR-T versus CAR-T trial,
so there is no loop and node splitting does not apply. The practical consequence is
that nothing in this network checks transitivity statistically; the qualitative
assessment above is doing all the work.

### Ranking

P-scores (the frequentist analogue of SUCRA) are reported, and read next to the point
estimates and intervals rather than on their own. With three trials in a star
network the uncertainty is wide and the intervals overlap, so the P-score order
mostly reflects the order of the point estimates. The report will say something close
to:

> P-scores are reported for completeness. Because the network consists of three
> trials connected only through a common comparator, all CAR-T versus CAR-T
> comparisons are entirely indirect with wide, overlapping confidence intervals. The
> P-score ordering therefore reflects the ordering of the point estimates rather than
> evidence of superiority, and no conclusion that one CAR-T product outranks another
> is warranted from these data.

### Sensitivity analyses

1. **ORR instead of CRR.** The primary analysis is re-run with ORR responders in
   place of CR responders, to see whether the direction and the ordering hold across
   the two Lugano response outcomes.
2. **Follow-up duration.** Where a trial has more than one publication, the most
   mature follow-up is the primary analysis and the earlier readout is re-run as a
   sensitivity analysis. For TRANSFORM this means the interim analysis
   [@kamdar2022] against the primary analysis [@abramson2023].
3. **Crossover-adjusted OS.** The OS analysis is repeated with the crossover-adjusted
   hazard ratios reported by the investigators. These estimates use different
   methods in different trials, so they are not in the primary analysis.
4. **Assumed heterogeneity.** CRR and OS are re-run with a moderate tau^2 assumed,
   taken from published empirical distributions for the relevant outcome type
   [@turner2012; @rhodes2015], passed to `netmeta` through
   `tau.preset`. Since tau^2 cannot be estimated from three single-trial comparisons,
   this shows whether a conclusion would change if a realistic amount of
   heterogeneity were there.

Any further sensitivity analysis is only added if the data support it, and is
reported as such.

## Confidence in the evidence

Assessed qualitatively with the CINeMA framework [@nikolakopoulou2020] across its five
domains: within-study bias, indirectness, imprecision, heterogeneity and
incoherence. Each is rated high, moderate, low or very low with a short
justification. The formal CINeMA web application is not used.

Two domains are not rated at all in this network. Heterogeneity cannot be judged
when tau^2 is not estimable, and incoherence cannot be judged when there is no closed
loop. They are recorded as "not assessable" with the reason, because a rating would
imply the domain had been checked.

The qualitative version also gives up CINeMA's contribution-weighted within-study
bias step, where RoB judgments are weighted by each trial's contribution to the
network. In a star network with equal contributions per comparison that loss is
small, but it is a difference from the full tool rather than an equivalent.

**Imprecision threshold.** So that "imprecise" means something specific, a
clinically meaningful effect is defined in advance as an odds ratio of 1.25 for
dichotomous outcomes and a hazard ratio of 0.80 for time-to-event outcomes.
Confidence intervals are judged against those numbers.

## Reporting

The report follows the PRISMA extension for network meta-analyses (PRISMA-NMA;
Hutton et al., Ann Intern Med 2015), with the completed checklist as a supplement and
a PRISMA 2020 flow diagram for identification and selection.

## Reproducibility

Everything runs in R, with package versions pinned by `renv::snapshot()` and the
lockfile committed. The R and `netmeta` versions used for the final analysis are
reported with the results. The analysis scripts are numbered and version controlled.
Changes to this protocol are listed in `report/amendments-log.md`, and anything
changed after data extraction started is flagged there as post hoc.

## References

Managed in `report/references.bib` and cited in the text with Pandoc keys.
