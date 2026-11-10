# Amendments log

Changes to the protocol after the first version was written. Anything that changes a
decision after the data extraction started is marked **post hoc** and has to be
reported as such.

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
   the primary analysis used in the text. No data changed.

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
