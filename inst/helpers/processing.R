if (!exists("TAX_RANK_MAP")) {
  TAX_RANK_MAP <- c("G"="Genus", "P"="Phylum", "F"="Family", "C"="Class", 
                    "O"="Order", "S"="Species", "U"="Unclassified", 
                    "D"="Domain", "R"="Root", "K"="Kingdom")
}

aggregate_reads <- function(data) {
  data[, .(clade_reads = sum(clade_reads)), by = .(sample_name, tax_name)]
}

compute_abundance_matrix <- function(aggregated_data) {
  dcast(aggregated_data, sample_name ~ tax_name,
        value.var = "clade_reads",
        fill = 0,
        fun.aggregate = sum)
}

compute_ordination <- function(distance_matrix) {
  nmds <- vegan::metaMDS(distance_matrix, k = 2, trymax = 50)
  nmds_df <- as.data.frame(scores(nmds))
  nmds_df <- tibble::rownames_to_column(nmds_df, var = "sample_name")

  mds <- cmdscale(distance_matrix, k = 2, eig = TRUE)
  mds_df <- data.frame(sample_name = rownames(mds$points),
                       MDS1 = mds$points[,1],
                       MDS2 = mds$points[,2])

  pcoa_res <- ape::pcoa(distance_matrix)
  pcoa_df <- as.data.frame(pcoa_res$vectors)
  pcoa_df$sample_name <- rownames(pcoa_df)

  list(nmds_df = nmds_df, mds_df = mds_df, pcoa_df = pcoa_df)
}

merge_ordination_with_metadata <- function(ord_list, metadata) {
  Reduce(function(x, y) merge(x, y, by = "sample_name"),
         c(ord_list, list(metadata)))
}

get_taxa_data <- function(file_type, rds_data, txt_data) {
  if (file_type == "rds") {
    req(rds_data)
    return(rds_data)
  } else if (file_type == "txt") {
    req(txt_data)
    return(txt_data)
  } else {
    return(NULL)
  }
}

create_binary_matrix <- function(dt, upset_rank, selected_samples) {
  dt <- dt[tax_rank_full == upset_rank & sample_name %in% selected_samples]

  bin <- dcast(dt, tax_name ~ sample_name,
               fun.aggregate = function(x) as.integer(length(x) > 0),
               value.var = "sample_name")

  bin_df <- as.data.frame(bin)
  rownames(bin_df) <- bin_df$tax_name
  bin_df$tax_name <- NULL

  missing_samples <- setdiff(selected_samples, colnames(bin_df))
  for (s in missing_samples) {
    bin_df[[s]] <- 0
  }

  bin_df <- bin_df[, selected_samples, drop = FALSE]

  return(bin_df)
}

get_shared_taxa <- function(bin_df, selected_samples) {
  rowSums_matched <- rowSums(bin_df[, selected_samples, drop = FALSE] == 1)
  shared_taxa <- rownames(bin_df)[rowSums_matched == length(selected_samples)]
  shared_taxa
}

filter_tax_rank <- function(data, tax_rank_filter) {
    req(tax_rank_filter)
    data <- data[tax_rank_full == tax_rank_filter]
    data
}


#' Process RDS (Phyloseq) File
#'
#' Loads a phyloseq object from an RDS file and extracts alpha diversity metrics
#' and metadata for downstream analysis.
#'
#' @param rds_files Data frame containing file path of the RDS file
#' @return List containing phyloseq object, processed diversity data, and metadata
#' @export
processRDSFile <- function(rds_files) {
  if (nrow(rds_files) > 1) {
    showNotification("Please upload only one .rds file at a time", type = "warning")
    return(NULL)
  }
  phylo <- readRDS(rds_files$datapath[1])
  metadata <- as.data.table(microbiome::meta(phylo), keep.rownames = TRUE)

  alpha_div <- prune_species(speciesSums(phylo) > 0, phylo)
  alpha_div <- as.data.table(estimate_richness(phylo), keep.rownames = TRUE)
  alpha_div <- melt.data.table(alpha_div, id.vars = "rn", variable.name = "diversity_metric", value.name = "idx")

  final_data <- merge.data.table(alpha_div, metadata, by = "rn")
  setnames(metadata, "rn", "sample_name")
  setnames(final_data, "rn", "sample_name")

  list(phylo = phylo,processed = final_data, metadata = metadata, raw = NULL)
}

