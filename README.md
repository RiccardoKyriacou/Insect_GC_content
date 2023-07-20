# Insect_GC_content

## Code repository for all scripts used to collect data, perform statistics and create figures for the paper

### 01 - Global
#### 01-GenomeGC
      1) get_genomes.py - Script to download genomes from DTOL 
      2) chrm_number_GC_content.py - Script to calculate GC content per chromosome/scaffold in a genome with a given cutoff size (> 1MB)
      3) get_mean_GC.py - Script to calculate mean GC for species when given inidivual chromosome data

#### 01-cdsGC
      1) get_genes.py - Script to download cds and protein data from DTOL 
      2) cds_GCcontent.py - Script to calculate cds GC content per chromosome/scaffold in a genome with a given cutoff size.
      3) get_mean_GC.py - Script to calculate mean GC for species when given inidivual chromosome data

#### 01-GC3
##### NOTE: Script use sinlge copy orthologue ouptus from orthofinder runs 
      1) orthofinder_GC3.py - Script to calculate aligned GC3 for orthofinder orthogroups given cds primary transcripts, as well as other gene metrics
      2) get_mean_species_GC3.py - Script to calculate mean GC3 for each species 

### 02 - Phylogenies 
     1) Script to produce figures

### 03 - Size 
    1) Script to produce figures, using outputs from 01-GenomeGC

### 04 - Telomere 
    1) get_telomere_plot.py - Script to calculate distance from telomere for each single copy orthologue and it's corresponding GC3 %
    2) Script to produce figures, using outputs from 

### 05 - Bombylius
    1) get_sneath_index.py - Script to calcualte sneath value index. This script uses function from get_genetrees.py so must be in the same dir as that script:
    2) get_genetrees.py - Provides functionality to get_sneath_index.py, doesn't need to be run 
    
