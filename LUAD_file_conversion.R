# load the packages tools
library(readr)
library(dplyr)

# import data
lung_mut <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.mutect2_snv.tsv")
lung_phe <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.GDC_phenotype.tsv")

# Obtain female non-smoking participants
fem_noSmoke <- lung_phe %>% 
  filter(tobacco_smoking_history==1 & gender.demographic == "female" &
         age_at_index.demographic > 20 & age_at_index.demographic < 75) %>%
  select(submitter_id.samples, age_at_index.demographic, gender.demographic, 
         race.demographic, tobacco_smoking_history)

# Join two data frame by Sample_ID
fem_noSmoke <- fem_noSmoke %>% 
  mutate(Sample_ID = submitter_id.samples)
# merge data from lung_mut, fem_noSmoke
merged_data <- merge(lung_mut, fem_noSmoke, by = "Sample_ID")


# Double check Sample_ID with alternative apporoache below!
# Obtain the mutate info of female non-smoking participants
#fem_mutate <- lung_mut %>% 
  #filter(Sample_ID %in% fem_noSmoke$submitter_id.samples)


# VCF FILES CONVERSION - PART 1

merged_data <- merged_data %>% 
  # Filter the FILTER == "PASS"
  filter(filter == "PASS") %>%  # only 53 participants "PASS" the criteria
  # Add columns ID, QUAL, INFO
  mutate(ID = ".", QUAL=".", INFO = ".") %>% 
  # Select the required columns
  select(Sample_ID, chrom, start, ID, ref, alt, QUAL, filter, INFO)  

# Rename column names
merged_data <- rename(merged_data, `#CHROM` = chrom, POS= start, REF = ref, ALT = alt, FILTER = filter)    


# Split data with the same sample_ID
split_data <- split(merged_data, merged_data$Sample_ID)


# Put same Sample_ID information to an individual TSV file
for (id in names(split_data)) {
  # revise ID, change "-" to "_"，remove space " "
  modified_id <- gsub("-", "_", id)
  modified_id <- gsub(" ", "", modified_id)
  
  # remove Sample_ID column
  split_data[[id]]$Sample_ID <- NULL
  
  # Write to TSV filte and named with ID
  file_name <- paste0(modified_id, ".tsv")
  write_tsv(split_data[[id]], file = file_name)
}

# VCF CONVERSION PART 2

# Folder Path
tsv_path <- "~/Desktop/Methylation/Lung/TCGA_tsv"
extension <- "vcf"

# Obtain all TSV files' path
tsv_files <- list.files(tsv_path, pattern = "*.tsv", full.names = TRUE)


# Iterate each file 
for (tsv_file in tsv_files) {
  # use new name and extension (vcf)
  vcf_file <- sub("\\.tsv$", paste0(".", extension), tsv_file)
  
  # copy files and become VCG files  
  file.copy(tsv_file, vcf_file, overwrite = TRUE)
}


