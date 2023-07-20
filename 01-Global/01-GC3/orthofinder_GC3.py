import os
import re
import glob
import argparse
from Bio import SeqIO
from Bio.Seq import Seq
from collections import defaultdict
from subprocess import call as unix

'''
Script to calculate aligned GC3 
for orthofinder orthogroups 
given cds primary transcripts
'''

parse = argparse.ArgumentParser()

parse.add_argument("-s", "--singlecopy",type=str, help="path to 1to1_orthologues directory (copied from Single_Copy_Orthologue_Sequences from orthofinder run)",required=True)
parse.add_argument("-g", "--genome",type=str, help="Path to genomes file",required=True)
parse.add_argument("-c", "--cds",type=str, help="Path to cds primary transcripts file",required=True)
parse.add_argument("-o", "--outlier",type=int, help="Outlier for GC/AT %",required=True)

''' 
1) Note, primary transcripts folder must be within the cds folder downloaded from ensemble
2) Must all conatin outgroup genome, and cds data - Because you are adding an orthofinder 
   outgroup, ensure that the outgroup has its cds, genome and pep PRIMARY transcirpt in the 
   correct directories      
'''

args = parse.parse_args()

def check_args():
    if  args.singlecopy[-1] != '/':
        args.singlecopy += '/'

    if args.cds[-1] != '/':
        args.cds += '/'

    if args.genome[-1] != '/':
        args.genome += '/'

#Dictionary of cds IDS : cds seq
def get_cds_ID_dict(fn):
    cds_dict = {}
    for cds in glob.glob(fn+ "*.fa"):
        with open(cds) as f:
            for record in SeqIO.parse(f, 'fasta'):            
                ID_cds = record.id
                cds_seq = str(record.seq)
                cds_dict[ID_cds] = cds_seq
    
    return cds_dict

#retun cds given orthogroup ID
def get_OG_cds_fasta(fn, cds_dict):
    for orthogroup in glob.glob(fn + "*.fa"):
        OGname = orthogroup.split("/")[-1].split(".")[0]
        with open(orthogroup) as f1, open(fn + OGname + ".fa.cds", "w") as outf1:
            for record in SeqIO.parse(f1, 'fasta'):            
                ID_OG = record.id
                cds_OG = cds_dict[ID_OG]
                outf1.write(f">{ID_OG}\n{cds_OG}\n")

def run_mafft(fn):
    print("Running mafft...")
    for orthogroup in glob.glob(fn + "*.fa"):
        OGname = orthogroup.split("/")[-1].split(".")[0]
        unix("mafft " + orthogroup + " > " + fn + OGname + ".fa.mafft", shell=True)

def run_trimal(fn):
    print("Running trimal (gappyout) with backtranslation...")
    for alignemnt in glob.glob(fn + "*.mafft"):
        OGname = alignemnt.split("/")[-1].split(".")[0]
        unix("trimal -in " + alignemnt + " -out " + alignemnt + ".trimal" + " -gappyout -backtrans " + fn + OGname + ".fa.cds"+ " -ignorestopcodon", shell=True)

def get_sp_ID_dict(fn):
    #Make dict of species name and ID
    name_dict = {}
    for cds in glob.glob(fn + "*.fa"):
        sp_name = cds.split("/")[-1].split("-")[0]
        with open(cds) as f:
            for record in SeqIO.parse(f, 'fasta'):
                    ID_cds = record.id
                    name_dict[ID_cds] = sp_name
    
    return name_dict

#Dict of dicts which has for each species, the length of each chromosome 
def get_nested_chrm_dict(fn):
    species_genome_dict = defaultdict(dict)
    for files in glob.glob(fn + "*.fasta"):
        genome_dict = {}
        if "Drosophila_melanogaster.BDGP6" in files: #/home/zoo/quee4075/GC_Chrm_runs/GC_genome_run-1/data/genomes/Drosophila_melanogaster.BDGP6.32.dna.toplevel.fasta
            with open(files) as f:
                for record in SeqIO.parse(f, 'fasta'):
                    header = record.id
                    sp_name = "Drosophila_melanogaster"
                    seq = str(record.seq)
                    len_chrm = len(seq)
                    genome_dict[header] = len_chrm
        else: 
            with open(files) as f:
                for record in SeqIO.parse(f, 'fasta'):
                    header = record.description
                    sp_name = header.split(" ")[1] + "_" + header.split(" ")[2]
                    if "chromosome:" in header:
                        chrm_no = header.split(": ")[1]
                        seq = str(record.seq)
                        len_chrm = len(seq)
                        genome_dict[chrm_no] = len_chrm
                    elif "contig:" in header:
                        contig_id = record.id 
                        seq = str(record.seq)
                        len_chrm = len(seq)
                        genome_dict[contig_id] = len_chrm

        species_genome_dict[sp_name] = genome_dict

    return species_genome_dict

