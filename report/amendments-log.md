# Amendments log

Changes to the protocol after the first version was written. Anything that changes a
decision after the data extraction started is marked **post hoc** and has to be
reported as such.

## 2026-11-13, review corrections

A line-by-line check of the protocol, results summary, references and outputs against
the trial publications found several wording and citation errors. The R pipeline was
re-run from a clean copy and every result table reproduced exactly, so none of these
corrections changes a number or a model. Most are wording corrections; item 8 corrects
the interpretation of an existing output. They are listed here because the protocol's
reported claims should match what the analysis actually shows.

1. **ORR P-score claim.** The results summary said the ORR P-score order was the same
   as for CRR. It is not: liso-cel is first for ORR (0.926 versus axi-cel 0.741),
   while axi-cel is first for CRR (0.851 versus liso-cel 0.816). The text now reports
   the swap and repeats that the axi-cel versus liso-cel interval includes 1, so this
   is not evidence of superiority.

2. **TRANSFORM crossover.** The summary said 67% of TRANSFORM's standard-care arm
   "crossed over". The correct description is that 61 of 92 (66%) were approved for
   crossover and 57 (62%) had received liso-cel by the 3-year update; the primary
   analysis reported 63%, and the interim analysis 50/92 (54%). The protocol and
   results summary now use this wording.

3. **SA2 description.** The protocol said the earliest TRANSFORM readout was the
   Kamdar 2022 interim analysis. The analysis actually uses the Abramson 2023 primary
   analysis as the earliest readout and Kamdar 2025 as the mature readout. The
   protocol now matches the analysis and states that the interim report is
   superseded.

4. **Reference DOI.** The Abramson 2023 *Blood* DOI was wrong
   (`10.1182/blood.2022018176`); it is corrected to
   `10.1182/blood.2022018730`. The Hutton 2015 PRISMA-NMA reference was missing and
   has been added.

5. **Follow-up and region wording.** "Beyond four years" and "three years" were
   replaced with the actual median follow-up (47.2, 33.9 and 10 months). The claim
   that BELINDA enrolled "heavily in Asia and Australia, unlike the other two" was
   too strong and is replaced with the actual country mix, including the Australian
   and Israeli sites in ZUMA-7 and the Japanese sites in TRANSFORM.

6. **Safety comparator.** The ZUMA-7 standard-care arm reports treatment-emergent
   neurologic events, not ICANS. The results summary now says so next to the ICANS
   odds ratios.

7. **Documentation gaps disclosed.** The protocol previously promised that the
   executed search string and date would be added, and that a completed PRISMA-NMA
   checklist would be a supplement. Neither exists in the repository. The protocol
   now records both as limitations instead of implying they are complete. The PRISMA
   flow diagram is still an incompletely populated template and is flagged as such.
   The planned double-extraction, blind re-screen and second full-text pass are also
   not documented as completed in the repository.

8. **Assumed-heterogeneity interpretation.** The results summary said that no
   conclusion changed under SA4. The point estimates do hold, but the axi-cel OS
   interval widens from 0.54 to 0.98 to 0.45 to 1.19 and now includes 1. The text now
   says that the CRR conclusions are unchanged while the OS signal is not robust to a
   moderate assumed tau-squared. No model or estimate changed; this corrects the
   interpretation of an existing output.

9. **Post-cut-off TRANSFORM report.** A 2026 TRANSFORM long-term follow-up brief
   report (Blood Advances, DOI `10.1182/bloodadvances.2025019303`) was added to the
   references and noted in the protocol and results summary. It reports 48-month OS
   and PFS in the selected long-term-follow-up subset and no new hazard ratio, so it
   does not change the analysis. The note exists so that the declared cut-off is not
   mistaken for an absence of later data.

10. **Code hardening.** Four code-level issues found in the same review are fixed:
    the binary NMA sets the zero-cell correction explicitly (`incr = 0.5`,
    `allstudies = TRUE`) instead of relying on defaults; sensitivity 3 asserts that
    there is exactly one adjusted row per trial; the extraction check asserts that
    every expected trial and outcome has a primary row; and a stale comment in the
    RoB 2 script still described TRANSFORM as "67% crossed over". The pipeline was
    re-run afterwards and all 38 result tables were byte-identical, so these are
    safeguards and documentation only, not changes to any estimate.

## 2026-11-10, protocol v1.1

1. **Response readout.** The protocol said to extract every outcome at the longest
   follow-up. That is right for survival outcomes but it makes no sense for CRR and
   ORR, because response rates do not change once they have been reported. The text
   now says that CRR, ORR and safety come from the primary analysis of each trial.
   Not post hoc: the numbers were already taken from the primary analyses, so this
   only corrects the wording. No data changed.

2. **TRANSFORM crossover.** The protocol quoted 50/92 (54%) from the interim
   analysis. At the primary analysis, which is the base case here, 61 of 91 treated
   patients in the SOC arm had crossed over (67%). Both numbers are now given, with
   the primary analysis used in the text. No data changed. (The denominator and the
   wording are superseded by the 2026-11-13 entry below: 61 of 92 were approved for
   crossover, and 57 had received liso-cel by the 3-year update.)

3. **CINeMA domains.** Heterogeneity and incoherence are now recorded as "not
   assessable" rather than given a rating. The earlier draft rated them Low or
   Moderate, which implied the domains had been checked. With one trial per
   comparison and no closed loop they cannot be checked, and the protocol already
   said so in the analysis section, so this makes the two sections agree.

4. **References.** The BELINDA citation was wrong (it pointed to a Lancet Oncology
   volume that is not the BELINDA paper) and the TRANSFORM primary citation was
   attributed to the wrong first author and the wrong journal. The Lancet 2022
   TRANSFORM paper is the interim analysis by Kamdar and colleagues; the primary
   analysis is Abramson 2023 in Blood. Two background references did not resolve and
   have been replaced with a review that does. This is a correction, not a change of
   plan.

5. **File paths.** The protocol pointed to two files that did not exist
   (`protocol/search_strategy.md` and `amendments_log.md`). The search string and
   its execution date now go into the protocol itself, and this log lives in
   `report/`.

6. **Safety scope.** SAEs and grade 3 or above AEs are still listed as aggregate
   safety outcomes, but they were never extracted, and the results now say so
   instead of leaving the reader to notice the gap.
