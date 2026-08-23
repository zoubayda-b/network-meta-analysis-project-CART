# Protocol 

## Title:
Comparative Efficacy and Safety of Second-Line CD19-Directed CAR T-Cell Therapies for Relapsed or Refractory Large B-Cell Lymphoma: A Frequentist Network Meta-analysis Protocol

## Project Aim:
The aim of this project is to conduct a reproducible frequentist network meta-analysis in R comparing second-line CAR-T therapies for relapsed or refractory large B-cell lymphoma. Statistical analyses will be conducted in R using a fully reproducible workflow, with the analysis environment locked via `renv` and the software versions reported in the final report (R version, `netmeta` version).

This is a personal learning project. Its goal is to build the skills of planning and running a network meta-analysis correctly, using a real clinical question with a small, well-defined evidence base.

## Background
Aggressive non-Hodgkin lymphoma (NHL) comprises a heterogeneous group of lymphoid malignancies and represents one of the most common hematological cancers worldwide. Approximately 250,000 new cases are diagnosed each year globally, with large B-cell lymphoma (LBCL) accounting for around one-third of adult NHL cases and occurring predominantly in older adults who frequently depict multiple comorbidities [@bishop2022; @ernst2021]. In the United States, an estimated 80,350 new cases of NHL are expected in 2025, including 45,140 cases in men and 35,210 cases in women [@acs2025].

Diffuse large B-cell lymphoma (DLBCL) is the most common subtype of LBCL, accounting for approximately 80-90% of cases [@bishop2022]. Although first-line treatment with rituximab plus cyclophosphamide, doxorubicin, vincristine, and prednisone (R-CHOP) achieves durable remissions for many patients, outcomes remain poor for those with primary refractory disease or relapse within 12 months of initial therapy [@bishop2022]. Historically, the standard second-line treatment for eligible patients has consisted of platinum-based salvage immunochemotherapy followed by high-dose chemotherapy and autologous stem-cell transplantation (ASCT) in patients achieving an adequate response. However, more than half of patients fail to proceed to ASCT because salvage therapy does not sufficiently reduce tumour burden, highlighting a substantial unmet clinical need [@bishop2022].

Recent advances in immunotherapy have transformed the treatment landscape for relapsed or refractory (R/R) LBCL. Novel therapeutic approaches, including monoclonal antibodies, antibody-drug conjugates (ADCs), bispecific antibodies (BsAbs), and CD19-directed chimeric antigen receptor (CAR) T-cell therapies, have expanded treatment options for patients with advanced disease [@abrisqueta2024]. Axicabtagene ciloleucel (axi-cel), tisagenlecleucel (tisa-cel), and lisocabtagene maraleucel (liso-cel) were initially approved for third-line or later treatment of R/R LBCL following the results of the single-arm ZUMA-1, JULIET, and TRANSCEND NHL 001 studies, respectively [@neelapu2017; @schuster2019; @abramson2020].

Subsequently, three phase III randomized controlled trials—ZUMA-7, TRANSFORM, and BELINDA evaluated whether CAR T-cell therapy could improve outcomes when used earlier in the treatment pathway as second-line therapy for patients with primary refractory or early relapsed LBCL. Both ZUMA-7 and TRANSFORM demonstrated superior outcomes compared with standard salvage chemotherapy followed by ASCT, leading to second-line approval of axi-cel and liso-cel [@locke2022; @abramson2023]. In contrast, BELINDA did not demonstrate a significant improvement over standard of care, and consequently tisa-cel did not receive regulatory approval for second-line treatment and remains indicated in later lines of therapy [@bishop2022]. Nevertheless, BELINDA enrolled the same second-line patient population and evaluated the same treatment strategy as the other phase III trials, making it an appropriate study for inclusion in comparative evidence synthesis.

