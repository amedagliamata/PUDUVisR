
is_macos <- function() {
  Sys.info()["sysname"] == "Darwin"
}

install_system_deps <- function() {
  if (is_macos()) {
    cat("Checking system dependencies on macOS...\n")
    # Check if Homebrew is available
    if (system("which brew", ignore.stdout = TRUE, ignore.stderr = TRUE) != 0) {
      cat("Warning: Homebrew not found. Some system dependencies may need manual installation.\n")
    }
  }
}

setup_bioconductor <- function() {
  cat("Setting up Bioconductor...\n")

  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    cat("Installing BiocManager...\n")
    install.packages("BiocManager", repos = "https://cran.rstudio.com/")
  }

  if (packageVersion("BiocManager") < "1.30.0") {
    cat("Updating BiocManager...\n")
    install.packages("BiocManager", repos = "https://cran.rstudio.com/")
  }

  r_version <- getRversion()
  cat(paste("R version:", r_version, "\n"))

  if (r_version >= "4.4.0") {
    bioc_version <- "3.19"
  } else if (r_version >= "4.3.0") {
    bioc_version <- "3.18"
  } else {
    bioc_version <- "3.17"
  }

  cat(paste("Setting Bioconductor version to:", bioc_version, "\n"))

  tryCatch({
    BiocManager::install(version = bioc_version, ask = FALSE, update = FALSE, checkBuilt = TRUE)
  }, warning = function(w) {
    cat("Warning during Bioconductor setup:", w$message, "\n")
    cat("Continuing with installation...\n")
  }, error = function(e) {
    cat("Error during Bioconductor setup, trying alternative approach...\n")
    BiocManager::install(ask = FALSE, update = FALSE)
  })

  if (is_macos() && Sys.info()["machine"] == "arm64") {
    cat("Setting up repositories for macOS ARM64...\n")
    options(BioC_mirror = "https://bioconductor.org")
    options(repos = c(
      CRAN = "https://cran.rstudio.com/",
      BioCsoft = "https://bioconductor.org/packages/release/bioc",
      BioCann = "https://bioconductor.org/packages/release/data/annotation",
      BioCexp = "https://bioconductor.org/packages/release/data/experiment"
    ))
  }
}

install_bioc_core <- function() {
  cat("Installing Bioconductor core dependencies...\n")

  core_deps <- c(
    "BiocGenerics",
    "S4Vectors", 
    "IRanges",
    "GenomeInfoDb",
    "GenomeInfoDbData",
    "Biostrings",
    "XVector"
  )

  for (pkg in core_deps) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      cat(paste("Installing core dependency:", pkg, "...\n"))

      tryCatch({
        BiocManager::install(pkg, ask = FALSE, update = FALSE, checkBuilt = TRUE)
      }, warning = function(w) {
        cat("Warning for", pkg, ":", w$message, "\n")
        # Continue despite warnings
      }, error = function(e) {
        cat("Error installing", pkg, ", trying from source...\n")
        BiocManager::install(pkg, ask = FALSE, update = FALSE, type = "source")
      })
    }
  }
}

install_bioc_packages <- function() {
  cat("Installing Bioconductor packages...\n")

  install_bioc_core()

  bioc_packages <- c("phyloseq", "microbiome")

  for (pkg in bioc_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      cat(paste("Installing", pkg, "...\n"))

      success <- FALSE
      tryCatch({
        BiocManager::install(pkg, ask = FALSE, update = FALSE, checkBuilt = TRUE)
        if (requireNamespace(pkg, quietly = TRUE)) {
          success <- TRUE
          cat(paste("✓", pkg, "installed successfully\n"))
        }
      }, warning = function(w) {
        cat("Warning for", pkg, ":", w$message, "\n")
      }, error = function(e) {
        cat("Standard installation failed for", pkg, "\n")
      })

      if (!success) {
        cat(paste("Trying source installation for", pkg, "...\n"))
        tryCatch({
          BiocManager::install(pkg, ask = FALSE, update = FALSE, type = "source")
          if (requireNamespace(pkg, quietly = TRUE)) {
            success <- TRUE
            cat(paste("✓", pkg, "installed from source\n"))
          }
        }, error = function(e) {
          cat("Source installation failed for", pkg, "\n")
        })
      }
      if (!success) {
        cat(paste("Trying with dependencies for", pkg, "...\n"))
        tryCatch({
          BiocManager::install(pkg, ask = FALSE, update = FALSE, dependencies = TRUE)
          if (requireNamespace(pkg, quietly = TRUE)) {
            success <- TRUE
            cat(paste("✓", pkg, "installed with dependencies\n"))
          }
        }, error = function(e) {
          cat("Installation with dependencies failed for", pkg, "\n")
        })
      }
      if (!success) {
        cat(paste("✗ Failed to install", pkg, "- manual intervention may be required\n"))
      }
    } else {
      cat(paste("✓", pkg, "is already installed.\n"))
    }
  }
}

