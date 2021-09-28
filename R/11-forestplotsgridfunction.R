
rm(list=ls())
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)



#comresults<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.rds")


#forplotgrid1- all sites, core neear, human source (no tropcical)
#all ages, over 18, 12, 10 and 8
forplotgrid1=function(dat, indicator, outcome, expfilt=NULL, save=FALSE, savename=NULL, savesize=NULL, print=TRUE) {
  if(exists("p")) rm(p)
  p<-dat %>%
    #filter(ind==indicator, Outcome==outcome,  age!="age8", site=="allsites"|site=="risk"|site=="neearcore"|site=="risknotropical")%>%
    filter(ind==indicator, Outcome==outcome,  age!="age8" & age!="age13up", site=="allsites"|site=="neearcore"|site=="risknotropical")%>%
    
    ggplot(aes(y = age, x = Coef, xmin=Lower, xmax=Upper)) +
    geom_errorbar()+
    #geom_point(aes(color=age), size=3.8, shape=15)+
    geom_point(aes(color=age), size=3.2)+
    #scale_shape_manual(values=c(15,15,15, 15, 15, 15)) +
    scale_color_manual(values=c('red', 'orange', "grey", "blue", "darkgreen", "black"),
                       labels=c("6 and under", "10 and under", "12 and under", "Over 18", "All ages"))+
    scale_x_log10(breaks=ticks, labels = ticks) +
    #scale_fill_discrete(name="Age group", labels=c("4 and under", "6 and under", "8 and under", "10 and under", "12 and under", "All ages"))
    #geom_pointrange(aes(xmin = Lower, xmax = Upper),
    #               position = dodger,
    #              size = .5) +
    geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
    labs(y = "", x = "Odds Ratio") +
    theme_bw()+ 
    facet_grid(exposure~site, switch = "y", labeller=labeller(site=site.labs))+
    theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
    guides(color=guide_legend("Age group", reverse=TRUE))
    if(print==TRUE) print(p)
    
    if(save==TRUE) {
      ggsave(savename, scale=savesize, width=12, height=8)
    }
    
    rm(p)
}

  
comresults<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.rds")
ticks<-c(seq(.2, .8, by =.2), seq(1, 3.8, by=.5), seq(4, 9.5, by=1), seq(10, 100, by =10))
#site.labs=c('allsites'="All sites", 'neearall'="All NEEAR", 'neearcore'="Core NEEAR",
       #     'neearps'="NEEAR Point source", 'risk'="Human source", 'risknotropical'="Human source (no tropical)")

site.labs=c('allsites'="All sites", 'neearall'="All NEEAR", 'neearcore'="Core NEEAR",
            'neearps'="NEEAR Point source", 'risknotropical'="Human source (no tropical)")


#forplotgrid1(dat=comresults, indicator="pcr", outcome="diarrhea", save=TRUE, savename="test.pdf", savesize=3)


indlist<-c("cfu", "pcr")
outlist<-c("hcgi", "diarrhea", "nausea", "stomach", "vomiting")
rm(list=c("i","j")) 

roottemp<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/grids/"

for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
      
      filetemp<-paste(roottemp, outlist[j], indlist[i], ".pdf", sep="")   
      indtemp<-indlist[i]
      outtemp<-outlist[j]
      forplotgrid1(dat=comresults, indicator=indtemp, outcome=outtemp, save=TRUE, savename=filetemp, savesize=1.1, print=FALSE)
    }
  }


comresultsresp<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.rds")

indlist<-c("cfu", "pcr")
outlist<-c("cough", "cold", "hcresp", "sorethroat")
rm(list=c("i","j")) 


for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
      
      filetemp<-paste(roottemp, outlist[j], indlist[i], ".pdf", sep="")   
      indtemp<-indlist[i]
      outtemp<-outlist[j]
      forplotgrid1(dat=comresultsresp, indicator=indtemp, outcome=outtemp, save=TRUE, savename=filetemp, savesize=1.1, print=FALSE)
    }
  }


comresultseveregi<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.rds")
ticks<-c(seq(.2, .8, by =.2), seq(1, 7, by=2),  seq(10, 100, by =10))

indlist<-c("cfu", "pcr")
outlist<-c("severegi")
rm(list=c("i","j")) 


for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    
    filetemp<-paste(roottemp, outlist[j], indlist[i], ".pdf", sep="")   
    indtemp<-indlist[i]
    outtemp<-outlist[j]
    forplotgrid1(dat=comresultseveregi, indicator=indtemp, outcome=outtemp, save=TRUE, savename=filetemp, savesize=1.1, print=FALSE)
  }
}



comresultsrash<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.rds")
ticks<-c(seq(.2, .8, by =.2), seq(1, 3.8, by=.5), seq(4, 9.5, by=1), seq(10, 100, by =10))

indlist<-c("cfu", "pcr")
outlist<-c("rash")
rm(list=c("i","j")) 


for(i in 1:length(indlist)) {
  for(j in 1:length(outlist)) {
    
    filetemp<-paste(roottemp, outlist[j], indlist[i], ".pdf", sep="")   
    indtemp<-indlist[i]
    outtemp<-outlist[j]
    forplotgrid1(dat=comresultsrash, indicator=indtemp, outcome=outtemp, save=TRUE, savename=filetemp, savesize=1.1, print=FALSE)
  }
}


