# The script is find out treatment info from nonsmokers and smokers

# load the packages tools
library(readr)
library(dplyr)

# import data
lung_mut <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.mutect2_snv.tsv")
lung_phe <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.GDC_phenotype.tsv")


# The distribution of races in female nonsmokers with 20 < age < 75
female_nonsmokers <- lung_phe %>% 
  filter(tobacco_smoking_history==1,
         gender.demographic == "female", 
         age_at_index.demographic > 20 & age_at_index.demographic < 75) %>%
  mutate(Sample_ID = submitter_id.samples)


# Join two data frame, lung_mut and female_nonsmoker, by Sample_ID
merged_data_nonsmokers <- merge(lung_mut, female_nonsmoker, by = "Sample_ID")


# Filter the FILTER == "PASS"
merged_data <- merged_data_nonsmokers %>% 
  filter(filter=="PASS")
# The number of unique participants
n_distinct(merged_data$Sample_ID) # 37 unique ID/participants


# Go back to lung_phe to extract these 37 subjects' Disease stage infomation
nonsmokers_stage <- lung_phe %>% 
  filter(submitter_id.samples %in% merged_data$Sample_ID) %>% 
  select(submitter_id.samples, tumor_stage.diagnoses) %>% 
  group_by(tumor_stage.diagnoses) %>% 
  summarize(count = n())

print(nonsmokers_stage)


# Select Smokers: Asian, Black/African American, White
female_smokers <- lung_phe %>% 
  filter(tobacco_smoking_history !=1,
         gender.demographic == "female",
         race.demographic %in% c("asian", "black or african american", "white"),
         age_at_index.demographic > 20 & age_at_index.demographic < 75) %>% 
  mutate(Sample_ID = submitter_id.samples)


# Join two data frame, lung_mut and female_smokers, by Sample_ID
merged_data_smokers <- merge(lung_mut, female_smokers, by = "Sample_ID")


# Filter the FILTER == "PASS"
merged_data_smokers <- merged_data_smokers %>% 
  filter(filter=="PASS")
# The number of unique participants
n_distinct(merged_data_smokers$Sample_ID) # 158 unique ID/participants


# Find Asia smokers without Age Limitation
asian_smokers_phe <- smokers_phe %>% 
  filter(tobacco_smoking_history !=1,
         gender.demographic == "female",
          race.demographic == "asian") %>% # only 4 Asian smokers 
  rename(Sample_ID = submitter_id.samples)

# merged lung_mut and asian_smokers_phe
merged_asian_smokers <- merge(lung_mut, asian_smokers_phe, by="Sample_ID") 
# n_distinct(merged_asian_smokers$Sample_ID) # >>> 3 asian subject left


# Go back to lung_phe to extract these 4 Asian subjects' Disease stage infomation
lung_phe %>% 
  filter(submitter_id.samples %in% asian_smokers_phe$Sample_ID) %>% 
  select(submitter_id.samples, age_at_index.demographic, tumor_stage.diagnoses)
