*re-run for adults
*edit to comment out partial runs
*edit varlist and log files as needed
*run nonhuman just for severegi  (cuts exited with error, did not converge)

do "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\RecWater-ChildAnalysis\Stata\03-allchildmodels.do"

capture log close
set more off
*log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\runchildmodels.log", replace
log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\runchildmodels-test.log", replace

*run all child models
*local illlist gi resp rash severegi cut  
*local illlist cut
local illlist severegi
*local sitelist allsites risk risknotropical notropical  neearall  neearcore  neearps
local sitelist nonhuman
local agelist allages age10 age12 age8 age6  age4 age13up age18up
*local agelist allages age10 age12 age8 age6  age4
*local agelist age13up age18up
local indlist cfu pcr


foreach illtemp in `illlist' {
	foreach sitetemp in  `sitelist' {
		foreach agetemp in `agelist' {
			foreach indtemp in  `indlist' {

allchildmodels, illness(`illtemp') subset(`sitetemp') agegroup(`agetemp') indicator(`indtemp') keep(i.beachg)
				}
			}
		}
	}
	


