# 04_nma_response.R
# Response network meta-analysis, odds ratio scale, common effect model.
#   CRR = primary outcome
#   ORR = key secondary / sensitivity analysis 1
# Both are also re-run with an assumed tau (sensitivity analysis 4).
# Reference treatment is standard of care.
# Run from the repo root: Rscript R/04_nma_response.R

library(tidyverse)
library(netmeta)

dir.create("results/tables",  showWarnings = FALSE, recursive = TRUE)
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)


# ------------------------------------------------------------------
# 1. load and recode treatment names
# ------------------------------------------------------------------

treat_map <- c("Axicabtagene ciloleucel"     = "axi-cel",
               "Lisocabtagene maraleucel"    = "liso-cel",
               "Tisagenlecleucel"            = "tisa-cel",
               "Standard of care"            = "SOC",
               "Standard care"               = "SOC")

binary <- read_csv("data/binary-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome),
         treat   = treat_map[treatment]) %>%
  select(trial_id, outcome, treat, events, n)

stopifnot(!any(is.na(binary$treat)))


# ------------------------------------------------------------------
# 2. one function per outcome
# ------------------------------------------------------------------

run_binary_nma <- function(outcome_label, tau_assumed = NULL) {

  dat <- filter(binary, outcome == outcome_label)

  # pairwise() is only used here to turn the arm level data into the
  # contrast format netmeta wants. It is not doing any pooling.
  pw <- pairwise(treat      = treat,
                 event      = events,
                 n          = n,
                 studlab    = trial_id,
                 data       = dat,
                 sm         = "OR",
                 incr       = 0.5,
                 allstudies = TRUE)

  args <- list(TE = pw$TE, seTE = pw$seTE, treat1 = pw$treat1,
               treat2 = pw$treat2, studlab = pw$studlab,
               sm = "OR", common = TRUE, random = FALSE,
               reference.group = "SOC")
  net <- do.call(netmeta, args)

  # there is one trial per comparison, so the network estimates have to come
  # back out as exactly the trial 2x2. If they do not, the data are wrong.
  for (tr in unique(dat$trial_id)) {
    d  <- dat[dat$trial_id == tr, ]
    ct <- d[d$treat != "SOC", ]
    so <- d[d$treat == "SOC", ]
    or_trial <- (ct$events / (ct$n - ct$events)) /
                (so$events / (so$n - so$events))
    stopifnot(abs(net$TE.common[ct$treat, "SOC"] - log(or_trial)) < 1e-8)
  }
  cat("  check: network estimates reproduce the trial ORs\n")

  # netmeta stores TE.common[i, j] as treatment i against treatment j, so
  # reading the SOC column gives every treatment against the reference
  trts_vs_ref <- setdiff(net$trts, "SOC")
  ors <- data.frame(
    comparison = paste(trts_vs_ref, "vs SOC"),
    OR         = round(exp(net$TE.common[trts_vs_ref, "SOC"]), 3),
    lo         = round(exp(net$lower.common[trts_vs_ref, "SOC"]), 3),
    hi         = round(exp(net$upper.common[trts_vs_ref, "SOC"]), 3)
  )
  write_csv(ors, paste0("results/tables/nma_", outcome_label, "_vs_soc.csv"))

  # OR above 1 is good here, so small values are the bad ones
  nr <- netrank(net, small.values = "undesirable")

  league <- netleague(net, digits = 3, seq = nr)
  write_csv(as.data.frame(league$common) %>% rownames_to_column("treatment"),
            paste0("results/tables/nma_", outcome_label, "_league.csv"))

  pscores <- data.frame(treatment = names(nr$ranking.common),
                        p_score   = round(unname(nr$ranking.common), 3))
  write_csv(pscores, paste0("results/tables/nma_", outcome_label, "_pscores.csv"))

  png(paste0("results/figures/network_", outcome_label, ".png"),
      width = 900, height = 700, res = 110)
  netgraph(net, plastic = FALSE, thickness = "number.of.studies",
           number.of.studies = TRUE, points = TRUE, cex.points = 3,
           main = paste0("Network: ", toupper(outcome_label)))
  dev.off()

  png(paste0("results/figures/forest_", outcome_label, "_vs_soc.png"),
      width = 1000, height = 600, res = 110)
  forest(net, reference.group = "SOC",
         smlab = paste0("Common effect NMA: ", toupper(outcome_label),
                        "\nOdds ratio vs SOC (>1 favours CAR-T)"))
  dev.off()

  # sensitivity analysis 4: assume some heterogeneity and see if it changes much
  if (!is.null(tau_assumed)) {
    re_args <- args
    re_args$random     <- TRUE
    re_args$tau.preset <- tau_assumed
    net_re <- do.call(netmeta, re_args)

    trts_re <- setdiff(net_re$trts, "SOC")
    ors_re <- data.frame(
      comparison = paste(trts_re, "vs SOC"),
      OR         = round(exp(net_re$TE.random[trts_re, "SOC"]), 3),
      lo         = round(exp(net_re$lower.random[trts_re, "SOC"]), 3),
      hi         = round(exp(net_re$upper.random[trts_re, "SOC"]), 3)
    )
    write_csv(ors_re, paste0("results/tables/nma_", outcome_label,
                             "_vs_soc_tau_assumed.csv"))
    cat("  sensitivity with tau =", tau_assumed, "written\n")
  }

  invisible(net)
}


# ------------------------------------------------------------------
# 3. run
# tau = 0.3 on the log OR scale is roughly "moderate" for this kind of outcome
# ------------------------------------------------------------------

cat("== primary: CRR ==\n")
net_crr <- run_binary_nma("crr", tau_assumed = 0.3)
print(net_crr, reference.group = "SOC", digits = 3)

cat("\n== key secondary / sensitivity 1: ORR ==\n")
net_orr <- run_binary_nma("orr", tau_assumed = 0.3)
print(net_orr, reference.group = "SOC", digits = 3)

cat("\ndone. tables in results/tables, figures in results/figures\n")
cat("remember: the P-scores only order the point estimates. Every CAR-T vs CAR-T\n")
cat("comparison is indirect and the confidence intervals overlap, so this is not\n")
cat("evidence that one product is better than another.\n")
