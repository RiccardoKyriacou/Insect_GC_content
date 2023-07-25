library(ggplot2)
library(patchwork)
library(tidyverse)
library(tidyr)

#Themes
box_theme <- theme_bw() + theme(plot.title = element_text(color="black", size=16),
                                panel.background = element_rect(fill="white"), 
                                axis.title.x= element_text(color="black", size=18),
                                axis.title.y= element_text(color="black", size=18),
                                axis.text.y = element_text(size = 18))

#B major
codons <- read_tsv("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\05-Bombylius\\codon_usage\\Bombylius_major_codon_usage.tsv")
codons
# Sort the data frame by the "Amino_acid" column
codons <- codons[order(codons$Amino_acid), ]

# Define the desired order of the codons based on the sorted data frame
desired_codon_order <- unique(codons$Codon)

# Convert the "Codon" column to a factor with the desired order
codons$Codon <- factor(codons$Codon, levels = desired_codon_order)
codons
# Create the plot
bomb_title <- expression(paste("Codon usage in ", italic("Bombylius major"), " single copy orthologues"))
plot_major <- ggplot(data = codons, aes(x = Codon, y = Obs_Freq, fill = GC3)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle(bomb_title)+  xlab("Codon") + ylab("Frequency")+
  geom_text(aes(label = Amino_acid), position = position_dodge(width = 1), vjust = -1, hjust = 0.5) +
  scale_fill_gradient(low = "#feca8d", high = "#9b2e7f") + box_theme + ylim(0, 30000)
 
plot_major

#Outgroup
codons <- read_tsv("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\05-Bombylius\\codon_usage\\Machimus_atricapillus_codon_usage.tsv")
codons
# Sort the data frame by the "Amino_acid" column
codons <- codons[order(codons$Amino_acid), ]

# Define the desired order of the codons based on the sorted data frame
desired_codon_order <- unique(codons$Codon)

# Convert the "Codon" column to a factor with the desired order
codons$Codon <- factor(codons$Codon, levels = desired_codon_order)

# Create the plot
out_title <- expression(paste("Codon usage in ", italic("Machimus atricapillus"), " single copy orthologues"))
plot_out <- ggplot(data = codons, aes(x = Codon, y = Obs_Freq, fill = GC3)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  geom_text(aes(label = Amino_acid), position = position_dodge(width = 1), vjust = -1, hjust = 0.5) +
  ggtitle(out_title)+  xlab("Codon") + ylab("Frequency")+
  scale_fill_gradient(low = "#feca8d", high = "#9b2e7f") + box_theme +ylim(0, 30000)
                                                                           


# Display the plot
plot_major / plot_out



