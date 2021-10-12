

*age interaction tests
*select model for full data
*test age group vs ohter groups
*test age group vs over 12 and over 18

*need to re run with venfest dropped!

*corrected outcome macro that was not saved properly



set more off
capture log close
log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\Results\interactiontests\respinteractiontests.log", replace

use "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta", clear

	keep indid hhid rawfood  dig  anim_any racecat sex stdtemp precip age algae venfest beach beachg  anycontact bodycontact swallwater hcgi/*
	*/ diarrhea severegi gibase gicontact_base vomitbase avgdyenteropcr avgdyentero1600 nausea vomiting stomach block repel shade allergy /*
	*/ sorethroat cough runnynose eyeinfection cut rash watertime hcresp sorebase rashbase cutbase eyebase earbase earache wateryeyes cold risk water30 water45 water60

	
gen age4=cond(age<=4, 1, 0)
replace age4=. if missing(age)

gen age6=cond(age<=6, 1, 0)
replace age6=. if missing(age)

gen age8=cond(age<=8, 1, 0)
replace age8=. if missing(age)


gen age10=cond(age<=10, 1, 0)
replace age10=. if missing(age)


gen age12=cond(age<=12, 1, 0)
replace age12=. if missing(age)

gen allsites=1
gen risknotrop=cond(risk==1 & beachg!=1, 1, 0)
gen neearall=cond(!inlist(beachg, 1, 3, 9, 8), 1, 0)
gen notropical=cond(beachg!=1, 1, 0)
gen neearps=cond(!inlist(beachg, 1, 3, 9, 8, 11), 1, 0)
gen neearcore=cond(!inlist(beachg, 1, 2, 3, 9, 8, 11), 1, 0)

*putexcel set "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\Results\interactiontests\giinteractiontests.xlsx", replace
putexcel set "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\Results\interactiontests\respinteractiontests.xlsx", modify

putexcel A1="Site" B1="Swim exposure" C1="Indicator" D1="Outcome" E1="Age" F1="Comparison" G1="OR-Int"   H1="pval-Int"  I1="OR-child" J1="pval-child" K1="OR-adult" L1="pval-adult" M1="model"

drop if venfest==1

*local illvars hcresp sorethroat cough cold
local covars  dig  anim_any racecat sex stdtemp precip age algae gicontact_base allergy repel
keep if sorebase~=1 


set more off

local j=1

foreach site in allsites risknotrop neearall notropical neearps neearcore risk{
	foreach swim in anycontact bodycontact swallwater water30 water45 water60{
		foreach exp in avgdyenteropcr avgdyentero1600 {
			foreach ill in hcresp sorethroat cough cold {
				foreach age in age12 age10 age8 age6 age4 {
					foreach subset in all adults {
				
						local j=`j'+1
						*local j=`count'+1
						selectaic logistic if `site'==1 & `swim'==1, outcome(`ill') exposure(`exp') covar(`covars') keepvar(i.beachg) stat(AIC) options(vce(cluster hhid))
						local vars `r(covarlist)'
						
						if "`subset'"=="all" {
							logistic `ill' i.`age'##c.`exp' `vars' i.beachg if `site'==1 & `swim'==1, vce(cluster hhid)
						}
						if "`subset'"=="adults" {
							logistic `ill' i.`age'##c.`exp' `vars' i.beachg if `site'==1 & `swim'==1 & (`age'==1 | age>=18), vce(cluster hhid)
						}
				
						putexcel A`j'="`site'"
						putexcel B`j'="`swim'"
						putexcel C`j'="`exp'"
						putexcel D`j'="`ill'"
						putexcel E`j'="`age'"
						putexcel F`j'="`subset'"
				
						matrix table = r(table)
						local c=table[1,5]
						local p=table[4,5]
						putexcel G`j'=`c'
						putexcel H`j'=`p'				
						putexcel M`j'="`e(cmdline)'"
						
						lincom 1.`age'#c.`exp' + `exp'
						local est1=r(estimate)
						local z1=log(r(estimate))/(r(se)/r(estimate))
						local p1=2*(1-normal(abs(`z1')))
						
						lincom c.`exp'
						local est2=r(estimate)
						local z2=log(r(estimate))/(r(se)/r(estimate))
						local p2=2*(1-normal(abs(`z2')))
						
						putexcel I`j'=`est1'
						putexcel J`j'=`p1'
						putexcel K`j'=`est2'
						putexcel L`j'=`p2'
						
					
						
					}
				}				
			}	
		}
	}
}
	

	log close
	
	
	
