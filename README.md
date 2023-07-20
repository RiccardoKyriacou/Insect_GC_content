# Insect_GC_content

## Code repository for all scripts used to collect data, perform statistics and create figures for the paper

### 01 - Global
#### 01-GenomeGC
      * get_genomes.py - Script to download genomes from DTOL 
      * chrm_number_GC_content.py - Script to calculate GC content per chromosome/scaffold in a genome with a given cutoff size (> 1MB)
      * get_mean_GC.py - Script to calculate mean GC for species when given inidivual chromosome data

#### 01-cdsGC
      * get_genes.py - Script to download cds and protein data from DTOL 
      * cds_GCcontent.py - Script to calculate cds GC content per chromosome/scaffold in a genome with a given cutoff size.
      * get_mean_GC.py - Script to calculate mean GC for species when given inidivual chromosome data

#### 01-GC3
##### NOTE: Script use sinlge copy orthologue ouptus from orthofinder runs 
      * orthofinder_GC3.py - Script to calculate aligned GC3 for orthofinder orthogroups given cds primary transcripts, as well as other gene metrics
      * get_mean_species_GC3.py - Script to calculate mean GC3 for each species 

### 02 - Phylogenies 
    * Script to produce figures

### 03 - Size 
    * Script to produce figures, using outputs from 01-GenomeGC

### 04 - Telomere 
    * get_telomere_plot.py - Script to calculate distance from telomere for each single copy orthologue and it's corresponding GC3 %
    * Script to produce figures, using outputs from 

### 05 - Bombylius
    * get_sneath_index.py - Script to calcualte sneath value index. This script uses function from get_genetrees.py so must be in the same dir as that script:
    * get_genetrees.py - Provides functionality to get_sneath_index.py, doesn't need to be run 
    
