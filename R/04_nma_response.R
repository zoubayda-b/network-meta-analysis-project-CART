# ==============================================================================
# 04_nma_response.R
# ------------------------------------------------------------------------------
# PRIMARY NMA: complete response rate (CRR), odds ratio scale, common-effect.
# KEY SECONDARY / SENSITIVITY 1: ORR re-analysis (protocol Sensitivity Analysis 1).
# SENSITIVITY 4 (binary): assumed moderate heterogeneity via tau.preset
#   (tau cannot be estimated from 3 single-trial edges; assumed tau = 0.3 on the
#    log-OR scale, moderate by Turner 2012 / Rhodes 2015 empirical distributions).
# Per AGENTS.md: reference = SOC; pairwise() only reshapes; no node-splitting;
# common-effect only as primary. P-scores reported with the protocol's caveat.
# Run from repo root: Rscript R/04_nma_response.R
# ==============================================================================

library(tidyverse)
library(netmeta)

dir.create("results/tables",  showWarnings = FALSE, recursive = TRUE)
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------------------------
# 1. Load + harmonize labels (single documented recode location)
# ------------------------------------------------------------------------------
treat_map <- c("Axicabtagene ciloleucel"               = "axi-cel",
               "Lisocabtagene maraleucel (liso-cel)"   = "liso-cel",
               "Tisagenlecleucel (tisa-cel)"           = "tisa-cel",
               "Standard care"                         = "SOC",
               "Standard of care"                      = "SOC")

binary <- read_csv("data/binary-data.csv", show_col_types = FALSE) %>%
  mutate(outcome = tolower(outcome),
         treat   = treat_map[treatment]) %>%
  select(trial_id, outcome, treat, events, n)

stopifnot(!any(is.na(binary$treat)))