#' Process Bracken Files
#'
#' Processes Bracken report files and merges them with metadata and domain information
#' from Kraken data. Computes diversity metrics for the processed data.
#'
#' @param txt_files Data frame containing file paths and names of Bracken files
#' @param metadata Data table with sample metadata including 'sample_name' column
#' @param basenames Character vector of base file names for matching samples
#' @param kraken_data Data frame with taxonomic ID and domain information from Kraken
#' @return List containing processed diversity data, metadata, and raw taxonomic data
#' @export
processBrackenFiles <- function(txt_files, metadata, basenames, kraken_data) {
  # Using global constant TAX_RANK_MAP

  raw_list <- lapply(seq_len(nrow(txt_files)), function(i) {
    bracken_dt <- fread(txt_files$datapath[i])
    file_name <- basename(txt_files$name[i])
    sample_id <- sub("_.*", "", tools::file_path_sans_ext(file_name))

    bracken_dt[, sample_name := sample_id]
    setnames(bracken_dt, 
             c("name", "new_est_reads", "fraction_total_reads", "taxonomy_lvl", "taxonomy_id"),
             c("tax_name", "clade_reads", "rel_abundance", "tax_rank","tax_ID"))
    bracken_dt
  })

  raw_data <- rbindlist(raw_list)
  final_data <- raw_data[clade_reads > 0]
  raw_data <- unique(merge.data.table(raw_data, metadata, by = "sample_name"))
  raw_data[, tax_rank_full := TAX_RANK_MAP[tax_rank]]

  raw_data <- merge(raw_data, kraken_data, by = "tax_ID", all.x = TRUE)

  final_data <- computeDiversityMetrics(final_data)
  final_data <- melt.data.table(final_data, id.vars = "sample_name", 
                                variable.name = "diversity_metric", value.name = "idx")
  final_data <- unique(merge.data.table(final_data, metadata, by = "sample_name"))


  list(
    processed = final_data, 
    metadata = metadata, 
    raw = raw_data
  )
}

#' Process Kraken Files
#'
#' Processes Kraken2 report files, extracts taxonomic information, and computes
#' diversity metrics. Assigns domain information based on taxonomic hierarchy.
#'
#' @param txt_files Data frame containing file paths and names of Kraken files
#' @param metadata Data table with sample metadata including 'sample_name' column
#' @param basenames Character vector of base file names for matching samples
#' @return List containing processed diversity data, metadata, and raw taxonomic data
#' @export
processKrakenFiles <- function(txt_files, metadata, basenames) {

  raw_list <- lapply(seq_len(nrow(txt_files)), function(i) {
    kraken_dt <- fread(txt_files$datapath[i])
    file_name <- basename(txt_files$name[i])
    sample_id <- sub("_.*", "", tools::file_path_sans_ext(file_name))
    kraken_dt[, sample_name := sample_id]
    if (ncol(kraken_dt) == 7) {
      setnames(kraken_dt, colnames(kraken_dt)[1:6],
               c("rel_abundance", "clade_reads", "taxon_reads", "tax_rank", "tax_ID", "tax_name"))
    }
    kraken_dt[, domain := NA_character_]
    current_domain <- NA_character_
    for (j in seq_len(nrow(kraken_dt))) {
      if (kraken_dt$tax_rank[j] == "D") {
        current_domain <- kraken_dt$tax_name[j]
      }
      kraken_dt$domain[j] <- current_domain
    }

    kraken_dt
  })

  raw_data <- rbindlist(raw_list)
  if (!"clade_reads" %in% colnames(raw_data)) {
    showNotification("The 'clade_reads' column is missing in the Kraken reports.", type = "error")
    return(NULL)
  }

  final_data <- raw_data[clade_reads > 0 & tax_rank == "G"]
  raw_data <- unique(merge.data.table(raw_data, metadata, by = "sample_name"))
  raw_data[, tax_rank_full := TAX_RANK_MAP[tax_rank]]
  if (nrow(final_data) == 0) {
    showNotification("No valid data found in the Kraken reports (clade_reads column is empty or missing).", type = "error")
    return(NULL)
  }

  final_data <- computeDiversityMetrics(final_data)
  final_data <- melt.data.table(final_data, id.vars = "sample_name", variable.name = "diversity_metric", value.name = "idx")
  final_data <- unique(merge.data.table(final_data, metadata, by = "sample_name"))

  list(processed = final_data, metadata = metadata, raw = raw_data)
}

