*re-run for adults
*edit to comment out partial runs

do "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\allchildmodels.do"

capture log close
set more off
log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\runchildmodels.log", replace

*run all child models
local illlist gi resp rash cut  severegi
*local illlist cut
*local illlist severegi
local sitelist allsites risk risknotropical notropical  neearall  neearcore  neearps
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
	


