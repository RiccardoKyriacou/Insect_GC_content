import argparse
import glob
from collections import defaultdict 

"""
Script to calculate mean GC for species 
when given inidivual chromosome data

"""

#Funciton to get mean GC for cds and genome 
def get_mean_GC(fn):
    out_name = fn.split("/")[-1]
    with open(f"mean_{out_name}", "w") as outf: 
        sp_dict = {}
        with open(fn) as f:
            for line in f:
                species = line.split("\t")[0]
                GC = float(line.split("\t")[2])
                order = line.split("\t")[-1].rstrip()

                #If species in dict, add GC total and count 
                if species in sp_dict:
                    sp_dict[species]["gc_total"] += GC
                    sp_dict[species]["count"] += 1
                    sp_dict[species]["order"] = order
                #If species not in dict, add it 
                else:
                    sp_dict[species] = {"gc_total": GC, "count": 1, "order": ""}         

        #Itterate through the dict to calculate average GC
        for species, values in sp_dict.items():
            avg_gc = values["gc_total"] / values["count"]
            order= values["order"]
            outf.write(f"{species}\t{avg_gc:.2f}\t{order}\n")


if __name__ == "__main__":
    parse = argparse.ArgumentParser()

    parse.add_argument("-i", "--input",type=str, help="path to tsv to get mean GC for species", required = True)

    args = parse.parse_args()

    get_mean_GC(args.input)
