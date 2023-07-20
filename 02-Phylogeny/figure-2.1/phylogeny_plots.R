library(ggtreeExtra)
library(ggtree)
library(ggplot2)
library(ggnewscale)

#Loading in data 
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

### COLEOPTERA ###
#DATA
Col_cds <- cds_data %>% filter(order == "Coleoptera")
Col_genome <- Insect_genome %>% filter(order== "Coleoptera")
Col_GC3 <- GC3 %>% filter(order == "Coleoptera")
Col_cds
##Tree
SCOtree<-read.tree("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\Insects\\cds_vs_genome_comparison\\Col_phylogeny\\pruned_sptree.nwk")
SCOtree
p <- ggtree(SCOtree, layout="fan", size=0.15, open.angle=5) 
p <- ggtree(SCOtree, layout="fan", open.angle=20) + geom_tiplab() + geom_nodelab(aes(label = node))
#Colour tree 
p<-ggtree(SCOtree, layout="fan", open.angle=20) +
  geom_hilight(node=17, fill="#91011C", alpha=.3, extendto=0.53) +
  geom_hilight(node=24, fill="#D884A7", alpha=.3, extendto=0.53) +
  geom_hilight(node=29, fill="#91011C", alpha=.3, extendto=0.53) 
#Add GC3
p1<-p + new_scale_fill() + geom_fruit(data=Col_GC3, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.281, width = 0.05) +
  scale_alpha_continuous(range=c(0, 1),limits=c(25,56),guide=guide_legend(keywidth = 0.3, keyheight = 0.3, order=5)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=25))

p2 <- p1 + new_scale_fill() +
  geom_fruit(data = Col_cds, geom = geom_tile, mapping = aes(y = species, alpha = gc), offset = 0.115, width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))

p3 <- p2 + new_scale_fill() +
  geom_fruit(data = Col_genome, geom = geom_tile, mapping = aes(y = species, alpha = gc), offset = 0.115, width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))

Col_phylogeny <- p3
Col_phylogeny

### Hymenoptera ###
#DATA
Hym_cds <- cds_data %>% filter(order == "Hymenoptera")
Hym_genome <- Insect_genome %>% filter(order== "Hymenoptera")
Hym_GC3 <- GC3 %>% filter(order == "Hymenoptera")
Hym_GC3
##Tree
SCOtree<-read.tree("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\Insects\\cds_vs_genome_comparison\\Hym_phylogeny\\pruned_sptree.nwk")
SCOtree
p <- ggtree(SCOtree, layout="fan", size=0.15, open.angle=5) 
p <- ggtree(SCOtree, layout="fan", open.angle=20) + geom_tiplab() + geom_nodelab(aes(label = node))
p
#Colour tree
p<-ggtree(SCOtree, layout="fan", open.angle=20) +
  geom_hilight(node=63, fill="#FAA825", alpha=.3, extendto=0.33) +
  geom_hilight(node=60, fill="#FDD975", alpha=.3, extendto=0.33) +
  geom_hilight(node=55, fill="#FAA825", alpha=.3, extendto=0.33) +
  geom_hilight(node=38, fill="#FDD975", alpha=.3, extendto=0.33) + 
  geom_hilight(node=40, fill="#FDD975", alpha=.3, extendto=0.33) +
  geom_hilight(node=43, fill="#FAA825", alpha=.3, extendto=0.33) +
  geom_hilight(node=52, fill="#FDD975", alpha=.3, extendto=0.33) +
  geom_hilight(node=48, fill="#FAA825", alpha=.3, extendto=0.33) 
p
#Add GC3
p1<-p + new_scale_fill() + geom_fruit(data=Hym_GC3, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.089, width = 0.05) +
  scale_alpha_continuous(range=c(0, 1),limits=c(25,56),guide=guide_legend(keywidth = 0.3, keyheight = 0.3, order=5)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=25))

p2 <- p1 + new_scale_fill() +
  geom_fruit(data = Hym_cds, geom = geom_tile, mapping = aes(y = species, alpha = gc), offset = 0.153, width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))

p3 <- p2 + new_scale_fill() +
  geom_fruit(data = Hym_genome, geom = geom_tile, mapping = aes(y = species, alpha = gc), offset = 0.153, width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))
p3
Hym_phylogeny <- p3
Hym_phylogeny

