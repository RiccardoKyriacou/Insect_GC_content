"""
Script to calculate average GC content for Eukaryotes

Calculated from: https://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/eukaryotes.txt

Layout of document:
Organism/Name  TaxID   BioProject Accession    BioProject ID   Group   SubGroup        Size (Mb)       GC%     Assembly Accession      Replicons       WGS   Scaffolds        Genes   Proteins        Release Date    Modify Date     Status  Center  BioSample Accession

"""

# Main function 
def get_mean_GC(fn):
    with open(fn, "r", encoding='utf-8') as f, open("total_animal_GC_content.tsv", "w") as outf: 
        subgroup_GC_dict = {}
        sp_lst = [] 
        for line in f:
            columns = line.split("\t")

          # Here I parse whatever I can from the file, some entries may not contain the following info, so are skipped 
            try:
                sp_name, group, sub_group, GC_content, status = columns[0], columns[4], columns[5], float(columns[7]), columns[16]
            except (IndexError, ValueError):
                continue

            # Filtering out file for chromosome level assemblies and animal genomes
            if (status == "Chromosome") and (group == "Animals"):
                
                # In order to make sure only one specie per subgroup is included, update a list 
                if sp_name not in sp_lst:
                    sp_lst.append(sp_name)
                
                    # Possible sub_groups:
                    # {'Insects', 'Fishes', 'Birds', 'Other Animals', 'Reptiles', 'Amphibians', 'Mammals', 'Flatworms', 'Roundworms'}

                    if sub_group in subgroup_GC_dict:
                        subgroup_GC_dict[sub_group]["gc_content"] += GC_content
                        subgroup_GC_dict[sub_group]["count"] += 1
                    else:
                        subgroup_GC_dict[sub_group] = {"gc_content": GC_content, "count": 1}
                
                # If species already present in the list, skip 
                else:
                    continue
                
        # This just is a function to sort the dictionary put based on GC content
        sorted_tuples = sorted(subgroup_GC_dict.items(), key=lambda x: x[1]['gc_content']/x[1]['count'], reverse=True)

        # Write sorted list to output file
        animal_gc = 0 
        subgroup_count = 0 
        for subgroup, values in sorted_tuples:
            avg_gc = values["gc_content"] / values["count"]
            animal_gc += avg_gc
            subgroup_count += 1
            
            print(f"{subgroup}\t{avg_gc:.2f}")
            outf.write(f"{subgroup}\t{avg_gc:.2f}\n")
        
        animal_GC_content = (animal_gc / subgroup_count)
        outf.write(f"Overall GC content for animals\t{animal_GC_content:.2f}\n")
        print(f"Overall GC content for animals\t{animal_GC_content:.2f}\n")

        outf.write(f"\nList of speices used:\n")
        for sp in sp_lst:
            outf.write(f"{sp}\n")
                  
get_mean_GC("eukaryotes.txt")


# # Code used to figure out the different columns 
# def get_first_row(fn):
#     with open(f"{fn}", "r") as f:
#         first_row = next(f).strip()
#         print(first_row)
#         second_row = next(f).strip()
#         print(second_row)
#         second_row = next(f).strip()
#         print(second_row)
#         #Status
#         print(second_row.split("\t")[16])
#         #Group
#         print(second_row.split("\t")[4])
#         #GC
#         print(second_row.split("\t")[7])

# get_first_row("eukaryotes.txt")
