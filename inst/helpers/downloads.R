#' Generate Binary Matrix CSV Download
#'
#' Creates a CSV file containing the binary presence/absence matrix for 
#' selected samples. Used for UpSet plot data export.
#'
#' @param bin_df Data frame containing binary matrix data
#' @param selected Character vector of selected sample names
#' @param file Character string specifying output file path
#' @return None (writes file to disk)
#' @export
generate_binary_matrix_csv <- function(bin_df, selected, file) {
  if (is.null(bin_df) || length(selected) < 2) {
    write.csv(data.frame(Message = "Not enough samples selected."), file, row.names = FALSE)
  } else {
    mat <- bin_df[, selected, drop = FALSE]
    write.csv(cbind(Taxon = rownames(mat), mat), file, row.names = FALSE)
  }
}

#' Generate Shared Taxa CSV Download
#'
#' Creates a CSV file containing taxa that are shared across all selected
#' samples. Exports the results of shared taxa analysis.
#'
#' @param bin_df Data frame containing binary matrix data
#' @param selected Character vector of selected sample names
#' @param file Character string specifying output file path
#' @return None (writes file to disk)
#' @export
generate_shared_taxa_csv <- function(bin_df, selected, file) {
  if (is.null(bin_df) || length(selected) < 2) {
    write.csv(data.frame(Message = "Not enough samples selected."), file, row.names = FALSE)
    return()
  }

  shared_taxa <- get_shared_taxa(bin_df, selected)
  if (length(shared_taxa) == 0) {
    write.csv(data.frame(Message = "No shared taxa found."), file, row.names = FALSE)
  } else {
    write.csv(data.frame(Shared_Taxa = shared_taxa), file, row.names = FALSE)
  }
}

#' Save UpSet Plot to PNG File
#'
#' Saves an UpSet plot object to a PNG file with specified dimensions.
#' Handles the special plotting requirements for UpSetR plots.
#'
#' @param plot_obj UpSet plot object from UpSetR package
#' @param file Character string specifying output file path
#' @param width Numeric value for plot width in pixels (default: 1200)
#' @param height Numeric value for plot height in pixels (default: 800)
#' @param res Numeric value for plot resolution (default: 150)
#' @return None (saves plot to disk)
#' @export
save_upset_plot <- function(plot_obj, file, width = 1200, height = 800, res = 150) {
  req(plot_obj)  # Ensure the plot exists
  png(file, width = width, height = height, res = res)

  dev.off()
}

#' Save ggplot to File
#'
#' Saves a ggplot object to a file using ggsave with specified dimensions
#' and resolution. Used for downloading plots from the application.
#'
#' @param plot ggplot object to save
#' @param file Character string specifying output file path
#' @param width Numeric value for plot width in inches (default: 8)
#' @param height Numeric value for plot height in inches (default: 6)
#' @param dpi Numeric value for dots per inch resolution (default: 300)
#' @return None (saves plot to disk)
#' @export
save_ggplot <- function(plot, file, width = 8, height = 6, dpi = 300) {
  req(plot)
  ggsave(file, plot = plot, width = width, height = height, dpi = dpi)
}