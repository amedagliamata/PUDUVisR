# Error handling utilities for PUDUApp
#'
#' This file contains centralized error handling functions to ensure consistent
#' error reporting and validation patterns throughout the application.

#' Validate Condition and Show Notification
#'
#' Validates a condition and shows a notification if the condition fails.
#' Provides consistent error handling across the application.
#'
#' @param condition Logical condition to validate
#' @param message Character string with error message to display
#' @param type Character string indicating notification type ("error", "warning", "message")
#' @return Logical indicating if validation passed (TRUE) or failed (FALSE)
#' @export
validate_and_notify <- function(condition, message, type = "error") {
  if (!condition) {
    showNotification(message, type = type, duration = 10)
    return(FALSE)
  }
  TRUE
}

#' Safe File Processing with Error Handling
#'
#' Safely executes file processing functions with proper error handling
#' and user notification. Catches and handles exceptions gracefully.
#'
#' @param files File data frame to process
#' @param processor_func Function to use for processing files
#' @param context_message Character string describing the processing context
#' @return Result of processor_func or NULL if error occurred
#' @export
safe_process_files <- function(files, processor_func, context_message = "processing files") {
  tryCatch({
    result <- processor_func(files)
    if (is.null(result)) {
      validate_and_notify(FALSE, paste("Failed", context_message, "- no data returned"))
      return(NULL)
    }
    return(result)
  }, error = function(e) {
    error_msg <- paste("Error", context_message, ":", e$message)
    validate_and_notify(FALSE, error_msg)

    return(NULL)
  })
}

#' Validate Required Inputs
#'
#' Checks that all required inputs are present and valid.
#' Useful for validating user inputs before processing.
#'
#' @param input_list Named list of inputs to validate
#' @param required_fields Character vector of required field names
#' @param context Character string describing the validation context
#' @return Logical indicating if all required inputs are valid
#' @export
validate_required_inputs <- function(input_list, required_fields, context = "operation") {
  missing_fields <- c()

  for (field in required_fields) {
    if (is.null(input_list[[field]]) || 
        (is.character(input_list[[field]]) && input_list[[field]] == "") ||
        (is.data.frame(input_list[[field]]) && nrow(input_list[[field]]) == 0)) {
      missing_fields <- c(missing_fields, field)
    }
  }

  if (length(missing_fields) > 0) {
    message <- paste("Missing required inputs for", context, ":", 
                    paste(missing_fields, collapse = ", "))
    validate_and_notify(FALSE, message)
    return(FALSE)
  }

  return(TRUE)
}

#' Handle Progress with Error Recovery
#'
#' Executes a function within a progress context with error handling.
#' Automatically handles progress completion and error cleanup.
#'
#' @param expr Expression to execute within progress context
#' @param message Character string for progress message
#' @param error_message Character string for error context
#' @return Result of expression or NULL if error occurred
#' @export
with_progress_and_error_handling <- function(expr, message = "Processing...", 
                                           error_message = "processing") {
  tryCatch({
    withProgress(message = message, value = 0, {
      result <- eval(expr)
      incProgress(1.0, detail = "Complete!")
      return(result)
    })
  }, error = function(e) {
    error_msg <- paste("Error during", error_message, ":", e$message)
    validate_and_notify(FALSE, error_msg)
    return(NULL)
  })
}

#' Validate Data Consistency
#'
#' Validates that data meets basic consistency requirements such as
#' minimum sample counts, required columns, and data types.
#'
#' @param data Data frame or data table to validate
#' @param required_columns Character vector of required column names
#' @param min_rows Integer minimum number of rows required
#' @param context Character string describing the data context
#' @return Logical indicating if data passes validation
#' @export
validate_data_consistency <- function(data, required_columns = NULL, 
                                    min_rows = 1, context = "data") {

  if (is.null(data) || nrow(data) == 0) {
    validate_and_notify(FALSE, paste("No", context, "available"))
    return(FALSE)
  }

  if (nrow(data) < min_rows) {
    validate_and_notify(FALSE, paste(context, "requires at least", min_rows, 
                                   "rows but only", nrow(data), "found"))
    return(FALSE)
  }

  if (!is.null(required_columns)) {
    missing_cols <- setdiff(required_columns, colnames(data))
    if (length(missing_cols) > 0) {
      validate_and_notify(FALSE, paste("Missing required columns in", context, ":", 
                                      paste(missing_cols, collapse = ", ")))
      return(FALSE)
    }
  }

  return(TRUE)
}

#' Show Success Notification
#'
#' Shows a success notification with consistent formatting.
#'
#' @param message Character string with success message
#' @param emoji Character string with emoji (default: "✅")
#' @export
show_success <- function(message, emoji = "✅") {
  showNotification(paste(emoji, message), type = "message", duration = 5)
}

#' Show Warning Notification
#'
#' Shows a warning notification with consistent formatting.
#'
#' @param message Character string with warning message
#' @param emoji Character string with emoji (default: "⚠️")
#' @export
show_warning <- function(message, emoji = "⚠️") {
  showNotification(paste(emoji, message), type = "warning", duration = 8)
}

#' Show Info Notification
#'
#' Shows an info notification with consistent formatting.
#'
#' @param message Character string with info message
#' @param emoji Character string with emoji (default: "ℹ️")
#' @export
show_info <- function(message, emoji = "ℹ️") {
  showNotification(paste(emoji, message), type = "message", duration = 6)
}