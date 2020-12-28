version 15

cd "C:\Users\Sarah\Epi510\Stata"
use vicpls2

//Labeling some variables from last HW //
label variable deldate "Delivery date (ddmonyyyy)"
label variable enrdate "Enrollment date (ddmonyyy)"
label variable daysbetween "days between enrollment & delivery"

//Creating categorical variable for momage & bw //
gen mom30plus = .
	replace mom30plus=0 if momage<30
		replace mom30plus=1 if momage>=30 & momage~=.
gen macrosomia = . 
	replace macrosomia=1 if bw >=4500 & bw~=.
		replace macrosomia=0 if bw<4500
gen belowhseduc = .
	replace belowhseduc=1 if grade<12
		replace belowhseduc=0 if grade>=12 & grade~=.
gen multpy = .
	replace multpy=1 if partyr>=2 & partyr ~=.
		replace multpy=0 if partyr<=1
gen eversmoke = .
	replace eversmoke=1 if cigs1>0 | cigs2>0 & cigs1~=. & cigs2~=.
		replace eversmoke=0 if cigs1==0 & cigs2==0

//adding label definitions and labels //
label variable mom30plus "Mom age exposure"
	la define l_mom30plus 1 "30+ (exposed)" 0 "Under 30 (unexposed)"
		label values mom30plus l_mom30plus
label variable macrosomia "Macrosomia status"
	label define l_macrosomia 1 "bw>=4500 (case)" 0 "bw<4500 (non-case)"
		label values macrosomia l_macrosomia
label variable belowhseduc "Education exposure" 
	label define l_belowhseduc 1 "below 12yrs education (exposed)" 0 "12+ education (unexposed)"
		label values belowhseduc l_belowhseduc
label variable multpy "Multiple sexual partners exposure"
	label define l_multpy 1 "more than one partner (exposed)" 0 "one or fewer (unexposed)"
		label values multpy l_multpy
label variable eversmoke "Smoking exposure status"
	label define l_eversmoke 1 "Ever smoked (exposed)" 0 "never smoked (unexposed)"
		label values eversmoke l_eversmoke

//Determine prevalences //
ta mom30plus
ta macrosomia
ta belowhseduc
ta multpy
ta eversmoke

// 2x2 table for association between being an older Mom and macrosomia //
cs macrosomia mom30plus

//analysis of effect modification //
cs macrosomia mom30plus, by(eversmoke)
cs macrosomia mom30plus, by(multpy)
cs macrosomia mom30plus, by(raceth)
cs macrosomia mom30plus, by(belowhseduc)

//stratify by smoking status for confouding analysis //
cs macrosomia mom30plus if eversmoke==0, by(raceth)
cs macrosomia mom30plus if eversmoke==1, by(raceth)

//stratify by smoking status & sex partners for confouding analysis //
cs macrosomia mom30plus if multpy==0, by(raceth)
cs macrosomia mom30plus if multpy==1, by(raceth)
