# PUDUVisR: Metagenomics Analysis Visualization Tool

## Overview

PUDUVisR is an interactive R Shiny web application for analyzing and visualizing microbiome data from Kraken/Bracken reports or phyloseq objects. The application provides comprehensive tools for alpha diversity analysis, beta diversity visualization, taxonomic composition plots, and shared taxa analysis.

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

Install the package directly from GitHub using:

```r
devtools::install_github("amedagliamata/PUDUVisR")
```

## Usage

### Launch the Application
```r
library(PUDUVisR)
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
- **Phyloseq**: Phyloseq .rds format file with metadata embedded

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper documentation
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

For questions and support:
- Create an issue on GitHub
- Email: amedagliamata@gmail.com

## Version History

- **v0.1.0**: Initial release with core functionality