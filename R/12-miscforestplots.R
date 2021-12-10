#miscellaneous forest plots
#corrected label for 18 and over and 13 and over
# add plots comparing non human site
# drop age4- now all ages included in main comresults files
#add eps files

rm(list=ls())
library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)



comresultsresp<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.rds")
comresultsresp<-dplyr::filter(comresultsresp, exposure!='45 minutes')

comresults<-readRDS("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.rds")
comresults<-dplyr::filter(comresults, exposure!='45 minutes')



site.labs=c('allsites'="All sites", 'neearall'="All NEEAR", 'neearcore'="Core NEEAR",
            'neearps'="NEEAR Point source", 'risknotropical'="Human source\n(no tropical)", 'risk'="Human source", 'notropical'="All sites\n(no tropical)", 'nonhuman'="Non-human source")
age.labs=c('age4'="4 and under", 'age6'="6 and under", 'age8'="8 and under", 'age10'="10 and under", 'age12'="12 and under", 'age13up'="13 and over", 'age18up'="18 and over", allages="All ages")

out.labs=c('diarrhea'="Diarrhea", 'hcgi'="NEEAR-GI", 'stomach'="Stomachache", 'vomiting'="Vomiting", 'nausea'="Nausea")


ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))

#ticks<-c(seq(.2, .8, by =.2), seq(1, 7, by=2),  seq(10, 100, by =10))

comresultsresp %>%
  filter(ind=="pcr", Outcome=="hcresp", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', 'orange', "grey", "blue", "darkgreen"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
   geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/respage4.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/respage4.eps", device="eps",width=11, height=7.25, units="in")


comresultsresp %>%
  filter(ind=="cfu", Outcome=="cough", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', 'orange', "grey", "blue", "darkgreen"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/coughage4cfu.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/coughage4cfu.eps", device="eps", width=1, height=7.25, unit="in")

  
comresultsresp %>%
  filter(ind=="pcr", Outcome=="hcresp", site=="neearcore"|site=="risknotropical"|site=="allsites", age=="age4"|age=="age6"|age=="age10"|age=="age18up", exposure=="60 minutes") %>%
  ggplot(aes(x = age, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=age), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15)) +
  scale_color_manual(values=c('red', 'orange', "blue", "grey"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x")+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Age"))



#age and site
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical" & site!="nonhuman") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"),
                     labels=c(site.labs))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbody.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbody.eps", width=11, height=7.25, device="eps", unit="in")



#age and site- with non-human
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
                    labels=c(site.labs))+
  #scale_color_brewer(palette="Set1",labels=c(site.labs))+
                     
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbody-nonhuman.pdf", scale=1.1, width=12, height=8)



#age and site- with non-human- alt color
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
  #  labels=c(site.labs))+
  scale_color_brewer(palette="Set1",labels=c(site.labs))+
  
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset1.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset1.eps", device="eps", width=11, height=7.25, unit="in")


#age and site- with non-human- alt color
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
  #  labels=c(site.labs))+
  scale_color_brewer(palette="Dark2",labels=c(site.labs))+
  
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumandark2.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumandark2.eps", width=11, height=7.5, device="eps", unit="in")



#age and site- with non-human- alt color
comresults%>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
  #  labels=c(site.labs))+
  scale_color_brewer(palette="Set2",labels=c(site.labs))+
  
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset2.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset2.pdf", width=11, height=7.5, device="eps", unit="in")




