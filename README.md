# PUDUApp: Metagenomics Analysis Visualization Tool

## Overview

PUDUApp is an interactive R Shiny web application for analyzing and visualizing microbiome data from Kraken/Bracken reports or phyloseq objects. The application provides comprehensive tools for alpha diversity analysis, beta diversity visualization, taxonomic composition plots, and shared taxa analysis.

## Features

### 📊 **Data Input Support**
- **Phyloseq objects** (.rds files)
- **Kraken reports** (.txt files) + metadata
- **Bracken reports** (.txt files) + metadata

### 🔍 **Analysis Capabilities**
- **Alpha Diversity Analysis**: Shannon, Simpson, Inverse Simpson indices
- **Beta Diversity Visualization**: PCoA, NMDS, MDS ordination plots
- **Taxonomic Composition**: Relative abundance plots at different taxonomic levels
- **Shared Taxa Analysis**: UpSet plots showing common taxa across samples

### 🎨 **Interactive Features**
- Multiple plot types (scatter, violin, box plots)
- Customizable colors, shapes, and sizes
- Domain filtering for focused analysis
- Downloadable plots and data tables

## Installation

### Prerequisites
- R >= 4.2.0
- macOS users: Xcode command line tools (`xcode-select --install`)
- Required R packages (automatically installed)

### Quick Installation

#### Method 1: Automated Installation (Recommended)
```r
# Download and run the installation script
source("install_puduapp.R")
```

#### Method 2: Simple Installation (If Method 1 fails)
```r
# Use the simple installation script
source("install_simple.R")
```

#### Method 3: Manual Installation (If automation fails)
```r
# Step 1: Install BiocManager
install.packages("BiocManager")

# Step 2: Install CRAN packages
install.packages(c("shiny", "plotly", "bslib", "ggplot2", "dplyr", 
                   "data.table", "UpSetR", "DT", "ggrepel", "vegan", "devtools"))

# Step 3: Install Bioconductor core dependencies
BiocManager::install(c("BiocGenerics", "S4Vectors", "IRanges", 
                       "GenomeInfoDb", "GenomeInfoDbData", "Biostrings"))

# Step 4: Install phyloseq and microbiome
BiocManager::install(c("phyloseq", "microbiome"))

# Step 5: Install PUDUApp
devtools::install_local(".", dependencies = FALSE)
```

### Installation Troubleshooting

If you encounter the error: `there is no package called 'GenomeInfoDbData'`, try:

1. **Update R**: Ensure you have R >= 4.2.0
2. **Update Bioconductor**:
   ```r
   BiocManager::install(version = "3.19", ask = FALSE, update = TRUE)
   ```
3. **Install dependencies step by step**:
   ```r
   # Core dependencies first
   BiocManager::install("BiocGenerics")
   BiocManager::install("S4Vectors")
   BiocManager::install("IRanges")
   BiocManager::install("GenomeInfoDbData")
   BiocManager::install("GenomeInfoDb")
   
   # Then phyloseq dependencies
   BiocManager::install("phyloseq")
   BiocManager::install("microbiome")
   ```

4. **For macOS users**:
   ```bash
   # Install Xcode command line tools
   xcode-select --install
   
   # If using Homebrew, update it
   brew update && brew upgrade
   ```

5. **Repository URL warnings** (macOS ARM64):
   If you see warnings like "unable to access index for repository https://bioconductor.org/packages/3.18/...", run:
   ```r
   source("fix_repositories.R")
   ```
   This warning is usually harmless and indicates that binary packages aren't available for your platform, but source packages will be used instead.

6. **Clear package cache and restart R**:
   ```r
   # Remove problematic packages and reinstall
   remove.packages("phyloseq")
   remove.packages("microbiome")
   
   # Restart R session, then reinstall
   BiocManager::install(c("phyloseq", "microbiome"))
   ```

### Verification

Test that installation worked:
```r
# Load key packages
library(puduapp)
library(phyloseq)
library(microbiome)

# Launch the app
run_app()
```

## Usage

