
library(pROC)

#########################
#                       #
#        FIGURE 1       #
#                       #
#########################

#HIV infection ROC curve - Figure 1a
chavi_vjs3 = read.delim('CHAVI_vj3/sorted_combined_LR_prediction_using_10_subjects_51624_no_isotype_updated.txt', header= F)
chavi_h1h2h3 = read.delim('CHAVI_h1h2h3/sorted_combined_LR_prediction_using_10_subjects_no_isotype_51924_updated.txt', header= F)

Predicted_proba_vjs3 = chavi_vjs3$V1
Actual_status_vjs3 = chavi_vjs3$V2

Predicted_proba_h1h2h3 = chavi_h1h2h3$V1
Actual_status_h1h2h3 = chavi_h1h2h3$V2

roc_list2_c_ = list()

roc_list2_c_[['VJ3 ROC curve']] = roc(Actual_status_vjs3, Predicted_proba_vjs3)
roc_list2_c_[['SCAGs ROC curve']] = roc(Actual_status_h1h2h3, Predicted_proba_h1h2h3)

#Plot curve
col = c('firebrick2','#7CAE00')
b1= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.20, label= paste('VJ3 model AUC =', round(roc_list2$`VJ3 ROC curve`$auc,3)),color = 'firebrick2', size=2.5)+
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs model AUC =', round(roc_list2$`SCAGs ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b1

#Add confidence intervals to plot
ciobj_vjs3_m <- ci.se(roc_list2[['VJ3 ROC curve']], specificities = roc_list2$`VJ3 ROC curve`$specificities)
ciobj_vjs3_siotype_m <- ci.se(roc_list2[['SCAGs ROC curve']], specificities = roc_list2$`SCAGs ROC curve`$specificities)

dat_ci_vjs3_m <- data.frame(x = as.numeric(rownames(ciobj_vjs3_m)),
                            lower = ciobj_vjs3_m[, 1],
                            upper = ciobj_vjs3_m[, 3],
                            group = 'A')

dat_ci_vjs3_isotype_m <- data.frame(x = as.numeric(rownames(ciobj_vjs3_siotype_m)),
                                    lower = ciobj_vjs3_siotype_m[, 1],
                                    upper = ciobj_vjs3_siotype_m[, 3],
                                    group = 'B')

dat.ci.list =list(dat_ci_vjs3_m,dat_ci_vjs3_isotype_m )

for(i in 1:2) {
  b1 <- b1 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b1

#Food sensitization ROC curve - Figure 1b
vjs3 = read.delim('sorted_combined_LR_prediction_using_10_subjects_42422.txt', header= F)
h1h2h3 = read.delim('sorted_combined_LR_prediction_using_10_subjects_no_isotype51924_updated.txt', header= F)

Predicted_proba_vjs3 = vjs3$V2
Actual_status_vjs3 = vjs3$V3

Predicted_proba_h1h2h3 = h1h2h3$V2
Actual_status_h1h2h3 = h1h2h3$V3

roc_list2_m = list()

roc_list2_m[['VJ3 ROC curve']] = roc(Actual_status_vjs3, Predicted_proba_vjs3)
roc_list2_m[['SCAGs ROC curve']] = roc(Actual_status_h1h2h3, Predicted_proba_h1h2h3)

#plot curve
col = c('firebrick2','#7CAE00')
b2= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.20, label= paste('VJ3 model AUC =', round(roc_list2$`VJ3 ROC curve`$auc,3)),color = 'firebrick2', size=2.5)+
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs model AUC =', round(roc_list2$`SCAGs ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b2

#Add confidence intervals to plot 
ciobj_vjs3_mpaach <- ci.se(roc_list2[['VJ3 ROC curve']], specificities = roc_list2$`VJ3 ROC curve`$specificities)
ciobj_h1h2h3_mpaach <- ci.se(roc_list2[['SCAGs ROC curve']], specificities = roc_list2$`SCAGs ROC curve`$specificities)

