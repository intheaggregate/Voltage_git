* install stata + data

ssc install estout, replace

cd "statasets1"

use third_grade.dta, clear

* generate total scores

generate score_total = math + verb
label var score_total "Total test score"

* generate control indicators

generate small = 0
replace small = 1 if class_size < 20
label var small "Small class"

generate single = 0
replace single = 1 if class_size == school_enrollment
label var single "Single class"

* generate percentiles

xtile stpct = score_total, nq(10)
label var stpct "Total score percentile"

generate low_stpct = 0 
replace low_stpct = 1 if stpct == 1
label var low_stpct "Lowest total score percentile"

generate high_stpct = 0 
replace high_stpct = 1 if stpct == 10
label var stpct "Highest score percentile"

xtile mpct = math, nq(10)
label var mpct "Math score percentile"

generate low_mpct = 0 
replace low_mpct = 1 if mpct == 1
label var low_mpct "Lowest math percentile"

generate high_mpct = 0 
replace high_mpct = 1 if mpct == 9
label var mpct "Highest math percentile"

xtile vpct = verb, nq(10)
label var vpct "Verb score percentile"

generate low_vpct = 0 
replace low_vpct = 1 if vpct == 1
label var low_vpct "Lowest verb percentile"

generate high_vpct = 0 
replace high_vpct = 1 if vpct == 9
label var vpct "Highest verb percentile"

* correlations

correlate religious single
correlate religious small
correlate religious ses_index
correlate religious boy

correlate score_total single
correlate score_total small
correlate score_total ses_index
correlate score_total boy

correlate math verb

* ols regressions 

cd ..

regress score_total religious, robust
estimates store stm1
regress score_total religious ses_index boy, robust
estimates store stm2
regress score_total religious ses_index boy small single, robust
estimates store stm3
esttab stm1 stm2 stm3 using r1.tex, se title(Total test scores)

regress math religious, robust
estimates store mm1
regress math religious ses_index boy, robust
estimates store mm2
regress math religious ses_index boy small single, robust
estimates store mm3
esttab mm1 mm2 mm3 using r2.tex, se title(Math test scores)

regress verb religious, robust
estimates store vm1
regress verb religious ses_index boy, robust
estimates store vm2
regress verb religious ses_index boy small single, robust
estimates store vm3
esttab vm1 vm2 vm3 using r3.tex, se title(Verbal test scores)

* logit regressions

logit low_stpct religious, robust
estimates store lm1
logit low_stpct religious ses_index boy, robust
estimates store lm2
logit low_stpct religious ses_index boy small single, robust
estimates store lm3
esttab lm1 lm2 lm3 using l1.tex, se title(Bottom-decile scores)

logit high_stpct religious, robust
estimates store hm1
logit high_stpct religious ses_index boy, robust
estimates store hm2
logit high_stpct religious ses_index boy small single, robust
estimates store hm3
esttab hm1 hm2 hm3 using l2.tex, se title(Top-decile scores)

logit low_mpct religious, robust
logit low_mpct religious ses_index boy, robust
logit low_mpct religious ses_index boy small single, robust

logit high_mpct religious, robust
logit high_mpct religious ses_index boy, robust
logit high_mpct religious ses_index boy small single, robust

logit low_vpct religious, robust
logit low_vpct religious ses_index boy, robust
logit low_vpct religious ses_index boy small single, robust

logit high_vpct religious, robust
logit high_vpct religious ses_index boy, robust
logit high_vpct religious ses_index boy small single, robust

* percentage 

preserve

collapse (mean) score_total, by(religious)

restore