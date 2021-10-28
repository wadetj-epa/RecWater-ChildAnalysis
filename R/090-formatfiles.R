library(readxl)
#add in results for adults
#add in nonhuman results 
#add alternate age groups
sink(file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresults.log")

ages<-c("allages", "age10", "age12", "age8", "age6", "age4", "age13up", "age18up", "age410", "age412", "age610", "age612")
sites<-c("allsites", "risk", "risknotropical", "notropical", "neearall", "neearcore", "neearps", "nonhuman")
inds<-c("cfu", "pcr")
comresults<-NULL

#gi
rootdir<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results"
for(i in 1:length(ages)){
  for(j in 1:length(sites)) {
      for(k in 1:length(inds)) {
        fname<-paste("gi", ages[i], sites[j], inds[k], ".xlsx", sep="")
        #print(fname)
        workfile<-paste(rootdir, ages[i], sites[j], inds[k], fname, sep="/")
        for(m in 1:30){
        
          xtemp<-read_excel(workfile, sheet=m)
          otemp<-xtemp[1,]
          otemp$age<-ages[i]
          otemp$site<-sites[j]
          otemp$ind<-inds[k]
          comresults<-rbind.data.frame(comresults, otemp)
      }
        
    }
  }
}

write.csv(comresults, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsgi.csv")

#resp
comresults<-NULL
rootdir<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results"
for(i in 1:length(ages)){
  for(j in 1:length(sites)) {
    for(k in 1:length(inds)) {
      fname<-paste("resp", ages[i], sites[j], inds[k], ".xlsx", sep="")
      #print(fname)
      workfile<-paste(rootdir, ages[i], sites[j], inds[k], fname, sep="/")
      for(m in 1:24){
        
        xtemp<-read_excel(workfile, sheet=m)
        otemp<-xtemp[1,]
        otemp$age<-ages[i]
        otemp$site<-sites[j]
        otemp$ind<-inds[k]
        comresults<-rbind.data.frame(comresults, otemp)
      }
      
    }
  }
}

write.csv(comresults, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsresp.csv")


#severegi
comresults<-NULL
rootdir<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results"
for(i in 1:length(ages)){
  for(j in 1:length(sites)) {
    for(k in 1:length(inds)) {
      fname<-paste("severegi", ages[i], sites[j], inds[k], ".xlsx", sep="")
      #print(fname)
      workfile<-paste(rootdir, ages[i], sites[j], inds[k], fname, sep="/")
      for(m in 1:6){
        
        xtemp<-read_excel(workfile, sheet=m)
        otemp<-xtemp[1,]
        otemp$age<-ages[i]
        otemp$site<-sites[j]
        otemp$ind<-inds[k]
        comresults<-rbind.data.frame(comresults, otemp)
      }
      
    }
  }
}

write.csv(comresults, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultseveregi.csv")

#rash
comresults<-NULL
rootdir<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results"
for(i in 1:length(ages)){
  for(j in 1:length(sites)) {
    for(k in 1:length(inds)) {
      fname<-paste("rash", ages[i], sites[j], inds[k], ".xlsx", sep="")
      #print(fname)
      workfile<-paste(rootdir, ages[i], sites[j], inds[k], fname, sep="/")
      for(m in 1:6){
        
        xtemp<-read_excel(workfile, sheet=m)
        otemp<-xtemp[1,]
        otemp$age<-ages[i]
        otemp$site<-sites[j]
        otemp$ind<-inds[k]
        comresults<-rbind.data.frame(comresults, otemp)
      }
      
    }
  }
}

write.csv(comresults, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultsrash.csv")

sink()


#cuts- not enough for analysis
# comresults<-NULL
# rootdir<-"C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results"
# for(i in 1:length(ages)){
#   for(j in 1:length(sites)) {
#     for(k in 1:length(inds)) {
#       fname<-paste("cut", ages[i], sites[j], inds[k], ".xlsx", sep="")
#       #print(fname)
#       workfile<-paste(rootdir, ages[i], sites[j], inds[k], fname, sep="/")
#       for(m in 1:6){
#         
#         xtemp<-read_excel(workfile, sheet=m)
#         otemp<-xtemp[1,]
#         otemp$age<-ages[i]
#         otemp$site<-sites[j]
#         otemp$ind<-inds[k]
#         comresults<-rbind.data.frame(comresults, otemp)
#       }
#       
#     }
#   }
# }
# 
# write.csv(comresults, file="C:/Users/twade/OneDrive - Environmental Protection Agency (EPA)/Rec_Water/ChildAnalysis/Results/comresultcut.csv")