#Two dicts = cds:start_pos to get position and cds:chrm_no to get chromsome number 
def get_position_dicts(fn):
    pos_dict = {}
    chrm_no_dict = {}
    cds_full = fn.split("primary")[0] #Get one dir back to full cds 
    for cds in glob.glob(cds_full + "*.fa"):
        if "Drosophila_melanogaster" in cds:
            with open(cds) as f:
                for record in SeqIO.parse(f, 'fasta'): #primary_assembly:BDGP6.32:3R:16375284:16403690:-1
                    header = record.description
                    ID = record.description.split("gene:")[1].split(" ")[0] #Gene ID not transcript ID
                    chrm_no = header.split(" ")[2].split(":")[2]
                    start_pos = header.split(" ")[2].split(":")[3]
                    pos_dict[ID] = start_pos
                    chrm_no_dict[ID] = chrm_no
        elif "Neomicropteryx_cornuta" in cds:
            #Non-DTOL species and can't get chromosome position from genes, hence skip this part 
            with open(cds) as f:
                for record in SeqIO.parse(f, 'fasta'): #maker-ptg000021l-snap-gene-73.20-mRNA-1
                    header = record.description
                    ID = record.description
                    chrm_no = None
                    start_pos = None
                    pos_dict[ID] = start_pos
                    chrm_no_dict[ID] = chrm_no
        else:
            with open(cds) as f:
                for record in SeqIO.parse(f, 'fasta'):
                    header = record.description
                    ID = record.description.split("gene:")[1].split(" ")[0]
                    chrm_no = header.split(" ")[2].split(":")[1]
                    start_pos = header.split(" ")[2].split(":")[2]
                    pos_dict[ID] = start_pos
                    chrm_no_dict[ID] = chrm_no
    
    return pos_dict, chrm_no_dict

def get_trimmed_GC3_output(fn, chrm_no_dict, pos_dict, name_dict, species_genome_dict):
    with open(f"{fn}trimmedGC3_ortogroups.tsv", "w") as outf1, open(f"{fn}outlierGC3_{args.outlier}.tsv", "w") as outf2, open(f"{fn}outlierAT3_{100 - args.outlier}.tsv", "w") as outf3:
        outf1.write("Orthogroup\tspecies\tgene_ID\tGC3_percent\tGC3_length\tchrm_no\tstart_position\tchrm_size\n")
        outf2.write("Orthogroup\tspecies\tgene_ID\tGC3_percent\tGC3_length\tchrm_no\tstart_position\tchrm_size\n")
        outf3.write("Orthogroup\tspecies\tgene_ID\tGC3_percent\tGC3_length\tchrm_no\tstart_position\tchrm_size\n")
        for cds in glob.glob(fn + "*.trimal"):
            OGname = cds.split("/")[-1].split(".")[0] 
            print(f"Calcuating GC3 for {OGname} ...")
            with open(cds) as f:
                for record in SeqIO.parse(f, 'fasta'):
                    ID = record.id 

                    try:        
                        chrm_name = str(chrm_no_dict[ID])
                        start_pos = pos_dict[ID]

                        species = name_dict[ID]
                        species_chrm = species_genome_dict[species]
                    
                        chrm_size = species_chrm[chrm_name]
                    
                    except:
                        chrm_name = None
                        start_pos = None

                        species = "Neomicropteryx_cornuta"
                        species_chrm = None
                    
                        chrm_size = None


                    seq = str(record.seq)
                    GC3 = seq[2::3]
                    GC3_count = GC3.count('G') + GC3.count('g') + GC3.count('C') + GC3.count('c')
                    GC3_percent = ( GC3_count / len(GC3) ) * 100
                    outf1.write(f"{OGname}\t{species}\t{ID}\t{str(GC3_percent)}\t{str(len(GC3))}\t{chrm_name}\t{start_pos}\t{str(chrm_size)}\n")

                    if GC3_percent > args.outlier:
                        outf2.write(f"{OGname}\t{species}\t{ID}\t{str(GC3_percent)}\t{str(len(GC3))}\t{chrm_name}\t{start_pos}\t{str(chrm_size)}\n")
                    elif GC3_percent < (100 - args.outlier):
                        outf3.write(f"{OGname}\t{species}\t{ID}\t{str(GC3_percent)}\t{str(len(GC3))}\t{chrm_name}\t{start_pos}\t{str(chrm_size)}\n")
                    else:
                        continue 

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

