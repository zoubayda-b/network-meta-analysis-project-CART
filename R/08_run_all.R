# ==============================================================================
# 08_run_all.R — full analysis pipeline, in protocol order
# Run from repo root: Rscript R/08_run_all.R
# ==============================================================================

scripts <- c("R/03_check_extraction.R",
             "R/04_nma_response.R",
             "R/05_nma_tte.R",
             "R/06_safety.R",
             "R/07_transitivity_rob_cinema.R")

for (s in scripts) {
  cat("\n", strrep("=", 70), "\n", "RUNNING: ", s, "\n", strrep("=", 70), "\n", sep = "")
  source(s)
  gc()
}

cat("\n", strrep("=", 70), "\nPIPELINE COMPLETE\n", strrep("=", 70), "\n", sep = "")
cat("R version:", R.version.string, "\n")
cat("netmeta version:", as.character(packageVersion("netmeta")), "\n")
cat("meta version:", as.character(packageVersion("meta")), "\n")
cat("robvis version:", as.character(packageVersion("robvis")), "\n")
