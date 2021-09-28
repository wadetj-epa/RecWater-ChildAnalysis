
*GM-470/300; STV-2000/1280 
*probably need to account for missing watertime, very few observations but need to re run all models



capture clear
capture log close 
set more off

cd "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water"

*read in 13 beach dat and recreate hcgi and hcresp variable

*merge some rain information in for NEEAR beaches only
use "L:\Lab\NHEERL_TWade\Tim\Rec_water\EPA_studies\data\healthenteroqpcr.dta" , clear

qui bysort beach intdate: keep if _n==1

keep beach intdate meanairtemp meanbathers rain8


gen beachg=2 if beach=="BB"
replace beachg=4 if beach=="EB"
replace beachg=5 if beach=="FB"
replace beachg=6 if beach=="GB"
replace beachg=7 if beach=="HB"
replace beachg=11 if beach=="MB"
replace beachg=10 if beach=="SB"
replace beachg=13 if beach=="WB"
replace beachg=12 if beach=="WP"
drop if missing(beach)
rename beach beach2


tempfile ancil
save `ancil', replace




*read in  human marker data


use "L:\Lab\NHEERL_TWade\Tim\Rec_water\EPA_studies\data\water_quality\humanmarkers.dta"
gen beachg=2 if beach=="BB"
replace beachg=4 if beach=="EB"
replace beachg=5 if beach=="FB"
replace beachg=6 if beach=="GB"
replace beachg=7 if beach=="HB"
replace beachg=11 if beach=="MB"
replace beachg=10 if beach=="SB"
replace beachg=13 if beach=="WB"
replace beachg=12 if beach=="WP"
drop if missing(beach)
rename beach beach2
tempfile waterq
save `waterq'
clear

use "L:\Lab\Nheerl_HSF_Beaches\13Beaches\Download31418\13beaches-epi.dta"

gen byte hcgi = (diarrhea==1) | (vomiting==1) | (nausea==1 & stomach==1) | (nausea==1 & stopdaily_gas==1) | (stomach==1 & stopdaily_gas==1)
replace hcgi=. if missing(diarrhea) & missing(vomiting) & missing(nausea) & missing(stomach)

egen byte hcresp= rowtotal(cold cough sorethroat runnynose fever), missing
recode  hcresp 2/max=1 1=0

gen coldate=intdate

*egen berm2=mean(berm), by(beach beachcode coldate)
*collapse (mean) berm groundwater , by(beach beachcode coldate)


/*We classified study days by whether human fecal contamination
was likely to be present (“human-impacted conditions”). At Fairhope and Goddard beaches,
 we considered all study days to be human-impacted because of the presence of nearby wastewater treatment facilities
 and discharges.55 At Doheny Beach, during the spring and summer, a sand berm forms that blocks the flow of San Juan Creek into the surf zone
 We classified days when the berm was open as human-impacted.50 At Avalon Beach, wastewater from a faulty 
 sanitary sewer system discharges in submarine groundwater through the sand and is moderated by tidal conditions.8 
 We classified days when groundwater flow was above the median as human-impacted and those when it was below median flow as not human-impacted.
 We classified all days at Malibu and Mission Bay beaches as not human-impacted because there were no known sources of fecal discharge at those sites. 
 See eAppendix 1 (http://links.lww.com/EDE/B203) for more additional information on our beach conditions classification.*/

 *need to consider surfide beach and boqueron beach
 
gen risk=1
replace risk = 0 if berm==0 
replace risk = 0 if groundwater==0
replace risk = 0 if beach=="Mission Bay" 
replace risk = 0 if beach=="Malibu" 
replace risk = 0 if beach=="Surfside"

label define riskl 1 "High" 0 "Low"
label values risk riskl

merge m:1 beach beachcode coldate using "L:\Lab\Nheerl_HSF_Beaches\13Beaches\Download31418\13beaches-wq.dta"

tabulate _merge
keep if _merge==3
drop _merge

encode beach, gen(beachg)