install_cran_packages <- function() {
  cat("Installing CRAN packages...\n")

  cran_packages <- c(
    "shiny", "plotly", "bslib", "ggplot2", "dplyr", 
    "data.table", "UpSetR", "DT", "ggrepel", "vegan"
  )

  for (pkg in cran_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      cat(paste("Installing", pkg, "...\n"))
      install.packages(pkg, repos = "https://cran.rstudio.com/")
    } else {
      cat(paste(pkg, "is already installed.\n"))
    }
  }
}

verify_dependencies <- function() {
  cat("Verifying dependencies...\n")

  required_packages <- c(
    "shiny", "plotly", "bslib", "ggplot2", "dplyr", 
    "data.table", "UpSetR", "DT", "ggrepel", "vegan",
    "phyloseq", "microbiome"
  )

  failed_packages <- c()

  for (pkg in required_packages) {
    tryCatch({
      library(pkg, character.only = TRUE)
      cat(paste("✓", pkg, "loaded successfully\n"))
    }, error = function(e) {
      cat(paste("✗", pkg, "failed to load:", e$message, "\n"))
      failed_packages <<- c(failed_packages, pkg)
    })
  }

  if (length(failed_packages) > 0) {
    cat("\nFailed packages:", paste(failed_packages, collapse = ", "), "\n")
    return(FALSE)
  }

  cat("All dependencies verified successfully!\n")
  return(TRUE)
}

install_puduapp <- function(path = ".") {
  cat("Installing PUDUApp...\n")

  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools", repos = "https://cran.rstudio.com/")
  }

  devtools::install_local(path, force = TRUE, dependencies = FALSE, upgrade = "never")

  cat("PUDUApp installation completed!\n")
}

install_all <- function(path = ".") {
  cat("=== Starting PUDUApp Installation ===\n\n")
  cat("R version:", R.version.string, "\n")
  cat("Platform:", R.version$platform, "\n\n")

  tryCatch({
    install_system_deps()
    cat("\n")
    setup_bioconductor()
    cat("\n")

    install_cran_packages()
    cat("\n")

    install_bioc_packages()
    cat("\n")

    if (!verify_dependencies()) {
      stop("Some dependencies failed to install properly")
    }
    cat("\n")

    install_puduapp(path)

    cat("\n=== Installation Summary ===\n")
    cat("✓ System dependencies checked\n")
    cat("✓ Bioconductor setup completed\n")
    cat("✓ CRAN packages installed\n")
    cat("✓ Bioconductor packages installed\n")
    cat("✓ All dependencies verified\n")
    cat("✓ PUDUApp installed successfully\n\n")

    cat("To run the app, use:\n")
    cat("library(puduapp)\n")
    cat("run_app()\n\n")

  }, error = function(e) {
    cat("\n=== Installation Failed ===\n")
    cat("Error:", e$message, "\n\n")

    cat("Manual installation steps:\n")
    cat("1. Install BiocManager:\n")
    cat("   install.packages('BiocManager')\n\n")

    cat("2. Install Bioconductor core:\n")
    cat("   BiocManager::install(c('BiocGenerics', 'S4Vectors', 'IRanges', 'GenomeInfoDb', 'GenomeInfoDbData'))\n\n")

    cat("3. Install phyloseq and microbiome:\n")
    cat("   BiocManager::install(c('phyloseq', 'microbiome'))\n\n")

    cat("4. Install CRAN packages:\n")
    cat("   install.packages(c('shiny', 'plotly', 'bslib', 'ggplot2', 'dplyr', 'data.table', 'UpSetR', 'DT', 'ggrepel', 'vegan'))\n\n")

    cat("5. Install PUDUApp:\n")
    cat("   devtools::install_local('.', dependencies = FALSE)\n\n")

    cat("If issues persist, try:\n")
    cat("- Updating R to the latest version\n")
    cat("- Installing Xcode command line tools (macOS): xcode-select --install\n")
    cat("- Clearing package cache: remove.packages() and reinstall\n")
  })
}

if (interactive()) {
  tryCatch({
    script_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
  }, error = function(e) {
    script_dir <- getwd()
  })

  install_all(script_dir)
} else {
  install_all(".")
}