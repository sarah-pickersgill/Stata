version 15

cd "C:\Users\Sarah\Epi510\Stata"
use vipcls

/// Labeling all variables ///
label variable patid "Patient ID"
label variable delmo "Delivery Month"
label variable deldy "Delivery Day"
label variable delyr "Delivery Year"
label variable enrmo "Enrollment Month"
label variable enrdy "Enrollment Day"
label variable enryr "Enrollment Year"
label variable momage "Mother's Age"
label variable raceth "Mother's Race/Ethnicity"
label variable grade "Mother's Education (years)"
label variable marstat "Mother's marital status"
label variable cigs1 "Mother's smoking, 1st trimester (cigs/days)"
label variable cigs2 "Mother's smoking, 2nd trimester (cigs/days)"
label variable etoh1 "Mother's alcohol intake, 1st trimester"
label variable etoh2 "Mother's alcohol intake, 2nd trimester"
label variable partyr "Number of sexual partners last year"
label variable pregnum "Number of pregnancies"
label variable delges "Gestational age at delivery"
label variable bw "Birth weight"
label variable deltype "Delivery Method"
label variable induclab "Induction of labor"
label variable auglab "Augmentation of labor"
label variable intrapih "Gestational hypertension"


///Label definitions///
label define l_raceth 0 white 1 hispanic 2 black
	label values raceth l_raceth
label define l_marstat 1 married 2 separated 3 divorced 4 widowed 5 "never married
	label values marstat l_marstat
label define l_alcohol 1 "every day" 2 "3-5/week" 3 "one/week" 4 "<one/week" 5 "<one/month" 6 never
	label values etoh1 l_alcohol
		label values etoh2 l_alcohol
label define l_deltype 1 vaginal 2 cesarean
	label values deltype l_deltype
label define l_yesno 1 yes 2 no
	label values induclab l_yesno
		label values auglab l_yesno
			label values intrapih l_yesno

///Changing implausible values to -1 ///
recode momage 15 = -1
recode partyr 200 = -1
recode delges (51/max = -1)
	
///Missing Data: changing all -1 values to (.) ///
recode _all (-1 = .)

///Summary table for all variables///
tabstat patid delmo deldy delyr enrmo enrdy enryr momage raceth gra marstat cigs1 cigs2 etoh1 etoh2 partyr pregnum delges bw deltype induclab auglab intrapih, stats(n mean min max) columns(statistics)

save vicpls1, replace
