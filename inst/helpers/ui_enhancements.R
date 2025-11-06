#' UI Enhancements for PUDUApp
#'
#' This file contains UI enhancement functions for better user experience,
#' including loading indicators, error displays, and improved feedback.

#' Notification Toast
#'
#' Creates a toast notification for better user feedback.
#'
#' @param message Character string for notification message
#' @param type Character string for notification type ("success", "info", "warning", "error")
#' @param title Character string for notification title (optional)
#' @return HTML div element for toast notification
#' @export
toastNotification <- function(message, type = "info", title = NULL) {
  type_classes <- list(
    "success" = list(class = "alert-success", icon = "check-circle"),
    "info" = list(class = "alert-info", icon = "info-circle"),
    "warning" = list(class = "alert-warning", icon = "exclamation-triangle"),
    "error" = list(class = "alert-danger", icon = "exclamation-circle")
  )

  config <- type_classes[[type]] %||% type_classes[["info"]]

  div(
    class = paste("alert", config$class, "alert-dismissible fade show position-fixed"),
    role = "alert",
    style = "top: 20px; right: 20px; z-index: 1050; min-width: 300px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
    div(
      class = "d-flex align-items-center",
      tags$i(class = paste("fas fa", config$icon, "me-2 fs-5")),
      div(
        if (!is.null(title)) tags$strong(title, class = "me-2"),
        message
      )
    ),
    tags$button(
      type = "button",
      class = "btn-close",
      `data-bs-dismiss` = "alert",
      `aria-label` = "Close"
    )
  )
}

#' Status Badge
#'
#' Creates a status badge with icon for file or process status.
#'
#' @param status Character string for status ("success", "processing", "error", "pending")
#' @param text Character string for badge text
#' @return HTML span element for status badge
#' @export
statusBadge <- function(status, text) {
  status_config <- list(
    "success" = list(class = "bg-success", icon = "check"),
    "processing" = list(class = "bg-warning", icon = "spinner fa-spin"),
    "error" = list(class = "bg-danger", icon = "times"),
    "pending" = list(class = "bg-secondary", icon = "clock")
  )

  config <- status_config[[status]] %||% status_config[["pending"]]

  span(
    class = paste("badge", config$class, "d-inline-flex align-items-center"),
    style = "font-size: 0.75em; padding: 0.5em 0.75em;",
    tags$i(class = paste("fas fa", config$icon, "me-1")),
    text
  )
}

#' Enhanced Error Display
#'
#' Creates a styled error display panel for showing detailed error information.
#'
#' @param id Character string for the output ID
#' @return HTML div element for error display
#' @export
errorDisplayPanel <- function(id) {
  div(
    id = paste0(id, "-error-panel"),
    style = "display: none; margin-top: 10px;",
    div(
      class = "alert alert-danger",
      role = "alert",
      style = "margin-bottom: 0;",
      tags$strong("Error: "),
      verbatimTextOutput(id, placeholder = FALSE)
    )
  )
}

#' Success Message Panel
#'
#' Creates a styled success message panel for positive feedback.
#'
#' @param message Character string for success message
#' @return HTML div element for success display
#' @export
successPanel <- function(message) {
  div(
    class = "alert alert-success alert-dismissible fade show",
    role = "alert",
    style = "margin-top: 10px;",
    tags$strong("Success! "),
    message,
    tags$button(
      type = "button",
      class = "btn-close",
      `data-bs-dismiss` = "alert",
      `aria-label` = "Close"
    )
  )
}

#' Info Panel with Icon
#'
#' Creates an informational panel with icon and message.
#'
#' @param title Character string for panel title
#' @param content Character string or HTML content for panel body
#' @param icon Character string for Font Awesome icon name (default: "info-circle")
#' @return HTML card element
#' @export
infoPanel <- function(title, content, icon = "info-circle") {
  card(
    card_header(
      tags$i(class = paste("fas fa", icon, "me-2")),
      title
    ),
    card_body(content)
  )
}

