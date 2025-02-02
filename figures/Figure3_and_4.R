
library(pROC)
library(gridExtra)

#########################
#                       #
#        FIGURE 3       #
#                       #
#########################

#HIV infection class-switched VJ3 ROC curve - Figure 3a
chavi_vjs3_isotype = read.delim('CHAVI/CHAVI_vjs3/Regression/sorted_combined_LR_prediction_using_10_subjects_43024_updated.txt', header= F)
chavi_vjs3_isotype_n = read.delim('CHAVI/folds/VJ3_isotype/sorted_combined_LR_prediction_non_naive_features_30924.txt', header= F)

chavi_Predicted_proba_vjs3_isotype = chavi_vjs3_isotype$V1
chavi_Actual_status_vjs3_isotype = chavi_vjs3_isotype$V2

chavi_Predicted_proba_vjs3_isotype_n = chavi_vjs3_isotype_n$V1
chavi_Actual_status_vjs3_isotype_n = chavi_vjs3_isotype_n$V2

roc_list2 = list()

roc_list2[['VJ3 and isotype ROC curve']] = roc(chavi_Actual_status_vjs3_isotype, chavi_Predicted_proba_vjs3_isotype)
roc_list2[['Non-naive VJ3 and isotype ROC curve']] = roc(chavi_Actual_status_vjs3_isotype_n, chavi_Predicted_proba_vjs3_isotype_n)

#Create ROC curves
col = c('#7CAE00', '#0072b2')
b1= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.150, label= paste('VJ3 + isotype model AUC =', round(roc_list2$`VJ3 and isotype ROC curve`$auc,3)), color = '#7CAE00', size=3.0)+ 
  annotate('text', x=0.56, y=0.100, label= paste('class-switched VJ3 + isotype model AUC =', round(roc_list2$`Non-naive VJ3 and isotype ROC curve`$auc,3)), color = '#0072b2', size=2.6)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=8)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=8), 
        axis.text = element_text(size=8),
        axis.ticks = element_line(linewidth = 0.4))

b1

# Create confidence intervals for curves
dat.ci.list =list(dat_ci_vjs3_isotype_chavi , dat_ci_vjs3_isotype_n_chavi)

for(i in 1:2) {
  b1 <- b1 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 
b1

#Food sensitization class-switched VJ3 ROC curve - Figure 3b
vjs3_isotype = read.delim('MPAACH/sorted_combined_LR_prediction_vj3_isotype_using_10_subjects_42422.txt', header= F)
vjs3_isotype_n = read.delim('MPAACH/folds/sorted_combined_LR_prediction_non_naive_features_30924.txt', header= F)

Predicted_proba_vjs3_isotype = vjs3_isotype$V2
Actual_status_vjs3_isotype = vjs3_isotype$V3

Predicted_proba_vjs3_isotype_n = vjs3_isotype_n$V2
Actual_status_vjs3_isotype_n = vjs3_isotype_n$V3

#Food sensitization VJ3 and Isotype
roc_list2 = list()

roc_list2[['VJ3 and isotype ROC curve']] = roc(Actual_status_vjs3_isotype, Predicted_proba_vjs3_isotype)
roc_list2[['Non-naive VJ3 and isotype ROC curve']] = roc(Actual_status_vjs3_isotype_n, Predicted_proba_vjs3_isotype_n)

#Create ROC curve 
col = c('#7CAE00', '#0072b2')
b2= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.150, label= paste('VJ3 + isotype model AUC =', round(roc_list2$`VJ3 and isotype ROC curve`$auc,3)), color = '#7CAE00', size=3.0)+ 
  annotate('text', x=0.56, y=0.100, label= paste('class-switched VJ3 + isotype model AUC =', round(roc_list2$`Non-naive VJ3 and isotype ROC curve`$auc,3)), color = '#0072b2', size=2.6)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b2

#Add confidence intervals to curves
dat.ci.list =list(dat_ci_vjs3_isotype_m,dat_ci_vjs3_isotype_n_m )

