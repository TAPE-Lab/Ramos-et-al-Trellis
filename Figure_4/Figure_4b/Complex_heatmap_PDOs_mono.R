library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)
library(dplyr)
library(viridis)

metadata_proportions_5 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_5')
metadata_proportions_11 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_11')
metadata_proportions_21 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_21')
metadata_proportions_23 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_23')
metadata_proportions_27 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_27')
metadata_proportions_75 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_75')
metadata_proportions_99 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_99')
metadata_proportions_109 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_109')
metadata_proportions_141 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_141')
metadata_proportions_216 <- read.csv(file = '~/Dropbox/From_python_to_R/Fig4_HM/Fold_change_CS_H2A_216')

whole_metadata <- rbind(metadata_proportions_5, metadata_proportions_11, metadata_proportions_21,
                        metadata_proportions_23, metadata_proportions_27, metadata_proportions_75,
                        metadata_proportions_99, metadata_proportions_109, metadata_proportions_141,
                        metadata_proportions_216)

whole_metadata_mono <- subset(whole_metadata)
meta <- whole_metadata_mono[,c('Patient', 'Treatment', 'Concentration', 'Replicate', 'Culture', 'pHistone_H2A')]
raw_proportions <- whole_metadata_mono[,c('M_phase', 'G2_phase', 'S_phase', 'G1_phase', 'G0_phase', 'Apoptosis')]
matrix_scale <- scale(data.matrix(raw_proportions))
z_scores <- (matrix_scale-mean(matrix_scale))/sd(matrix_scale)
z_metadata <- cbind(z_scores, meta)
z_metadata_treat <- subset(z_metadata, Concentration != 0)
z_metadata_control <- subset(whole_metadata_mono, Concentration == 0, Replicate=='AA')
proportions_treat <- z_metadata_treat[,c('M_phase', 'G2_phase', 'S_phase', 'G1_phase', 'G0_phase', 'Apoptosis')]
proportions_control<- z_metadata_control[,c('M_phase', 'G2_phase', 'S_phase', 'G1_phase', 'G0_phase', 'Apoptosis')]


histone_treat <- z_metadata_treat[,'pHistone_H2A']
drug_conc <- select(z_metadata_treat, Concentration, Treatment)
treatment_treat <- z_metadata_treat[,'Treatment']
patient_treat <- z_metadata_treat[,'Patient']
culture_treat <- z_metadata_treat[,'Culture']
matrix_treat <- data.matrix(proportions_treat)


patient_control <- z_metadata_control[,'Patient']
culture_contro <- z_metadata_control[,'Culture']
matrix_control <- data.matrix(proportions_control)

#Color 
hm_col = colorRamp2(c( -4, -3,-2, -1, -0.5, 0, 0.5, 1, 2, 3, 4), 
                    c('#5C509C', '#4a6eb7', '#4A85B7', '#7DC0A6', '#B5DCA8',
                      '#F8E095', '#F0B06D', '#E3744F', '#C53F32', '#911C43', '#961D2A'))
col_treatments = c('DMSO'='#000000', 'H2O'='#000000', 'AH'='#000000', 
                   'S'='#0433FF', 'VS'='#011993', 'L'='#F2AE40', 
                   'F'='#942193', 'C'='#B7933A', 'CS'='#005493', 'CSF'='#0096FF', 
                   'SF'='#7A81FF', 'V'='#FFD479', 'CF'='#941751', 'O'='#38774F')
control_col = colorRamp2(c( 0, 0.05,0.015, 0.1, 0.2,0.35, 0.4, 0.5, 0.8, 0.9, 1), 
                    c('#5C509C', '#4a6eb7', '#4A85B7', '#7DC0A6', '#B5DCA8',
                      '#F8E095', '#F0B06D', '#E3744F', '#C53F32', '#911C43', '#961D2A'))
drug_conc_ha = rowAnnotation(
  Treatment = anno_barplot(drug_conc[1], gp = gpar(col = FALSE,fill = col_treatments[drug_conc$Treatment]), axis=FALSE, 
                           border = FALSE, width = unit(2.5, "cm"), bar_width = 1))

treatment_mono_ha = rowAnnotation( border=TRUE,
  Treatment = treatment_treat,col = list(
    Treatment = c('DMSO'='#000000', 'H2O'='#000000', 'AH'='#000000', 
                  'S'='#0433FF', 'VS'='#011993', 'L'='#F2AE40', 
                  'F'='#942193', 'C'='#B7933A', 'CS'='#005493', 'CSF'='#0096FF', 
                  'SF'='#7A81FF', 'V'='#FFD479', 'CF'='#941751', 'O'='#38774F')))
culture_mono_ha = rowAnnotation(
  Culture = culture_treat, col = list(Culture = c(
    "PDO" = "#008C26", "PDOF" = "#FF7F7F")))

patient_mono_ha = rowAnnotation(
  Patient = patient_treat, border=TRUE, col = list(
    Patient = c('11'='#da70d6', '21'= '#9acd32', '23'='#cd5c5c', '27'='#7d0f0f', '75'='#808000', 
                '99'='#add8e6', '109'='#3b65a8', '141'='#663399', '216'='#8b008b', '5'= '#d42f81')))
histone_mono_ha = rowAnnotation(
  pHistone_H2A = anno_barplot(histone_treat, baseline = 1, ylim = c(1, 3)), gp = gpar(fill = 'none', col = 'none'),
  border=TRUE
)

hm_mono =Heatmap(matrix_treat, col = hm_col, column_dend_reorder = FALSE, row_gap = unit(1, "mm"), row_split = patient_treat,
                 border = TRUE, cluster_rows = TRUE, cluster_columns = FALSE, name='Fold change Z-score',
        right_annotation = histone_mono_ha, left_annotation = treatment_mono_ha)
hm_mono

