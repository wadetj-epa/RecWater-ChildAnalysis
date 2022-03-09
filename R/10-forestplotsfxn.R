#need to set up data before running plots
#RDS files created and formatted for plotting by crcomresultsforplot.R
#cvs files saved by formatfiles.R
#add non human to function
#edit plots to have dots instead of box symbols
#added alternate color schemes (forplotalt)
#save files as eps for PLOS One

rm(list=ls())
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)


#plotting function

forplot=function(dat, indicator, outcome, sitetype, expfilt=NULL, save=FALSE, savename=NULL, savenameeps=NULL, savesize=NULL, print=TRUE) {
  if(exists("p")) rm(p)
  p<-dat %>%
    filter(ind==indicator, Outcome==outcome, site==sitetype) %>%
    ggplot(aes(y = age, x = Coef, xmin=Lower, xmax=Upper)) +
    geom_errorbar()+
    geom_point(aes(color=age), size=4)+
    scale_color_manual(values=c('red','green', 'orange', "grey", "blue", "darkgreen", "black"),
                       labels=c("6 and under", "8 and under", "10 and under", "12 and under", "13 and over", "18 and over", "All ages"))+
    scale_x_log10(breaks=ticks, labels = ticks) +
    #scale_fill_discrete(name="Age group", labels=c("4 and under", "6 and under", "8 and under", "10 and under", "12 and under", "All ages"))
    #geom_pointrange(aes(xmin = Lower, xmax = Upper),
    #               position = dodger,
    #              size = .5) +
    geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
    labs(y = "", x = "Odds Ratio") +
    theme_bw()+ 
    facet_grid(exposure~., switch = "y")+
    theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
    guides(color=guide_legend("Age group", reverse=TRUE))
    if(print==TRUE) print(p)
    
    if(save==TRUE) {
      ggsave(savename, scale=savesize)
      ggsave(savenameeps, width=11, height=7.25, units="in", device="eps")
    }
  
    rm(p)
}


forplotalt=function(dat, indicator, outcome, sitetype, expfilt=NULL, save=FALSE, savename=NULL, savenameeps=NULL, savesize=NULL, print=TRUE) {
  if(exists("p")) rm(p)
  p<-dat %>%
    filter(ind==indicator, Outcome==outcome, site==sitetype) %>%
    ggplot(aes(y = age, x = Coef, xmin=Lower, xmax=Upper)) +
    geom_errorbar()+
    geom_point(aes(color=age), size=4)+
    #scale_color_manual(values=c('red','green', 'orange', "grey", "blue", "darkgreen", "black"),
                       #labels=c("6 and under", "8 and under", "10 and under", "12 and under", "13 and over", "18 and over", "All ages"))+
    scale_color_brewer(palette="Set1",labels=c("6 and under", "8 and under", "10 and under", "12 and under", "13 and over", "18 and over", "All ages"))+
    scale_x_log10(breaks=ticks, labels = ticks) +
    #scale_fill_discrete(name="Age group", labels=c("4 and under", "6 and under", "8 and under", "10 and under", "12 and under", "All ages"))
    #geom_pointrange(aes(xmin = Lower, xmax = Upper),
    #               position = dodger,
    #              size = .5) +
    geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
    labs(y = "", x = "Odds Ratio") +
    theme_grey()+ 
    facet_grid(exposure~., switch = "y")+
    theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
    guides(color=guide_legend("Age group", reverse=TRUE))
  if(print==TRUE) print(p)
  
  if(save==TRUE) {
    ggsave(savename, scale=savesize)
    ggsave(savenameeps, width=11, height=7.25, units="in", device="eps")
  }
  
  rm(p)
}




comresults<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.rds")
#filter to keep original age groups
comresults<-dplyr::filter(comresults, age!="age4" & age!="age410" & age!="age412" & age!="age610" & age!="age612")

dodger = position_dodge(width = 0.3)

ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))


