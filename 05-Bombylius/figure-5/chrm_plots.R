library(ggplot2)
library(RColorBrewer)
library(patchwork)
library(tidyverse)
library(tidyr)


#file.choose() 
Dip_OGdata<- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\GC_Dip\\GC3\\results\\1to1_OGs\\trimmedGC3_ortogroups.tsv")
#Order data by chromos
Dip_OGdata_ordered <- Dip_OGdata
Dip_OGdata_ordered$chrm_no <- factor(Dip_OGdata_ordered$chrm_no,
                                     levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20", "21","22","23","24","25","26","27","28","29","30","X", "Y"))

my_theme <- theme_minimal() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill="white"),
        plot.title = element_text(color="black", size=15),
        axis.title.y= element_text(color="black", size=18),
        axis.title = element_text(size = 20),
        axis.text = element_text(size = 16),axis.text.x = element_blank(), 
        plot.tag = element_text(size = 20, face = "bold"), 
        legend.position="right", legend.text = element_text(size=12))

# Bombylius_major - Continuous
bomb_title <- expression(paste("GC3 along ", italic("Bombylius major"), " chromosomes"))
Bomb_chrm <- ggplot(Dip_OGdata_ordered %>% filter(species == "Bombylius_major")) +
  facet_wrap(. ~ chrm_no, ncol = 1) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(100, 0), trans="reverse") +
  xlab("") + ylab("GC3 (%)") + my_theme + ylim(0, 100) +
  ggtitle(bomb_title) + labs(color = "GC3%")+ my_theme

Bomb_chrm

disc_title <- expression(paste("GC3 along ", italic("Bombylius discolor"), " chromosomes"))
Disc_chrm <- ggplot(Dip_OGdata_ordered %>% filter(species == "Bombylius_discolor")) +
  facet_wrap(. ~ chrm_no, ncol = 1) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(100, 0), trans="reverse") +
  xlab("") + ylab("") + my_theme + ylim(0, 100) +
  ggtitle(disc_title) + labs(color = "GC3%")+my_theme
Disc_chrm

Bomb_chrm + Disc_chrm + plot_layout(guides="collect")

