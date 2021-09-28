set more off
capture log close
capture clear




use "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta", clear

log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\desctables.log", replace

gen risknotrop=cond(risk==1 & beachg!=1, 1, 0)
gen neearall=cond(!inlist(beachg, 1, 3, 9, 8), 1, 0)
gen notropical=cond(beachg!=1, 1, 0)
gen neearps=cond(!inlist(beachg, 1, 3, 9, 8, 11), 1, 0)
gen neearcore=cond(!inlist(beachg, 1, 2, 3, 9, 8, 11), 1, 0)

* all sites

count
count if age<=12
count if age<=10
count if age<=8
count if age<=6
count if age<=4
tab anycontact
tab bodycontact
tab swallwater 
tab water60
tab water45
tab water30
tab hcgi
tab diarrhea
tab severegi
tab hcresp
tab rash

* risk

count if risk==1
count if age<=12 &  risk==1
count if age<=10 &  risk==1
count if age<=8 &  risk==1
count if age<=6 &  risk==1
count if age<=4 &  risk==1
tab anycontact if  risk==1
tab bodycontact if  risk==1
tab swallwater if  risk==1
tab water60 if  risk==1
tab water45 if  risk==1
tab water30 if  risk==1
tab hcgi if  risk==1
tab diarrhea if  risk==1
tab severegi if  risk==1
tab hcresp if  risk==1
tab rash if  risk==1


* risk no trop

count if risknotrop==1
count if age<=12 &  risknotrop==1
count if age<=10 &  risknotrop==1
count if age<=8 &  risknotrop==1
count if age<=6 &  risknotrop==1
count if age<=4 &  risknotrop==1
tab anycontact if  risknotrop==1
tab bodycontact if  risknotrop==1
tab swallwater if  risknotrop==1
tab water60 if  risknotrop==1
tab water45 if  risknotrop==1
tab water30 if  risknotrop==1
tab hcgi if  risknotrop==1
tab diarrhea if risknotrop==1
tab severegi if  risknotrop==1
tab hcresp if  risknotrop==1
tab rash if  risknotrop==1



* neear all

count if neearall==1
count if age<=12 &  neearall==1
count if age<=10 &  neearall==1
count if age<=8 &  neearall==1
count if age<=6 &  neearall==1
count if age<=4 &  neearall==1
tab anycontact if  neearall==1
tab bodycontact if  neearall==1
tab swallwater if  neearall==1
tab water60 if  neearall==1
tab water45 if  neearall==1
tab water30 if  neearall==1
tab hcgi if  neearall==1
tab diarrhea if neearall==1
tab severegi if  neearall==1
tab hcresp if  neearall==1
tab rash if  neearall==1



* neear point source

count if neearps==1
count if age<=12 &  neearps==1
count if age<=10 &  neearps==1
count if age<=8 &  neearps==1
count if age<=6 &  neearps==1
count if age<=4 &  neearps==1
tab anycontact if  neearps==1
tab bodycontact if  neearps==1
tab swallwater if  neearps==1
tab water60 if  neearps==1
tab water45 if  neearps==1
tab water30 if  neearps==1
tab hcgi if  neearps==1
tab diarrhea if neearps==1
tab severegi if  neearps==1
tab hcresp if  neearps==1
tab rash if  neearps==1


* neear core

count if neearcore==1
count if age<=12 &  neearcore==1
count if age<=10 &  neearcore==1
count if age<=8 &  neearcore==1
count if age<=6 &  neearcore==1
count if age<=4 &  neearcore==1
tab anycontact if  neearcore==1
tab bodycontact if  neearcore==1
tab swallwater if  neearcore==1
tab water60 if  neearcore==1
tab water45 if  neearcore==1
tab water30 if  neearcore==1
tab hcgi if  neearcore==1
tab diarrhea if neearcore==1
tab severegi if  neearcore==1
tab hcresp if  neearcore==1
tab rash if  neearcore==1

log close



/*
count if risk==1 & beachg!=1
count if  inlist(beachg, 1, 3, 9, 8)
count if  !inlist(beachg, 1, 3, 9, 8)

tab neearps
tab neearcore
tab allsites if age<=10
tab age<=10
count if age<=10
count if age<=6
count if age<=4
tab anycontact
tab bodycontact
count if age<=10 & risk==1
count if age<=6 & risk==1
count if age<=4 & risk==1
count if anycontact==1 & risk==1
*/
