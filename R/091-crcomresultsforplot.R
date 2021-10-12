library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)


#format combined results for forest plots
#see formatfiles.R for creation of csv files
#creates RDS files for use in forest plots
#re run to include nonhuman results
#add age 4 to severe GI

#GI
comresults <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresults, "...1", "Outcome")
setnames(comresults, "Upper CI", "Upper")
setnames(comresults, "Lower CI", "Lower")
setnames(comresults, "Coef.", "Coef")

comresults$age <- factor(comresults$age,
                         levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
comresults<-filter(comresults, age!="age4")

comresults$exposurecat <- NA
comresults$exposurecat<-ifelse(grepl("swallwater", comresults$command), "swallwater", NA)
comresults$exposurecat1<-ifelse(grepl("anycontact", comresults$command), "anycontact", NA)
comresults$exposurecat2<-ifelse(grepl("bodycontact", comresults$command), "bodycontact", NA)
comresults$exposurecat3<-ifelse(grepl("water30", comresults$command), "water30", NA)
comresults$exposurecat4<-ifelse(grepl("water45", comresults$command), "water45", NA)
comresults$exposurecat5<-ifelse(grepl("water60", comresults$command), "water60", NA)


comresults <- unite(comresults, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresults$exposure <- factor(comresults$exposure,
                              levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                              labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresults<-filter(comresults, exposure!="45 minutes")
saveRDS(comresults, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsGI.rds")


#GI- with age4
comresultsage4 <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultsage4, "...1", "Outcome")
setnames(comresultsage4, "Upper CI", "Upper")
setnames(comresultsage4, "Lower CI", "Lower")
setnames(comresultsage4, "Coef.", "Coef")

comresultsage4$age <- factor(comresultsage4$age,
                         levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
#comresults<-filter(comresults, age!="age4")

comresultsage4$exposurecat <- NA
comresultsage4$exposurecat<-ifelse(grepl("swallwater", comresultsage4$command), "swallwater", NA)
comresultsage4$exposurecat1<-ifelse(grepl("anycontact", comresultsage4$command), "anycontact", NA)
comresultsage4$exposurecat2<-ifelse(grepl("bodycontact", comresultsage4$command), "bodycontact", NA)
comresultsage4$exposurecat3<-ifelse(grepl("water30", comresultsage4$command), "water30", NA)
comresultsage4$exposurecat4<-ifelse(grepl("water45", comresultsage4$command), "water45", NA)
comresultsage4$exposurecat5<-ifelse(grepl("water60", comresultsage4$command), "water60", NA)


comresultsage4 <- unite(comresultsage4, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultsage4$exposure <- factor(comresultsage4$exposure,
                              levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                              labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultsage4<-filter(comresultsage4, exposure!="45 minutes")
saveRDS(comresultsage4, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsGIage4.rds")



# forplot(dat=comresults, indicator="pcr", outcome="hcgi", sitetype="allsites")
# forplot(dat=comresults, indicator="pcr", outcome="diarrhea", sitetype="allsites", save=TRUE, savename="test3.pdf", savesize=1.5)
# 
# forplot(dat=comresults, indicator="pcr", outcome="diarrhea", sitetype="risk", save=TRUE, savename="test4.pdf", savesize=1.7)
# 
# 

#respiratory      
comresultsresp <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultsresp, "...1", "Outcome")
setnames(comresultsresp, "Upper CI", "Upper")
setnames(comresultsresp, "Lower CI", "Lower")
setnames(comresultsresp, "Coef.", "Coef")

comresultsresp$age <- factor(comresultsresp$age,
                             levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
comresultsresp<-filter(comresultsresp, age!="age4")

comresultsresp$exposurecat <- NA
comresultsresp$exposurecat<-ifelse(grepl("swallwater", comresultsresp$command), "swallwater", NA)
comresultsresp$exposurecat1<-ifelse(grepl("anycontact", comresultsresp$command), "anycontact", NA)
comresultsresp$exposurecat2<-ifelse(grepl("bodycontact", comresultsresp$command), "bodycontact", NA)
comresultsresp$exposurecat3<-ifelse(grepl("water30", comresultsresp$command), "water30", NA)
comresultsresp$exposurecat4<-ifelse(grepl("water45", comresultsresp$command), "water45", NA)
comresultsresp$exposurecat5<-ifelse(grepl("water60", comresultsresp$command), "water60", NA)


comresultsresp <- unite(comresultsresp, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultsresp$exposure <- factor(comresultsresp$exposure,
                                  levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                                  labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultsresp<-filter(comresultsresp, exposure!="45 minutes")
saveRDS(comresultsresp, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.rds")


#respiratory  - keep age 4    
comresultsrespage4 <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultsrespage4, "...1", "Outcome")
setnames(comresultsrespage4, "Upper CI", "Upper")
setnames(comresultsrespage4, "Lower CI", "Lower")
setnames(comresultsrespage4, "Coef.", "Coef")

comresultsrespage4$age <- factor(comresultsresp$age,
                             levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)


comresultsrespage4$exposurecat <- NA
comresultsrespage4$exposurecat<-ifelse(grepl("swallwater", comresultsrespage4$command), "swallwater", NA)
comresultsrespage4$exposurecat1<-ifelse(grepl("anycontact", comresultsrespage4$command), "anycontact", NA)
comresultsrespage4$exposurecat2<-ifelse(grepl("bodycontact", comresultsrespage4$command), "bodycontact", NA)
comresultsrespage4$exposurecat3<-ifelse(grepl("water30", comresultsrespage4$command), "water30", NA)
comresultsrespage4$exposurecat4<-ifelse(grepl("water45", comresultsrespage4$command), "water45", NA)
comresultsrespage4$exposurecat5<-ifelse(grepl("water60", comresultsrespage4$command), "water60", NA)


comresultsrespage4 <- unite(comresultsrespage4, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultsrespage4$exposure <- factor(comresultsrespage4$exposure,
                                  levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                                  labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultsrespage4<-filter(comresultsrespage4, exposure!="45 minutes")
saveRDS(comresultsrespage4, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrespage4.rds")









#severegi - with age 4   
comresultseveregiage4 <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultseveregiage4, "...1", "Outcome")
setnames(comresultseveregiage4, "Upper CI", "Upper")
setnames(comresultseveregiage4, "Lower CI", "Lower")
setnames(comresultseveregiage4, "Coef.", "Coef")

comresultseveregiage4$age <- factor(comresultseveregiage4$age,
                                levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
#comresultseveregiage4<-filter(comresultseveregiage4, age!="age4")

comresultseveregiage4$exposurecat <- NA
comresultseveregiage4$exposurecat<-ifelse(grepl("swallwater", comresultseveregiage4$command), "swallwater", NA)
comresultseveregiage4$exposurecat1<-ifelse(grepl("anycontact", comresultseveregiage4$command), "anycontact", NA)
comresultseveregiage4$exposurecat2<-ifelse(grepl("bodycontact", comresultseveregiage4$command), "bodycontact", NA)
comresultseveregiage4$exposurecat3<-ifelse(grepl("water30", comresultseveregiage4$command), "water30", NA)
comresultseveregiage4$exposurecat4<-ifelse(grepl("water45", comresultseveregiage4$command), "water45", NA)
comresultseveregiage4$exposurecat5<-ifelse(grepl("water60", comresultseveregiage4$command), "water60", NA)


comresultseveregiage4 <- unite(comresultseveregiage4, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultseveregiage4$exposure <- factor(comresultseveregiage4$exposure,
                                     levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                                     labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultseveregiage4<-filter(comresultseveregiage4, exposure!="45 minutes")
saveRDS(comresultseveregiage4, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregiage4.rds")


#severegi    
comresultseveregi <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultseveregi, "...1", "Outcome")
setnames(comresultseveregi, "Upper CI", "Upper")
setnames(comresultseveregi, "Lower CI", "Lower")
setnames(comresultseveregi, "Coef.", "Coef")

comresultseveregi$age <- factor(comresultseveregi$age,
                                levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
comresultseveregi<-filter(comresultseveregi, age!="age4")

comresultseveregi$exposurecat <- NA
comresultseveregi$exposurecat<-ifelse(grepl("swallwater", comresultseveregi$command), "swallwater", NA)
comresultseveregi$exposurecat1<-ifelse(grepl("anycontact", comresultseveregi$command), "anycontact", NA)
comresultseveregi$exposurecat2<-ifelse(grepl("bodycontact", comresultseveregi$command), "bodycontact", NA)
comresultseveregi$exposurecat3<-ifelse(grepl("water30", comresultseveregi$command), "water30", NA)
comresultseveregi$exposurecat4<-ifelse(grepl("water45", comresultseveregi$command), "water45", NA)
comresultseveregi$exposurecat5<-ifelse(grepl("water60", comresultseveregi$command), "water60", NA)


comresultseveregi <- unite(comresultseveregi, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultseveregi$exposure <- factor(comresultseveregi$exposure,
                                     levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                                     labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultseveregi<-filter(comresultseveregi, exposure!="45 minutes")
saveRDS(comresultseveregi, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.rds")







#rash  
comresultsrash <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.csv", stringsAsFactors = FALSE)

#comresults$age <- factor(comresults$age,
#                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
#                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))

setnames(comresultsrash, "...1", "Outcome")
setnames(comresultsrash, "Upper CI", "Upper")
setnames(comresultsrash, "Lower CI", "Lower")
setnames(comresultsrash, "Coef.", "Coef")

comresultsrash$age <- factor(comresultsrash$age,
                             levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#ordered = TRUE)
#drop age group 4 and under
comresultsrash<-filter(comresultsrash, age!="age4")

comresultsrash$exposurecat <- NA
comresultsrash$exposurecat<-ifelse(grepl("swallwater", comresultsrash$command), "swallwater", NA)
comresultsrash$exposurecat1<-ifelse(grepl("anycontact", comresultsrash$command), "anycontact", NA)
comresultsrash$exposurecat2<-ifelse(grepl("bodycontact", comresultsrash$command), "bodycontact", NA)
comresultsrash$exposurecat3<-ifelse(grepl("water30", comresultsrash$command), "water30", NA)
comresultsrash$exposurecat4<-ifelse(grepl("water45", comresultsrash$command), "water45", NA)
comresultsrash$exposurecat5<-ifelse(grepl("water60", comresultsrash$command), "water60", NA)


comresultsrash <- unite(comresultsrash, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)


comresultsrash$exposure <- factor(comresultsrash$exposure,
                                  levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
                                  labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))

#drop 45 minutes in water

comresultsrash<-filter(comresultsrash, exposure!="45 minutes")
saveRDS(comresultsrash, "C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.rds")

