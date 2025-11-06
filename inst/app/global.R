# Global configuration and library loading for PUDUApp
library(shiny)
# Allow larger uploads: set max request size to 30 MB (30 * 1024^2 bytes)
# Place here so it applies to the whole app (UI + server)
options(shiny.maxRequestSize = 30 * 1024^2)
library(plotly)
library(bslib)
library(ggplot2)
library(dplyr)
library(data.table)
library(phyloseq)
library(microbiome)
library(UpSetR)
library(DT)
library(ggrepel)
library(vegan)

TAX_RANK_MAP <- c("G"="Genus", "P"="Phylum", "F"="Family", "C"="Class", 
                  "O"="Order", "S"="Species", "U"="Unclassified", 
                  "D"="Domain", "R"="Root", "K"="Kingdom")

REAL_TAX_ORDER <- c("Domain", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

MIN_SAMPLES_BETA <- 3

source_helper <- function(type, filename) {
    # Try installed package first
    path <- system.file(type, filename, package = "puduapp")
    if (nzchar(path)) {
        source(path, local = FALSE)
        return(invisible(TRUE))
    }

    if (exists("PUDUAPP_LOCAL_APP_DIR", envir = .GlobalEnv)) {
        local_base <- get("PUDUAPP_LOCAL_APP_DIR", envir = .GlobalEnv)
        candidate <- file.path(local_base, "helpers", filename)
        if (file.exists(candidate)) {
            source(candidate, local = FALSE)
            return(invisible(TRUE))
        }
        candidate2 <- file.path(local_base, "modules", filename)
        if (file.exists(candidate2)) {
            source(candidate2, local = FALSE)
            return(invisible(TRUE))
        }
    }

    find_in_parent_inst <- function(start = getwd(), type, filename) {
        cur <- normalizePath(start, winslash = "/", mustWork = FALSE)
        while (TRUE) {
            candidate <- file.path(cur, "inst", type, filename)
            if (file.exists(candidate)) return(candidate)
            parent <- dirname(cur)
            if (identical(parent, cur) || parent == "" ) break
            cur <- parent
        }
        return(NULL)
    }

    dev_candidate <- find_in_parent_inst(getwd(), type, filename)
    if (!is.null(dev_candidate)) {
        source(dev_candidate, local = FALSE)
        return(invisible(TRUE))
    }

    stop(sprintf("Could not find helper file '%s' under type '%s' (tried package, local app, and inst paths)", filename, type))
}

source_helper("helpers", "ui_constants.R")
source_helper("helpers", "error_handling.R")
source_helper("helpers", "notifications.R")
source_helper("helpers", "validation.R")
source_helper("helpers", "processing.R")
source_helper("helpers", "plots.R")
source_helper("helpers", "downloads.R")
source_helper("helpers", "ui_enhancements.R")
source_helper("modules", "file_upload_mod.R")