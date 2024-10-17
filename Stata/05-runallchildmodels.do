
*edit varlist and log files as needed
*run for new age groups- 610, 612,  410  and 412
*rerun for new age groups/non human

do "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\RecWater-ChildAnalysis\Stata\03-allchildmodels.do"

capture log close
set more off
*log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\runchildmodels.log", replace
log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\runchildmodels1026.log", replace

*run all child models
*full illlist
*local illlist gi resp rash severegi cut  
local illlist gi resp rash severegi
*full siteliste
*local sitelist allsites risk risknotropical notropical  neearall  neearcore  neearps nonhuman
local sitelist nonhuman
*full age list
*local agelist allages age10 age12 age8 age6  age4 age13up age18up age610 age612 age410 age412
local agelist age610 age612 age410 age412
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
	


