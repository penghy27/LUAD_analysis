# LUAD_data_analysis  

Date: 09/25/2023

The prevalence of Lung Adenocarcinoma (LUAD) among female nonsmokers is on the rise today. However, the underlying factors contributing to this trend need further investigation. In this project, we leverage the TCGA LUAD dataset from the University of California, Santa Cruz database to extract genetic variant information for female LUAD subjects who are nonsmokers. This data will be used to conduct mutational signature analyses.  

Below is a breakdown of the tasks that will provide you with hands-on experience, covering data preprocessing to mutational signature analysis:
 
1. Demographic Data Selection 
2. VCF File Creation for Nonsmokers:
3. Mutational Signature Analysis:
Perform mutational signature analysis on the obtained VCF files using SigProfilerExtractor. Reference genome is GRCh38.  
https://github.com/AlexandrovLab/SigProfilerExtractor
4. VCF Files for Selected Smokers:
·  Select TCGA Asian, White, and Black/African American smokers.
·  Generate VCF files, with the flexibility to include more files for Asian smokers due to lower numbers. There is no age limitation for including more TCGA Asian smokers.
·  Run separate SigProfilerExtractor analyses based on each race.
5. Final Signature Analysis Results:
·  Obtain four distinct signature analysis outcomes: TCGA_nonsmokers, TCGA_smokers for White, Black/African American, and Asian races.

