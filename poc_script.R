#importing data
load("POC_data.Rdata")
load("test_data.Rdata")

View(data)
View(test)

#encoding variables training data
data$Beneficiary.gender.code <- factor(data$Beneficiary.gender.code, labels = c(1,2), levels = c('female','male'))
data$Base.DRG.code <- factor(data$Base.DRG.code, labels = c(10000,20000,30000,40000,50000,60000,70000,80000,90000), levels = c('Diabetes','Other digestive system O.R. procedures','Female reproductive system reconstructive procedures','G.I. hemorrhage',
                                                                                                                               'Alcohol/drug abuse or dependence w/o rehabilitation therapy','Psychoses','Rehabilitation','Permanent cardiac pacemaker implant','Traumatic stupor & coma'))
data$ICD9.primary.procedure.code <- factor(data$ICD9.primary.procedure.code, labels = c(1000,2000,3000,4000,5000,6000,7000), levels = c('No procedure performed','Other abdomen region ops','Vagina & cul-de-sac ops','Intest incis/excis/anast','Psyche related procedure','Pt, rehab & related proc','Other heart/pericard ops'))

data$Inpatient.days.code <- factor(data$Inpatient.days.code, labels = c(100,200,300), levels = c('2-3 days','8 or more days','1 day'))

data$Beneficiary.Age.category.code <- factor(data$Beneficiary.Age.category.code, labels = c(10,20,30,40), levels = c('80 - 84 ','Under  65 ','65 - 69 ','85 & Older'))


#encoding test data
test$Beneficiary.gender.code <- factor(test$Beneficiary.gender.code, labels = c(1,2), levels = c('female','male'))
test$Base.DRG.code <- factor(test$Base.DRG.code, labels = c(10000,20000,30000,40000,50000,60000,70000,80000,90000), levels = c('Diabetes','Other digestive system O.R. procedures','Female reproductive system reconstructive procedures','G.I. hemorrhage',
                                                                                                                               'Alcohol/drug abuse or dependence w/o rehabilitation therapy','Psychoses','Rehabilitation','Permanent cardiac pacemaker implant','Traumatic stupor & coma'))

test$ICD9.primary.procedure.code <- factor(test$ICD9.primary.procedure.code, labels = c(1000,2000,3000,4000,5000,6000,7000), levels = c('No procedure performed','Other abdomen region ops','Vagina & cul-de-sac ops','Intest incis/excis/anast','Psyche related procedure','Pt, rehab & related proc','Other heart/pericard ops'))

test$Inpatient.days.code <- factor(test$Inpatient.days.code, labels = c(100,200,300), levels = c('2-3 days','8 or more days','1 day'))

test$Beneficiary.Age.category.code <- factor(test$Beneficiary.Age.category.code, labels = c(10,20,30,40), levels = c('80 - 84 ','Under  65 ','65 - 69 ','85 & Older'))


#Model Building
#Artificial neural networks
library(h2o)
h2o.init(nthreads = -1)
ann_classifier <- h2o.deeplearning(y = 'DRG.quintile.average.payment.amount',
                                   training_frame = as.h2o(data),
                                   activation = 'Rectifier',
                                   epochs = 100,
                                   hidden = c(8,8),
                                   train_samples_per_iteration = -2)

#predict on training data
pred <- as.data.frame(predict(ann_classifier, newdata = as.h2o(data[,-6])))

table <- cbind(predicted = pred, Actuals = data$DRG.quintile.average.payment.amount)
View(table)

#predicting test data
test_pred <- as.data.frame(predict(ann_classifier, newdata = as.h2o(test[,-6])))

test_table <- cbind(predicted = test_pred, Actuals = test$DRG.quintile.average.payment.amount)
View(test_table)
