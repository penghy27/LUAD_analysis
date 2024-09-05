# The script is find out disease stage information from nonsmokers and smokers

# load the packages tools
library(readr)
library(dplyr)

# Define the function to process data
process_data <- function(data_path, phe_path, smoking_status, age_range=c(20, 75),
                         race_filter = NULL) {
  # Import data
  lung_mut <- read_tsv(data_path)
  lung_phe <- read_tsv(phe_path)
  
  # Filter phenotype data based on smoking status, gender, age, and race
  filtered_phe <- lung_phe %>% 
    filter(
           tobacco_smoking_history %in% smoking_status,
           gender.demographic == "female", 
           age_at_index.demographic > age_range[1] & age_at_index.demographic < age_range[2])
  
  if (!is.null(race_filter)) {
    filtered_phe <- filtered_phe %>%
      filter(race.demographic %in% race_filter)
  }
  
  filtered_phe <- filtered_phe %>%
    mutate(Sample_ID = submitter_id.samples)
  
  # Join phenotype and mutation data by Sample ID
  merged_data <- merge(lung_mut, filtered_phe, by = "Sample_ID")
  
  # Filter mutations where FILTER == "PASS"
  filtered_data <- merged_data %>% 
    filter(filter == "PASS")
  
  # Number of unique participants
  num_participants <- n_distinct(filtered_data$Sample_ID)
  print(paste("Number of unique participants:", num_participants))
  
  # Extract disease stage information for these participants
  disease_stage <- lung_phe %>% 
    filter(submitter_id.samples %in% merged_data$Sample_ID) %>% 
    select(submitter_id.samples, tumor_stage.diagnoses) %>% 
    group_by(tumor_stage.diagnoses) %>% 
    summarize(count = n())
  
  print(disease_stage)
  
  return(list(filtered_data = filtered_data, disease_stage = disease_stage))
  
}


# Define the file paths
data_path = "~/TCGA-LUAD.mutect2_snv.tsv"
phe_path = "~/TCGA-LUAD.GDC_phenotype.tsv"

# Female nonsmoker with age between 20 and 75
nonsmoker_results <- process_data(
  data_path = mut_path,
  phe_path = phe_path,
  smoking_status = 1, # non-smoker
  )

# Female non-smokers with specific races with age between 20 and 75
race_filter = c("asian", "black or african american", "white")
smoker_results <- process_data(
  data_path = mut_path,
  phe_path = phe_path,
  smoking_status = 1, # non-smokers
  race_filter = race_filter
)

# Female smokers with specific races with age between 20 and 75
race_filter = c("asian", "black or african american", "white")
smoking_status = c(2, 3, 4, 5)

smoker_results <- process_data(
  data_path = mut_path,
  phe_path = phe_path,
  smoking_status = smoking_status, # smokers
  race_filter = race_filter
)

