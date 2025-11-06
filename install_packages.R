options(repos = c(CRAN = 'https://cloud.r-project.org'))

install_if_missing <- function(pkgs) {
  to_install <- pkgs[!(pkgs %in% installed.packages()[, 'Package'])]
  if (length(to_install) > 0) {
    install.packages(to_install, dependencies = TRUE)
  }
}

desc <- read.dcf('/srv/shiny-server/test_shiny/DESCRIPTION')
imports <- unlist(strsplit(gsub('\n', ' ', desc[1, 'Imports']), ','))
imports <- trimws(imports)
imports <- gsub(',.*$', '', imports) # safety

cran_pkgs <- imports
install_if_missing(cran_pkgs)

if (!is.null(desc[1, 'Additional_repositories']) && grepl('bioconductor', desc[1, 'Additional_repositories'], ignore.case = TRUE)) {
  if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager')
  # Known Bioconductor packages used by the app
  bioc_pkgs <- c('phyloseq', 'microbiome', 'vegan')
  bioc_to_install <- bioc_pkgs[!(bioc_pkgs %in% installed.packages()[, 'Package'])]
  if (length(bioc_to_install) > 0) BiocManager::install(bioc_to_install, ask = FALSE)
}

if (!requireNamespace('remotes', quietly = TRUE)) install.packages('remotes')

cat('Package installation finished')