indlist<-c("cfu", "pcr")
outlist<-c("hcgi", "diarrhea", "nausea", "stomach", "vomiting")
sitelist<-c("allsites", "risk", "neearall", "risknotropical", "neearps", "neearcore", "nonhuman")
rm(list=c("i","j","k")) 



roottemp<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/"

for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    for(k in 1:length(sitelist)) {
   
  filetemp<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".pdf", sep="")   
  filetempalt<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".pdf", sep="") 
  filetempeps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".eps", sep="")   
  filetempalteps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".eps", sep="") 
  indtemp<-indlist[i]
   outtemp<-outlist[j]
   sitetemp<-sitelist[k]
   forplot(dat=comresults, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetemp, savenameeps=filetempeps, savesize=1.7, print=FALSE)
   forplotalt(dat=comresults, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetempalt, savenameeps=filetempalteps, savesize=1.7, print=FALSE)
   
    }
  }
}

comresultsresp<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.rds")
#filter to keep original age groups
comresultsresp<-dplyr::filter(comresultsresp, age!="age4" & age!="age410" & age!="age412" & age!="age610" & age!="age612")

dodger = position_dodge(width = 0.3)

#try adding log scale and ticks
#ticks<-c(seq(.1, 1, by =.1), seq(0, 10, by =1), seq(10, 100, by =10))

ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))


indlist<-c("cfu", "pcr")
outlist<-c("cough", "cold", "hcresp", "sorethroat")
sitelist<-c("allsites", "risk", "neearall", "risknotropical", "neearps", "neearcore", "nonhuman")
rm(list=c("i","j","k")) 



roottemp<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/"

for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    for(k in 1:length(sitelist)) {
      
      filetemp<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".pdf", sep="")   
      filetempalt<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".pdf", sep="") 
      filetempeps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".eps", sep="")   
      filetempalteps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".eps", sep="") 
      
      indtemp<-indlist[i]
      outtemp<-outlist[j]
      sitetemp<-sitelist[k]
      forplot(dat=comresultsresp, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetemp, savenameeps=filetempeps, savesize=1.7, print=FALSE)
      forplotalt(dat=comresultsresp, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetempalt, savenameeps=filetempalteps, savesize=1.7, print=FALSE)
      }
  }
}

comresultseveregi<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.rds")
#filter to keep original age groups
comresultseveregi<-dplyr::filter(comresultseveregi, age!="age4" & age!="age410" & age!="age412" & age!="age610" & age!="age612")


dodger = position_dodge(width = 0.3)

ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))

indlist<-c("cfu", "pcr")
outlist<-c("severegi")
sitelist<-c("allsites", "risk", "neearall", "risknotropical", "neearps", "neearcore")
rm(list=c("i","j","k")) 



roottemp<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/"

for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    for(k in 1:length(sitelist)) {
      
      filetemp<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".pdf", sep="")   
      filetempalt<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".pdf", sep="")   
      filetempeps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".eps", sep="")   
      filetempalteps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".eps", sep="")   
      indtemp<-indlist[i]
      outtemp<-outlist[j]
      sitetemp<-sitelist[k]
      forplot(dat=comresultseveregi, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetemp, savenameeps=filetempeps, savesize=1.7, print=FALSE)
      forplotalt(dat=comresultseveregi, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetempalt, savenameeps=filetempalteps, savesize=1.7, print=FALSE)
      }
  }
}


comresultsrash<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.rds")
#filter to keep original age groups
comresultsrash<-dplyr::filter(comresultsrash, age!="age4" & age!="age410" & age!="age412" & age!="age610" & age!="age612")


dodger = position_dodge(width = 0.3)

ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))


indlist<-c("cfu", "pcr")
outlist<-c("rash")
sitelist<-c("allsites", "risk", "neearall", "risknotropical", "neearps", "neearcore", "nonhuman")
rm(list=c("i","j","k")) 



roottemp<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/"