merge m:1 beachg intdate using `waterq'

tab _merge
drop _merge


gen racecat=race
recode racecat 1=1 2/max=0
replace racecat=. if race==9 
replace racecat=. if missing(race)


*confirm beaches were correctly assigned
tabulate beach beach2


drop beach2
drop if missing(beach)

*merge ancillary data for NEEAR

merge m:1 beachg intdate using `ancil'

tab _merge 
drop _merge
drop beach2

*merge formatted weather data

merge m:1 beachg intdate using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\weather.dta"
tab _merge
drop _merge


*define severe gi
* hospitalization, er or doctor contact, or symptoms lasting three or more days

gen severe=cond(diarrheadays>3 & !missing(diarrheadays)  | vomitingdays>3 & !missing(vomitingdays)  | nauseadays>3 & !missing(nauseadays)| stomachdays>3 & !missing(stomachdays), 1, 0)
replace severe=. if missing(diarrheadays) & missing(vomitingdays) & missing(nauseadays) & missing(stomachdays)

gen doctor=cond(hospitalized_gas==1 | emergencyroom_gas==1 | visitdoc_gas==1, 1, 0)
replace doctor=. if missing(hospitalized_gas) & missing(emergencyroom_gas) & missing(visitdoc_gas)

gen severegi=0
replace severegi=1 if hcgi==1 & severe==1
replace severegi=1 if diarrhea==1 & severe==1
replace severegi=1 if vomiting==1 & severe==1
replace severegi=1 if stomach==1 & severe==1
replace severegi=. if missing(hcgi)

* severity info not collected at mission bay
replace severegi=. if beachg==9


replace venfest=0 if missing(venfest)

*add swimming exposures based on water time


gen water30=watertime>30
replace water30=0 if anycontact==0

gen water45=watertime>45
replace water45=0 if anycontact==0

gen water60=watertime>60
replace water60=0 if anycontact==0


save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta", replace
export delimited  using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.txt", nolabel replace




/*

*as with other analysis, drop venfest
drop if venfest==1

gen exp= avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


selectaic logistic if gibase~=1 & vomitbase~=1 & risk==1 & age<=10, outcome(diarrhea) exposure(exp) covar(i.beachg i.rawfood  dig  anim_any i.racecat i.sex stdtemp precip age algae ) keepvar(swimtemp) stat(AIC)
selectaic logistic if gibase~=1 & vomitbase~=1 & risk==1 & age<=10 & swallwater==1 & beachg~=2 & venfest~=1, outcome(diarrhea) exposure(avgdyenteropcr)  covar( i.rawfood  dig  anim_any i.racecat i.sex stdtemp precip age algae ) keepvar(i.beachg) stat(AIC)



selectaic logistic if gibase~=1 & vomitbase~=1, outcome(diarrhea) exposure(exp) covar(i.beachg i.gicontact_any i.rawmeat_any miles bsand swam anim_any i.racecat i.sex) keepvar(swimtemp) stat(AIC)
selectaic logistic if gibase~=1 & vomitbase~=1 & age<=10, outcome(diarrhea) exposure(exp) covar(i.beachg i.gicontact_any i.rawmeat_any miles bsand swam anim_any i.racecat i.sex) keepvar(swimtemp) stat(AIC)
selectaic logistic if gibase~=1 & vomitbase~=1, outcome(hcgi) exposure(exp) covar(i.beachg i.gicontact_any i.rawmeat_any miles bsand swam anim_any i.racecat i.sex) keepvar(swimtemp) stat(AIC)

/*
gen risk=.
replace risk = 1 if berm==1 | groundwater==1
replace risk = 1 if beach=="Fairhope" | beach=="Goddard" 
replace risk = 0 if berm== 0 | groundwater==0
replace risk = 0 if beach=="Mission Bay" 
replace risk = 0 if beach=="Malibu" 

label define riskl 1 "High" 0 "Low"
label values risk riskl
*/

*these produce the same results

