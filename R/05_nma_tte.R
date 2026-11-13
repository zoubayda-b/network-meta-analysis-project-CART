# 05_nma_tte.R
# Time to event network meta-analysis, hazard ratio scale, common effect model.
#   OS  = key secondary, intention to treat, most mature follow-up
#   EFS = exploratory (the three trials define an EFS event differently)
#   PFS = exploratory (BELINDA does not report it, so it is not in the network)
#   sensitivity 2: earliest readout instead of the most mature one
#   sensitivity 3: crossover adjusted OS
#   sensitivity 4: assumed tau of 0.2 on the log HR scale
# Run from the repo root: Rscript R/05_nma_tte.R

library(tidyverse)
library(netmeta)

dir.create("results/tables",  showWarnings = FALSE, recursive = TRUE)
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)

tte <- read_csv("data/time-to-event-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome))

treat_map <- c("axi_cel" = "axi-cel", "liso_cel" = "liso-cel",
               "tisa_cel" = "tisa-cel")


# ------------------------------------------------------------------
# which publication counts as the primary source for each trial
# ------------------------------------------------------------------

mature   <- c("ZUMA-7" = "Westin 2023", "TRANSFORM" = "Kamdar 2025",
              "BELINDA" = "Bishop 2022")
earliest <- c("ZUMA-7" = "Locke 2022", "TRANSFORM" = "Abramson 2023",
              "BELINDA" = "Bishop 2022")

pick_rows <- function(source_map, estimands) {
  tte %>%
    filter(str_detect(source, source_map[trial_id])) %>%
    filter(is.na(estimand) | estimand %in% estimands)
}

sets <- list(
  primary_os   = pick_rows(mature,   "itt") %>% filter(outcome == "os"),
  primary_efs  = pick_rows(mature,   "itt") %>% filter(outcome == "efs"),
  primary_pfs  = pick_rows(mature,   "itt") %>% filter(outcome == "pfs"),
  sens2_os     = pick_rows(earliest, "itt") %>% filter(outcome == "os"),
  sens2_efs    = pick_rows(earliest, "itt") %>% filter(outcome == "efs"),
  sens3_os_adj = tte %>%
    filter(outcome == "os",
           estimand %in% c("rpsft_adjusted", "covariate_adjusted"))
)

stopifnot(all(vapply(sets, nrow, integer(1)) > 0))

# sensitivity 3 must contribute exactly one adjusted row per trial. Two rows for
# the same trial would silently enter the network as separate studies.
sens3_per_trial <- sets$sens3_os_adj %>%
  count(trial_id) %>%
  pull(n)
stopifnot(all(sens3_per_trial == 1))


# ------------------------------------------------------------------
# the analysis itself
# ------------------------------------------------------------------

run_tte_nma <- function(dat, label, tau_assumed = NULL) {

  dat <- dat %>%
    mutate(TE     = log(hr),
           seTE   = (log(hr_upper) - log(hr_lower)) / (2 * qnorm(0.975)),
           treat1 = treat_map[treatment_arm],
           treat2 = "SOC")

  args <- list(TE = dat$TE, seTE = dat$seTE, treat1 = dat$treat1,
               treat2 = dat$treat2, studlab = dat$trial_id,
               sm = "HR", common = TRUE, random = FALSE,
               reference.group = "SOC")
  net <- do.call(netmeta, args)

  # one trial per comparison, so the network estimates must equal the inputs
  for (i in seq_len(nrow(dat))) {
    stopifnot(abs(net$TE.common[dat$treat1[i], "SOC"] - dat$TE[i]) < 1e-8)
  }
  cat("  check: network estimates reproduce the trial HRs\n")

  # TE.common[i, j] is treatment i against treatment j, so the SOC column gives
  # every treatment against the reference
  trts_vs_ref <- setdiff(net$trts, "SOC")
  hrs <- data.frame(
    comparison = paste(trts_vs_ref, "vs SOC"),
    HR         = round(exp(net$TE.common[trts_vs_ref, "SOC"]), 3),
    lo         = round(exp(net$lower.common[trts_vs_ref, "SOC"]), 3),
    hi         = round(exp(net$upper.common[trts_vs_ref, "SOC"]), 3)
  )
  write_csv(hrs, paste0("results/tables/nma_", label, "_vs_soc.csv"))

  # a hazard ratio below 1 is good here, so small values are the desirable ones
  nr <- netrank(net, small.values = "desirable")

  league <- netleague(net, digits = 3, seq = nr)
  write_csv(as.data.frame(league$common) %>% rownames_to_column("treatment"),
            paste0("results/tables/nma_", label, "_league.csv"))

  pscores <- data.frame(treatment = names(nr$ranking.common),
                        p_score   = round(unname(nr$ranking.common), 3))
  write_csv(pscores, paste0("results/tables/nma_", label, "_pscores.csv"))

  png(paste0("results/figures/forest_", label, "_vs_soc.png"),
      width = 1000, height = 600, res = 110)
  forest(net, reference.group = "SOC",
         smlab = paste0(label, "\nhazard ratio vs SOC (<1 favours CAR-T)"))
  dev.off()

  if (!is.null(tau_assumed)) {
    re_args <- args
    re_args$random     <- TRUE
    re_args$tau.preset <- tau_assumed
    net_re <- do.call(netmeta, re_args)

    trts_re <- setdiff(net_re$trts, "SOC")
    hrs_re <- data.frame(
      comparison = paste(trts_re, "vs SOC"),
      HR         = round(exp(net_re$TE.random[trts_re, "SOC"]), 3),
      lo         = round(exp(net_re$lower.random[trts_re, "SOC"]), 3),
      hi         = round(exp(net_re$upper.random[trts_re, "SOC"]), 3)
    )
    write_csv(hrs_re, paste0("results/tables/nma_", label, "_vs_soc_tau_assumed.csv"))
  }

  invisible(net)
}


# ------------------------------------------------------------------
# run
# ------------------------------------------------------------------

cat("== key secondary: OS (ITT, most mature follow-up) ==\n")
net_os <- run_tte_nma(sets$primary_os, "os", tau_assumed = 0.2)
print(net_os, reference.group = "SOC", digits = 3)

cat("\n== exploratory: EFS (definitions are not harmonised) ==\n")
net_efs <- run_tte_nma(sets$primary_efs, "efs_exploratory", tau_assumed = 0.2)
print(net_efs, reference.group = "SOC", digits = 3)

cat("\n== exploratory: PFS (BELINDA not reported) ==\n")
net_pfs <- run_tte_nma(sets$primary_pfs, "pfs_exploratory")
print(net_pfs, reference.group = "SOC", digits = 3)

cat("\n== sensitivity 2: earliest readout per trial ==\n")
run_tte_nma(sets$sens2_os,  "os_sens2_earliest_readout")
run_tte_nma(sets$sens2_efs, "efs_sens2_earliest_readout")

cat("\n== sensitivity 3: crossover adjusted OS ==\n")
cat("   ZUMA-7 RPSFT 0.58 | TRANSFORM adjusted 0.335 | BELINDA covariate adjusted 0.99\n")
cat("   the BELINDA estimate is not a crossover adjustment, so it is only there\n")
cat("   to show what the trial reported and should not be read the same way\n")
run_tte_nma(sets$sens3_os_adj, "os_sens3_crossover_adjusted")

cat("\ndone. a hazard ratio below 1 favours CAR-T.\n")
