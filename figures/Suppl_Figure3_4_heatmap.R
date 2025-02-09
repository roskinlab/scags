require(ggplot2)
library(stringr)
library(data.table)
library(dplyr)
library(argparser, quietly=TRUE)

p <- arg_parser("Create heatmap tile figure used for supplementary figures")
p <- add_argument(p, "file_data", help="the file containing the mean coefficient weights and the features selected by lasso ")
p <- add_argument(p, "file_lineage", help="the file containing all necessary information for the highest frquent clones of all features")

argv <- parse_args(p)

dat = read.delim(argv$file_data, header = T, sep =',')
lineage_file = fread(argv$file_lineage,header = T, fill = T )

#create a new column where the V and J segment names do not contain their alleles
lineage_file = lineage_file%>% 
  mutate(v_segment_without_allele =str_split_i(lineage_file$v_segment, '\\*',1))
lineage_file = lineage_file%>% 
  mutate(J_segment_without_allele =str_split_i(lineage_file$j_segment, '\\*',1))

#calculate frequency for V_segments and J_segments
get_segment_percentages = function(x, names, segment_type){
  table1 = x %>% 
    group_by(.data[[names]],.data[[segment_type]]) %>%
    summarise(count = n())
  
  table2 = table1 %>% 
    group_by(.data[[names]] ) %>%
    summarise(group_count = sum(count),
              segment_name = .data[[segment_type]],
              count = count,
              percentage = (count/group_count)*100 )
  return(table2)
}

Perct_tabl_v = get_segment_percentages(lineage_file,'Probes', 'v_segment_without_allele')
Perct_tabl_v = Perct_tabl_v[!grepl('IGHV1/OR', Perct_tabl_v$segment_name),]

Perct_tabl_j = get_segment_percentages(lineage_file,'Probes', 'J_segment_without_allele')

vj_segments = rbind(Perct_tabl_v, Perct_tabl_j)
vj_segments = select(vj_segments, segment_name,Probes, percentage)

#remove unwanted strings from vj_segment and dat dataframe
vj_segments$Probes = gsub(c('H1-'),"",vj_segments$Probes)
vj_segments$Probes = gsub(c('H2-'),"",vj_segments$Probes)

dat$Probes. = gsub(c('H1-'),"",dat$Probes.)
dat$Probes. = gsub(c('H2-'),"",dat$Probes.)

#reorder features in dat and VJ_segment file according to regression model weights
dat = dat[order(dat$Coefficient.mean,decreasing = T ),]
dat$Probes. = factor(dat$Probes., levels = c(dat$Probes.))

vj_segments = vj_segments[order(vj_segments$segment_name),]
vj_segments$Probes = factor(vj_segments$Probes, levels = c(dat$Probes.))

vj_segments$name_one=NA
vj_segments$name_two = 0
vj_segments$name_three =0

#split VJ-segment names based on if the name has a '-' in the family gene name
for (i in 1:length(vj_segments$segment_name)){
  # J segments  
  if (startsWith(vj_segments$segment_name[i],'IGHJ') ){
    vj_segments$name_one[i] = vj_segments$segment_name[i]
    vj_segments$name_two[i] = vj_segments$name_two[i]
    vj_segments$name_three[i] = vj_segments$name_three[i]
    
    #J segments
  }else{
    vj_segments$name_one[i] = str_split(vj_segments$segment_name, '-')[[i]][1]
    vj_segments$name_two[i] = as.numeric(str_split(vj_segments$segment_name, '-')[[i]][2])
  }
  if (is.na(str_split(vj_segments$segment_name, '-')[[i]][3]) ){
    vj_segments$name_three[i] = vj_segments$name_three[i]
  }else{
    vj_segments$name_three[i] = as.numeric(str_split(vj_segments$segment_name, '-')[[i]][3])
  }
}


#rename the isotypes from all uppercases to lowercase and uppercase
vj_segments$Probes = vj_segments$Probes %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))

#create new columns annotating the isotypes and structure groups of the features
vj_segments = vj_segments %>% 
  mutate(isotype =str_split_i(Probes, ':',4))


#Update the new feature names with the new isotype annotations
dat$Probes.= dat$Probes. %>%
  str_replace_all(c('IGHG1' = 'IgG1','IGHG2' = 'IgG2','IGHG3' = 'IgG3', 'IGHG4' = 'IgG4', 
                    'IGHA1' = 'IgA1', 'IGHA2' = 'IgA2', 'IGHE' = 'IgE', 'IGHM' = 'IgM', 
                    'IGHD' = 'IgD'))

n_features = length(dat$Probes.)