/*
gen exp= avgdyenteropcr
replace exp=0 if anycontact==0

logistic diarrhea  c.avgdyenteropcr#1.anycontact i.anycontact if risk==1
margins r.anycontact, at(avgdyenteropcr=(-1(0.2)4.2)) predict(xb)
logit diarrhea i.anycontact exp if risk==1
lincom 1.anycontact+0.1*exp
lincom 1.anycontact+2*exp

logistic diarrhea i.beachg age c.avgdyenteropcr#1.anycontact i.anycontact if risk==1
margins r.anycontact, at(avgdyenteropcr=(0 1 2 3)) predict(xb)
logit diarrhea i.anycontact i.beachg age exp if risk==1
lincom 1.anycontact+0*exp
lincom 1.anycontact+1*exp
lincom 1.anycontact+2*exp
lincom 1.anycontact+3*exp

*does not produce identical results- close but not identical 
logistic diarrhea i.beachg age c.avgdyenteropcr#i.anycontact i.anycontact if risk==1
margins r.anycontact, at(avgdyenteropcr=(0 1 2 3)) predict(xb)
logit diarrhea i.anycontact i.beachg age exp if risk==1
lincom 1.anycontact+0*exp
lincom 1.anycontact+1*exp
lincom 1.anycontact+2*exp
lincom 1.anycontact+3*exp

*produce same results for slope
logit diarrhea  c.avgdyenteropcr#1.anycontact c.avgdyenteropcr#1.swallwater i.anycontact i.swallwater if risk==1 & age<=10
lincom 1.swallwater#c.avgdyenteropcr + 1.anycontact#c.avgdyenteropcr
logit diarrhea  c.avgdyenteropcr if risk==1 & age<=10 & swallwater==1
lincom 1.swallwater#c.avgdyenteropcr + 1.anycontact#c.avgdyenteropcr + 1.anycontact + 1.swallwater

gen exp= avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1

list beach coldate if _merge==1
list beach coldate intdate if _merge==1
logistic diarrhea avgdyenteropcr if anycontact==1
logistic diarrhea avgdyentero1600 if anycontact==1
logistic hcgi avgdyenteropcr if anycontact==1
logistic hcresp avgdyenteropcr if anycontact==1
logistic hcgi avgdyenteropcr i.beachcode if anycontact==1
encode beachcode: gen(beachcodeg)
encode beachcode, gen(beachcodeg)
logistic hcgi avgdyenteropcr i.beachcodeg if anycontact==1
encode beach, gen(beachg)
logistic hcgi avgdyenteropcr i.beachg if anycontact==1
logistic diarrhea avgdyenteropcr i.beachg if anycontact==1
logistic diarrhea avgdyenteropcr i.beachg if bodycontact==1
logistic diarrhea avgdyenteropcr i.beachg if swallwater==1
logistic diarrhea avgdyenteropcr i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
gen agecat=age<=10
tab agecat
recode agecat=. if missing(age)
replace agecat=. if missing(age)
logistic diarrhea avgdyenteropcr##i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
tab agecat
logistic diarrhea i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
logistic diarrhea avgdyenteropcr#i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
logistic diarrhea c.avgdyenteropcr##i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
logistic hcgi c.avgdyenteropcr##i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
logistic diarrhea c.avgdyenteropcr##i.agecat i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
gen agecat5=age<=5
replace agecat5=. if missing(age)
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg if swallwater==1 & (gibase~=1 & vomitbase~=1)
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg if bodycontact==1 & (gibase~=1 & vomitbase~=1)
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg if bodycontact==1
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg i.gicontact_base if swallwater==1
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg i.gicontact_base i.venfest if swallwater==1
logistic diarrhea c.avgdyenteropcr##i.agecat5 i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyentero1600##i.agecat5 i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyentero1600##i.agecat10 i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyentero1600##i.agecat i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic hcresp c.avgdyentero1600##i.agecat i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyfmc1601##i.agecat i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyfpc1601##i.agecat i.beachg i.gicontact_base  if swallwater==1 & (venfest==0 | missing(venfest))
logistic diarrhea c.avgdyenteropcr##c.age i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<=10
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<=5
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<=3
logistic hcgi c.avgdyenteropcr i.beachg if swallwater==1 & age<=3
logistic hcgi c.avgdyenteropcr i.beachg if swallwater==1 & age<=10
logistic hcgi c.avgdyenteropcr i.beachg if swallwater==1 & age<=5
logistic hcgi c.avgdyenteropcr i.beachg if swallwater==1
logistic hcgi c.avgdyenteropcr i.beachg if bodycontact==1
logistic hcgi c.avgdyenteropcr i.beachg if bodycontact==1 & age<=10
logistic hcgi c.avgdyenteropcr i.beachg if bodycontact==1 & age<=5
help aic
help selectAIC
selectaic logistic hcgi c.avgdyenteropcr i.beachg if bodycontact==1 & age<=5
selectaic logistic hcgi avgdyenteropcr i.beachg if bodycontact==1 & age<=5
selectaic logistic hcgi avgdyenteropcr beachg if bodycontact==1 & age<=5
selectaic logistic, outcome(hcgi) exposure(c.avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(c.avgdyenteropcr) if bodycontact==1 & age<=5
selectaic logistic, outcome(hcgi) exposure(c.avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(c.avgdyenteropcr) stat(AIC) if bodycontact==1 & age<=5
selectaic logistic  if bodycontact==1 & age<=5, outcome(hcgi) exposure(c.avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(c.avgdyenteropcr) stat(AIC)
selectaic logistic  if bodycontact==1 & age<=5, outcome(hcgi) exposure(avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(c.avgdyenteropcr) stat(AIC)
selectaic logistic  if bodycontact==1 & age<=5, outcome(hcgi) exposure(avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(avgdyenteropcr) stat(AIC)
selectaic logistic  if bodycontact==1 & age<=5, outcome(hcgi) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(avgdyenteropcr) stat(AIC)
nmissing(miles)
nmissing miles
help nmissing
nmissing
help nmissing
help missing
table gicontact_base, mi
table gibase, mi
table rawmeatbase, mi
table rawmeat_base, mi
table basnd, mi
selectaic logistic  if bodycontact==1 & age<=10, outcome(hcgi) exposure(avgdyenteropcr i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(avgdyenteropcr) stat(AIC)
selectaic logistic  if bodycontact==1 & age<=10, outcome(hcgi) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(avgdyenteropcr) stat(AIC)
selectaic logistic  if bodycontact==1 & age<=10, outcome(hcgi) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand)  stat(AIC)
selectaic logistic  if swallwater==1 & age<=10, outcome(hcgi) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand)  stat(AIC)
selectaic logistic  if swallwater==1 & age<=10, outcome(diarrhea) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand)  stat(AIC)
selectaic logistic  if swallwater==1 & age<=10, outcome(diarrhea) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(i.beachg) stat(AIC)
selectaic logistic  if swallwater==1, outcome(diarrhea) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(i.beachg) stat(AIC)
marginsplot aavgdyenteropcr
help marginsplot
summ avgdyenteropcr
summ avgdyenteropcr, detail
margins avgdyenteropcr, at(-1(1)4)
?margins
help margins
margins, at(avgdyenteropcr=-1(0.2)4.2))
margins, at(avgdyenteropcr=(-1(0.2)4.2))
marginsplot
tabulate diarrhea if anycontact==1
di 10^4.2
selectaic logistic  if swallwater==1 & age<=10, outcome(diarrhea) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand) keepvar(i.beachg) stat(AIC)
margins, at(avgdyenteropcr=(-1(0.2)4.2))
margins, at(avgdyenteropcr=1)
margins, at(avgdyenteropcr=-1)
estimates replay
selectaic logistic  if swallwater==1 & age<=10, outcome(diarrhea) exposure(avgdyenteropcr) covar(i.beachg i.gibase i.vomitbase i.gicontact_base i.rawmeat_base miles bsand)  stat(AIC)
margins, at(avgdyenteropcr=-1)
margins, at(avgdyenteropcr=(-1(0.2)4.2))
marginsplot
help marginsplot
logistic c.avgdyenteropcr##i.agecat i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr##i.agecat i.beachg if swallwater==1
margins agecat, at(avgdyenteropcr=(-1(0.2)4.2))
marginsplot, recast(line) recastci(rarea)
marginsplot, recast(line)
marginsplot, noci
marginsplot, noci recast(line)
help grcombine
help graphcombine
help graph combine
help margins
help margins
margins agecat, at(avgdyenteropcr=(-1(0.2)4.2)) generate(test)
list test1
list test1-test10
drop test*
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<=10
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr##i.agecat i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<10
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age>=10
logistic diarrhea avgdyenteropcr i.beachg if swallwater==1
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age<=10
margins, at(avgdyenteropcr=(-1(0.2)4.2)) post
est store test
est table test
logistic diarrhea c.avgdyenteropcr i.beachg if swallwater==1 & age>10
margins, at(avgdyenteropcr=(-1(0.2)4.2)) post
est store test2
est table test test2
di .0409674 +(1.96*.0064671)
estimates replay test
help estimates store
est table test test2, se
est table test test2,  b(%7.4f) se(%7.4f)
est table test test2,  b(%7.4f) se(%7.4f) style(columns)
est table test test2,  b(%7.4f) se(%7.4f) vsquish

* compare different ways to deal with non swimmers
* observed probability of diarrhea in non-swimming children age <=10 and risk==1 beaches is 4.8%
* issue is that some beaches have entero <0 on log scale
/* three methods:
		1) assign non-swimmers 0 as usual (some swimmers will have lower entero)
		2) assign non-swimmers -1 (lowest value of swimmers)
		3) substitute 0.1 for values less than 0, assign non-swimmers 0

	*/
	
	


