library(ggplot2)
library(RColorBrewer)
library(patchwork)
library(tidyverse)

#file.choose() 
GC3_OGdata<- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\GC_Lep_new\\GC3\\results\\trimmedGC3_ortogroups.tsv")
head(GC3_OGdata)


#Order data by chromos
GC3_OGdata_ordered <- GC3_OGdata
GC3_OGdata_ordered$chrm_no <- factor(GC3_OGdata_ordered$chrm_no,
                                     levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20", "21","22","23","24","25","26","27","28","29","30","Z"))
GC3_OGdata_ordered


#Theme
my_theme <- theme_minimal() + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill="white"),
        plot.title = element_text(color="black", size=18),
        axis.title.y= element_text(color="black", size=12),
        axis.title = element_text(size = 16),
        axis.text = element_text(size = 10),axis.text.x = element_blank(), 
        plot.tag = element_text(size = 22, face = "bold"), 
        legend.position="bottom", legend.text = element_text(size=12))

#Plutella_xylostella - Highest GC3
Plutella_xylostella <- ggplot(GC3_OGdata_ordered %>% filter(species == "Plutella_xylostella")) +
  facet_wrap(. ~ chrm_no, ncol = 3) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(0, 100)) +
  xlab("") + ylab("GC3 (%)") + my_theme + ylim(0, 100) +
  ggtitle("GC3 along Plutella xylostella chromosomes") + labs(color = "GC3%")+ guides(color = "none")+
  theme(plot.title = element_text(size = 18, margin = margin(b = 10, t = 10)))
Plutella_xylostella


#Zygaena_filipendulae - Middle GC3
Zygaena_filipendulae <- ggplot(GC3_OGdata_ordered %>% filter(species == "Zygaena_filipendulae")) +
  facet_wrap(. ~ chrm_no, ncol = 3) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(0, 100)) +
  xlab("") + ylab("") + my_theme + ylim(0, 100) +
  ggtitle("GC3 along Zygaena filipendulae chromosomes") + labs(color = "GC3%")+ guides(color = "none")+
  theme(plot.title = element_text(size = 18, margin = margin(b = 10, t = 10)))
Zygaena_filipendulae


#Orgyia_antiqua - Lowest GC3
Orgyia_antiqua <- ggplot(GC3_OGdata_ordered %>% filter(species == "Orgyia_antiqua")) +
  facet_wrap(. ~ chrm_no, ncol = 3) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(0, 100)) +
  xlab("") + yab("") + my_theme + ylim(0, 100) +
  ggtitle("GC3 along Orgyia antiqua chromosomes") + labs(color = "GC3%")+
  theme(plot.title = element_text(size = 18, margin = margin(b = 10, t = 10)), 
        legend.position = "right",
        legend.direction = "vertical")
Orgyia_antiqua


##Thymelicus_sylvestris- Lowest GC3
Thymelicus_sylvestris <- ggplot(GC3_OGdata_ordered %>% filter(species == "Thymelicus_sylvestris")) +
  facet_wrap(. ~ chrm_no, ncol = 3) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(0, 100)) +
  xlab("") + ylab("") + my_theme + ylim(0, 100) +
  ggtitle("GC3 along Thymelicus_sylvestris  chromosomes") + labs(color = "GC3%")+
  theme(plot.title = element_text(size = 18, margin = margin(b = 10, t = 10)), 
        legend.position = "right",
        legend.direction = "vertical")
Thymelicus_sylvestris


Plutella_xylostella + Zygaena_filipendulae + Orgyia_antiqua  + plot_layout(guides = "collect")


#Testing telomere distance 
#Euclidia_mi
Euclidia_mi <- ggplot(GC3_OGdata_ordered %>% filter(species == "Euclidia_mi")) +
  facet_wrap(. ~ chrm_no, ncol = 3) +
  geom_point(mapping = aes(x = as.numeric(start_position), y = as.numeric(GC3_percent), color = GC3_percent), size = 2) + 
  scale_color_viridis_c(option = "magma", limits = c(0, 100)) +
  xlab("") + ylab("") + my_theme + ylim(0, 100) +
  ggtitle("GC3 along Euclidia_mi chromosomes") + labs(color = "GC3%")+
  theme(plot.title = element_text(size = 18, margin = margin(b = 10, t = 10)), 
        legend.position = "right",
        legend.direction = "vertical")
Euclidia_mi