#age and site- with non-human- alt color
comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age6"|age=="age10"|age=="age8"|age=="age18up"|age=="age13up", exposure=="Body immersion", site!="notropical") %>%
  ggplot(aes(x = site, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=site), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  #scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black", "lightgreen"),
  #  labels=c(site.labs))+
  scale_color_brewer(palette="Set1",labels=c(site.labs))+
  
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_grey()+
  facet_grid(.~age, switch = "x", labeller=labeller(age=age.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Site"))

ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset1grey.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrbodynonhumanset1grey.eps", width=11, height=7.5, device="eps", unit="in")





# site and exposure

comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age12") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage12.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage12.eps", device="eps",  width=11, height=7.5, unit="in")



comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age8") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage8.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage8.eps", width=11, height=7.5, device="eps", unit="in")



comresults %>%
  filter(ind=="pcr", Outcome=="diarrhea", age=="age10") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage10.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheapcrage10.eps", width=11, height=7.5, device="eps", unit="in")


ticks<-c(seq(.1, 1.9, by =.1), seq(2, 3.8, by=.2), seq(4, 9.5, by=0.5), seq(10, 100, by =10))



# site and exposure
#need to add labels for other sites
comresults %>%
  filter(ind=="cfu", Outcome=="diarrhea", age=="age12") %>%
  ggplot(aes(x = exposure, y = Coef, ymin=Lower, ymax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=exposure), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey", "darkgreen", "black"))+
  scale_y_log10(breaks=ticks, labels = ticks) +
  geom_hline(yintercept = 1.0, linetype = "dotted", size = 1) +
  labs(x = "", y = "Odds Ratio") +
  theme_bw()+
  facet_grid(.~site, switch = "x", labeller=labeller(site=site.labs))+
  theme(axis.text.x=element_blank(), axis.ticks = element_blank(), axis.text.y=element_text(angle=45, hjust=1))+
  guides(color=guide_legend("Exposure"))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheacfuage12.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/diarrheacfuage12.eps",  width=11, height=7.5, device="eps", unit="in")


ticks<-c(seq(.2, .8, by =.2), seq(1, 3.8, by=.5), seq(4, 9.5, by=1), seq(10, 100, by =10))


#grid plot comparing gi definitions
#swallwater 60 minutes
comresults %>%
  filter(ind=="pcr", Outcome=="hcgi"|Outcome=="diarrhea"|Outcome=="vomiting"|Outcome=="stomach", site=="neearcore"|site=="risknotropical", age=="age10"|age=="age6"|age=="allages"|age=="age8", exposure=="60 minutes") %>%
  ggplot(aes( x = Coef, y = Outcome, xmin=Lower, xmax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=Outcome), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey"), labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  #scale_fill_discrete(name="Test", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_x_log10(breaks=ticks, labels = ticks) +
  geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
  labs(y = "", x = "Odds Ratio") +
  theme_bw()+
  facet_grid(age~site, switch = "y", labeller=labeller(site=site.labs, age=age.labs))+
  theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
  guides(color=guide_legend(reverse=TRUE))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60pcr.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60pcr.eps", device="eps", unit="in", width=11, height=7.5)



comresults %>%
  filter(ind=="cfu", Outcome=="hcgi"|Outcome=="diarrhea"|Outcome=="vomiting"|Outcome=="stomach", site=="neearcore"|site=="risknotropical", age=="age10"|age=="age6"|age=="allages"|age=="age8", exposure=="60 minutes") %>%
  ggplot(aes( x = Coef, y = Outcome, xmin=Lower, xmax=Upper)) +
  geom_errorbar()+
  geom_point(aes(color=Outcome), size=4)+
  #scale_shape_manual(values=c(15,15,15, 15, 15)) +
  scale_color_manual(values=c('red', "orange", "blue", "grey"), labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  #scale_fill_discrete(name="Test", labels=c("Diarrhea", "NEEAR-GI", "Stomachache", "Vomiting"))+
  scale_x_log10(breaks=ticks, labels = ticks) +
  geom_vline(xintercept = 1.0, linetype = "dotted", size = 1) +
  labs(y = "", x = "Odds Ratio") +
  theme_bw()+
  facet_grid(age~site, switch = "y", labeller=labeller(site=site.labs, age=age.labs))+
  theme(axis.text.y=element_blank(), axis.ticks = element_blank(), axis.text.x=element_text(angle=45, hjust=1))+
  guides(color=guide_legend(reverse=TRUE))
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60cfu.pdf", scale=1.1, width=12, height=8)
ggsave("C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/forestplots/misc/giwater60cfu.eps",  width=11, height=7.5, unit="in", device="eps")



