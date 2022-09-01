library(ComplexHeatmap)
library(circlize)
library (RColorBrewer)
library(dplyr)
library(networkD3)
library(caret)

#Load datframes
sn_21 <- read.csv (file = '~/Dropbox/From_python_to_R/All_phase_all_levels_for_sankey_75')
sn_21 <- subset(sn_21, (Culture =='PDO' & Replicate == 'C') & (Level != 1) & (Treatment == 'AH' | (Treatment == 'F' & Concentration == 3)))
sn_21$Treatment <- as.factor(sn_21$Treatment)
sn_21 <- subset(sn_21, select = c(Treatment, Level, Phase, Node, Proportion, Parent)) 
sn_21_4 <- subset(sn_21, (Level == 4))
sn_21_all <- subset(sn_21, (Level != 4))



parents <- unique(as.character(sn_21$Node))
phases <- unique(as.character(sn_21$Phase))
nodes <- data.frame(node = c(0:127), name = c('AH', 'F', parents))

sn_21_all <- merge(sn_21_all, nodes, by.x = 'Parent', by.y = 'name')
sn_21_all <- merge(sn_21_all, nodes, by.x = 'Node', by.y = 'name')
sn_21_4 <- merge(sn_21_4, nodes, by.x = 'Treatment', by.y = 'name')
sn_21_4 <- merge(sn_21_4, nodes, by.x = 'Node', by.y = 'name')

sn_21_all <- rename(sn_21_all, 'source' = 'node.x')
sn_21_all <- rename(sn_21_all, 'target' = 'node.y')
sn_21_all <- rename(sn_21_all, 'value' = 'Proportion')
sn_21_4 <- rename(sn_21_4, 'source' = 'node.x')
sn_21_4 <- rename(sn_21_4, 'target' = 'node.y')
sn_21_4 <- rename(sn_21_4, 'value' = 'Proportion')

sn_21_all <- sn_21_all %>%mutate(group = case_when(Treatment == 'AH' ~ 'group_1', Treatment == 'F' ~ 'group_2'))
sn_21_4 <- sn_21_4 %>%mutate(group = case_when(Treatment == 'AH' ~ 'group_1', Treatment == 'F' ~ 'group_2'))
#nodes <- nodes %>%mutate(group = case_when(name == ('DMSO') ~ 'group_1', name == ('S') ~ 'group_2', node >= (2) & node <= (6) ~ 'S_phase',
#                                          node >= (7) & node <= (11) ~ 'M_phase', node >= (12) & node <= (16) ~ 'G2_phase',
 #                                          node >= (17) & node <= (21) ~ 'G1_phase', node >= (22) & node <= (26) ~ 'G0_phase',
  #                                         node >= (27) & node <= (33) ~ 'Apoptosis'))
#nodes <- nodes %>%mutate(group = case_when(name == ('DMSO') ~ 'group_1', name == ('S') ~ 'group_2', node >= (2) & node <= (86) ~ 'S_phase',
 #                                          node >= (87) & node <= (167) ~ 'M_phase', node >= (168) & node <= (252) ~ 'G2_phase',
  #                                         node >= (253) & node <= (337) ~ 'G1_phase', node >= (338) & node <= (422) ~ 'G0_phase',
   #                                        node >= (423) & node <= (504) ~ 'Apoptosis'))
nodes <- nodes %>%mutate(group = case_when(name == ('AH') ~ 'group_1', name == ('F') ~ 'group_2', node >= (2) & node <= (22) ~ 'S_phase',
                                          node >= (23) & node <= (43) ~ 'M_phase', node >= (44) & node <= (64) ~ 'G2_phase',
                                         node >= (65) & node <= (85) ~ 'G1_phase', node >= (86) & node <= (106) ~ 'G0_phase',
                                        node >= (107) & node <= (128) ~ 'Apoptosis'))
sn_21_all$target <- as.numeric(sn_21_all$target)
sn_21_all$source <- as.numeric(sn_21_all$source)
sn_21_4$target <- as.numeric(sn_21_4$target)
sn_21_4$source <- as.numeric(sn_21_4$source)

n <- sn_21_all[, c('source', 'target', 'value', 'Level', 'group')]
c_s <- sn_21_4[, c('source', 'target', 'value', 'Level', 'group')]
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
                         nodeWidth = 10, nodePadding = 1,
                         colourScale=my_color, LinkGroup="group", fontSize = 0, NodeGroup="group", iterations =0)