### Launch the Application
```r
library(puduapp)
run_app()
```

### Data Requirements

#### For Kraken/Bracken Reports:
1. **Reports**: Upload Kraken (.txt) or Bracken (.txt) files
2. **Metadata**: Required file with column 'sample_name' matching base file names
3. **Optional**: Bracken files (must match Kraken samples exactly)

#### For Phyloseq Objects:
1. **Phyloseq Object**: Upload a single .rds file containing a phyloseq object

### Example Metadata Format
```
sample_name,group,condition,timepoint
sample1,control,healthy,day0
sample2,treatment,disease,day7
sample3,control,healthy,day14
```

## Application Workflow

### 1. **Data Upload & Validation**
- Upload your data files and metadata
- Validation checks ensure file compatibility
- Preview uploaded files information

### 2. **Alpha Diversity Analysis**
- Select diversity metrics (Shannon, Simpson, etc.)
- Choose plot types: scatter, violin, or box plots
- Customize colors and grouping variables

### 3. **Beta Diversity Visualization**
- Perform ordination analysis (PCoA, NMDS, MDS)
- Color and shape points by metadata variables
- Add sample labels and customize appearance

### 4. **Shared Taxa Analysis**
- Generate UpSet plots showing taxa intersection
- Select specific samples for comparison
- Download binary matrices and shared taxa lists

### 5. **Taxonomic Distribution**
- Visualize relative abundance at different taxonomic levels
- Filter by domain (Bacteria, Archaea, etc.)
- Show top N taxa or complete distributions

## File Structure
```
puduapp/
├── DESCRIPTION              # Package metadata
├── NAMESPACE               # Exported functions
├── README.md              # This file
├── install_puduapp.R      # Main installation script
├── install_simple.R       # Simple installation script
├── R/
│   └── run_app.R          # Main app launcher
├── inst/
│   ├── app/
│   │   ├── global.R       # Global constants and libraries
│   │   ├── ui.R          # User interface
│   │   └── server.R      # Server logic
│   └── helpers/
│       ├── plots.R       # Plot generation functions
│       ├── processing.R  # Data processing functions
│       ├── validation.R  # Input validation functions
│       └── downloads.R   # Download handlers
└── man/                  # Documentation
```

## Key Functions

### Data Processing
- `processKrakenFiles()`: Process Kraken report files
- `processBrackenFiles()`: Process Bracken report files  
- `processRDSFile()`: Load phyloseq objects
- `computeDiversityMetrics()`: Calculate alpha diversity indices

### Visualization
- `generate_alpha_plot()`: Create alpha diversity plots
- `generate_phyloseq_beta_plot()`: Generate beta diversity plots
- `generate_taxonomic_plot()`: Create taxonomic composition plots
- `render_upset_plot()`: Generate UpSet plots

### Validation
- `validateTxtReports()`: Validate report files and metadata
- `checkFileConflicts()`: Check for file type conflicts
- `validateOptionalFiles()`: Validate Bracken files against Kraken

## Troubleshooting

### Common Issues

**"Missing samples in metadata"**
- Ensure metadata 'sample_name' column matches file base names
- Check for typos in sample names

**"Beta diversity requires at least 3 samples"**
- Upload more samples or check data processing steps

**"Failed to parse metadata"**
- Verify metadata file format (tab or comma-separated)
- Ensure 'sample_name' column exists

**Installation Issues**
- Use Method 2 or 3 if automated installation fails
- Ensure R >= 4.2.0 and latest Bioconductor
- On macOS: Install Xcode command line tools

### Data Format Requirements
- **Kraken files**: Standard Kraken2 output format
- **Bracken files**: Standard Bracken output with 'new_est_reads' column
- **Metadata**: Tab or comma-separated with 'sample_name' header

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper documentation
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Citation

If you use PUDUApp in your research, please cite:
```
[Add appropriate citation information]
```

## Support

For questions and support:
- Create an issue on GitHub
- Email: [contact email]

## Version History

- **v0.1.0**: Initial release with core functionality