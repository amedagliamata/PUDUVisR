#' Run the Shiny App
#'
#' This function launches the Shiny app.
#'
#' @param launch.browser Logical, whether to launch in browser. 
#'   If TRUE (default), opens in external browser for best experience.
#'   If FALSE, uses RStudio viewer (may have rendering limitations).
#' @param ... Additional arguments passed to shinyApp
#' @export
run_app <- function(launch.browser = TRUE, ...) {
  # Prefer installed package app directory; fall back to local inst/app when developing
  app_dir <- system.file("app", package = "puduapp")
  if (app_dir == "") {
    # Attempt to use local development copy at project root 'inst/app'
    local_app <- file.path(getwd(), "inst", "app")
    if (dir.exists(local_app)) {
      app_dir <- local_app
      message("Using local app directory: ", app_dir)
      # expose local app dir to sourced globals so they can find helper files
      assign("PUDUAPP_LOCAL_APP_DIR", app_dir, envir = .GlobalEnv)
    } else {
      stop("Could not find app directory. Please ensure the package is installed or run from the project root containing 'inst/app'.")
    }
  }

  # Inform user about browser recommendation
  if (interactive() && !launch.browser) {
    message("💡 Note: For optimal rendering and performance, consider using launch.browser = TRUE")
    message("   The app uses advanced CSS and JavaScript features that work best in a full browser.")
  }

  # Source global configuration first in global environment
  # Source global.R from installed package or local app dir
  global_file <- file.path(app_dir, "global.R")
  if (file.exists(global_file)) {
    tryCatch({
      source(global_file, local = FALSE)  # Source in global environment
    }, error = function(e) {
      stop("Error sourcing global.R: ", e$message)
    })
  } else {
    stop("Could not find global.R file in app directory: ", app_dir)
  }

  # Source UI and server files in global environment too
  ui_file <- file.path(app_dir, "ui.R")
  server_file <- file.path(app_dir, "server.R")
  
  if (!file.exists(ui_file)) {
    stop("Could not find ui.R file in app directory.")
  }
  if (!file.exists(server_file)) {
    stop("Could not find server.R file in app directory.")
  }

  tryCatch({
    source(ui_file, local = FALSE)
    source(server_file, local = FALSE)
  }, error = function(e) {
    stop("Error sourcing UI/Server files: ", e$message)
  })

  # Configure options for better rendering
  options(shiny.launch.browser = launch.browser)
  
  shiny::shinyApp(
    ui = ui, 
    server = server,
    options = list(
      launch.browser = launch.browser,
      height = 800,
      width = 1200
    )
  )
}

#' Run the App in Browser (Recommended)
#'
#' This function launches the Shiny app directly in your default browser
#' for the best experience with all features properly rendered.
#'
#' @param ... Additional arguments passed to run_app
#' @export
run_app_browser <- function(...) {
  message("🚀 Launching PUDU App in browser for optimal experience...")
  run_app(launch.browser = TRUE, ...)
}