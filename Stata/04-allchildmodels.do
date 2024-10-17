*add correct cuts which repeated rash
* add groups for adults 13 and up, 18 and up
* add non-human impacted site group (risk==0)
* add age groups 6-10 and 6-12 4-10 and 4-12

capture program drop allchildmodels
program define allchildmodels
syntax [anything], illness(string) subset(string) agegroup(string) indicator(string) [keep(string)]

*confirm subset, agegroup and indicators are appropriate
if inlist("`illness'", "gi", "rash", "cut", "resp", "severegi")==0 {
	display as err "option illness() invalid"
    exit 198
}

if inlist("`subset'", "allsites", "risk", "risknotropical", "notropical", "neearall", "neearcore", "neearps", "nonhuman")==0 {
	display as err "option subset() invalid"
    exit 198
}

*if inlist("`agegroup'", "allages", "age10", "age12", "age8", "age6", "age4", "age13up", "age18up", "age610")==0 & "`agegroup'"!="age612" {
if regexm("`agegroup'", "(^allages$|^age10$|^age12$|^age8$|^age6$|^age4$|^age13up$|^age18up$|^age610$|^age612$|^age410$|^age412$)")==0 {
	display as err "option agegroup() invalid"
    exit 198
}


if inlist("`indicator'", "cfu", "pcr")==0 {
	display as err "option indicator() invalid"
    exit 198
}


set more off

	/*

	illness= gi, resp, skin
	subset=all, risk, notropical, risknotropical, neearall, neearps, neearcore
	agegroup=all, age12, age10, age8, age6, age4
	indicator=pcr, cfu
	
	
           1   Avalon
           2   Boqueron
           3   Doheny
           4   Edgewater
           5   Fairhope
           6   Goddard
           7   Huntington
           8   Malibu
           9   Mission Bay
          10   Silver
          11   Surfside
          12   Washington Park
          13   West

	
	

	*/
	use "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta", clear

	*add variables for skin rash, respiratory
	keep indid hhid rawfood  dig  anim_any racecat sex stdtemp precip age algae venfest beach beachg  anycontact bodycontact swallwater hcgi/*
	*/ diarrhea severegi gibase gicontact_base vomitbase avgdyenteropcr avgdyentero1600 nausea vomiting stomach block repel shade allergy /*
	*/ sorethroat cough runnynose eyeinfection cut rash watertime hcresp sorebase rashbase cutbase eyebase earbase earache wateryeyes cold risk water30 water45 water60

	if "`indicator'"=="pcr" {
		local indvar avgdyenteropcr
		}
		
		
	if "`indicator'"=="cfu" {
		local indvar avgdyentero1600
		
		}



	local bs "\"

	local rootdir "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\ChildAnalysis\Results\"
	*local age `agegroup'
	*local sub `subset'
	*local age `bs'`age'
	local workdir `rootdir'`bs'`agegroup'`bs'`subset'`bs'`indicator'

	*check if directory exists, if not create it

	capture cd "`workdir'"
	if _rc~=0 {
		shell mkdir "`workdir'"
		}
		
	 

	cd "`workdir'"




	*define excel file
	local fname `illness'`agegroup'`subset'`indicator'.xlsx

	*subset and define data source

	*drop venfest
	drop if venfest==1

	*define swim exposures
	local swimexposures anycontact bodycontact swallwater water30 water45 water60


	if "`illness'"=="gi" {
		local illvars hcgi diarrhea nausea vomiting stomach
		local covars rawfood  dig  anim_any racecat sex stdtemp precip age algae  gicontact_base
		keep if gibase~=1 & vomitbase~=1
		
			}
			
	if "`illness'"=="severegi" {
		local illvars severegi
		local covars rawfood  dig  anim_any racecat sex stdtemp precip age algae  gicontact_base
		keep if gibase~=1 & vomitbase~=1
		
			}


	if "`illness'"=="rash" {
		local illvars rash
		local covars  dig  anim_any racecat sex stdtemp precip age algae gicontact_base allergy repel
		keep if rashbase~=1 
		
			}		
			

	if "`illness'"=="cut" {
		local illvars cut
		local covars  dig  anim_any racecat sex stdtemp precip age algae gicontact_base allergy repel
		keep if cutbase~=1 
		
			}		
			

	if "`illness'"=="resp" {
		local illvars hcresp sorethroat cough cold
		local covars  dig  anim_any racecat sex stdtemp precip age algae gicontact_base allergy repel
		keep if sorebase~=1 
		
			}
		
	if "`subset'"=="risk" {

		keep if risk==1
		
		}
		
	if "`subset'"=="risknotropical" {

		keep if risk==1
		drop if beachg==1
		
		}
		
		
	if "`subset'"=="notropical" {

		drop if beachg==1
		
		}
			
		
	if "`subset'"=="neearall" {

		drop if  inlist(beachg, 1, 3, 9, 8)
		
		}
			
	if "`subset'"=="neearps" {

		drop if  inlist(beachg, 1, 3, 9, 8, 11)
		
		}
			
	if "`subset'"=="neearcore" {

		drop if  inlist(beachg, 1, 2, 3, 9, 8, 11)
		
		}
			
	if "`subset'"=="nonhuman" {

		keep if risk==0
		
		}
			
	if "`agegroup'"=="age10" {

		keep if age<=10

	}
		
		
	if "`agegroup'"=="age12" {

		keep if age<=12

	}
			
	if "`agegroup'"=="age8" {

		keep if age<=8

	}

	if "`agegroup'"=="age6" {

		keep if age<=6

	}
		

	if "`agegroup'"=="age4" {

		keep if age<=4

	}
	
	if "`agegroup'"=="age13up" {

		keep if age>12 & !missing(age)

	}
	
		if "`agegroup'"=="age18up" {

		keep if age>17 & !missing(age)

	}
	
	if "`agegroup'"=="age610" {

		keep if age>=6 & age<=10

	}
	
	if "`agegroup'"=="age612" {

		keep if age>=6 & age<=12

	}
	
	if "`agegroup'"=="age412" {

		keep if age>=4 & age<=12

	}

	if "`agegroup'"=="age410" {

		keep if age>=4 & age<=10

	}
	
	
		
	
			
		*run models
		
		
	
	foreach ill of varlist `illvars' {
		foreach swim of varlist `swimexposures' {
		
			putexcel set `fname', sheet(`ill' `swim') modify
		
			putexcel C1="Coef." D1="Lower CI" E1="Upper CI" F1="p-value" G1="N" H1="AIC" I1="command" 

			selectaic logistic if `swim'==1, outcome(`ill') exposure(`indvar') covar(`covars') keepvar(`keep') stat(AIC) options(vce(cluster hhid))
			*logistic `gi' avgdyenterocfu `gicovars' i.beachg if gibase~=1 & vomitbase~=1 & swallwater==1 
			local newcov=r(covarlist)
			
			if "`newcov'"=="." {
				local newcov=""
			}
			
			
			logistic `ill' `indvar'  `newcov' `keep' if `swim'==1, vce(cluster hhid)
			
			matrix table = r(table)
			matrix b = table[1, 1...]'
			matrix p = table[4, 1...]'
			matrix ll = table[5, 1...]'
			matrix ul = table[6, 1...]'
			
			local aic=-2*`e(ll)'+2*`e(rank)'

			putexcel A2=matrix(b), rownames
			putexcel F2=matrix(p)
			putexcel D2=matrix(ll)
			putexcel E2=matrix(ul)
			putexcel G2=`e(N)'
			putexcel H2=`aic'
			putexcel I2="`e(cmdline)'"


		}

	}