To date, no randomized head-to-head trial has directly compared axi-cel, liso-cel, and tisa-cel. Instead, each CAR T-cell therapy has been evaluated only against a common standard-of-care comparator. Consequently, indirect treatment comparisons (ITCs) are required to estimate the relative efficacy of these interventions. Network meta-analysis (NMA), a robust form of indirect treatment comparison, enables simultaneous comparison of multiple interventions while preserving the randomization within each included trial and provides estimates of comparative treatment effects when direct evidence is unavailable.

Therefore, the objective of this project is to conduct a frequentist network meta-analysis to indirectly compare the efficacy of CD19-directed CAR T-cell therapies evaluated in randomized second-line trials in patients with relapsed or refractory LBCL.

## Research Question
In adults with primary refractory or early relapsed (≤12 months after completion of first-line therapy) large B-cell lymphoma eligible for second-line treatment, how do axicabtagene ciloleucel, tisagenlecleucel, and lisocabtagene maraleucel compare with one another and with standard-of-care salvage chemoimmunotherapy in terms of efficacy and safety?

## PICO
### Population
Adults (≥18 years) with large B-cell lymphoma, primary refractory to or relapsed within 12 months after completion of first-line anti-CD20 monoclonal antibody plus anthracycline-based chemoimmunotherapy, considered eligible for second-line treatment.
### Intervention
Three CD19-directed CAR T-cell therapies administered as second-line treatment: axicabtagene ciloleucel, lisocabtagene maraleucel, and tisagenlecleucel.
### Comparator
Standard-of-care platinum-based salvage immunochemotherapy followed, where appropriate, by high-dose chemotherapy and autologous stem-cell transplantation (ASCT).

**The comparator node is an assumption, and it is stated here openly.** The three trials' standard-of-care arms will be treated as one single comparator ("node") in the network. In reality these three arms are not identical: they used different salvage regimens, different proportions of patients actually reached ASCT, and supportive care differed. Treating them as one node means assuming they are similar enough to be compared through. This matters because every CAR-T versus CAR-T comparison in this network is calculated *through* this node — if the three standard-of-care arms are not truly comparable, the indirect comparisons inherit that problem. This assumption will be checked by comparing the raw results (CRR, ORR, OS) of the three standard-of-care arms against each other, and it will be discussed as a limitation of the analysis.

### Outcomes
Outcomes will be ranked a priori to define which outcomes are most important and to avoid doing too many separate NMAs. One primary outcome and two key secondary outcomes will be used for confirmatory analysis. The remaining outcomes will be considered exploratory and will be reported descriptively.

#### Primary Outcome
- **Complete response rate (CRR)**: the most transitivity-defensible outcome, because CR is defined consistently across all three trials by the Lugano 2014 PET-based response criteria. This harmonization is what makes CRR suitable as the basis for an indirect comparison, in contrast to EFS even though EFS was the primary endpoint in all 3 trials. *Note:* whether response in each trial was assessed by an independent review committee or by the trial investigators will be verified during data extraction (this differs between trials and can change the reported rate by several percentage points); if the verification shows this sentence needs correcting, the correction will be logged as a protocol amendment. A further practical advantage of CRR: response is assessed before any treatment switching, so CRR is not affected by crossover — unlike overall survival.

#### Secondary Outcomes
##### Key secondary (confirmatory)
- **Overall response rate (ORR)**: defined as CR + partial response, by the same Lugano criteria; pre-specified sensitivity/confirmatory companion to CRR.
- **Overall survival (OS)**: the most clinically meaningful survival endpoint, reported as a hazard ratio with 95% CI. OS is also the *least* transitive outcome in this network (see Assessment of Transitivity), so its results carry the largest caveat.

##### Exploratory
- **Event-free survival (EFS)**: reported as a hazard ratio with 95% CI. **Important transitivity caveat:** EFS is the trial-level endpoint these studies were powered on, but its event definition is *not* harmonized across the three trials, which materially threatens transitivity for this outcome specifically (see Assessment of Transitivity). EFS is therefore reported as exploratory and interpreted under that caveat, not as a primary confirmatory result.
- **Progression-free survival (PFS)**: reported as a hazard ratio with 95% CI where available.

