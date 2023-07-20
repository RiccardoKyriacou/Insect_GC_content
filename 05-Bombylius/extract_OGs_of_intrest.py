import argparse

'''
Simple script to extract the AT-rich OGs for Bombylius OGs
in order to make Sneath distribution plot on R
'''

def get_OG_list(fn):
    OG_lst = []
    with open(fn) as f:
        for line in f:
            OG = line.split("\n")[0]
            OG_lst.append(OG) 
    return OG_lst

def re_write_output(sneath_r_output, OG_lst):
    with open(sneath_r_output) as f, open("sneath_orthogroups_of_intrest.tsv", "w") as outf:
        outf.write(f"Orthogroup	Bombylius_discolor\tBombylius_major\tMachimus_atricapillus\n")
        for line in f:
            if line.startswith("Orthogroup"):
                continue
            else:
                orthogroup = line.split("\t")[0].strip()
                ingroup1_sneath = line.split("\t")[1].strip()
                ingroup2_sneath = line.split("\t")[2].strip()
                ingroup3_sneath = line.split("\t")[3].strip()

                if orthogroup in OG_lst:
                    outf.write(f"{orthogroup}\t{ingroup1_sneath}\t{ingroup2_sneath}\t{ingroup3_sneath}\n")


if __name__ == "__main__":
    parse = argparse.ArgumentParser()

    parse.add_argument("-o", "--orthogroups",type=str, help="list of orthogroups to extract", required = True)
    parse.add_argument("-t", "--tsv",type=str, help="sneath_R_output.tsv", required = True)

    args = parse.parse_args()

    OGs_of_intrest = get_OG_list(args.orthogroups)
    re_write_output(args.tsv, OGs_of_intrest)
