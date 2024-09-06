# LUAD_analysis  

## Overview:

The prevalence of Lung Adenocarcinoma (LUAD) among female nonsmokers is on the rise today. However, the underlying factors contributing to this trend need further investigation. This project investigates mutational signatures in Lung Adenocarcinoma (LUAD) with a focus on nonsmoking females from TCGA LUAD and Taiwanese datasets. Leveraging advanced tools like SigProfilerExtractor, the project aims to uncover unique cancer signatures, recurrent variants, and genes associated with lung adenocarcinoma.  

## Key Components:
- **Data Pipeline Development**: Created data preprocessing, integration, conversion, and analysis pipeline, optimizing efficiency in mutational signature analysis and Ensembl’s VEP annotation.
- **Mutational Signature Analysis**: Conducted detailed analyses of mutational signatures using SigProfilerExtractor, identifying distinct cancer-related patterns and recurrent variants specific to nonsmoking female LUAD patients.
- **Biomarker Discovery**: Identified unique mutational signatures as well as variants and genes recurrence in the Taiwanese cohort, exploring their potential utility as biomarkers for LUAD in Asian nonsmokers.

This project contributes valuable insights into LUAD and highlights potential biomarkers for improved understanding and treatment of lung cancer in specific populations.

## Breakdown Tasks:
 
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
- Analyze and interpret the results to understand the mutational landscape of LUAD among different groups.

## Results
The mutational signature analysis within TCGA cohort revealed the presence of several distinct signatures. Our findings show that SBS1, SBS2, SBS13, SBS5, SBS4, SBS19, and SBS95 are the predominant mutational signatures within this cohort.
  
  **Note**: The research findings related to the Taiwanese LUAD nonsmokers are progressively concluding. As the manuscript is currently in preparation and has not been published, this repo primarily focuses on the analysis results of TCGA LUAD.*
