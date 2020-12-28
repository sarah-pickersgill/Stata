version 15

cd "C:\Users\Sarah\Epi510\Stata"
import sasxport LLCP2017.XPT
save brfss2017.dta

//Restrict data to WA state //
keep if _state==53

// Set survey weights //
svyset _psu [pweight=_llcpwt]

//label variables//
do Stata_hmwk5_labels.do

save brfss2017.dta, replace
clear

use _ment14d _race _age_g _educag _incomg _rfsmok3 _curecig pa1vigm_ _pacat1 _psu _llcpwt using brfss2017.dta

//recode variables for don’t know/refused/missing values to (.) //
recode _ment14d 9=.
recode _race 9=.
recode _educag 9=.
recode _incomg 9=.
recode _rfsmok3 9=.
recode _curecig 9=.
recode _pacat 9=.

//Describe mental health by activity level //
svy: tab _pacat1 _ment14d, row obs ci percent
	svy:mean pa1vigm_ if _ment14d==1
		svy:mean pa1vigm_ if _ment14d==3
		
//Prep data set .. create binary variables //
gen mh14 = . 
	replace mh14=0 if _ment14d==1 | _ment14d==2
		replace mh14=1 if _ment14d==3

la var mh14 "Over 14 days poor mental health"
la def l_mh 1 "Over 14 days"  0 "Less than 14 days"
la val mh14 l_mh
		
gen active = .
	replace active=0 if pa1vigm==0
		replace active=1 if pa1vigm_>0 & pa1vigm~=.

la var active "Any vigorous activity"
la def l_active 1 "Some vigorous activity"  0 "Zero vigorous activity"
la val active l_active

// Crude risk estimate //
svy: logistic mh active
svy: tab mh active, obs percent ci

svy: tabodds mh active

//Checking for confounders //
svy: logistic mh active i._race
svy: logistic mh active i._age_g
svy: logistic mh active i._incomg
svy: logistic mh active i._educag
svy: logistic mh active i._rfsmok3
svy: logistic mh active i._curecig

//Adjusting for age, income, and education //

svy: logistic mh active i._age_g _educag _incomg


//Create education categorical variable //
gen educ =.
	replace educ=0 if _educag==1
		replace educ=1 if _educag==2 | _educag==3
			replace educ=2 if _educag==4
			
la var educ "Education"
la def l_ed 0 "Did not grad hs"  1 "HS grad or some college/tech school" 2 "College/tech school grad"
la val educ l_ed

//linear regression for physical activity~education//
//xi: [regression command] [outcome] i.[predictor]//

xi: regress pa1vigm_ i.educ


