
APP_TITLE <- "PUDUApp - Microbiome Analysis"
APP_VERSION <- "v0.1.0"

NAV_DATA_UPLOAD <- "Data upload and previsualization"
NAV_ALPHA_DIVERSITY <- "Alpha Diversity"
NAV_BETA_DIVERSITY <- "Beta Diversity"
NAV_SHARED_TAXA <- "Shared Taxa"
NAV_TAXONOMIC_DISTRIBUTION <- "Taxonomic Distribution"

HEADER_FILE_UPLOAD <- "Report(s) and metadata data upload"
HEADER_PARAMETERS <- "Parameters"
HEADER_ALPHA_ANALYSIS <- "Alpha Diversity Analysis"
HEADER_BETA_ANALYSIS <- "Beta Diversity Analysis"
HEADER_UPSET_PLOT <- "UpSet Plot"
HEADER_TAXONOMIC_COMPOSITION <- "Taxonomic Composition"
HEADER_INFO_INSTRUCTIONS <- "Information and instructions"
HEADER_DATA_REQUIREMENTS <- "Data Requirements"

LABEL_MAIN_FILES <- "Upload Kraken report(s) or phyloseq object (.txt or .rds)"
LABEL_METADATA_FILE <- "Upload metadata file for kraken/bracken reports"
LABEL_OPTIONAL_FILES <- "Optional: Upload Bracken reports (must match Kraken samples)"
LABEL_PLOT_TYPE <- "Select Plot Type:"
LABEL_X_AXIS_SCATTER <- "X axis (Scatter):"
LABEL_X_AXIS_VIOLIN <- "X axis (Violin):"
LABEL_GROUP_BY_BOX <- "Group by (Box):"
LABEL_DOT_SIZE <- "Dot Size:"
LABEL_SET_DOT_COLOR <- "Set dot color"
LABEL_SET_VIOLIN_COLOR <- "Set violin color"
LABEL_SET_BOX_COLOR <- "Set box color"
LABEL_COLOR_BY <- "Color by:"
LABEL_ORDINATION_METHOD <- "Ordination Method:"
LABEL_SHAPE_BY <- "Shape by:"
LABEL_PRINT_LABELS <- "Print labels when saving the image"
LABEL_LABEL_BY <- "Label by:"
LABEL_COLOR_BY_GROUP <- "Color by Group"
LABEL_TAXONOMIC_LEVEL <- "Taxonomic Level:"
LABEL_FILTER_BY_DOMAIN <- "Filter by Domain"
LABEL_SELECT_TAXONOMIC_RANK <- "Select Taxonomic Rank:"
LABEL_SELECT_SAMPLES <- "Select Samples:"
LABEL_X_AXIS <- "X Axis:"
LABEL_FILTER_TOP_N <- "Filter Top N Taxa"
LABEL_SHOW_TOP_N <- "Show Top N Taxa:"
LABEL_SHOW_LEGEND <- "Show Legend"

BTN_PROCESS_REPORTS <- "Process reports"
BTN_DOWNLOAD_PLOT <- "Download Plot"
BTN_DOWNLOAD_UPSET <- "Download Plot"
BTN_DOWNLOAD_SHARED_TAXA <- "Download Shared Taxa"
BTN_DOWNLOAD_BINARY_MATRIX <- "Download Binary Matrix"

PLOT_TYPES <- list(
  "Scatter Plot" = "scatter",
  "Violin Plot" = "violin", 
  "Box Plot" = "box"
)

ORDINATION_METHODS_RDS <- c("PCoA", "NMDS", "CCA", "RDA", "DCA", "MDS")
ORDINATION_METHODS_TXT <- c("PCoA", "MDS", "NMDS")

TAXONOMIC_RANKS <- c("Phylum", "Class", "Order", "Family", "Genus", "Species")

APP_DESCRIPTION <- "This dashboard provides tools for analyzing and visualizing microbiome data, including:"

FEATURE_LIST <- list(
  "Alpha diversity analysis: Measures diversity within samples",
  "Beta diversity analysis: Compares diversity between samples", 
  "Shared Taxonomic Features: Creates upset plots for the shared taxonomic features",
  "Taxonomic composition: Plots relative abundance at selected taxonomic level"
)

DATA_REQUIREMENTS_TEXT <- "Upload '.rds' (for phyloseq data) or '.txt' Kraken/Bracken reports + metadata. 
Metadata must include a column 'sample_name' matching the base name of each file."

MSG_PHYLOSEQ_LOADED <- "📊 Phyloseq object loaded successfully"
MSG_KRAKEN_LOADED <- "📊 Kraken reports loaded successfully" 
MSG_BRACKEN_LOADED <- "📊 Bracken reports loaded successfully"

ERR_NO_MAIN_FILES <- "Main files are required to start processing."
ERR_FILE_CONFLICTS <- "Conflict in uploaded files or missing metadata for TXT files."
ERR_PROCESSING_FAILED <- "Processing failed or output was NULL."
ERR_METADATA_PARSE_FAILED <- "Failed to parse metadata or TXT reports."