for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    for(k in 1:length(sitelist)) {
      
      filetemp<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".pdf", sep="")   
      filetempalt<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".pdf", sep="")   
      filetempeps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], ".eps", sep="")   
      filetempalteps<-paste(roottemp, outlist[j], sitelist[k], indlist[i], "alt", ".eps", sep="")   
      
      indtemp<-indlist[i]
      outtemp<-outlist[j]
      sitetemp<-sitelist[k]
      forplotalt(dat=comresultsrash, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetemp, savenameeps=filetempeps, savesize=1.7, print=FALSE)
      forplot(dat=comresultsrash, indicator=indtemp, outcome=outtemp, sitetype=sitetemp, save=TRUE, savename=filetemp, savenameeps=filetempalteps, savesize=1.7, print=FALSE)
    }
  }
}



#GI
# comresults <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.csv", stringsAsFactors = FALSE)
# 
# #comresults$age <- factor(comresults$age,
# #                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
# #                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))
# 
# setnames(comresults, "...1", "Outcome")
# setnames(comresults, "Upper CI", "Upper")
# setnames(comresults, "Lower CI", "Lower")
# setnames(comresults, "Coef.", "Coef")
# 
# comresults$age <- factor(comresults$age,
#                          levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
#                          #ordered = TRUE)
# #drop age group 4 and under
# comresults<-filter(comresults, age!="age4")
# 
# comresults$exposurecat <- NA
# comresults$exposurecat<-ifelse(grepl("swallwater", comresults$command), "swallwater", NA)
# comresults$exposurecat1<-ifelse(grepl("anycontact", comresults$command), "anycontact", NA)
# comresults$exposurecat2<-ifelse(grepl("bodycontact", comresults$command), "bodycontact", NA)
# comresults$exposurecat3<-ifelse(grepl("water30", comresults$command), "water30", NA)
# comresults$exposurecat4<-ifelse(grepl("water45", comresults$command), "water45", NA)
# comresults$exposurecat5<-ifelse(grepl("water60", comresults$command), "water60", NA)
# 
# 
# comresults <- unite(comresults, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)
# 
# 
# comresults$exposure <- factor(comresults$exposure,
#                               levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
#                               labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))
# 
# #drop 45 minutes in water
# 
# comresults<-filter(comresults, exposure!="45 minutes")

#respiratory      
# comresultsresp <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.csv", stringsAsFactors = FALSE)
# 
# #comresults$age <- factor(comresults$age,
# #                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
# #                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))
# 
# setnames(comresultsresp, "...1", "Outcome")
# setnames(comresultsresp, "Upper CI", "Upper")
# setnames(comresultsresp, "Lower CI", "Lower")
# setnames(comresultsresp, "Coef.", "Coef")
# 
# comresultsresp$age <- factor(comresultsresp$age,
#                          levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
# #ordered = TRUE)
# #drop age group 4 and under
# comresultsresp<-filter(comresultsresp, age!="age4")
# 
# comresultsresp$exposurecat <- NA
# comresultsresp$exposurecat<-ifelse(grepl("swallwater", comresultsresp$command), "swallwater", NA)
# comresultsresp$exposurecat1<-ifelse(grepl("anycontact", comresultsresp$command), "anycontact", NA)
# comresultsresp$exposurecat2<-ifelse(grepl("bodycontact", comresultsresp$command), "bodycontact", NA)
# comresultsresp$exposurecat3<-ifelse(grepl("water30", comresultsresp$command), "water30", NA)
# comresultsresp$exposurecat4<-ifelse(grepl("water45", comresultsresp$command), "water45", NA)
# comresultsresp$exposurecat5<-ifelse(grepl("water60", comresultsresp$command), "water60", NA)
# 
# 
# comresultsresp <- unite(comresultsresp, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)
# 
# 
# comresultsresp$exposure <- factor(comresultsresp$exposure,
#                               levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
#                               labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))
# 
# #drop 45 minutes in water
# 
# comresultsresp<-filter(comresultsresp, exposure!="45 minutes")