##### Safety (descriptive synthesis)
Safety is reported at two levels:

1. **Named toxicities (the informative comparisons):** cytokine release syndrome (CRS) and neurotoxicity/ICANS, each as *any grade* and *grade ≥3*. These are the toxicities that actually distinguish CAR-T products from chemotherapy, so they are the safety outcomes that matter clinically. The grading systems used for CRS and ICANS differ between trials (e.g., Lee vs ASTCT criteria for CRS); the system used by each trial will be extracted, and these differences will be treated as a transitivity caveat for safety results.
2. **Aggregate measures (background only):** treatment-emergent adverse events (TEAEs), serious adverse events (SAEs), and grade ≥3 adverse events (CTCAE). "Any grade ≥3 AE" will be near-universal on every arm (CAR-T, salvage chemotherapy, and ASCT are all highly toxic), so this number carries little comparative information and is reported only for completeness.

**Denominators:** safety outcomes are reported on the *as-treated* (safety) population, not the randomized (ITT) population — in TRANSFORM and BELINDA, a non-trivial number of randomized patients were never infused. The safety-population denominator (n_safety) will be extracted alongside the randomized denominator (n_randomized) for every arm, and the two will never be mixed.

Safety outcomes will be synthesized quantitatively (odds ratios with 95% CIs) and presented in a league table, but **this safety league table is descriptive only and is not intended to support a "safest CAR-T" ranking.** The toxicity profiles of CAR-T products (CRS, ICANS), platinum salvage, and ASCT are categorically different, and an aggregate "odds of any Grade ≥3 AE" averages over mechanistically unrelated events. Rankings derived from safety outcomes will not be emphasised.

##### Patient-Reported Outcomes (Descriptive Synthesis)
Health-related quality of life and patient-reported outcomes (e.g., FACT-Lym, EQ-5D) reported in trial publications. These will be extracted and summarized descriptively in a summary table. A formal meta-analysis of PROs will be conducted only if at least two trials report comparable instruments and timepoints; otherwise, results will be presented narratively without statistical pooling.

### Timing (if applicable)
Outcomes will be extracted at the longest available follow-up reported for each included study. For time-to-event outcomes (EFS, OS, PFS), the most appropriate effect estimate reported by each study (e.g., hazard ratio with 95% confidence interval, where available) will be extracted from the longest available follow-up. For dichotomous outcomes (CRR, ORR, and safety outcomes), data from the final reported assessment at the longest available follow-up will be extracted. For each trial, the most mature follow-up **peer-reviewed journal publication** available at the time of data extraction will serve as the primary data source.

