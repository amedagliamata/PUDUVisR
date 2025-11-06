#' Generic Ordination Plot
#'
#' Creates a customizable scatter plot for ordination data with optional 
#' color coding, shape mapping, and sample labels.
#'
#' @param df Data frame containing ordination coordinates and metadata
#' @param x_col Character string specifying the column name for x-axis
#' @param y_col Character string specifying the column name for y-axis
#' @param plot_title Character string for the plot title
#' @param color_col Optional character string for color mapping column
#' @param shape_col Optional character string for shape mapping column
#' @param dot_size Numeric value for point size (default: 3)
#' @param show_labels Logical indicating whether to show sample labels
#' @return ggplot object
#' @export
plot_ordination_generic <- function(df, x_col, y_col, plot_title,
                                    color_col = NULL, shape_col = NULL,
                                    dot_size = 3, show_labels = FALSE) {

  aes_args <- list(
    x = as.name(x_col),
    y = as.name(y_col),
    text = as.name("sample_name")
  )

  filter_vars <- c(x_col, y_col)

  if (!is.null(color_col)) {
    aes_args$color <- as.name(color_col)
    filter_vars <- c(filter_vars, color_col)
  }
  if (!is.null(shape_col)) {
    aes_args$shape <- as.name(shape_col)
    filter_vars <- c(filter_vars, shape_col)
  }

  df <- df[complete.cases(df[, filter_vars, drop = FALSE]), ]

  p <- ggplot(df, do.call(aes, aes_args)) +
    geom_point(size = dot_size, alpha = 0.8) +
    ggtitle(plot_title) +
    theme_bw() +
    theme(
      strip.background = element_rect(fill = "lightblue"),
      plot.title = element_text(hjust = 0.5, size = 14, margin = margin(b = 20)),
      plot.margin = margin(t = 30, r = 15, b = 15, l = 15),
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.x = element_text(margin = margin(t = 20)),
      axis.title.y = element_text(margin = margin(r = 10))
    )

  if (isTRUE(show_labels)) {
    p <- p + ggrepel::geom_text_repel(aes_string(label = "sample_name"),
                                      size = 3, max.overlaps = 100)
  }

  return(p)
}

#' Create Empty Plot with Message
#'
#' Creates an empty ggplot with a centered message, typically used for
#' displaying error messages or informational text when data is unavailable.
#'
#' @param msg Character string containing the message to display
#' @return ggplot object with centered message
#' @export
empty_plot_with_message <- function(msg) {

  ggplot() + 
    annotate("text", x = 0.5, y = 0.5, label = msg, size = 10, hjust = 0.5, vjust = 0.5, color = "red", fontface = "bold") +
    theme_void() +
    theme(
      panel.border = element_blank(),
      axis.line = element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      plot.background = element_blank(),
      panel.grid = element_blank()
    )
}

#' Create Alpha Diversity Scatter Plot
#'
#' Generates a scatter plot for alpha diversity data with faceting by
#' diversity metric and optional color coding.
#'
#' @param data Data table containing alpha diversity data
#' @param group_var Character string specifying the grouping variable for x-axis
#' @param color_var Optional character string for color mapping
#' @param dot_size Numeric value for point size (default: 3)
#' @param selected_metrics Character vector of selected diversity metrics (currently unused)
#' @return ggplot object
#' @export
create_scatter_plot <- function(data, group_var, color_var = NULL, dot_size = 3, selected_metrics = NULL) {


  filter_vars <- group_var
  if (!is.null(color_var)) {
    filter_vars <- c(filter_vars, color_var)
  }

  data <- data[complete.cases(data[, ..filter_vars])]

  p <- ggplot(data, aes_string(x = group_var, y = "idx")) +
    geom_point(size = dot_size) +
    facet_wrap(~ diversity_metric, scales = "free_y") +
    theme_bw() +
    labs(title = "Alpha Diversity Scatter Plot",
         y = "Alpha Diversity Index",
         x = gsub("_", " ", group_var)) +
    theme(
      strip.background = element_rect(fill = "lightblue"),
      plot.title = element_text(
        hjust = 0.5,
        size = 14,                    
        margin = margin(b = 20)     
      ),
      plot.margin = margin(t = 30, r = 15, b = 15, l = 15),
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.x = element_text(margin = margin(t = 20)),
      axis.title.y = element_text(margin = margin(r = 10))
    )

  if (!is.null(color_var)) {
    p <- p + aes_string(color = color_var)
  }
  return(p)
}

create_violin_plot <- function(data, group_var, color_var = NULL, selected_metrics = NULL) {
  validate(need(group_var != "", "No metadata selected for grouping."))

  filter_vars <- group_var
  if (!is.null(color_var)) {
    filter_vars <- c(filter_vars, color_var)
  }

  data <- data[complete.cases(data[, ..filter_vars])]

  p <- ggplot(data, aes_string(x = group_var, y = "idx")) +
    geom_violin(trim = FALSE) +
    facet_wrap(~ diversity_metric, scales = "free_y") +
    theme_bw() + 
    labs(title = "Alpha Diversity Violin Plot",
         y = "Alpha Diversity Index",
         x = gsub("_", " ", group_var)) +
    theme(
      strip.background = element_rect(fill = "lightblue"),
      plot.title = element_text(
        hjust = 0.5,
        size = 14,                    
        margin = margin(b = 20)     
      ),
      plot.margin = margin(t = 30, r = 15, b = 15, l = 15),
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.x = element_text(margin = margin(t = 20)),
      axis.title.y = element_text(margin = margin(r = 10))
    )

  if (!is.null(color_var)) {
    p <- p + aes_string(color = color_var)
  }
  return(p)
}

