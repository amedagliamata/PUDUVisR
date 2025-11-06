# Enhanced Notification System for PUDUApp
#'
#' This file provides a consistent notification system that matches the visual
#' style of the validation alerts throughout the application.

#' Show Enhanced Error Notification
#'
#' Shows a styled error notification with consistent Bootstrap alert styling
#' and FontAwesome icons to match the validation UI components.
#'
#' @param message Character string with error message
#' @param title Character string with optional title (default: "Error")
#' @param duration Numeric duration in seconds (default: 10)
#' @export
showEnhancedError <- function(message, title = "Error", duration = 10) {
  showNotification(
    ui = div(
      class = "alert alert-danger border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-exclamation-triangle' style='color: #dc3545; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #721c24; font-weight: 600;'>", title, "</strong>",
        "<div style='color: #721c24; margin-top: 4px; line-height: 1.4;'>", message, "</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "error",
    duration = duration
  )
}

#' Show Enhanced Warning Notification
#'
#' Shows a styled warning notification with consistent Bootstrap alert styling.
#'
#' @param message Character string with warning message
#' @param title Character string with optional title (default: "Warning")
#' @param duration Numeric duration in seconds (default: 8)
#' @export
showEnhancedWarning <- function(message, title = "Warning", duration = 8) {
  showNotification(
    ui = div(
      class = "alert alert-warning border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-exclamation-triangle' style='color: #856404; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #856404; font-weight: 600;'>", title, "</strong>",
        "<div style='color: #856404; margin-top: 4px; line-height: 1.4;'>", message, "</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "warning",
    duration = duration
  )
}

#' Show Enhanced Success Notification
#'
#' Shows a styled success notification with consistent Bootstrap alert styling.
#'
#' @param message Character string with success message
#' @param title Character string with optional title (default: "Success")
#' @param duration Numeric duration in seconds (default: 5)
#' @export
showEnhancedSuccess <- function(message, title = "Success", duration = 5) {
  showNotification(
    ui = div(
      class = "alert alert-success border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-check-circle' style='color: #155724; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #155724; font-weight: 600;'>", title, "</strong>",
        "<div style='color: #155724; margin-top: 4px; line-height: 1.4;'>", message, "</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "message",
    duration = duration
  )
}

#' Show Enhanced Info Notification
#'
#' Shows a styled info notification with consistent Bootstrap alert styling.
#'
#' @param message Character string with info message
#' @param title Character string with optional title (default: "Information")
#' @param duration Numeric duration in seconds (default: 6)
#' @export
showEnhancedInfo <- function(message, title = "Information", duration = 6) {
  showNotification(
    ui = div(
      class = "alert alert-info border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-info-circle' style='color: #0c5460; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #0c5460; font-weight: 600;'>", title, "</strong>",
        "<div style='color: #0c5460; margin-top: 4px; line-height: 1.4;'>", message, "</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "message",
    duration = duration
  )
}

#' Show File Upload Success Notification
#'
#' Specialized notification for successful file uploads with file-specific styling.
#'
#' @param file_type Character string describing the file type (e.g., "Phyloseq object", "Kraken reports")
#' @param count Integer number of files uploaded
#' @export
showFileUploadSuccess <- function(file_type, count = 1) {
  emoji_map <- list(
    "Phyloseq object" = "📊",
    "Kraken reports" = "📊", 
    "Bracken reports" = "📈",
    "Metadata" = "📋"
  )

  emoji <- emoji_map[[file_type]] %||% "📁"

  message <- if (count > 1) {
    paste(count, file_type, "loaded successfully")
  } else {
    paste(file_type, "loaded successfully")
  }

  showEnhancedSuccess(message, title = paste(emoji, "Upload Complete"))
}

#' Show Enhanced Modal Dialog
#'
#' Shows a styled modal dialog with consistent error styling for critical issues.
#'
#' @param title Character string for modal title
#' @param message Character string for main message
#' @param details Character vector of additional details (optional)
#' @param type Character string: "error", "warning", "success", or "info"
#' @export
showEnhancedModal <- function(title, message, details = NULL, type = "error") {

  icon_config <- switch(type,
    "error" = list(icon = "fas fa-exclamation-triangle", color = "#d32f2f"),
    "warning" = list(icon = "fas fa-exclamation-triangle", color = "#ed6c02"),
    "success" = list(icon = "fas fa-check-circle", color = "#2e7d32"),
    "info" = list(icon = "fas fa-info-circle", color = "#0288d1"),
    list(icon = "fas fa-info-circle", color = "#0288d1")
  )

  details_html <- ""
  if (!is.null(details) && length(details) > 0) {
    details_html <- paste0(
      "<div style='background-color: #f5f5f5; padding: 15px; border-radius: 8px; margin-top: 20px; border-left: 4px solid ", icon_config$color, ";'>",
      "<strong style='color: #333; display: block; margin-bottom: 8px;'>Details:</strong>",
      paste(paste0("• ", details), collapse = "<br>"),
      "</div>"
    )
  }

  showModal(modalDialog(
    title = div(
      style = paste0("color: ", icon_config$color, "; font-weight: 600; font-size: 1.1rem;"),
      HTML(paste0("<i class='", icon_config$icon, "' style='margin-right: 10px;'></i>", title))
    ),
    HTML(paste0(
      "<div style='font-family: \"Inter\", sans-serif; line-height: 1.5;'>",
      "<p style='color: #333; margin-bottom: 15px;'>", message, "</p>",
      details_html,
      "</div>"
    )),
    footer = modalButton("OK"),
    easyClose = TRUE,
    size = "m"
  ))
}

#' Show Processing Progress Notification
#'
#' Shows a temporary notification indicating processing is in progress.
#'
#' @param message Character string with processing message
#' @export
showProcessingNotification <- function(message = "Processing your data...") {
  showNotification(
    ui = div(
      class = "alert alert-info border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<div class='spinner-border spinner-border-sm text-info' role='status' style='margin-right: 12px;'>",
        "<span class='visually-hidden'>Loading...</span>",
        "</div>",
        "<div>",
        "<strong style='color: #0c5460; font-weight: 600;'>Processing</strong>",
        "<div style='color: #0c5460; margin-top: 4px; line-height: 1.4;'>", message, "</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "message",
    duration = 3
  )
}

#' Show Data Clearing Confirmation
#'
#' Shows a specialized notification for data clearing operations.
#'
#' @export
showDataClearSuccess <- function() {
  showNotification(
    ui = div(
      class = "alert alert-success border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-trash-restore' style='color: #155724; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #155724; font-weight: 600;'>🗑️ Data Cleared</strong>",
        "<div style='color: #155724; margin-top: 4px; line-height: 1.4;'>All data has been cleared successfully. You can now upload new files.</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "message",
    duration = 4
  )
}

#' Show Export Success Notification
#'
#' Shows a specialized notification for successful export operations.
#'
#' @param export_type Character string describing what was exported
#' @param format Character string describing the export format
#' @export
showExportSuccess <- function(export_type, format = "file") {
  showNotification(
    ui = div(
      class = "alert alert-success border-0 shadow-sm",
      style = "margin: 0; border-radius: 12px; font-family: 'Inter', sans-serif;",
      HTML(paste0(
        "<div style='display: flex; align-items: center;'>",
        "<i class='fas fa-download' style='color: #155724; margin-right: 12px; font-size: 1.1rem;'></i>",
        "<div>",
        "<strong style='color: #155724; font-weight: 600;'>📥 Export Complete</strong>",
        "<div style='color: #155724; margin-top: 4px; line-height: 1.4;'>", export_type, " exported as ", format, " successfully!</div>",
        "</div>",
        "</div>"
      ))
    ),
    type = "message",
    duration = 4
  )
}