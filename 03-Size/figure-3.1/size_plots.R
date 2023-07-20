library(tidyverse)
library(ggplot2)
library(patchwork)
library(arm)
library(dplyr)


file.choose()
#Genome data
New_insect_genomes <- read_tsv(file= "C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\03-Size\\data\\combined_genome_data.tsv"
                          ,col_names = FALSE)
New_insect_genomes
colnames(New_insect_genomes) <- c("species", "size", "gc", "chromosome", "order")
head(New_insect_genomes)

#Themes
my_theme <- theme_minimal() + theme(plot.title = element_text(color="black", face = "bold", size=22),
                                    panel.background = element_rect(fill="white"),
                                    title =element_text(size=20), 
                                    axis.title.x= element_text(color="black", size=20),
                                    axis.title.y= element_text(color="black", size=20),
                                    axis.text.x = element_text(size = 14),
                                    axis.text.y = element_text(size = 20),
                                    legend.position="bottom", legend.text = element_text(size=20))

theme_no_legend <- theme_minimal() + theme(plot.title = element_text(color="black", face = "bold", size=22),
                                              panel.background = element_rect(fill="white"),
                                              strip.text = element_text(size=20), 
                                              axis.title.x= element_text(color="black", size=20),
                                              axis.title.y= element_text(color="black", size=20),
                                              axis.text.x = element_text(size = 14),
                                              axis.text.y = element_text(size = 20),
                                              legend.position="None", legend.text = element_text(size=20))


#Plot 
plot_Insect_genomes<- ggplot(data = New_insect_genomes)+ 
  geom_point(mapping = aes(x =as.numeric(size), y =as.numeric(gc), colour = order), alpha = 0.5, size = 2)+
  scale_colour_manual(values=c("#91011C", "#218380", "#FBB13C", "#73D2DE"))+
  geom_hline(yintercept=50, linetype="dashed", color = "black") +
  xlab("Chromosome length (Mb)") + ylab("GC content (%)") + ggtitle("A") + labs(colour="")+ 
  my_theme + ylim(20, 60) + guides(color = guide_legend(override.aes = list(size = 5)))+
  scale_x_continuous(breaks = c(0e+00, 1e+08, 2e+08, 3e+08, 4e+08), labels = c("0", "100", "200", "300", "400"))

#Facet
Insect_orders<- ggplot(data = New_insect_genomes)+ facet_wrap(. ~order, ncol=2)+
  geom_point(mapping = aes(x =as.numeric(size), y =as.numeric(gc), colour = order), alpha = 0.5, size = 2)+
  scale_colour_manual(values=c("#91011C", "#218380", "#FBB13C", "#73D2DE"))+
  geom_hline(yintercept=50, linetype="dashed", color = "black") +
  xlab("") + ylab("") + ggtitle("B") + labs(colour="")+ 
  scale_x_continuous(breaks = c(0e+00, 1e+08, 2e+08, 3e+08, 4e+08), labels = c("0", "100", "200", "300", "400"))+
  theme_no_legend

plot <- plot_Insect_genomes + Insect_orders
plot 


#Stats
#ANCOVA 0) Linear regression all insects
head(New_insect_genomes)
ggplot(New_insect_genomes, aes(x = size, y = gc )) + 
  geom_point()
#Regression
lm <- lm(gc  ~ size, New_insect_genomes)
#Summary
summary(lm)

#ANCOVA 1.1) Genome
#ANCOVA
genome_lm <- lm(gc  ~ size + order, New_insect_genomes)
#Check linearity  
plot(genome_lm, which = 1)
plot(genome_lm, which = 2)
#Summary
summary(genome_lm)
anova(genome_lm)

#Linear regression 1.2) Genome Lep
reg <- lm(gc  ~ size, New_insect_genomes%>% filter(order == "Lepidoptera"))
ggplot(New_insect_genomes%>% filter(order == "Lepidoptera"), aes(x = size, y = gc )) + 
  geom_point()
summary(reg) #SIGNIFICANT POSITIVE

#Linear regression 1.3) Genome Col
reg <- lm(gc  ~ size, New_insect_genomes%>% filter(order == "Coleoptera"))
ggplot(New_insect_genomes%>% filter(order == "Coleoptera"), aes(x = size, y = gc )) + 
  geom_point()
summary(reg)

#Linear regression 1.4) Genome Dip
reg <- lm(gc  ~ size, New_insect_genomes%>% filter(order == "Diptera"))
ggplot(New_insect_genomes%>% filter(order == "Diptera"), aes(x = size, y = gc )) + 
  geom_point()
summary(reg) #SIGNIFICANT NEGATIVE

#Linear regression 1.5) Genome Hym
reg <- lm(gc  ~ size, New_insect_genomes%>% filter(order == "Hymenoptera"))
ggplot(New_insect_genomes%>% filter(order == "Hymenoptera"), aes(x = size, y = gc )) + 
  geom_point()
summary(reg) #SIGNIFICANT POSITIVE


