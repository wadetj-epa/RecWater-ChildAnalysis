#read in combined results to assess significant interaction effects
#criteria-main effect is significant in original model
#one or more interaction effects are significant

#note outputs did not get read in correctly for respiratory interaction


library(dplyr)
library(readxl)
library(tidyr)
comresultsGI<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsGIage4.rds")
comresultsGI$p=comresultsGI$'p-value'
comresultsGI$exp<-ifelse(comresultsGI$exposure=="Any contact", "anycontact", NA)
comresultsGI$exp<-ifelse(comresultsGI$exposure=="Body immersion", "bodycontact", comresultsGI$exp)
comresultsGI$exp<-ifelse(comresultsGI$exposure=="Swallowed water", "swallwater", comresultsGI$exp)
comresultsGI$exp<-ifelse(comresultsGI$exposure=="30 minutes", "water30", comresultsGI$exp)
comresultsGI$exp<-ifelse(comresultsGI$exposure=="45 minutes", "water45", comresultsGI$exp)
comresultsGI$exp<-ifelse(comresultsGI$exposure=="60 minutes", "water60", comresultsGI$exp)

giint<-read_excel("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/interactiontests/giinteractiontests.xlsx")


names(giint)[2]<-"exp"
names(giint)[7]<-"ORint"
names(giint)[8]<-"pvalint"
names(giint)[9]<-"ORchild"
names(giint)[10]<-"pvalchild"
names(giint)[11]<-"ORadult"
names(giint)[12]<-"pvaladult"

comresultsGI<-comresultsGI[, c(-1, -3, -7, -14)]
names(comresultsGI)[8]<-"Age"
names(comresultsGI)[9]<-"Site"
names(comresultsGI)[10]<-"Indicator"

giint$Indicator=ifelse(giint$Indicator=="avgdyentero1600", "cfu", "pcr")


#filter significant effects for children
sigeffs<-comresultseveregi %>%
  dplyr::filter(Coef>1,  p<0.05, Age!="age13up" & Age!="age18up" & Age!="allages")

ints<-merge( sigeffs, giint, by=c("Outcome", "Indicator", "Age", "Site", "exp"))

sigintseveregi<-filter(ints, pvalint<0.05)


#severeGI- interaction tests are with other GI models
#main models are in different file

comresultseveregi<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregiage4.rds")
comresultseveregi$p=comresultseveregi$'p-value'
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="Any contact", "anycontact", NA)
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="Body immersion", "bodycontact", comresultseveregi$exp)
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="Swallowed water", "swallwater", comresultseveregi$exp)
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="30 minutes", "water30", comresultseveregi$exp)
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="45 minutes", "water45", comresultseveregi$exp)
comresultseveregi$exp<-ifelse(comresultseveregi$exposure=="60 minutes", "water60", comresultseveregi$exp)


comresultseveregi<-comresultseveregi[, c(-1, -3, -7, -14)]
names(comresultseveregi)[8]<-"Age"
names(comresultseveregi)[9]<-"Site"
names(comresultseveregi)[10]<-"Indicator"




#respiratory

comresultsresp<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrespage4.rds")
comresultsresp$p=comresultsresp$'p-value'
comresultsresp$exp<-ifelse(comresultsresp$exposure=="Any contact", "anycontact", NA)
comresultsresp$exp<-ifelse(comresultsresp$exposure=="Body immersion", "bodycontact", comresultsresp$exp)
comresultsresp$exp<-ifelse(comresultsresp$exposure=="Swallowed water", "swallwater", comresultsresp$exp)
comresultsresp$exp<-ifelse(comresultsresp$exposure=="30 minutes", "water30", comresultsresp$exp)
comresultsresp$exp<-ifelse(comresultsresp$exposure=="45 minutes", "water45", comresultsresp$exp)
comresultsresp$exp<-ifelse(comresultsresp$exposure=="60 minutes", "water60", comresultsresp$exp)

respint<-read_excel("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/interactiontests/respinteractiontests.xlsx")


names(respint)[2]<-"exp"
names(respint)[7]<-"ORint"
names(respint)[8]<-"pvalint"
names(respint)[9]<-"ORchild"
names(respint)[10]<-"pvalchild"
names(respint)[11]<-"ORadult"
names(respint)[12]<-"pvaladult"

comresultsresp<-comresultsresp[, c(-1, -3, -7, -14)]
names(comresultsresp)[8]<-"Age"
names(comresultsresp)[9]<-"Site"
names(comresultsresp)[10]<-"Indicator"

respint$Indicator=ifelse(respint$Indicator=="avgdyentero1600", "cfu", "pcr")


#filter significant effects for children
sigeffs<-comresultsresp %>%
  dplyr::filter(Coef>1,  p<0.05, Age!="age13up" & Age!="age18up" & Age!="allages")

ints<-merge( sigeffs, respint, by=c("Outcome", "Indicator", "Age", "Site", "exp"))

sigintsresp<-filter(ints, pvalint<0.05)

allints<-rbind.data.frame(sigintsGI, sigintseveregi, sigintsresp)

write.csv(allints, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/interactiontests/siginteractions.csv", row.names=FALSE)