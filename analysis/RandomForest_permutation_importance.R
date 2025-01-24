library(data.table)
library(dplyr)
library(randomForest)

############################################################################
#                                                                          # 
#                             MPAACH cohort  - scags                       #                                    
###########################################################################

mpaach_h1h2h3_data <- fread("/Mpaach_h1h2h3/Matrix_without_IgM_IgD_reads.csv")
sensitization_status = read.delim('/sensitization_group_metadata.csv', header=T, sep=',')

#delete unwanted Subjects
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00044',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00076',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00135',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00187',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00218',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00313',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00534',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00548',]
mpaach_h1h2h3_data = mpaach_h1h2h3_data[mpaach_h1h2h3_data$Subject!= 'mpaach:MP00323',]

Subject=mpaach_h1h2h3_data$Subject
mpaach_h1h2h3_data$Subject=NULL
mpaach_h1h2h3_data[mpaach_h1h2h3_data > 0] = 1 

keep=which(colSums(mpaach_h1h2h3_data)>10)
mpaach_h1h2h3_data = mpaach_h1h2h3_data[,..keep]
mpaach_h1h2h3_data$Subject = Subject


#Merge metadata and Matrix
Matrix2 = merge(mpaach_h1h2h3_data,sensitization_status, by.x  ='Subject', by.y = 'subject')
meta_data = Matrix2$group

Matrix2$Subject =NULL

Matrix2$group = as.factor(Matrix2$group)
Matrix3 = Matrix2
Matrix3$group = NULL
Matrix3 = as.matrix(Matrix3)

set.seed(1)
rf <- randomForest(y= as.factor(Matrix2$group),x= Matrix2[, 1:31243], ntree=2000, proximity=TRUE, importance = TRUE, keep.inbag=TRUE) 

plot(rf$err.rate[,1], type = "l")
plot(rf, main="OOB Error Rate vs. Number of Trees")

Permutation  = data.frame(importance(rf, type=1))
Permutation$Features = row.names(Permutation)
least_neg = abs(min(Permutation$MeanDecreaseAccuracy))
permutation_data= Permutation[Permutation$MeanDecreaseAccuracy > least_neg,]

write.csv(permutation_data, '/Mpaach_h1h2h3/RandomForest_importance_nonNaive_Features_ntree1000.csv')

############################################################################
#                                                                          # 
#                             MPAACH cohort  - vj3                         #                                    
###########################################################################

Matrix <- fread("/MPAACH_vjs3/Full_Matrix_vjs3_isotype.csv")

#keep only class switched features in feature matrix
accepted_isotypes = c('isotype=IGHE','isotype=IGHG1','isotype=IGHG2','isotype=IGHG3','isotype=IGHG4','isotype=IGHA1','isotype=IGHA2')

keep =c()
for (cols in colnames(Matrix)){
  if (str_split_i(cols, ':',4) %in% accepted_isotypes){
    keep = c(keep, cols) 
  }
}

keep2= which(colnames(Matrix) %in% keep)
mat_keep = Matrix[,..keep2]

Subjects = Matrix$V1
Matrix$V1 = NULL

# make feature matrix cells binary
mat_keep[mat_keep > 0] = 1 

#filter columns based on the number of subjects that are in each column
keep=which(colSums(mat_keep)>10)
Matrix2= mat_keep[,..keep]
Matrix2 = cbind.data.frame(Subjects, Matrix2)

#Merge metadata and Matrix
Matrix2 = merge(Matrix2,metadata, by.x  ='Subjects', by.y = 'subject')

Matrix2$Subjects =NULL
Matrix2$group = as.factor(Matrix2$group)

set.seed(1)

#run random forest  model
rf <- randomForest(y= as.factor(Matrix2$group),x= Matrix2[, colnames(Matrix2) != "group"], ntree=2500, proximity=TRUE, importance = TRUE, keep.inbag=TRUE) 

plot(rf$err.rate[,1], type = "l")
plot(rf, main="OOB Error Rate vs. Number of Trees")

Permutation2  = data.frame(importance(rf, type=1))
Permutation2$Features = row.names(Permutation2)
least_neg = abs(min(Permutation2$MeanDecreaseAccuracy))

#carry out filtering
permutation_data2= Permutation2[Permutation2$MeanDecreaseAccuracy > least_neg,]

write.csv(permutation_data2, '/Mpaach_vjs3/RandomForest_importance_nonNaive_Features_mpaach_vj3ntree2500.csv')

############################################################################
#                                                                          # 
#                             CHAVI cohort                                 #                                    
###########################################################################

chavi_scag_data <- fread("/CHAVI_h1h2h3/Matrix_with_Isotype.csv")
metadata = read.delim('/CHAVI_h1h2h3/chavi_metadata.csv', header=T, sep=',')
metadata = metadata[,c(1,5)]

Subject=chavi_scag_data$subject
Subject = gsub('boydlab:', '', Subject)
chavi_scag_data$subject=NULL
chavi_scag_data[chavi_scag_data > 0] = 1 

keep=which(colSums(chavi_scag_data)>10)
chavi_scag_data_new = chavi_scag_data[,..keep]
chavi_scag_data_new$subject = Subject

#Merge metadata and Matrix
Matrix2 = merge(chavi_scag_data_new,metadata, by = 'subject')

Matrix2$subject =NULL

Matrix2$hiv_status = as.factor(Matrix2$hiv_status)
Matrix3 = Matrix2
Matrix3$hiv_status = NULL
Matrix3 = as.matrix(Matrix3)

set.seed(1)
rf <- randomForest(y= as.factor(Matrix2$hiv_status) ,x= Matrix2[, 1:56572], 
                   ntree=5000, proximity=TRUE, importance = TRUE, 
                   keep.inbag=TRUE, strata =as.factor(Matrix2$hiv_status),
                   sampsize = rep(43, 2)) 


plot(rf$err.rate[,1], type = "l")
plot(rf, main="OOB Error Rate vs. Number of Trees")

Permutation3  = data.frame(importance(rf, type=1))
Permutation3$Features = row.names(Permutation3)
least_neg = abs(min(Permutation3$MeanDecreaseAccuracy))
permutation_data3= Permutation3[Permutation3$MeanDecreaseAccuracy > least_neg,]

write.csv(permutation_data3, '/CHAVI_h1h2h3/RandomForest_importance_Features_ntree5000.csv')
