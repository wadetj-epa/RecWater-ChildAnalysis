

import delimited using "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\CAbeachesWeather.csv", clear
qui bysort beach date: gen count=_N
*drop if report_type=="SOM" & count==2
*drop count

*qui bysort beach date: gen count=_N

keep beach date dailyaveragedrybulbtemperature  dailyaveragewindspeed dailyprecipitation lag1_ppt


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


qui bysort beachg date: gen count2=_N
*drop if missing(dailyaveragedrybulbtemperature) & count2>1
*qui bysort beachg date: gen count3=_N
*tab count3

drop count*


*replace missing values with previous non missing for precipitation and temp

sort beachg intdate
*gen otemp=dailyaveragedrybulbtemperature

bys beach: replace dailyaveragedrybulbtemperature = dailyaveragedrybulbtemperature[_n-1] if dailyaveragedrybulbtemperature >= .

*gen oppt=dailyprecipitation

bys beach: replace dailyprecipitation = dailyprecipitation[_n-1] if dailyprecipitation >= .

bys beach: replace lag1_ppt = lag1_ppt[_n-1] if lag1_ppt >= .

save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\recweather.dta", replace

clear

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
table beachg, c(min temp mean temp max temp)

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