#' Compute Diversity Metrics
#'
#' Calculates alpha diversity indices including Shannon, Simpson, Inverse Simpson,
#' and Berger-Parker indices for each sample.
#'
#' @param dt Data table containing taxonomic abundance data with 'clade_reads' column
#' @return Data table with computed diversity metrics by sample
#' @export
computeDiversityMetrics <- function(dt) {
  dt[, c("s", "N", "p", "D") := .(
    .N,
    sum(clade_reads),
    clade_reads / sum(clade_reads),
    sum(clade_reads * (clade_reads - 1)) / (sum(clade_reads) * (sum(clade_reads) - 1))
  ), by = sample_name]

  dt[, c("shannon_idx", "BP", "simpson", "inv_simpson") := .(
    -sum(p * log(p)),
    max(p),
    1 - sum(p^2),
    1 / sum(p^2)
  ), by = sample_name]

  dt[, .(sample_name, shannon_idx, BP, simpson, inv_simpson)]
}

get_top_taxa <- function(phylo, top_n = 500) {
  top_taxa <- names(sort(taxa_sums(phylo), decreasing = TRUE))[1:top_n]
  prune_taxa(top_taxa, phylo)
}

make_otu_long <- function(phylo) {
  otu <- otu_table(phylo)

  if (!taxa_are_rows(otu)) {
    otu <- t(otu)
  }

  otu_mat <- as.data.table(as(otu, "matrix"), keep.rownames = "taxa")
  otu_long <- melt(otu_mat, id.vars = "taxa", variable.name = "sample_name", value.name = "clade_reads")

  # Keep only non-zero reads
  otu_long[clade_reads > 0]
}

make_tax_long <- function(phylo) {
  tax_df <- as.data.table(as(tax_table(phylo), "matrix"), keep.rownames = "taxa")
  tax_df <- melt(tax_df, id.vars = "taxa", variable.name = "tax_rank_full", value.name = "tax_name")
}

merge_and_aggregate <- function(otu_long, tax_long, metadata) {
  merged <- merge(otu_long, tax_long, by = "taxa", allow.cartesian = TRUE)
  merged <- merged[!is.na(tax_name) & tax_name != "" & clade_reads > 0]
  aggregated <- merged[, .(clade_reads = sum(clade_reads)), by = .(sample_name, tax_rank_full, tax_name)]
  merge(aggregated, metadata, by = "sample_name")
}

render_shared_taxa_table <- function(bin_df, selected_samples) {
  if (is.null(bin_df) || length(selected_samples) < 2) {
    return(DT::datatable(data.table(Message = "Not enough samples selected."),
                         options = list(dom = 't'),
                         rownames = FALSE))
  }

  shared_taxa <- get_shared_taxa(bin_df, selected_samples)

  if (length(shared_taxa) == 0) {
    return(DT::datatable(data.table(Message = "No shared taxa found."),
                         options = list(dom = 't'),
                         rownames = FALSE))
  } else {
    return(DT::datatable(data.table(`Shared Taxa` = shared_taxa),
                         options = list(pageLength = 10, searchHighlight = TRUE),
                         rownames = FALSE))
  }
}

