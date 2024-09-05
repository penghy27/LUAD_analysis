# LUAD_analysis  

# Project Overview:

The prevalence of Lung Adenocarcinoma (LUAD) among female nonsmokers is on the rise today. However, the underlying factors contributing to this trend need further investigation. In this project, we leverage the TCGA LUAD dataset from the University of California, Santa Cruz database to extract genetic variant information for female LUAD subjects who are nonsmokers. This data will be used to conduct mutational signature analyses.  

# Project Tasks:
 
1. Demographic Data Selection:
- Select female non-smokers/smokers with ages between 20 and 75 
2. VCF File Creation for Nonsmokers:
- Selected eligible participants from TCGA LUAD `.tsv` files.
- Converted the selected `.tsv` files into individual VCF files stored in a folder.
3. VCF files for Selected Smokers:
- The same process as step 2 above.
4. Mutational Signature Analysis:
Perform mutational signature analysis on the obtained VCF files using SigProfilerExtractor. Reference genome is GRCh38.  
https://github.com/AlexandrovLab/SigProfilerExtractor
5. Final Signature Analysis Results.
- Analuze and interpret the results to understand the mutational landscape of LUAD among different groups.

#### Results
The mutational signature analysis within TCGA cohort revealed the presence of several distinct signatures. Our findings show that SBS1, SBS2, SBS13, SBS5, SBS4, SBS19, and SBS95 are the predominant mutational signatures within this cohort.
  
  *Note: The research findings related to the Taiwanese LUAD nonsmokers are progressively concluding. As the manuscript is currently in preparation and has not been published, this repo primarily focuses on the analysis results of TCGA LUAD.*
