
# Insect_GC_content

Code repository for all scripts used to collect data, perform statistics and create figures for the paper *"GC content across insect genomes: phylogenetic patterns, causes and consequences"*

Kyriacou, R.G., Mulhair, P.O. & Holland, P.W.H. GC Content Across Insect Genomes: Phylogenetic Patterns, Causes and Consequences. J Mol Evol 92, 138–152 (2024). https://doi.org/10.1007/s00239-024-10160-5

# Contents 

## /01 - Global/

### 00 - Intro/
    1) GC_totals_eukaryotes.py
Script used to calculate GC content totals for different Animal subgroups using data from NCBI (https://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/eukaryotes.txt)

### 01-GenomeGC/
    1) get_genomes.py 
Script to download genomes from DTOL 
    
    2) chrm_number_GC_content.py
Script to calculate GC content per chromosome/scaffold in a genome with a given cutoff size (> 1MB)

    3) get_mean_GC.py
Script to calculate mean GC for species when given chromosome data

### 01-cdsGC/
    1) get_genes.py
Script to download cds and protein data from DTOL 

    2) cds_GCcontent.py
Script to calculate cds GC content per chromosome/scaffold in a genome with a given cutoff size

    3) get_mean_GC.py
Script to calculate mean GC for species when given inidivual chromosome data

### 01-GC3/
**NOTE: Scripts here use sinlge copy orthologue ouptus from orthofinder runs**

    1) orthofinder_GC3.py
Script to calculate aligned GC3 for orthofinder orthogroups given cds primary transcripts, as well as other gene metrics

    2) get_mean_species_GC3.py
Script to calculate mean GC3 for each species 

### figure-1.1/
    1) species_GC_comaprison.R
R script used to create Figure 1

## /02 - Phylogeny/
    1) phylogeny_plots.R
Script to produce Figure 1
    
## /03 - Size/
    1) size_plots.R
Script to produce Figure 3, using outputs from 01-GenomeGC

## /04 - Telomere/
    1) get_telomere_plot.py
Script to calculate distance from telomere for each single copy orthologue and it's corresponding GC3 %

    2a) figure-4.1/chromosome_plots.R
    2b) figure-4.1/telomere_distance.R
Scripts to produce Figure 4

## /05 - Bombylius/ 
    1) get_sneath_index.py
Script to calculate sneath value index. This script uses function from get_genetrees.py so must be in the same dir as that script:

    2) get_genetrees.py 
Provides functionality to get_sneath_index.py, doesn't need to be run 

## /Data/
All data used in this paper provided: 
- all_output_data.xlsx 

Order of tabs: 
    
    genome IDs; genome GC; CDS GC; SCO GC3; species tree files; chromosome size GC; regressions between chromosome size and GC; SCO gene identification numbers, chromosomal location and GC3; average distances from telomeres; codon usage data; Sneath values


    



## Installation

```bash
  git clone https://github.com/RiccardoKyriacou/Insect_GC_content
```
    
