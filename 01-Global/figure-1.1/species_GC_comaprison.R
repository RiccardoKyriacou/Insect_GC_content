#Combined insect genome plot
library(tidyverse)
library(ggplot2)
library(patchwork)
library(arm)
library(dplyr)

#Themes
box_theme <- theme_bw() + theme(plot.title = element_text(color="black", size=15),
                                panel.background = element_rect(fill="white"),
                                axis.title.x= element_text(color="black", size=18),
                                axis.text.x = element_text(size = 18), 
                                axis.title.y= element_text(color="black", size=18),
                                axis.text.y = element_text(size = 18), 
                                legend.position="right", 
                                legend.text = element_text(size=16), 
                                legend.title = element_text(size = 16))


#Genome 
Insect_genome <- read_tsv(file= "C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\01-Global\\data\\mean_genome_GCcontent.tsv"
                          ,col_names = FALSE)
Insect_genome
mean_genome_all <- mean(Insect_genome$X2)
mean_genome_all
#Add headings and parse
colnames(Insect_genome) <- c("species", "gc_genome", "order")
Insect_genome

#CDS 
cds_data <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\01-Global\\data\\mean_cds_GCcontent.tsv",
                       col_names = FALSE)
print(cds_data, n=150)
mean_cds_all <- mean(cds_data$X2)
mean_cds_all
#Add heading and parse
colnames(cds_data) <- c("species","gc_cds", "order")
cds_data

#GC3
GC3 <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\01-Global\\data\\mean_SCO_GC3content.tsv", 
                col_names = FALSE)
head(GC3)
GC3 <- GC3 %>%
  mutate(DNA_type = "GC3")
colnames(GC3) <- c("species", "gc", "order", "DNA_type")
GC3


# Add a new column to each table indicating the DNA type
Insect_genome$DNA_type <- "GC_genome"
cds_data$DNA_type <- "GC_cds"
colnames(Insect_genome) <- c("species","gc", "order", "DNA_type") #Re-name columns
colnames(cds_data) <- c("species","gc", "order", "DNA_type")


#Combine table
sp_combined_table <- rbind(Insect_genome, cds_data, GC3)
sp_combined_table

#Means
mean_genome <- aggregate(gc  ~ order, Insect_genome, mean)
mean_cds <- aggregate(gc  ~ order, cds_data, mean)
mean_GC3 <- aggregate(gc  ~ order, GC3, mean)
mean_genome
mean_cds
mean_GC3

sp_combined_table

box1 <- ggplot(sp_combined_table, aes(x = factor(DNA_type, levels = c("GC_genome", "GC_cds", "GC3")), y = gc, fill = order)) +
  geom_boxplot() + 
  scale_fill_manual(values=c("#91011C", "#218380", "#FBB13C", "#73D2DE"))+
  labs(x = "DNA type", y = "GC content (%)", fill = "Order") + 
  box_theme +
  scale_x_discrete(labels = c("Genome", "CDS", "GC3")) 

box1