/*
capture log close
log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\comparetest.log", replace


* assign non swimmers 0
capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1




logit diarrhea i.swimtemp exp i.beachg age if age<=10 & risk==1
estimates store m1

foreach num in 0 1 2 3 4 {
	qui estimates restore m1
	margins, at(swimtemp=(0 1) exp=(-1 `num')) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}
	
*assign non swimmers -1

capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=-1 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp i.beachg age if age<=10 & risk==1
estimates store m2

foreach num in 0 1 2 3 4 {
	qui estimates restore m2
	margins, at(swimtemp=(0 1) exp=(-1 `num')) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}


*replace entero to 0.1 for all swimmers, assign non-swimmers 0
capture drop exp swimtemp

gen exp=avgdyenteropcr
replace exp=0.1 if avgdyenteropcr<0
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp i.beachg age if age<=10 & risk==1
estimates store m3

foreach num in 0 1 2 3 4 {
	qui estimates restore m3
	margins, at(swimtemp=(0 1) exp=(-1 `num')) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}



estimates table m1 m2 m3



*without covars and linear predictor

* assign non swimmers 0
capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1

logit diarrhea i.swimtemp exp if age<=10 & risk==1
estimates store m1u

foreach num in 0 1 2 3 4 {
	qui estimates restore m1
	margins, at(swimtemp=(0 1) exp=(-1 `num')) predict(xb) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}
	
*assign non swimmers -1

capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=-1 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp  if age<=10 & risk==1
estimates store m2u

foreach num in 0 1 2 3 4 {
	qui estimates restore m2u
	margins, at(swimtemp=(0 1) exp=(-1 `num')) predict(xb) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}


*replace entero to 0.1 for all swimmers, assign non-swimmers 0
capture drop exp swimtemp

gen exp=avgdyenteropcr
replace exp=0.1 if avgdyenteropcr<0
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp if age<=10 & risk==1
estimates store m3u

foreach num in 0 1 2 3 4 {
	qui estimates restore m3u
	margins, at(swimtemp=(0 1) exp=(-1 `num')) predict(xb) post coeflegend
	lincom _b[4._at]-_b[1bn._at]
}



estimates table m1u m2u m3u




capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=-1 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp if age<=10 & risk==1
estimates store m2

margins, at(swimtemp=(0 1) exp=(-1 0)) post coeflegend
	lincom _b[4._at]-_b[1bn._at]


capture drop exp swimtemp


gen exp=avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logit diarrhea i.swimtemp exp if age<=10 & risk==1
estimates store m3

margins, at(swimtemp=(0 1) exp=(-1 0)) post coeflegend
	lincom _b[4._at]-_b[1bn._at]

	
set more off	
capture drop exp swimtemp	

gen exp=avgdyenteropcr
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1

logistic diarrhea i.swimtemp exp i.beachg  if  risk==1
est store m1


margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m1.dta, replace)


logistic diarrhea i.swimtemp exp i.beachg  if age<=10 & risk==1
est store m1c
margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m1c.dta, replace)


*replace ent to -1 for non -swimmers
capture drop exp swimtemp

gen exp=avgdyenteropcr
replace exp=-1 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1

logistic diarrhea i.swimtemp exp i.beachg  if  risk==1
est store m2

margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m2.dta, replace)

logistic diarrhea i.swimtemp exp i.beachg  if age<=10 & risk==1
est store m2c
margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m2c.dta, replace)



*replace entero to 0.1 for all swimmers, assign non-swimmers 0
capture drop exp swimtemp

gen exp=avgdyenteropcr
replace exp=0.1 if avgdyenteropcr<0
replace exp=0 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1


logistic diarrhea i.swimtemp exp i.beachg  if  risk==1
est store m3

margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m3.dta, replace)

logistic diarrhea i.swimtemp exp i.beachg  if age<=10 & risk==1
est store m3c
margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m3c.dta, replace)



capture drop exp swimtemp

gen exp=avgdyenteropcr
replace exp=-1 if anycontact==0
replace exp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1

selectaic logistic if  risk==1 &  gibase~=1, outcome(diarrhea) exposure(i.swimtemp exp) covar(gichron dig bsand  rawmeat_any anim_any venfest) keepvar(i.beachg) stat(AIC)
est store m1
margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m1.dta, replace)

selectaic logistic if  risk==1 &  gibase~=1 & age<=10, outcome(diarrhea) exposure(i.swimtemp exp) covar(gichron dig bsand  rawmeat_any anim_any venfest) keepvar(i.beachg) stat(AIC)
est store m1c
margins, at(swimtemp=(0 1) exp=(-1(0.2)4.2)) contrast(atcontrast(r)) saving(m1c.dta, replace)



preserve

use m1.dta, clear
keep if _at1==1
keep _at2 _margin _ci_lb _ci_ub
gen lent=_at2
gen ar=_margin
gen lb= _ci_lb
gen ub= _ci_ub
gen gmean=10^lent

foreach var of varlist ar lb ub {
replace `var'=`var'*1000
}


#delimit ;
twoway line ar lb ub gmean, pstyle(p1 p2 p2) sort clwidth(medthick medthick medthick)
xscale(log) clpattern(solid dash dash) graphregion(fcolor(white)) xlabel(.1 1 10 100 1000, grid)
xmtick(.2 .3 .4 .5 .6 .7 .8 .9  2 3 4 5 6 7 8 9 20 30 40 50 60 70 80 90 200 300 400 500 600 700 800 900 2000 3000 4000 5000, grid) ymtick(##3)
legend(ring(0) pos(11) symxsize(4) forcesize  cols(1) size(small) order(1 2)
lab(1 "Swimming-associated illness") lab(2 "95% Confidence bound")) xtitle("{it: Enterococcus} CCE/100ml" "daily geometric mean", size(small))
ytitle("Swimming-associated GI illness (x 1000)", size(small)) ylabel(#15, angle(45) grid);

#delimit cr

tempfile m1
save `m1'

clear 


use m1c.dta, clear
keep if _at1==1
keep _at2 _margin _ci_lb _ci_ub
gen lent=_at2
gen ar=_margin
gen lb= _ci_lb
gen ub= _ci_ub
gen gmean=10^lent

foreach var of varlist ar lb ub {
replace `var'=`var'*1000
}

#delimit ;
twoway line ar lb ub gmean, pstyle(p1 p2 p2) sort clwidth(medthick medthick medthick)
xscale(log) clpattern(solid dash dash) graphregion(fcolor(white)) xlabel(.1 1 10 100 1000, grid)
xmtick(.2 .3 .4 .5 .6 .7 .8 .9  2 3 4 5 6 7 8 9 20 30 40 50 60 70 80 90 200 300 400 500 600 700 800 900 2000 3000 4000 5000, grid) ymtick(##3)
legend(ring(0) pos(11) symxsize(4) forcesize  cols(1) size(small) order(1 2)
lab(1 "Swimming-associated illness") lab(2 "95% Confidence bound")) xtitle("{it: Enterococcus} CCE/100ml" "daily geometric mean", size(small))
ytitle("Swimming-associated GI illness (x 1000)", size(small)) ylabel(#15, angle(45) grid);

#delimit cr

tempfile m1c
save `m1c'

rename (ar lb ub) =c


drop  _margin _ci_lb _ci_ub _at2 lent

merge 1:1 gmean using `m1'


#delimit ;
twoway line ar arc gmean, sort clwidth(medthick medthick medthick)
xscale(log)  graphregion(fcolor(white)) xlabel(.1 1 10 100 1000, grid)
xmtick(.2 .3 .4 .5 .6 .7 .8 .9  2 3 4 5 6 7 8 9 20 30 40 50 60 70 80 90 200 300 400 500 600 700 800 900 2000 3000 4000 5000, grid) ymtick(##3)
legend(ring(0) pos(11) symxsize(4) forcesize  cols(1) size(small) order(1 2)
lab(1 "All") lab(2 "Children 10 and under")) xtitle("{it: Enterococcus} CCE/100ml" "daily geometric mean", size(small))
ytitle("Swimming-associated GI illness (x 1000)", size(small)) ylabel(#15, angle(45) grid);

#delimit cr

restore



/*

use m1.dta
keep if _at1==1
gen model=1
keep _at2 _margin _ci_lb _ci_ub
gen model=1
tempfile m1
save `m1'
use m2.dta
keep if _at1==1
keep _at2 _margin _ci_lb _ci_ub
gen model=2
tempfil m2
save `m2'
clear
use m3.dta
keep if _at1==1
keep _at2 _margin _ci_lb _ci_ub
gen model=3
tempfil m3
save `m3'
use `m1', clear
append using `m2'
append using `m3'
egen id=group(_at2)
reshape wide _margin _ci_lb _ci_ub _at2, j(model) i(id)
twoway line _margin1 _margin2 _margin3 _at21, sort

*/



