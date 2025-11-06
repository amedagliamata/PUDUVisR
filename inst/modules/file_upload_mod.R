#' File Upload Module
#'
#' This module handles file upload, validation, and processing for the PUDUApp application.
#' It manages the upload of Kraken/Bracken reports, phyloseq objects, and metadata files.

#' File Upload Module UI
#'
#' Creates the UI components for file upload functionality including file inputs,
#' processing button, and file information display.
#'
#' @param id Character string specifying the module namespace
#' @return Shiny UI elements
#' @export
fileUploadUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    card(
      fileInput(ns("mainFiles"), LABEL_MAIN_FILES, 
                multiple = TRUE, accept = c(".rds", ".txt")),
      fileInput(ns("metadataFile"), LABEL_METADATA_FILE,
                accept = c(".txt", ".tsv")),
      fileInput(ns("optionalFiles"), LABEL_OPTIONAL_FILES, 
                multiple = TRUE, accept = c(".txt")),
      actionButton(ns("processBtn"), BTN_PROCESS_REPORTS, class = "btn-primary")
    ),
    card(
      div(
        style = "max-height: 200px; overflow-y: auto; overflow-x: auto; width: 100%;",
        tableOutput(ns("uploadedFiles"))
      )
    )
  )
}

#' File Upload Module Server
#'
#' Server logic for handling file upload, validation, and processing.
#' Manages the reactive data flow and error handling for uploaded files.
#'
#' @param id Character string specifying the module namespace
#' @param appData Reactive values object for storing application data
#' @return None (modifies appData through side effects)
#' @export
fileUploadServer <- function(id, appData) {
  moduleServer(id, function(input, output, session) {
    
    # Display uploaded files information
    output$uploadedFiles <- renderTable({
      files_info <- data.frame(
        "File Type" = character(),
        "File Name" = character(), 
        "File Size" = character(),
        stringsAsFactors = FALSE
      )
      
      # Process main files
      if (!is.null(input$mainFiles)) {
        main_files <- input$mainFiles
        main_type <- ifelse(tools::file_ext(main_files$name) == "rds", 
                           TABLE_MAIN_RDS, TABLE_MAIN_TXT)
        main_info <- data.frame(
          "File Type" = main_type,
          "File Name" = main_files$name,
          "File Size" = format_file_size(main_files$size),
          stringsAsFactors = FALSE
        )
        files_info <- rbind(files_info, main_info)
      }
      
      # Process metadata file
      if (!is.null(input$metadataFile)) {
        meta_info <- data.frame(
          "File Type" = TABLE_METADATA,
          "File Name" = input$metadataFile$name,
          "File Size" = format_file_size(input$metadataFile$size),
          stringsAsFactors = FALSE
        )
        files_info <- rbind(files_info, meta_info)
      }
      
      # Process optional files
      if (!is.null(input$optionalFiles)) {
        opt_files <- input$optionalFiles
        opt_info <- data.frame(
          "File Type" = TABLE_OPTIONAL,
          "File Name" = opt_files$name,
          "File Size" = sapply(opt_files$size, format_file_size),
          stringsAsFactors = FALSE
        )
        files_info <- rbind(files_info, opt_info)
      }
      
      # Return result
      if (nrow(files_info) == 0) {
        return(data.frame("Uploaded files" = TABLE_NO_FILES))
      }
      
      return(files_info)
    })
    
    # Process button event handler
    observeEvent(input$processBtn, {
      
      # Validate required inputs
      if (!validate_required_inputs(input, "mainFiles", "file processing")) {
        return()
      }
      
      files <- input$mainFiles
      file_exts <- tools::file_ext(files$name)
      
      # Validate file compatibility and requirements
      if (!checkFileConflicts(file_exts) || !requireMetadata(file_exts, input$metadataFile)) {
        return()
      }
      
      # Process files with progress indication
      result <- with_progress_and_error_handling({
        incProgress(0.2, detail = PROGRESS_VALIDATING)
        
        if (any(file_exts == "rds")) {
          # Process RDS files
          appData$fileType <- "rds"
          rds_files <- files[file_exts == "rds", ]
          output <- safe_process_files(rds_files, processRDSFile, "RDS file processing")
          if (!is.null(output)) {
            incProgress(0.5, detail = PROGRESS_RDS_PROCESSED)
            show_success(MSG_PHYLOSEQ_LOADED)
          }
          
        } else if (all(file_exts == "txt")) {
          # Process TXT files
          appData$fileType <- "txt"
          txt_files <- files[file_exts == "txt", ]
          
          # Validate and process metadata
          meta_info <- validateTxtReports(txt_files, input$metadataFile)
          if (is.null(meta_info)) {
            validate_and_notify(FALSE, ERR_METADATA_PARSE_FAILED)
            return(NULL)
          }
          
          incProgress(0.3, detail = PROGRESS_KRAKEN_PROCESSING)
          
          # Process Kraken files
          output <- safe_process_files(
            list(files = txt_files, metadata = meta_info$metadata, basenames = meta_info$basenames),
            function(args) processKrakenFiles(args$files, args$metadata, args$basenames),
            "Kraken file processing"
          )
          
          if (!is.null(output)) {
            kraken_data <- output$raw[, c("tax_ID", "domain")]
            appData$reportType <- "kraken"
            show_success(MSG_KRAKEN_LOADED)
            
            # Process optional Bracken files if provided
            if (!is.null(input$optionalFiles)) {
              incProgress(0.1, detail = PROGRESS_BRACKEN_VALIDATION)
              validation_result <- validateOptionalFiles(txt_files, input$optionalFiles)
              
              if (validation_result$valid) {
                incProgress(0.2, detail = PROGRESS_BRACKEN_PROCESSING)
                bracken_output <- safe_process_files(
                  list(files = input$optionalFiles, metadata = meta_info$metadata, 
                       basenames = meta_info$basenames, kraken_data = kraken_data),
                  function(args) processBrackenFiles(args$files, args$metadata, 
                                                   args$basenames, args$kraken_data),
                  "Bracken file processing"
                )
                
                if (!is.null(bracken_output)) {
                  output <- bracken_output
                  appData$reportType <- "bracken"
                  show_success(MSG_BRACKEN_LOADED)
                }
              } else {
                validate_and_notify(FALSE, validation_result$message)
              }
            }
          }
          
        } else {
          validate_and_notify(FALSE, ERR_UNSUPPORTED_FILE_TYPES)
          return(NULL)
        }
        
        return(output)
        
      }, PROGRESS_PROCESSING, "file processing")
      
      # Store results in app data
      if (!is.null(result)) {
        incProgress(0.1, detail = PROGRESS_SAVING_DATA)
        appData$processedData <- result$processed
        appData$metaData <- result$metadata
        appData$rawData <- result$raw
        appData$phyloseqData <- result$phylo
      }
    })
  })
}