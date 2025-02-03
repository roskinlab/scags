#load relevant libraries
library(ggplot2)
library(stringr)
library(colorspace)
library(dplyr)
library(gridExtra)

#########################
#                       #
#        FIGURE 5       #
#                       #
#########################

#### HIV infection VJ3 barplot - Figure 5a ###

#read in data with weigths of stable features across multiple l1 regularization
weights = read.delim('CHAVI/stable_features_across_all_penalty_terms_102224.csv', header = T, sep =',')
weights$X = NULL
weights = weights[weights$C_value. == 1.20,]

#remove unwanted string characters from weights file
weights$Probes. =gsub(c('v_segment='),"",weights$Probes.)
weights$Probes. =gsub(c('j_segment='),"",weights$Probes.)
weights$Probes. =gsub(c('isotype='),"",weights$Probes.)
weights$Probes. =gsub(c('Cluster'),"",weights$Probes.)

#create new column called isotype
weights=weights %>% 
  mutate(Isotype =str_split_i(weights$Probes, ':',4))

weights$Isotype = weights$Isotype %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))


#rename feature names in weights file
weights$Probes. = paste(str_split_i(weights$Probes., ':',1),str_split_i(weights$Probes., ':',2),str_split_i(weights$Probes., ':',3), weights$Isotype,  sep = ':')

weights$Probes. =gsub(c('IGH'),"",weights$Probes.)
#order the features and its levels allowing feature names on barplot to be in the right order 
weights = weights[order(weights$Coefficient.mean,decreasing = T ),]
weights = head(weights,10)
weights$Probes. = factor(weights$Probes., levels = c(weights$Probes.))

#plot bar plots of the weights
col2 = c(IgA1 =  "chocolate", IgM = "#BF219A", IgA2 = "#EF9708", IgG1= "#7C7BB2", IgD= "#56B4E9", IgG2="#A79FE1",IgG3="#CAC5F3", IgE="#11C638")

p1=ggplot(weights, aes(x= Probes., y = Coefficient.mean, fill = Isotype))+
  geom_bar( stat="identity")+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=8, face = 'bold'))+
  theme(axis.text.y = element_text(colour = c("black", "black", "black", "black","black", "black", "black",
                                              "black", "black", "black", "black")))+
  ylab('Mean weights from LASSO')+
  xlab('VJ3 and Isotype')+
  geom_errorbar(data = weights,
                aes(x = Probes., ymax = Coefficient.mean + Coefficient.std, ymin = Coefficient.mean - Coefficient.std), 
                width = 0.2)+
  scale_y_continuous(n.breaks = 10, expand = c(0,0), limits = c(0, 2.70))+
  scale_x_discrete(expand = c(0,0))+
  scale_fill_manual(values= col2)+
  theme(legend.position = c(0.8, 0.37),
        legend.key = element_blank(),
        legend.text=element_text(size=5.5))+
  coord_flip()                                                   

#### Food sensitization VJ3 barplot - Figure 5b ###

#read in data with weigths of stable features across multiple l1 regularization
weights = read.delim('MPAACH/stable_features_across_all_penalty_terms_102224.csv', header = T, sep =',')
weights = weights[weights$C_value. ==0.51,]

#remove unwanted string characters from weights file
weights$Probes. =gsub(c('v_segment='),"",weights$Probes.)
weights$Probes. =gsub(c('j_segment='),"",weights$Probes.)
weights$Probes. =gsub(c('isotype='),"",weights$Probes.)
weights$Probes. =gsub(c('Cluster'),"",weights$Probes.)

#create new column called isotype
weights=weights %>% 
  mutate(Isotype =str_split_i(weights$Probes, ':',4))

weights$Isotype = weights$Isotype %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))

#rename feature names in weights file
weights$Probes. = paste(str_split_i(weights$Probes., ':',1),str_split_i(weights$Probes., ':',2),str_split_i(weights$Probes., ':',3), weights$Isotype,  sep = ':')

weights$Probes. =gsub(c('IGH'),"",weights$Probes.)
#order the features and its levels allowing feature names on barplot to be in the right order
weights = weights[order(weights$Coefficient.mean,decreasing = T ),]
weights$Probes. = factor(weights$Probes., levels = c(weights$Probes.))

#plot bar plots of the weights
#make figure2 plot
col2 = c(IgA1 =  "chocolate", IgM = "#BF219A", IgA2 = "#EF9708", IgG1= "#7C7BB2", IgD= "#56B4E9", IgG2="#A79FE1",IgG3="#CAC5F3", IgE="#11C638")


p2=ggplot(weights, aes(x= Probes., y = Coefficient.mean, fill = Isotype))+
  geom_bar( stat="identity")+
  theme_bw(base_size=8)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=8, face = 'bold'))+
  theme(axis.text.y = element_text(colour = c("black", "black", "black", "black","black", "black", "black",
                                              "black", "black")))+
  ylab('Mean weights from LASSO')+
  xlab('Class-switched VJ3 and Isotype')+
  geom_errorbar(data = weights,
                aes(x = Probes., ymax = Coefficient.mean + Coefficient.std, ymin = Coefficient.mean - Coefficient.std), 
                width = 0.2)+
  scale_y_continuous(n.breaks = 12, expand = c(0,0), limits = c(-1.01, 0.871))+
  scale_x_discrete(expand = c(0,0))+
  scale_fill_manual(values= col2)+
  theme(legend.position = c(0.3, 0.34),
        legend.key = element_blank(),
        legend.text=element_text(size=5.5))+
  coord_flip()                                                   

