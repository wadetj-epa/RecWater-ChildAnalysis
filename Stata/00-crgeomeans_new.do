*creates daily geometric means for BB and MB and merges to core neear sites

clear
use "L:\Lab\Nheerl_HSF_Beaches\Tim\Rec_Water\EPA_Studies\data\2009\water_quality\PCR_Entero_baba\censor_half\enteropcr_baba_bb_day_half.dta"
rename labs date
rename m_l10count log10mean_epcr
gen beach="BB"
tempfile bbpcr
save `bbpcr'

use "L:\Lab\Nheerl_HSF_Beaches\Tim\Rec_Water\EPA_Studies\data\2009\water_quality\entero1600\entero1600_bb_dy.dta"
rename labs date
rename m_l10count log10mean_cfu
gen beach="BB"
tempfile bbcfu
save `bbcfu'
use  "L:\Lab\Nheerl_HSF_Beaches\Tim\Rec_Water\EPA_Studies\data\2009\water_quality\PCR_Entero_baba\censor_half\enteropcr_baba_mb_day_half.dta", clear
rename labs date
rename m_l10count log10mean_epcr
gen beach="MB"
tempfile mbpcr
save `mbpcr'

use "L:\Lab\Nheerl_HSF_Beaches\Tim\Rec_Water\EPA_Studies\data\2009\water_quality\entero1600\entero1600_mb_dy.dta", clear
rename labs date
rename m_l10count log10mean_cfu
gen beach="MB"
tempfile mbcfu
drop  m_l10count_d1 m_l10count_d2

merge 1:1 beach date using `mbpcr'
drop  m_l10count_d1 m_l10count_d2 _merge
tempfile mb
save `mb'

clear
use `bbpcr'
drop  m_l10count_d1 m_l10count_d2
merge 1:1 beach date using `bbcfu'
drop  m_l10count_d1 m_l10count_d2 _merge

append using `mb'

gen stdate=date(date, "YMD")
format stdate %dN/D/CY

tostring stdate, gen(strdate) usedisplayformat force

gen marine=1
gen geomean_epcr=10^log10mean_epcr
gen geomean_cfu=10^log10mean_cfu
drop date
rename stdate date


tempfile bbmb
save `bbmb'



use "L:/Lab/Nheerl_HSF_Beaches/Tim/Rec_Water/EPA_Studies/data/PublicDatasets/geomeans_entero.dta",clear
append using `bbmb'


save "C:\Users\twade\OneDrive - Environmental Protection Agency (EPA)\Rec_Water\geomeans_entero_new.dta"






