import pandas as pd
import argparse

def get_OG_list(fn):
    orthogroup_lst = []
    with open(f"{fn}trimmedGC3_ortogroups.tsv") as f:
        for line in f:
            if line.startswith("Orthogroup"):
                continue
            else:
                orthogroup = line.split("\t")[0]
                orthogroup_lst.append(orthogroup)

    return orthogroup_lst

def get_t_position(start_position, chrm_size):
    t_distance = None
    if start_position is not None and chrm_size is not None:
        midpoint = chrm_size / 2
        if start_position < midpoint:
            t_distance = start_position
        else:
            t_distance = chrm_size - start_position

    return t_distance, midpoint

def get_t_distance(sco_path, orthogroup_lst):
    with open(f"{sco_path}trimmedGC3_ortogroups.tsv") as f1, open(f"{sco_path}t_distance.tsv", "w") as outf:
        outf.write(f"Orthogroup\tSpecies\tgene_ID\tchrm_no\tGC3\tPosition\tt_distance\n")
        for line in f1:
            if line.startswith("Orthogroup"):
                continue
            else:
                orthogroup = line.split("\t")[0]
                if orthogroup in orthogroup_lst:
                    gene_ID = line.split("\t")[2]
                    sp = line.split("\t")[1]
                    GC3 = line.split("\t")[3]
                    chrm_no = line.split("\t")[5]

                    try:
                        start_position = int(line.split("\t")[6])
                    except:
                        start_position = None

                    try:
                        chrm_size = int(line.split("\t")[7])
                    except:
                        chrm_size = None

                    t_distance, midpoint = get_t_position(start_position, chrm_size)

                    if t_distance is not None:
                        outf.write(f"{orthogroup}\t{sp}\t{gene_ID}\t{chrm_no}\t{GC3}\t{start_position}\t{t_distance}\n")

def get_average(sco_path):
    df = pd.read_csv(f'{sco_path}t_distance.tsv', delimiter='\t')
    averages = df.groupby('Orthogroup')[['GC3', 't_distance']].mean()
    averages.to_csv(f'{sco_path}mean_t_distance.tsv', sep='\t', index=False)

def main():
    orthogroup_lst = get_OG_list(args.singlecopy)
    get_t_distance(args.singlecopy, orthogroup_lst)
    get_average(args.singlecopy)

if __name__ == "__main__":
    parse = argparse.ArgumentParser()

    parse.add_argument("-s", "--singlecopy",type=str, help="path to 1to1_orthologues directory (copied from Single_Copy_Orthologue_Sequences from orthofinder run)",required=True)

    args = parse.parse_args()

    main()
