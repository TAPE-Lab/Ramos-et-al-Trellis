###############################
# Runs the splitRtools pipeline 
# On SPLiT-seq experiments PDO_21 and PDO_27
# Visit the github link for README and docs
###############################

# load devtools
library(devtools)

# download required packages from bioconductor if needed for first time
if (!require("BiocManager", quietly = TRUE))
install.packages("BiocManager")
BiocManager::install(c("zellkonverter", "scater", "ShortRead", "DropletUtils"))

# download and install splitRtools from github
devtools::install_github("https://github.com/TAPE-Lab/splitRtools")

# Load splitRtools
library(splitRtools)

# Set WD
setwd("~/PATH")

### RUN PDO-21 data
# specify raw reads per sublibrary
read_df_21 =  data.frame(sl_name = c('exp013_p21_s4', 'exp013_p21_s5'), reads = c(1220258423, 869989398))

# Run the splitRtool pipeline
# Each sublibrary is contained within its own folder in the data_folder folder and must contain zUMIs output, named by sublib name.
run_split_pipe(mode = 'single', # Process sublibs individually
               n_sublibs = 2, # How many to sublibraries are present
               data_folder = "~/PATH/pdo_21_sublib_data/", # Location of zUMIs data directory
               output_folder = "~/PATH/split_tools_pdo21_outputs/", # Output folder path
               filtering_mode = "manual", # Filter by knee (standard) or manual value (default 1000) transcripts
               filter_value = 500,
               count_reads = FALSE,
               total_reads = read_df_21,
               fastq_path = NA, # Path to folder containing subibrary raw FastQ
               rt_bc = "~/PATH/barcode_layout/barcodes_v2_48.csv", # RT barcode map
               lig_bc = "~/PATH/barcode_layout/barcodes_v1.csv", # Ligation barcode map
               sample_map = "~/PATH/barcode_layout/exp013_cell_metadata.xlsx" # RT plate layout file
)

### RUN PDO-27 data
# specify raw reads per sublibrary
reads_df_27 =  data.frame(sl_name = c('exp013_p27_s4', 'exp013_p27_s5'), reads = c(1041593427, 1083652637))

# Run the splitRtool pipeline
# Each sublibrary is contained within its own folder in the data_folder folder and must contain zUMIs output, named by sublib name.
run_split_pipe(mode = 'single', # Merge sublibraries or process seperately
               n_sublibs = 2, # How many to sublibraries are present
               data_folder = "~/PATH/pdo_27_sublib_data/", # Location of zUMIs data directory
               output_folder = "~/PATH/split_tools_pdo27_outputs/", # Output folder path
               filtering_mode = "manual", # Filter by knee (standard) or manual value (default 1000) transcripts
               filter_value = 500,
               count_reads = FALSE,
               total_reads = reads_df_27,
               fastq_path = NA, # Path to folder containing subibrary raw FastQ
               rt_bc = "~/PATH/barcode_layout/barcodes_v2_48.csv", # RT barcode map
               lig_bc = "~/PATH/barcode_layout/barcodes_v1.csv", # Ligation barcode map
               sample_map = "~/PATH/barcode_layout/exp013_cell_metadata.xlsx" # RT plate layout file
)
