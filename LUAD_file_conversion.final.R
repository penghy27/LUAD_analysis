# load the packages tools
library(readr)
library(dplyr)

# Define the function to convert the files
convert_files <- function(data_path, phe_path, gender = "female",
                          smoking_status = 1, age = c(20, 75),
                          tsv_output_dir, vcf_output_dir, 
                          vcf_extension = "vcf") {
  
  # Import data
  lung_mut <- read_tsv(data_path)
  lung_phe <- read_tsv(phe_path)
  
  # Filtered phenotype based on smoking status, gender, age
  filtered_phe <- lung_phe %>% 
    filter(tobacco_smoking_history %in% smoking_status &
           gender.demographic == gender &
           age_at_index.demographic > age[1] & 
           age_at_index.demographic < age[2] ) %>% 
    select(submitter_id.samples, age_at_index.demographic, gender.demographic,
           race.demographic, tobacco_smoking_history) %>% 
    mutate(Sample_ID = submitter_id.samples) # Add Sample_ID column for merging later
  
  # Join lung_mut and filtered_phe by Sample_ID
  merged_data <- merge(lung_mut, filtered_phe, by = "Sample_ID")
  
  # Part 1: Extract necessary information from tsv file, and write to individual's tsv file
  # Filter mutations where FILTER == "PASS" and add necessary columns
  merged_data <- merged_data %>% 
    filter(filter == "PASS") %>% 
    mutate(ID = ".", QUAL=".", INFO = ".") %>%  # Add columns ID, QUAL, INFO
    select(Sample_ID, chrom, start, ID, ref, alt, QUAL, filter, INFO) %>% # Select the required columns
    rename(`#CHROM` = chrom, POS= start, 
           REF = ref, ALT = alt, FILTER = filter)   # Rename column names
     
  # Split data with the same sample_ID
  split_data <- split(merged_data, merged_data$Sample_ID)
  
  # Write each subset of data to an individual TSV file
  for (id in names(split_data)) {
    # revise ID, change "-" to "_"，remove space " "
    modified_id <- gsub("-", "_", id)
    modified_id <- gsub(" ", "", modified_id)
    
    # remove Sample_ID column
    split_data[[id]]$Sample_ID <- NULL
    
    # Create TSV file name
    file_name <- file.path(tsv_output_dir, paste0(modified_id, ".tsv"))
    
    # Write TSV file
    write_tsv(split_data[[id]], file = file_name)
  }
  
  # Part 2: Convert TSV files to VCF files by copying with a new extension
  
  # Convert TSV files to VCF files by copying with a new extension
  tsv_files <- list.files(tsv_output_dir, pattern = "*.tsv", full.names = TRUE)
  
  # Iterate over each TSV file to create VCF files
  for (tsv_file in tsv_files) {
    # use new name and extension (vcf)
    vcf_file <- file.path(vcf_output_dir, sub("\\.tsv$", paste0(".", vcf_extension), basename(tsv_file)))
    
    # copy files and become VCF files  
    file.copy(tsv_file, vcf_file, overwrite = TRUE) 
  }
  
  # Return the list of processed files
  return(list(tsv_files = tsv_files, vcf_files = list.files(vcf_output_dir, pattern = paste0("*.", vcf_extension), full.names = TRUE)))

}

# Example usage of the function
mut_path <- "~/TCGA-LUAD.mutect2_snv.tsv"
phe_path <- "~/TCGA-LUAD.GDC_phenotype.tsv"
tsv_output_dir <- "~/Desktop/TCGA_tsv"
vcf_output_dir <- "~/Desktop/TCGA_vcf"

# Call the function
convert_files(mut_path, phe_path, gender = "female", smoking_status = 1, 
                         age = c(20, 75), tsv_output_dir = tsv_output_dir, vcf_output_dir = vcf_output_dir, 
                         vcf_extension = "vcf")