# ------------------------------------------------------------------------------
# 2. Analysis function (one per outcome)
# ------------------------------------------------------------------------------
run_binary_nma <- function(outcome_label, tau_assumed = NULL) {

  dat <- binary %>% filter(outcome == outcome_label)

  pw <- pairwise(treat   = treat,
                 event   = events,
                 n       = n,
                 studlab = trial_id,
                 data    = dat,
                 sm      = "OR")

  common_args <- list(TE = pw$TE, seTE = pw$seTE, treat1 = pw$treat1,
                      treat2 = pw$treat2, studlab = pw$studlab,
                      sm = "OR", common = TRUE, random = FALSE,
                      reference.group = "SOC",
                      details.chkmultiarm = FALSE)
  net <- do.call(netmeta, common_args)

  # --- Protocol validation: NMA direct estimates must reproduce trial inputs ---
  direct <- as.data.frame(net$TE.direct.common)
  for (tr in unique(dat$trial_id)) {
    cart <- dat$treat[dat$trial_id == tr & dat$treat != "SOC"]
    d    <- dat[dat$trial_id == tr, ]
    or_in <- (d$events[d$treat == cart] / (d$n[d$treat == cart] - d$events[d$treat == cart])) /
             (d$events[d$treat == "SOC"] / (d$n[d$treat == "SOC"] - d$events[d$treat == "SOC"]))
    stopifnot(abs(direct[cart, "SOC"] - log(or_in)) < 1e-8)
  }
  cat("  validation: NMA reproduces trial-level ORs exactly — OK\n")

  # --- Tables ---
  # netmeta 3.x: TE.common[i, j] = effect of row treatment i vs column j.
  # Use the MATRIX (not TE.nma.common, whose alphabetical-pair ordering flips
  # signs for treatments alphabetically after the reference) and verify each
  # tabled value against the trial input — the sign must match by construction.
  trts_vs_ref <- setdiff(net$trts, "SOC")
  ors <- data.frame(
    comparison = paste(trts_vs_ref, "vs SOC"),
    OR         = round(exp(net$TE.common[trts_vs_ref, "SOC"]), 3),
    lo         = round(exp(net$lower.common[trts_vs_ref, "SOC"]), 3),
    hi         = round(exp(net$upper.common[trts_vs_ref, "SOC"]), 3)
  )
  for (tr in unique(dat$trial_id)) {
    cart <- dat$treat[dat$trial_id == tr & dat$treat != "SOC"]
    d    <- dat[dat$trial_id == tr, ]
    or_in <- (d$events[d$treat == cart] / (d$n[d$treat == cart] - d$events[d$treat == cart])) /
             (d$events[d$treat == "SOC"] / (d$n[d$treat == "SOC"] - d$events[d$treat == "SOC"]))
    stopifnot(abs(ors$OR[ors$comparison == paste(cart, "vs SOC")] -
                    round(or_in, 3)) < 0.002)
  }
  cat("  validation: tabled ORs match trial inputs (sign checked) — OK\n")
  write_csv(ors, paste0("results/tables/nma_", outcome_label, "_vs_soc.csv"))

  nr <- netrank(net, small.values = "undesirable")
  league <- netleague(net, digits = 3, seq = nr)
  write_csv(as.data.frame(league$common) %>% rownames_to_column("treatment"),
            paste0("results/tables/nma_", outcome_label, "_league.csv"))

  pscores <- data.frame(treatment = names(nr$ranking.common),
                        p_score   = round(unname(nr$ranking.common), 3))
  write_csv(pscores, paste0("results/tables/nma_", outcome_label, "_pscores.csv"))

  # --- Figures ---
  png(paste0("results/figures/network_", outcome_label, ".png"), width = 900, height = 700, res = 110)
  netgraph(net, plastic = FALSE, thickness = "number.of.studies",
           number.of.studies = TRUE, points = TRUE, cex.points = 3,
           main = paste0("Network: ", toupper(outcome_label)))
  dev.off()

  png(paste0("results/figures/forest_", outcome_label, "_vs_soc.png"), width = 1000, height = 600, res = 110)
  forest(net, reference.group = "SOC",
         smlab = paste0("Common-effect NMA: ", toupper(outcome_label),
                        "\nOdds ratio vs SOC (>1 favors CAR-T)"))
  dev.off()

  # --- Sensitivity 4: assumed heterogeneity (only if requested) ---
  if (!is.null(tau_assumed)) {
    re_args <- common_args
    re_args$random     <- TRUE
    re_args$tau.preset <- tau_assumed
    net_re <- do.call(netmeta, re_args)
    trts_re  <- setdiff(net_re$trts, "SOC")
    ors_re <- data.frame(
      comparison = paste(trts_re, "vs SOC"),
      OR         = round(exp(net_re$TE.random[trts_re, "SOC"]), 3),
      lo         = round(exp(net_re$lower.random[trts_re, "SOC"]), 3),
      hi         = round(exp(net_re$upper.random[trts_re, "SOC"]), 3)
    )
    write_csv(ors_re, paste0("results/tables/nma_", outcome_label,
                             "_vs_soc_tau_assumed.csv"))
    cat("  sensitivity (assumed tau =", tau_assumed, "): results written\n")
  }

  invisible(net)
}

# ------------------------------------------------------------------------------
# 3. Run: CRR primary, ORR confirmatory companion (Sensitivity Analysis 1),
#    both also under assumed tau = 0.3 (Sensitivity Analysis 4)
# ------------------------------------------------------------------------------
cat("== PRIMARY: CRR ==\n")
net_crr <- run_binary_nma("crr", tau_assumed = 0.3)
print(net_crr, reference.group = "SOC", digits = 3)

cat("\n== KEY SECONDARY (Sensitivity 1): ORR ==\n")
net_orr <- run_binary_nma("orr", tau_assumed = 0.3)
print(net_orr, reference.group = "SOC", digits = 3)

cat("\nDone. Tables in results/tables/, figures in results/figures/\n")
cat("REMINDER: P-score ordering reflects point-estimate ordering only; all CAR-T vs\n")
cat("CAR-T comparisons are entirely indirect with wide overlapping CIs (protocol framing).\n")