#make empty dataframe replicating the unique segment names to the amount of features we are interested in (7)
df = data.frame(matrix(nrow = length(unique(vj_segments$segment_name))*n_features, ncol = 3))
colnames(df) = c('segment_name', 'Probes', 'Percentages')
df$segment_name = rep(unique(vj_segments$segment_name), n_features)

rep_probes= c()
for(i in 1:length(unique(vj_segments$Probes))){
  replicates = rep(unique(vj_segments$Probes)[i], nrow(df)/7)
  rep_probes = append(rep_probes, replicates)
}

df$Probes = rep_probes
df$Percentages = 0

# fill in the empty dataframe with the percentage of each gene segment
for(i in 1:length(vj_segments$segment_name)){
  segment_name = vj_segments$segment_name[i]
  Probe = vj_segments$Probes[i]
  percentage = vj_segments$percentage[i]
  g=which(df$segment_name ==segment_name )
  k=which(df$Probes== Probe)
  df[intersect(g,k),3] = percentage
}

#create labels for figures
labels_y = factor(dat$Probes.)

J_positions =  which(startsWith(df$segment_name,'IGHJ'))
J_genes = df[J_positions,]
J_genes$Probes = factor(J_genes$Probes, levels =labels_y )

V_positions =  which(startsWith(df$segment_name,'IGHV'))
V_genes = df[V_positions,]
V_genes$Probes = factor(V_genes$Probes, levels =labels_y )

#create labels for figures
labels_x <- c( "IGHJ1", "IGHJ2", "IGHJ3",  "IGHJ4", "IGHJ5", "IGHJ6")
labels_x2 = unique(V_genes$segment_name)

#create dataframe used for annotating cluster status
cluster_status = data.frame(matrix(nrow = n_features, ncol = 3))
cluster_status$X1=factor(dat$Probes.) 

X2= ifelse(sign(dat$Coefficient.mean) >0, 0,1)
cluster_status$X2 = X2
cluster_status$X3 = rep('Pred Pheno', n_features)
colnames(cluster_status) = c('Probes', 'cluster_value', 'Pred Pheno')
cluster_status$Probes = factor(cluster_status$Probes, levels = c(cluster_status$Probes))

#V gene segment tile plot
V=ggplot(data= V_genes) +
  geom_tile(aes(x = segment_name, y = Probes, fill = Percentages), color= 'grey')+
  theme_bw(base_size = 8)+
  scale_fill_distiller(palette = "BuPu", direction = 1)+
  scale_x_discrete(labels = labels_x2, expand = c(0,0))+
  scale_y_discrete(labels = labels_y,expand = c(0,0))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = 'bold'),
        axis.title.x = element_blank() )+
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank())+
  theme(legend.position = 'none')

#J gene segment tile plot
J=ggplot(data= J_genes) +
  geom_tile(aes(x = segment_name, y = Probes, fill = Percentages), color= 'grey')+
  theme_bw(base_size = 8)+
  scale_fill_distiller(palette = "BuPu", direction = 1)+
  scale_x_discrete(expand = c(0,0), labels = labels_x)+
  scale_y_discrete(expand = c(0,0), labels = labels_y)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = 'bold'), 
        axis.title.x = element_blank() )+
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank(), 
        axis.ticks.y = element_blank())+
  theme(legend.position = 'none')

#Cluster status tile plot
status= ggplot(data= cluster_status) +
  geom_tile(aes(x = `Pred Pheno`, y = Probes , fill = as.factor(cluster_value)), color= 'grey')+
  theme_bw(base_size = 8)+
  scale_fill_manual(values = c("#B71729", "#377EB8"))+
  scale_x_discrete(expand = c(0,0))+
  scale_y_discrete(expand = c(0,0), )+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = 'bold'), 
        axis.title.x = element_blank() )+
  theme(axis.text.y = element_text( colour = c("black", "black", "black", "black", "black",
                                               "black") ,
                                    vjust = 0, face= 'bold'),
        axis.title.y = element_blank(), 
        axis.ticks.y = element_blank())+
  theme(legend.position = 'none')


ggsave('j_segements_used.pdf', plot=J, width=0.6, height=3.47, device=cairo_pdf)
ggsave('j_segements_used.png', plot=J, width=0.6, height=3.47)

ggsave('v_segements_used.pdf', plot=V, width=1.35, height=3.52, device=cairo_pdf)
ggsave('v_segements_used.png', plot=V, width=1.35, height=3.52)

ggsave('status.pdf', plot=status, width=1.27, height=3.53, device=cairo_pdf)
ggsave('status.png', plot=status, width=1.27, height=3.53)