/*
gen waterexp=anycontact*avgdyenteropcr
gen swimexp=swallwater*avgdyenteropcr
logistic diarrhea anycontact swallwater waterexp swimexp i.beachg age algae if risk==1
lincom waterexp+swimexp
logistic diarrhea anycontact swallwater waterexp swimexp if risk==1
lincom waterexp+swimexp
logistic diarrhea avgdyenteropc if swallwater==1 & risk==1
logistic diarrhea anycontact swallwater waterexp swimexp if risk==1
lincom anycontact+ waterexp+swimexp
lincom anycontact+ 2*waterexp+2*swimexp
do "C:\Users\twade\AppData\Local\Temp\STD00000000.tmp"
logistic diarrhea exp swallwater if risk==1
lincom swallwater+ 2*waterexp+2*swimexp
lincom swallwater+ 2*exp
drop swimtemp
gen swimtep=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1
gen swimtemp=swallwater
replace swimtemp=. if anycontact==1 & swallwater~=1
logistic diarrhea exp swimtemp if risk==1
lincom swimtemp+ 2*exp
logistic diarrhea anycontact swallwater waterexp swimexp if risk==1
lincom anycontact+ waterexp+swimexp
lincom waterexp+swimexp
lincom anycontact+ swallwater+ 2*waterexp+2*swimexp

*/
