#load relevant libraries
library(ggplot2)
library(gridExtra)

#########################
#                       #
#   Supp FIGURE 1       #
#                       #
#########################

#### HIV infection Stability analysis VJ3 line plot - supp 1a ###
#read in data with weigths of stable features across multiple l1 regularization
weights1 = read.csv('CHAVI/stable_features_across_all_penalty_terms_102224.csv', header =T)

p1=ggplot(weights1, aes(x= C_value., y = Number_of_Features))+
  geom_line()+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=6, face = 'bold'))+
  ylab('Number of stable Features')+
  xlab('Inverse of regularization')+
  scale_y_continuous(breaks = c(0,2,4,6,8,10,12,14,16,18,20,22,24,26), limits = c(0,26))+
  scale_x_continuous(n.breaks= 10, expand = c(0,0), limits = c(0.07,1.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_vline(xintercept = 1.20, linetype = 'dashed', color = 'red')


#### Food sensitization Stability analysis VJ3 line plot - supp 2b ###
#read in data with weigths of stable features across multiple l1 regularization
weights2 = read.csv('MPAACH/stable_features_across_all_penalty_terms_102224.csv', header =T)

p2=ggplot(weights2, aes(x= C_value., y = Number_of_Features))+
  geom_line()+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=6, face = 'bold'))+
  ylab('Number of stable features')+
  xlab('Inverse of regularization')+
  scale_y_continuous(breaks = c(0,2,4,6,8,10,12,14), limits = c(0,14))+
  scale_x_continuous(n.breaks= 10, expand = c(0,0), limits = c(0.09,1.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_vline(xintercept = 0.51, linetype = 'dashed', color = 'red')


#Create Supp figure 1 grid
p=grid.arrange(p1,p2, layout_matrix = rbind(c(1,1,2,2)))

#########################
#                       #
#   Supp FIGURE 2       #
#                       #
#########################

#### HIV infection Stability analysis SCAGs line plot - supp 2a ###
#read in data with weigths of stable features across multiple l1 regularization
weights3 = read.delim('CHAVI_h1h2h3/stable_features_across_all_penalty_terms_102224.csv', header = T, sep =',')

p3=ggplot(weights3, aes(x= C_value., y = Number_of_Features))+
  geom_line()+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=6, face = 'bold'))+
  ylab('Number of stable Features')+
  xlab('Inverse of regularization')+
  scale_y_continuous(breaks = c(0,2,4,6,8,10,12,14,16,18,20,22,24,26), limits = c(0,26))+
  scale_x_continuous(n.breaks= 10, expand = c(0,0), limits = c(0.05,1.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_vline(xintercept = 0.59, linetype = 'dashed', color = 'red')


#### Food sensitization Stability analysis SCAGs line plot - supp 2b ###

weights4 = read.csv('MPAACH_h1h2h3/stable_features_across_all_penalty_terms_102224.csv', header =T)
#read in data with weigths of stable features across multiple l1 regularization

p4=ggplot(weights4, aes(x= C_value., y = Number_of_Features))+
  geom_line()+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=6, face = 'bold'))+
  ylab('Number of stable features')+
  xlab('Inverse of regularization')+
  scale_y_continuous(breaks = c(0,2,4,6,8,10,12,14,16), limits = c(0,15))+
  scale_x_continuous(n.breaks= 10, expand = c(0,0), limits = c(0.09,1.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_vline(xintercept = 0.24, linetype = 'dashed', color = 'red')

#Create Supp figure 2 grid
p=grid.arrange(p3,p4, layout_matrix = rbind(c(1,1,2,2)))
