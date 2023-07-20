import argparse
import glob
from collections import defaultdict 

"""
Script to calculate mean GC3 for each species 

"""

# Funciton to get mean GC for cds and genome 
def get_mean_GC(fn):
    out_name = fn.split("/")[-1]
    with open(f"mean_{out_name}", "w") as outf: 
        species_dict = {}
        with open(fn) as f:
            for line in f:
                # Skip header
                if line.startswith("Orthogroup"):
                    continue
                else:       
                    species = line.split("\t")[1]
                    GC3 = float(line.split("\t")[3])
                    order = args.order

                    # If OG_name in dict, add GC total and count 
                    if species in species_dict:
                        species_dict[species]["gc_total"] += GC3
                        species_dict[species]["count"] += 1
                        species_dict[species]["order"] = order
                    # If OG_name not in dict, add it 
                    else:
                        species_dict[species] = {"gc_total": GC3, "count": 1, "order": ""}         

         # Convert dict to list of tuples and sort by GC3 percentage value
        sorted_tuples = sorted(species_dict.items(), key=lambda x: x[1]['gc_total']/x[1]['count'], reverse=True)

        # Write sorted list to output file
        for species, values in sorted_tuples:
            avg_gc = values["gc_total"] / values["count"]
            order= values["order"]
            outf.write(f"{species}\t{avg_gc:.2f}\t{order}\n")


if __name__ == "__main__":
    parse = argparse.ArgumentParser()

    parse.add_argument("-i", "--input",type=str, help="path to tsv to get mean GC for OG_name", required = True)
    parse.add_argument("-o", "--order",type=str, help="order", required = True)

    args = parse.parse_args()

    get_mean_GC(args.input)
