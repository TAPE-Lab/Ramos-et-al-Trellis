library(ComplexHeatmap)
library(circlize)
library (RColorBrewer)
library(dplyr)
library(ggplot2)
library(ggalluvial)
library(networkD3)
library(caret)


sn_21 <- read.csv (file = '~/Dropbox/From_python_to_R/Cell_state_H_PDO23')
sn_21 <- subset(sn_21, (Culture =='PDO') & (Treatment == 'AH' | (Treatment == 'F' & Concentration == 4)))
sn_21$Treatment <- as.factor(sn_21$Treatment)
down_sn_21 <- downSample(x = sn_21, y = sn_21$Treatment)
#summary <- down_sn_21 %>% count(Treatment, Phase, Phase_H)
sn_21_cs <- subset(down_sn_21, select = c(Treatment, Phase))
sum_sn_21_cs <- sn_21_cs %>% count(Treatment, Phase)
sn_21_h <- subset(down_sn_21, select = c(Treatment, Phase, Phase_H))
sn_21_h_cs <- sn_21_h %>% count(Treatment,Phase, Phase_H)

#Create nodes dataframe
histones <- rev(unique(as.character(sn_21_h_cs$Phase_H)))
phases <- rev(unique(as.character(sum_sn_21_cs$Phase)))
nodes <- data.frame(node = c(0:19), name = c('AH', 'F', histones, phases))

sn_21_h_cs <- merge(sn_21_h_cs, nodes, by.x = 'Phase', by.y = 'name')
sn_21_h_cs <- merge(sn_21_h_cs, nodes, by.x = 'Phase_H', by.y = 'name')
sum_sn_21_cs <- merge(sum_sn_21_cs, nodes, by.x = 'Treatment', by.y = 'name')
sum_sn_21_cs <- merge(sum_sn_21_cs, nodes, by.x = 'Phase', by.y = 'name')

sn_21_h_cs <- rename(sn_21_h_cs, 'source' = 'node.x')
sn_21_h_cs <- rename(sn_21_h_cs, 'target' = 'node.y')
sn_21_h_cs <- rename(sn_21_h_cs, 'value' = 'n')
sum_sn_21_cs <- rename(sum_sn_21_cs, 'source' = 'node.x')
sum_sn_21_cs <- rename(sum_sn_21_cs, 'target' = 'node.y')
sum_sn_21_cs <- rename(sum_sn_21_cs, 'value' = 'n')

sn_21_h_cs <- sn_21_h_cs %>%mutate(group = case_when(Treatment == 'AH' ~ 'group_1', Treatment == 'F' ~ 'group_2'))
sum_sn_21_cs <- sum_sn_21_cs %>%mutate(group = case_when(Treatment == 'AH' ~ 'group_1', Treatment == 'F' ~ 'group_2'))

sum_sn_21_cs$target <- as.numeric(sum_sn_21_cs$target)
sum_sn_21_cs$source <- as.numeric(sum_sn_21_cs$source)
sn_21_h_cs$target <- as.numeric(sn_21_h_cs$target)
sn_21_h_cs$source <- as.numeric(sn_21_h_cs$source)

n <- sn_21_h_cs[, c('source', 'target', 'value', 'group')]
c_s <- sum_sn_21_cs[, c('source', 'target', 'value', 'group')]
links <- bind_rows(n, c_s)

my_color <- 'd3.scaleOrdinal().domain(
  ["group_1", "group_2", "S_phase", "M_phase", "G2_phase", "G1_phase", "G0_phase", "Apoptosis"]).range(
  ["grey", "rgba(148, 33, 147, 1)", "rgba(235, 81, 247, 1)", "rgba(234, 82, 246, 1)", "rgba(238, 123, 247, 1)", 
"rgba(248, 212, 252, 1)", "rgba(158, 216, 151, 1)", "rgba(82, 179, 57, 1)"])'

networkD3::sankeyNetwork(Links = links, Nodes = nodes, 
                         Source = 'source', 
                         Target = 'target', 
                         Value = 'value', 
                         NodeID = 'name', 
                         nodeWidth = 10, nodePadding = 15,colourScale=my_color, LinkGroup="group", 
                         fontSize = 0, iterations =0)

