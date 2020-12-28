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

//recoding to 0/1 //
recode deltype 1 = 0
recode deltype 2 = 1

recode intrapih 2 = 0
recode induclab 2= 0

///Label definitions///
label define l_raceth 0 white 1 hispanic 2 black
	label values raceth l_raceth
label define l_marstat 1 married 2 separated 3 divorced 4 widowed 5 "never married
	label values marstat l_marstat
label define l_alcohol 1 "every day" 2 "3-5/week" 3 "one/week" 4 "<one/week" 5 "<one/month" 6 never
	label values etoh1 l_alcohol
		label values etoh2 l_alcohol
label define l_deltype 0 vaginal 1 cesarean
	label values deltype l_deltype
label define l_yesno 1 yes 0 no
	label values induclab l_yesno
		label values auglab l_yesno
			
label define l_intrapih 1 yes 0 no
	label values intrapih l_intrapih
	
			
///Changing implausible values to -1 ///
recode momage 15 = -1
recode delges (53/max = -1)
recode bw (299/min = -1)
recode bw (6000/max = -1)
	
///Missing Data: changing all -1 values to (.) ///
recode _all (-1 = .)

///Summary table for all variables///
tabstat patid delmo deldy delyr enrmo enrdy enryr momage raceth gra marstat cigs1 cigs2 etoh1 etoh2 partyr pregnum delges bw deltype induclab auglab intrapih, stats(n mean min max) columns(statistics)

///Recoding variables as categorical ///
gen momcatage=.
	replace momcatage=1 if momage<=19
		replace momcatage=2 if momage>=20 & momage<=29
			replace momcatage=3 if momage>=30 & momage~=.
gen gradecat=.
	replace gradecat=1 if grade<=12
		replace gradecat=0 if grade>=13 & grade~=.
		
gen marstatcat=.
	replace marstatcat=1 if marstat==1
		replace marstatcat=2 if marstat>=2 & marstat<=4
			replace marstatcat=3 if marstat==5 & marstat~=.
		
gen partyrcat =.
	replace partyrcat=0 if partyr<=1
		replace partyrcat=1 if partyr>=2 & partyr~=.

gen pregnumcat=.
	replace pregnumcat=0 if pregnum==1
		replace pregnumcat=1 if pregnum>=2 & pregnum~=.

gen delgescat=.
	replace delgescat=1 if delges<37
		replace delgescat=2 if delges>=37 & delges<=42
			replace delgescat=3 if delges>=43 & delges~=.

gen bwcat=.
	replace bwcat=1 if bw<1500
		replace bwcat=2 if bw>=1500 & bw<=2499
			replace bwcat=3 if bw>=2500 & bw<=3999
				replace bwcat=4 if bw>=4000 & bw~=.

gen smokecat=.
	replace smokecat=0 if cigs1==0 & cigs2==0
		replace smokecat=1 if cigs1>0 & cigs1~=. & cigs2==0
			replace smokecat=2 if cigs2>0 & cigs2~=. & cigs1==0
				replace smokecat=3 if cigs1>0 & cigs1~=. & cigs2>0 &cigs2~=.
	
gen etohcat=.
	replace etohcat=0 if etoh1==6 & etoh1~=. & etoh2==6 & etoh2~=.
		replace etohcat=1 if etoh1<6 & etoh2==6 & etoh2~=.
			replace etohcat=2 if etoh2<6 & etoh1==6 & etoh1~=.
				replace etohcat=3 if etoh1 <6 & etoh2<6

gen studyclinic=.
	replace studyclinic=1 if patid >=1000000 & patid<=1999999
		replace studyclinic=3 if patid>=3000000 & patid<=3999999
			replace studyclinic=5 if patid>=5000000 & patid<=5999999
				replace studyclinic=6 if patid>=6000000 & patid<=6999999
					replace studyclinic=7 if patid>=7000000 & patid<=7999999
						replace studyclinic=8 if patid>=8000000 & patid<=8999999
							replace studyclinic=9 if patid>=9000000 & patid<=9999999
					
					
//Relabeling categorical variables //
label variable momcatage "Mother's Age (categorical)"
	la define l_momcatage 1 "<=19" 2 "20-29" 3 "30+"
		label values momcatage l_momcatage
label variable gradecat "Mother's Education (categorical)"
	la define l_gradecat 0 "12 or fewer years" 1 "13 or more years"
		label values gradecat l_gradecat
label variable marstatcat "Marital status (categorical)"
	la define l_marstatcat 1 "married" 2 "previously married" 3 "never married"
		label values marstatcat l_marstatcat
label variable partyrcat "# of sexual partners last year (categorical)"
	la define l_partyrcat 0 "one" 1 "two or more"
		label values partyrcat l_partyrcat
label variable pregnumcat "Number of pregnancies (categorical)"
		label values pregnumcat l_partyrcat
label variable delgescat "Gestational age at delivery (categorical)"
	la define l_delgescat 1 "less than 37 weeks" 2 "between 37-42 weeks" 3 "43+ weeks"
		label values delgescat l_delgescat
label variable bwcat "Birthweight (categorical)"
	la define l_bwcat 1 "less than 1500 g" 2 "between 1500-2499 g" 3 "between 2500-3999 g" 4 "4000+ grams"
		label values bwcat l_bwcat
label variable smokecat "smoking status (categorical)"
	la define l_smokecat 0 "never smoked" 1 "first trimester smoking only" 2 "second trimester smoking only" 3 "smoking both trimesters"
		label values smokecat l_smokecat
label variable etohcat "Mother's alcohol intake (categorical)"
	la define l_etohcat 0 "never drinks" 1 "drinks only in first trimester" 2 "drinks only in second trimester" 3 "drinks in both trimesters"
		label values etohcat l_etohcat
label variable studyclinic "Study Clinic"
	la define l_studyclinic 1 "Olympia" 3 "Everett" 5 "Seattle" 6 "Bellingham" 7 "Spokane" 8 "Bellevue" 9 "Tacoma"
		label values studyclinic l_studyclinic

/// HW3Q2 tabulate new variables to obtain frequencies ///
ta momcatage
ta gradecat
ta marstatcat
ta partyrcat
ta pregnumcat
ta delgescat
ta bwcat
ta smokecat
ta etohcat
ta studyclinic
	
//create 2x2 table for associatin btw sexual partners and pregnum //
cs pregnumcat partyrcat 

cc partyrcat pregnumcat

// creating date variables //
gen deldate=mdy(delmo, deldy, delyr)
	format deldate %d

gen enrdate=mdy(enrmo, enrdy, enryr)
	format enrdate %d

gen daysbetween=deldate-enrdate

// reset implausible values//
recode daysbetween -18 = .

//create new variable for preterm delivery //
gen delgesbin=.
	replace delgesbin=1 if delges<37
		replace delgesbin=0 if delges>=37 & delges~=.
label variable delgesbin "Preterm delivery"
	la define l_delgesbin 1 "<37 weeks" 0 "37+ weeks"
		label values delgesbin l_delgesbin
	
/// Save data file ///
save vicpls2, replace