process_beta_diversity <- function(data, metadata, tax_filter = NULL) {
  if (!is.null(tax_filter) && tax_filter != "") {
    data <- filter_tax_rank(data, tax_filter)
  }

  if (!validate_sample_count(data)) return(NULL)

  aggregated <- aggregate_reads(data)
  abundance_matrix <- compute_abundance_matrix(aggregated)
  abundance_matrix <- as.matrix(tibble::column_to_rownames(abundance_matrix, var = "sample_name"))

  bray_curtis <- vegan::vegdist(abundance_matrix, method = "bray")
  ord <- compute_ordination(bray_curtis)

  merged_df <- merge_ordination_with_metadata(ord, metadata)

  categorical_cols <- names(merged_df)[sapply(merged_df, function(col) is.factor(col) || is.character(col))]

  list(data = merged_df, categorical_cols = categorical_cols)
}

prepare_phyloseq_temp <- function(phyloseq_obj, metadata, top_n = 500) {
  phylo <- phyloseq_obj #|> get_top_taxa(top_n = top_n)

  otu_long <- make_otu_long(phylo)
  tax_long <- make_tax_long(phylo)

  aggregated <- merge_and_aggregate(otu_long, tax_long, metadata)

  return(aggregated)
}

#' Prepare Metadata for Display
#'
#' Cleans and prepares metadata for display in the metadata viewer tab.
#' Handles both phyloseq and text file metadata formats.
#'
#' @param metadata Data table containing metadata
#' @param file_type Character indicating file type ("rds" or "txt")
#' @return Cleaned data table ready for display
#' @export
prepare_metadata_for_display <- function(metadata, file_type = NULL) {
  if (is.null(metadata) || nrow(metadata) == 0) {
    return(NULL)
  }

  # Make a copy to avoid modifying original data
  meta_display <- data.table::copy(metadata)

  # Clean up column names - replace dots and underscores with spaces, capitalize
  clean_names <- function(names) {
    names %>%
      gsub("_", " ", .) %>%
      gsub("\\.", " ", .) %>%
      tools::toTitleCase(.)
  }

  # Apply name cleaning
  setnames(meta_display, colnames(meta_display), clean_names(colnames(meta_display)))

  # Round numeric columns to reasonable precision
  numeric_cols <- sapply(meta_display, is.numeric)
  if (any(numeric_cols)) {
    meta_display[, (names(which(numeric_cols))) := lapply(.SD, function(x) round(x, 4)), 
                 .SDcols = names(which(numeric_cols))]
  }

  # Convert logical columns to Yes/No for better readability
  logical_cols <- sapply(meta_display, is.logical)
  if (any(logical_cols)) {
    meta_display[, (names(which(logical_cols))) := lapply(.SD, function(x) ifelse(x, "Yes", "No")), 
                 .SDcols = names(which(logical_cols))]
  }

  # Limit character columns to reasonable length for display
  char_cols <- sapply(meta_display, is.character)
  if (any(char_cols)) {
    meta_display[, (names(which(char_cols))) := lapply(.SD, function(x) {
      ifelse(nchar(x) > 50, paste0(substr(x, 1, 47), "..."), x)
    }), .SDcols = names(which(char_cols))]
  }

  return(meta_display)
}

#' Get Metadata Summary Statistics
#'
#' Generates summary statistics for metadata to display in the sidebar
#'
#' @param metadata Data table containing metadata
#' @return List with summary information
#' @export
get_metadata_summary <- function(metadata) {
  if (is.null(metadata) || nrow(metadata) == 0) {
    return(list(
      sample_count = 0,
      variable_count = 0,
      data_types = character(0),
      missing_data = 0
    ))
  }

  # Count different data types
  data_types <- sapply(metadata, class)
  type_summary <- table(sapply(data_types, function(x) x[1]))

  # Count missing values
  missing_count <- sum(is.na(metadata))
  total_cells <- nrow(metadata) * ncol(metadata)
  missing_percentage <- round((missing_count / total_cells) * 100, 1)

  list(
    sample_count = nrow(metadata),
    variable_count = ncol(metadata),
    data_types = type_summary,
    missing_data = missing_percentage,
    missing_count = missing_count,
    total_cells = total_cells
  )
}