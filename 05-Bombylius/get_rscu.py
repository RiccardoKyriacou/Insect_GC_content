import csv
import argparse


def read_tsv_file(file_path):
    data = []
    with open(file_path, 'r') as tsvfile:
        reader = csv.DictReader(tsvfile, delimiter='\t')
        for row in reader:
            data.append(row)
    return data

def calculate_total_codon_counts(data):
    codon_counts = {}
    gc3_values = {}
    gc_content_values = {}
    for row in data:
        amino_acid = row['Amino_acid']
        codon = row['Codon']
        obs_freq = int(row['Obs_Freq'])
        gc3 = int(row['GC3'])
        gc_content = float(row['GC_content'])
        
        if amino_acid not in codon_counts:
            codon_counts[amino_acid] = {}
            gc3_values[amino_acid] = {}
            gc_content_values[amino_acid] = {}
            
        codon_counts[amino_acid][codon] = obs_freq
        gc3_values[amino_acid][codon] = gc3
        gc_content_values[amino_acid][codon] = gc_content
        
    return codon_counts, gc3_values, gc_content_values

def calculate_total_amino_acid_counts(codon_counts):
    amino_acid_counts = {}
    for amino_acid, codons in codon_counts.items():
        total_count = sum(codons.values())
        amino_acid_counts[amino_acid] = total_count
    return amino_acid_counts

def calculate_RSCU(codon_counts, amino_acid_counts):
    RSCU_values = {}
    for amino_acid, codons in codon_counts.items():
        total_amino_acid_count = amino_acid_counts[amino_acid]
        RSCU_values[amino_acid] = {}
        for codon, obs_freq in codons.items():
            expected_freq = total_amino_acid_count / len(codons)
            
            RSCU_values[amino_acid][codon] = obs_freq / expected_freq
    return RSCU_values

if __name__ == "__main__":
    parse = argparse.ArgumentParser()

    parse.add_argument("-f", "--file",type=str, help="input file", required = True)

    args = parse.parse_args()

    tsv_file_path = args.file
    out_name = args.file.split("/")[-1].split(".tsv")[0]

    data = read_tsv_file(tsv_file_path)
    codon_counts, gc3_values, gc_content_values = calculate_total_codon_counts(data)
    amino_acid_counts = calculate_total_amino_acid_counts(codon_counts)
    RSCU_values = calculate_RSCU(codon_counts, amino_acid_counts)

    # Print the RSCU values along with GC3 and GC content
    with open(f"{out_name}_RSCU.tsv", "w") as outf:
        outf.write("Amino_acid\tCodon\tRSCU\tGC3\tGC_Content\n")
        for amino_acid, codons in RSCU_values.items():
            for codon, RSCU in codons.items():
                gc3 = gc3_values[amino_acid][codon]
                gc_content = gc_content_values[amino_acid][codon]
                outf.write(f"{amino_acid}\t{codon}\t{RSCU:.2f}\t{gc3}\t{gc_content:.2f}\n")

    
