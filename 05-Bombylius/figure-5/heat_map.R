library(ggtree)
library(ggplot2)
library(patchwork)

file.choose()

#Tree
tree <- read.tree("C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\GC_Dip\\GC3\\results\\1to1_OGs\\tree\\SpeciesTree_rooted_node_labels.txt")

ggtree(tree) + geom_tiplab() + geom_nodelab(aes(label=node)) #ROTATE TREE ON NODE 

p <- ggtree(tree) + ggplot2::xlim(0, 0.9) + 
  geom_hilight(node=48, fill="#218380", alpha=.3, extendto=0.9) +
  geom_hilight(node=52, fill="#91EBCE", alpha=.3, extendto=0.9) +
  geom_hilight(node=66, fill="#218380", alpha=.3, extendto=0.9) + 
  geom_hilight(node=65, fill="#91EBCE", alpha=.3, extendto=0.9) +
  geom_hilight(node=62, fill="#218380", alpha=.3, extendto=0.9) +
  geom_hilight(node=56, fill="#91EBCE", alpha=.3, extendto=0.9) +
  geom_hilight(node=60, fill="#91EBCE", alpha=.3, extendto=0.9) +
  geom_hilight(node=58, fill="#91EBCE", alpha=.3, extendto=0.9) +
  geom_hilight(node=67, fill="#218380", alpha=.3, extendto=0.9)
p


#Heatmap
Ordered_OGs<- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\GC_chrm_runs\\GC_Dip\\GC3\\results\\1to1_OGs\\tree\\full_ordered_GC3.tsv")
Ordered_OGs

gg_heat_2 <- ggplot(Ordered_OGs, aes(fill = GC3 , x = Orthogroup, y = factor(Species, levels = unique(Species)))) + 
  geom_tile() + 
  scale_fill_viridis_c(option = "magma", limits = c(100, 0), trans = "reverse") +
  theme_minimal() + xlab("Single Copy Orthologues") + labs(fill = "GC3 (%)")+
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), legend.position = "top") 

gg_heat_2

#Combined plot
phylogeny_Dip2 <- p + gg_heat_2 
phylogeny_Dip2

