library(ggtree)
library(ggplot2)
library(patchwork)
library(tidyverse)
library(tidyr)

file.choose()

sneath_data <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\gene_evolution\\Dip\\results\\Bombylius_analysis\\sneath_R_output.tsv")
head(sneath_data)


#Continuous 
#Control 
plot_Bm_Bd <- ggplot(sneath_data)+
  geom_point(mapping =
               aes(x =as.numeric(Bombylius_major), y =as.numeric(Bombylius_discolor)), colour = "#218380", size = 2)+
  geom_abline(slope=1, intercept=0, size = 0.8, linetype = "dashed")+
  xlab("Bombylius_major") + ylab("Bombylius_discolor ") + ggtitle("Adjusted Sneath value distribution") + xlim(0,10)+ylim(0,10)

plot_Bm_Bd



#Bombylius_major  vs Coremacera_marginata  
gradient_1 <- ggplot(sneath_data)+
  geom_point(mapping =
               aes(x =as.numeric(Bombylius_major), y =as.numeric(Machimus_atricapillus), color = Bombylius_major_GC3), size = 2)+
  scale_color_viridis_c(option = "magma", limits=c(100, 0), trans = "reverse")+
  geom_abline(slope=1, intercept=0, size = 0.8, linetype = "dashed")+ labs(color = "GC3%")+ guides(color = "none") + 
  xlab("Bombylius_major") + ylab("Machimus_atricapillus") + ggtitle("Adjusted Sneath value distribution") + ylim(0, 10)+ xlim(0, 10)

gradient_2 <- ggplot(sneath_data)+
  geom_point(mapping =
               aes(x =as.numeric(Bombylius_discolor), y =as.numeric(Machimus_atricapillus), color = Bombylius_discolor_GC3), size = 2)+
  scale_color_viridis_c(option = "magma", limits=c(100, 0), trans = "reverse")+
  geom_abline(slope=1, intercept=0, size = 0.8, linetype = "dashed")+ labs(color = "GC3%")+ 
  xlab("Bombylius_discolor") + ylab("Machimus_atricapillus") + ggtitle("Adjusted Sneath value distribution") + ylim(0, 10)+ xlim(0, 10)

gradient_2

box_theme <- theme_bw() + theme(plot.title = element_text(color="black", size=20),
                                panel.background = element_rect(fill="grey95"),
                                axis.title.x= element_text(color="black", size=20),
                                axis.text.x = element_text(size = 18), 
                                axis.title.y= element_text(color="black", size=20),
                                axis.text.y = element_text(size = 18), 
                                legend.position="bottom", 
                                legend.text = element_text(size=16), 
                                legend.title = element_text(size = 16))


#Plots
(plot_Bm_Bd + gradient_1 + gradient_2) & box_theme


#Statistics 
sneath_data

#Check normality 
shapiro.test(sneath_data$Bombylius_major)
shapiro.test(sneath_data$Bombylius_discolor)
shapiro.test(sneath_data$Machimus_atricapillus)

#Two bomblyius 
cor.test(sneath_data$Bombylius_major, sneath_data$Bombylius_discolor, method=c("pearson"))
#major vs robber 
cor.test(sneath_data$Bombylius_major, sneath_data$Machimus_atricapillus, method=c("pearson"))
#discolor vs robber 
cor.test(sneath_data$Bombylius_discolor, sneath_data$Machimus_atricapillus, method=c("pearson"))

