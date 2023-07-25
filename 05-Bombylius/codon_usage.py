import argparse
import pandas as pd
from Bio import SeqIO


'''
Script to calculate codon usage 
'''

# define codon_aa_table
codon_aa = {
    "TTT":"Phe", "TTC":"Phe",         
    "TCT":"Ser", "TCC":"Ser", "TCA":"Ser", "TCG":"Ser",
    "AGT":"Ser", "AGC":"Ser",
    "CTT":"Leu", "CTC":"Leu", "CTA":"Leu", "CTG":"Leu",
    "TTA":"Leu", "TTG":"Leu",
    
    "TAT":"Tyr", "TAC":"Tyr", "TAA":"STOP", "TAG":"STOP",
    "TGT":"Cys", "TGC":"Cys", "TGA":"STOP", "TGG":"Trp",
    "CGT":"Arg", "CGC":"Arg", "CGA":"Arg", "CGG":"Arg",
    "AGA":"Arg", "AGG":"Arg",
    "CCT":"Pro", "CCC":"Pro", "CCA":"Pro", "CCG":"Pro",
    "CAT":"His", "CAC":"His", "CAA":"Gln", "CAG":"Gln",
    
    "ATT":"Ile", "ATC":"Ile", "ATA":"Ile", "ATG":"Met",
    "ACT":"Thr", "ACC":"Thr", "ACA":"Thr", "ACG":"Thr",
    "AAT":"Asn", "AAC":"Asn", "AAA":"Lys", "AAG":"Lys",
   
    "GTT":"Val", "GTC":"Val", "GTA":"Val", "GTG":"Val",
    "GCT":"Ala", "GCC":"Ala", "GCA":"Ala", "GCG":"Ala",
    "GAT":"Asp", "GAC":"Asp", "GAA":"Glu", "GAG":"Glu",
    "GGT":"Gly", "GGC":"Gly", "GGA":"Gly", "GGG":"Gly",}
    

def get_cod_freq(seq):
    # Computes absolute codon counts in the input gene coding sequence
    codon_count_dict=dict() 

    # Define eacg codon from above table and set  count to 0 
    for codon in list(codon_aa.keys()):
        codon_count_dict[codon]=0

    # Make a list of codons
    codons=[]
    for c in range(0,len(seq),3):
        cod = seq[c:c+3]
        if 'N' not in cod:  ##ignore N
            codons.append(cod)
        else:
            continue
    
    # For each codon, incremement count by 1
    for c in list(codon_count_dict.keys()):
        codon_count_dict[c]+= codons.count(c)

    # Converts the items of the codon_count_dict dictionary into a list of key-value pairs  
    df_codcnt=pd.DataFrame(list(codon_count_dict.items()) )
    # Rename columns
    df_codcnt.columns=['Codon', 'Obs_Freq']
    # Add coulum Amino-acid, retrieved from aa dict
    df_codcnt['Amino_acid'] = [codon_aa[codon] for codon in df_codcnt['Codon'].values]

    # Add column for GC
    df_codcnt['GC3'] = df_codcnt['Codon'].apply(lambda codon: 1 if codon[-1] in {'G', 'C'} else 0)


    df_codcnt['GC_content'] = df_codcnt['Codon'].apply(lambda codon: (codon.count('G') + codon.count('C')) / 3 * 100)

    return df_codcnt


def main(gene_file):
    sp_name = gene_file.split("/")[-1].split("_all")[0]
    with open(gene_file) as f:
        all_dfs = []
        for record in SeqIO.parse(f, 'fasta'):
            seq = record.seq
            
            df_codcnt = get_cod_freq(seq)
            all_dfs.append(df_codcnt) 

    concatenated_df = pd.concat(all_dfs, ignore_index=True)
    
    agg_functions = {
    'Obs_Freq': 'sum',    # Sum 'Obs_Freq'
    'Amino_acid': 'first',
    'GC3': 'first',
    'GC_content': 'first',  # Keep the first 'Amino_acid' value
    }

    summed_df = concatenated_df.groupby('Codon').agg(agg_functions).reset_index()
    summed_df.to_csv(f'{sp_name}_codon_usage.tsv', sep='\t', index=False)  

            

if __name__=='__main__':

    about = 'Computes relative synonymous codon usage per coding sequeunce'
    parse = argparse.ArgumentParser(description=about)

    parse.add_argument("-f", "--fasta",type=str, help="path to OG file to geenrate codon usage", required = True)

    args = parse.parse_args()

    main(args.fasta)

