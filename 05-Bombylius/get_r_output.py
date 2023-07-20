from collections import defaultdict

#Stand alone scrip- has been integrated into the get_sneath_index.py script

def make_OG_dict(sneath_output):
    #Create a dictionary to store the values for each OG and species
    OG_dict = defaultdict(dict)
    with open(sneath_output) as f:
        for row in f:
            #Loop through the input table and add the values to the dictionary
            OG = row.split("\t")[0]
            sp = row.split("\t")[1]
            sneath = row.split("\t")[2].strip()
            
            OG_dict[OG][sp] = sneath
    
    return OG_dict

# Output as a table in format
# OG   SP1 SP2 SP3
# OG1  s   s   s
# OG2  s   s   s
def create_tsv(OG_dict, ingroup1, ingroup2, ingroup3):
    with open("sneath_R_output.tsv", "w") as outf:
        #Open and write headers for table
        outf.write("{:<9}\t{:<23}\t{:<23}\t{:<23}\n".format("Orthogroup", ingroup1, ingroup2, ingroup3))
        for OG, species_sneath in OG_dict.items():
            species1 = species_sneath.get(ingroup1, "")
            species2 = species_sneath.get(ingroup2, "")
            species3 = species_sneath.get(ingroup3, "")
            outf.write("{:<9}\t{:<23}\t{:<23}\t{:<23}\n".format(OG, species1, species2, species3))
    
    
if __name__ == "__main__":
    OG_dict = make_OG_dict("sneath_values.tsv")
    create_tsv(OG_dict, "Thecophora_atra", "Pherbina_coryleti", "Coremacera_marginata")