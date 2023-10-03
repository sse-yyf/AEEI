clear all

set seed 123

*** SET GLOBAL OF ALL COVARIATES ***
global MAIN			"female black hispanic othrace dep q1-q6 recall agelt35 agegt54 durable nondurable husd loc_10404-loc_10880"
global SECORDER		"*X*"
global ALLCOV		"$MAIN $SECORDER"

*********************************************************************************
***                       CROSS-FIT PARTIALING OUT                            ***
*********************************************************************************
eststo clear
use "../input/cleaneddata.dta", clear	

*** Plugin-formula ***
eststo a1: xporegress loginuidur treatment, controls($ALLCOV) sel(plugin)  ///
				   cluster(abdt) xfold(5) resample(10) 
lassoinfo, each
mat B1 = r(table)
esttab matrix(B1) using "../outcome/LassoPFinfo.tex", replace nomtitles label

lassocoef (.,for(loginuidur) xfold(3) resample(5)) ///
		  (.,for(treatment) xfold(3) resample(5))
mat C1 = r(coef)
esttab matrix(C1) using "../outcome/LassoPFreg.tex", replace nomtitles label


*** Always select, plugin-formula ***
eststo a2: xporegress loginuidur treatment, controls(($MAIN) $SECORDER)  ///
					  sel(plugin) cluster(abdt) xfold(5) resample(10)
					  
lassoinfo, each
mat B2 = r(table)
esttab matrix(B2) using "../outcome/LassoPFinfo-AS.tex", replace nomtitles label

lassocoef (.,for(loginuidur) xfold(3) resample(5)) ///
		  (.,for(treatment) xfold(3) resample(5))
mat C2 = r(coef)
esttab matrix(C2) using "../outcome/LassoPFreg-AS.tex", replace nomtitles label
		 
		 
*** Cross-validation ***
eststo a3: xporegress loginuidur treatment, controls($ALLCOV) sel(cv) ///
				   cluster(abdt) xfold(5) resample(10)
lassoinfo, each
mat B3 = r(table)
esttab matrix(B3) using "../outcome/LassoCVinfo.tex", replace nomtitles label

lassocoef (.,for(loginuidur) xfold(3) resample(5)) ///
		  (.,for(treatment) xfold(3) resample(5))
mat C3 = r(coef)
esttab matrix(C3) using "../outcome/LassoCVreg.tex", replace nomtitles label

*** Consolidating coefficients into one table ***
esttab a1 a2 a3 using "../outcome/outcomes.tex", replace se nomtitles label 
			