"The scripts: (1) summarized nonsmokers demographic information, such as races, nonsmoker/smoker counts,
nonsmoker/smoker race distribution...(2) subset subjects' infomation "

# load the packages tools
library(readr)
library(dplyr)

# import data
lung_mut <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.mutect2_snv.tsv")
lung_phe <- read_tsv("~/Desktop/methylation/lung/TCGA-LUAD.GDC_phenotype.tsv")


# # The distribution of races in smoker_noAgeLimit
# lung_phe %>% 
#   filter(tobacco_smoking_history !=1,
#          gender.demographic == "female", 
#   ) %>%
#   group_by(race.demographic) %>%
#   count() 


# # Select female nonsmoker/smoker particants without considering age limitation
# nonsmoker_noAgeLimit <- lung_phe %>%
#   filter(gender.demographic == "female") %>%
#   summarize(nonsmokers = sum(tobacco_smoking_history == 1, na.rm = TRUE),
#             smokers = sum(tobacco_smoking_history != 1, na.rm = TRUE),
#             na_count = sum(is.na(tobacco_smoking_history)))
# nonsmoker_noAgeLimit # 79 participants

# # The distribution of races in nonsmoker_noAgeLimit
# lung_phe %>% 
#   filter(tobacco_smoking_history==1,
#          gender.demographic == "female", 
#          ) %>%
#   group_by(race.demographic) %>%
#   count() 


# # Select female nonsmoker/smoker participants considering age limitation
# nonsmoker_AgeLimit <- lung_phe %>%
#   filter(gender.demographic == "female", age_at_index.demographic > 20 & age_at_index.demographic < 75) %>%
#   summarize(nonsmokers = sum(tobacco_smoking_history == 1, na.rm = TRUE),
#             smokers = sum(tobacco_smoking_history != 1, na.rm = TRUE),
#             na_count = sum(is.na(tobacco_smoking_history)))
# nonsmoker_AgeLimit # 58 participants


# The distribution of races in female nonsmokers with 20 < age < 75
lung_phe %>% 
  filter(tobacco_smoking_history==1,
         gender.demographic == "female", 
         age_at_index.demographic > 20 & age_at_index.demographic < 75) %>%
  group_by(race.demographic) %>%
  count()
  

# Join two data frame by Sample_ID
fem_noSmoke <- fem_noSmoke %>% 
  mutate(Sample_ID = submitter_id.samples)
# merge data from lung_mut, fem_noSmoke
merged_data <- merge(lung_mut, fem_noSmoke, by = "Sample_ID")

# Filter the FILTER == "PASS"
merged_data <- merged_data %>% 
  filter(filter=="PASS")
# The number of unique participants
n_distinct(merged_data$Sample_ID) # 37 unique ID/participants

# Select 37 partipants' metadata
filtered_data <- lung_phe %>%
  filter(submitter_id.samples %in% unique(merged_data$Sample_ID))
# Races distribution
filter_race <- filtered_data %>% 
  group_by(race.demographic) %>%
  count()


# Find NO AGE Limitation in mutation dataset
fem_noSmoke_noAge <- lung_phe %>% 
  filter(tobacco_smoking_history==1 & gender.demographic == "female") %>%
  select(submitter_id.samples, age_at_index.demographic, gender.demographic, 
         race.demographic, tobacco_smoking_history)

# Join two data frame by Sample_ID
fem_noSmoke_noAge <- fem_noSmoke_noAge %>% 
  mutate(Sample_ID = submitter_id.samples)

# merge data from lung_mut, fem_noSmoke
merged_data <- merge(lung_mut, fem_noSmoke_noAge, by = "Sample_ID")

merged_data <- merged_data %>% 
  # Filter the FILTER == "PASS"
  filter(filter == "PASS") %>%  # only 53 participants "PASS" the criteria
  # Add columns ID, QUAL, INFO
  mutate(ID = ".", QUAL=".", INFO = ".") %>% 
  # Select the required columns
  select(Sample_ID, chrom, start, ID, ref, alt, QUAL, filter, INFO)

# Find out remaining subjects
unique(merged_data$Sample_ID) # 53 subjects

# Select 57 partipants' metadata
filtered_data2 <- lung_phe %>%
  filter(submitter_id.samples %in% unique(merged_data$Sample_ID))
# Races distribution
filter_race2 <- filtered_data2 %>% 
  group_by(race.demographic) %>%
  count()


# # Find Sample IDs not present in lung_mut
#missing_samples <- anti_join(fem_noSmoke, lung_mut, by = "Sample_ID")

# View the missing Sample IDs
#missing_samples$Sample_ID


# The distribution of ethnicities/race in TCGA subjects