#rash  
# comresultsrash <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.csv", stringsAsFactors = FALSE)
# 
# #comresults$age <- factor(comresults$age,
# #                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
# #                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))
# 
# setnames(comresultsrash, "...1", "Outcome")
# setnames(comresultsrash, "Upper CI", "Upper")
# setnames(comresultsrash, "Lower CI", "Lower")
# setnames(comresultsrash, "Coef.", "Coef")
# 
# comresultsrash$age <- factor(comresultsrash$age,
#                                 levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
# #ordered = TRUE)
# #drop age group 4 and under
# comresultsrash<-filter(comresultsrash, age!="age4")
# 
# comresultsrash$exposurecat <- NA
# comresultsrash$exposurecat<-ifelse(grepl("swallwater", comresultsrash$command), "swallwater", NA)
# comresultsrash$exposurecat1<-ifelse(grepl("anycontact", comresultsrash$command), "anycontact", NA)
# comresultsrash$exposurecat2<-ifelse(grepl("bodycontact", comresultsrash$command), "bodycontact", NA)
# comresultsrash$exposurecat3<-ifelse(grepl("water30", comresultsrash$command), "water30", NA)
# comresultsrash$exposurecat4<-ifelse(grepl("water45", comresultsrash$command), "water45", NA)
# comresultsrash$exposurecat5<-ifelse(grepl("water60", comresultsrash$command), "water60", NA)
# 
# 
# comresultsrash <- unite(comresultsrash, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)
# 
# 
# comresultsrash$exposure <- factor(comresultsrash$exposure,
#                                      levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
#                                      labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))
# 
# #drop 45 minutes in water
# 
# comresultsrash<-filter(comresultsrash, exposure!="45 minutes")


#severegi    
# comresultseveregi <- fread("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.csv", stringsAsFactors = FALSE)
# 
# #comresults$age <- factor(comresults$age,
# #                         levels = c("age4", "age6", "age8", "age10", "age12", "allages"),
# #                         ordered = TRUE, labels=c("4 and under", "6 and under", "10 and under", "12 and under", "All ages"))
# 
# setnames(comresultseveregi, "...1", "Outcome")
# setnames(comresultseveregi, "Upper CI", "Upper")
# setnames(comresultseveregi, "Lower CI", "Lower")
# setnames(comresultseveregi, "Coef.", "Coef")
# 
# comresultseveregi$age <- factor(comresultseveregi$age,
#                              levels = c("age4", "age6", "age8", "age10", "age12", "age13up", "age18up", "allages"))
# #ordered = TRUE)
# #drop age group 4 and under
# comresultseveregi<-filter(comresultseveregi, age!="age4")
# 
# comresultseveregi$exposurecat <- NA
# comresultseveregi$exposurecat<-ifelse(grepl("swallwater", comresultseveregi$command), "swallwater", NA)
# comresultseveregi$exposurecat1<-ifelse(grepl("anycontact", comresultseveregi$command), "anycontact", NA)
# comresultseveregi$exposurecat2<-ifelse(grepl("bodycontact", comresultseveregi$command), "bodycontact", NA)
# comresultseveregi$exposurecat3<-ifelse(grepl("water30", comresultseveregi$command), "water30", NA)
# comresultseveregi$exposurecat4<-ifelse(grepl("water45", comresultseveregi$command), "water45", NA)
# comresultseveregi$exposurecat5<-ifelse(grepl("water60", comresultseveregi$command), "water60", NA)
# 
# 
# comresultseveregi <- unite(comresultseveregi, exposure,c(exposurecat:exposurecat5), na.rm = TRUE, remove = TRUE)
# 
# 
# comresultseveregi$exposure <- factor(comresultseveregi$exposure,
#                                   levels = c("anycontact", "bodycontact", "swallwater", "water30", "water45", "water60"),
#                                   labels = c("Any contact", "Body immersion", "Swallowed water", "30 minutes", "45 minutes", "60 minutes"))
# 
# #drop 45 minutes in water
# 
# comresultseveregi<-filter(comresultseveregi, exposure!="45 minutes")

