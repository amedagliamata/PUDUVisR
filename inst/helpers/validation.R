#' Validate Metadata Against File Names
#'
#' Checks if metadata contains a 'sample_name' column that matches the provided
#' file basenames. Ensures all files have corresponding metadata entries.
#'
#' @param metadata Data frame containing sample metadata
#' @param file_basenames Character vector of file base names to match
#' @return List with 'valid' (logical) and 'message' (character) components
#' @export
validateMetadataWithFileNames <- function(metadata, file_basenames) {
  # Validate inputs
  if (is.null(metadata) || nrow(metadata) == 0) {
    return(list(valid = FALSE, message = "Metadata file is empty or invalid"))
  }

  if (length(file_basenames) == 0) {
    return(list(valid = FALSE, message = "No file names provided for validation"))
  }

  found_col <- any(colnames(metadata) == "sample_name")

  if (!isTRUE(found_col)) {
    return(list(valid = FALSE, message = "Could not find a column in metadata that matches the file names"))
  }

  metadata_samples <- unique(metadata[["sample_name"]])
  missing_samples <- setdiff(file_basenames, metadata_samples)

  if (length(missing_samples) > 0) {
    return(list(valid = FALSE, message = paste("Missing samples in metadata:", paste(missing_samples, collapse = ", "))))
  }

  return(list(valid = TRUE, message = paste("All file names match values in metadata column: sample_name")))
}

#' Check for File Upload Conflicts
#'
#' Validates that uploaded files are compatible and don't conflict with each other.
#' Ensures proper file type combinations and minimum requirements.
#'
#' @param file_exts Character vector of file extensions
#' @return Logical indicating if files are compatible (TRUE) or conflicting (FALSE)
#' @export
checkFileConflicts <- function(file_exts) {
  if (length(file_exts) == 0) {
    showEnhancedError("No files provided for validation")
    return(FALSE)
  }

  if (any(file_exts == "rds") && any(file_exts == "txt")) {
    showEnhancedError("You cannot upload both phyloseq (.rds) and text report files (.txt) at the same time. Please choose one format.", 
                     title = "Mixed File Types")
    return(FALSE)
  }

  if (all(file_exts == "txt") && sum(file_exts == "txt") < 2) {
    showEnhancedError("You must upload at least two Kraken/Bracken report files for analysis.", 
                     title = "Insufficient Files")
    return(FALSE)
  }

  supported_extensions <- c("rds", "txt")
  unsupported <- setdiff(file_exts, supported_extensions)
  if (length(unsupported) > 0) {
    showEnhancedError(paste("Unsupported file types:", paste(unsupported, collapse = ", "), 
                          "Please upload .rds or .txt files only."), 
                     title = "Unsupported File Types")
    return(FALSE)
  }

  return(TRUE)
}

#' Check Metadata Requirements
#'
#' Validates that metadata is provided when required for text file analysis.
#' Metadata is mandatory when uploading multiple text report files.
#'
#' @param file_exts Character vector of file extensions
#' @param metadataFile Shiny file input object containing metadata file
#' @return Logical indicating if metadata requirements are met
#' @export
requireMetadata <- function(file_exts, metadataFile) {
  txt_count <- sum(file_exts == "txt")

  if (txt_count > 1 && is.null(metadataFile)) {
    showEnhancedError("Metadata file is required when uploading multiple Kraken/Bracken reports. Please upload a metadata file with 'sample_name' column.", 
                     title = "Missing Metadata")
    return(FALSE)
  }

  if (!is.null(metadataFile)) {
    if (is.null(metadataFile$datapath) || !file.exists(metadataFile$datapath)) {
      showEnhancedError("Metadata file path is invalid or file does not exist", 
                       title = "Invalid File Path")
      return(FALSE)
    }

    if (file.info(metadataFile$datapath)$size == 0) {
      showEnhancedError("Metadata file is empty. Please upload a valid metadata file.", 
                       title = "Empty File")
      return(FALSE)
    }
  }

  return(TRUE)
}

validateTxtReports <- function(txt_files, metadataFile) {
  txt_basenames <- gsub("_.*", "", tools::file_path_sans_ext(txt_files$name))
  metadata <- fread(metadataFile$datapath)
  metadata[metadata == ""] <- NA

  validation <- validateMetadataWithFileNames(metadata, txt_basenames)
  if (!validation$valid) {
    showEnhancedError(validation$message, title = "Metadata Validation Failed")
    return(NULL)
  }
  list(metadata = metadata, basenames = txt_basenames)
}

detectReportType <- function(txt_files) {
  is_bracken <- sapply(txt_files$datapath, function(path) {
    "new_est_reads" %in% colnames(fread(path, nrows = 1))
  })
  if (all(is_bracken)) return("bracken")
  if (all(!is_bracken)) return("kraken")
  showEnhancedError("Do not mix Kraken and Bracken reports. All files should be the same format.", 
                   title = "Mixed Report Types")
  return(NULL)
}

validate_sample_count <- function(data, min_samples = 3) {
  sample_count <- length(unique(data$sample_name))
  if (sample_count < min_samples) {
    showEnhancedWarning("Beta diversity requires at least 3 samples. Skipping beta diversity computation.", 
                       title = "Insufficient Samples")
    return(FALSE)
  }
  TRUE
}

get_violin_safe_columns <- function(metadata_dt) {
  if (!is.data.table(metadata_dt)) {
    metadata_dt <- as.data.table(metadata_dt)
  }

  cols_safe <- colnames(metadata_dt)[sapply(colnames(metadata_dt), function(col) {
    min(metadata_dt[ , .N, by = col]$N) >= 2
  })]

  return(cols_safe)
}

validateOptionalFiles <- function(main_files, optional_files) {
  main_basenames <- gsub("_.*","", tools::file_path_sans_ext(main_files$name))
  optional_basenames <- gsub("_.*","", tools::file_path_sans_ext(optional_files$name))

  if (length(main_basenames) != length(optional_basenames)) {
    return(list(valid = FALSE, message = "The number of Bracken reports MUST match the Kraken reports uploaded."))
  }

  if (!setequal(main_basenames, optional_basenames)) {
    missing_in_opt <- setdiff(main_basenames, optional_basenames)
    extra_in_opt <- setdiff(optional_basenames, main_basenames)

    msg <- "Mismatch in sample names between Kraken and Bracken reports."
    if (length(missing_in_opt) > 0) {
      msg <- paste0(msg, " Missing in Bracken: ", paste(missing_in_opt, collapse = ", "))
    }
    if (length(extra_in_opt) > 0) {
      msg <- paste0(msg, " Extra in Bracken: ", paste(extra_in_opt, collapse = ", "))
    }
    return(list(valid = FALSE, message = msg))
  }

  invalid_files <- c()
  for (i in seq_along(optional_files$datapath)) {
    file_path <- optional_files$datapath[i]
    file_headers <- fread(file_path, nrows = 0, header = TRUE)
    if (ncol(file_headers) < 1 || !"new_est_reads" %in% colnames(file_headers)) {
      invalid_files <- c(invalid_files, optional_files$name[i])
    }
  }

  if (length(invalid_files) > 0) {
    return(list(valid = FALSE, message = paste("The following are not valid Bracken reports: ", paste(invalid_files, collapse = ", "))))
  }

  return(list(valid = TRUE, message = "Bracken reports are valid and match Kraken samples."))
}
