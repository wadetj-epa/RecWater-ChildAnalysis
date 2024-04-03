*see R programs 01-pre-WeatherforCABeaches.R

import delimited using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\California Beaches\CAbeachesWeather_corrected.csv", clear varnames(1)
qui bysort beach date: gen count=_N
tab count

*drop if report_type=="SOM" & count==2
*drop count

*qui bysort beach date: gen count=_N

keep beach date dailyaveragedrybulbtemperature  dailyaveragewindspeed dailyprecipitation lag1_ppt

foreach var of varlist _all {
	replace `var'="." if `var'=="NA"
}

foreach var of varlist dailyaveragedrybulbtemperature  dailyaveragewindspeed dailyprecipitation lag1_ppt {
	destring `var', replace force
}


gen stdate=substr(date, 1, 10)
gen stdate2=date(stdate, "YMD")

format stdate2 %td

drop date stdate
rename stdate2 date
gen intdate=date

replace beach="Doheny" if beach=="Doheny  Beach"


*gen beach variable for merging
gen beachg=1 if beach=="Avalon"
replace beachg=3 if beach=="Doheny"
replace beachg=8 if beach=="Malibu"
replace beachg=9 if beach=="Mission Bay"

drop count*

*corrected weather has few missing
/*
  +--------------------------------------------+
  |                                  # missing |
  |--------------------------------------------|
  | dailyaveragedrybulbtemperature           1 |
  |             dailyprecipitation           2 |
  |          dailyaveragewindspeed           4 |
  |                       lag1_ppt           3 |
*/


*replace missing values with previous non missing 

bys beach: replace dailyprecipitation = dailyprecipitation[_n-1] if dailyprecipitation >= .
bys beach: replace dailyaveragedrybulbtemperature = dailyaveragedrybulbtemperature[_n-1] if dailyaveragedrybulbtemperature >= .
bys beach: replace dailyaveragewindspeed = dailyaveragewindspeed[_n-1] if dailyaveragewindspeed >= .
bys beach: replace lag1_ppt = lag1_ppt[_n-1] if lag1_ppt >= .

save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recweather.dta", replace

clear

*use epi data to get dates
use "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recwaterepi.dta"

keep beachg intdate meanairtemp rain8
qui bysort beachg intdate: keep if _n==1


merge 1:1 beachg intdate using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recweather.dta"

drop if _merge==2



*convert to C

gen tempdrybulbC= (dailyaveragedrybulbtemperature-32)* 5/9


*list tempdrybulbC if beachg==1
gen temp=meanairtemp
replace temp= tempdrybulbC if missing(temp)
*table beachg, c(min temp mean temp max temp)
table beachg, stat(min temp) stat(mean temp) stat(max temp)

capture drop stdtemp 
gen stdtemp=.
*generate standardized temp by beach
forvalues i=1(1)13 {

	qui sum temp if beachg==`i'
	local m=r(mean)
	local s=r(sd)
	
	replace stdtemp=(temp-`m')/`s' if beachg==`i'
	
	}
	
	

	
gen precip=rain8
replace precip=lag1_ppt if missing(rain8)
keep beachg intdate temp precip stdtemp

*fill in final missing precip with mean for beach

forvalues i=1(1)13 {

	qui sum precip if beachg==`i'
	local m=r(mean)
	
	replace precip=`m' if missing(precip) & beachg==`i'
	
	}
	
	

save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\weather.dta", replace




/*
  definition
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

   variables:  beachg
*/
