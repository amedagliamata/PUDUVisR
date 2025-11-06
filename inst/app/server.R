source(system.file("helpers", "plots.R", package = "puduapp"))
source(system.file("helpers", "validation.R", package = "puduapp"))
source(system.file("helpers", "processing.R", package = "puduapp"))
source(system.file("helpers", "downloads.R", package = "puduapp"))

server <- function(input, output, session) {

  observe({
    if (exists(".rs.invokeShinyWindowViewer", envir = .GlobalEnv) || 
        exists(".rs.invokeShinyPaneViewer", envir = .GlobalEnv)) {
    }
  })

  output$uploadedFiles <- DT::renderDataTable({
    files_info <- data.frame(
      "File Type" = character(),
      "File Name" = character(),
      "File Size" = character(),
      stringsAsFactors = FALSE
    )

    if (!is.null(input$mainFiles)) {
      main_files <- input$mainFiles
  main_type <- ifelse(tools::file_ext(main_files$name) == "rds", "Main (.rds)", "Main (.txt)")
      main_info <- data.frame(
        "File Type" = main_type,
        "File Name" = main_files$name,
        "File Size" = format(main_files$size/1024, digits = 2, nsmall = 2, trim = TRUE),
        stringsAsFactors = FALSE
      )
      files_info <- rbind(files_info, main_info)
    }

    if (!is.null(input$metadataFile)) {
      meta_info <- data.frame(
        "File Type" = "Metadata",
        "File Name" = input$metadataFile$name,
        "File Size" = format(input$metadataFile$size/1024, digits = 2, nsmall = 2, trim = TRUE),
        stringsAsFactors = FALSE
      )
      files_info <- rbind(files_info, meta_info)
    }

    if (!is.null(input$optionalFiles)) {
      opt_files <- input$optionalFiles
      opt_info <- data.frame(
        "File Type" = "Optional",
        "File Name" = opt_files$name,
        "File Size" = format(opt_files$size/1024, digits = 2, nsmall = 2, trim = TRUE),
        stringsAsFactors = FALSE
      )
      files_info <- rbind(files_info, opt_info)
    }

    if (nrow(files_info) == 0) {
      return(data.frame("Status" = "No files uploaded yet"))
    }

    files_info$`File Size` <- paste(files_info$`File Size`, "kb")

    return(files_info)
  }, options = list(
    scrollY = "100px",
    scrollCollapse = TRUE,
    paging = FALSE,
    searching = FALSE,
    info = FALSE,
    ordering = FALSE,
    dom = 't',
    autoWidth = TRUE
  ))

  appData <- reactiveValues(
    upsetPlot = NULL,
    currentPlot = NULL,
    alphaPlot = NULL,
    betaPlot = NULL,
    taxonomicPlot = NULL,
    taxonomicPlotData = NULL,
    lastValidUpsetSelection = NULL,
    processedData = NULL,
    reportType = NULL,
    metaData = NULL,
    fileType = NULL,
    phyloseqData = NULL,
    betaCalc = NULL,
    bd_cat_col = NULL,
    rawData = NULL,
    phyloTemp = NULL,
    optionalData = NULL
  )

  observe({
    if (!is.null(input$mainFiles) && !is.null(input$optionalFiles)) {
      main_exts <- tools::file_ext(input$mainFiles$name)
  if (all(main_exts == "txt")) {
        validation_result <- validateOptionalFiles(input$mainFiles, input$optionalFiles)
        if (!validation_result$valid) {
          showEnhancedWarning(
            validation_result$message,
            title = "File Compatibility Warning"
          )
        } else {
          showEnhancedSuccess(
            "Bracken and Kraken files are compatible",
            title = "Files Compatible"
          )
        }
      }
    }
  })
  output$fileValidationStatus <- renderUI({
    if (!is.null(input$mainFiles) && !is.null(input$optionalFiles)) {
      main_exts <- tools::file_ext(input$mainFiles$name)
  if (all(main_exts == "txt")) {
        validation_result <- validateOptionalFiles(input$mainFiles, input$optionalFiles)
        if (!validation_result$valid) {
          div(
            class = "alert alert-warning",
            style = "padding: 8px 12px; margin: 0; font-size: 0.9rem;",
            HTML(paste0(
              "<i class='fas fa-exclamation-triangle me-2'></i>",
              "<strong>File Compatibility Issue:</strong> ", validation_result$message
            ))
          )
        } else {
          div(
            class = "alert alert-success",
            style = "padding: 8px 12px; margin: 0; font-size: 0.9rem;",
            HTML("<i class='fas fa-check-circle me-2'></i><strong>Files are compatible</strong> - Ready to process")
          )
        }
      }
    } else if (!is.null(input$mainFiles)) {
      main_exts <- tools::file_ext(input$mainFiles$name)
  if (all(main_exts == "txt")) {
        div(
          class = "alert alert-info",
          style = "padding: 8px 12px; margin: 0; font-size: 0.9rem;",
          HTML("<i class='fas fa-info-circle me-2'></i>Main files uploaded. Add Bracken files if available.")
        )
      }
    }
  })
  observe({
    if (!is.null(input$mainFiles) && !is.null(input$metadataFile)) {
      main_exts <- tools::file_ext(input$mainFiles$name)
      if (all(main_exts == "txt")) {
        tryCatch({
          txt_files <- input$mainFiles[main_exts == "txt", ]
          meta_info <- validateTxtReports(txt_files, input$metadataFile)
          if (!is.null(meta_info)) {
            showEnhancedSuccess(
              "Metadata is compatible with uploaded files",
              title = "Metadata Compatible"
            )
          }
        }, error = function(e) {
        })
      }
    }
  })

  observeEvent(input$loadDemoBtn, {
    withProgress(message = "Loading DEMO data...", value = 0, {
      incProgress(0.3, detail = "Finding demo file...")
      
      # Function to find demo data file
      find_demo_file <- function() {
        # Primary strategy: Use system.file to locate example data within helpers
        # Since example/ is now in inst/helpers/example/, it will be included in package installation
        demo_path <- system.file("helpers", "example", "example_data.rds", package = "puduapp")
        if (nzchar(demo_path) && file.exists(demo_path)) {
          return(normalizePath(demo_path))
        }
        
        # Fallback strategy: Try local development mode via PUDUAPP_LOCAL_APP_DIR
        if (exists("PUDUAPP_LOCAL_APP_DIR", envir = .GlobalEnv)) {
          local_base <- get("PUDUAPP_LOCAL_APP_DIR", envir = .GlobalEnv)
          # PUDUAPP_LOCAL_APP_DIR points to inst/app, helpers is sibling
          candidate <- file.path(dirname(local_base), "helpers", "example", "example_data.rds")
          if (file.exists(candidate)) {
            return(normalizePath(candidate))
          }
        }
        
        # Additional fallback: Hardcoded development location
        dev_candidate <- "/Users/alejandromedaglia/Documents/dev_workflows/shiny_final/test_shiny/inst/helpers/example/example_data.rds"
        if (file.exists(dev_candidate)) {
          return(dev_candidate)
        }
        
        return(NULL)
      }
      
      demo_file <- find_demo_file()
      
      incProgress(0.3, detail = "Loading demo data...")
      
      # Check if file exists
      if (is.null(demo_file) || !file.exists(demo_file)) {
        showEnhancedError(
          paste0(
            "Demo data file not found. Searched in multiple locations.<br><br>",
            "<strong>Current working directory:</strong> ", getwd(), "<br>",
            "<strong>Expected location:</strong> example/example_data.rds (relative to project root)"
          ),
          title = "Demo Data Not Found"
        )
        return()
      }
      
      result <- tryCatch({
        # Load the RDS file
        demo_data <- readRDS(demo_file)
        
        incProgress(0.2, detail = "Processing demo data...")
        
        # Create a temporary file structure to reuse processRDSFile
        temp_file_info <- data.frame(
          name = "example_data.rds",
          datapath = demo_file,
          stringsAsFactors = FALSE
        )
        
        # Process using existing RDS handler
        output <- processRDSFile(temp_file_info)
        
        if (is.null(output)) {
          showEnhancedError("Failed to process demo data.", title = "Processing Failed")
          return()
        }
        
        incProgress(0.1, detail = "Saving processed data...")
        
        # Store in appData
        appData$fileType <- "rds"
        appData$processedData <- output$processed
        appData$metaData <- output$metadata
        appData$rawData <- output$raw
        appData$phyloseqData <- output$phylo
        appData$reportType <- NULL
        
        # Notify UI that data has been loaded
        session$sendCustomMessage(type = 'dataLoaded', message = list(loaded = TRUE))
        
        incProgress(0.1, detail = "Complete!")
        
        # Show success message
        showNotification(
          ui = div(
            style = "background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; padding: 15px; border-radius: 8px;",
            HTML(paste0(
              "<div style='display: flex; align-items: center;'>",
              "<i class='fas fa-check-circle' style='font-size: 24px; margin-right: 12px;'></i>",
              "<div>",
              "<strong style='font-size: 16px;'>DEMO Data Loaded Successfully!</strong><br>",
              "<span style='font-size: 14px; opacity: 0.9;'>Example phyloseq dataset ready for analysis</span>",
              "</div>",
              "</div>"
            ))
          ),
          type = "message",
          duration = 5
        )
        
      }, error = function(e) {
        showEnhancedError(
          paste("An error occurred while loading demo data:", e$message),
          title = "Loading Error"
        )
        return(NULL)
      })
    })
  })

  observeEvent(input$processBtn, {

    if (is.null(input$mainFiles)) {
      showModal(modalDialog(
        title = "Missing Main Files",
  "Please upload main files (Kraken reports or phyloseq object) before processing.",
        footer = modalButton("OK"),
        easyClose = TRUE
      ))
      return()
    }

    files <- input$mainFiles
  file_exts <- tools::file_ext(files$name)

    if (!checkFileConflicts(file_exts) || !requireMetadata(file_exts, input$metadataFile)) {
      return()
    }

  if (all(file_exts == "txt") && !is.null(input$optionalFiles)) {
      validation_result <- validateOptionalFiles(input$mainFiles, input$optionalFiles)
      if (!validation_result$valid) {
        showModal(modalDialog(
          title = "File Compatibility Error",
          HTML(paste0(
            "<div style='color: #d32f2f; margin-bottom: 15px;'>",
            "<i class='fas fa-exclamation-triangle' style='margin-right: 8px;'></i>",
            "<strong>Bracken and Kraken files do not match</strong>",
            "</div>",
            "<p>", validation_result$message, "</p>",
            "<div style='background-color: #f5f5f5; padding: 10px; border-radius: 5px; margin-top: 15px;'>",
            "<strong>Requirements:</strong><br>",
            "• Same number of Bracken and Kraken files<br>",
            "• Identical sample names (before underscore)<br>",
            "• Valid Bracken format with 'new_est_reads' column",
            "</div>"
          )),
          footer = modalButton("OK"),
          easyClose = TRUE
        ))
        return()
      }
    }

  if (all(file_exts == "txt")) {
      txt_files <- files[file_exts == "txt", ]
      meta_info <- validateTxtReports(txt_files, input$metadataFile)
      if (is.null(meta_info)) {
        return()
      }
    }

    withProgress(message = "Processing files...", value = 0, {
      incProgress(0.2, detail = "Validating files...")
      result <- tryCatch({
        if (any(file_exts == "rds")) {
          appData$fileType <- "rds"
          rds_files <- files[file_exts == "rds", ]
          output <- processRDSFile(rds_files)
          incProgress(0.5, detail = "Processed RDS file")
          showFileUploadSuccess("Phyloseq object")
        } else if (all(file_exts == "txt")) {
          appData$fileType <- "txt"
          txt_files <- files[file_exts == "txt", ]

          meta_info <- validateTxtReports(txt_files, input$metadataFile)
          if (is.null(meta_info)) {
            showEnhancedError("Could not parse the uploaded metadata file or text reports. Please check file formats and try again.")
            return()
          }
          incProgress(0.4, detail = "Processing Kraken reports...")
          output <- processKrakenFiles(txt_files, meta_info$metadata, meta_info$basenames)
          kraken_data <- output$raw[, c("tax_ID", "domain")]
          appData$reportType <- "kraken"
          showFileUploadSuccess("Kraken reports", length(txt_files$name))

          if (!is.null(input$optionalFiles)) {
            incProgress(0.1, detail = "Processing Bracken files...")
            bracken_output <- processBrackenFiles(input$optionalFiles, meta_info$metadata, meta_info$basenames, kraken_data)
            if (!is.null(bracken_output)) {
              output <- bracken_output
              appData$reportType <- "bracken"
              showFileUploadSuccess("Bracken reports", length(input$optionalFiles$name))
            }
          }
        } else {
          showEnhancedError("Please upload supported file types only: .rds (phyloseq objects) or .txt (Kraken/Bracken reports).")
          return()
        }

        if (is.null(output)) {
          showEnhancedError("Data processing failed. Please check your files and try again.", title = "Processing Failed")
          return()
        }

        incProgress(0.1, detail = "Saving data")
        appData$processedData <- output$processed
        appData$metaData <- output$metadata
        appData$rawData <- output$raw
        appData$phyloseqData <- output$phylo
        
        # Notify UI that data has been loaded
        session$sendCustomMessage(type = 'dataLoaded', message = list(loaded = TRUE))
      }, error = function(e) {
        showEnhancedError(paste("An error occurred while processing your files:", e$message), title = "Processing Error")
        return(NULL)
      })
      incProgress(1.0, detail = "Complete!")
    })
  })
  observeEvent(input$clearDataBtn, {
    # Show confirmation modal
    showModal(modalDialog(
      title = "Confirm Clear Data",
      "Are you sure you want to clear all uploaded files and reset the application? This action cannot be undone.",
      footer = tagList(
        modalButton("Cancel"),
        actionButton("confirmClearBtn", "Yes, Clear Data", class = "btn-danger")
      ),
      easyClose = TRUE
    ))
  })
  observeEvent(input$confirmClearBtn, {
    appData$upsetPlot <- NULL
    appData$currentPlot <- NULL
    appData$alphaPlot <- NULL
    appData$betaPlot <- NULL
    appData$taxonomicPlot <- NULL
    appData$taxonomicPlotData <- NULL
    appData$lastValidUpsetSelection <- NULL
    appData$processedData <- NULL
    appData$reportType <- NULL
    appData$metaData <- NULL
    appData$fileType <- NULL
    appData$phyloseqData <- NULL
    appData$betaCalc <- NULL
    appData$bd_cat_col <- NULL
    appData$rawData <- NULL
    appData$phyloTemp <- NULL
    appData$optionalData <- NULL

    session$sendCustomMessage(type = 'resetFileInputs', message = list(
      inputs = c('mainFiles', 'metadataFile', 'optionalFiles')
    ))
    
    # Notify UI that data has been cleared
    session$sendCustomMessage(type = 'dataLoaded', message = list(loaded = FALSE))

    removeModal()

    showDataClearSuccess()
  })


  output$metric_selectors <- renderUI({
    req(appData$processedData)

    metrics <- unique(appData$processedData$diversity_metric)
    tagList(
      h4("Select Diversity Metrics"),
      checkboxGroupInput("selected_metrics", 
                         label = NULL, 
                         choices = metrics,
                         selected = metrics[1])
    )
  })

  violinSafeColumns <- reactive({
    req(appData$metaData)
    get_violin_safe_columns(appData$metaData)
  })

  observe({
    req(violinSafeColumns())
    updateSelectInput(session, "alpha_viocolor", choices = violinSafeColumns())
    updateSelectInput(session, "alpha_boxgroup", choices = violinSafeColumns())
  })

  output$showTaxFilterControls <- reactive({
    appData$fileType == "txt" && appData$reportType == "kraken"
  })

  output$showDomainFilterControls <- reactive({
    appData$fileType == "txt"
  })

  outputOptions(output, "showDomainFilterControls", suspendWhenHidden = FALSE)
  outputOptions(output, "showTaxFilterControls", suspendWhenHidden = FALSE)

  output$showfilterBeta <- reactive({
    appData$fileType == "rds"
  })

  outputOptions(output, "showfilterBeta", suspendWhenHidden = FALSE)

  observeEvent(c(appData$processedData, input$taxLevel), {
    req(appData$fileType)

    if (appData$fileType == "rds") {
      req(appData$phyloseqData, appData$metaData)

      appData$phyloTemp <- prepare_phyloseq_temp(appData$phyloseqData, appData$metaData)
    }
  })

  observeEvent(
    c(appData$processedData, input$tax_rank_filter, appData$reportType, appData$fileType), 
    {
      req(appData$rawData, appData$reportType, appData$metaData)

      if (appData$fileType == "txt") {
        result <- process_beta_diversity(
          data = appData$rawData,
          metadata = appData$metaData,
          tax_filter = input$tax_rank_filter        
          )

        if (is.null(result)) {
          appData$betaCalc <- NULL
          return()
        }

        appData$betaCalc <- result$data
        appData$bd_cat_col <- result$categorical_cols
      } else {
        appData$betaCalc <- NULL
      }
    }
  )

  observe({
    req(appData$fileType)
    req(appData$metaData)

    if (appData$fileType == "txt") { 

      updateSelectInput(session, "alphaGroup",
                      choices = colnames(appData$metaData),
                      selected = colnames(appData$metaData)[1])

      updateSelectInput(session, "colorAlpha",
                      choices = colnames(appData$metaData),
                      selected = colnames(appData$metaData)[1])

      updateSelectInput(session, "taxaGroup",
                      choices = colnames(appData$metaData),
                      selected = colnames(appData$metaData)[1])

    } else if (appData$fileType == "rds") {
      req(appData$phyloseqData)
      updateSelectInput(session, "alphaGroup",
                        choices = colnames(appData$metaData),
                        selected = colnames(appData$metaData)[1])

      updateSelectInput(session, "colorAlpha",
                        choices = colnames(appData$metaData),
                        selected = colnames(appData$metaData)[1])

      updateSelectInput(session, "taxaGroup",
                        choices = colnames(appData$metaData),
                        selected = colnames(appData$metaData)[1])

      }
})

  observe({
    req(appData$fileType)
    req(appData$metaData)

    if (appData$fileType == "txt") {
      req(appData$betaCalc)
      beta <- appData$betaCalc
      catcol <- appData$bd_cat_col

      beta_cols <- ncol(appData$metaData) - 1
      beta_group_cols <- c(colnames(beta)[1],tail(colnames(beta), beta_cols))

      updateSelectInput(session, "betaOrdination",
                        choices = c("PCoA", "MDS", "NMDS"),
                        selected = "NMDS")
      updateSelectInput(session, "shapeBy_bd", 
                        choices = c(catcol, "None"),
                        selected = "None")
      updateSelectInput(session, "betaGroup",
                        choices = beta_group_cols)
    } else if (appData$fileType == "rds") {
      req(appData$phyloseqData)
      updateSelectInput(session, "betaOrdination",
                        choices = c("PCoA", "NMDS", "CCA", "RDA", "DCA", "MDS"),
                        selected = "NMDS")
      updateSelectInput(session, "shapeBy_bd", 
                        choices = c(colnames(sample_data(appData$phyloseqData)), "None"),
                        selected = "None")
      updateSelectInput(session, "betaGroup",
                        choices = colnames(sample_data(appData$phyloseqData)))
      updateSelectInput(session, "labelGroup",
                        choices = c(colnames(sample_data(appData$phyloseqData)), "None"))
    }
  })

  observe({
    req(appData$fileType)

    if (appData$fileType == "rds") {
      req(appData$phyloTemp)
      tax_levels <- unique(appData$phyloTemp$tax_rank_full)
    } else if (appData$fileType == "txt") {
      req(appData$rawData)
      tax_levels <- unique(appData$rawData$tax_rank_full)
    } else {
      return()
    }

    tax_levels <- sort(tax_levels[!tax_levels %in% c("Unclassified", "Root")])
    sorted_ranks <- REAL_TAX_ORDER[REAL_TAX_ORDER %in% tax_levels]

    updateSelectInput(session, "tax_rank_filter", choices = sorted_ranks, selected = sorted_ranks[1])
    updateSelectInput(session, "taxLevel", choices = sorted_ranks, selected = sorted_ranks[1])
    updateSelectInput(session, "upset_rank", choices = sorted_ranks, selected = sorted_ranks[1])
  })

  observe({
    req(appData$fileType)
    if (appData$fileType == "rds") {
      req(appData$phyloTemp)
      sample_choices <- unique(appData$phyloTemp$sample_name)
    } else if (appData$fileType == "txt") {
      req(appData$rawData)
      sample_choices <- unique(appData$rawData$sample_name)
    } else {
      return()
    }

    updateCheckboxGroupInput(session, "selectedSamples",
                             choices = sample_choices,
                             selected = head(sample_choices, 2))
  })

  observeEvent(input$selectedSamples, {
    if (length(input$selectedSamples) < 2) {
      showEnhancedError("Please select at least two samples to generate the UpSet plot.")
      updateCheckboxGroupInput(session, "selectedSamples", selected = appData$lastValidUpsetSelection)
    } else {
      appData$lastValidUpsetSelection <- input$selectedSamples
    }
  })

  observe({
    req(appData$rawData)
    domain_choices <- sort(unique(na.omit(appData$rawData$domain)))

    updateSelectInput(session, "domainFilter",
                      choices = c("All", domain_choices),
                      selected = "All")

    updateSelectInput(session, "domainFilterShared",
                      choices = c("All", domain_choices),
                      selected = "All")
  })

  binaryMatrix <- reactive({
    req(appData$fileType, input$upset_rank, input$selectedSamples)

    dt <- get_taxa_data(appData$fileType, appData$phyloTemp, appData$rawData)
    if (is.null(dt)) return(NULL)

    if (!is.null(input$domainFilterShared) && input$domainFilterShared != "All" && "domain" %in% colnames(dt)) {
      dt <- dt[dt$domain == input$domainFilterShared,]
    }

    create_binary_matrix(dt, input$upset_rank, input$selectedSamples)
  })

  output$upsetPlot <- renderPlot({
    p <- render_upset_plot(binaryMatrix(), input$selectedSamples)
    req(p)
    appData$upsetPlot <- p
    p
  })

  output$sharedTaxaList <- renderDT({
    render_shared_taxa_table(binaryMatrix(), input$selectedSamples)
  })

  output$betaPlot <- renderPlotly({
    req(appData$fileType, appData$metaData)

    shape_group <- if (input$shapeBy_bd == "None") NULL else input$shapeBy_bd
    color_group <- if (isTRUE(input$use_color_beta)) input$betaGroup else NULL
    label_group <- if (isTRUE(input$use_labels_beta) && input$labelGroup != "None") input$labelGroup else NULL

    if (appData$fileType == "rds") {
      req(appData$phyloseqData, input$betaOrdination, input$dotSize_bd)

      p <- generate_phyloseq_beta_plot(
        phyloseq_obj = appData$phyloseqData,
        method = input$betaOrdination,
        dot_size = input$dotSize_bd,
        color = color_group,
        shape = shape_group,
        label = label_group
      )

    } else {
      if (is.null(appData$betaCalc)) {
        return(ggplotly(empty_plot_with_message("Beta diversity calculation requires at least 3 samples.")))
      }

      ord_data <- appData$betaCalc

      p <- switch(
        input$betaOrdination,
        "PCoA" = {
          if (!all(c("Axis.1", "Axis.2") %in% colnames(ord_data))) {
            return(ggplotly(empty_plot_with_message("PCoA only produced one axis — cannot display 2D plot.")))
          }
          plot_ordination_generic(ord_data, "Axis.1", "Axis.2", "PCoA Plot (Bray-Curtis)",
                                  color_col = color_group, shape_col = shape_group,
                                  dot_size = input$dotSize_bd, show_labels = input$use_labels_beta)
        },
        "MDS" = plot_ordination_generic(ord_data, "MDS1", "MDS2", "MDS Plot",
                                        color_col = color_group, shape_col = shape_group,
                                        dot_size = input$dotSize_bd, show_labels = input$use_labels_beta),
        "NMDS" = plot_ordination_generic(ord_data, "NMDS1", "NMDS2", "NMDS Ordination (Bray-Curtis)",
                                         color_col = color_group, shape_col = shape_group,
                                         dot_size = input$dotSize_bd, show_labels = input$use_labels_beta)
      )
    }

    appData$betaPlot <- p
    appData$currentPlot <- p

    plotly_obj <- ggplotly(p) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = c("sendDataToCloud", "editInChartStudio"),
        toImageButtonOptions = list(
          format = "png",
          filename = "beta_diversity_plot",
          scale = 2
        )
      )

    plotly_obj
  })

  output$taxPlot <- renderPlotly({
    req(appData$fileType, input$taxLevel)

    data <- if (appData$fileType == "txt") appData$rawData else appData$phyloTemp
    req(data)

    if (!is.null(input$domainFilter) && input$domainFilter != "All" && "domain" %in% colnames(data)) {
      data <- data[data$domain == input$domainFilter,]
    }

    p <- generate_taxonomic_plot(
      data = data,
      tax_level = input$taxLevel,
      taxa_group = input$taxaGroup,
      show_legend = input$showLegend,
      filter_top = input$filterTop,
      top_n = input$numAb
    )

    # Store the processed data used for the plot
    processed_data <- data[tax_rank_full == input$taxLevel]
    processed_data <- processed_data[!is.na(get(input$taxaGroup))]
    processed_data[, tot := sum(clade_reads), by = sample_name]
    processed_data[, rel_abundance := (clade_reads / tot) * 100]
    plot_data <- processed_data[, .(mean_abundance = sum(rel_abundance)), by = c(input$taxaGroup, "tax_name")]
    
    if (input$filterTop) {
      top_taxa <- plot_data[, .(total = sum(mean_abundance)), by = tax_name][order(-total)][1:input$numAb, tax_name]
      plot_data <- plot_data[tax_name %in% top_taxa]
    }
    
    appData$taxonomicPlotData <- plot_data
    appData$taxonomicPlot <- p
    appData$currentPlot <- p

    plotly_obj <- ggplotly(p) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = c("sendDataToCloud", "editInChartStudio"),
        toImageButtonOptions = list(
          format = "png",
          filename = "taxonomic_distribution_plot",
          scale = 2
        )
      )

    plotly_obj
  })

    output$alphaPlotOutput <- renderPlotly({
    req(appData$processedData, input$selected_metrics, input$dotSize_alpha)


    data <- data.table::as.data.table(appData$processedData)



    filtered_data <- data[data$diversity_metric %in% input$selected_metrics,]

    p <- generate_alpha_plot(filtered_data, input)
    appData$alphaPlot <- p
    appData$currentPlot <- p

    plotly_obj <- ggplotly(p) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = c("sendDataToCloud", "editInChartStudio"),
        toImageButtonOptions = list(
          format = "png",
          filename = "alpha_diversity_plot",
          scale = 2
        )
      )

    plotly_obj
  })

  output$downloadPlot <- downloadHandler(
    filename = function() {
      tab <- input$main_nav
      date <- Sys.Date()

      switch(
        tab,
        "Alpha Diversity" = paste0("alpha_diversity_", date, ".png"),
        "Beta Diversity" = paste0("beta_diversity_", input$betaOrdination, "_", date, ".png"),
        "Taxonomic Distribution" = paste0("taxonomic_distribution_", input$taxLevel, "_", date, ".png"),
        paste0("plot_", date, ".png")  # fallback
      )
    },
    content = function(file) {
      tab <- input$main_nav

      plot_to_save <- switch(
        tab,
        "Alpha Diversity" = appData$alphaPlot,
        "Beta Diversity" = appData$betaPlot,
        "Taxonomic Distribution" = appData$taxonomicPlot,
        appData$currentPlot  
      )

      if (!is.null(plot_to_save)) {
        save_ggplot(plot_to_save, file)
      } else {
        save_ggplot(appData$currentPlot, file)
      }
    }
  )

  output$downloadAlphaPlot <- downloadHandler(
    filename = function() {
      paste0("alpha_diversity_", Sys.Date(), ".png")
    },
    content = function(file) {
      if (!is.null(appData$alphaPlot)) {
        save_ggplot(appData$alphaPlot, file)
      }
    }
  )

  output$downloadBetaPlot <- downloadHandler(
    filename = function() {
      method <- if (!is.null(input$betaOrdination)) input$betaOrdination else "ordination"
      paste0("beta_diversity_", method, "_", Sys.Date(), ".png")
    },
    content = function(file) {
      if (!is.null(appData$betaPlot)) {
        save_ggplot(appData$betaPlot, file)
      }
    }
  )

  output$downloadTaxonomicPlot <- downloadHandler(
    filename = function() {
      level <- if (!is.null(input$taxLevel)) input$taxLevel else "composition"
      paste0("taxonomic_distribution_", level, "_", Sys.Date(), ".png")
    },
    content = function(file) {
      if (!is.null(appData$taxonomicPlot)) {
        save_ggplot(appData$taxonomicPlot, file)
      }
    }
  )
  
  output$downloadTaxonomicData <- downloadHandler(
    filename = function() {
      level <- if (!is.null(input$taxLevel)) input$taxLevel else "composition"
      group <- if (!is.null(input$taxaGroup)) input$taxaGroup else "group"
      paste0("taxonomic_data_", level, "_by_", group, "_", Sys.Date(), ".csv")
    },
    content = function(file) {
      if (!is.null(appData$taxonomicPlotData)) {
        # Prepare data with proper column names
        download_data <- copy(appData$taxonomicPlotData)
        
        # Get the actual column names (first is grouping variable, second is tax_name)
        col_names <- colnames(download_data)
        group_var <- col_names[1]
        
        # Create descriptive column names
        new_names <- c(
          paste0("Grouping_Variable_", group_var),
          "Taxon_Name", 
          "Mean_Relative_Abundance_Percent"
        )
        setnames(download_data, new_names)
        
        # Round abundance values for readability
        download_data[, Mean_Relative_Abundance_Percent := round(Mean_Relative_Abundance_Percent, 3)]
        
        # Write to CSV
        fwrite(download_data, file, row.names = FALSE)
      }
    }
  )

  output$downloadUpsetPlot <- downloadHandler(
    filename = function() {
      paste0("upset_plot_", Sys.Date(), ".png")
    },
    content = function(file) {
      save_upset_plot(appData$upsetPlot, file)
    }
  )

  output$downloadSharedTaxa <- downloadHandler(
    filename = function() {
      paste0("shared_taxa_", Sys.Date(), ".csv")
    },
    content = function(file) {
      generate_shared_taxa_csv(binaryMatrix(), input$selectedSamples, file)
    }
  )

  output$downloadBinaryMatrix <- downloadHandler(
    filename = function() {
      paste0("binary_matrix_", Sys.Date(), ".csv")
    },
    content = function(file) {
      generate_binary_matrix_csv(binaryMatrix(), input$selectedSamples, file)
    }
  )


  output$metadataAvailable <- reactive({
    !is.null(appData$metaData) && nrow(appData$metaData) > 0
  })
  outputOptions(output, "metadataAvailable", suspendWhenHidden = FALSE)

  output$alphaPlotAvailable <- reactive({
    !is.null(appData$alphaPlot)
  })
  outputOptions(output, "alphaPlotAvailable", suspendWhenHidden = FALSE)

  output$betaPlotAvailable <- reactive({
    !is.null(appData$betaPlot)
  })
  outputOptions(output, "betaPlotAvailable", suspendWhenHidden = FALSE)

  output$taxonomicPlotAvailable <- reactive({
    !is.null(appData$taxonomicPlot)
  })
  outputOptions(output, "taxonomicPlotAvailable", suspendWhenHidden = FALSE)

  output$sampleCount <- renderText({
    if (!is.null(appData$metaData)) {
      nrow(appData$metaData)
    } else {
      "0"
    }
  })

  output$variableCount <- renderText({
    if (!is.null(appData$metaData)) {
      ncol(appData$metaData)
    } else {
      "0"
    }
  })

  output$dataType <- renderText({
    if (!is.null(appData$fileType)) {
      switch(appData$fileType,
        "rds" = "Phyloseq (RDS)",
        "txt" = paste("Text files", if(!is.null(appData$reportType)) paste0("(", appData$reportType, ")") else ""),
        "Unknown"
      )
    } else {
      "Not available"
    }
  })

  observe({
    if (!is.null(appData$metaData)) {
      col_choices <- setNames(colnames(appData$metaData), colnames(appData$metaData))
      updateSelectInput(session, "selectedColumns", 
                       choices = col_choices)
    }
  })

  output$metadataTable <- renderDT({
    req(appData$metaData)

    metadata_to_show <- appData$metaData

    if (!isTRUE(input$showAllColumns) && !is.null(input$selectedColumns) && length(input$selectedColumns) > 0) {
      # Keep only selected columns that exist in the data
      valid_cols <- intersect(input$selectedColumns, colnames(metadata_to_show))
      if (length(valid_cols) > 0) {
        metadata_to_show <- metadata_to_show[, valid_cols, with = FALSE]
      }
    }

    page_length <- if(!is.null(input$rowsToShow)) input$rowsToShow else 25

    DT::datatable(
      metadata_to_show,
      options = list(
        pageLength = page_length,
        searchHighlight = TRUE,
        scrollX = TRUE,
        scrollY = "500px",
        scrollCollapse = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel'),
        columnDefs = list(
          list(className = 'dt-center', targets = "_all")
        )
      ),
      class = "table table-striped table-hover",
      rownames = FALSE,
      filter = 'none'
    ) %>%
      DT::formatStyle(columns = colnames(metadata_to_show), 
                     fontSize = '14px',
                     fontWeight = 'normal')
  })

  output$downloadMetadataCSV <- downloadHandler(
    filename = function() {
      paste0("metadata_", Sys.Date(), ".csv")
    },
    content = function(file) {
      req(appData$metaData)
      metadata_to_export <- appData$metaData
      if (!isTRUE(input$showAllColumns) && !is.null(input$selectedColumns)) {
        valid_cols <- intersect(input$selectedColumns, colnames(metadata_to_export))
        if (length(valid_cols) > 0) {
          metadata_to_export <- metadata_to_export[, valid_cols, with = FALSE]
        }
      }
      fwrite(metadata_to_export, file)
      showExportSuccess("Metadata", "CSV")
    }
  )

  output$downloadMetadataExcel <- downloadHandler(
    filename = function() {
      paste0("metadata_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      req(appData$metaData)
      metadata_to_export <- appData$metaData

      if (!isTRUE(input$showAllColumns) && !is.null(input$selectedColumns)) {
        valid_cols <- intersect(input$selectedColumns, colnames(metadata_to_export))
        if (length(valid_cols) > 0) {
          metadata_to_export <- metadata_to_export[, valid_cols, with = FALSE]
        }
      }

      metadata_df <- as.data.frame(metadata_to_export)

      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "Metadata")
      openxlsx::writeData(wb, "Metadata", metadata_df, startRow = 1, startCol = 1, rowNames = FALSE)

      header_style <- openxlsx::createStyle(
        fontColour = "white",
        fgFill = "#007bff",
        textDecoration = "bold",
        border = "bottom"
      )
      openxlsx::addStyle(wb, "Metadata", header_style, rows = 1, cols = 1:ncol(metadata_df))

      openxlsx::setColWidths(wb, "Metadata", cols = 1:ncol(metadata_df), widths = "auto")

      openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
      showExportSuccess("Metadata", "Excel")
    }
  )
}