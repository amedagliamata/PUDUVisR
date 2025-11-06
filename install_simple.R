cat("=== Simple PUDUApp Installation ===\n\n")
cat("R version:", R.version.string, "\n")
cat("Platform:", R.version$platform, "\n\n")

cat("Step 1: Installing BiocManager...\n")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cran.rstudio.com/")
}

cat("Step 2: Installing CRAN packages...\n")
cran_packages <- c(
  "shiny", "plotly", "bslib", "ggplot2", "dplyr", 
  "data.table", "UpSetR", "DT", "ggrepel", "vegan", "devtools"
)

for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    install.packages(pkg, repos = "https://cran.rstudio.com/")
  }
}

cat("Step 3: Setting up Bioconductor...\n")
r_version <- getRversion()

if (Sys.info()["sysname"] == "Darwin" && Sys.info()["machine"] == "arm64") {
  cat("Configuring repositories for macOS ARM64...\n")
  options(repos = c(
    CRAN = "https://cran.rstudio.com/",
    BioCsoft = "https://bioconductor.org/packages/release/bioc",
    BioCann = "https://bioconductor.org/packages/release/data/annotation",
    BioCexp = "https://bioconductor.org/packages/release/data/experiment"
  ))
}

tryCatch({
  BiocManager::install(ask = FALSE, update = FALSE)
}, warning = function(w) {
  cat("Warning during Bioconductor setup (this is usually fine):", w$message, "\n")
}, error = function(e) {
  cat("Error during Bioconductor setup:", e$message, "\n")
  cat("Continuing with package installation...\n")
})

cat("Step 4: Installing Bioconductor core dependencies...\n")
core_deps <- c(
  "BiocGenerics", "S4Vectors", "IRanges", "GenomeInfoDb", 
  "GenomeInfoDbData", "Biostrings", "XVector"
)

for (pkg in core_deps) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    tryCatch({
      BiocManager::install(pkg, ask = FALSE, update = FALSE)
    }, warning = function(w) {
      cat("Warning for", pkg, "(continuing):", w$message, "\n")
    }, error = function(e) {
      cat("Error for", pkg, ", trying from source...\n")
      BiocManager::install(pkg, ask = FALSE, update = FALSE, type = "source")
    })
    Sys.sleep(1)
  }
}

cat("Step 5: Installing phyloseq dependencies...\n")
phyloseq_deps <- c("Biobase", "biomformat", "multtest")
for (pkg in phyloseq_deps) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    tryCatch({
      BiocManager::install(pkg, ask = FALSE, update = FALSE)
    }, warning = function(w) {
      cat("Warning for", pkg, "(continuing):", w$message, "\n")
    }, error = function(e) {
      cat("Error for", pkg, ", trying from source...\n")
      BiocManager::install(pkg, ask = FALSE, update = FALSE, type = "source")
    })
    Sys.sleep(1)
  }
}

cat("Step 6: Installing phyloseq and microbiome...\n")

cat("Installing phyloseq...\n")
tryCatch({
  BiocManager::install("phyloseq", ask = FALSE, update = FALSE)
}, warning = function(w) {
  cat("Warning for phyloseq (continuing):", w$message, "\n")
}, error = function(e) {
  cat("Error for phyloseq, trying from source...\n")
  BiocManager::install("phyloseq", ask = FALSE, update = FALSE, type = "source")
})
Sys.sleep(2)

cat("Installing microbiome...\n")
tryCatch({
  BiocManager::install("microbiome", ask = FALSE, update = FALSE)
}, warning = function(w) {
  cat("Warning for microbiome (continuing):", w$message, "\n")
}, error = function(e) {
  cat("Error for microbiome, trying from source...\n")
  BiocManager::install("microbiome", ask = FALSE, update = FALSE, type = "source")
})

cat("Step 7: Testing package loading...\n")
test_packages <- c("phyloseq", "microbiome", "shiny", "ggplot2")
all_good <- TRUE

for (pkg in test_packages) {
  tryCatch({
    library(pkg, character.only = TRUE)
    cat(paste("✓", pkg, "loaded successfully\n"))
  }, error = function(e) {
    cat(paste("✗", pkg, "failed:", e$message, "\n"))
    all_good <<- FALSE
  })
}

if (!all_good) {
  cat("\nSome packages failed to load. Manual intervention may be required.\n")
  cat("Try this in a fresh R session:\n")
  cat("BiocManager::install(c('phyloseq', 'microbiome'), force = TRUE)\n")
  stop("Package loading test failed")
}

cat("Step 8: Installing PUDUApp...\n")
tryCatch({
  # Get the current directory
  current_dir <- if (interactive()) {
    tryCatch({
      dirname(rstudioapi::getActiveDocumentContext()$path)
    }, error = function(e) getwd())
  } else {
    getwd()
  }

  devtools::install_local(current_dir, force = TRUE, dependencies = FALSE, upgrade = "never")

}, error = function(e) {
  cat("PUDUApp installation failed:", e$message, "\n")
  cat("Try manually: devtools::install_local('.', dependencies = FALSE)\n")
})

cat("\n=== Installation Complete ===\n")
cat("If successful, run the app with:\n")
cat("library(puduapp)\n")
cat("run_app()\n")