ERR_MIXED_FILE_TYPES <- "You cannot upload both phyloseq (.rds) and text report files (.txt) at the same time. Please choose one format."
ERR_INSUFFICIENT_TXT_FILES <- "You must upload at least two Kraken/Bracken report files for analysis."
ERR_METADATA_REQUIRED <- "Metadata file is required when uploading multiple Kraken/Bracken reports. Please upload a metadata file with 'sample_name' column."
ERR_METADATA_MISSING_COLUMN <- "Could not find a 'sample_name' column in metadata that matches the file names"
ERR_METADATA_MISSING_SAMPLES <- "Missing samples in metadata:"
ERR_METADATA_EMPTY <- "Metadata file is empty or invalid"
ERR_NO_FILES_PROVIDED <- "No files provided for validation"
ERR_METADATA_FILE_INVALID <- "Metadata file path is invalid or file does not exist"
ERR_METADATA_FILE_EMPTY <- "Metadata file is empty. Please upload a valid metadata file."

ERR_INSUFFICIENT_SAMPLES_BETA <- "Beta diversity calculation requires at least 3 samples."
ERR_INSUFFICIENT_SAMPLES_UPSET <- "Please select at least two samples for the UpSet plot."
ERR_NO_CLADE_READS <- "The 'clade_reads' column is missing in the Kraken reports."
ERR_NO_VALID_DATA <- "No valid data found in the Kraken reports (clade_reads column is empty or missing)."
ERR_PCOA_ONE_AXIS <- "PCoA only produced one axis — cannot display 2D plot."

ERR_MIXED_KRAKEN_BRACKEN <- "Do not mix Kraken and Bracken reports. All the files should be the same format."
ERR_BRACKEN_COUNT_MISMATCH <- "The number of Bracken reports MUST match the Kraken reports uploaded."
ERR_SAMPLE_NAME_MISMATCH <- "Mismatch in sample names between Kraken and Bracken reports."
ERR_INVALID_BRACKEN_FORMAT <- "The following are not valid Bracken reports:"
ERR_UNSUPPORTED_FILE_TYPES <- "Unsupported file types. Upload either .rds or .txt files."

# ============================================================================
# WARNING MESSAGES
# ============================================================================

WARN_BETA_REQUIRES_SAMPLES <- "Beta diversity requires at least 3 samples. Skipping beta diversity computation."
WARN_ONE_RDS_FILE <- "Please upload only one .rds file at a time"

# ============================================================================
# PROGRESS MESSAGES
# ============================================================================

PROGRESS_PROCESSING <- "Processing files..."
PROGRESS_VALIDATING <- "Validating files..."
PROGRESS_RDS_PROCESSED <- "Processed RDS file"
PROGRESS_KRAKEN_PROCESSING <- "Processing Kraken reports..."
PROGRESS_BRACKEN_VALIDATION <- "Validating Bracken files"
PROGRESS_BRACKEN_PROCESSING <- "Processing Bracken files"
PROGRESS_SAVING_DATA <- "Saving data"
PROGRESS_COMPLETE <- "Complete!"

# ============================================================================
# TABLE HEADERS
# ============================================================================

TABLE_FILE_TYPE <- "File Type"
TABLE_FILE_NAME <- "File Name" 
TABLE_FILE_SIZE <- "File Size"
TABLE_UPLOADED_FILES <- "Uploaded files"
TABLE_NO_FILES <- "No files uploaded yet"
TABLE_MAIN_RDS <- "Main (.rds)"
TABLE_MAIN_TXT <- "Main (.txt)"
TABLE_METADATA <- "Metadata"
TABLE_OPTIONAL <- "Optional"

# ============================================================================
# PLOT TITLES
# ============================================================================

PLOT_ALPHA_SCATTER <- "Alpha Diversity Scatter Plot"
PLOT_ALPHA_VIOLIN <- "Alpha Diversity Violin Plot"
PLOT_ALPHA_BOX <- "Alpha Diversity Box Plot"
PLOT_BETA_ORDINATION <- "Beta Diversity Ordination"
PLOT_PCOA_BRAY <- "PCoA Plot (Bray-Curtis)"
PLOT_MDS <- "MDS Plot"
PLOT_NMDS_BRAY <- "NMDS Ordination (Bray-Curtis)"

# ============================================================================
# AXIS LABELS
# ============================================================================

AXIS_ALPHA_DIVERSITY <- "Alpha Diversity Index"
AXIS_MEAN_RELATIVE_ABUNDANCE <- "Mean Relative Abundance (%)"

# ============================================================================
# MISC CONSTANTS
# ============================================================================

NONE_OPTION <- "None"
ALL_OPTION <- "All"
DEFAULT_TOP_TAXA <- 20
MIN_DOT_SIZE <- 1
MAX_DOT_SIZE <- 10
DEFAULT_DOT_SIZE <- 3
FILE_SIZE_UNIT <- "kb"

format_file_size <- function(size_bytes) {
  paste(format(size_bytes/1024, digits = 2, nsmall = 2, trim = TRUE), FILE_SIZE_UNIT)
}

create_tax_level_title <- function(tax_level, group_var) {
  paste(tax_level, "-Level Abundance by", group_var)
}