### Diptera ###
#DATA
Dip_cds <- cds_data %>% filter(order == "Diptera")
Dip_genome <- Insect_genome %>% filter(order== "Diptera")
Dip_GC3 <- GC3 %>% filter(order == "Diptera")
##Tree
SCOtree<-read.tree("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\Insects\\cds_vs_genome_comparison\\Dip_phylogeny\\pruned_sptree.nwk")
SCOtree
p <- ggtree(SCOtree, layout="fan", size=0.15, open.angle=5) 
p <- ggtree(SCOtree, layout="fan", open.angle=20) + geom_tiplab() + geom_nodelab(aes(label = node))
#Colour tree 
p<-ggtree(SCOtree, layout="fan", open.angle=20) +
  geom_hilight(node=46, fill="#218380", alpha=.3, extendto=0.52) +
  geom_hilight(node=50, fill="#91EBCE", alpha=.3, extendto=0.52) +
  geom_hilight(node=64, fill="#218380", alpha=.3, extendto=0.52) + 
  geom_hilight(node=63, fill="#91EBCE", alpha=.3, extendto=0.52) +
  geom_hilight(node=60, fill="#218380", alpha=.3, extendto=0.52) +
  geom_hilight(node=54, fill="#91EBCE", alpha=.3, extendto=0.52) +
  geom_hilight(node=58, fill="#91EBCE", alpha=.3, extendto=0.52) +
  geom_hilight(node=56, fill="#91EBCE", alpha=.3, extendto=0.52) +
  geom_hilight(node=65, fill="#218380", alpha=.3, extendto=0.52) 

p
#Add GC3
p1<-p + new_scale_fill() + geom_fruit(data=Dip_GC3, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.05, width = 0.05) +
  scale_alpha_continuous(range=c(0, 1),limits=c(25,56),guide=guide_legend(keywidth = 0.3, keyheight = 0.3, order=5)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=25))

p2 <-p1 + new_scale_fill() + geom_fruit(data=Dip_cds, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.0967, width = 0.05) +
  scale_alpha_continuous(range=c(0, 1),limits=c(25,56),guide=guide_legend(keywidth = 0.3, keyheight = 0.3, order=5)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=25))

p3 <- p2 + new_scale_fill() +
  geom_fruit(data = Dip_genome, geom = geom_tile, mapping = aes(y = species, alpha = gc), offset = 0.0967, width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))
p3
Dip_phylogeny <- p3


### LEPIDOPTERA ###
#DATA
Lep_cds <- cds_data %>% filter(order == "Lepidoptera")
Lep_genome <- Insect_genome %>% filter(order== "Lepidoptera")
Lep_GC3 <- GC3 %>% filter(order == "Lepidoptera")
##Tree
SCOtree<-read.tree("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\GC_Lep_new\\GC3\\results\\species_tree_lep.tsv")
SCOtree
p <- ggtree(SCOtree, layout="fan", size=0.15, open.angle=5) 
p <- ggtree(SCOtree, layout="fan", open.angle=20) + geom_tiplab() + geom_nodelab(aes(label = node))
p

#Colour tree 
p<-ggtree(SCOtree, layout="fan", open.angle=20) +
  geom_hilight(node=63, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=65, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=68, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=70, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=77, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=82, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=85, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=89, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=92, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=97, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=100, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=102, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=108, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=118, fill="#6AC4FC", alpha=.3, extendto=0.8) +
  geom_hilight(node=112, fill="#1759E7", alpha=.3, extendto=0.8) +
  geom_hilight(node=114, fill="#6AC4FC", alpha=.3, extendto=0.8)

p

p1<-p + new_scale_fill() + geom_fruit(data=Lep_GC3, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.05, width = 0.05) +
  scale_alpha_continuous(range=c(0, 1),limits=c(25,56),guide=guide_legend(keywidth = 0.3, keyheight = 0.3, order=5)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=25))

p2 <- p1 + new_scale_fill() + geom_fruit(data=Lep_cds, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.0635,width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))


p3 <- p2 + new_scale_fill() + geom_fruit(data=Lep_genome, geom=geom_tile, mapping=aes(y=species, alpha=gc), offset = 0.0635,width = 0.05) +
  scale_alpha_continuous(range = c(0, 1), limits = c(25, 56), guide = guide_legend(keywidth = 0.3, keyheight = 0.3, order = 5), 
                         breaks = seq(25, 56, by = 5),
                         labels = c("<25", "30", "35","40","45","50",">55")) +  
  labs(alpha = "<25", "30")+
  theme(legend.title = element_blank(), legend.text = element_text(size = 25))


p3
Lep_phylogeny <- p3


(Lep_phylogeny + Dip_phylogeny) / (Hym_phylogeny + Col_phylogeny) + plot_layout(guides = "collect")