for(i in 1:2) {
  b2 <- b2 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b2

# Create Figure 3 grid
p=grid.arrange(b1,b2, layout_matrix = rbind(c(1,1,2,2)))
roc.test(roc_list2$`VJ3 and isotype ROC curve`, roc_list2$`Non-naive VJ3 and isotype ROC curve`, method = c('delong'))

#save figures
ggsave('mpaach_chavi_vj3_isotype_nonnaive_ROC_curves.pdf', plot=p, width=6.0, height=2.8, device=cairo_pdf)
ggsave('mpaach_chavi_vj3_isotype_nonnaive_ROC_curves.png', plot=p, width=6.0, height=2.8)

#########################
#                       #
#        FIGURE 4       #
#                       #
#########################

#HIV infection class-switched SCAGs ROC curve - Figure 4a
chavi_h1h2h3_isotype = read.delim('/CHAVI_h1h2h3/sorted_combined_LR_prediction_using_10_subjects_5124_updated.txt', header= F)
chavi_h1h2h3_isotype_n = read.delim('/CHAVI_h1h2h3/folds/sorted_combined_LR_prediction_non_naive_features_30924.txt', header = F)

chavi_Predicted_proba_h1h2h3_isotype = chavi_h1h2h3_isotype$V1
chavi_Actual_status_h1h2h3_isotype = chavi_h1h2h3_isotype$V2

chavi_Predicted_proba_h1h2h3_isotype_n = chavi_h1h2h3_isotype_n$V1
chavi_Actual_status_h1h2h3_isotype_n = chavi_h1h2h3_isotype_n$V2

roc_list2 = list()

roc_list2[['SCAGs and isotype ROC curve']] = roc(chavi_Actual_status_h1h2h3_isotype, chavi_Predicted_proba_h1h2h3_isotype)
roc_list2[['Non-naive SCAGs and isotype ROC curve']] = roc(chavi_Actual_status_h1h2h3_isotype_n, chavi_Predicted_proba_h1h2h3_isotype_n)

#Create ROC curves
col = c('#7CAE00', '#0072B2')
b3= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs + isotype model AUC =', round(roc_list2$`SCAGs and isotype ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  annotate('text', x=0.56, y=0.100, label= paste('class-switched SCAGs + isotype model AUC =', round(roc_list2$`Non-naive SCAGs and isotype ROC curve`$auc,3)), color = '#0072B2', size=2.4)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=8)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=8), 
        axis.text = element_text(size=8),
        axis.ticks = element_line(linewidth = 0.4))

b3

# Add confidence interval to ROC curves
dat.ci.list =list(dat_ci_h1h2h3_isotype_chavi , dat_ci_h1h2h3_isotype_n_chavi)

for(i in 1:2) {
  b3 <- b3 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 
b3


#Food sensitization class-switched SCAGs ROC curve - Figure 4b'
h1h2h3_isotype = read.delim('sorted_combined_LR_prediction_using_10_subjects_5124_updated.txt', header= F)
h1h2h3_isotype_n = read.delim('/MPAACH_h1h2h3/sorted_combined_LR_nonnaive_prediction_93024.txt', header = F)

Predicted_proba_h1h2h3_isotype = h1h2h3_isotype$V2
Actual_status_h1h2h3_isotype = h1h2h3_isotype$V3

Predicted_proba_h1h2h3_isotype_n = h1h2h3_isotype_n$V2
Actual_status_h1h2h3_isotype_n = h1h2h3_isotype_n$V3

roc_list2 = list()

roc_list2[['SCAGs and isotype ROC curve']] = roc(Actual_status_h1h2h3_isotype, Predicted_proba_h1h2h3_isotype)
roc_list2[['Non-naive SCAGs and isotype ROC curve']] = roc(Actual_status_h1h2h3_isotype_n, Predicted_proba_h1h2h3_isotype_n)

#Create ROC curve
col = c('#7CAE00', '#0072B2')
b4= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs + isotype model AUC =', round(roc_list2$`SCAGs and isotype ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  annotate('text', x=0.56, y=0.100, label= paste('class-switched SCAGs + isotype model AUC =', round(roc_list2$`Non-naive SCAGs and isotype ROC curve`$auc,3)), color = '#0072B2', size=2.4)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b4

#Add confidence interval to ROC curves
dat.ci.list =list(dat_ci_h1h2h3_isotype_m,dat_ci_h1h2h3_isotype_n_m )

for(i in 1:2) {
  b4 <- b4 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b4

#Create Figure 4 grid
p=grid.arrange(b3,b4, layout_matrix = rbind(c(1,1,2,2)))
roc.test(roc_list2$`SCAGs and isotype ROC curve`, roc_list2$`Non-naive SCAGs and isotype ROC curve`, method = c('delong'))

ggsave('mpaach_chavi_scag_isotype_nonnaive_ROC_curves.pdf', plot=p, width=6.0, height=2.8, device=cairo_pdf)
ggsave('mpaach_chavi_scag_isotype_nonnaive_ROC_curves.png', plot=p, width=6.0, height=2.8)