dat_ciobj_vjs3_mpaach <- data.frame(x = as.numeric(rownames(ciobj_vjs3_mpaach)),
                                    lower = ciobj_vjs3_mpaach[, 1],
                                    upper = ciobj_vjs3_mpaach[, 3],
                                    group = 'A')

dat_ciobj_h1h2h3_mpaach<- data.frame(x = as.numeric(rownames(ciobj_h1h2h3_mpaach)),
                                     lower = ciobj_h1h2h3_mpaach[, 1],
                                     upper = ciobj_h1h2h3_mpaach[, 3],
                                     group = 'B')

dat.ci.list =list(dat_ciobj_vjs3_mpaach,dat_ciobj_h1h2h3_mpaach )

for(i in 1:2) {
  b2 <- b2 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b2

#Create figure grid and save figure 1
library(gridExtra)
p=grid.arrange(b1,b2, layout_matrix = rbind(c(1,1,2,2)))

ggsave('mpaach_chavi_vj3_h1h2h3_ROC_curves.pdf', plot=p, width=6.0, height=2.8, device=cairo_pdf)
ggsave('mpaach_chavi_vj3_h1h2h3_ROC_curves.png', plot=p, width=6.0, height=2.8)


#########################
#                       #
#        FIGURE 2       #
#                       #
#########################

#HIV infection with isotype - 2a
chavi_vjs3_isotype = read.delim('CHAVI/sorted_combined_LR_prediction_using_10_subjects_43024_updated.txt', header= F)
chavi_h1h2h3_isotype = read.delim('/CHAVI_h1h2h3/sorted_combined_LR_prediction_using_10_subjects_5124_updated.txt', header= F)

Predicted_proba_vjs3_isotype = chavi_vjs3_isotype$V1
Actual_status_vjs3_isotype = chavi_vjs3_isotype$V2

Predicted_proba_h1h2h3_isotype = chavi_h1h2h3_isotype$V1
Actual_status_h1h2h3_isotype = chavi_h1h2h3_isotype$V2

roc_list2_c = list()

roc_list2_c[['VJ3+isotype ROC curve']] = roc(Actual_status_vjs3_isotype, Predicted_proba_vjs3_isotype)
roc_list2_c[['SCAGs+isotype ROC curve']] = roc(Actual_status_h1h2h3_isotype, Predicted_proba_h1h2h3_isotype)

#Create ROC curve
col = c('firebrick2','#7CAE00')
b3= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.20, label= paste('VJ3+isotype model AUC =', round(roc_list2$`VJ3+isotype ROC curve`$auc,3)),color = 'firebrick2', size=2.5)+
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs+isotype model AUC =', round(roc_list2$`SCAGs+isotype ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b3

#Add confidence intervals to curve 
ciobj_vjs3_iso_chavi <- ci.se(roc_list2[['VJ3+isotype ROC curve']], specificities = roc_list2$`VJ3+isotype ROC curve`$specificities)
ciobj_h1h2h3_iso_chavi <- ci.se(roc_list2[['SCAGs+isotype ROC curve']], specificities = roc_list2$`SCAGs+isotype ROC curve`$specificities)

dat_ciobj_vjs3_iso_chavi <- data.frame(x = as.numeric(rownames(ciobj_vjs3_iso_chavi)),
                                       lower = ciobj_vjs3_iso_chavi[, 1],
                                       upper = ciobj_vjs3_iso_chavi[, 3],
                                       group = 'A')

dat_ciobj_h1h2h3_iso_chavi<- data.frame(x = as.numeric(rownames(ciobj_h1h2h3_iso_chavi)),
                                        lower = ciobj_h1h2h3_iso_chavi[, 1],
                                        upper = ciobj_h1h2h3_iso_chavi[, 3],
                                        group = 'B')

dat.ci.list =list(dat_ciobj_vjs3_iso_chavi,dat_ciobj_h1h2h3_iso_chavi )