create_box_plot <- function(data, group_var, color_var = NULL, selected_metrics = NULL) {
  validate(need(group_var != "", "No metadata selected for grouping."))

  filter_vars <- group_var
  if (!is.null(color_var)) {
    filter_vars <- c(filter_vars, color_var)
  }

  data <- data[complete.cases(data[, ..filter_vars])]

  p <- ggplot(data, aes_string(x = group_var, y = "idx")) +
    geom_boxplot(outlier.shape = NA, alpha = 0.8) +
    geom_jitter(width = 0.2, alpha = 0.6, size = 1) +
    theme_bw() +
    facet_wrap(~ diversity_metric, scales = "free_y") +
    labs(
      title = "Alpha Diversity Box Plot",
      y = "Alpha Diversity Index",
      x = gsub("_", " ", group_var)
    ) +
    theme(
      strip.background = element_rect(fill = "lightblue"),
      plot.title = element_text(
        hjust = 0.5,
        size = 14,                    
        margin = margin(b = 20)     
      ),
      plot.margin = margin(t = 30, r = 15, b = 15, l = 15), 
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title.x = element_text(margin = margin(t = 20)),
      axis.title.y = element_text(margin = margin(r = 10))
    )

  if (!is.null(color_var)) {
    p <- p + aes_string(color = color_var)
  }

  return(p)
}

#' Generate Alpha Diversity Plot
#'
#' Main function to generate alpha diversity plots based on user input.
#' Dispatches to appropriate plotting function based on selected plot type.
#'
#' @param data Data table containing alpha diversity data
#' @param input Shiny input object containing plot parameters
#' @param dot_size Optional numeric value for dot size (overrides input)
#' @return ggplot object or NULL if invalid plot type
#' @export
generate_alpha_plot <- function(data, input, dot_size = NULL) {
  plot_type <- input$alphaPlotType

  if (plot_type == "scatter") {
    color_var <- if (isTRUE(input$use_color_sc)) input$colorAlpha else NULL
    return(create_scatter_plot(data, input$alphaGroup, color_var, input$dotSize_alpha, input$selected_metrics))

  } else if (plot_type == "violin") {
    color_var <- if (isTRUE(input$use_color_vi)) input$alpha_viocolor else NULL
    return(create_violin_plot(data, input$alpha_viocolor, color_var, input$selected_metrics))

  } else if (plot_type == "box") {
    color_var <- if (isTRUE(input$use_color_box)) input$alpha_boxgroup else NULL
    return(create_box_plot(data, input$alpha_boxgroup, color_var, input$selected_metrics))
  }

  return(NULL)
}

#' Generate Taxonomic Composition Plot
#'
#' Creates a stacked bar plot showing taxonomic composition and relative
#' abundance at a specified taxonomic level.
#'
#' @param data Data table containing taxonomic abundance data
#' @param tax_level Character string specifying taxonomic level to plot
#' @param taxa_group Character string specifying grouping variable
#' @param show_legend Logical indicating whether to show legend (default: TRUE)
#' @param filter_top Logical indicating whether to filter to top N taxa (default: FALSE)
#' @param top_n Integer specifying number of top taxa to show (default: 20)
#' @return ggplot object
#' @export
generate_taxonomic_plot <- function(data, tax_level, taxa_group, show_legend = TRUE, filter_top = FALSE, top_n = 20) {

  data <- data[tax_rank_full == tax_level]
  data <- data[!is.na(get(taxa_group))]
  data[, tot := sum(clade_reads), by = sample_name]
  data[, rel_abundance := (clade_reads / tot) * 100]

  data <- data[, .(mean_abundance = sum(rel_abundance)), by = c(taxa_group, "tax_name")]

  if (filter_top) {
    top_taxa <- data[, .(total = sum(mean_abundance)), by = tax_name][order(-total)][1:top_n, tax_name]
    data <- data[tax_name %in% top_taxa]
  }

  legend_pos <- if (show_legend) "right" else "none"

  p <- ggplot(data, aes(x = .data[[taxa_group]], y = mean_abundance, fill = tax_name)) +
    geom_bar(stat = "identity", position = "stack", color = "black", linewidth = 0.2) +
    coord_flip() +
    theme_minimal() +
    labs(title = paste(tax_level, "-Level Abundance by", taxa_group),
         x = taxa_group,
         y = "Mean Relative Abundance (%)",
         fill = "Taxon") +
    theme(axis.text.y = element_text(size = 10),
          legend.position = legend_pos)

  return(p)
}
generate_phyloseq_beta_plot <- function(phyloseq_obj, method, dot_size = 3, color = NULL, shape = NULL, label = NULL) {

  wh0 <- genefilter_sample(phyloseq_obj, filterfun_sample(function(x) x > 5), A = 0.5 * nsamples(phyloseq_obj))
  phyloseq_filt <- prune_taxa(wh0, phyloseq_obj)

  ordu <- ordinate(phyloseq_filt, method = method, distance = "bray")

  p <- plot_ordination(phyloseq_filt, ordu, color = color, shape = shape) +
    geom_point(size = dot_size) +
    ggtitle("Beta Diversity Ordination")

  if (!is.null(label)) {
    p <- p + ggrepel::geom_text_repel(aes_string(label = label), size = 3, max.overlaps = 100)
  }

  return(p)
}

render_upset_plot <- function(bin_df, selected_samples) {
  if (is.null(bin_df) || nrow(bin_df) == 0 || length(selected_samples) == 0) return(NULL)

  p <- UpSetR::upset(bin_df,
                     nsets = length(selected_samples),
                     order.by = "freq")
  return(p)
}