**Consequence of this rule, stated openly:** the trials will contribute data at very different follow-up maturities (ZUMA-7 has multi-year updates; BELINDA's follow-up is much shorter). A hazard ratio is an average over the observed period, so HRs measured over different time windows are not perfectly like-for-like. To keep this visible, a **data maturity table** (trial × outcome × data-cutoff date × median follow-up) will be produced and presented alongside every time-to-event league table, and time-to-event results will be interpreted with these maturity differences in mind. Proportional-hazards plausibility will be checked narratively (by inspecting curve shapes) during extraction.

## Eligibility Criteria
### Inclusion Criteria
- Phase III randomized controlled trials (RCTs).
- Adults (≥18 years) with primary refractory or early relapsed (≤12 months after completion of first-line therapy) large B-cell lymphoma (LBCL) who are eligible for second-line treatment.
- Treatment with one of the following CD19-directed CAR-T cell therapies: Axicabtagene ciloleucel, Tisagenlecleucel, Lisocabtagene maraleucel
- Standard-of-care salvage chemoimmunotherapy, or another eligible intervention within the treatment network.
- Studies reporting at least one of the predefined outcomes
- **Peer-reviewed journal publications only** (see note below).

### Exclusion Criteria
- Non-randomized studies
- Single-arm studies
- Phase I or Phase II clinical trials
- Studies including pediatric populations (<18 years).
- Studies evaluating patients receiving third-line or later therapy
- Studies involving lymphoma subtypes outside the predefined LBCL population.
- Reviews, editorials, letters, case reports, case series, and study protocols.
- **Conference abstracts (all of them, as data sources).** Reason for deciding this now: the newest follow-up data for these trials often appears at conferences (ASH/EHA/ASCO) before a journal paper exists, and the protocol rule "use the most mature follow-up" would otherwise collide with "exclude abstracts." The decision is: only peer-reviewed journal publications count as data sources, and the data are frozen as of a declared cutoff date (the day the searches are executed, which will be recorded verbatim in `protocol/search_strategy.md`). This keeps the rule simple, reproducible, and free of case-by-case exceptions. The trade-off — possibly missing the very latest conference-only update — is accepted and will be named as a limitation.
- Duplicate publications (the publication with the most complete or most recent data will be included)

## Search Strategy
### Databases
The literature search will be conducted from database inception to the declared cutoff date (the search execution date) using PubMed and ClinicalTrials.gov. If institutional access becomes available, the Cochrane Central Register of Controlled Trials (CENTRAL) will also be searched. ClinicalTrials.gov will be searched to identify completed and ongoing trials and to cross-check trial registrations against published studies; WHO ICTRP or EU CTR will be used as a free additional registry cross-check if time permits. Reference lists of all included studies and relevant systematic reviews will be manually screened to identify additional eligible studies.

**Expectation, stated in advance:** the eligible universe for this question is tiny and essentially known — three phase III RCTs (ZUMA-7, TRANSFORM, BELINDA) plus their registrations and follow-up publications. The search's job is to *demonstrate completeness*, not to discover. If screening yields many more eligible RCTs than this, the eligibility criteria are misfiring somewhere and will be re-examined before proceeding.

### Search Terms
The search will include terms for:
Population: "large B-cell lymphoma", "large B cell lymphoma", "diffuse large B-cell lymphoma", "DLBCL", "LBCL".
Intervention: "CAR-T", "CAR T", "CAR-T cell", "CAR T-cell", "chimeric antigen receptor", "chimeric antigen receptor T cell", "axicabtagene ciloleucel", "axi-cel", "tisagenlecleucel", "tisa-cel", "lisocabtagene maraleucel", and "liso-cel".
Study design: "randomized", "randomised", "randomized controlled trial", "phase III", "phase 3", and "clinical trial".
Boolean operators (AND/OR) will be used to combine search terms, and database-specific syntax will be applied as appropriate. Reference lists of included studies and relevant reviews will also be screened to identify additional eligible studies.

**Draft verbatim PubMed search string** (to be reviewed before execution; the final executed string and its exact execution date will be saved verbatim in `protocol/search_strategy.md`):

```
("large B-cell lymphoma"[tiab] OR "large B cell lymphoma"[tiab] OR "diffuse large B-cell lymphoma"[tiab] OR DLBCL[tiab] OR LBCL[tiab] OR "Lymphoma, Large B-Cell, Diffuse"[Mesh])
AND
("Receptors, Chimeric Antigen"[Mesh] OR "chimeric antigen receptor"[tiab] OR "CAR-T"[tiab] OR "CAR T"[tiab] OR "CAR T-cell"[tiab] OR "axicabtagene ciloleucel"[tiab] OR "axi-cel"[tiab] OR "tisagenlecleucel"[tiab] OR "tisa-cel"[tiab] OR "lisocabtagene maraleucel"[tiab] OR "liso-cel"[tiab])
AND
("Randomized Controlled Trial"[pt] OR randomized[tiab] OR randomised[tiab] OR "phase III"[tiab] OR "phase 3"[tiab])
```

### Study Selection Process
Records identified through the database searches will be imported into Rayyan, and duplicate records will be removed. Titles and abstracts will be screened first against the predefined eligibility criteria, followed by full-text assessment of potentially eligible studies. Study selection will be conducted by a single reviewer (ZB) due to the scope and resource constraints of this project. This approach differs from the standard practice of independent screening by two reviewers and is acknowledged as a methodological limitation.

**Single-reviewer safeguards (pre-specified):**
1. *Test–retest check:* after a 1–2 week break, a random 10–20% of titles/abstracts will be re-screened blind to the first decision, and agreement between the two passes will be reported.
2. *Second look at exclusions:* every full-text exclusion will be re-read a second time before the dataset is frozen.
3. Reasons for exclusion at full-text review will be documented and summarized in a PRISMA 2020 flow diagram.

### Language restrictions:
No language restrictions will be applied. Studies published in English and French will be assessed directly. Studies published in other languages will be considered where a reliable translation is available.
### Limitations:
Due to the lack of institutional access to subscription-based databases, Embase and MEDLINE (via Ovid) will not be searched. Although PubMed provides extensive coverage of the biomedical literature, the omission of these databases may result in some relevant studies not being identified. This limitation will be partially mitigated through manual reference screening and searches of ClinicalTrials.gov. Conference abstracts are excluded as data sources (see Exclusion Criteria), so follow-up results that exist only in abstract form at the cutoff date will not be captured.

## Data Extraction
### Trial-Specific Primary Sources
For each included trial, data will be extracted from the most mature peer-reviewed follow-up publication available at the declared cutoff date. Where multiple publications exist for the same trial, the publication with the longest reported follow-up and most complete outcome data will serve as the primary source, with earlier publications retained for sensitivity analyses only. (In practice this means: initial + long-term follow-up papers for ZUMA-7 and TRANSFORM; the initial results paper for BELINDA, which had no long-term journal follow-up at the time of writing.)

### Variables to Extract
A standardized data extraction form will be developed and piloted using one included study before formal data extraction is undertaken.

**Trial identifiers:** NCT number, citation, year, journal, data cutoff date, median follow-up per outcome.

**Design features:** randomization ratio, blinding status, sample size per arm, bridging-therapy policy, crossover provisions, response-assessment method.

**Population characteristics relevant to transitivity:** age, prior lines of therapy, disease stage, IPI score, geographic region, proportion primary refractory vs early relapse, time from diagnosis to CAR-T infusion.

**Comparator-arm checks (needed to test the comparator-node assumption):** salvage regimens used in each trial's standard-of-care arm; the proportion of each SOC arm that actually reached ASCT; and each SOC arm's raw CRR, ORR, and OS, so the three common-comparator arms can be compared directly with each other.

**Crossover / subsequent CAR-T (all three trials):** for every trial, the proportion of the SOC arm that received CAR-T after the protocol treatment — whether by protocol crossover (TRANSFORM, BELINDA) or as commercial CAR-T after progression (ZUMA-7).

**Outcome-definition verification (two facts the protocol's outcome hierarchy rests on):**
- *Response assessor* per outcome per trial: independent review committee (IRC) or investigator-assessed, quoted from the paper.
- *EFS event definition* per trial: quoted verbatim, with page number.

**Safety denominators and grading systems:** n_safety (as-treated population) alongside n_randomized for every arm; the grading system used for CRS and for ICANS in each trial.

**Outcome data by arm**, as described below.

### Outcomes
For time-to-event outcomes (EFS, OS, and PFS), hazard ratios (HRs) with corresponding 95% confidence intervals will be extracted from the longest available follow-up reported in each study. For dichotomous outcomes (CRR, ORR, and safety outcomes), the number of participants and the number experiencing each outcome will be extracted for each treatment arm directly from the primary publication or its supplementary appendices.

**Handling of unreported hazard ratios:** If a trial does not report an HR with 95% CI for a time-to-event outcome, the estimate will be reconstructed from published Kaplan-Meier curves and numbers at risk using the methods of Tierney et al. (2007) / Parmar et al. (1998). Reconstructed estimates will be flagged in the dataset and checked for plausibility against any earlier directly reported HR from the same trial. If reconstruction is not feasible from the available data, that outcome-trial cell will be excluded from the corresponding NMA rather than imputed; the exclusion and its reason will be documented in the data dictionary.

**Crossover-adjusted OS:** Where reported by trial investigators (e.g., rank-preserving structural failure time [RPSFT] adjusted estimates), crossover-adjusted OS hazard ratios will be extracted alongside intention-to-treat estimates for use in a pre-specified sensitivity analysis.

**Patient-reported outcomes:** Where reported, PRO instruments (e.g., FACT-Lym, EQ-5D), assessment timepoints, and available summary statistics (mean change from baseline, standard deviation, or responder analyses) will be extracted for descriptive synthesis.

**Double extraction (single-reviewer safeguard):** all data will be extracted once, left for at least a few days, then re-extracted blind onto a fresh form. The two passes will be reconciled, and any differences will be resolved by returning to the source paper. This is the standard honest substitute for a second extractor.

## Risk of Bias Assessment
The risk of bias for each outcome will be assessed using the Cochrane Risk of Bias 2 (RoB 2) tool across its five domains: (1) the randomization process, (2) deviations from intended interventions, (3) missing outcome data, (4) measurement of the outcome, and (5) selection of the reported result. The assessment will be conducted by a single reviewer, with the same safeguards as screening (a second pass over every judgment before freezing, after a short break). Risk-of-bias judgments will be visualized using the robvis R package as traffic-light and weighted summary plots (McGuinness & Higgins, 2021).

## Statistical Analysis
### Network Meta-analysis
Frequentist network meta-analyses will be conducted using the netmeta package in R. Time-to-event outcomes (EFS, OS, and PFS) will be synthesized using hazard ratios (HRs) with corresponding 95% confidence intervals, while dichotomous outcomes (CRR, ORR, and safety outcomes) will be synthesized using odds ratios (ORs) with corresponding 95% confidence intervals. Standard of care will serve as the reference treatment. Results will be presented as network plots, league tables of all pairwise treatment comparisons, forest plots comparing each intervention with standard of care, and P-score rankings to summarize the relative performance of the interventions.

**Choice of model — common-effect (fixed-effect), and why.** A common-effect model will be used as the primary analytical approach. The reason is about what the data *can estimate*, not a claim that the trials are identical: with exactly one trial per comparison, between-study heterogeneity (τ²) cannot be estimated from the data at all, and with only three trials a random-effects estimate would be driven almost entirely by whatever τ² value was assumed. The trials *do* differ clinically (bridging policies, EFS definitions, follow-up maturity), and a common-effect model does not make those differences disappear — it simply does not model them. To check whether the conclusions depend on this choice, a pre-specified sensitivity analysis (Sensitivity Analysis 4) re-runs the key analyses while *assuming* a moderate amount of heterogeneity.

**Validation check.** With one study per comparison, the NMA's direct (CAR-T vs SOC) estimates must reproduce the trial-level inputs exactly. This will be verified for every outcome; any mismatch means the dataset was assembled incorrectly and will be fixed before proceeding.

**Zero-event handling:** For dichotomous outcomes where a treatment arm has zero events, a continuity correction of 0.5 will be applied to both arms of that comparison (the `netmeta::pairwise()` default), applied consistently and pre-specified here rather than decided post hoc. This is expected to matter mainly for named toxicities (e.g., zero grade ≥3 CRS events in a SOC arm). Known caveat: with very rare events and imbalanced arms, the fixed 0.5 correction can nudge results toward "no effect"; if a zero cell appears in a key safety comparison, a sensitivity analysis using a treatment-arm-sized continuity correction will be added and reported.

### Assessment of Heterogeneity
Not formally estimable in this network. Standard between-study heterogeneity statistics (τ², I²) require multiple trials informing the same comparison, and every edge in this network is informed by exactly one trial. This is reported as a structural limitation of the evidence base, not as a heterogeneity estimate of zero.

### Assessment of Transitivity
Assessed qualitatively, by comparing baseline characteristics and trial-design features across the three trials — with special attention to the three standard-of-care arms, since the whole network is built through them.

**Characteristics compared across trials (from each trial's Table 1 / supplementary material):**
- Age, prior lines of therapy, disease stage.
- **International Prognostic Index (IPI) score distribution**: a named, plausible effect modifier in DLBCL; differences in IPI mix across trials are a direct threat to transitivity.
- **Geographic region / enrollment distribution**: BELINDA enrolled heavily in Asia and Australia, unlike ZUMA-7 and TRANSFORM; regional differences in salvage regimen practice and supportive care are a recognised effect modifier.
- **Proportion primary refractory vs early relapse**: these subgroups have materially different prognosis, and an imbalanced mix across trials biases indirect comparisons.
- **Time from diagnosis to CAR-T infusion**: a measure of how well the trial reflects real-world turnaround; longer intervals disadvantage CAR-T arms.
- Trial-design features: bridging-therapy policy, crossover provisions, response-adjudication method (IRC vs investigator).
- **Comparator-arm check:** salvage regimens used, proportion of the SOC arm reaching ASCT, and the raw CRR/ORR/OS of each SOC arm. This is the single best empirical test of the comparator-node assumption: if the three SOC arms' raw outcomes look very different (for example, BELINDA's SOC CRR is conspicuously lower than ZUMA-7's), that is direct evidence that the common comparator is not behaving like one treatment, and the indirect comparisons must be interpreted accordingly.

**Outcome-definition transitivity:** Transitivity is assessed per outcome, not only per population.

- *EFS (not harmonized):* ZUMA-7 defines an EFS event as death, progressive disease, new therapy, or relapse/progression after a best response of stable disease or non-CR/PR; BELINDA additionally counts failure to achieve a PET-negative complete response by week 6 (with subsequent PD/death) as an event, a clause that treats a slow CAR-T response as an event even when the other trials would not. This definitional divergence is widely understood to contribute to BELINDA's null EFS result despite an identical CR rate in its two arms. **EFS transitivity is therefore not assumed**, and EFS results are interpreted under that explicit caveat. (The exact wording of each trial's EFS definition will be verified verbatim during extraction.)
- *OS (the least transitive outcome in this network):* all three trials have "contaminated" standard-of-care overall survival, by different routes. TRANSFORM allowed protocol crossover from SOC to liso-cel (50/92, 54%). BELINDA also allowed protocol crossover from SOC to tisa-cel. ZUMA-7 did not allow crossover inside the trial, but a large proportion of its SOC arm received commercial CAR-T after progression. So for OS, the "SOC" node means three different things across the three edges. Consequences, stated plainly: OS indirect comparisons carry the largest structural caveat in this project; the RPSFT-adjusted sensitivity analysis is essential; and adjusted estimates produced by different methods in different trials are not necessarily comparable with each other.
- *CRR (unaffected by switching):* response is assessed before any treatment switching, so crossover does not touch it. This is a further reason — beyond the harmonized Lugano definition — for CRR as the primary outcome.

**Named design differences** (presented in the transitivity table and discussed in the report):
- ZUMA-7 did not permit chemotherapy bridging therapy; TRANSFORM did.
- BELINDA had a materially higher proportion of patients progress before receiving CAR-T (25.9% by week 6, vs 13.8% in its own control arm) — widely cited as a mechanical reason that trial read null rather than a true absence of drug effect.
- TRANSFORM's 50/92 (54%) SOC-to-liso-cel crossover rate; BELINDA's protocol crossover; ZUMA-7's post-trial commercial CAR-T use — the three routes of SOC-arm contamination listed above.

### Assessment of Consistency
Not assessable in this network. Consistency — agreement between direct and indirect evidence — can only be evaluated where a closed loop exists, giving both direct and indirect evidence for the same comparison. This network is star-shaped: all three CAR-T therapies connect only through the shared standard-of-care comparator, with no direct CAR-T-versus-CAR-T trial, so no closed loop exists and node-splitting is not applicable. A practical consequence: there is no statistical check anywhere in this network on the transitivity assumption, so the qualitative transitivity assessment above is doing all the work.

### Treatment Ranking
P-scores (netmeta's frequentist analogue to SUCRA), interpreted alongside point estimates and confidence intervals rather than in isolation. Given the wide uncertainty expected from a three-trial star network, P-score rankings will be near-uninformative (overlapping confidence intervals across treatments). The report will use the following pre-specified framing, or wording very close to it:

> "P-scores are reported for completeness. Because the network consists of three trials connected only through a common comparator, all CAR-T–versus–CAR-T comparisons are entirely indirect with wide, overlapping confidence intervals; the P-score ordering therefore reflects point-estimate ordering rather than evidence of superiority, and no conclusion that one CAR-T product outranks another is warranted from these data."

### Sensitivity Analyses
Sensitivity analyses will be conducted, where applicable, to evaluate the robustness of the findings.

1. **Outcome re-analysis (ORR):** The primary NMA (CRR) will be re-run substituting ORR responders for CR responders, to confirm whether ranking and direction of effect hold across the two harmonized Lugano-criteria response outcomes.
2. **Follow-up duration:** Where multiple publications of the same trial are available (e.g., interim and updated analyses of TRANSFORM), the analysis based on the most mature follow-up will serve as the primary analysis, with earlier analyses evaluated in sensitivity analyses to assess the impact of follow-up duration on the estimated treatment effects.
3. **Crossover-adjusted overall survival:** A pre-specified sensitivity analysis will be conducted for OS using crossover-adjusted hazard ratios (where reported by trial investigators using methods such as RPSFT) in place of intention-to-treat estimates. This analysis aims to assess the impact of treatment switching from the standard-of-care arm to CAR-T therapy on the comparative effectiveness estimates. Crossover-adjusted estimates will not be incorporated into the primary NMA due to potential heterogeneity in adjustment methods across trials.
4. **Assumed heterogeneity (τ²):** The primary NMA (CRR) and the key secondary OS NMA will be re-run under an assumed moderate between-study heterogeneity, taken from published empirical distributions for the relevant outcome type (Turner et al. 2012; Rhodes et al. 2015) and imposed in netmeta via the `tau.preset` argument. Purpose: since τ² cannot be estimated from three single-trial edges, this shows whether any conclusion would change if real heterogeneity of a plausible size were present.

Any additional sensitivity analyses will be undertaken only if sufficient data are available and will be reported transparently.

## Confidence in the Evidence
Assessed qualitatively using the CINeMA framework [Nikolakopoulou et al., 2020] across five domains — within-study bias, indirectness, imprecision, heterogeneity, and incoherence each rated High/Moderate/Low/Very low with a brief justification, rather than using the formal CINeMA web application. Note that the qualitative version forfeits CINeMA's contribution-weighted within-study-bias step (in which RoB judgments are weighted by each trial's contribution to the network); in a star network with equal per-edge contributions this loss is minor, but the limitation is acknowledged rather than implying full equivalence with the formal tool.

**Pre-specified threshold for the imprecision domain:** so that "imprecise" means something specific rather than a vibe, a clinically meaningful effect is defined in advance as an odds ratio of 1.25 for dichotomous outcomes and a hazard ratio of 0.80 for time-to-event outcomes. Confidence intervals will be judged against these thresholds when rating imprecision.

## Reporting Standard
The final report will conform to the PRISMA extension for network meta-analyses (PRISMA-NMA; Hutton et al., Ann Intern Med 2015). The completed PRISMA-NMA checklist will be included as a supplement, and a PRISMA 2020 flow diagram will report study identification and selection.

## Reproducibility
Analyses will be conducted in R, with package versions locked via `renv::snapshot()` and the resulting lockfile committed to the repository. The R version and `netmeta` version used for the final analysis will be reported in the final report. All analysis scripts will be numbered and version-controlled in the project repository. The protocol itself is version-controlled: v1.0 is frozen, all changes live in `amendments_log.md`, and any change made after data extraction begins will be flagged as post-hoc.

## References
References will be managed using the references.bib bibliography file
