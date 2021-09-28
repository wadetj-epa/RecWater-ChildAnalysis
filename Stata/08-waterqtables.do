set more off
capture log close
capture clear

use "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta", clear

log using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\waterqtables.log", replace


gen risknotrop=cond(risk==1 & beachg!=1, 1, 0)
gen neearall=cond(!inlist(beachg, 1, 3, 9, 8), 1, 0)
gen notropical=cond(beachg!=1, 1, 0)
gen neearps=cond(!inlist(beachg, 1, 3, 9, 8, 11), 1, 0)
gen neearcore=cond(!inlist(beachg, 1, 2, 3, 9, 8, 11), 1, 0)

qui bysort beachg intdate: keep if _n==1

gen entero1600=10^avgdyentero1600
gen enteroqpcr=10^avgdyenteropcr

summ  entero1600  enteroqpcr, detail
summ  entero1600  enteroqpcr if risk==1, detail
summ  entero1600  enteroqpcr if risknotrop==1, detail
summ  entero1600  enteroqpcr if notropical==1, detail
summ  entero1600  enteroqpcr if neearall==1, detail
summ  entero1600  enteroqpcr if neearps==1, detail
summ  entero1600  enteroqpcr if neearcore==1, detail


log close