for(i in 1:2) {
  b3 <- b3 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b3

#Food sensitization and isotype - 2b
vjs3_isotype = read.delim('/MPAACH/sorted_combined_LR_prediction_vj3_isotype_using_10_subjects_42422.txt', header= F)
h1h2h3_isotype = read.delim('/MPAACH_h1h2h3/sorted_combined_LR_prediction_using_10_subjects_5124_updated.txt', header= F)

Predicted_proba_vjs3_isotype = vjs3_isotype$V2
Actual_status_vjs3_isotype = vjs3_isotype$V3

Predicted_proba_h1h2h3_isotype = h1h2h3_isotype$V2
Actual_status_h1h2h3_isotype = h1h2h3_isotype$V3

roc_list2 = list()

roc_list2[['VJ3+isotype ROC curve']] = roc(Actual_status_vjs3_isotype, Predicted_proba_vjs3_isotype)
roc_list2[['SCAGs+isotype ROC curve']] = roc(Actual_status_h1h2h3_isotype, Predicted_proba_h1h2h3_isotype)

#Create ROC curve
col = c('firebrick2','#7CAE00')
b4= ggroc(roc_list2, linetype =1, size = 0.6, legacy.axes = TRUE) + 
  scale_color_manual(values= col)+
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1), color="darkgrey", linetype="dashed", linewidth =0.3) +
  annotate('text', x=0.56, y=0.20, label= paste('VJ3+isotype model AUC =', round(roc_list2$`VJ3+isotype ROC curve`$auc,3)),color = 'firebrick2', size=2.5)+
  annotate('text', x=0.56, y=0.150, label= paste('SCAGs+isotype model AUC =', round(roc_list2$`SCAGs+isotype ROC curve`$auc,3)), color = '#7CAE00', size=2.5)+ 
  xlab("FPR") + ylab("TPR")+
  theme_bw(base_size=6.5)+
  theme(legend.position = 'none')+
  theme(axis.title =element_text(size=7), 
        axis.text = element_text(size=7),
        axis.ticks = element_line(linewidth = 0.5))


b4

#Add confidence intervals to curves
ciobj_vjs3_iso_mpaach <- ci.se(roc_list2[['VJ3+isotype ROC curve']], specificities = roc_list2$`VJ3+isotype ROC curve`$specificities)
ciobj_h1h2h3_iso_mpaach <- ci.se(roc_list2[['SCAGs+isotype ROC curve']], specificities = roc_list2$`SCAGs+isotype ROC curve`$specificities)

dat_ciobj_vjs3_iso_mpaach <- data.frame(x = as.numeric(rownames(ciobj_vjs3_iso_mpaach)),
                                        lower = ciobj_vjs3_iso_mpaach[, 1],
                                        upper = ciobj_vjs3_iso_mpaach[, 3],
                                        group = 'A')

dat_ciobj_h1h2h3_iso_mpaach<- data.frame(x = as.numeric(rownames(ciobj_h1h2h3_iso_mpaach)),
                                         lower = ciobj_h1h2h3_iso_mpaach[, 1],
                                         upper = ciobj_h1h2h3_iso_mpaach[, 3],
                                         group = 'B')

dat.ci.list =list(dat_ciobj_vjs3_iso_mpaach,dat_ciobj_h1h2h3_iso_mpaach )

for(i in 1:2) {
  b4 <- b4 + geom_ribbon(
    data = dat.ci.list[[i]],
    aes(x = 1-x, ymin = lower, ymax = upper),
    alpha = 0.18,
    fill = col[i],
    inherit.aes = F) 
} 

b4

#Create figure grid and save figure 2
p2=grid.arrange(b3,b4, layout_matrix = rbind(c(1,1,2,2)))

ggsave('mpaach_chavi_vj3_h1h2h3_iso_ROC_curves.pdf', plot=p2, width=6.0, height=2.8, device=cairo_pdf)
ggsave('mpaach_chavi_vj3_h1h2h3_iso_ROC_curves.png', plot=p2, width=6.0, height=2.8)