def get_t_distance(fn, orthogroup_lst ):
    with open(f"{fn}trimmedGC3_ortogroups.tsv") as f1, open(f"{fn}t_metric.tsv", "w") as outf:
        outf.write(f"Orthogroup\tSpecies\tgene_ID\tchrm_no\tGC3\tPosition\tt_distance\tt_metric\n")   
        for line in f1:
            if line.startswith("Orthogroup"):
                continue
            else: 
                orthogroup = line.split("\t")[0]
                if orthogroup in set(orthogroup_lst):
                    gene_ID = line.split("\t")[2]
                    sp = line.split("\t")[1]
                    GC3 = line.split("\t")[3]
                    chrm_no = line.split("\t")[5]
                    
                    try:
                        start_position = int(line.split("\t")[6])
                    except:
                        start_position = None #Again no chromosome datae for Neo, therefore skip all this 
                    
                    try:
                        chrm_size = int(line.split("\t")[7])
                    except:
                        chrm_size = None

                    #Window analysis - old method to see if near telomere 
                    if (start_position != None) or (chrm_size != None):
                        window = int(1_000_000) 
                        near_telomere = ""
                        if start_position < window:
                            near_telomere += "Near_Telomere"
                        elif start_position > (chrm_size - window):
                            near_telomere += "Near_Telomere"
                        else:
                            near_telomere = near_telomere

                    else:
                        near_telomere = None

                    #NOTE Sample code on how to work out distance from the temomere 
                    #NOTE Check to see if near telomere correlates with low d 
                    t_distance = None #Is this needed?
                    if start_position != None:
                        #Get midpoint of the chromosome
                        midpoint = chrm_size / 2

                        #For any gene before mid point, distance form telomere == start position 
                        if start_position < midpoint:
                            t_distance = start_position
                        
                        #For any gene after mid point, distance form telomere == chromosome size - start position 
                        #This is because the chromosome size == end posiition 
                        elif start_position >= midpoint:
                            t_distance = chrm_size - start_position
                    
                    if t_distance != None:
                        #Find the distance relative to the midpoint of the chromosome 
                        t_metric = (t_distance / midpoint) * 100
                        outf.write(f"{orthogroup}\t{sp}\t{gene_ID}\t{chrm_no}\t{GC3}\t{near_telomere}\t{t_distance}\t{t_metric}\n")

def main():
    # #Get CDS for each OG
    # cds_dict = get_cds_ID_dict(args.cds)
    # get_OG_cds_fasta(args.singlecopy, cds_dict)
   
    # #Run mafft and trimal 
    # run_mafft(args.singlecopy)
    # run_trimal(args.singlecopy)
    # print("Calculating aligned GC3...")
   
    # #Calculate GC3 - getting appropriate dictionaries
    # name_dict = get_sp_ID_dict(args.cds)
    # species_genome_dict = get_nested_chrm_dict(args.genome)
    # pos_dict, chrm_no_dict = get_position_dicts(args.cds)
    # #Output1: trimmed GC3 for all OGs and outliers 
    # get_trimmed_GC3_output(args.singlecopy, chrm_no_dict, pos_dict, name_dict, species_genome_dict)
    
    #Output 2: a comparison file with telomeric distances for each gene shown 
    orthogroup_lst = get_OG_list(args.singlecopy)
    get_t_distance(args.singlecopy, orthogroup_lst)

if __name__ == "__main__":
    check_args()
    main()

