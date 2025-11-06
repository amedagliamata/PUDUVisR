# Create utils/error_handling.R
handle_error <- function(condition, message, type = "error") {
  showNotification(message, type = type)
  if (type == "error") {
    return(NULL)
  }
}

validate_input <- function(input, required_fields) {
  missing <- required_fields[!sapply(required_fields, function(f) !is.null(input[[f]]))]
  if (length(missing) > 0) {
    handle_error(NULL, paste("Missing required fields:", paste(missing, collapse = ", ")))
  }
}