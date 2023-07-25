#!/usr/bin/env python3
import os
import glob
import shutil
import argparse
from Bio import SeqIO

'''
Script to concatonate all OGS for one speices
into one fasta file. Uses output from get_sneath_index.py
'''

# Usage: python3 concat_OGs.py --species [sp_name]

# Create dictionary of gene_id : sp_name
def get_OG_sp_dict(tsv):
    ID_sp_dict = {}
    with open(tsv) as f: 
        
        # Skip the header line
        next(f)

        for line in f:
            sp_name = line.split("\t")[1]
            gene_id = line.split("\t")[2]
            ID_sp_dict[gene_id] = sp_name

    return ID_sp_dict

# Replace header such that:        
# >GENE_ID 
# Is re-written to 
# >sp_name
def rename_trimal_files(species_name, trimal_files, ID_sp_dict):
    with open(f"{species_name}_all_SCOs.fasta", "w") as outf:
        for alignment in glob.glob(trimal_files + "*.trimal"): #Open alignemnt files
            with open(alignment) as f:
                # Parse trimal folders to get gene ID and seq
                for record in SeqIO.parse(f, 'fasta'): 
                    gene_ID = record.id
                    seq = str(record.seq)
                    
                    # Get species name 
                    sp_name = ID_sp_dict[gene_ID] #Match gene_ID to seq

                    if sp_name == species_name:
                        outf.write(f">{sp_name}\n{seq}\n")


if __name__=='__main__':

    about = 'concatonate all OGS for one speiceis into one fasta file. Need to run get_sneath_index.py first '
    parse = argparse.ArgumentParser(description=about)

    parse.add_argument("-t", "--tsv",type=str, help="path to trimmedGC3_orthogroups.tsv", required = True)
    parse.add_argument("-s", "--species",type=str, help="name of species to concat OGs, in form genus_species", required = True)
    parse.add_argument("-o", "--orthogroups",type=str, help="path to single copy orthogroup dir", required = True)

    args = parse.parse_args()

    if  args.orthogroups[-1] != '/':
        args.orthogroups += '/'
    
    ID_sp_dict  = get_OG_sp_dict(args.tsv)
    sp_seq_dict = rename_trimal_files(args.species, args.orthogroups, ID_sp_dict)




