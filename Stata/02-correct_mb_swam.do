*correct MB swam variable- swam recoded to anycontact


use "L:\Lab\Nheerl_HSF_Beaches\Tim\Rec_Water\san diego\Jack\mb_analysis_final.dta", clear
drop if catiyn~=1
drop swam
gen swam=cond(sw1a_b==1 | sw1b_b==1 | sw1c_b==1 | sw1d_b==1 | sw2a_b==1, 1, 0)
replace swam=. if missing(sw1) & missing(sw1b_a) & missing(sw1c_a) & missing(sw1d_a) & missing(sw2a_a)
keep beach sdate fullid hhid swam 

save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\California Beaches\mb_swam_correct.dta", clear