#' Enhanced File Input
#'
#' Creates an enhanced file input with drag-and-drop styling and preview.
#'
#' @param inputId Character string for input ID
#' @param label Character string or HTML for input label
#' @param multiple Logical indicating if multiple files are allowed
#' @param accept Character vector of accepted file types
#' @param placeholder Character string for placeholder text
#' @return HTML div element with enhanced file input
#' @export
enhancedFileInput <- function(inputId, label, multiple = FALSE, accept = NULL, placeholder = "Choose files or drag them here...") {
  div(
    class = "enhanced-file-input mb-3",
    if (!is.null(label)) {
      tags$label(
        class = "form-label fw-semibold mb-2",
        `for` = inputId,
        label
      )
    },
    div(
      class = "file-input-wrapper position-relative",
      style = "
        border: 2px dashed #dee2e6;
        border-radius: 12px;
        padding: 2rem;
        text-align: center;
        background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        transition: all 0.3s ease;
        cursor: pointer;
      ",
      onmouseover = "this.style.borderColor='#007bff'; this.style.backgroundColor='#f0f8ff';",
      onmouseout = "this.style.borderColor='#dee2e6'; this.style.backgroundColor='#f8f9fa';",

      fileInput(
        inputId = inputId,
        label = NULL,
        multiple = multiple,
        accept = accept,
        width = "100%"
      ),

      div(
        class = "file-input-content position-absolute top-50 start-50 translate-middle pointer-events-none",
        style = "color: #6c757d;",
        tags$i(class = "fas fa-cloud-upload-alt fa-3x mb-3 text-primary"),
        p(class = "mb-1 fw-semibold", placeholder),
        small(class = "text-muted", 
              if (!is.null(accept)) paste("Accepted formats:", paste(accept, collapse = ", ")) else "")
      )
    )
  )
}

#' Input Group with Icon
#'
#' Creates a form input group with icon and enhanced styling.
#'
#' @param inputId Character string for input ID
#' @param label Character string for input label
#' @param icon Character string for Font Awesome icon name
#' @param input_function Function to create the input (e.g., textInput, selectInput)
#' @param ... Additional arguments passed to input_function
#' @return HTML div element with input group
#' @export
inputGroupWithIcon <- function(inputId, label, icon, input_function, ...) {
  div(
    class = "mb-3",
    if (!is.null(label)) {
      tags$label(
        class = "form-label fw-semibold mb-2 d-flex align-items-center",
        `for` = inputId,
        tags$i(class = paste("fas fa", icon, "me-2 text-primary")),
        label
      )
    },
    div(
      class = "input-group",
      span(
        class = "input-group-text bg-primary text-white border-primary",
        tags$i(class = paste("fas fa", icon))
      ),
      input_function(inputId, label = NULL, ...)
    )
  )
}

#' Progress Bar with Steps
#'
#' Creates a multi-step progress bar for complex operations.
#'
#' @param steps Character vector of step names
#' @param current_step Integer indicating current step (1-based)
#' @return HTML div element with progress bar
#' @export
stepProgressBar <- function(steps, current_step = 1) {
  total_steps <- length(steps)
  progress_percent <- (current_step - 1) / (total_steps - 1) * 100
  
  div(
    class = "progress-container mb-3",
    div(
      class = "progress",
      style = "height: 10px;",
      div(
        class = "progress-bar bg-primary progress-bar-striped progress-bar-animated",
        role = "progressbar",
        style = paste0("width: ", progress_percent, "%;"),
        `aria-valuenow` = progress_percent,
        `aria-valuemin` = "0",
        `aria-valuemax` = "100"
      )
    ),
    div(
      class = "d-flex justify-content-between mt-2",
      lapply(seq_along(steps), function(i) {
        status_class <- if (i < current_step) {
          "text-success fw-bold"
        } else if (i == current_step) {
          "text-primary fw-bold"
        } else {
          "text-muted"
        }
        span(
          class = status_class,
          style = "font-size: 0.9em;",
          steps[i]
        )
      })
    )
  )
}

#' Collapsible Help Panel
#'
#' Creates a collapsible help panel with instructions.
#'
#' @param id Character string for unique panel ID
#' @param title Character string for panel title
#' @param content Character string or HTML content for help text
#' @param collapsed Logical indicating if panel starts collapsed (default: TRUE)
#' @return HTML div element with collapsible panel
#' @export
helpPanel <- function(id, title, content, collapsed = TRUE) {
  collapse_id <- paste0(id, "_collapse")

  div(
    class = "card mb-3",
    div(
      class = "card-header",
      tags$button(
        class = "btn btn-link text-decoration-none p-0 text-start w-100",
        type = "button",
        `data-bs-toggle` = "collapse",
        `data-bs-target` = paste0("#", collapse_id),
        `aria-expanded` = ifelse(collapsed, "false", "true"),
        `aria-controls` = collapse_id,
        tags$i(class = "fas fa-question-circle me-2 text-info"),
        title,
        tags$i(class = "fas fa-chevron-down float-end mt-1")
      )
    ),
    div(
      id = collapse_id,
      class = ifelse(collapsed, "collapse", "collapse show"),
      div(
        class = "card-body",
        content
      )
    )
  )
}

