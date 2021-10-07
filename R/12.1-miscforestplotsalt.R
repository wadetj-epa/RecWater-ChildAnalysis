#miscellaneous forest plots
#corrected label for 18 and over and 13 and over
# add plots comparing non human site
# use alternating color scheme


rm(list=ls())
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)



comresultsrespage4<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrespage4.rds")
comresults<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.rds")


comresultsage4<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgiage4.rds")


# comresultsrespage4 %>%
#   filter(ind=="pcr", Outcome=="sorethroat", exposure=="Swallowed water", site!="notropical", age=="age4") 
  

site.labs=c('allsites'="All sites", 'neearall'="All NEEAR", 'neearcore'="Core NEEAR",
            'neearps'="NEEAR Point source", 'risknotropical'="Human source\n(no tropical)", 'risk'="Human source", 'notropical'="All sites\n(no tropical)", 'nonhuman'="Non-human source")
age.labs=c('age4'="4 and under", 'age6'="6 and under", 'age8'="8 and under", 'age10'="10 and under", 'age12'="12 and under", 'age13up'="13 and over", 'age18up'="18 and over", allages="All ages")

out.labs=c('diarrhea'="Diarrhea", 'hcgi'="NEEAR-GI", 'stomach'="Stomachache", 'vomiting'="Vomiting", 'nausea'="Nausea")


ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))

#ticks<-c(seq(.2, .8, by =.2), seq(1, 7, by=2),  seq(10, 100, by =10))

comresultsrespage4 %>%
  filter(ind=="pcr", Outcome=="hcresp", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', 'orange', "grey", "blue", "darkgreen"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
   geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/respage4alt.pdf", scale=1.1, width=12, height=8)


comresultsrespage4 %>%
  filter(ind=="cfu", Outcome=="cough", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', 'orange', "grey", "blue", "darkgreen"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/coughage4cfualt.pdf", scale=1.1, width=12, height=8)

  
comresultsrespage4 %>%
  filter(ind=="pcr", Outcome=="hcresp", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4"|age=="age6"|age=="age10"|age=="age18up", exposure=="60 minutes") %>%
  ggplot(aes(x = age, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=age), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15)) +
  #scale_color_manual(values=c('red', 'orange', "blue", "grey"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x")+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Age"))



#age and site
comresultsage4 %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical" & site!="nonhuman") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"),
   #                  labels=c(site.labs))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodyalt.pdf", scale=1.1, width=12, height=8)



#age and site- with non-human
comresultsage4 %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
   #                 labels=c(site.labs))+
  scale_color_brewer(palette="Set1",labels=c(site.labs))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodyalt-nonhuman.pdf", scale=1.1, width=12, height=8)


# site and exposure

comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age12") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage12alt.pdf", scale=1.1, width=12, height=8)



comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age8") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage8alt.pdf", scale=1.1, width=12, height=8)



comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age10") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_brewer(palette="Set1")+
 #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage10altnonhuman.pdf", scale=1.1, width=12, height=8)


#without nonhuman
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age10", site!="nonhuman") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_brewer(palette="Set1")+
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage10alt.pdf", scale=1.1, width=12, height=8)

ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))



# site and exposure
#need to add labels for other sites
comresults %>%
  filter(ind=="cfu", Outcome=="diarrhea", age=="age12") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_color_brewer(palette="Set1")+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheacfuage12alt.pdf", scale=1.1, width=12, height=8)

ticks<-c(seq(.2, .8, by =.2), seq(1, 3.8, by=.5), seq(4, 9.5, by=1), seq(10, 100, by =10))


#grid plot comparing gi definitions
#swallwater 60 minutes
comresults %>%
  filter(ind=="pcr", Outcome=="hcgi"|Outcome=="diarrhea"|Outcome=="vomiting"|Outcome=="stomach", site=="neearcore"|site=="risknotropical", age=="age10"|age=="age6"|age=="allages"|age=="age8", exposure=="60 minutes") %>%
  ggplot(aes( x = Coef, y = Outcome, xmin=Lower, xmax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=Outcome), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey"), labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  #scale_fill_discrete(name="Test", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_color_brewer(palette="Set1", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_x_log10(breaks=ticks, labels = ticks) +
  geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
  labs(y = "", x = "Odds Ratio") +
  theme_grey()+
  facet_grid(age~site, switch = "y", labeller=labeller(site=site.labs, age=age.labs))+
  theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
  guides(color=guide_legend(reverse=TRUE))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60pcralt.pdf", scale=1.1, width=12, height=8)



comresults %>%
  filter(ind=="cfu", Outcome=="hcgi"|Outcome=="diarrhea"|Outcome=="vomiting"|Outcome=="stomach", site=="neearcore"|site=="risknotropical", age=="age10"|age=="age6"|age=="allages"|age=="age8", exposure=="60 minutes") %>%
  ggplot(aes( x = Coef, y = Outcome, xmin=Lower, xmax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=Outcome), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey"), labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  #scale_fill_discrete(name="Test", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_color_brewer(palette="Set1", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_x_log10(breaks=ticks, labels = ticks) +
  geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
  labs(y = "", x = "Odds Ratio") +
  theme_grey()+
  facet_grid(age~site, switch = "y", labeller=labeller(site=site.labs, age=age.labs))+
  theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
  guides(color=guide_legend(reverse=TRUE))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60cfualt.pdf", scale=1.1, width=12, height=8)


#plots at nonhuman sites
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", site=="nonhuman", exposure=="Any contact"|exposure=="Body immersion"|exposure=="Swallowed water") %>%
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
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrnonhumanalt.pdf", scale=1.1, width=12, height=8)






comresults %>%
  filter(ind=="cfu", Outcome=="diarrhea", site=="nonhuman", exposure=="Any contact"|exposure=="Body immersion"|exposure=="Swallowed water") %>%
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
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheacfunonhumanalt.pdf", scale=1.1, width=12, height=8)




comresults %>%
  filter(ind=="pcr", Outcome=="hcgi", site=="nonhuman", exposure=="Any contact"|exposure=="Body immersion"|exposure=="Swallowed water") %>%
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
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/hcgipcrnonhumanalt.pdf", scale=1.1, width=12, height=8)






comresults %>%
  filter(ind=="cfu", Outcome=="hcgi", site=="nonhuman", exposure=="Any contact"|exposure=="Body immersion"|exposure=="Swallowed water") %>%
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
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/hcgicfunonhumanalt.pdf", scale=1.1, width=12, height=8)