end


capture clear

/*

**qcpr
*gi all sites
allchildmodels, illness(gi) subset(allsites) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age12) indicator(pcr) keep(i.beachg)

*severegi all sites
allchildmodels, illness(severegi) subset(allsites) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age12) indicator(pcr) keep(i.beachg)



*gi high risk
allchildmodels, illness(gi) subset(risk) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age12) indicator(pcr) keep(i.beachg)


*severegi high risk
allchildmodels, illness(severegi) subset(risk) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age12) indicator(pcr) keep(i.beachg)


*gi high risk no tropical
allchildmodels, illness(gi) subset(risknotropical) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age4) indicator(pcr) keep(i.beachg)



*severegi high risk no tropical
allchildmodels, illness(severegi) subset(risknotropical) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risknotropical) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risknotropical) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risknotropical) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risknotropical) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(risknotropical) agegroup(age4) indicator(pcr) keep(i.beachg)



*neear all
allchildmodels, illness(gi) subset(neearall) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age4) indicator(pcr) keep(i.beachg)


*severegi neearall
allchildmodels, illness(severegi) subset(neearall) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearall) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearall) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearall) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearall) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearall) agegroup(age4) indicator(pcr) keep(i.beachg)




*neear point source
allchildmodels, illness(gi) subset(neearps) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age4) indicator(pcr) keep(i.beachg)

*severegi neear point source
allchildmodels, illness(severegi) subset(neearps) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearps) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearps) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearps) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearps) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearps) agegroup(age4) indicator(pcr) keep(i.beachg)


*neear core
allchildmodels, illness(gi) subset(neearcore) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age4) indicator(pcr) keep(i.beachg)


*severegi neear core
allchildmodels, illness(severegi) subset(neearcore) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearcore) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearcore) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearcore) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearcore) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(severegi) subset(neearcore) agegroup(age4) indicator(pcr) keep(i.beachg)


**cfu
*gi all sites
allchildmodels, illness(gi) subset(allsites) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(allsites) agegroup(age12) indicator(cfu) keep(i.beachg)


*severegi cfu all sites
allchildmodels, illness(severegi) subset(allsites) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(allsites) agegroup(age12) indicator(cfu) keep(i.beachg)

*gi high risk
allchildmodels, illness(gi) subset(risk) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risk) agegroup(age12) indicator(cfu) keep(i.beachg)

*severegi cfu high risk
allchildmodels, illness(severegi) subset(risk) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(severegi) subset(risk) agegroup(age12) indicator(cfu) keep(i.beachg)



*gi high risk no tropical
allchildmodels, illness(gi) subset(risknotropical) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(risknotropical) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear all
allchildmodels, illness(gi) subset(neearall) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearall) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear point source
allchildmodels, illness(gi) subset(neearps) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearps) agegroup(age4) indicator(cfu) keep(i.beachg)


*neear core
allchildmodels, illness(gi) subset(neearcore) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(gi) subset(neearcore) agegroup(age4) indicator(cfu) keep(i.beachg)



**qcpr
*resp all sites
allchildmodels, illness(resp) subset(allsites) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age12) indicator(pcr) keep(i.beachg)

*resp high risk
allchildmodels, illness(resp) subset(risk) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age12) indicator(pcr) keep(i.beachg)

*resp high risk no tropical
allchildmodels, illness(resp) subset(risknotropical) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age4) indicator(pcr) keep(i.beachg)

*neear all
allchildmodels, illness(resp) subset(neearall) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age4) indicator(pcr) keep(i.beachg)

*neear point source
allchildmodels, illness(resp) subset(neearps) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age4) indicator(pcr) keep(i.beachg)


*neear core
allchildmodels, illness(resp) subset(neearcore) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age4) indicator(pcr) keep(i.beachg)


**cfu
*resp all sites
allchildmodels, illness(resp) subset(allsites) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age12) indicator(cfu) keep(i.beachg)

*resp high risk
allchildmodels, illness(resp) subset(risk) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age12) indicator(cfu) keep(i.beachg)

*resp high risk no tropical
allchildmodels, illness(resp) subset(risknotropical) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear all
allchildmodels, illness(resp) subset(neearall) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear point source
allchildmodels, illness(resp) subset(neearps) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age4) indicator(cfu) keep(i.beachg)


*neear core
allchildmodels, illness(resp) subset(neearcore) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age4) indicator(cfu) keep(i.beachg)



**cfu
*resp all sites
allchildmodels, illness(resp) subset(allsites) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age12) indicator(pcr) keep(i.beachg)

*resp high risk
allchildmodels, illness(resp) subset(risk) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age4) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age12) indicator(pcr) keep(i.beachg)

*resp high risk no tropical
allchildmodels, illness(resp) subset(risknotropical) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age4) indicator(pcr) keep(i.beachg)

*neear all
allchildmodels, illness(resp) subset(neearall) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age4) indicator(pcr) keep(i.beachg)

*neear point source
allchildmodels, illness(resp) subset(neearps) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age4) indicator(pcr) keep(i.beachg)


*neear core
allchildmodels, illness(resp) subset(neearcore) agegroup(allages) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age12) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age10) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age8) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age6) indicator(pcr) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age4) indicator(pcr) keep(i.beachg)


**cfu
*resp all sites
allchildmodels, illness(resp) subset(allsites) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(allsites) agegroup(age12) indicator(cfu) keep(i.beachg)

*resp high risk
allchildmodels, illness(resp) subset(risk) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age4) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risk) agegroup(age12) indicator(cfu) keep(i.beachg)

*resp high risk no tropical
allchildmodels, illness(resp) subset(risknotropical) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(risknotropical) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear all
allchildmodels, illness(resp) subset(neearall) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearall) agegroup(age4) indicator(cfu) keep(i.beachg)

*neear point source
allchildmodels, illness(resp) subset(neearps) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearps) agegroup(age4) indicator(cfu) keep(i.beachg)


*neear core
allchildmodels, illness(resp) subset(neearcore) agegroup(allages) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age12) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age10) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age8) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age6) indicator(cfu) keep(i.beachg)
allchildmodels, illness(resp) subset(neearcore) agegroup(age4) indicator(cfu) keep(i.beachg)

*/