#' Enhanced Custom CSS Styles
#'
#' Comprehensive custom CSS styles for modern UI components.
#'
#' @return HTML style tag with enhanced custom CSS
#' @export
enhancedCustomCSS <- function() {
  tags$style(HTML("
    /* Global Design System */
    :root {
      --primary-gradient: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
      --success-gradient: linear-gradient(135deg, #28a745 0%, #20c997 100%);
      --warning-gradient: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
      --danger-gradient: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
      --surface-gradient: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
      --shadow-sm: 0 2px 8px rgba(0,0,0,0.08);
      --shadow-md: 0 4px 12px rgba(0,0,0,0.12);
      --shadow-lg: 0 6px 20px rgba(0,0,0,0.15);
      --border-radius: 12px;
      --border-radius-sm: 8px;
      --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* Enhanced Loading States */
    .loading-overlay {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      backdrop-filter: blur(8px);
    }

    /* Button System */
    .btn {
      border-radius: var(--border-radius-sm) !important;
      font-weight: 600 !important;
      padding: 0.6rem 1.2rem !important;
      transition: var(--transition) !important;
      border: none !important;
      position: relative !important;
      overflow: hidden !important;
    }
    
    .btn::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
      transition: left 0.5s;
    }

    .btn:hover::before {
      left: 100%;
    }

    .btn-primary {
      background: var(--primary-gradient) !important;
      box-shadow: var(--shadow-sm) !important;
    }

    .btn-primary:hover {
      transform: translateY(-2px) !important;
      box-shadow: var(--shadow-md) !important;
    }

    .btn-darkblue {
      background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 100%) !important;
      color: white !important;
      box-shadow: var(--shadow-sm) !important;
    }

    .btn-darkblue:hover {
      background: linear-gradient(135deg, #1e40af 0%, #1d4ed8 100%) !important;
      transform: translateY(-2px) !important;
      box-shadow: var(--shadow-md) !important;
    }

    /* Card System */
    .card {
      border-radius: var(--border-radius) !important;
      border: none !important;
      box-shadow: var(--shadow-sm) !important;
      transition: var(--transition) !important;
      background: white !important;
    }

    .card:hover {
      box-shadow: var(--shadow-md) !important;
      transform: translateY(-2px) !important;
    }

    .card-header {
      background: var(--surface-gradient) !important;
      border-radius: var(--border-radius) var(--border-radius) 0 0 !important;
      border-bottom: 2px solid #e9ecef !important;
      font-weight: 600 !important;
      padding: 1.25rem !important;
      color: #495057 !important;
    }

    .card-body {
      padding: 1.5rem !important;
    }

    /* Form Controls */
    .form-control, .form-select {
      border-radius: var(--border-radius-sm) !important;
      border: 2px solid #e9ecef !important;
      transition: var(--transition) !important;
      padding: 0.75rem !important;
      font-size: 0.95rem !important;
    }

    .form-control:focus, .form-select:focus {
      border-color: #007bff !important;
      box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.15) !important;
      transform: scale(1.02) !important;
    }

    .form-label {
      font-weight: 600 !important;
      color: #495057 !important;
      margin-bottom: 0.75rem !important;
    }

    /* Enhanced File Inputs */
    .enhanced-file-input .file-input-wrapper:hover {
      border-color: #007bff !important;
      background: #f0f8ff !important;
      transform: scale(1.02) !important;
    }

    .file-input-wrapper .shiny-input-container {
      position: absolute !important;
      width: 100% !important;
      height: 100% !important;
      opacity: 0 !important;
      cursor: pointer !important;
    }

    /* Navigation */
    .navbar-brand {
      font-size: 1.5rem !important;
      font-weight: 700 !important;
    }

    .nav-link {
      border-radius: var(--border-radius-sm) !important;
      margin: 0 4px !important;
      transition: var(--transition) !important;
      font-weight: 500 !important;
      padding: 0.75rem 1rem !important;
    }

    .nav-link:hover {
      background-color: rgba(0,123,255,0.1) !important;
      transform: translateY(-1px) !important;
    }

    .nav-link.active {
      background: var(--primary-gradient) !important;
      box-shadow: var(--shadow-sm) !important;
      color: white !important;
    }

    /* Sidebar */
    .bslib-sidebar-layout > .sidebar {
      background: var(--surface-gradient) !important;
      border-radius: var(--border-radius) !important;
      border: 1px solid #e9ecef !important;
      box-shadow: var(--shadow-sm) !important;
    }

    .sidebar-title {
      font-size: 1.1rem !important;
      font-weight: 700 !important;
      color: #495057 !important;
      margin-bottom: 1.5rem !important;
    }

    /* Tables */
    .table-container {
      border-radius: var(--border-radius) !important;
      overflow: hidden !important;
      border: 1px solid #e9ecef !important;
      background: white !important;
    }

    .table th {
      background: var(--surface-gradient) !important;
      border-bottom: 2px solid #dee2e6 !important;
      font-weight: 600 !important;
      padding: 1rem 0.75rem !important;
      color: #495057 !important;
    }

    .table td {
      padding: 0.75rem !important;
      border-bottom: 1px solid #f8f9fa !important;
    }

    .table tbody tr:hover {
      background-color: #f8f9fa !important;
    }

    /* Alerts and Notifications */
    .alert {
      border-radius: var(--border-radius) !important;
      border: none !important;
      box-shadow: var(--shadow-sm) !important;
      padding: 1rem 1.25rem !important;
    }

    /* Floating Elements */
    .floating-download {
      background: var(--success-gradient) !important;
      border-radius: 50px !important;
      padding: 12px 24px !important;
      box-shadow: var(--shadow-md) !important;
      font-weight: 600 !important;
      transition: var(--transition) !important;
      color: white !important;
    }

    .floating-download:hover {
      transform: translateY(-3px) scale(1.05) !important;
      box-shadow: var(--shadow-lg) !important;
    }

    /* Progress Indicators */
    .progress {
      height: 10px !important;
      border-radius: 10px !important;
      background-color: #f8f9fa !important;
      box-shadow: inset 0 1px 2px rgba(0,0,0,0.1) !important;
    }

    .progress-bar {
      border-radius: 10px !important;
      background: var(--primary-gradient) !important;
    }

    /* Tabs */
    .nav-pills .nav-link {
      border-radius: var(--border-radius-sm) !important;
      font-weight: 500 !important;
    }

    .nav-pills .nav-link.active {
      background: var(--primary-gradient) !important;
      box-shadow: var(--shadow-sm) !important;
      color: #fff !important;
    }

    /* Status Badges */
    .badge {
      border-radius: 20px !important;
      font-weight: 500 !important;
      letter-spacing: 0.5px !important;
    }

    /* Scrollbars */
    .table-container::-webkit-scrollbar,
    .sidebar::-webkit-scrollbar {
      width: 8px;
      height: 8px;
    }
    .table-container::-webkit-scrollbar-track,
    .sidebar::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 4px;
    }
    .table-container::-webkit-scrollbar-thumb,
    .sidebar::-webkit-scrollbar-thumb {
      background: #c1c1c1;
      border-radius: 4px;
      transition: var(--transition);
    }
    .table-container::-webkit-scrollbar-thumb:hover,
    .sidebar::-webkit-scrollbar-thumb:hover {
      background: #a8a8a8;
    }
    /* Responsive Design */
    @media (max-width: 768px) {
      .floating-download {
        position: relative !important;
        top: auto !important;
        right: auto !important;
        margin: 1rem 0 !important;
        width: 100% !important;
      }
      .card {
        margin-bottom: 1rem !important;
      }
      .sidebar {
        margin-bottom: 1rem !important;
      }
    }
    /* Animation Classes */
    .fade-in {
      animation: fadeIn 0.5s ease-in;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .slide-in {
      animation: slideIn 0.3s ease-out;
    }
    @keyframes slideIn {
      from { transform: translateX(-100%); }
      to { transform: translateX(0); }
    }
  "))
}