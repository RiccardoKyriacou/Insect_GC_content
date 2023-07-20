library(ggtree)
library(ggplot2)
library(patchwork)
library(tidyverse)
library(tidyr)
library(gridExtra)
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

## Mean T distance - Lepidoptera ###
mean_distance <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\04-Telomeres\\data\\Lep\\mean_t_distance.tsv")

mean_d <- ggplot(data = mean_distance, aes(x = as.numeric(t_distance), y = GC3)) +
  geom_point(colour = "#73D2DE", size = 2) +
  labs(x = "", y = "") +
  ggtitle("Lepidoptera") + box_theme +
  ylim(0, 100) +
  scale_x_continuous(breaks = c(2.5e+06, 5e+06, 7.5e+06, 1e+07), labels = c("2.5", "5", "7.5", "10"))
mean_d
# Linear regression
regression <- lm(GC3 ~ as.numeric(t_distance), data = mean_distance)
summary(regression) #-1.868e-06
# Add regression 
mean_Lep <- mean_d +
  geom_abline(intercept = regression$coefficients[1], slope = regression$coefficients[2], color = "darkblue", linewidth = 1) +
  annotate("text", x = max(mean_distance$t_distance), y = 95, label = "β = -1.9e-06 (***)", hjust = 1, vjust = 1, color = "darkblue", size = 7)
mean_Lep


## Mean T distance - Coleoptera ###
mean_distance <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\04-Telomeres\\data\\Col\\mean_t_distance.tsv")
mean_col <- ggplot(data = mean_distance, aes(x = as.numeric(t_distance), y = GC3)) +
  geom_point(colour = "#91011C", size = 2)+
  labs(x = "", y = "") + ggtitle("Coleoptera") + box_theme+ylim(0,100)+ 
  scale_x_continuous(breaks = c(1e+07, 2e+07), labels = c("10", "20"))
mean_col
# Linear regression
regression <- lm(GC3 ~ as.numeric(t_distance), data = mean_distance)
summary(regression) #-2.639e-07
# Add to plot
mean_Col<- mean_col +
  geom_abline(intercept = regression$coefficients[1], slope = regression$coefficients[2], color = "darkblue", linewidth = 1) +
  annotate("text", x = max(mean_distance$t_distance), y = 95, label = "β = -2.6e-07 (***)", hjust = 1, vjust = 1, color = "darkblue", size = 7)


## Mean T distance - Hymenoptera ###
mean_distance <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\04-Telomeres\\data\\Hym\\mean_t_distance.tsv")
mean_hym <- ggplot(data = mean_distance, aes(x = as.numeric(t_distance), y = GC3)) +
  geom_point(colour = "#FBB13C", size = 2)+
  labs(x = "", y = "") + ggtitle("Hymenoptera") + box_theme+ylim(0,100)+
  scale_x_continuous(breaks = c(4e+06, 6e+06, 8.5e+06, 1e+07), labels = c("4", "6", "8", "10"))
mean_hym
# Linear regression
regression <- lm(GC3 ~ as.numeric(t_distance), data = mean_distance)
summary(regression) #-9.631e-07
# Add to plot
mean_Hym<- mean_hym +
  geom_abline(intercept = regression$coefficients[1], slope = regression$coefficients[2], color = "darkblue", linewidth = 1) +
  annotate("text", x = max(mean_distance$t_distance), y =95, label = "β = -9.6e-07 (***)", hjust = 1, vjust = 1, color = "darkblue", size = 7)
mean_Hym 

## Mean T distance - Diptera ###
mean_distance <- read_tsv(file="C:\\Users\\Ricca\\OneDrive\\Documents\\University\\Y4\\Paper\\04-Telomeres\\data\\Dip\\mean_t_distance.tsv")
mean_dip <- ggplot(data = mean_distance, aes(x = as.numeric(t_distance), y = GC3)) +
  geom_point(colour = "#218380", size = 2)+
  labs(x = "", y = "") + ggtitle("Diptera") + box_theme+ylim(0,100)+
  scale_x_continuous(breaks = c(0e+00, 2e+07, 4e+07, 6e+07), labels = c("0", "20", "40", "60"))
mean_dip
# Linear regression
regression <- lm(GC3 ~ as.numeric(t_distance), data = mean_distance)
summary(regression) #-2.195e-08 NS 
# Add to plot
mean_Dip <- mean_dip +
  geom_abline(intercept = regression$coefficients[1], slope = regression$coefficients[2], color = "darkblue", linewidth = 1) +
  annotate("text", x = max(mean_distance$t_distance), y = 95, label = "NS", hjust = 1, vjust = 1, color = "darkblue", size = 7)
mean_Dip

#Add lims 
combined_plot <- (mean_Lep + mean_Hym) / (mean_Col + mean_Dip) 
combined_plot
