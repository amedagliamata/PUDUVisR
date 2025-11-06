# Create modules/file_upload_module.R
fileUploadUI <- function(id) {
  ns <- NS(id)
  card(
    fileInput(ns("mainFiles"), "Upload Kraken report(s) or phyloseq object (.txt or .rds)", 
              multiple = TRUE, accept = c(".rds", ".txt")),
    fileInput(ns("metadataFile"), "Upload metadata file", accept = c(".txt", ".tsv")),
    fileInput(ns("optionalFiles"), "Optional: Upload Bracken reports", 
              multiple = TRUE, accept = c(".txt")),
    actionButton(ns("processBtn"), "Process reports", class = "btn-primary")
  )
}