#Create Figure 5 grid
p=grid.arrange(p1,p2, layout_matrix = rbind(c(1,1,2,2)))

#########################
#                       #
#        FIGURE 6       #
#                       #
#########################

#### HIV infection SCAGs barplot - Figure 6a ###
#read in data with weigths of stable features across multiple l1 regularization
weights = read.delim('CHAVI_h1h2h3/stable_features_across_all_penalty_terms_102224.csv', header = T, sep =',')
weights = weights[weights$C_value. == 0.59,]

#create new column called isotype
weights=weights %>% 
  mutate(Isotype =str_split_i(weights$Probes., ':',4))

weights$Isotype = weights$Isotype %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))

#remove unwanted string characters from weights file
weights$Probes. =gsub(c('H1-'),"",weights$Probes.)
weights$Probes. =gsub(c('H2-'),"",weights$Probes.)

#rename feature names in weights file
weights$Probes. = paste(str_split_i(weights$Probes., ':',1),str_split_i(weights$Probes., ':',2),str_split_i(weights$Probes., ':',3), weights$Isotype,  sep = ':')

#order the features and its levels allowing feature names on barplot to be in the right order 
weights = weights[order(weights$Coefficient.mean,decreasing = T ),]
weights = head(weights, 10)
weights$Probes. = factor(weights$Probes., levels = c(weights$Probes.))

#plot bar plots of the weights
col2 = c(IgA1 =  "chocolate", IgM = "#BF219A", IgA2 = "#EF9708", IgG1= "#7C7BB2", IgD= "#56B4E9", IgG2="#A79FE1",IgG3="#CAC5F3", IgE="#11C638")

p3=ggplot(weights, aes(x= Probes., y = Coefficient.mean, fill = Isotype))+
  geom_bar( stat="identity")+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=8, face = 'bold'))+
  theme(axis.text.y = element_text(colour = c("red", "black", "black", "black","red", "black", "red",
                                              "black", "red", 'black')))+
  ylab('Weights from LASSO')+
  xlab('SCAGs and Isotype')+
  ylab('Mean weights from LASSO')+
  geom_errorbar(data = weights,
                aes(x = Probes., ymax = Coefficient.mean + Coefficient.std, ymin = Coefficient.mean - Coefficient.std), 
                width = 0.2)+
  scale_y_continuous(n.breaks = 12, expand = c(0,0))+
  scale_x_discrete(expand = c(0,0))+
  scale_fill_manual(values= col2)+
  theme(legend.position = c(0.88, 0.75),
        legend.key = element_blank(),
        legend.text=element_text(size=5.5))+
  coord_flip()                                                   

#### Food sensitization SCAGs barplot - Figure 6b ###

#read in data with weigths of stable features across multiple l1 regularization
weights = read.csv('MPAACH_h1h2h3/stable_features_across_all_penalty_terms_102224.csv', header =T)
weights = weights[weights$C_value.==0.24,]

weights$X = NULL

#create new column called isotype
weights=weights %>% 
  mutate(Isotype =str_split_i(weights$Probes, ':',4))

weights$Isotype = weights$Isotype %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))

#remove unwanted string characters from weights file
weights$Probes. =gsub(c('H1-'),"",weights$Probes.)
weights$Probes. =gsub(c('H2-'),"",weights$Probes.)

#rename feature names in weights file
weights$Probes. = paste(str_split_i(weights$Probes., ':',1),str_split_i(weights$Probes., ':',2),str_split_i(weights$Probes., ':',3), weights$Isotype,  sep = ':')

#order the features and its levels allowing feature names on barplot to be in the right order 
weights = weights[order(weights$Coefficient.mean,decreasing = T ),]
weights$Probes. = factor(weights$Probes., levels = c(weights$Probes.))

#plot bar plots of the weights
col2 = c(IgA1 =  "chocolate", IgM = "#BF219A", IgA2 = "#EF9708", IgG1= "#7C7BB2", IgD= "#56B4E9", IgG2="#A79FE1",IgG3="#CAC5F3", IgE="#11C638")

p4=ggplot(weights, aes(x= Probes., y = Coefficient.mean, fill = Isotype))+
  geom_bar( stat="identity")+
  theme_bw(base_size=6)+
  theme(axis.text=element_text(size=6, face = 'bold'),axis.title=element_text(size=8),
        legend.text = element_text(size=6, face ='bold'), legend.title = element_text(size=8, face = 'bold'))+
  theme(axis.text.y = element_text(colour = c("black", "black", "black", "black", "black",
                                              "black", "black")))+
  geom_errorbar(data = weights,
                aes(x = Probes., ymax = Coefficient.mean + Coefficient.std, ymin = Coefficient.mean - Coefficient.std), 
                width = 0.2)+                                                   
  ylab('Mean weights from LASSO')+
  xlab('Class-switched SCAGs and Isotype')+
  scale_y_continuous(n.breaks = 10, expand = c(0,0), limits = c(-1.0, 0.63))+
  scale_x_discrete(expand = c(0,0))+
  scale_fill_manual(values= col2)+
  theme(legend.position = c(0.2, 0.45),
        legend.key = element_blank(),
        legend.text=element_text(size=5.5))+
  coord_flip()

#Create Figure 6 grid
p=grid.arrange(p3,p4, layout_matrix = rbind(c(1,1,2,2)))
